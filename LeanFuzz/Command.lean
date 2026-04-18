import Lean
import LeanFuzz.ExprToDescr
import LeanFuzz.Pretty

/-!
# `#grammar` command

Usage:
  #grammar term       -- dump all rules for the `term` category
  #grammar command     -- dump all rules for the `command` category
  #grammar tactic 5    -- dump first 5 rules for `tactic`
-/

open Lean Lean.Parser Elab Command

namespace LeanFuzz

private def dumpCatImpl (env : Environment) (catName : Name) (cat : ParserCategory)
    (limit : Nat) : CommandElabM Unit := do
  let kindsList := cat.kinds.foldl (init := #[]) fun acc k _ => acc.push k
  let lim := min limit kindsList.size
  logInfo m!"category <{catName}> ({kindsList.size} rules, showing {lim}):\n"
  let mut shown := 0
  for declName in kindsList do
    if shown >= lim then break
    let some ci := env.find? declName | do
      logInfo m!"{declName} ::= (not found)"; shown := shown + 1; continue
    let some val := ci.value? | do
      logInfo m!"{declName} ::= (opaque)"; shown := shown + 1; continue
    let descr := exprToDescr env val
    let pretty := ppDescr descr
    let tag := match ci.type with
      | Expr.const ``TrailingParser _ => "[trailing] "
      | Expr.const ``TrailingParserDescr _ => "[trailing] "
      | _ => ""
    logInfo m!"{tag}{declName} ::= {pretty}"
    shown := shown + 1

elab "#grammar " catId:ident n:(num)? : command => do
  let catName := catId.getId
  let env ← getEnv
  let state := parserExtension.getState env
  let limit := match n with
    | some n => n.getNat
    | none => 1000
  let catName' := if catName == `syntax then `stx else catName
  match state.categories.find? catName' with
  | none => throwError "unknown parser category `{catName}`"
  | some cat => dumpCatImpl env catName' cat limit

private def indentStr (n : Nat) : String := String.mk (List.replicate (n * 2) ' ')

private partial def dumpExprStr (e : Expr) (depth maxDepth : Nat) : String :=
  let pfx := indentStr depth
  if depth >= maxDepth then s!"{pfx}..."
  else match e with
  | .app f a =>
    s!"{pfx}app:\n{dumpExprStr f (depth+1) maxDepth}\n{dumpExprStr a (depth+1) maxDepth}"
  | .const n _ => s!"{pfx}const {n}"
  | .lit (.strVal s) => s!"{pfx}str \"{s}\""
  | .lit (.natVal n) => s!"{pfx}nat {n}"
  | .lam n _ b _ => s!"{pfx}lam {n}:\n{dumpExprStr b (depth+1) maxDepth}"
  | .bvar i => s!"{pfx}bvar {i}"
  | .fvar id => s!"{pfx}fvar {id.name}"
  | .mdata _ e => dumpExprStr e depth maxDepth
  | .proj tn idx _ => s!"{pfx}proj {tn}.{idx}"
  | .forallE n _ _ _ => s!"{pfx}forall {n}"
  | .letE n _ v b _ =>
    s!"{pfx}let {n}:\n{dumpExprStr v (depth+1) maxDepth}\n{dumpExprStr b (depth+1) maxDepth}"
  | .mvar id => s!"{pfx}mvar {id.name}"
  | .sort _ => s!"{pfx}sort"

elab "#grammar_raw " id:ident : command => do
  let env ← getEnv
  let name := id.getId
  let some ci := env.find? name | throwError "unknown declaration `{name}`"
  let some val := ci.value? | logInfo m!"{name} : (no value)"; return
  let s := dumpExprStr val 0 15
  logInfo m!"{name} :\n{s}"

end LeanFuzz
