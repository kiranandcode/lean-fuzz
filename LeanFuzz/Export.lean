import Lean
import LeanFuzz.Grammar
import LeanFuzz.Generate

/-!
# Grammar export to external formats

Serializes the extracted grammar to JSON for consumption by AFL++,
grammar-based fuzzers, and other external tools.
-/

open Lean

namespace LeanFuzz

private def jsonNat (n : Nat) : Json := .num ⟨↑n, 0⟩

/-- Convert a ParserDescr to JSON.
    Formatting-only wrappers (ppGroup, ppIndent, etc.) are stripped.
    Sequences and alternatives are flattened into arrays. -/
partial def descrToJson : ParserDescr → Json
  | .const name => .mkObj [("const", .str name.toString)]
  | .unary name p =>
    if name == `Lean.Parser.optional || name == `optional then
      .mkObj [("optional", descrToJson p)]
    else if name == `Lean.Parser.many || name == `many
        || name == `manyIndent then
      .mkObj [("many", descrToJson p)]
    else if name == `Lean.Parser.many1 || name == `many1
        || name == `many1Indent then
      .mkObj [("many1", descrToJson p)]
    else if name == `Lean.Parser.group || name == `Lean.Parser.ppGroup
        || name == `Lean.Parser.ppIndent || name == `Lean.Parser.ppDedent
        || name == `Lean.Parser.ppRealGroup || name == `Lean.Parser.ppRealFill
        || name == `Lean.Parser.ppAllowUngrouped
        || name == `Lean.Parser.withPosition || name == `withPosition
        || name == `Lean.Parser.withoutPosition || name == `withoutPosition
        || name == `Lean.Parser.atomic || name == `atomic
        || name == `recover || name == `withoutForbidden then
      descrToJson p
    else if name == `Lean.Parser.notFollowedBy || name == `notFollowedBy
        || name == `lookahead || name == `Lean.Parser.lookahead then
      .mkObj [("lookahead", descrToJson p)]
    else if name == `interpolatedStr then
      .mkObj [("interpolatedStr", descrToJson p)]
    else
      .mkObj [("unary", .str name.toString), ("arg", descrToJson p)]
  | .binary name p₁ p₂ =>
    if name == `Lean.Parser.andthen || name == `andthen then
      .mkObj [("seq", .arr (flattenSeq (.binary name p₁ p₂)))]
    else if name == `Lean.Parser.orelse || name == `orelse then
      .mkObj [("alt", .arr (flattenAlt (.binary name p₁ p₂)))]
    else
      .mkObj [("binary", .str name.toString),
        ("left", descrToJson p₁), ("right", descrToJson p₂)]
  | .node kind prec p =>
    .mkObj [("node", .str kind.toString),
      ("prec", jsonNat prec), ("body", descrToJson p)]
  | .trailingNode kind prec lhsPrec p =>
    .mkObj [("trailingNode", .str kind.toString),
      ("prec", jsonNat prec), ("lhsPrec", jsonNat lhsPrec),
      ("body", descrToJson p)]
  | .symbol val => .mkObj [("symbol", .str val)]
  | .nonReservedSymbol val _ => .mkObj [("nonReservedSymbol", .str val)]
  | .cat name rbp =>
    if rbp == 0 then .mkObj [("cat", .str name.toString)]
    else .mkObj [("cat", .str name.toString), ("rbp", jsonNat rbp)]
  | .parser name => .mkObj [("parser", .str name.toString)]
  | .nodeWithAntiquot _ _ p => descrToJson p
  | .sepBy p sep _ trail =>
    .mkObj [("sepBy", .mkObj [("elem", descrToJson p),
      ("sep", .str sep), ("trailing", .bool trail)])]
  | .sepBy1 p sep _ trail =>
    .mkObj [("sepBy1", .mkObj [("elem", descrToJson p),
      ("sep", .str sep), ("trailing", .bool trail)])]
  | .unicodeSymbol u a _ =>
    .mkObj [("symbol", .str a), ("unicode", .str u)]
where
  flattenSeq : ParserDescr → Array Json
    | .binary name p₁ p₂ =>
      if name == `Lean.Parser.andthen || name == `andthen then
        flattenSeq p₁ ++ flattenSeq p₂
      else #[descrToJson (.binary name p₁ p₂)]
    | .nodeWithAntiquot _ _ p => flattenSeq p
    | p => #[descrToJson p]
  flattenAlt : ParserDescr → Array Json
    | .binary name p₁ p₂ =>
      if name == `Lean.Parser.orelse || name == `orelse then
        flattenAlt p₁ ++ flattenAlt p₂
      else #[descrToJson (.binary name p₁ p₂)]
    | .nodeWithAntiquot _ _ p => flattenAlt p
    | p => #[descrToJson p]

