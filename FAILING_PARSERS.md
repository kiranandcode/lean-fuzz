






### [doElem] Lean.Parser.Term.doDbgTrace — 18/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doDbgTrace]("dbg_trace " $interpolatedStr | <term>)
```

**Good generation (parses):**
```
dbg_trace "test"
```

**Failing generation:**
```
dbg_trace StateRefT rightact% x for m : "hello" in true,  m : "hello" in z,  m : f in x do 
  
  g;  g z
```

**Error:** `<input>:3:9: unexpected end of input`

---

### [doElem] Lean.Parser.Term.doExpr — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doExpr]($Lean.Parser.checkPrec <term> $Lean.Parser.checkPrec)
```

**Good generation (parses):**
```
decl_name%
```

**Failing generation:**
```
have +postponeValue : try 
  
  match (dependent := true) (generalizing := true) (motive := true) false with
      
      | () |  x => 
      
      
      x; 
catch _ => 
  
  x;  := f;
n
```

**Error:** `<input>:1:5: expected '(', ':=', '|' or term`

---

### [doElem] Lean.Parser.Term.doLetExpr — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doLetExpr]($Lean.Parser.withPosition("let_expr " node[Lean.Parser.Term.matchExprPat]($Lean.Parser.optional($Lean.Parser.checkPrec $ident "@") $Lean.Parser.checkPrec $ident $Lean.Parser.many($ident | node[Lean.Parser.Term.hole]("_"))) " := " <term> $Lean.Parser.checkColGe " | " node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))) $Lean.Parser.optional($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))))
```

**Good generation (parses):**
```
let_expr x@f := set_option g.x false in match (motive := throwNamedError n ()) false,  0 with
    
    | x,  y => 
    b
 | 
  
  h


b; 
```

**Failing generation:**
```
let_expr f := by set_option a false in trivial
 | 
  
  return 0; 
```

**Error:** `<input>:1:40: unknown tactic`

---

### [doElem] Lean.Parser.Term.doFor — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doFor]("for " sepBy1(node[Lean.Parser.Term.doForDecl]($Lean.Parser.optional($Lean.Parser.checkPrec $ident " : ") <term> " in " <term>), ", ") "do " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))
```

**Good generation (parses):**
```
for z : unsafe leading_parser:_ (withAnonymousAntiquot := true) "hello" in (),  z : 0 in b do 
  
  x; 
```

**Failing generation:**
```
for (unreachable! : return 
  ()) in "hello",  0 in z do 
  
  z; 
```

**Error:** `<input>:2:2: expected ')'`

---

