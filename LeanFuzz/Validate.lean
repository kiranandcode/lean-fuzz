import Lean
import LeanFuzz.Grammar
import LeanFuzz.Generate

/-!
# Validation of grammar descriptions against Lean's actual parser

Uses `Lean.Parser.runParserCategory` to check that strings generated
from our grammar descriptions actually parse.
-/

open Lean Lean.Parser

namespace LeanFuzz

/-- Try to parse a string using Lean's parser for a given category.
    Returns `Except.ok syntax` on success, `Except.error msg` on failure. -/
def tryParse (env : Environment) (catName : Name) (input : String) : Except String Syntax :=
  runParserCategory env catName input

/-- Validate builtin descriptions by generating and parsing. -/
def validateBuiltins (env : Environment) (grammar : Grammar) (nTrials : Nat := 10) : IO Unit := do
  let tokenTrie := Lean.Parser.getTokenTable env
  for cat in grammar.categories do
    let mut successes := 0
    let mut failures := 0
    for rule in cat.rules do
      for trial in List.range nTrials do
        let seed := (trial.toUInt64 + 1) * 7919 + rule.declName.hash
        let state := GenState.initial seed cat.name tokenTrie
        let (generated, _) := generate rule.descr grammar.categories cat.name |>.run state
        match tryParse env cat.name generated with
        | .ok _ => successes := successes + 1
        | .error msg =>
          failures := failures + 1
          if failures <= 3 then  -- only show first few failures per category
            IO.println s!"  FAIL [{cat.name}] {rule.declName}: \"{generated}\""
            IO.println s!"    error: {msg}"
    if cat.rules.size > 0 then
      let total := successes + failures
      IO.println s!"  <{cat.name}>: {successes}/{total} passed"

end LeanFuzz
