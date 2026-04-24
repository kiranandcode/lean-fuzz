import Lean
import LeanFuzz.Grammar

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

end LeanFuzz
