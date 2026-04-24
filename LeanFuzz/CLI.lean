import LeanFuzz.Gen
import LeanFuzz.Arb
import LeanFuzz.Target
import LeanFuzz.Config
import LeanFuzz.Grammar
import LeanFuzz.Generate
import LeanFuzz.Validate
import LeanFuzz.Export
import LeanFuzz.Pretty

namespace LeanFuzz

-- ============================================================
-- Help text
-- ============================================================

private def helpText : String :=
  "LeanFuzz \u2014 fuzzing library for Lean 4

USAGE
  lake exe <name> [MODE] [FLAGS]

MODES
  (default)           Standalone fuzzing (random inputs, catch crashes)
  --afl               AFL++ mode: read one input from stdin
  --replay <file>     Replay a crash file
  --setup-afl         Generate AFL++ integration scripts in ./fuzz/
  --dump-grammar <fmt> Dump extracted grammar (json, afl, or text)
  --help              Show this help

FLAGS
  --count <n>         Number of iterations in standalone mode (default: 10000)
  --verbose           Print all crashes, not just first 10
  --seed <n>          RNG seed for standalone mode

QUICK START
  1. Add lean-fuzz to your lakefile.toml:

     [[require]]
     name = \"lean-fuzz\"
     git  = \"https://github.com/<user>/lean-fuzz\"
     rev  = \"main\"

     [[lean_exe]]
     name = \"fuzz\"
     root = \"Fuzz\"

  2. Create Fuzz.lean:

     import LeanFuzz

     def target : LeanFuzz.FuzzTarget := {
       run := fun bytes => do
         let input := String.fromUTF8? bytes |>.getD \"\"
         let _ := MyLib.process input
     }

     def main (args : List String) : IO Unit :=
       LeanFuzz.fuzz target args

  3. Run:

     lake exe fuzz                  # standalone: 10000 random inputs
     lake exe fuzz --count 50000   # more iterations
     lake exe fuzz --setup-afl     # generate AFL++ scripts
     ./fuzz/run-afl.sh             # coverage-guided fuzzing"

-- ============================================================
-- Arg parsing
-- ============================================================

private structure ParsedArgs where
  mode : String := "standalone"
  replayFile : Option String := none
  countOverride : Option Nat := none
  seedOverride : Option UInt64 := none
  verbose : Bool := false
  dumpFormat : Option String := none

private partial def parseArgs : List String → ParsedArgs → ParsedArgs
  | [], r => r
  | "--help" :: rest, r => parseArgs rest { r with mode := "help" }
  | "--afl" :: rest, r => parseArgs rest { r with mode := "afl" }
  | "--setup-afl" :: rest, r => parseArgs rest { r with mode := "setup-afl" }
  | "--dump-grammar" :: "json" :: rest, r =>
    parseArgs rest { r with mode := "dump-grammar", dumpFormat := some "json" }
  | "--dump-grammar" :: "text" :: rest, r =>
    parseArgs rest { r with mode := "dump-grammar", dumpFormat := some "text" }
  | "--dump-grammar" :: "afl" :: rest, r =>
    parseArgs rest { r with mode := "dump-grammar", dumpFormat := some "afl" }
  | "--dump-grammar" :: rest, r =>
    parseArgs rest { r with mode := "dump-grammar", dumpFormat := some "json" }
  | "--replay" :: path :: rest, r =>
    parseArgs rest { r with mode := "replay", replayFile := some path }
  | "--count" :: n :: rest, r => parseArgs rest { r with countOverride := n.toNat? }
  | "--seed" :: n :: rest, r =>
    parseArgs rest { r with seedOverride := n.toNat?.map fun v => UInt64.ofNat v }
  | "--verbose" :: rest, r => parseArgs rest { r with verbose := true }
  | _ :: rest, r => parseArgs rest r

-- ============================================================
-- Runners
-- ============================================================

private def generateInput (iteration : Nat) (sizeMin sizeMax : Nat) : ByteArray :=
  let seed := (iteration.toUInt64 + 1) * 6364136223846793005 + 1442695040888963407
  let size := sizeMin + (seed.toNat % (sizeMax - sizeMin + 1))
  ByteArray.mk ((List.range size).map fun j =>
    let s := seed * (j.toUInt64 + 1) * 2862933555777941757 + 1013904223
    (s >>> 56).toUInt8).toArray

