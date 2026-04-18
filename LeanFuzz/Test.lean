import LeanFuzz
import Lean

/-!
# Tests for lean-fuzz

Run via `lake test`.

Tests that:
1. Grammar extraction captures all builtin categories with expected rule counts
2. Every extracted rule generates parseable output (no zero-score rules)
3. Custom `declare_syntax_cat` categories are extracted when their module is imported
-/

-- Custom syntax for testing extraction
declare_syntax_cat myexpr
syntax num : myexpr
syntax ident : myexpr
syntax myexpr " + " myexpr : myexpr

syntax "#mycheck " term : command

syntax:25 "myif " term " mythen " term " myelse " term : term

open Lean Lean.Parser LeanFuzz

unsafe def _root_.main : IO UInt32 := do
  Lean.initSearchPath (← Lean.findSysroot)
  Lean.enableInitializersExecution
  let passed ← IO.mkRef (0 : Nat)
  let failed ← IO.mkRef (0 : Nat)

  let report := fun (name : String) (result : Except String Unit) => do
    match result with
    | .ok () =>
      IO.println s!"  PASS: {name}"
      passed.modify (· + 1)
    | .error msg =>
      IO.eprintln s!"  FAIL: {name}"
      IO.eprintln s!"        {msg}"
      failed.modify (· + 1)

  -- Builtin-only environment (no loadExts) for regression tests
  let builtinEnv ← Lean.importModules #[{ module := `Init }, { module := `Lean }] {}
  let builtinTokenTrie := Lean.Parser.getTokenTable builtinEnv
  let builtinGrammar ← extractGrammar builtinEnv

  -- Full environment with extensions for custom syntax tests
  let env ← Lean.importModules #[{ module := `Init }, { module := `Lean }, { module := `LeanFuzz.Test }] {} (loadExts := true)
  let env := activateScopedParsers env
  let tokenTrie := Lean.Parser.getTokenTable env
  let grammar ← extractGrammar env

  -- ========================================
  -- Grammar structure tests (builtin)
  -- ========================================
  IO.println "=== Grammar extraction ==="

  report "≥8 categories" <| do
    if builtinGrammar.categories.size < 8 then .error s!"got {builtinGrammar.categories.size}" else .ok ()

  let totalRules := builtinGrammar.categories.foldl (init := 0) fun acc c => acc + c.rules.size
  report "≥200 rules" <| do
    if totalRules < 200 then .error s!"got {totalRules}" else .ok ()

  for (catName, minRules) in #[
    (`term, 80), (`command, 40), (`tactic, 3), (`doElem, 15),
    (`level, 5), (`stx, 7), (`attr, 10), (`prec, 1), (`prio, 1),
    (`structInstFieldDecl, 2)
  ] do
    report s!"{catName} ≥{minRules} rules" <| do
      match builtinGrammar.categories.find? (·.name == catName) with
      | some cat =>
        if cat.rules.size < minRules then .error s!"got {cat.rules.size}" else .ok ()
      | none => .error "not found"

  -- ========================================
  -- No zero-score rules (builtin parsers, 40 trials)
  -- ========================================
  IO.println "\n=== Generation (no zeros, 40 trials) ==="

  for cat in builtinGrammar.categories do
    let mut zeros : Array String := #[]
    for rule in cat.rules do
      let mut successes := 0
      for trial in List.range 40 do
        let seed := (trial.toUInt64 + 1) * 7919 + rule.declName.hash
        let state := GenState.initial seed cat.name builtinTokenTrie
        let (generated, _) := generate rule.descr builtinGrammar.categories cat.name |>.run state
        match tryParse builtinEnv cat.name generated with
        | .ok _ => successes := successes + 1
        | .error _ => pure ()
      if successes == 0 then
        zeros := zeros.push s!"{rule.declName}"
    report s!"{cat.name}: no zeros ({cat.rules.size} rules)" <| do
      if zeros.size > 0 then
        .error s!"{zeros.size} zeros: {", ".intercalate zeros.toList |>.take 200}"
      else .ok ()

  -- ========================================
  -- Custom syntax categories
  -- ========================================
  IO.println "\n=== Custom syntax ==="

  report "custom categories extracted" <| do
    if grammar.categories.size > builtinGrammar.categories.size then .ok ()
    else .error s!"expected more categories with loadExts, got {grammar.categories.size} vs {builtinGrammar.categories.size}"

  report "myexpr category extracted" <| do
    match grammar.categories.find? (·.name == `myexpr) with
    | some cat =>
      if cat.rules.size >= 3 then .ok ()
      else .error s!"expected ≥3 rules, got {cat.rules.size}"
    | none => .error "not found in grammar"

  report "#mycheck command extracted" <| do
    match grammar.categories.find? (·.name == `command) with
    | some cat =>
      let found := cat.rules.any fun r =>
        let s := r.declName.toString
        (s.splitOn "mycheck").length > 1
      if found then .ok () else .error "not found"
    | none => .error "command category missing"

  report "myif term extracted" <| do
    match grammar.categories.find? (·.name == `term) with
    | some cat =>
      let found := cat.rules.any fun r =>
        r.declName == `termMyif_Mythen_Myelse_
      if found then .ok () else .error "not found"
    | none => .error "term category missing"

  -- ========================================
  -- Full validation (all rules, 40 trials)
  -- ========================================
  IO.println "\n=== Full validation (40 trials) ==="

  let mut perfect := 0
  let mut partial' := 0
  let mut zero := 0
  for cat in grammar.categories do
    for rule in cat.rules do
      let mut successes := 0
      for trial in List.range 40 do
        let seed := (trial.toUInt64 + 1) * 7919 + rule.declName.hash
        let state := GenState.initial seed cat.name tokenTrie
        let (generated, _) := generate rule.descr grammar.categories cat.name |>.run state
        match tryParse env cat.name generated with
        | .ok _ => successes := successes + 1
        | .error _ => pure ()
      if successes == 40 then perfect := perfect + 1
      else if successes > 0 then partial' := partial' + 1
      else zero := zero + 1

  let totalRules := perfect + partial' + zero
  IO.println s!"  Perfect (40/40): {perfect}"
  IO.println s!"  Partial (>0/40): {partial'}"
  IO.println s!"  Zero    (0/40): {zero}"
  IO.println s!"  Total:           {totalRules}"

  report s!"100% perfect (got {perfect}/{totalRules})" <| do
    if perfect == totalRules then .ok ()
    else .error s!"{partial'} partial, {zero} zero"

  report "no zero-score rules" <| do
    if zero == 0 then .ok () else .error s!"{zero} zero-score rules"

  -- ========================================
  -- Summary
  -- ========================================
  let p ← passed.get
  let f ← failed.get
  IO.println s!"\n{p} passed, {f} failed"
  return if f > 0 then 1 else 0
