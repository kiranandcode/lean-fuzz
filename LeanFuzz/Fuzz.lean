import Lean
import LeanFuzz.Grammar
import LeanFuzz.Generate
import LeanFuzz.Validate

/-!
# libFuzzer FFI surface

Exports C-callable functions for integration with libFuzzer:
- `lean_fuzz_init`: one-time initialization (load environment, extract grammar)
- `lean_fuzz_one_input`: per-input handler (generate program from bytes, run full pipeline)
-/

open Lean

namespace LeanFuzz

/-- Persistent state shared across fuzz iterations. -/
structure FuzzState where
  env : Environment
  grammar : Grammar
  tokenTrie : Lean.Parser.TokenTable

initialize fuzzStateRef : IO.Ref (Option FuzzState) ← IO.mkRef none

/-- Initialize the Lean environment and extract the parser grammar.
    Called once from `LLVMFuzzerInitialize` in the C harness. -/
@[export lean_fuzz_init]
unsafe def fuzzInit : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  Lean.enableInitializersExecution
  let modules := #[{ module := `Init : Import }, { module := `Lean }]
  let env ← Lean.importModules modules {} (loadExts := true)
  let env := activateScopedParsers env
  let grammar ← extractGrammar env
  let tokenTrie := Lean.Parser.getTokenTable env
  fuzzStateRef.set (some { env, grammar, tokenTrie })
  return 0

/-- Process one fuzzer input: generate a program from the byte buffer,
    then run it through Lean's parse + elaborate pipeline.
    Called from `LLVMFuzzerTestOneInput` in the C harness. -/
@[export lean_fuzz_one_input]
unsafe def fuzzOneInput (data : @& ByteArray) : IO UInt32 := do
  let some st ← fuzzStateRef.get | return 1
  let program := generateProgramFromBytes st.grammar st.tokenTrie data
  if program.isEmpty then return 0
  -- Write the program to a file before elaborating. On crash (segfault/abort),
  -- this file contains the last input — since control never returns to print it.
  IO.FS.writeFile "last-fuzz-input.lean" program
  -- Run the full pipeline (parse + elaborate).
  -- All errors are expected and caught — only ASan/UBSan crashes matter.
  try
    let _ ← Lean.Elab.process program st.env {}
  catch _ => pure ()
  return 0

end LeanFuzz