def ruleToJson (r : GrammarRule) : Json :=
  .mkObj [("name", .str r.declName.toString),
    ("leading", .bool r.isLeading),
    ("descr", descrToJson r.descr)]

def categoryToJson (c : GrammarCategory) : Json :=
  .mkObj [("name", .str c.name.toString),
    ("rules", .arr (c.rules.map ruleToJson))]

def Grammar.toJson (g : Grammar) : Json :=
  .mkObj [("format", .str "lean-fuzz-grammar-v1"),
    ("categories", .arr (g.categories.map categoryToJson))]

def Grammar.toJsonString (g : Grammar) : String :=
  g.toJson.pretty

-- ============================================================
-- AFL++ Grammar Mutator JSON export
--
-- Converts the grammar to the flat CFG format used by
-- AFL++ Grammar Mutator (https://github.com/AFLplusplus/Grammar-Mutator).
--
-- Format:
--   { "<category>": [["terminal", "<nonterminal>", ...], ...], ... }
--
-- Indentation constraints and precedence levels are dropped.
-- Helper nonterminals are generated for optional/many/sepBy.
-- ============================================================

private structure AflState where
  extraRules : Array (String × Array (Array String)) := #[]
  counter : Nat := 0
  config : GenConfig := {}
  poolCache : Array (String × String) := #[]

private abbrev AflM := StateM AflState

private partial def descrToAflProd : ParserDescr → AflM (Array String)
  | .symbol val => return #[val]
  | .nonReservedSymbol val _ => return #[val]
  | .const name => constAtomM name
  | .cat name _ => return #[s!"<{name}>"]
  | .parser _ => poolRef "ident" (·.identPool)
  | .unicodeSymbol _ a _ => return #[a]
  | .nodeWithAntiquot _ _ p => descrToAflProd p
  | .node _ _ p => descrToAflProd p
  | .trailingNode _ _ _ p => do
    let lhs ← poolRef "ident" (·.identPool)
    let body ← descrToAflProd p
    return lhs ++ body
  | .binary name p₁ p₂ => do
    if name == `Lean.Parser.andthen || name == `andthen then
      let a₁ ← descrToAflProd p₁
      let a₂ ← descrToAflProd p₂
      return a₁ ++ a₂
    else if name == `Lean.Parser.orelse || name == `orelse then
      let n ← fresh "alt"
      let alt₁ ← descrToAflProd p₁
      let alt₂ ← descrToAflProd p₂
      addRule n #[alt₁, alt₂]
      return #[n]
    else
      let a₁ ← descrToAflProd p₁
      let a₂ ← descrToAflProd p₂
      return a₁ ++ a₂
  | .unary name p => do
    if name == `Lean.Parser.optional || name == `optional then
      let n ← fresh "opt"
      let prod ← descrToAflProd p
      addRule n #[prod, #[]]
      return #[n]
    else if name == `Lean.Parser.many || name == `many
        || name == `manyIndent then
      let n ← fresh "rep"
      let prod ← descrToAflProd p
      addRule n #[prod ++ #[n], #[]]
      return #[n]
    else if name == `Lean.Parser.many1 || name == `many1
        || name == `many1Indent then
      let prod ← descrToAflProd p
      let n ← fresh "rep"
      addRule n #[prod ++ #[n], #[]]
      return prod ++ #[n]
    else if name == `Lean.Parser.notFollowedBy || name == `notFollowedBy
        || name == `lookahead || name == `Lean.Parser.lookahead then
      return #[]
    else if name == `interpolatedStr then
      poolRef "str" (·.strPool)
    else
      descrToAflProd p
  | .sepBy p sep _ _ => do
    let n ← fresh "sep"
    let elem ← descrToAflProd p
    let tail ← fresh "septail"
    addRule tail #[#[sep] ++ elem ++ #[tail], #[]]
    addRule n #[elem ++ #[tail], #[]]
    return #[n]
  | .sepBy1 p sep _ _ => do
    let elem ← descrToAflProd p
    let tail ← fresh "septail"
    addRule tail #[#[sep] ++ elem ++ #[tail], #[]]
    return elem ++ #[tail]
where
  fresh (pfx : String) : AflM String := do
    let s ← get
    set { s with counter := s.counter + 1 }
    return s!"<_{pfx}_{s.counter}>"
  addRule (name : String) (alts : Array (Array String)) : AflM Unit :=
    modify fun s => { s with extraRules := s.extraRules.push (name, alts) }
  poolRef (key : String) (getPool : GenConfig → Array String) : AflM (Array String) := do
    let st ← get
    match st.poolCache.find? (·.1 == key) with
    | some (_, n) => return #[n]
    | none =>
      let pool := getPool st.config
      if pool.size == 0 then return #[]
      if pool.size == 1 then return #[pool[0]!]
      let n := s!"<_{key}>"
      addRule n (pool.map fun v => #[v])
      modify fun s => { s with poolCache := s.poolCache.push (key, n) }
      return #[n]
  singleAtom (getVal : GenConfig → String) : AflM (Array String) := do
    let v := getVal (← get).config
    if v.isEmpty then return #[] else return #[v]
  constAtomM (name : Name) : AflM (Array String) := do
    if name == `ident || name == `rawIdent then
      poolRef "ident" (·.identPool)
    else if name == `numLit || name == `num then
      poolRef "num" (·.numPool)
    else if name == `strLit || name == `str then
      poolRef "str" (·.strPool)
    else if name == `charLit then singleAtom (·.charLit)
    else if name == `nameLit then singleAtom (·.nameLit)
    else if name == `scientificLit then singleAtom (·.scientificLit)
    else if name == `hexnum then poolRef "hex" (·.hexPool)
    else if name == `interpolatedStr then poolRef "str" (·.strPool)
    else if name == `tacticSeq || name == `Lean.Parser.Tactic.tacticSeq
        || name == `tacticSeqIndentGt || name == `matchRhsTacticSeq then
      singleAtom (·.tacticSeqAtom)
    else if name == `doSeq || name == `Lean.Parser.Term.doSeq then
      singleAtom (·.doSeqAtom)
    else if name == `hole then singleAtom (·.holeAtom)
    else if name == `optionValue then poolRef "optval" (·.optionValuePool)
    else if name == `letDecl then singleAtom (·.letDeclAtom)
    else if name == `declId || name == `Lean.Parser.Command.declId then
      singleAtom (·.declIdAtom)
    else if name == `Lean.Parser.commentBody then singleAtom (·.docCommentBody)
    else return #[]

private def aflSpacing (prod : Array String) : Array String := Id.run do
  if prod.size <= 1 then return prod
  let mut result : Array String := #[]
  for i in [:prod.size] do
    let s := prod[i]!
    if s.isEmpty then continue
    if result.size > 0 then
      let prev := result[result.size - 1]!
      if !prev.isEmpty then
        let last := prev.back
        let first := s.front
        let idLike (c : Char) := c.isAlphanum || c == '_' || c == '\''
        if (idLike last && (idLike first || first == '<'))
            || (last == '>' && (idLike first || first == '<')) then
          result := result.push " "
    result := result.push s
  return result

private partial def flattenOrelseTop : ParserDescr → Array ParserDescr
  | .binary name p₁ p₂ =>
    if name == `Lean.Parser.orelse || name == `orelse then
      flattenOrelseTop p₁ ++ flattenOrelseTop p₂
    else #[.binary name p₁ p₂]
  | .nodeWithAntiquot _ _ p => flattenOrelseTop p
  | p => #[p]

private def unwrapNode : ParserDescr → ParserDescr
  | .node _ _ p => p
  | .nodeWithAntiquot _ _ p => unwrapNode p
  | p => p

private def containsPushNoneAfl : ParserDescr → Bool
  | .const name => name == `Lean.Parser.pushNone
  | .binary _ p₁ p₂ => containsPushNoneAfl p₁ || containsPushNoneAfl p₂
  | .unary _ p => containsPushNoneAfl p
  | .node _ _ p => containsPushNoneAfl p
  | .nodeWithAntiquot _ _ p => containsPushNoneAfl p
  | _ => false

def Grammar.toAflJson (g : Grammar) (config : GenConfig := {}) : Json :=
  let (entries, _) := go g |>.run { config }
  let jsonEntries := entries.map fun (name, alts) =>
    (name, Json.arr (alts.map fun prod =>
      Json.arr ((aflSpacing prod).map Json.str)))
  Json.mkObj jsonEntries.toList
where
  go (g : Grammar) : AflM (Array (String × Array (Array String))) := do
    let mut result : Array (String × Array (Array String)) := #[]
    for cat in g.categories do
      let catName := s!"<{cat.name}>"
      let mut alts : Array (Array String) := #[]
      for rule in cat.rules do
        let inner := unwrapNode rule.descr
        let isTrailing := match rule.descr with
          | .trailingNode _ _ _ _ => true
          | _ => false
        let topAlts := flattenOrelseTop inner
        for alt in topAlts do
          if containsPushNoneAfl alt then continue
          let prod ← descrToAflProd alt
          let prod := prod.filter (!·.isEmpty)
          if prod.size == 0 then continue
          if isTrailing then
            let lhs ← descrToAflProd (.const `ident)
            alts := alts.push (lhs ++ prod)
          else
            alts := alts.push prod
      if alts.size > 0 then
        result := result.push (catName, alts)
    let extra := (← get).extraRules
    return result ++ extra

def Grammar.toAflJsonString (g : Grammar) (config : GenConfig := {}) : String :=
  (g.toAflJson config).pretty

end LeanFuzz
