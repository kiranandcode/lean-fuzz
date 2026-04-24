import Lean
import LeanFuzz.ExprToDescr

/-!
# Grammar extraction from Lean's parser

Extracts the grammar from Lean's runtime parser extension state.
Uses `ExprToDescr` to decompile both `ParserDescr` and compiled `Parser`
definitions back to grammar descriptors.
-/

open Lean Lean.Parser

deriving instance Repr for ParserDescr

namespace LeanFuzz

/-- A grammar rule: a named parser in a category. -/
structure GrammarRule where
  declName : Name
  isLeading : Bool
  descr : ParserDescr
  deriving Repr, Inhabited

/-- A parser category with its rules. -/
structure GrammarCategory where
  name : Name
  rules : Array GrammarRule
  deriving Repr

/-- The full extracted grammar. -/
structure Grammar where
  categories : Array GrammarCategory
  deriving Repr

/-- Extract grammar rules for a single category. -/
def extractCategoryGrammar (env : Environment) (catName : Name)
    (cat : ParserCategory) : IO GrammarCategory := do
  let mut rules : Array GrammarRule := #[]
  let kindsList := cat.kinds.foldl (init := #[]) fun acc k _ => acc.push k
  for declName in kindsList do
    if declName == `Lean.Parser.Tactic.unknown
        || declName == `Lean.Elab.Command.aux_def then continue
    if env.find? declName |>.isNone then continue
    let result ← try
      pure (some (← extractParserDescr env declName))
    catch _ =>
      pure none
    if let some (isLeading, descr) := result then
      rules := rules.push { declName, isLeading, descr }
  return { name := catName, rules }

/-- Activate all scoped parser entries on an environment.
    Without this, `scoped syntax` rules (e.g., Verso doc categories) are invisible. -/
def activateScopedParsers (env : Environment) : Environment :=
  let env := parserExtension.pushScope env
  let namespaces := (parserExtension.ext.getState env).scopedEntries.map.fold
    (init := #[]) fun acc ns _ => acc.push ns
  namespaces.foldl (init := env) fun env ns =>
    parserExtension.activateScoped env ns

def extractGrammar (env : Environment) : IO Grammar := do
  let env := activateScopedParsers env
  let state := parserExtension.getState env
  let mut categories : Array GrammarCategory := #[]
  let catList := state.categories.foldl (init := #[]) fun acc k v => acc.push (k, v)
  for (catName, cat) in catList do
    categories := categories.push (← extractCategoryGrammar env catName cat)
  return { categories }

end LeanFuzz
