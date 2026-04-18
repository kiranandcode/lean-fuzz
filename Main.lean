import LeanFuzz
import Lean

open Lean Lean.Parser in
unsafe def main (args : List String) : IO Unit := do
  Lean.initSearchPath (← Lean.findSysroot)
  Lean.enableInitializersExecution
  -- Collect --import arguments, pass rest through as flags
  let mut modules := #[{ module := `Init : Import }, { module := `Lean }]
  let mut flags : List String := []
  let mut replayFile : Option String := none
  let mut iter := args
  while !iter.isEmpty do
    match iter with
    | "--import" :: modName :: rest =>
      modules := modules.push { module := modName.toName }
      iter := rest
    | "--replay" :: path :: rest =>
      replayFile := some path
      iter := rest
    | flag :: rest =>
      flags := flags ++ [flag]
      iter := rest
    | [] => iter := []
  let args := flags
  let env ← Lean.importModules modules {} (loadExts := true)
  let env := LeanFuzz.activateScopedParsers env
  let tokenTrie := Lean.Parser.getTokenTable env

  if let some path := replayFile then
    let bytes ← IO.FS.readBinFile path
    let grammar ← LeanFuzz.extractGrammar env
    let program := LeanFuzz.generateProgramFromBytes grammar tokenTrie bytes
    IO.println program
    return

  if args.contains "--partials" then
    -- Show partial rules with example failures
    let grammar ← LeanFuzz.extractGrammar env
    for cat in grammar.categories do
      for rule in cat.rules do
        let mut successes := 0
        let mut failures : Array (String × String) := #[]
        for trial in List.range 20 do
          let seed := (trial.toUInt64 + 1) * 7919 + rule.declName.hash
          let state := LeanFuzz.GenState.initial seed cat.name tokenTrie
          let (generated, _) := LeanFuzz.generate rule.descr grammar.categories cat.name |>.run state
          match LeanFuzz.tryParse env cat.name generated with
          | .ok _ => successes := successes + 1
          | .error msg =>
            if failures.size < 2 then
              failures := failures.push ((generated.toList.take 80).asString, (msg.toList.take 80).asString)
        if successes > 0 && successes < 20 then
          IO.println s!"[{cat.name}] {rule.declName} ({successes}/20)"
          for (gen, err) in failures do
            IO.println s!"  FAIL: {gen}"
            IO.println s!"  ERR:  {err}"
          IO.println ""
  else if args.contains "--validate" then
    let grammar ← LeanFuzz.extractGrammar env
    IO.println grammar.summary
    IO.println ""
    let mut perfect := 0
    let mut partial' := 0
    let mut zero := 0
    for cat in grammar.categories do
      for rule in cat.rules do
        let mut successes := 0
        for trial in List.range 20 do
          let seed := (trial.toUInt64 + 1) * 7919 + rule.declName.hash
          let state := LeanFuzz.GenState.initial seed cat.name tokenTrie
          let (generated, _) := LeanFuzz.generate rule.descr grammar.categories cat.name |>.run state
          match LeanFuzz.tryParse env cat.name generated with
          | .ok _ => successes := successes + 1
          | .error _ => pure ()
        if successes == 20 then perfect := perfect + 1
        else if successes > 0 then partial' := partial' + 1
        else zero := zero + 1
    IO.println s!"Per-rule (20 trials each):"
    IO.println s!"  Perfect (20/20): {perfect}"
    IO.println s!"  Partial (>0/20): {partial'}"
    IO.println s!"  Zero   (0/20):  {zero}"
    IO.println s!"  Total:           {perfect + partial' + zero}"
  else if args.contains "--zeros" then
    let grammar ← LeanFuzz.extractGrammar env
    for cat in grammar.categories do
      for rule in cat.rules do
        let mut successes := 0
        let mut firstFail := ""
        let mut firstGen := ""
        for trial in List.range 20 do
          let seed := (trial.toUInt64 + 1) * 7919 + rule.declName.hash
          let state := LeanFuzz.GenState.initial seed cat.name tokenTrie
          let (generated, _) := LeanFuzz.generate rule.descr grammar.categories cat.name |>.run state
          match LeanFuzz.tryParse env cat.name generated with
          | .ok _ => successes := successes + 1
          | .error msg =>
            if firstFail == "" then
              firstFail := (msg.toList.take 100).asString
              firstGen := (generated.toList.take 100).asString
        if successes == 0 then
          IO.println s!"[{cat.name}] {rule.declName}"
          IO.println s!"  gen: {firstGen}"
          IO.println s!"  err: {firstFail}"
          IO.println s!"  desc: {LeanFuzz.ppDescr rule.descr}"
          IO.println ""
  else if args.contains "--audit" then
    -- Full audit: for each failing rule, show extracted grammar, good/bad gen, error
    let grammar ← LeanFuzz.extractGrammar env
    IO.println "# Failing Builtin Parsers"
    IO.println ""
    for cat in grammar.categories do
      for rule in cat.rules do
        let mut successes := 0
        let mut firstFail := ""
        let mut firstGen := ""
        let mut goodGen := ""
        for trial in List.range 20 do
          let seed := (trial.toUInt64 + 1) * 7919 + rule.declName.hash
          let state := LeanFuzz.GenState.initial seed cat.name tokenTrie
          let (generated, _) := LeanFuzz.generate rule.descr grammar.categories cat.name |>.run state
          match LeanFuzz.tryParse env cat.name generated with
          | .ok _ =>
            successes := successes + 1
            if goodGen == "" then goodGen := generated
          | .error msg =>
            if firstFail == "" then
              firstFail := msg
              firstGen := generated
        if successes < 20 then
          IO.println s!"### [{cat.name}] {rule.declName} — {successes}/20"
          IO.println ""
          IO.println "**Extracted grammar:**"
          IO.println "```"
          IO.println s!"{LeanFuzz.ppDescr rule.descr}"
          IO.println "```"
          IO.println ""
          if goodGen != "" then
            IO.println "**Good generation (parses):**"
            IO.println "```"
            IO.println goodGen
            IO.println "```"
            IO.println ""
          IO.println "**Failing generation:**"
          IO.println "```"
          IO.println firstGen
          IO.println "```"
          IO.println ""
          IO.println s!"**Error:** `{firstFail}`"
          IO.println ""
          IO.println "---"
          IO.println ""
  else
    let grammar ← LeanFuzz.extractGrammar env
    IO.println grammar.summary