private def runStandalone (target : FuzzTarget) (config : FuzzConfig) : IO Unit := do
  let iterations := config.iterations
  let (sizeMin, sizeMax) := config.inputSizeRange
  let mut crashes := 0
  IO.println s!"LeanFuzz: fuzzing \"{target.name}\" ({iterations} iterations)"
  for i in List.range iterations do
    let buf := generateInput i sizeMin sizeMax
    try
      target.run buf
    catch e =>
      crashes := crashes + 1
      if config.verbose || crashes <= 10 then
        IO.println s!"  CRASH [{i}]: {e.toString}"
      IO.FS.createDirAll "fuzz/crashes"
      IO.FS.writeBinFile s!"fuzz/crashes/crash-{i}" buf
    if (i + 1) % 1000 == 0 then
      IO.println s!"  {i + 1}/{iterations} ({crashes} crashes)"
  IO.println s!"\nDone: {iterations} iterations, {crashes} crashes"
  if crashes > 0 then
    IO.println s!"Crash inputs saved to fuzz/crashes/"

private def runAfl (target : FuzzTarget) : IO Unit := do
  let bytes ← IO.getStdin >>= (·.readBinToEnd)
  if bytes.size == 0 then return
  target.run bytes

private def runReplay (target : FuzzTarget) (path : String) : IO Unit := do
  let bytes ← IO.FS.readBinFile path
  IO.println s!"Replaying {bytes.size} bytes from {path}..."
  try
    target.run bytes
    IO.println "OK \u2014 no crash"
  catch e =>
    IO.println s!"CRASH: {e.toString}"

-- ============================================================
-- AFL++ setup
-- ============================================================

private def aflScriptContent (timeoutMs : Nat) : String :=
  ("#!/usr/bin/env bash
set -euo pipefail

# LeanFuzz AFL++ runner
# Generated by: lake exe <name> --setup-afl
#
# Usage:
#   ./fuzz/run-afl.sh [--run-only]
#
# Environment variables:
#   LEAN_FUZZ_EXE     Binary name (default: fuzz)
#   AFL_TIMEOUT       Per-input timeout in ms (default: __TIMEOUT__)
#
# Prerequisites:
#   macOS: brew install aflplusplus
#   Linux: apt install afl++

PROJECT_ROOT=\"$(cd \"$(dirname \"$0\")/..\" && pwd)\"
BINARY_NAME=\"${LEAN_FUZZ_EXE:-fuzz}\"
BINARY=\"$PROJECT_ROOT/.lake/build/bin/$BINARY_NAME\"
CORPUS=\"$PROJECT_ROOT/fuzz/corpus\"
FINDINGS=\"$PROJECT_ROOT/fuzz/findings\"

RUN_ONLY=false
for arg in \"$@\"; do
    case \"$arg\" in
        --run-only) RUN_ONLY=true ;;
    esac
done

