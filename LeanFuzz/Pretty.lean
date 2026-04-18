import LeanFuzz.Grammar

/-!
# Pretty-printing ParserDescr as BNF-like grammar rules
-/

open Lean

namespace LeanFuzz

/-- Render a ParserDescr as a human-readable grammar string. -/
partial def ppDescr : ParserDescr → String
  | .const name => s!"${name}"
  | .unary name p => s!"${name}({ppDescr p})"
  | .binary name p₁ p₂ =>
    if name == `Lean.Parser.andthen then
      s!"{ppDescr p₁} {ppDescr p₂}"
    else if name == `Lean.Parser.orelse then
      s!"{ppDescr p₁} | {ppDescr p₂}"
    else
      s!"${name}({ppDescr p₁}, {ppDescr p₂})"
  | .node kind _prec p => s!"node[{kind}]({ppDescr p})"
  | .trailingNode kind _prec _lhsPrec p => s!"trailing[{kind}](lhs {ppDescr p})"
  | .symbol val => s!"\"{val}\""
  | .nonReservedSymbol val _ => s!"&\"{val}\""
  | .cat catName rbp =>
    if rbp == 0 then s!"<{catName}>"
    else s!"<{catName}:{rbp}>"
  | .parser declName => s!"@{declName}"
  | .nodeWithAntiquot _name _kind p => ppDescr p
  | .sepBy p sep _psep trail =>
    let t := if trail then ",trailing" else ""
    s!"sepBy({ppDescr p}, \"{sep}\"{t})"
  | .sepBy1 p sep _psep trail =>
    let t := if trail then ",trailing" else ""
    s!"sepBy1({ppDescr p}, \"{sep}\"{t})"
  | .unicodeSymbol u a _ => s!"\"{u}\" | \"{a}\""

def GrammarRule.pretty (r : GrammarRule) : String :=
  let tag := if r.isLeading then "" else "[trailing] "
  s!"  {tag}{r.declName} ::= {ppDescr r.descr}"

def GrammarCategory.pretty (c : GrammarCategory) : String :=
  let header := s!"category <{c.name}> ({c.rules.size} rules):"
  let rules := c.rules.map GrammarRule.pretty
  "\n".intercalate (header :: rules.toList)

def Grammar.pretty (g : Grammar) : String :=
  let cats := g.categories.map GrammarCategory.pretty
  "\n\n".intercalate cats.toList

def Grammar.summary (g : Grammar) : String := Id.run do
  let mut total := 0
  let mut leading := 0
  let mut trailing := 0
  for cat in g.categories do
    for rule in cat.rules do
      total := total + 1
      if rule.isLeading then leading := leading + 1
      else trailing := trailing + 1
  s!"Grammar: {g.categories.size} categories, {total} rules ({leading} leading, {trailing} trailing)"

end LeanFuzz