### [doElem] Lean.Parser.Term.doIf — 10/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doIf]("if " node[Lean.Parser.Term.doIfLet]("let " <term> node[Lean.Parser.Term.doIfLetPure](" := " <term>) | node[Lean.Parser.Term.doIfLetBind]("← " | "<- " <term>)) | node[Lean.Parser.Term.doIfProp]($Lean.Parser.optional($ident | node[Lean.Parser.Term.hole]("_") " : ") <term>) " then" $Lean.Parser.ppSpace node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))) $Lean.Parser.many($Lean.Parser.checkColGe $Lean.Parser.group($Lean.Parser.ppSpace $Lean.Parser.group($Lean.Parser.withPosition("else " $Lean.Parser.checkLineEq " if ")) node[Lean.Parser.Term.doIfLet]("let " <term> node[Lean.Parser.Term.doIfLetPure](" := " <term>) | node[Lean.Parser.Term.doIfLetBind]("← " | "<- " <term>)) | node[Lean.Parser.Term.doIfProp]($Lean.Parser.optional($ident | node[Lean.Parser.Term.hole]("_") " : ") <term>) " then " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))) $Lean.Parser.optional($Lean.Parser.checkColGe $Lean.Parser.ppSpace "else " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))))))
```

**Good generation (parses):**
```
if ``(`(clear% g

x)) then 
  
  pure (); 
 else {
return x
}
```

**Failing generation:**
```
if (_ : Sort 
  y) -> false then {
return 0
}
 else 
  if let 0 := h then {
f
}
 else {
a
}
```

**Error:** `<input>:9:1: expected end of input`

---

### [doElem] Lean.Parser.Term.doLetMetaExpr — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doLetMetaExpr]($Lean.Parser.withPosition("let_expr " node[Lean.Parser.Term.matchExprPat]($Lean.Parser.optional($Lean.Parser.checkPrec $ident "@") $Lean.Parser.checkPrec $ident $Lean.Parser.many($ident | node[Lean.Parser.Term.hole]("_"))) "← " | "<- " <term> $Lean.Parser.checkColGe " | " node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))) $Lean.Parser.optional($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))))
```

**Good generation (parses):**
```
let_expr b@y<- forall _, @& StateRefT false $0
 | 
  
  return 0; 
```

**Failing generation:**
```
let_expr f<- { 
  ,  
  ,  
   : do 
  
  unless 0 do {
  return 0
  };  }
 | 
  
  pure (); 
```

**Error:** `<input>:2:2: expected '_', '}' or identifier`

---

### [doElem] Lean.Parser.Term.doHave — 13/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doHave]("have" node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>))))))))
```

**Good generation (parses):**
```
have (unsafe wait_if_type_contains_mvar% ?y; show_term_elab "hello") := false
```

**Failing generation:**
```
have : unless by trivial do 
  
  return x;  := true
```

**Error:** `<input>:1:18: unknown tactic`

---

### [doElem] Lean.Parser.Term.doUnless — 8/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doUnless]("unless " <term> " do " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))
```

**Good generation (parses):**
```
unless default_or_ofNonempty%  do 
  
  match_expr (meta := false) ensure_type_of% "hello""" false with
    
    | _ => 
      
      return x; 
```

**Failing generation:**
```
unless let +postponeValue : Type 
    y := true

true do 
  
  return 0; 
```

**Error:** `<input>:2:4: expected ':=' or '|'`

---

### [doElem] Lean.Parser.Term.doMatchExpr — 13/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doMatchExpr]("match_expr " $Lean.Parser.optional("(" &"meta" " := " &"false" ") ") <term> " with" node[Lean.Parser.Term.matchExprAlts]($Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.ppLine $Lean.Parser.checkColGe $Lean.Parser.checkPrec node[Lean.Parser.Term.matchExprAlt]("| " node[Lean.Parser.Term.matchExprPat]($Lean.Parser.optional($Lean.Parser.checkPrec $ident "@") $Lean.Parser.checkPrec $ident $Lean.Parser.many($ident | node[Lean.Parser.Term.hole]("_"))) " => " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))) $Lean.Parser.ppLine $Lean.Parser.checkColGe node[Lean.Parser.Term.matchExprElseAlt]("| " node[Lean.Parser.Term.hole]("_") " => " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))))))))
```

**Good generation (parses):**
```
match_expr (meta := false) Prop with
  
  | n => 
    
    let_expr x@n := unop% b 0
     | 
      
      return 0; ; 
  
  | _ => {
  return x
  }
```

**Failing generation:**
```
match_expr <- let_expr g@n := let_mvar% ?b := "hello"; ()
     | 0;
n with
  
  | _ => 
    
    m; 
```

**Error:** `<input>:2:5: expected checkColGt`

---

### [doElem] Lean.Parser.Term.doAssert — 13/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doAssert]("assert! " <term>)
```

**Good generation (parses):**
```
assert! for_in'% elabToSyntax% 42 logNamedWarning y x "hello"
```

**Failing generation:**
```
assert! logNamedErrorAt throwNamedErrorAt `(tactic| skip;
 skip) m.m () a x
```

**Error:** `<input>:1:53: unknown tactic`

---

### [doElem] Lean.Parser.Term.doLetElse — 12/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doLetElse]($Lean.Parser.withPosition("let " $Lean.Parser.optional("mut ") <term> " := " <term> $Lean.Parser.checkColGe " | " node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))) $Lean.Parser.optional($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))))
```

**Good generation (parses):**
```
let mut Type 
  f := 'a'
 | 
  
  pure ()


pure (); 
```

**Failing generation:**
```
let `(tactic| { 
};
 rfl;
 sorry) := "hello"
 | 
  
  pure (); 
```

**Error:** `<input>:3:2: unknown tactic`

---

### [doElem] Lean.Parser.Term.doLetRec — 0/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doLetRec]($Lean.Parser.group("let " &"rec ") node[Lean.Parser.Term.letRecDecls](sepBy1(node[Lean.Parser.Term.letRecDecl]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ")) node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>))))))) node[Lean.Parser.Termination.suffix]($Lean.Parser.optional($Lean.Parser.ppLine node[Lean.Parser.Termination.terminationBy?]("termination_by?") | node[Lean.Parser.Termination.terminationBy]("termination_by " $Lean.Parser.optional(&"structural ") $Lean.Parser.optional($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_")) " => ") <term>) | node[Lean.Parser.Termination.partialFixpoint]($Lean.Parser.withPosition("partial_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.coinductiveFixpoint]($Lean.Parser.withPosition("coinductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.inductiveFixpoint]($Lean.Parser.withPosition("inductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>)))) $Lean.Parser.optional(node[Lean.Parser.Termination.decreasingBy]($Lean.Parser.ppLine "decreasing_by " <tactic>)))), ", ")))
```

**Failing generation:**
```
let rec /-- doc comment text -/
 : let rec @[scoped tactic_name f]  (for_in'% true 0 x) : g := n
  decreasing_by x,  /-- doc comment text -/
   : m := a
  decreasing_by z

b := f
decreasing_by x
```

**Error:** `<input>:3:17: unknown tactic`

---

### [doElem] Lean.Parser.Term.doReturn — 10/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doReturn]($Lean.Parser.withPosition("return" $Lean.Parser.optional($Lean.Parser.ppSpace $Lean.Parser.checkLineEq <term>)))
```

**Good generation (parses):**
```
return
```

**Failing generation:**
```
return 
binop_lazy% y throwNamedErrorAt no_error_if_unused% true a () 0
```

**Error:** `<input>:2:0: expected end of input`

---

### [doElem] Lean.Parser.Term.doTry — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doTry]("try " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))) $Lean.Parser.many(node[Lean.Parser.Term.doCatch]($Lean.Parser.ppLine "catch " $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.optional(" : " <term>) " => " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))))) | node[Lean.Parser.Term.doCatchMatch]($Lean.Parser.ppLine "catch " node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))))))))))) $Lean.Parser.optional(node[Lean.Parser.Term.doFinally]($Lean.Parser.ppLine "finally " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))))
```

**Good generation (parses):**
```
try 
  
  debug_assert! (for false in x,  z : "hello" in g do 
    
    g;  :); 
finally {
h
}
```

**Failing generation:**
```
try 
  
  try 
    
    if 1.5e10 then {
    pure ()
    }
     else 
      if let false := false then {
    h
    }
     else {
    a
    }; 
  finally {
  f
  }; 
finally {
a
}
```

**Error:** `<input>:12:5: expected end of input`

---

### [doElem] Lean.Parser.Term.doReassignArrow — 11/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doReassignArrow]($Lean.Parser.checkPrec node[Lean.Parser.Term.doIdDecl]($Lean.Parser.checkPrec $ident $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) $Lean.Parser.ppSpace "← " | "<- " <doElem>) | node[Lean.Parser.Term.doPatDecl](<term> $Lean.Parser.ppSpace "← " | "<- " <doElem> $Lean.Parser.optional($Lean.Parser.checkColGe " | " node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))) $Lean.Parser.optional($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))))))))
```

**Good generation (parses):**
```
n <- break
```

**Failing generation:**
```
f <- let_expr a<- dbg_trace"test";
  logNamedWarningAt () n true
   | 
    
    return 0
  
  
  z; 
```

**Error:** `<input>:3:3: expected checkColGe`

---

### [doElem] Lean.Parser.Term.doLetArrow — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doLetArrow]($Lean.Parser.withPosition("let " $Lean.Parser.optional("mut ") node[Lean.Parser.Term.doIdDecl]($Lean.Parser.checkPrec $ident $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) $Lean.Parser.ppSpace "← " | "<- " <doElem>) | node[Lean.Parser.Term.doPatDecl](<term> $Lean.Parser.ppSpace "← " | "<- " <doElem> $Lean.Parser.optional($Lean.Parser.checkColGe " | " node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))) $Lean.Parser.optional($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))))))
```

**Good generation (parses):**
```
let mut n <- a <- let  : ensure_expected_type% "world" () := "hello"
```

**Failing generation:**
```
let mut h <- let (_ : let +postponeValue : () := 0;
  0) -> a := x
   | 
    
    h
  
  
  g; 
```

**Error:** `<input>:3:3: expected end of input`

---

### [doElem] Lean.Parser.Term.doDebugAssert — 16/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doDebugAssert]("debug_assert! " <term>)
```

**Good generation (parses):**
```
debug_assert! @ensure_type_of% ``("hello")"hello" false
```

**Failing generation:**
```
debug_assert! { 
  ,  
  ,  
   : type_of% wait_if_type_mvar% ?z; false }
```

**Error:** `<input>:2:2: expected '_', '}' or identifier`

---

### [doElem] Lean.Parser.Term.doLet — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doLet]("let " $Lean.Parser.optional("mut ") node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>))))))))
```

**Good generation (parses):**
```
let  : logNamedError f ensure_type_of% ."" 0 := x
```

**Failing generation:**
```
let  : . := binrel_no_prop% m wait_if_type_mvar% ?m; "hello" x
```

**Error:** `<input>:1:62: unexpected end of input`

---

### [doElem] Lean.Parser.Term.doNested — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doNested]("do " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))
```

**Good generation (parses):**
```
do 
  
  let mut f <- try {
  (); 
  }
  finally {
  return x
  }; 
```

**Failing generation:**
```
do {
have (``x) : let_expr z@n := false
     | x

() := y
}
```

**Error:** `<input>:2:6: expected '_' or identifier`

---

### [doElem] Lean.Parser.Term.doMatch — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doMatch]("match " $Lean.Parser.optional(node[Lean.Parser.Term.dependentParam]("(" &"dependent" " := " node[Lean.Parser.Term.trueVal](&"true") | node[Lean.Parser.Term.falseVal](&"false") ")" $Lean.Parser.ppSpace)) $Lean.Parser.optional(node[Lean.Parser.Term.generalizingParam]("(" &"generalizing" " := " node[Lean.Parser.Term.trueVal](&"true") | node[Lean.Parser.Term.falseVal](&"false") ")" $Lean.Parser.ppSpace)) $Lean.Parser.optional(node[Lean.Parser.Term.motive]("(" &"motive" " := " $Lean.Parser.withoutPosition(<term>) ")" $Lean.Parser.ppSpace)) sepBy1(node[Lean.Parser.Term.matchDiscr]($Lean.Parser.optional($ident | node[Lean.Parser.Term.hole]("_") " : ") <term>), ", ") " with" node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))))))))))
```

**Good generation (parses):**
```
match (generalizing := true) (motive := sorry) debug_assert! panic! "hello";
false with
    
    | x |  b |  m,  a,  b => 
    
    
    b; 
```

**Failing generation:**
```
match (dependent := true) (generalizing := true) (motive := value_of% y) f : 2,  `(tactic| trivial),  a : () with
    
    | false,  g => 
    
    
    b; 
```

**Error:** `<input>:1:92: unknown tactic`

---

### [doElem] Lean.Parser.Term.doReassign — 13/20

**Extracted grammar:**
```
node[Lean.Parser.Term.doReassign]($Lean.Parser.checkPrec node[Lean.Parser.Term.letIdDeclNoBinders](node[Lean.Parser.Term.letId]($Lean.Parser.checkPrec $ident) $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>))
```

**Good generation (parses):**
```
h := clear% z

@clear% m

true
```

**Failing generation:**
```
 (return 
  let +postponeValue : binop% f x "hello" := x
  
  x) : m := a
```

**Error:** `<input>:2:2: expected ')', ',' or ':'`

---

### [tactic] Lean.Parser.Tactic.open — 12/20

**Extracted grammar:**
```
node[Lean.Parser.Tactic.open]("open " node[Lean.Parser.Command.openHiding]($Lean.Parser.ppSpace $ident " hiding" $Lean.Parser.many1($Lean.Parser.ppSpace $Lean.Parser.checkColGt $ident)) | node[Lean.Parser.Command.openRenaming]($Lean.Parser.ppSpace $ident " renaming " sepBy1(node[Lean.Parser.Command.openRenamingItem]($ident " → " | " -> " $Lean.Parser.checkColGt $ident), ", ")) | node[Lean.Parser.Command.openOnly]($Lean.Parser.ppSpace $ident " (" $Lean.Parser.many1($ident) ")") | node[Lean.Parser.Command.openSimple]($Lean.Parser.many1($Lean.Parser.ppSpace $Lean.Parser.checkColGt $ident)) | node[Lean.Parser.Command.openScoped](" scoped" $Lean.Parser.many1($Lean.Parser.ppSpace $Lean.Parser.checkColGt $ident)) " in " <tactic>)
```

**Good generation (parses):**
```
open  n renaming f -> 
  g,  f -> 
  z,  f -> 
  b in intro
    
    | show_term_elab "",  0 |  false,  true |  g,  h => 
    _
```

**Failing generation:**
```
open  a hiding 
  z in intro
    
    | binop% y let_mvar% ?y := x; 0 true,  n |  a,  x => 
    ?_
```

**Error:** `<input>:4:40: expected term`

---

### [tactic] Lean.Parser.Tactic.match — 16/20

**Extracted grammar:**
```
node[Lean.Parser.Tactic.match]("match " $Lean.Parser.optional(node[Lean.Parser.Term.generalizingParam]("(" &"generalizing" " := " node[Lean.Parser.Term.trueVal](&"true") | node[Lean.Parser.Term.falseVal](&"false") ")" $Lean.Parser.ppSpace)) $Lean.Parser.optional(node[Lean.Parser.Term.motive]("(" &"motive" " := " $Lean.Parser.withoutPosition(<term>) ")" $Lean.Parser.ppSpace)) sepBy1(node[Lean.Parser.Term.matchDiscr]($Lean.Parser.optional($ident | node[Lean.Parser.Term.hole]("_") " : ") <term>), ", ") " with " node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.syntheticHole]("?" $ident | "_") | <tactic>))))))
```

**Good generation (parses):**
```
match (motive := type_of% fun {_ : logNamedErrorAt false m.b true} : () => a) a : m,  n : b,  y : x with 
    
    | n,  m |  b |  g,  f => 
    _
```

**Failing generation:**
```
match (motive := wait_if_type_contains_mvar% ?n; Prop) `(x| y) with 
    
    | true |  x,  false,  x |  b,  h => 
    _
```

**Error:** `<input>:1:60: unknown parser `x`

---

### [tactic] Lean.Parser.Tactic.set_option — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Tactic.set_option]("set_option " $ident $Lean.Parser.optional($Lean.Parser.checkNoWsBefore "." $Lean.Parser.checkNoWsBefore $ident) $Lean.Parser.ppSpace &"true" | &"false" | $strLit | $numLit " in " <tactic>)
```

**Good generation (parses):**
```
set_option b.g false in match (motive := with_decl_name% ?m "") false,  "hello" with 
    
    | true,  a,  z |  x,  a => 
    _
```

**Failing generation:**
```
set_option a false in { 
  ;  
  
}
```

**Error:** `<input>:2:2: expected '}'`

---

### [tactic] Lean.Parser.Tactic.nestedTactic — 10/20

**Extracted grammar:**
```
node[Lean.Parser.Tactic.tacticSeqBracketed]("{ " $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.ppLine "}")
```

**Good generation (parses):**
```
{ 
  
}
```

**Failing generation:**
```
{ 
  ;  
  ;  
  
}
```

**Error:** `<input>:2:2: expected '}'`

---

### [tactic] Lean.Parser.Tactic.unknown — 0/20

**Extracted grammar:**
```
node[Lean.Parser.Tactic.unknown]($Lean.Parser.withPosition($ident $Lean.Parser.errorAtSavedPos))
```

**Failing generation:**
```
m
```

**Error:** `<input>:1:1: unknown tactic`

---

### [tactic] Lean.Parser.Tactic.introMatch — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Tactic.introMatch](&"intro" node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.syntheticHole]("?" $ident | "_") | <tactic>))))))
```

**Good generation (parses):**
```
intro
    
    | 0 => 
    _
```

**Failing generation:**
```
intro
    
    | <- return 
      .,  false => 
    _
```

**Error:** `<input>:4:6: expected '=>'`

---

### [structInstFieldDecl] Lean.Parser.Term.structInstFieldEqns — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.structInstFieldEqns]($Lean.Parser.optional("private") node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>))))))
```

**Good generation (parses):**
```


| default_or_ofNonempty%  |  leading_parser:{ "hello" with  .. } (withAnonymousAntiquot := true) "hello",  () |  m,  f => 
m
```

**Failing generation:**
```
private
    
    | let_λ  (no_implicit_lambda% `(tactic| assumption)) := false;
    false |  n => 
    b
```

**Error:** `<input>:3:14: expected '_' or identifier`

---

### [structInstFieldDecl] Lean.Parser.Term.structInstFieldDef — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.structInstFieldDef](" := " $Lean.Parser.optional("private") <term>)
```

**Good generation (parses):**
```
 := debug_assert! no_index ⟨⟩

true
```

**Failing generation:**
```
 := private binop_lazy% n { dbg_trace"test";
0,  x,  false with 
  ,  
   .. } h
```

**Error:** `<input>:3:2: expected '}'`

---

### [term] Lean.Parser.Tactic.quot — 13/20

**Extracted grammar:**
```
node[Lean.Parser.Tactic.quot]("`(tactic| " $Lean.Parser.withoutPosition(<tactic>) ")")
```

**Good generation (parses):**
```
`(tactic| open  n renaming h -> 
  g,  n -> 
  g in intro
    
    | rightact% a true 0 |  0,  m,  h => 
    _)
```

**Failing generation:**
```
`(tactic| { 
  ;  
  
})
```

**Error:** `<input>:2:2: expected '}'`

---

### [term] Lean.Parser.Term.noindex — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Term.noindex]("no_index " <term:1024>)
```

**Good generation (parses):**
```
no_index elabToSyntax% 1
```

**Failing generation:**
```
no_index for x : { 
  ,  
  ,  
   : 100 } in (),  b : "hello" in x,  z : n in m do 
  
  g; 
```

**Error:** `<input>:2:2: expected '_', '}' or identifier`

---

### [term] Lean.Parser.Term.waitIfContainsMVar — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.waitIfContainsMVar]("wait_if_contains_mvar% " "?" $Lean.Parser.checkPrec $ident "; " <term>)
```

**Good generation (parses):**
```
wait_if_contains_mvar% ?m; <- wait_if_type_mvar% ?n; sorry
```

**Failing generation:**
```
wait_if_contains_mvar% ?z; binrel_no_prop% z `(m| n) 1.5e10
```

**Error:** `<input>:1:50: unknown parser `m`

---

### [term] Lean.Parser.Term.showTermElabImpl — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.showTermElabImpl]("show_term_elab " <term>)
```

**Good generation (parses):**
```
show_term_elab for assert! let_λ  ("hello") := "hello";
  0;
a in x do 
  
  m; 
```

**Failing generation:**
```
show_term_elab binrel_no_prop% b ensure_type_of% no_error_if_unused% "hello""hello" 0 ()
```

**Error:** `<input>:1:88: unexpected end of input`

---

### [term] Lean.Parser.Term.privateDecl — 18/20

**Extracted grammar:**
```
node[Lean.Parser.Term.privateDecl]("private_decl% " <term:1024>)
```

**Good generation (parses):**
```
private_decl% ?h
```

**Failing generation:**
```
private_decl% StateRefT inferInstanceAs <| throwNamedError f true ()
```

**Error:** `<input>:1:68: unexpected end of input; expected '$'`

---

### [term] Lean.Parser.Term.termFor — 18/20

**Extracted grammar:**
```
node[Lean.Parser.Term.termFor]("for " sepBy1(node[Lean.Parser.Term.doForDecl]($Lean.Parser.optional($Lean.Parser.checkPrec $ident " : ") <term> " in " <term>), ", ") " do " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))
```

**Good generation (parses):**
```
for x : "" in private_decl% `x,  z : "hello" in () do 
  
  return x; 
```

**Failing generation:**
```
for `(b| y) in let_delayed  : Type 
    0 := false;
"hello" do {
f
}
```

**Error:** `<input>:1:9: unknown parser `b`

---

### [term] Lean.Parser.Term.assert — 12/20

**Extracted grammar:**
```
node[Lean.Parser.Term.assert]($Lean.Parser.withPosition("assert! " <term>) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
assert! <- 1;
1.5e10
```

**Failing generation:**
```
assert! unsafe leading_parser:let_mvar% ?h := x; "hello" "hello";
y
```

**Error:** `<input>:1:64: expected term`

---

### [term] Lean.Parser.Term.waitIfTypeMVar — 16/20

**Extracted grammar:**
```
node[Lean.Parser.Term.waitIfTypeMVar]("wait_if_type_mvar% " "?" $Lean.Parser.checkPrec $ident "; " <term>)
```

**Good generation (parses):**
```
wait_if_type_mvar% ?y; elabToSyntax% 0
```

**Failing generation:**
```
wait_if_type_mvar% ?b; match (motive := return 
  value_of% y) f : x,  n : () with
    
    | false |  n => 
    g
```

**Error:** `<input>:2:2: expected ')'`

---

### [term] Lean.Parser.Term.noErrorIfUnused — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Term.noErrorIfUnused]("no_error_if_unused% " <term>)
```

**Good generation (parses):**
```
no_error_if_unused% match_expr for (() : x) in 0,  n in z,  g : h in g do 
  
  x;  with
  
  | _ => a
```

**Failing generation:**
```
no_error_if_unused% let_λ  (x) : Type 
    u := false;
0
```

**Error:** `<input>:2:4: expected ':=' or '|'`

---

### [term] Lean.Parser.Term.namedPattern — 16/20

**Extracted grammar:**
```
trailing[Lean.Parser.Term.namedPattern](lhs $Lean.Parser.checkStackTop $Lean.Parser.checkNoWsBefore "@" $Lean.Parser.optional($Lean.Parser.checkPrec $ident ":") <term:1024>)
```

**Good generation (parses):**
```
f@with_decl_name% a let_delayed  : `x := "hello";
false
```

**Failing generation:**
```
a@binrel% b unless return 
  () do 
  
  return 0;  x
```

**Error:** `<input>:2:2: expected 'do'`

---

### [term] Lean.Parser.Term.let_delayed — 8/20

**Extracted grammar:**
```
node[Lean.Parser.Term.let_delayed]($Lean.Parser.withPosition("let_delayed " node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>)))))))) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
let_delayed  : wait_if_type_contains_mvar% ?a; type_of% type_of% () := "hello";
0
```

**Failing generation:**
```
let_delayed  (`(g| a)) := unop% b { 
   : x }

true
```

**Error:** `<input>:1:14: expected '_' or identifier`

---

### [term] Lean.Parser.Term.logNamedWarningMacro — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Term.logNamedWarningMacro]("logNamedWarning " $ident $Lean.Parser.optional($Lean.Parser.checkNoWsBefore "." $Lean.Parser.checkNoWsBefore $ident) $Lean.Parser.ppSpace $interpolatedStr | <term:1024>)
```

**Good generation (parses):**
```
logNamedWarning z.m logNamedErrorAt { 
   : binop_lazy% n x 0 } m.z true
```

**Failing generation:**
```
logNamedWarning b.m wait_if_contains_mvar% ?a; try 
  
  let rec @[scoped inline,  reducible,  simp]  (n) := h
  decreasing_by x; 
finally {
y
}
```

**Error:** `<input>:4:17: unknown tactic`

---

### [term] Lean.Parser.Term.forall — 10/20

**Extracted grammar:**
```
node[Lean.Parser.Term.forall]("∀" | "forall" $Lean.Parser.many1($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) ", " <term>)
```

**Good generation (parses):**
```
forall _, ``(leftact% n leftact% f x "hello" true)
```

**Failing generation:**
```
forall (_ : suffices binop% y .a () by sorry

x :=  by a), f
```

**Error:** `<input>:1:39: expected '{' or tactic`

---

### [term] Lean.Parser.Term.binop_lazy — 12/20

**Extracted grammar:**
```
node[Lean.Parser.Term.binop_lazy]("binop_lazy% " $Lean.Parser.checkPrec $ident $Lean.Parser.ppSpace <term:1024> $Lean.Parser.ppSpace <term:1024>)
```

**Good generation (parses):**
```
binop_lazy% h Sort 
  0 rightact% f true "hello"
```

**Failing generation:**
```
binop_lazy% n logNamedError a (`(g| f) :) "hello"
```

**Error:** `<input>:1:36: unknown parser `g`

---

### [term] Lean.Parser.Term.letrec — 0/20

**Extracted grammar:**
```
node[Lean.Parser.Term.letrec]($Lean.Parser.withPosition($Lean.Parser.group("let " &"rec ") node[Lean.Parser.Term.letRecDecls](sepBy1(node[Lean.Parser.Term.letRecDecl]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ")) node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>))))))) node[Lean.Parser.Termination.suffix]($Lean.Parser.optional($Lean.Parser.ppLine node[Lean.Parser.Termination.terminationBy?]("termination_by?") | node[Lean.Parser.Termination.terminationBy]("termination_by " $Lean.Parser.optional(&"structural ") $Lean.Parser.optional($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_")) " => ") <term>) | node[Lean.Parser.Termination.partialFixpoint]($Lean.Parser.withPosition("partial_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.coinductiveFixpoint]($Lean.Parser.withPosition("coinductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.inductiveFixpoint]($Lean.Parser.withPosition("inductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>)))) $Lean.Parser.optional(node[Lean.Parser.Termination.decreasingBy]($Lean.Parser.ppLine "decreasing_by " <tactic>)))), ", "))) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Failing generation:**
```
let rec /-- doc comment text -/
 : unreachable! := dbg_trace"test";
set_option b.m false in 0
decreasing_by skip,  /-- doc comment text -/
 : true := y
decreasing_by m

m
```

**Error:** `<input>:4:15: unknown tactic`

---

### [term] Lean.Parser.Term.unop — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Term.unop]("unop% " $Lean.Parser.checkPrec $ident $Lean.Parser.ppSpace <term:1024>)
```

**Good generation (parses):**
```
unop% m ``x
```

**Failing generation:**
```
unop% f with_decl_name% ?x throwNamedErrorAt letI  +postponeValue : () := "hello";
"hello" b.x b
```

**Error:** `<input>:2:13: unexpected end of input; expected identifier`

---

### [term] Lean.Parser.Term.ensureExpectedType — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Term.ensureExpectedType]("ensure_expected_type% " $strLit $Lean.Parser.ppSpace <term:1024>)
```

**Good generation (parses):**
```
ensure_expected_type% "test" .
```

**Failing generation:**
```
ensure_expected_type% "test" ⟨let_expr m@f := throwNamedErrorAt true n x
     | 0;
n⟩
```

**Error:** `<input>:2:5: expected checkColGt`

---

### [term] Lean.Parser.Term.unsafe — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.unsafe]("unsafe " <term>)
```

**Good generation (parses):**
```
unsafe letI  +postponeValue : for ``x in false do {
  return x
  } := 0;
h
```

**Failing generation:**
```
unsafe with_decl_name% ?z by trivial
```

**Error:** `<input>:1:30: unknown tactic`

---

### [term] Lean.Parser.Term.ensureTypeOf — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.ensureTypeOf]("ensure_type_of% " <term:1024> $strLit $Lean.Parser.ppSpace <term>)
```

**Good generation (parses):**
```
ensure_type_of% ``(logNamedErrorAt rightact% g 0 true a x)"world" x
```

**Failing generation:**
```
ensure_type_of% no_implicit_lambda% unless logNamedErrorAt 0 x.z x do 
  
  return x; "hello" n
```

**Error:** `<input>:3:21: unexpected end of input; expected string literal`

---

### [term] Lean.Parser.Term.forInMacro' — 8/20

**Extracted grammar:**
```
node[Lean.Parser.Term.forInMacro']("for_in'% " <term:1024> <term:1024> $Lean.Parser.ppSpace <term:1024>)
```

**Good generation (parses):**
```
for_in'% .logNamedWarningAt Sort n x "hello"
```

**Failing generation:**
```
for_in'% _binrel% g binrel_no_prop% x 0 x false x
```

**Error:** `<input>:1:16: expected token`

---

### [term] Lean.Parser.Term.waitIfTypeContainsMVar — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.waitIfTypeContainsMVar]("wait_if_type_contains_mvar% " "?" $Lean.Parser.checkPrec $ident "; " <term>)
```

**Good generation (parses):**
```
wait_if_type_contains_mvar% ?h; Prop
```

**Failing generation:**
```
wait_if_type_contains_mvar% ?z; `(m| y)
```

**Error:** `<input>:1:37: unknown parser `m`

---

### [term] Lean.Parser.Term.proj — 18/20

**Extracted grammar:**
```
trailing[Lean.Parser.Term.proj](lhs $Lean.Parser.checkNoWsBefore "." $Lean.Parser.checkNoWsBefore $numLit | $ident)
```

**Good generation (parses):**
```
n.100
```

**Failing generation:**
```
y.0
```

**Error:** `<input>:1:2: expected end of input`

---

### [term] Lean.Parser.Term.clear — 16/20

**Extracted grammar:**
```
node[Lean.Parser.Term.clear]("clear% " $Lean.Parser.checkPrec $ident ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
clear% b

value_of% a
```

**Failing generation:**
```
clear% y;
fun {_ : let_delayed  : let rec @[scoped inline,  reducible]  (false) := n
    decreasing_by b,  /-- doc comment text -/
     : x := a
    decreasing_by z
  
  b := h;
n} => f
```

**Error:** `<input>:3:18: expected '{' or indented tactic sequence`

---

### [term] Lean.Parser.Term.termReturn — 10/20

**Extracted grammar:**
```
node[Lean.Parser.Term.termReturn]($Lean.Parser.withPosition("return" $Lean.Parser.optional($Lean.Parser.ppSpace $Lean.Parser.checkLineEq <term>)))
```

**Good generation (parses):**
```
return
```

**Failing generation:**
```
return 
Prop
```

**Error:** `<input>:2:0: expected end of input`

---

### [term] Lean.Parser.Term.matchExpr — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Term.matchExpr]("match_expr " <term> " with" node[Lean.Parser.Term.matchExprAlts]($Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.ppLine $Lean.Parser.checkColGe $Lean.Parser.checkPrec node[Lean.Parser.Term.matchExprAlt]("| " node[Lean.Parser.Term.matchExprPat]($Lean.Parser.optional($Lean.Parser.checkPrec $ident "@") $Lean.Parser.checkPrec $ident $Lean.Parser.many($ident | node[Lean.Parser.Term.hole]("_"))) " => " <term>)) $Lean.Parser.ppLine $Lean.Parser.checkColGe node[Lean.Parser.Term.matchExprElseAlt]("| " node[Lean.Parser.Term.hole]("_") " => " <term>))))
```

**Good generation (parses):**
```
match_expr for unsafe `(#check 0) in x,  m : "hello" in m do 
  
  g;  with
  
  | _ => a
```

**Failing generation:**
```
match_expr let_expr g@f := ()
     | { 
    ,  
    ,  
     : true }

true with
  
  | y => 0
  
  | _ => m
```

**Error:** `<input>:2:5: expected checkColGt`

---

### [term] Lean.Parser.Term.pipeProj — 16/20

**Extracted grammar:**
```
trailing[Lean.Parser.Term.pipeProj](lhs " |>." $Lean.Parser.checkNoWsBefore $numLit | $ident $Lean.Parser.many($Lean.Parser.checkWsBefore $Lean.Parser.checkColGt node[Lean.Parser.Term.namedArgument]("(" $Lean.Parser.checkPrec $ident " := " $Lean.Parser.withoutPosition(<term>) ")") | node[Lean.Parser.Term.ellipsis](".." $Lean.Parser.checkPrec) | <term:1023>))
```

**Good generation (parses):**
```
f |>.42
```

**Failing generation:**
```
b |>.m 
  (a := binop% a ensure_type_of% elabToSyntax% 42"test" true false)
```

**Error:** `<input>:2:66: expected term`

---

### [term] Lean.Parser.Term.inferInstanceAs — 13/20

**Extracted grammar:**
```
node[Lean.Parser.Term.inferInstanceAs]("inferInstanceAs" " $ " | " <| " <term:10> | $Lean.Parser.ppSpace <term:1023>)
```

**Good generation (parses):**
```
inferInstanceAs <| throwNamedError a (binrel% f () false, "hello",  z,  f)
```

**Failing generation:**
```
inferInstanceAs ``(`(g| n))
```

**Error:** `<input>:1:24: unknown parser `g`

---

### [term] Lean.Parser.Term.panic — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.panic]("panic! " <term>)
```

**Good generation (parses):**
```
panic! ⋯
```

**Failing generation:**
```
panic! let +postponeValue : Type 
    a := x

true
```

**Error:** `<input>:2:4: expected ':=' or '|'`

---

### [term] Lean.Parser.Term.match — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.match]("match " $Lean.Parser.optional(node[Lean.Parser.Term.generalizingParam]("(" &"generalizing" " := " node[Lean.Parser.Term.trueVal](&"true") | node[Lean.Parser.Term.falseVal](&"false") ")" $Lean.Parser.ppSpace)) $Lean.Parser.optional(node[Lean.Parser.Term.motive]("(" &"motive" " := " $Lean.Parser.withoutPosition(<term>) ")" $Lean.Parser.ppSpace)) sepBy1(node[Lean.Parser.Term.matchDiscr]($Lean.Parser.optional($ident | node[Lean.Parser.Term.hole]("_") " : ") <term>), ", ") " with" node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>))))))
```

**Good generation (parses):**
```
match (motive := @unop% g private_decl% x) "hello",  false with
    
    | x,  y,  x |  b,  n,  m => 
    y
```

**Failing generation:**
```
match (generalizing := true) (motive := show throwNamedErrorAt value_of% h x.b true by assumption) "hello",  y,  f with
    
    | b,  f,  x => 
    f
```

**Error:** `<input>:1:88: unknown tactic`

---

### [term] Lean.Parser.Term.logNamedErrorMacro — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Term.logNamedErrorMacro]("logNamedError " $ident $Lean.Parser.optional($Lean.Parser.checkNoWsBefore "." $Lean.Parser.checkNoWsBefore $ident) $Lean.Parser.ppSpace $interpolatedStr | <term:1024>)
```

**Good generation (parses):**
```
logNamedError y default_or_ofNonempty% unsafe
```

**Failing generation:**
```
logNamedError x.g `(y| x)
```

**Error:** `<input>:1:23: unknown parser `y`

---

### [term] Lean.Parser.Term.subst — 17/20

**Extracted grammar:**
```
trailing[Lean.Parser.Term.subst](lhs " ▸ " sepBy1(<term:75>, " ▸ "))
```

**Good generation (parses):**
```
a ▸ assert! logNamedError n ((), x,  0);
n
```

**Failing generation:**
```
h ▸ by set_option h false in trivial
```

**Error:** `<input>:1:30: unknown tactic`

---

### [term] Lean.Parser.Term.set_option — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.set_option]("set_option " $ident $Lean.Parser.optional($Lean.Parser.checkNoWsBefore "." $Lean.Parser.checkNoWsBefore $ident) $Lean.Parser.ppSpace &"true" | &"false" | $strLit | $numLit " in " <term>)
```

**Good generation (parses):**
```
set_option h false in match (motive := do 
  
  break; ) f : () with
    
    | false,  x,  f |  f,  m |  b,  f => 
    g
```

**Failing generation:**
```
set_option z.x false in (_ : no_index logNamedErrorAt () y true :=  by assumption) -> z
```

**Error:** `<input>:1:72: unknown tactic`

---

### [term] Lean.Parser.Term.noImplicitLambda — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.noImplicitLambda]("no_implicit_lambda% " <term:1024>)
```

**Good generation (parses):**
```
no_implicit_lambda% fun {_ : wait_if_type_contains_mvar% ?y; `x} : true => 0
```

**Failing generation:**
```
no_implicit_lambda% binrel% a haveI  +postponeValue : show_term_elab false := x

() y
```

**Error:** `<input>:3:4: unexpected end of input`

---

### [term] Lean.Parser.Term.letExpr — 10/20

**Extracted grammar:**
```
node[Lean.Parser.Term.letExpr]($Lean.Parser.withPosition("let_expr " node[Lean.Parser.Term.matchExprPat]($Lean.Parser.optional($Lean.Parser.checkPrec $ident "@") $Lean.Parser.checkPrec $ident $Lean.Parser.many($ident | node[Lean.Parser.Term.hole]("_"))) " := " <term> $Lean.Parser.checkColGt " | " <term>) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
let_expr f := match (motive := have +postponeValue : binop_lazy% h x "hello" := x

g) h,  f,  n with
    
    | b,  f |  a |  y,  g,  a => 
    g
   | y;
f
```

**Failing generation:**
```
let_expr y := `(x| f)
   | ensure_expected_type% "world" leftact% a () false;
"hello"
```

**Error:** `<input>:1:19: unknown parser `x`

---

### [term] Lean.Parser.Term.letMVar — 12/20

**Extracted grammar:**
```
node[Lean.Parser.Term.letMVar]("let_mvar% " "?" $Lean.Parser.checkPrec $ident " := " <term> "; " <term>)
```

**Good generation (parses):**
```
let_mvar% ?n := `(no_implicit_lambda% decl_name%); 0
```

**Failing generation:**
```
let_mvar% ?g := no_error_if_unused% let_expr z@h := let_mvar% ?x := "hello"; true
     | 0;
a; m
```

**Error:** `<input>:2:5: expected checkColGt`

---

### [term] Lean.Parser.Term.leftact — 10/20

**Extracted grammar:**
```
node[Lean.Parser.Term.leftact]("leftact% " $Lean.Parser.checkPrec $ident $Lean.Parser.ppSpace <term:1024> $Lean.Parser.ppSpace <term:1024>)
```

**Good generation (parses):**
```
leftact% z nofun rightact% y unop% a () "hello"
```

**Failing generation:**
```
leftact% h h `(tactic| rfl)
```

**Error:** `<input>:1:24: unknown tactic`

---

### [term] Lean.Parser.Term.forInMacro — 12/20

**Extracted grammar:**
```
node[Lean.Parser.Term.forInMacro]("for_in% " <term:1024> <term:1024> $Lean.Parser.ppSpace <term:1024>)
```

**Good generation (parses):**
```
for_in% 42 logNamedErrorAt binop% b false () n x h
```

**Failing generation:**
```
for_in% value_of% b with_decl_name% a do 
  
  return x;  ()
```

**Error:** `<input>:3:15: unexpected end of input`

---

### [term] Lean.Parser.Term.withDeclName — 18/20

**Extracted grammar:**
```
node[Lean.Parser.Term.withDeclName]("with_decl_name% " $Lean.Parser.optional("?") $Lean.Parser.checkPrec $ident $Lean.Parser.ppSpace <term>)
```

**Good generation (parses):**
```
with_decl_name% ?z ``x
```

**Failing generation:**
```
with_decl_name% ?x by open  h renaming h -> 
  m,  y -> 
  x in trivial
```

**Error:** `<input>:2:2: expected checkColGt`

---

### [term] Lean.Parser.Tactic.quotSeq — 5/20

**Extracted grammar:**
```
node[Lean.Parser.Tactic.quotSeq]("`(tactic| " $Lean.Parser.withoutPosition(node[Lean.Parser.Tactic.seq1](sepBy1(<tactic>, ";
",trailing))) ")")
```

**Good generation (parses):**
```
`(tactic| set_option h false in intro
    
    | let_delayed  : () := 0;
    0 |  a,  b,  n |  n => 
    _)
```

**Failing generation:**
```
`(tactic| set_option n false in intro
    
    | show_term_elab false,  true |  (),  a,  m => 
    ?_;
 z)
```

**Error:** `<input>:5:1: expected ')'`

---

### [term] Lean.Parser.Term.letI — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.letI]($Lean.Parser.withPosition("letI " node[Lean.Parser.Term.letConfig]($Lean.Parser.many(node[Lean.Parser.Term.letPosOpt](" +" $Lean.Parser.checkNoWsBefore node[Lean.Parser.Term.letOpts](node[Lean.Parser.Term.letOptNondep](&"nondep") | node[Lean.Parser.Term.letOptPostponeValue](&"postponeValue") | node[Lean.Parser.Term.letOptUsedOnly](&"usedOnly") | node[Lean.Parser.Term.letOptZeta](&"zeta") | node[Lean.Parser.Term.letOptGeneralize](&"generalize"))) | node[Lean.Parser.Term.letNegOpt](" -" $Lean.Parser.checkNoWsBefore node[Lean.Parser.Term.letOpts](node[Lean.Parser.Term.letOptNondep](&"nondep") | node[Lean.Parser.Term.letOptPostponeValue](&"postponeValue") | node[Lean.Parser.Term.letOptUsedOnly](&"usedOnly") | node[Lean.Parser.Term.letOptZeta](&"zeta") | node[Lean.Parser.Term.letOptGeneralize](&"generalize"))) | node[Lean.Parser.Term.letOptEq](" (" &"eq" " := " $ident | node[Lean.Parser.Term.hole]("_") ")"))) node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>)))))))) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
letI  : show_term_elab x := set_option z.m false in "hello";
"hello"
```

**Failing generation:**
```
letI  +postponeValue : let_expr z@n := let_tmp  (private_decl% x) : true := 0;
  n
     | b

m := a;
a
```

**Error:** `<input>:3:5: expected checkColGt`

---

### [term] Lean.Parser.Term.stateRefT — 12/20

**Extracted grammar:**
```
node[Lean.Parser.Term.stateRefT]("StateRefT " <term:1024> $Lean.Parser.ppSpace node[Lean.Parser.Term.macroDollarArg]("$" <term:10>) | <term:1024>)
```

**Good generation (parses):**
```
StateRefT binop% g { 
   : no_index false } x ()
```

**Failing generation:**
```
StateRefT let_mvar% ?h := binop% a binrel% h true 0 (); y $f
```

**Error:** `<input>:1:60: unexpected end of input; expected '$'`

---

### [term] Lean.Parser.Term.trailing_parser — 11/20

**Extracted grammar:**
```
node[Lean.Parser.Term.trailing_parser]("trailing_parser" $Lean.Parser.optional(":" <term:1024>) $Lean.Parser.optional(":" <term:1024>) $Lean.Parser.ppSpace <term>)
```

**Good generation (parses):**
```
trailing_parser:decl_name%:`(wait_if_contains_mvar% ?g; 0) ()
```

**Failing generation:**
```
trailing_parser:letI  +postponeValue : rightact% y `(tactic| sorry) true := "hello";
a m
```

**Error:** `<input>:1:61: expected tactic`

---

### [term] Lean.Parser.Term.explicit — 16/20

**Extracted grammar:**
```
node[Lean.Parser.Term.explicit]("@" <term:1024>)
```

**Good generation (parses):**
```
@Prop
```

**Failing generation:**
```
@for x : by trivial in 0,  false in (),  m : y in x do 
  
  x; 
```

**Error:** `<input>:1:13: unknown tactic`

---

### [term] Lean.Parser.Term.open — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Term.open]("open" node[Lean.Parser.Command.openHiding]($Lean.Parser.ppSpace $ident " hiding" $Lean.Parser.many1($Lean.Parser.ppSpace $Lean.Parser.checkColGt $ident)) | node[Lean.Parser.Command.openRenaming]($Lean.Parser.ppSpace $ident " renaming " sepBy1(node[Lean.Parser.Command.openRenamingItem]($ident " → " | " -> " $Lean.Parser.checkColGt $ident), ", ")) | node[Lean.Parser.Command.openOnly]($Lean.Parser.ppSpace $ident " (" $Lean.Parser.many1($ident) ")") | node[Lean.Parser.Command.openSimple]($Lean.Parser.many1($Lean.Parser.ppSpace $Lean.Parser.checkColGt $ident)) | node[Lean.Parser.Command.openScoped](" scoped" $Lean.Parser.many1($Lean.Parser.ppSpace $Lean.Parser.checkColGt $ident)) " in " <term>)
```

**Good generation (parses):**
```
open y renaming a -> 
  b in set_option x.g false in assert! nofun

()
```

**Failing generation:**
```
open h renaming a -> 
  g in { 
  ,  
  ,  
   : `(throwNamedErrorAt () n ()) }
```

**Error:** `<input>:3:2: expected '_', '}' or identifier`

---

### [term] Lean.Parser.Term.show — 8/20

**Extracted grammar:**
```
node[Lean.Parser.Term.show]("show " <term> $Lean.Parser.ppSpace node[Lean.Parser.Term.fromTerm]("from " <term>) | node[Lean.Parser.Term.byTactic']("by " <tactic>))
```

**Good generation (parses):**
```
show throwNamedError h binrel% n ⟨x⟩ false from "hello"
```

**Failing generation:**
```
show "" by open  y renaming n -> 
  z,  y -> 
  b in trivial
```

**Error:** `<input>:2:2: expected checkColGt`

---

### [term] Lean.Parser.Term.precheckedQuot — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Term.precheckedQuot]("`" node[Lean.Parser.Term.quot]("`(" $Lean.Parser.withoutPosition(<term>) ")"))
```

**Good generation (parses):**
```
``(())
```

**Failing generation:**
```
``(let rec @[scoped tactic_name n,  default_instance]  : x := "hello"
  decreasing_by rfl

z)
```

**Error:** `<input>:2:17: unknown tactic`

---

### [term] Lean.Parser.Term.logNamedErrorAtMacro — 10/20

**Extracted grammar:**
```
node[Lean.Parser.Term.logNamedErrorAtMacro]("logNamedErrorAt " <term:1024> $Lean.Parser.ppSpace $ident $Lean.Parser.optional($Lean.Parser.checkNoWsBefore "." $Lean.Parser.checkNoWsBefore $ident) $Lean.Parser.ppSpace $interpolatedStr | <term:1024>)
```

**Good generation (parses):**
```
logNamedErrorAt unop% h no_index () a true
```

**Failing generation:**
```
logNamedErrorAt `(b| h) b.g `(tactic| trivial)
```

**Error:** `<input>:1:21: unknown parser `b`

---

### [term] Lean.Parser.Term.binop — 10/20

**Extracted grammar:**
```
node[Lean.Parser.Term.binop]("binop% " $Lean.Parser.checkPrec $ident $Lean.Parser.ppSpace <term:1024> $Lean.Parser.ppSpace <term:1024>)
```

**Good generation (parses):**
```
binop% f ensure_expected_type% "world" binop% h logNamedError f () "hello" ()
```

**Failing generation:**
```
binop% y no_error_if_unused% unsafe no_index "hello" ()
```

**Error:** `<input>:1:55: unexpected end of input`

---

### [term] Lean.Parser.Term.logNamedWarningAtMacro — 11/20

**Extracted grammar:**
```
node[Lean.Parser.Term.logNamedWarningAtMacro]("logNamedWarningAt " <term:1024> $Lean.Parser.ppSpace $ident $Lean.Parser.optional($Lean.Parser.checkNoWsBefore "." $Lean.Parser.checkNoWsBefore $ident) $Lean.Parser.ppSpace $interpolatedStr | <term:1024>)
```

**Good generation (parses):**
```
logNamedWarningAt 'a' m.b `x
```

**Failing generation:**
```
logNamedWarningAt no_implicit_lambda% clear% h;
"" f x
```

**Error:** `<input>:2:6: unexpected end of input; expected identifier`

---

### [term] Lean.Parser.Command.quot — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Command.quot]("`(" $Lean.Parser.withoutPosition(<command>) ")")
```

**Good generation (parses):**
```
`(#version)
```

**Failing generation:**
```
`(/-- doc comment text -/
private protected unsafe def n _y)
```

**Error:** `<input>:2:33: expected ':=', 'where' or '|'`

---

### [term] Lean.Parser.Term.debugAssert — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.debugAssert]($Lean.Parser.withPosition("debug_assert! " <term>) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
debug_assert! let_tmp  (1.5e10) := ()

true

()
```

**Failing generation:**
```
debug_assert! let rec @[scoped default_instance]  : for 0 in x,  b : false in x,  b : f in m do 
    
    x;  := g
  termination_by?
  decreasing_by x

b

g
```

**Error:** `<input>:5:17: unknown tactic`

---

### [term] Lean.Parser.Term.termUnless — 12/20

**Extracted grammar:**
```
node[Lean.Parser.Term.termUnless]("unless " <term> " do " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))
```

**Good generation (parses):**
```
unless `(#version) do {
try {
pure ()
}
catch _ => 
  
  return x; ; 
}
```

**Failing generation:**
```
unless haveI  : let rec @[scoped tactic_name a,  inline]  (false) := 0
    decreasing_by x,  /-- doc comment text -/
     : g := n
    decreasing_by x
  
  g := h;
n do {
n
}
```

**Error:** `<input>:2:19: unknown tactic`

---

### [term] Lean.Parser.Term.binrel — 10/20

**Extracted grammar:**
```
node[Lean.Parser.Term.binrel]("binrel% " $Lean.Parser.checkPrec $ident $Lean.Parser.ppSpace <term:1024> $Lean.Parser.ppSpace <term:1024>)
```

**Good generation (parses):**
```
binrel% h elabToSyntax% 2 ensure_type_of% private_decl% true"world" true
```

**Failing generation:**
```
binrel% g throwNamedErrorAt Type 
  (1) z.g x false
```

**Error:** `<input>:2:2: expected identifier`

---

### [term] Lean.Parser.Term.quot — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Term.quot]("`(" $Lean.Parser.withoutPosition(<term>) ")")
```

**Good generation (parses):**
```
`(match (motive := logNamedError f StateRefT false $false) n : () with
    
    | h,  z,  f |  a,  z |  m,  y => 
    x)
```

**Failing generation:**
```
`(by set_option y false in rfl)
```

**Error:** `<input>:1:28: unknown tactic`

---

### [term] Lean.Parser.Term.structInst — 8/20

**Extracted grammar:**
```
node[Lean.Parser.Term.structInst]("{ " $Lean.Parser.withoutPosition($Lean.Parser.optional(sepBy1(<term>, ", ") " with ") node[Lean.Parser.Term.structInstFields]($Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, ", ",trailing))) node[Lean.Parser.Term.optEllipsis]($Lean.Parser.optional(" ..")) $Lean.Parser.optional(" : " <term>)) " }")
```

**Good generation (parses):**
```
{ ⋯ with  .. }
```

**Failing generation:**
```
{ 
  ,  
  ,  
   : `(let_mvar% ?m := ⋯; ()) }
```

**Error:** `<input>:2:2: expected '_', '}' or identifier`

---

### [term] Lean.Parser.Term.leading_parser — 13/20

**Extracted grammar:**
```
node[Lean.Parser.Term.leading_parser]("leading_parser" $Lean.Parser.optional(":" <term:1024>) $Lean.Parser.optional(node[Lean.Parser.Term.withAnonymousAntiquot](" (" &"withAnonymousAntiquot" " := " node[Lean.Parser.Term.trueVal](&"true") | node[Lean.Parser.Term.falseVal](&"false") ")")) $Lean.Parser.ppSpace <term>)
```

**Good generation (parses):**
```
leading_parser (withAnonymousAntiquot := true) set_option b.m false in fun {_ : StateRefT false $"hello"} => false
```

**Failing generation:**
```
leading_parser:try 
  
   (`x) : x := 0
catch _ => 
  
  pure ();  (withAnonymousAntiquot := true) f
```

**Error:** `<input>:6:35: expected ')', ',' or ':'`

---

### [term] Lean.Parser.Term.let_tmp — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.let_tmp]($Lean.Parser.withPosition("let_tmp " node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>)))))))) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
let_tmp  (let_mvar% ?x := dbg_trace"test";
⋯; ()) : () := false;
n
```

**Failing generation:**
```
let_tmp  : show .m by sorry := 0;
0
```

**Error:** `<input>:1:22: expected '{' or tactic`

---

### [term] Lean.Parser.Term.depArrow — 11/20

**Extracted grammar:**
```
node[Lean.Parser.Term.depArrow](node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]") " → " | " -> " <term>)
```

**Good generation (parses):**
```
⦃f : logNamedError a ensure_type_of% for_in'% x false ()"test" b⦄ -> x
```

**Failing generation:**
```
(_ : unless let_tmp  (unop% m "hello") := false;
0 do {
n
} :=  by f) -> g
```

**Error:** `<input>:4:10: unknown tactic`

---

### [term] Lean.Parser.Term.rightact — 9/20

**Extracted grammar:**
```
node[Lean.Parser.Term.rightact]("rightact% " $Lean.Parser.checkPrec $ident $Lean.Parser.ppSpace <term:1024> $Lean.Parser.ppSpace <term:1024>)
```

**Good generation (parses):**
```
rightact% g unop% m "" ``m
```

**Failing generation:**
```
rightact% h ``n with_decl_name% ?x `(tactic| sorry;
 rfl;
 rfl)
```

**Error:** `<input>:1:45: expected tactic`

---

### [term] Lean.Parser.Term.inaccessible — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Term.inaccessible](".(" $Lean.Parser.withoutPosition(<term>) ")")
```

**Good generation (parses):**
```
.((leftact% f for_in% 0() "hello" x))
```

**Failing generation:**
```
.(have +postponeValue : . := `(x| f);
0)
```

**Error:** `<input>:1:34: unknown parser `x`

---

### [term] Lean.Parser.Term.throwNamedErrorMacro — 18/20

**Extracted grammar:**
```
node[Lean.Parser.Term.throwNamedErrorMacro]("throwNamedError " $ident $Lean.Parser.optional($Lean.Parser.checkNoWsBefore "." $Lean.Parser.checkNoWsBefore $ident) $Lean.Parser.ppSpace $interpolatedStr | <term:1024>)
```

**Good generation (parses):**
```
throwNamedError y wait_if_contains_mvar% ?a; 'a'
```

**Failing generation:**
```
throwNamedError x.z ⟨wait_if_type_contains_mvar% ?y; let_expr x@a := 0
     | true

x,  h,  x⟩
```

**Error:** `<input>:2:5: expected checkColGt`

---

### [term] Lean.Parser.Term.dynamicQuot — 0/20

**Extracted grammar:**
```
$Lean.Parser.withoutPosition(node[Lean.Parser.Term.dynamicQuot]("`(" $Lean.Parser.checkPrec $ident "| " $Lean.Parser.rawToken ")"))
```

**Failing generation:**
```
`(g| a)
```

**Error:** `<input>:1:5: unknown parser `g`

---

### [term] Lean.Parser.Term.let_fun — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.let_fun]($Lean.Parser.withPosition("let_fun " | "let_λ " node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>)))))))) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
let_λ  (private_decl% Sort 
  (1)) := false;
false
```

**Failing generation:**
```
let_λ  (let_mvar% ?z := (let_expr x@y := "hello"
     | true

true); n) := h;
a
```

**Error:** `<input>:1:8: expected '_' or identifier`

---

### [term] Lean.Parser.Term.haveI — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.haveI]($Lean.Parser.withPosition("haveI " node[Lean.Parser.Term.letConfig]($Lean.Parser.many(node[Lean.Parser.Term.letPosOpt](" +" $Lean.Parser.checkNoWsBefore node[Lean.Parser.Term.letOpts](node[Lean.Parser.Term.letOptNondep](&"nondep") | node[Lean.Parser.Term.letOptPostponeValue](&"postponeValue") | node[Lean.Parser.Term.letOptUsedOnly](&"usedOnly") | node[Lean.Parser.Term.letOptZeta](&"zeta") | node[Lean.Parser.Term.letOptGeneralize](&"generalize"))) | node[Lean.Parser.Term.letNegOpt](" -" $Lean.Parser.checkNoWsBefore node[Lean.Parser.Term.letOpts](node[Lean.Parser.Term.letOptNondep](&"nondep") | node[Lean.Parser.Term.letOptPostponeValue](&"postponeValue") | node[Lean.Parser.Term.letOptUsedOnly](&"usedOnly") | node[Lean.Parser.Term.letOptZeta](&"zeta") | node[Lean.Parser.Term.letOptGeneralize](&"generalize"))) | node[Lean.Parser.Term.letOptEq](" (" &"eq" " := " $ident | node[Lean.Parser.Term.hole]("_") ")"))) node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>)))))))) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
haveI  : 0 := nofun

binop% f true 0
```

**Failing generation:**
```
haveI  +postponeValue : suffices show_term_elab ``b by sorry

() := "hello";
a
```

**Error:** `<input>:1:55: expected '{' or tactic`

---

### [term] Lean.Parser.Term.do — 16/20

**Extracted grammar:**
```
node[Lean.Parser.Term.do]($Lean.Parser.ppAllowUngrouped "do " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))
```

**Good generation (parses):**
```
do 
  
  match_expr (meta := false) ensure_type_of% throwNamedErrorAt true y x"world" true with
    
    | h => 
      
      m; 
    
    | _ => {
    a
    }; 
```

**Failing generation:**
```
do {
do {
for g : `(tactic| trivial) in false,  false in m,  g : h in b do 
  
  g; 
}; 
}
```

**Error:** `<input>:3:19: unknown tactic`

---

### [term] Lean.Parser.Term.arrow — 19/20

**Extracted grammar:**
```
trailing[Lean.Parser.Term.arrow](lhs $Lean.Parser.checkPrec " → " | " -> " <term:25>)
```

**Good generation (parses):**
```
b -> throwNamedError m.m throwNamedError n throwNamedErrorAt "hello" x.b ()
```

**Failing generation:**
```
z -> let_expr n := for_in% `(tactic| trivial)"hello" x
     | n;
y
```

**Error:** `<input>:1:38: unknown tactic`

---

### [term] Lean.Parser.Term.typeAscription — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Term.typeAscription](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term> " :" $Lean.Parser.optional($Lean.Parser.ppSpace <term>)) ")")
```

**Good generation (parses):**
```
(do 
  
  let mut 42 := x
   | 
    
    return x
  
  
  pure ();  : z)
```

**Failing generation:**
```
(dbg_trace"test";
for_in% `(tactic| sorry)"hello" () : b)
```

**Error:** `<input>:2:18: expected tactic`

---

### [term] Lean.Parser.Term.have — 16/20

**Extracted grammar:**
```
node[Lean.Parser.Term.have]($Lean.Parser.withPosition("have" node[Lean.Parser.Term.letConfig]($Lean.Parser.many(node[Lean.Parser.Term.letPosOpt](" +" $Lean.Parser.checkNoWsBefore node[Lean.Parser.Term.letOpts](node[Lean.Parser.Term.letOptNondep](&"nondep") | node[Lean.Parser.Term.letOptPostponeValue](&"postponeValue") | node[Lean.Parser.Term.letOptUsedOnly](&"usedOnly") | node[Lean.Parser.Term.letOptZeta](&"zeta") | node[Lean.Parser.Term.letOptGeneralize](&"generalize"))) | node[Lean.Parser.Term.letNegOpt](" -" $Lean.Parser.checkNoWsBefore node[Lean.Parser.Term.letOpts](node[Lean.Parser.Term.letOptNondep](&"nondep") | node[Lean.Parser.Term.letOptPostponeValue](&"postponeValue") | node[Lean.Parser.Term.letOptUsedOnly](&"usedOnly") | node[Lean.Parser.Term.letOptZeta](&"zeta") | node[Lean.Parser.Term.letOptGeneralize](&"generalize"))) | node[Lean.Parser.Term.letOptEq](" (" &"eq" " := " $ident | node[Lean.Parser.Term.hole]("_") ")"))) node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>)))))))) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
have +postponeValue : `(debug_assert! for false in x do 
    
    pure (); ;
h) := z

m
```

**Failing generation:**
```
have : suffices 'a' by skip

() := "hello";
false
```

**Error:** `<input>:1:24: unknown tactic`

---

### [term] Lean.Parser.Term.anonymousCtor — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Term.anonymousCtor]("⟨" $Lean.Parser.withoutPosition(sepBy(<term>, ", ",trailing)) "⟩")
```

**Good generation (parses):**
```
⟨inferInstanceAs <| for haveI  : () := "hello";
0 in m,  g : f in b do 
  
  b; ,  z⟩
```

**Failing generation:**
```
⟨rightact% f with_decl_name% ?m inferInstanceAs <| true false,  true,  f⟩
```

**Error:** `<input>:1:61: expected term`

---

### [term] Lean.Parser.Term.suffices — 7/20

**Extracted grammar:**
```
node[Lean.Parser.Term.suffices]($Lean.Parser.withPosition("suffices " node[Lean.Parser.Term.sufficesDecl]($Lean.Parser.group($ident | node[Lean.Parser.Term.hole]("_") " : ") | $Lean.Parser.checkPrec <term> $Lean.Parser.ppSpace node[Lean.Parser.Term.fromTerm]("from " <term>) | node[Lean.Parser.Term.byTactic']("by " <tactic>))) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
suffices _ : binop% a default_or_ofNonempty% unsafe private_decl% false from false;
false
```

**Failing generation:**
```
suffices type_of% logNamedError b.x _ by sorry

true
```

**Error:** `<input>:1:41: expected '{' or tactic`

---

### [term] Lean.Parser.Term.fun — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Term.fun]($Lean.Parser.ppAllowUngrouped "λ" | "fun" node[Lean.Parser.Term.basicFun]($Lean.Parser.many1($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | $Lean.Parser.checkPrec node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]") | <term:1024>) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " ↦" | " =>" $Lean.Parser.ppSpace <term>) | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>))))))
```

**Good generation (parses):**
```
fun
   
   | unless b do 
     
     () <- pure (); ,  () |  z,  y,  m |  x,  a,  m => 
   h
```

**Failing generation:**
```
fun
   
   | 'a' |  .,  `(tactic| assumption),  "hello" => 
   ()
```

**Error:** `<input>:3:27: unknown tactic`

---

### [term] Lean.Parser.Term.liftMethod — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Term.liftMethod]("← " | "<- " <term>)
```

**Good generation (parses):**
```
<- match (motive := ensure_type_of% throwNamedError b.x true"world" ()) false,  a with
    
    | x,  a,  x |  g,  h |  y,  m,  f => 
    x
```

**Failing generation:**
```
<- `(tactic| intro
    
    | wait_if_type_contains_mvar% ?f; true => 
    ?_;
 trivial;
 trivial)
```

**Error:** `<input>:5:2: unknown tactic`

---

### [term] Lean.Parser.Term.typeOf — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Term.typeOf]("type_of% " <term:1024>)
```

**Good generation (parses):**
```
type_of% no_implicit_lambda% Prop
```

**Failing generation:**
```
type_of% `(m| a)
```

**Error:** `<input>:1:14: unknown parser `m`

---

### [term] Lean.Parser.Term.binrel_no_prop — 13/20

**Extracted grammar:**
```
node[Lean.Parser.Term.binrel_no_prop]("binrel_no_prop% " $Lean.Parser.checkPrec $ident $Lean.Parser.ppSpace <term:1024> $Lean.Parser.ppSpace <term:1024>)
```

**Good generation (parses):**
```
binrel_no_prop% b .(ensure_type_of% logNamedWarning b.g ()"world" ()) false
```

**Failing generation:**
```
binrel_no_prop% g binrel% m () clear% m

true "hello"
```

**Error:** `<input>:3:12: unexpected end of input`

---

### [term] Lean.Parser.Term.throwNamedErrorAtMacro — 11/20

**Extracted grammar:**
```
node[Lean.Parser.Term.throwNamedErrorAtMacro]("throwNamedErrorAt " <term:1024> $Lean.Parser.ppSpace $ident $Lean.Parser.optional($Lean.Parser.checkNoWsBefore "." $Lean.Parser.checkNoWsBefore $ident) $Lean.Parser.ppSpace $interpolatedStr | <term:1024>)
```

**Good generation (parses):**
```
throwNamedErrorAt `(tactic| match (motive := leading_parser:x (withAnonymousAntiquot := true) false) a : x,  a : z with 
    
    | y,  b |  g,  h |  y,  b,  y => 
    _) a m
```

**Failing generation:**
```
throwNamedErrorAt wait_if_contains_mvar% ?m; () a ⟨true⟩
```

**Error:** `<input>:1:56: unexpected end of input; expected identifier`

---

### [term] Lean.Parser.Term.dbgTrace — 11/20

**Extracted grammar:**
```
node[Lean.Parser.Term.dbgTrace]($Lean.Parser.withPosition("dbg_trace" $interpolatedStr | <term>) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
dbg_trace panic! (_ : let_delayed  : x := false;
false) -> y;
f
```

**Failing generation:**
```
dbg_trace letI  +postponeValue : wait_if_type_contains_mvar% ?n; let_expr g@f := "hello"
       | true
  
  true := h;
n;
a
```

**Error:** `<input>:2:7: expected checkColGt`

---

### [term] Lean.Parser.Term.let — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Term.let]($Lean.Parser.withPosition("let" node[Lean.Parser.Term.letConfig]($Lean.Parser.many(node[Lean.Parser.Term.letPosOpt](" +" $Lean.Parser.checkNoWsBefore node[Lean.Parser.Term.letOpts](node[Lean.Parser.Term.letOptNondep](&"nondep") | node[Lean.Parser.Term.letOptPostponeValue](&"postponeValue") | node[Lean.Parser.Term.letOptUsedOnly](&"usedOnly") | node[Lean.Parser.Term.letOptZeta](&"zeta") | node[Lean.Parser.Term.letOptGeneralize](&"generalize"))) | node[Lean.Parser.Term.letNegOpt](" -" $Lean.Parser.checkNoWsBefore node[Lean.Parser.Term.letOpts](node[Lean.Parser.Term.letOptNondep](&"nondep") | node[Lean.Parser.Term.letOptPostponeValue](&"postponeValue") | node[Lean.Parser.Term.letOptUsedOnly](&"usedOnly") | node[Lean.Parser.Term.letOptZeta](&"zeta") | node[Lean.Parser.Term.letOptGeneralize](&"generalize"))) | node[Lean.Parser.Term.letOptEq](" (" &"eq" " := " $ident | node[Lean.Parser.Term.hole]("_") ")"))) node[Lean.Parser.Term.letDecl]($Lean.Parser.checkPrec node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letIdDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letPatDecl]($Lean.Parser.ppSpace $Lean.Parser.checkPrec node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")") $Lean.Parser.pushNone $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " <term>) | node[Lean.Parser.Term.letEqnsDecl](node[Lean.Parser.Term.letId]($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.checkPrec | $Lean.Parser.checkPrec) $Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)) " := " | node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>)))))))) ";" | $Lean.Parser.checkLinebreakBefore $Lean.Parser.pushNone $Lean.Parser.ppLine <term>)
```

**Good generation (parses):**
```
let +postponeValue : unless (wait_if_type_contains_mvar% ?f; x : x) do 
  
  return 0;  := g

g
```

**Failing generation:**
```
let : 'a' := let_mvar% ?b := (_ : x :=  by sorry) -> true; h;
h
```

**Error:** `<input>:1:43: expected '{' or tactic`

---

### [term] Lean.Parser.Term.byTactic — 9/20

**Extracted grammar:**
```
node[Lean.Parser.Term.byTactic]($Lean.Parser.ppAllowUngrouped "by " <tactic>)
```

**Good generation (parses):**
```
by match (motive := for wait_if_contains_mvar% ?x; false in true do 
  
  pure (); ) n : m,  f : g with 
    
    | n |  n => 
    _
```

**Failing generation:**
```
by set_option a false in { 
  ;  
  
}
```

**Error:** `<input>:2:2: expected '}'`

---

### [term] Lean.Parser.Term.nomatch — 11/20

**Extracted grammar:**
```
node[Lean.Parser.Term.nomatch]("nomatch " sepBy1(<term>, ", "))
```

**Good generation (parses):**
```
nomatch `(attribute [tactic_name h] g)
```

**Failing generation:**
```
nomatch binop% f wait_if_contains_mvar% ?y; @false (),  "hello"
```

**Error:** `<input>:1:53: expected term`

---

### [term] Lean.Parser.Term.paren — 18/20

**Extracted grammar:**
```
node[Lean.Parser.Term.paren](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.withoutPosition(<term>) ")")
```

**Good generation (parses):**
```
(no_index default_or_ofNonempty% )
```

**Failing generation:**
```
(fun {_ : suffices let rec @[scoped inline,  reducible,  simp]  (f) := h
    decreasing_by z,  /-- doc comment text -/
     : m := n
    decreasing_by m
  
  g by g

m} : m => h)
```

**Error:** `<input>:2:18: expected '{' or indented tactic sequence`

---

### [term] Lean.Parser.Term.termTry — 13/20

**Extracted grammar:**
```
node[Lean.Parser.Term.termTry]("try " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))) $Lean.Parser.many(node[Lean.Parser.Term.doCatch]($Lean.Parser.ppLine "catch " $ident | node[Lean.Parser.Term.hole]("_") $Lean.Parser.optional(" : " <term>) " => " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))))) | node[Lean.Parser.Term.doCatchMatch]($Lean.Parser.ppLine "catch " node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))))))))))) $Lean.Parser.optional(node[Lean.Parser.Term.doFinally]($Lean.Parser.ppLine "finally " node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))))
```

**Good generation (parses):**
```
try 
  
  Type 
    (0) <- return x
   | 
    
    pure (); ; 