if ! command -v afl-fuzz >/dev/null 2>&1; then
    echo \"Error: afl-fuzz not found.\"
    if [ \"$(uname)\" = \"Darwin\" ]; then
        echo \"  macOS: brew install aflplusplus\"
    else
        echo \"  Linux: apt install afl++\"
    fi
    exit 1
fi

if [ \"$RUN_ONLY\" = false ]; then
    if ! command -v afl-clang-fast >/dev/null 2>&1; then
        echo \"Error: afl-clang-fast not found (needed for instrumented build)\"
        exit 1
    fi
    echo \"=== Building with AFL++ instrumentation ===\"
    cd \"$PROJECT_ROOT\"
    LEAN_CC=afl-clang-fast LEAN_CXX=afl-clang-fast++ lake build \"$BINARY_NAME\"
    echo \"\"
fi

mkdir -p \"$FINDINGS\"

LEAN_LIB=\"$(lean --print-prefix)/lib/lean\"
if [ \"$(uname)\" = \"Darwin\" ]; then
    export DYLD_LIBRARY_PATH=\"${LEAN_LIB}:${DYLD_LIBRARY_PATH:-}\"
else
    export LD_LIBRARY_PATH=\"${LEAN_LIB}:${LD_LIBRARY_PATH:-}\"
fi

echo \"=== Running AFL++ ===\"
echo \"Binary: $BINARY --afl\"
echo \"Corpus: $CORPUS\"
echo \"Findings: $FINDINGS\"
echo \"\"

AFL_SKIP_CPUFREQ=1 afl-fuzz \\
    -i \"$CORPUS\" \\
    -o \"$FINDINGS\" \\
    -t \"${AFL_TIMEOUT:-__TIMEOUT__}\" \\
    -m none \\
    -- \"$BINARY\" --afl
").replace "__TIMEOUT__" (toString timeoutMs)

private def setupAfl (config : FuzzConfig := {}) : IO Unit := do
  IO.FS.createDirAll "fuzz/corpus"
  IO.FS.writeFile "fuzz/run-afl.sh" (aflScriptContent config.aflTimeoutMs)
  let _ ← IO.Process.output { cmd := "chmod", args := #["+x", "fuzz/run-afl.sh"] }
  IO.FS.writeBinFile "fuzz/corpus/seed" (ByteArray.mk (Array.replicate 64 0))
  IO.println "AFL++ integration files generated:"
  IO.println ""
  IO.println "  fuzz/run-afl.sh    AFL++ runner script"
  IO.println "  fuzz/corpus/seed   Initial seed file"
  IO.println ""
  IO.println "Run:"
  IO.println "  ./fuzz/run-afl.sh              # build + run under AFL++"
  IO.println "  ./fuzz/run-afl.sh --run-only   # skip rebuild"
  IO.println ""
  IO.println "Replay findings:"
  IO.println "  lake exe fuzz --replay fuzz/findings/default/crashes/id:XXXXXX"
  IO.println ""
  IO.println "Environment variables:"
  IO.println "  LEAN_FUZZ_EXE=<name>   Override binary name (default: fuzz)"

-- ============================================================
-- Main entry point
-- ============================================================

/-- Run a fuzz target. This is the main entry point for LeanFuzz.

    ```lean
    import LeanFuzz

    def target : LeanFuzz.FuzzTarget := {
      run := fun bytes => do
        let input := String.fromUTF8? bytes |>.getD ""
        let _ := MyLib.process input
    }

    def main (args : List String) : IO Unit :=
      LeanFuzz.fuzz target args
    ```
-/
def fuzz (target : FuzzTarget) (args : List String := [])
    (config : FuzzConfig := {}) : IO Unit := do
  let parsed := parseArgs args {}

  match parsed.mode with
  | "help" =>
    IO.println helpText
  | "dump-grammar" =>
    IO.println "Error: --dump-grammar is only available with grammar-based fuzzing (fuzzGrammar)"
  | "setup-afl" =>
    setupAfl config
  | "afl" =>
    runAfl target
  | "replay" =>
    if let some path := parsed.replayFile then
      runReplay target path
    else
      IO.println "Error: --replay requires a file path"
  | _ =>
    let config := { config with
      iterations := parsed.countOverride.getD config.iterations
      verbose := config.verbose || parsed.verbose
    }
    runStandalone target config

private unsafe def fuzzGrammarUnsafe (imports : Array Lean.Name) (category : Lean.Name)
    (args : List String := []) (config : FuzzConfig := {}) : IO Unit := do
  Lean.initSearchPath (← Lean.findSysroot)
  Lean.enableInitializersExecution
  let importStmts := imports.map (fun m => s!"import {m}")
  let source := "\n".intercalate importStmts.toList ++ "\n"
  let some env ← Lean.Elab.runFrontend source {} "<fuzz>" `_fuzz_temp
    | do IO.println "Error: failed to elaborate imports"; return
  let grammar ← extractGrammar env
  let parsed := parseArgs args {}
  if parsed.mode == "dump-grammar" then
    match parsed.dumpFormat.getD "json" with
    | "text" => IO.println grammar.pretty
    | "afl" => IO.println grammar.toAflJsonString
    | _ => IO.println grammar.toJsonString
    return
  let tokenTrie := Lean.Parser.getTokenTable env
  IO.println s!"Extracted {grammar.categories.size} categories"
  for cat in grammar.categories do
    IO.println s!"  {cat.name}: {cat.rules.size} rules"
  let catExists := grammar.categories.any (·.name == category)
  if !catExists then
    IO.println s!"Error: syntax category `{category}` not found in imported modules"
    return
  let target : FuzzTarget := {
    name := s!"grammar:{category}"
    run := fun bytes => do
      let generated := generateProgramFromBytes grammar tokenTrie bytes category
      match tryParse env category generated with
      | .ok _ => pure ()
      | .error msg => throw <| IO.userError s!"parse error: {msg}\ninput: {generated}"
  }
  fuzz target args config

/-- Fuzz a syntax category by extracting its grammar at runtime.

    ```lean
    import LeanFuzz
    import Radix

    def main (args : List String) : IO Unit :=
      LeanFuzz.fuzzGrammar #[`Radix] `rstmt args
    ```
-/
@[implemented_by fuzzGrammarUnsafe]
opaque fuzzGrammar (imports : Array Lean.Name) (category : Lean.Name)
    (args : List String := []) (config : FuzzConfig := {}) : IO Unit

end LeanFuzz