finally {
a
}
```

**Failing generation:**
```
try {
StateRefT try {
pure ()
}
catch _ => 
  
  return 0;  (); 
}
finally {
n
}
```

**Error:** `<input>:8:0: expected '$' or term`

---

### [term] Lean.Parser.Term.tuple — 16/20

**Extracted grammar:**
```
node[Lean.Parser.Term.tuple](node[Lean.Parser.Term.hygienicLParen]("(" $Lean.Parser.checkPrec) $Lean.Parser.optional($Lean.Parser.withoutPosition(<term> ", " sepBy1(<term>, ", ",trailing))) ")")
```

**Good generation (parses):**
```
()
```

**Failing generation:**
```
(show throwNamedErrorAt `(tactic| rfl;
 sorry;
 skip) y m by z, x,  f,  g)
```

**Error:** `<input>:1:35: unknown tactic`

---

### [command] Lean.Parser.Command.elab — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Command.elab]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ")) node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) "elab" $Lean.Parser.optional(node[Lean.Parser.precedence](":" <prec:1024>)) $Lean.Parser.optional(node[Lean.Parser.Command.namedName](" (" &"name" " := " $ident ")")) $Lean.Parser.optional(node[Lean.Parser.Command.namedPrio](" (" &"priority" " := " $Lean.Parser.withoutPosition(<prio>) ")")) $Lean.Parser.many1($Lean.Parser.ppSpace node[Lean.Parser.Command.macroArg]($Lean.Parser.optional($ident $Lean.Parser.checkNoWsBefore ":") <stx:1023>)) node[Lean.Parser.Command.elabTail](" : " $ident $Lean.Parser.optional(" <= " $ident) " => " $Lean.Parser.withPosition(<term>)))
```

**Good generation (parses):**
```
@[scoped default_instance,  scoped tactic_name n] elab:0 (priority := 1000) x : n => "hello"
```

**Failing generation:**
```
/-- doc comment text -/
scoped elab:0 (priority := 1000) g:0 : x <= x => false
```

**Error:** `<input>:2:35: expected stx`

---

### [command] Lean.Parser.Command.in — 0/20

**Extracted grammar:**
```
trailing[Lean.Parser.Command.in](lhs " in" $Lean.Parser.ppLine <command>)
```

**Failing generation:**
```
n in
#with_exporting #import_path g
```

**Error:** `<input>:1:0: expected command`

---

### [command] Lean.Parser.Command.mixfix — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Command.mixfix]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ")) node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) node[Lean.Parser.Command.prefix]("prefix") | node[Lean.Parser.Command.infix]("infix") | node[Lean.Parser.Command.infixl]("infixl") | node[Lean.Parser.Command.infixr]("infixr") | node[Lean.Parser.Command.postfix]("postfix") node[Lean.Parser.precedence](":" <prec:1024>) $Lean.Parser.optional(node[Lean.Parser.Command.namedName](" (" &"name" " := " $ident ")")) $Lean.Parser.optional(node[Lean.Parser.Command.namedPrio](" (" &"priority" " := " $Lean.Parser.withoutPosition(<prio>) ")")) $Lean.Parser.ppSpace $strLit | node[Lean.Parser.Syntax.unicodeAtom]("unicode(" $strLit ", " $strLit $Lean.Parser.optional(", " &"preserveForPP") ")") | node[Lean.Parser.Command.identPrec]($ident $Lean.Parser.optional(node[Lean.Parser.precedence](":" <prec:1024>))) " => " <term>)
```

**Good generation (parses):**
```
/-- doc comment text -/
scoped infix:0 (name := z) (priority := 1000) "world" => binop% a true "hello"
```

**Failing generation:**
```
/-- doc comment text -/
scoped infix:0 (name := x) (priority := 1000) "test" => suffices x by trivial

()
```

**Error:** `<input>:2:71: unknown tactic`

---

### [command] Lean.Parser.Command.evalBang — 18/20

**Extracted grammar:**
```
node[Lean.Parser.Command.evalBang]("#eval! " <term>)
```

**Good generation (parses):**
```
#eval! nomatch .,  ⋯
```

**Failing generation:**
```
#eval! `(tactic| { 
};
 trivial)
```

**Error:** `<input>:3:2: unknown tactic`

---

### [command] Lean.Parser.Command.eval — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Command.eval]("#eval " <term>)
```

**Good generation (parses):**
```
#eval no_implicit_lambda% y
```

**Failing generation:**
```
#eval `(tactic| set_option n false in trivial)
```

**Error:** `<input>:1:39: unknown tactic`

---

### [command] Lean.Parser.Command.check — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Command.check]("#check " <term>)
```

**Good generation (parses):**
```
#check set_option b.m false in clear% z

do 
  
  return 0; 
```

**Failing generation:**
```
#check let rec @[scoped default_instance,  scoped tactic_name n]  (0) := 0
  decreasing_by rfl

g
```

**Error:** `<input>:2:17: unknown tactic`

---

### [command] Lean.Parser.Command.grindPattern — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Command.grindPattern](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) "grind_pattern " $Lean.Parser.optional("[" $ident "]") $ident " => " sepBy1(<term>, ",") $Lean.Parser.optional(node[Lean.Parser.Command.grindPatternCnstrs]("where " $Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Command.GrindCnstr.isValue](&"is_value " $ident $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.isStrictValue](&"is_strict_value " $ident $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.notValue](&"not_value " $ident $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.notStrictValue](&"not_strict_value " $ident $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.isGround](&"is_ground " $ident $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.sizeLt](&"size " $ident " < " $numLit $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.depthLt](&"depth " $ident " < " $numLit $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.genLt](&"gen" " < " $numLit $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.maxInsts](&"max_insts" " < " $numLit $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.guard](&"guard " $Lean.Parser.checkColGe <term> $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.check](&"check " $Lean.Parser.checkColGe <term> $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.notDefEq]($ident " =/= " $Lean.Parser.checkColGe <term> $Lean.Parser.optional(";")) | node[Lean.Parser.Command.GrindCnstr.defEq]($ident " =?= " $Lean.Parser.checkColGe <term> $Lean.Parser.optional(";")))))))
```

**Good generation (parses):**
```
scoped grind_pattern [m]n => decl_name%, StateRefT logNamedError x.g x x where 
  
  is_value y
```

**Failing generation:**
```
scoped grind_pattern [z]h => by n
```

**Error:** `<input>:1:33: unknown tactic`

---

### [command] Lean.Parser.Command.synth — 15/20

**Extracted grammar:**
```
node[Lean.Parser.Command.synth]("#synth " <term>)
```

**Good generation (parses):**
```
#synth show_term_elab clear% m

Prop
```

**Failing generation:**
```
#synth let_expr x@a := no_implicit_lambda% ensure_expected_type% "world" true
     | "hello";
0
```

**Error:** `<input>:2:5: expected checkColGt`

---

### [command] Lean.Parser.Command.binderPredicate — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Command.binderPredicate]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ")) $Lean.Parser.optional(node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local ")))) "binder_predicate" $Lean.Parser.optional(node[Lean.Parser.Command.namedName](" (" &"name" " := " $ident ")")) $Lean.Parser.optional(node[Lean.Parser.Command.namedPrio](" (" &"priority" " := " $Lean.Parser.withoutPosition(<prio>) ")")) $Lean.Parser.ppSpace $ident $Lean.Parser.many($Lean.Parser.ppSpace node[Lean.Parser.Command.macroArg]($Lean.Parser.optional($ident $Lean.Parser.checkNoWsBefore ":") <stx:1023>)) " => " <term>)
```

**Good generation (parses):**
```
@[scoped tactic_alt b,  scoped tactic_alt g,  scoped tactic_tag b] binder_predicate (name := x) (priority := 1000) m x => 0
```

**Failing generation:**
```
/-- doc comment text -/
binder_predicate (name := x) (priority := 1000) b m:0 => x
```

**Error:** `<input>:2:52: expected stx`

---

### [command] Lean.Parser.Command.macro — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Command.macro]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ")) node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) "macro" $Lean.Parser.optional(node[Lean.Parser.precedence](":" <prec:1024>)) $Lean.Parser.optional(node[Lean.Parser.Command.namedName](" (" &"name" " := " $ident ")")) $Lean.Parser.optional(node[Lean.Parser.Command.namedPrio](" (" &"priority" " := " $Lean.Parser.withoutPosition(<prio>) ")")) $Lean.Parser.many1($Lean.Parser.ppSpace node[Lean.Parser.Command.macroArg]($Lean.Parser.optional($ident $Lean.Parser.checkNoWsBefore ":") <stx:1023>)) node[Lean.Parser.Command.macroTail](" : " $ident " => " node[Lean.Parser.Command.macroRhs]($Lean.Parser.withPosition(<term>))))
```

**Good generation (parses):**
```
@[scoped default_instance,  scoped tactic_name f,  tactic_name y] macro:0 (priority := 1000) x : h => b
```

**Failing generation:**
```
/-- doc comment text -/
scoped macro:0 (priority := 1000) g:0 : z => 0
```

**Error:** `<input>:2:36: expected stx`

---

### [command] Lean.Parser.Command.notation — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Command.notation]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ")) node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) "notation" $Lean.Parser.optional(node[Lean.Parser.precedence](":" <prec:1024>)) $Lean.Parser.optional(node[Lean.Parser.Command.namedName](" (" &"name" " := " $ident ")")) $Lean.Parser.optional(node[Lean.Parser.Command.namedPrio](" (" &"priority" " := " $Lean.Parser.withoutPosition(<prio>) ")")) $Lean.Parser.many($Lean.Parser.ppSpace $strLit | node[Lean.Parser.Syntax.unicodeAtom]("unicode(" $strLit ", " $strLit $Lean.Parser.optional(", " &"preserveForPP") ")") | node[Lean.Parser.Command.identPrec]($ident $Lean.Parser.optional(node[Lean.Parser.precedence](":" <prec:1024>)))) " => " <term>)
```

**Good generation (parses):**
```
@[scoped extern] scoped notation:0 (priority := 1000) => false
```

**Failing generation:**
```
/-- doc comment text -/
scoped notation:0 (priority := 1000) => `(tactic| trivial)
```

**Error:** `<input>:2:51: unknown tactic`

---

### [command] Lean.Parser.Command.registerErrorExplanationStx — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Command.registerErrorExplanationStx]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) "register_error_explanation " $ident <term>)
```

**Good generation (parses):**
```
register_error_explanation y binrel% n nofun ensure_expected_type% "" "hello"
```

**Failing generation:**
```
register_error_explanation a binop_lazy% n 'a' `(tactic| assumption;
 assumption;
 trivial)
```

**Error:** `<input>:1:58: unknown tactic`

---

### [command] Lean.Parser.Command.mutual — 19/20

**Extracted grammar:**
```
node[Lean.Parser.Command.mutual]("mutual" $Lean.Parser.many1($Lean.Parser.ppLine $Lean.Parser.checkPrec <command>) $Lean.Parser.ppLine "end")
```

**Good generation (parses):**
```
mutual
import
end
```

**Failing generation:**
```
mutual
/-- doc comment text -/
scoped macro_rules (kind:=m)
    
    | `(tactic| rfl),  "hello" |  "hello",  () |  b => 
    f
end
```

**Error:** `<input>:5:17: unknown tactic`

---

### [command] Lean.Parser.Command.initialize — 14/20

**Extracted grammar:**
```
node[Lean.Parser.Command.initialize](node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) node[Lean.Parser.Command.initializeKeyword]("initialize " | "builtin_initialize ") $Lean.Parser.optional($ident node[Lean.Parser.Term.typeSpec](" : " <term>) $Lean.Parser.ppSpace "← " | "<- ") node[Lean.Parser.Term.doSeqBracketed]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1(node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; ")))) $Lean.Parser.ppLine "}") | node[Lean.Parser.Term.doSeqIndent]($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe node[Lean.Parser.Term.doSeqItem]($Lean.Parser.ppLine <doElem> $Lean.Parser.optional("; "))))))
```

**Good generation (parses):**
```
/-- doc comment text -/
private protected unsafe builtin_initialize 
  
  for no_implicit_lambda% unop% y () in false,  "hello" in m do 
    
    g; 
```

**Failing generation:**
```
/-- doc comment text -/
private protected unsafe builtin_initialize 
  
  assert! `(tactic| trivial); 
```

**Error:** `<input>:4:21: unknown tactic`

---

### [command] Lean.Parser.Command.check_failure — 12/20

**Extracted grammar:**
```
node[Lean.Parser.Command.check_failure]("#check_failure " <term>)
```

**Good generation (parses):**
```
#check_failure `x
```

**Failing generation:**
```
#check_failure `(tactic| y)
```

**Error:** `<input>:1:26: unknown tactic`

---

### [command] Lean.Parser.Command.omit — 18/20

**Extracted grammar:**
```
node[Lean.Parser.Command.omit]("omit" $Lean.Parser.many1($Lean.Parser.ppSpace $Lean.Parser.checkColGt $ident | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")))
```

**Good generation (parses):**
```
omit 
  a
```

**Failing generation:**
```
omit 
  [`(m| f)]
```

**Error:** `<input>:2:8: unknown parser `m`

---

### [command] Lean.Parser.Command.variable — 9/20

**Extracted grammar:**
```
node[Lean.Parser.Command.variable]("variable" $Lean.Parser.many1($Lean.Parser.ppSpace $Lean.Parser.checkColGt node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")))
```

**Good generation (parses):**
```
variable 
  ⦃h : no_index private_decl% for_in% 0 x 0}}
```

**Failing generation:**
```
variable 
  (_ : wait_if_type_contains_mvar% ?f; throwNamedError f sorry :=  by skip)
```

**Error:** `<input>:2:71: unknown tactic`

---

### [command] Lean.Parser.Command.elab_rules — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Command.elab_rules]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ")) node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) "elab_rules" $Lean.Parser.optional(" (" &"kind" ":=" $ident ")") $Lean.Parser.optional(" : " $ident) $Lean.Parser.optional(" <= " $ident) node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>))))))
```

**Good generation (parses):**
```
@[scoped default_instance,  scoped tactic_name n,  default_instance] scoped elab_rules (kind:=x) : b <= b
    
    | 0 |  "hello" |  false,  m,  n => 
    g
```

**Failing generation:**
```
/-- doc comment text -/
scoped elab_rules (kind:=x) : x <= g
    
    | ⟨⟩,  clear% x
    
    return 
    (),  0 |  0,  x,  y => 
    x
```

**Error:** `<input>:7:4: expected '=>'`

---

### [command] Lean.Parser.Command.declaration — 0/20

**Extracted grammar:**
```
node[Lean.Parser.Command.declaration](node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) node[Lean.Parser.Command.abbrev]("abbrev " node[Lean.Parser.Command.declId]($ident $Lean.Parser.optional(".{" sepBy1($ident, ", ") "}")) node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))) node[Lean.Parser.Command.declValSimple](" :=" $Lean.Parser.ppLine $Lean.Parser.checkPrec <term:1022> | <term> node[Lean.Parser.Termination.suffix]($Lean.Parser.optional($Lean.Parser.ppLine node[Lean.Parser.Termination.terminationBy?]("termination_by?") | node[Lean.Parser.Termination.terminationBy]("termination_by " $Lean.Parser.optional(&"structural ") $Lean.Parser.optional($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_")) " => ") <term>) | node[Lean.Parser.Termination.partialFixpoint]($Lean.Parser.withPosition("partial_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.coinductiveFixpoint]($Lean.Parser.withPosition("coinductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.inductiveFixpoint]($Lean.Parser.withPosition("inductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>)))) $Lean.Parser.optional(node[Lean.Parser.Termination.decreasingBy]($Lean.Parser.ppLine "decreasing_by " <tactic>))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>)))))))) | node[Lean.Parser.Command.declValEqns](@Lean.Parser.Term.matchAltsWhereDecls) | node[Lean.Parser.Command.whereStructInst]($Lean.Parser.ppSpace "where" node[Lean.Parser.Term.structInstFields]($Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>))))))))) | node[Lean.Parser.Command.definition]("def " node[Lean.Parser.Command.declId]($ident $Lean.Parser.optional(".{" sepBy1($ident, ", ") "}")) node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))) node[Lean.Parser.Command.declValSimple](" :=" $Lean.Parser.ppLine $Lean.Parser.checkPrec <term:1022> | <term> node[Lean.Parser.Termination.suffix]($Lean.Parser.optional($Lean.Parser.ppLine node[Lean.Parser.Termination.terminationBy?]("termination_by?") | node[Lean.Parser.Termination.terminationBy]("termination_by " $Lean.Parser.optional(&"structural ") $Lean.Parser.optional($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_")) " => ") <term>) | node[Lean.Parser.Termination.partialFixpoint]($Lean.Parser.withPosition("partial_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.coinductiveFixpoint]($Lean.Parser.withPosition("coinductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.inductiveFixpoint]($Lean.Parser.withPosition("inductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>)))) $Lean.Parser.optional(node[Lean.Parser.Termination.decreasingBy]($Lean.Parser.ppLine "decreasing_by " <tactic>))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>)))))))) | node[Lean.Parser.Command.declValEqns](@Lean.Parser.Term.matchAltsWhereDecls) | node[Lean.Parser.Command.whereStructInst]($Lean.Parser.ppSpace "where" node[Lean.Parser.Term.structInstFields]($Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>)))))))) $Lean.Parser.optional($Lean.Parser.ppLine "deriving " $Lean.Parser.checkPrec $Lean.Parser.checkPrec sepBy1(node[Lean.Parser.Command.derivingClass]($Lean.Parser.optional("@[" &"expose" "]") <term>), ", "))) | node[Lean.Parser.Command.theorem]("theorem " node[Lean.Parser.Command.declId]($ident $Lean.Parser.optional(".{" sepBy1($ident, ", ") "}")) node[Lean.Parser.Command.declSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) node[Lean.Parser.Term.typeSpec](" : " <term>)) node[Lean.Parser.Command.declValSimple](" :=" $Lean.Parser.ppLine $Lean.Parser.checkPrec <term:1022> | <term> node[Lean.Parser.Termination.suffix]($Lean.Parser.optional($Lean.Parser.ppLine node[Lean.Parser.Termination.terminationBy?]("termination_by?") | node[Lean.Parser.Termination.terminationBy]("termination_by " $Lean.Parser.optional(&"structural ") $Lean.Parser.optional($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_")) " => ") <term>) | node[Lean.Parser.Termination.partialFixpoint]($Lean.Parser.withPosition("partial_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.coinductiveFixpoint]($Lean.Parser.withPosition("coinductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.inductiveFixpoint]($Lean.Parser.withPosition("inductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>)))) $Lean.Parser.optional(node[Lean.Parser.Termination.decreasingBy]($Lean.Parser.ppLine "decreasing_by " <tactic>))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>)))))))) | node[Lean.Parser.Command.declValEqns](@Lean.Parser.Term.matchAltsWhereDecls) | node[Lean.Parser.Command.whereStructInst]($Lean.Parser.ppSpace "where" node[Lean.Parser.Term.structInstFields]($Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>))))))))) | node[Lean.Parser.Command.opaque]("opaque " node[Lean.Parser.Command.declId]($ident $Lean.Parser.optional(".{" sepBy1($ident, ", ") "}")) node[Lean.Parser.Command.declSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) node[Lean.Parser.Term.typeSpec](" : " <term>)) $Lean.Parser.optional(node[Lean.Parser.Command.declValSimple](" :=" $Lean.Parser.ppLine $Lean.Parser.checkPrec <term:1022> | <term> node[Lean.Parser.Termination.suffix]($Lean.Parser.optional($Lean.Parser.ppLine node[Lean.Parser.Termination.terminationBy?]("termination_by?") | node[Lean.Parser.Termination.terminationBy]("termination_by " $Lean.Parser.optional(&"structural ") $Lean.Parser.optional($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_")) " => ") <term>) | node[Lean.Parser.Termination.partialFixpoint]($Lean.Parser.withPosition("partial_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.coinductiveFixpoint]($Lean.Parser.withPosition("coinductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.inductiveFixpoint]($Lean.Parser.withPosition("inductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>)))) $Lean.Parser.optional(node[Lean.Parser.Termination.decreasingBy]($Lean.Parser.ppLine "decreasing_by " <tactic>))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>)))))))))) | node[Lean.Parser.Command.instance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) "instance" $Lean.Parser.optional(node[Lean.Parser.Command.namedPrio](" (" &"priority" " := " $Lean.Parser.withoutPosition(<prio>) ")")) $Lean.Parser.optional($Lean.Parser.ppSpace node[Lean.Parser.Command.declId]($ident $Lean.Parser.optional(".{" sepBy1($ident, ", ") "}"))) node[Lean.Parser.Command.declSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) node[Lean.Parser.Term.typeSpec](" : " <term>)) node[Lean.Parser.Command.declValSimple](" :=" $Lean.Parser.ppLine $Lean.Parser.checkPrec <term:1022> | <term> node[Lean.Parser.Termination.suffix]($Lean.Parser.optional($Lean.Parser.ppLine node[Lean.Parser.Termination.terminationBy?]("termination_by?") | node[Lean.Parser.Termination.terminationBy]("termination_by " $Lean.Parser.optional(&"structural ") $Lean.Parser.optional($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_")) " => ") <term>) | node[Lean.Parser.Termination.partialFixpoint]($Lean.Parser.withPosition("partial_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.coinductiveFixpoint]($Lean.Parser.withPosition("coinductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.inductiveFixpoint]($Lean.Parser.withPosition("inductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>)))) $Lean.Parser.optional(node[Lean.Parser.Termination.decreasingBy]($Lean.Parser.ppLine "decreasing_by " <tactic>))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>)))))))) | node[Lean.Parser.Command.declValEqns](@Lean.Parser.Term.matchAltsWhereDecls) | node[Lean.Parser.Command.whereStructInst]($Lean.Parser.ppSpace "where" node[Lean.Parser.Term.structInstFields]($Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>))))))))) | node[Lean.Parser.Command.axiom]("axiom " node[Lean.Parser.Command.declId]($ident $Lean.Parser.optional(".{" sepBy1($ident, ", ") "}")) node[Lean.Parser.Command.declSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) node[Lean.Parser.Term.typeSpec](" : " <term>))) | node[Lean.Parser.Command.example]("example" node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))) node[Lean.Parser.Command.declValSimple](" :=" $Lean.Parser.ppLine $Lean.Parser.checkPrec <term:1022> | <term> node[Lean.Parser.Termination.suffix]($Lean.Parser.optional($Lean.Parser.ppLine node[Lean.Parser.Termination.terminationBy?]("termination_by?") | node[Lean.Parser.Termination.terminationBy]("termination_by " $Lean.Parser.optional(&"structural ") $Lean.Parser.optional($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_")) " => ") <term>) | node[Lean.Parser.Termination.partialFixpoint]($Lean.Parser.withPosition("partial_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.coinductiveFixpoint]($Lean.Parser.withPosition("coinductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>))) | node[Lean.Parser.Termination.inductiveFixpoint]($Lean.Parser.withPosition("inductive_fixpoint" $Lean.Parser.optional($Lean.Parser.checkColGt &"monotonicity " $Lean.Parser.checkColGt <term>)))) $Lean.Parser.optional(node[Lean.Parser.Termination.decreasingBy]($Lean.Parser.ppLine "decreasing_by " <tactic>))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>)))))))) | node[Lean.Parser.Command.declValEqns](@Lean.Parser.Term.matchAltsWhereDecls) | node[Lean.Parser.Command.whereStructInst]($Lean.Parser.ppSpace "where" node[Lean.Parser.Term.structInstFields]($Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing))) $Lean.Parser.optional(node[Lean.Parser.Term.whereDecls]($Lean.Parser.ppLine "where" $Lean.Parser.withPosition(sepBy($Lean.Parser.checkColGe $Lean.Parser.checkPrec, "; ",trailing)) $Lean.Parser.optional(node[Lean.Parser.Term.whereFinally]($Lean.Parser.ppLine "finally " $Lean.Parser.optional(<tactic>) $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe node[Lean.Parser.Term.whereFinallySubsection]($Lean.Parser.ppLine "| " $Lean.Parser.checkPrec $ident " => " <tactic>))))))))) | node[Lean.Parser.Command.inductive]("inductive " node[Lean.Parser.Command.declId]($ident $Lean.Parser.optional(".{" sepBy1($ident, ", ") "}")) node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))) $Lean.Parser.optional(" :=" | " where") $Lean.Parser.many(node[Lean.Parser.Command.ctor]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) "
| " node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) $ident node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))))) $Lean.Parser.optional($Lean.Parser.ppLine node[Lean.Parser.Command.computedFields]("with" $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Command.computedField](node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) $ident " : " <term> node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>)))))))))) node[Lean.Parser.Command.optDeriving]($Lean.Parser.optional($Lean.Parser.ppLine "deriving " $Lean.Parser.checkPrec $Lean.Parser.checkPrec sepBy1(node[Lean.Parser.Command.derivingClass]($Lean.Parser.optional("@[" &"expose" "]") <term>), ", ")))) | node[Lean.Parser.Command.coinductive]("coinductive " node[Lean.Parser.Command.declId]($ident $Lean.Parser.optional(".{" sepBy1($ident, ", ") "}")) node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))) $Lean.Parser.optional(" :=" | " where") $Lean.Parser.many(node[Lean.Parser.Command.ctor]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) "
| " node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) $ident node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))))) $Lean.Parser.optional($Lean.Parser.ppLine node[Lean.Parser.Command.computedFields]("with" $Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Command.computedField](node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) $ident " : " <term> node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>)))))))))) node[Lean.Parser.Command.optDeriving]($Lean.Parser.optional($Lean.Parser.ppLine "deriving " $Lean.Parser.checkPrec $Lean.Parser.checkPrec sepBy1(node[Lean.Parser.Command.derivingClass]($Lean.Parser.optional("@[" &"expose" "]") <term>), ", ")))) | node[Lean.Parser.Command.classInductive]($Lean.Parser.group("class " "inductive ") node[Lean.Parser.Command.declId]($ident $Lean.Parser.optional(".{" sepBy1($ident, ", ") "}")) node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))) $Lean.Parser.optional(" :=" | " where") $Lean.Parser.many(node[Lean.Parser.Command.ctor]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) "
| " node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) $ident node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))))) node[Lean.Parser.Command.optDeriving]($Lean.Parser.optional($Lean.Parser.ppLine "deriving " $Lean.Parser.checkPrec $Lean.Parser.checkPrec sepBy1(node[Lean.Parser.Command.derivingClass]($Lean.Parser.optional("@[" &"expose" "]") <term>), ", ")))) | node[Lean.Parser.Command.structure](node[Lean.Parser.Command.structureTk]("structure ") | node[Lean.Parser.Command.classTk]("class ") node[Lean.Parser.Command.declId]($ident $Lean.Parser.optional(".{" sepBy1($ident, ", ") "}")) node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))) $Lean.Parser.optional(node[Lean.Parser.Command.extends](" extends " sepBy1(node[Lean.Parser.Command.structParent]($Lean.Parser.optional($ident " : ") <term>), ", ") $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>)))) $Lean.Parser.optional(" := " | " where " $Lean.Parser.optional(node[Lean.Parser.Command.structCtor](node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) $ident $Lean.Parser.many($Lean.Parser.ppSpace node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) " :: ")) node[Lean.Parser.Command.structFields]($Lean.Parser.withPosition($Lean.Parser.many($Lean.Parser.checkColGe $Lean.Parser.ppLine $Lean.Parser.checkColGe node[Lean.Parser.Command.structExplicitBinder](node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) "(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident) node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Command.structImplicitBinder](node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) "{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident) node[Lean.Parser.Command.declSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) node[Lean.Parser.Term.typeSpec](" : " <term>))) "}") | node[Lean.Parser.Command.structInstBinder](node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) "[" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident) node[Lean.Parser.Command.declSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) node[Lean.Parser.Term.typeSpec](" : " <term>))) "]") | node[Lean.Parser.Command.structSimpleBinder](node[Lean.Parser.Command.declModifiers]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ") $Lean.Parser.skip) $Lean.Parser.optional(node[Lean.Parser.Command.private]("private ") | node[Lean.Parser.Command.public]("public ")) $Lean.Parser.optional(node[Lean.Parser.Command.protected]("protected ")) $Lean.Parser.optional(node[Lean.Parser.Command.meta]("meta ") | node[Lean.Parser.Command.noncomputable]("noncomputable ")) $Lean.Parser.optional(node[Lean.Parser.Command.unsafe]("unsafe ")) $Lean.Parser.optional(node[Lean.Parser.Command.partial]("partial ") | node[Lean.Parser.Command.nonrec]("nonrec "))) $ident node[Lean.Parser.Command.optDeclSig]($Lean.Parser.many($Lean.Parser.ppSpace $ident | node[Lean.Parser.Term.hole]("_") | node[Lean.Parser.Term.explicitBinder]("(" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))) ")") | node[Lean.Parser.Term.strictImplicitBinder]($Lean.Parser.group("{" "{") | "⦃" $Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>) $Lean.Parser.group("}" "}") | "⦄") | node[Lean.Parser.Term.implicitBinder]("{" $Lean.Parser.withoutPosition($Lean.Parser.many1($ident | node[Lean.Parser.Term.hole]("_")) node[null](" : " <term>)) "}") | node[Lean.Parser.Term.instBinder]("[" $Lean.Parser.withoutPosition($Lean.Parser.optional($ident " : ") <term>) "]")) $Lean.Parser.optional(node[Lean.Parser.Term.typeSpec](" : " <term>))) $Lean.Parser.optional(node[Lean.Parser.Term.binderTactic](" := " " by " <tactic>) | node[Lean.Parser.Term.binderDefault](" := " <term>))))))) node[Lean.Parser.Command.optDeriving]($Lean.Parser.optional($Lean.Parser.ppLine "deriving " $Lean.Parser.checkPrec $Lean.Parser.checkPrec sepBy1(node[Lean.Parser.Command.derivingClass]($Lean.Parser.optional("@[" &"expose" "]") <term>), ", ")))))
```

**Failing generation:**
```
/-- doc comment text -/
private protected unsafe def a _n
```

**Error:** `<input>:2:33: unexpected end of input; expected ':=', 'where' or '|'`

---

### [command] Lean.Parser.Command.macro_rules — 16/20

**Extracted grammar:**
```
node[Lean.Parser.Command.macro_rules]($Lean.Parser.optional(node[Lean.Parser.Command.docComment]("/--" $Lean.Parser.ppSpace $Lean.Parser.commentBody $Lean.Parser.ppLine)) $Lean.Parser.optional(node[Lean.Parser.Term.attributes]("@[" $Lean.Parser.withoutPosition(sepBy1(node[Lean.Parser.Term.attrInstance](node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) <attr>), ", ")) "] ")) node[Lean.Parser.Term.attrKind]($Lean.Parser.optional(node[Lean.Parser.Term.scoped]("scoped ") | node[Lean.Parser.Term.local]("local "))) "macro_rules" $Lean.Parser.optional(" (" &"kind" ":=" $ident ")") node[Lean.Parser.Term.matchAlts]($Lean.Parser.withPosition($Lean.Parser.withPosition($Lean.Parser.many1($Lean.Parser.checkColGe $Lean.Parser.ppLine node[Lean.Parser.Term.matchAlt]("| " sepBy1(sepBy1(<term>, ", "), " | ") " => " $Lean.Parser.checkColGe <term>))))))
```

**Good generation (parses):**
```
/-- doc comment text -/
scoped macro_rules (kind:=b)
    
    | clear% m
    
    'a' => 
    .(())
```

**Failing generation:**
```
@[scoped extern,  scoped tactic_name n] macro_rules (kind:=b)
    
    | (_ : x :=  by sorry) -> x,  a,  g => 
    h
```

**Error:** `<input>:3:20: expected '{' or tactic`

---

### [command] Lean.Parser.Command.deriving — 17/20

**Extracted grammar:**
```
node[Lean.Parser.Command.deriving]("deriving " $Lean.Parser.optional("noncomputable ") "instance " sepBy1(node[Lean.Parser.Command.derivingClass]($Lean.Parser.optional("@[" &"expose" "]") <term>), ", ") " for " sepBy1(<term>, ", "))
```

**Good generation (parses):**
```
deriving noncomputable instance @[expose]sorry for ensure_type_of% for_in'% true false ()"test" z,  a
```

**Failing generation:**
```
deriving instance private_decl% nofun,  @[expose]for "hello" in x,  z : false in z do 
  
  x;  for a,  x
```

**Error:** `<input>:1:49: expected forbidden token`

---

