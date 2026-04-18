| Category | Parser | Score | Sample | Error |
|----------|--------|-------|--------|-------|
| doElem | Lean.Parser.Term.doDbgTrace | 19/20 | `dbg_trace "test"` | <input>:3:143: unexpected end of input |
| doElem | Lean.Parser.Term.doExpr | 15/20 | `decl_name%` | <input>:1:5: expected '(', ':=', '\|' or term |
| doElem | Lean.Parser.Term.doContinue | 20/20 | `continue` |  |
| doElem | Lean.Parser.Term.doLetExpr | 15/20 | `let_expr x@f := set_option g.x false in match (motive := thr` | <input>:1:40: unknown tactic |
| doElem | Lean.Parser.Term.doFor | 15/20 | `for z : unsafe leading_parser:_ (withAnonymousAntiquot := tr` | <input>:2:20: expected ')' |
| doElem | Lean.Parser.Term.doBreak | 20/20 | `break` |  |
| doElem | Lean.Parser.Term.doIf | 10/20 | `if ``(`(clear% g↵↵x)) then ↵         ↵         pure (); ↵ el` | <input>:9:1: expected end of input |
| doElem | Lean.Parser.Term.doLetMetaExpr | 14/20 | `let_expr b@y<- forall _, @& StateRefT false $0↵ \| ↵   ↵   re` | <input>:2:15: expected '_', '}' or identifier |
| doElem | Lean.Parser.Term.doHave | 13/20 | `have (unsafe wait_if_type_contains_mvar% ?y; show_term_elab ` | <input>:1:18: unknown tactic |
| doElem | Lean.Parser.Term.doUnless | 10/20 | `unless default_or_ofNonempty%  do ↵                         ` | <input>:1:60: expected forbidden token |
| doElem | Lean.Parser.Term.doMatchExpr | 14/20 | `match_expr <- let_expr g@n := let_mvar% ?b := "hello"; ()↵  ` | <input>:1:16: unknown parser `x |
| doElem | Lean.Parser.Term.doAssert | 13/20 | `assert! for_in'% elabToSyntax% 42 logNamedWarning y x "hello` | <input>:1:53: unknown tactic |
| doElem | Lean.Parser.Term.doLetElse | 12/20 | `let mut Type ↵  f := 'a'↵ \| ↵   ↵   pure ()↵↵↵pure (); ` | <input>:3:2: unknown tactic |
| doElem | Lean.Parser.Term.doLetRec | 0/20 | `let rec /-- doc comment text -/↵ : let rec @[scoped tactic_n` | <input>:3:18: unknown tactic |
| doElem | Lean.Parser.Term.doReturn | 10/20 | `return` | <input>:2:0: expected end of input |
| doElem | Lean.Parser.Term.doTry | 15/20 | `try ↵    ↵    debug_assert! (for false in x,  z : "hello" in` | <input>:12:9: expected end of input |
| doElem | Lean.Parser.Term.doReassignArrow | 16/20 | `n <- break` | <input>:1:5: expected '(', ':=', '\|' or term |
| doElem | Lean.Parser.Term.doLetArrow | 17/20 | `let mut n <- a <- let  : ensure_expected_type% "world" () :=` | <input>:2:19: unknown tactic |
| doElem | Lean.Parser.Term.doDebugAssert | 17/20 | `debug_assert! @ensure_type_of% ``("hello")"hello" false` | <input>:2:16: expected '_', '}' or identifier |
| doElem | Lean.Parser.Term.doLet | 14/20 | `let  : logNamedError f ensure_type_of% ."" 0 := x` | <input>:1:62: unexpected end of input |
| doElem | Lean.Parser.Term.doNested | 15/20 | `do {↵have (``x) : let_expr z@n := false↵                \| x↵` | <input>:12:1: expected '}' |
| doElem | Lean.Parser.Term.doMatch | 15/20 | `match (generalizing := true) (motive := sorry) debug_assert!` | <input>:1:92: unknown tactic |
| doElem | Lean.Parser.Term.doReassign | 14/20 | ` (nofun) : let_expr g@f := ``x↵              \| false;↵false ` | <input>:2:2: expected ')', ',' or ':' |
| tactic | Lean.Parser.Tactic.open | 12/20 | `open  n renaming f -> ↵  g,  f -> ↵  z,  f -> ↵  b in intro↵` | <input>:4:48: expected term |
| tactic | Lean.Parser.Tactic.match | 16/20 | `match (motive := type_of% fun {_ : logNamedErrorAt false m.b` | <input>:1:60: unknown parser `x |
| tactic | Lean.Parser.Tactic.set_option | 14/20 | `set_option b.g false in match (motive := with_decl_name% ?m ` | <input>:2:24: expected '}' |
| tactic | Lean.Parser.Tactic.nestedTactic | 10/20 | `{ ↵  ↵}` | <input>:2:2: expected '}' |
| tactic | Lean.Parser.Tactic.unknown | 0/20 | `m` | <input>:1:1: unknown tactic |
| tactic | Lean.Parser.Tactic.introMatch | 15/20 | `intro↵     ↵     \| 0 => ↵     _` | <input>:4:10: expected '=>' |
| attr | Lean.Parser.Attr.instance | 20/20 | `instance` |  |
| attr | Lean.Parser.Attr.default_instance | 20/20 | `default_instance 1000` |  |
| attr | Lean.Parser.Attr.specialize | 20/20 | `specialize h` |  |
| attr | Lean.Parser.Attr.simple | 20/20 | `f` |  |
| attr | Lean.Parser.Attr.export | 20/20 | `export y` |  |
| attr | Lean.Parser.Attr.extern | 20/20 | `extern` |  |
| attr | Lean.Parser.Attr.macro | 20/20 | `macro n` |  |
| attr | Lean.Parser.Attr.tactic_tag | 20/20 | `tactic_tag x` |  |
| attr | Lean.Parser.Attr.class | 20/20 | `class` |  |
| attr | Lean.Parser.Attr.tactic_name | 20/20 | `tactic_name ""` |  |
| attr | Lean.Parser.Attr.recursor | 20/20 | `recursor 2` |  |
| attr | Lean.Parser.Attr.tactic_alt | 20/20 | `tactic_alt a` |  |
| prec | Lean.Parser.Syntax.numPrec | 20/20 | `42` |  |
| structInstFieldDecl | Lean.Parser.Term.structInstFieldEqns | 14/20 | `↵↵\| default_or_ofNonempty%  \|  leading_parser:{ "hello" with` | <input>:3:17: expected '_' or identifier |
| structInstFieldDecl | Lean.Parser.Term.structInstFieldDef | 15/20 | ` := debug_assert! no_index ⟨⟩↵↵true` | <input>:3:19: expected '}' |
| level | Lean.Parser.Level.paren | 20/20 | `(_)` |  |
| level | Lean.Parser.Level.max | 20/20 | `max n` |  |
| level | Lean.Parser.Level.num | 20/20 | `42` |  |
| level | Lean.Parser.Level.hole | 20/20 | `_` |  |
| level | Lean.Parser.Level.addLit | 20/20 | `y + 2` |  |
| level | Lean.Parser.Level.ident | 20/20 | `a` |  |
| level | Lean.Parser.Level.imax | 20/20 | `imax 2` |  |
| stx | Lean.Parser.Syntax.sepBy | 20/20 | `sepBy(b(""), "world", allowTrailingSep)` |  |
| stx | Lean.Parser.Syntax.paren | 20/20 | `("hello")` |  |
| stx | Lean.Parser.Syntax.unary | 20/20 | `b("hello")` |  |
| stx | Lean.Parser.Syntax.atom | 20/20 | `""` |  |
| stx | Lean.Parser.Syntax.binary | 20/20 | `x(&"hello", sepBy(sepBy1(x, "world", allowTrailingSep), "", ` |  |
| stx | Lean.Parser.Syntax.nonReserved | 20/20 | `&"hello"` |  |
| stx | Lean.Parser.Syntax.sepBy1 | 20/20 | `sepBy1(sepBy1(sepBy1(unicode("hello", "test"), "world", allo` |  |
| stx | Lean.Parser.Syntax.unicodeAtom | 20/20 | `unicode("test", "", preserveForPP)` |  |
| stx | Lean.Parser.Syntax.cat | 20/20 | `a` |  |
| prio | Lean.Parser.Priority.numPrio | 20/20 | `42` |  |
| term | Lean.Parser.Term.type | 20/20 | `Type` |  |
| term | Lean.Parser.Tactic.quot | 13/20 | ``(tactic\| open  n renaming h -> ↵  g,  n -> ↵  g in intro↵  ` | <input>:2:12: expected '}' |
| term | Lean.Parser.Term.noindex | 17/20 | `no_index elabToSyntax% 1` | <input>:2:19: expected '_', '}' or identifier |
| term | Lean.Parser.Term.waitIfContainsMVar | 16/20 | `wait_if_contains_mvar% ?m; <- wait_if_type_mvar% ?n; sorry` | <input>:1:50: unknown parser `m |
| term | Lean.Parser.Term.showTermElabImpl | 15/20 | `show_term_elab for assert! let_λ  ("hello") := "hello";↵    ` | <input>:1:88: unexpected end of input |
| term | Lean.Parser.Term.privateDecl | 18/20 | `private_decl% ?h` | <input>:1:68: unexpected end of input; expected '$' |
| term | Lean.Parser.Term.termFor | 18/20 | `for x : "" in private_decl% `x,  z : "hello" in () do ↵     ` | <input>:1:9: unknown parser `b |
| term | Lean.Parser.Term.assert | 13/20 | `assert! <- 1;↵1.5e10` | <input>:1:64: expected term |
| term | Lean.Parser.Term.waitIfTypeMVar | 17/20 | `wait_if_type_mvar% ?y; elabToSyntax% 0` | <input>:2:40: expected ')' |
| term | Lean.Parser.Term.noErrorIfUnused | 18/20 | `no_error_if_unused% match_expr for (() : x) in 0,  n in z,  ` | <input>:1:71: unexpected end of input; expected '$' |
| term | Lean.Parser.Term.namedPattern | 16/20 | `f@with_decl_name% a let_delayed  : `x := "hello";↵false` | <input>:2:19: expected 'do' |
| term | Lean.Parser.Term.let_delayed | 10/20 | `let_delayed  : wait_if_type_contains_mvar% ?a; type_of% type` | <input>:1:14: expected '_' or identifier |
| term | Lean.Parser.Term.doubleQuotedName | 20/20 | ```x` |  |
| term | Lean.Parser.Term.logNamedWarningMacro | 19/20 | `logNamedWarning z.m logNamedErrorAt { ↵                     ` | <input>:4:66: unknown tactic |
| term | Lean.Parser.Term.forall | 10/20 | `forall _, ``(leftact% n leftact% f x "hello" true)` | <input>:1:39: expected '{' or tactic |
| term | Lean.Parser.Term.binop_lazy | 12/20 | `binop_lazy% h Sort ↵  0 rightact% f true "hello"` | <input>:1:36: unknown parser `g |
| term | Lean.Parser.Term.ident | 20/20 | `x` |  |
| term | Lean.Parser.Term.letrec | 0/20 | `let rec /-- doc comment text -/↵ : unreachable! := dbg_trace` | <input>:4:15: unknown tactic |
| term | Lean.Parser.Term.unop | 19/20 | `unop% m ``x` | <input>:2:13: unexpected end of input; expected identifier |
| term | Lean.Parser.Term.ensureExpectedType | 18/20 | `ensure_expected_type% "test" .` | <input>:1:59: unknown tactic |
| term | Lean.Parser.Term.app | 20/20 | `a ↵  (y := throwNamedError a ?_)` |  |
| term | Lean.Parser.Term.unsafe | 14/20 | `unsafe letI  +postponeValue : for ``x in false do {↵       r` | <input>:1:30: unknown tactic |
| term | Lean.Parser.Term.ensureTypeOf | 15/20 | `ensure_type_of% ``(logNamedErrorAt rightact% g 0 true a x)"w` | <input>:3:89: unexpected end of input; expected string liter |
| term | Lean.Parser.Term.forInMacro' | 8/20 | `for_in'% .logNamedWarningAt Sort n x "hello"` | <input>:1:16: expected token |
| term | Lean.Parser.Term.waitIfTypeContainsMVar | 14/20 | `wait_if_type_contains_mvar% ?h; Prop` | <input>:1:37: unknown parser `m |
| term | Lean.Parser.Term.proj | 18/20 | `n.100` | <input>:1:2: expected end of input |
| term | Lean.Parser.Term.clear | 16/20 | `clear% b↵↵value_of% a` | <input>:3:39: unknown tactic |
| term | Lean.Parser.Term.termReturn | 10/20 | `return` | <input>:2:0: expected end of input |
| term | Lean.Parser.Term.completion | 20/20 | `n.` |  |
| term | Lean.Parser.Term.hole | 20/20 | `_` |  |
| term | Lean.Parser.Term.nofun | 20/20 | `nofun` |  |
| term | Lean.Parser.Term.matchExpr | 17/20 | `match_expr for unsafe `(#check 0) in x,  m : "hello" in m do` | <input>:3:18: expected '_', '}' or identifier |
| term | Lean.Parser.Term.prop | 20/20 | `Prop` |  |
| term | Lean.Parser.Term.pipeProj | 16/20 | `f \|>.42` | <input>:2:66: expected term |
| term | Lean.Parser.Term.inferInstanceAs | 14/20 | `inferInstanceAs <\| throwNamedError a (binrel% f () false, "h` | <input>:1:24: unknown parser `g |
| term | Lean.Parser.Term.panic | 16/20 | `panic! let +postponeValue : Type ↵         a := x↵↵true` | <input>:3:2: unknown tactic |
| term | Lean.Parser.Term.match | 14/20 | `match (motive := @unop% g private_decl% x) "hello",  false w` | <input>:1:88: unknown tactic |
| term | Lean.Parser.Term.logNamedErrorMacro | 17/20 | `logNamedError y default_or_ofNonempty% unsafe` | <input>:1:23: unknown parser `y |
| term | Lean.Parser.Term.subst | 17/20 | `a ▸ assert! logNamedError n ((), x,  0);↵n` | <input>:1:30: unknown tactic |
| term | Lean.Parser.Term.set_option | 15/20 | `set_option h false in match (motive := do ↵                 ` | <input>:1:72: unknown tactic |
| term | Lean.Parser.Term.sorry | 20/20 | `sorry` |  |
| term | Lean.Parser.Term.noImplicitLambda | 15/20 | `no_implicit_lambda% fun {_ : wait_if_type_contains_mvar% ?y;` | <input>:3:4: unexpected end of input |
| term | Lean.Parser.Term.letExpr | 10/20 | `let_expr f := match (motive := have +postponeValue : binop_l` | <input>:1:19: unknown parser `x |
| term | Lean.Parser.Term.scientific | 20/20 | `1.5e10` |  |
| term | Lean.Parser.Term.sort | 20/20 | `Sort ↵  0` |  |
| term | Lean.Parser.Term.letMVar | 14/20 | `let_mvar% ?n := `(no_implicit_lambda% decl_name%); 0` | <input>:1:81: unknown tactic |
| term | Lean.Parser.Term.leftact | 10/20 | `leftact% z nofun rightact% y unop% a () "hello"` | <input>:1:24: unknown tactic |
| term | Lean.Parser.Term.forInMacro | 12/20 | `for_in% 42 logNamedErrorAt binop% b false () n x h` | <input>:3:53: unexpected end of input |
| term | Lean.Parser.Term.withDeclName | 18/20 | `with_decl_name% ?z ``x` | <input>:2:2: expected checkColGt |
| term | Lean.Parser.Tactic.quotSeq | 5/20 | ``(tactic\| set_option h false in intro↵                      ` | <input>:5:1: expected ')' |
| term | Lean.Parser.Term.letI | 16/20 | `letI  : show_term_elab x := set_option z.m false in "hello";` | <input>:1:49: expected tactic |
| term | Lean.Parser.Term.defaultOrOfNonempty | 20/20 | `default_or_ofNonempty% ` |  |
| term | Lean.Parser.Term.stateRefT | 12/20 | `StateRefT binop% g { ↵                      : no_index false` | <input>:1:60: unexpected end of input; expected '$' |
| term | Lean.Parser.Term.trailing_parser | 11/20 | `trailing_parser:decl_name%:`(wait_if_contains_mvar% ?g; 0) (` | <input>:1:61: expected tactic |
| term | Lean.Parser.Term.explicit | 16/20 | `@Prop` | <input>:1:13: unknown tactic |
| term | Lean.Parser.Term.open | 17/20 | `open y renaming a -> ↵  b in set_option x.g false in assert!` | <input>:3:9: expected '_', '}' or identifier |
| term | Lean.Parser.Term.valueOf | 20/20 | `value_of% y` |  |
| term | Lean.Parser.Term.dotIdent | 20/20 | `.f` |  |
| term | Lean.Parser.Term.explicitUniv | 20/20 | `b.{(max y)}` |  |
| term | Lean.Parser.Term.show | 8/20 | `show throwNamedError h binrel% n ⟨x⟩ false from "hello"` | <input>:2:2: expected checkColGt |
| term | Lean.Parser.Term.precheckedQuot | 17/20 | ```(())` | <input>:2:18: unknown tactic |
| term | Lean.Parser.Term.logNamedErrorAtMacro | 10/20 | `logNamedErrorAt unop% h no_index () a true` | <input>:1:21: unknown parser `b |
| term | Lean.Parser.Term.str | 20/20 | `"world"` |  |
| term | Lean.Parser.Term.binop | 10/20 | `binop% f ensure_expected_type% "world" binop% h logNamedErro` | <input>:1:55: unexpected end of input |
| term | Lean.Parser.Term.logNamedWarningAtMacro | 11/20 | `logNamedWarningAt 'a' m.b `x` | <input>:2:6: unexpected end of input; expected identifier |
| term | Lean.Parser.Command.quot | 19/20 | ``(#version)` | <input>:2:33: expected ':=', 'where' or '\|' |
| term | Lean.Parser.Term.debugAssert | 15/20 | `debug_assert! let_tmp  (1.5e10) := ()↵↵true↵↵()` | <input>:5:29: unknown tactic |
| term | Lean.Parser.Term.termUnless | 13/20 | `unless `(#version) do {↵try {↵pure ()↵}↵catch _ => ↵        ` | <input>:2:31: unknown tactic |
| term | Lean.Parser.Term.borrowed | 20/20 | `@& trailing_parser:try ↵                       ↵            ` |  |
| term | Lean.Parser.Term.binrel | 10/20 | `binrel% h elabToSyntax% 2 ensure_type_of% private_decl% true` | <input>:2:2: expected identifier |
| term | Lean.Parser.Term.declName | 20/20 | `decl_name%` |  |
| term | Lean.Parser.Term.quot | 17/20 | ``(match (motive := logNamedError f StateRefT false $false) n` | <input>:1:28: unknown tactic |
| term | Lean.Parser.Term.structInst | 8/20 | `{ ⋯ with  .. }` | <input>:2:2: expected '_', '}' or identifier |
| term | Lean.Parser.Term.leading_parser | 13/20 | `leading_parser (withAnonymousAntiquot := true) set_option b.` | <input>:6:44: expected ')', ',' or ':' |
| term | Lean.Parser.Term.let_tmp | 16/20 | `let_tmp  (let_mvar% ?x := dbg_trace"test";↵⋯; ()) : () := fa` | <input>:1:22: expected '{' or tactic |
| term | Lean.Parser.Term.num | 20/20 | `100` |  |
| term | Lean.Parser.Term.depArrow | 11/20 | `⦃f : logNamedError a ensure_type_of% for_in'% x false ()"tes` | <input>:4:10: unknown tactic |
| term | Lean.Parser.Term.rightact | 9/20 | `rightact% g unop% m "" ``m` | <input>:1:45: expected tactic |
| term | Lean.Parser.Term.inaccessible | 17/20 | `.((leftact% f for_in% 0() "hello" x))` | <input>:1:34: unknown parser `x |
| term | Lean.Parser.Term.throwNamedErrorMacro | 19/20 | `throwNamedError y wait_if_contains_mvar% ?a; 'a'` | <input>:1:53: unknown tactic |
| term | Lean.Parser.Term.dynamicQuot | 0/20 | ``(g\| a)` | <input>:1:5: unknown parser `g |
| term | Lean.Parser.Term.let_fun | 17/20 | `let_λ  (private_decl% Sort ↵  (1)) := false;↵false` | <input>:1:8: expected '_' or identifier |
| term | Lean.Parser.Term.haveI | 16/20 | `haveI  : 0 := nofun↵↵binop% f true 0` | <input>:1:55: expected '{' or tactic |
| term | Lean.Parser.Term.do | 16/20 | `do ↵   ↵   match_expr (meta := false) ensure_type_of% throwN` | <input>:3:19: unknown tactic |
| term | Lean.Parser.Term.omission | 20/20 | `⋯` |  |
| term | Lean.Parser.Term.arrow | 19/20 | `b -> throwNamedError m.m throwNamedError n throwNamedErrorAt` | <input>:1:38: unknown tactic |
| term | Lean.Parser.Term.cdot | 20/20 | `.` |  |
| term | Lean.Parser.Term.typeAscription | 15/20 | `(do ↵    ↵    let mut 42 := x↵     \| ↵       ↵       return ` | <input>:2:18: expected tactic |
| term | Lean.Parser.Term.have | 16/20 | `have +postponeValue : `(debug_assert! for false in x do ↵   ` | <input>:1:24: unknown tactic |
| term | Lean.Parser.Term.anonymousCtor | 19/20 | `⟨inferInstanceAs <\| for haveI  : () := "hello";↵0 in m,  g :` | <input>:1:61: expected term |
| term | Lean.Parser.Term.suffices | 7/20 | `suffices _ : binop% a default_or_ofNonempty% unsafe private_` | <input>:1:41: expected '{' or tactic |
| term | Lean.Parser.Term.fun | 19/20 | `fun↵   ↵   \| unless b do ↵                 ↵                ` | <input>:3:27: unknown tactic |
| term | Lean.Parser.Term.quotedName | 20/20 | ``x` |  |
| term | Lean.Parser.Term.liftMethod | 19/20 | `<- match (motive := ensure_type_of% throwNamedError b.x true` | <input>:5:2: unknown tactic |
| term | Lean.Parser.Term.elabToSyntax | 20/20 | `elabToSyntax% 2` |  |
| term | Lean.Parser.Term.syntheticHole | 20/20 | `?h` |  |
| term | Lean.Parser.Term.typeOf | 19/20 | `type_of% no_implicit_lambda% Prop` | <input>:1:14: unknown parser `m |
| term | Lean.Parser.Term.binrel_no_prop | 13/20 | `binrel_no_prop% b .(ensure_type_of% logNamedWarning b.g ()"w` | <input>:3:12: unexpected end of input |
| term | Lean.Parser.Term.unreachable | 20/20 | `unreachable!` |  |
| term | Lean.Parser.Term.throwNamedErrorAtMacro | 11/20 | `throwNamedErrorAt `(tactic\| match (motive := leading_parser:` | <input>:1:56: unexpected end of input; expected identifier |
| term | Lean.Parser.Term.char | 20/20 | `'a'` |  |
| term | Lean.Parser.Term.dbgTrace | 13/20 | `dbg_trace letI  +postponeValue : wait_if_type_contains_mvar%` | <input>:2:34: unknown tactic |
| term | Lean.Parser.Term.let | 14/20 | `let +postponeValue : unless (wait_if_type_contains_mvar% ?f;` | <input>:1:43: expected '{' or tactic |
| term | Lean.Parser.Term.byTactic | 10/20 | `by match (motive := for wait_if_contains_mvar% ?x; false in ` | <input>:2:27: expected '}' |
| term | Lean.Parser.Term.nomatch | 13/20 | `nomatch `(attribute [tactic_name h] g)` | <input>:1:53: expected term |
| term | Lean.Parser.Term.paren | 18/20 | `(no_index default_or_ofNonempty% )` | <input>:2:34: unknown tactic |
| term | Lean.Parser.Term.pipeCompletion | 20/20 | `a \|>.` |  |
| term | Lean.Parser.Term.termTry | 13/20 | `try ↵    ↵    Type ↵      (0) <- return x↵     \| ↵       ↵  ` | <input>:8:0: expected '$' or term |
| term | Lean.Parser.Term.tuple | 17/20 | `()` | <input>:1:35: unknown tactic |
| command | Lean.Parser.Command.syntaxCat | 20/20 | `declare_syntax_cat y` |  |
| command | Lean.Parser.Command.elab | 19/20 | `@[scoped default_instance,  scoped tactic_name n] elab:0 (pr` | <input>:2:35: expected stx |
| command | Lean.Parser.Command.in | 0/20 | `n in↵#with_exporting #import_path g` | <input>:1:0: expected command |
| command | Lean.Parser.Command.mixfix | 19/20 | `/-- doc comment text -/↵scoped infix:0 (name := z) (priority` | <input>:2:71: unknown tactic |
| command | Lean.Parser.Command.evalBang | 19/20 | `#eval! nomatch .,  ⋯` | <input>:3:2: unknown tactic |
| command | Lean.Parser.Command.tactic_extension | 20/20 | `tactic_extension y` |  |
| command | Lean.Parser.Command.import | 20/20 | `import` |  |
| command | Lean.Parser.Command.eval | 14/20 | `#eval no_implicit_lambda% y` | <input>:1:39: unknown tactic |
| command | Lean.Parser.Command.printSig | 20/20 | `#print sig m` |  |
| command | Lean.Parser.Command.export | 20/20 | `export x (n)` |  |
| command | Lean.Parser.Command.syntax | 20/20 | `/-- doc comment text -/↵scoped syntax :0 (priority := 1000) ` |  |
| command | Lean.Parser.Command.check | 15/20 | `#check set_option b.m false in clear% z↵↵do ↵   ↵   return 0` | <input>:2:22: unknown tactic |
| command | Lean.Parser.Command.recommended_spelling | 20/20 | `/-- doc comment text -/↵↵recommended_spelling "hello" for "t` |  |
| command | Lean.Parser.Command.grindPattern | 14/20 | `scoped grind_pattern [m]n => decl_name%, StateRefT logNamedE` | <input>:1:33: unknown tactic |
| command | Lean.Parser.Command.withWeakNamespace | 20/20 | `with_weak_namespace ↵  f ↵  /-- doc comment text -/↵declare_` |  |
| command | Lean.Parser.Command.synth | 17/20 | `#synth show_term_elab clear% m↵↵Prop` | <input>:1:24: unknown parser `n |
| command | Lean.Parser.Command.binderPredicate | 17/20 | `@[scoped tactic_alt b,  scoped tactic_alt g,  scoped tactic_` | <input>:2:52: expected stx |
| command | Lean.Parser.Command.importPath | 20/20 | `#import_path a` |  |
| command | Lean.Parser.Command.assertNotImported | 20/20 | `assert_not_imported m` |  |
| command | Lean.Parser.Command.macro | 19/20 | `@[scoped default_instance,  scoped tactic_name f,  tactic_na` | <input>:2:36: expected stx |
| command | Lean.Parser.Command.printAxioms | 20/20 | `#print axioms y` |  |
| command | Lean.Parser.Command.notation | 17/20 | `@[scoped extern] scoped notation:0 (priority := 1000) => fal` | <input>:2:51: unknown tactic |
| command | Lean.Parser.Command.withExporting | 20/20 | `#with_exporting #import_path h` |  |
| command | Lean.Parser.Command.assertNotExists | 20/20 | `assert_not_exists y` |  |
| command | Lean.Parser.Command.attribute | 20/20 | `attribute [-a,  -y] x` |  |
| command | Lean.Parser.Command.section | 20/20 | `@[expose] noncomputable section ↵  b` |  |
| command | Lean.Parser.Command.register_tactic_tag | 20/20 | `/-- doc comment text -/↵↵register_tactic_tag m"test"` |  |
| command | Lean.Parser.Command.printTacTags | 20/20 | `#print tactic tags` |  |
| command | Lean.Parser.Command.syntaxAbbrev | 20/20 | `private syntax h := f` |  |
| command | Lean.Parser.Command.genInjectiveTheorems | 20/20 | `gen_injective_theorems% a` |  |
| command | Lean.Parser.Command.namespace | 20/20 | `namespace ↵  b` |  |
| command | Lean.Parser.Command.open | 20/20 | `open a hiding ↵  b` |  |
| command | Lean.Parser.Command.registerErrorExplanationStx | 14/20 | `register_error_explanation y binrel% n nofun ensure_expected` | <input>:1:58: unknown tactic |
| command | Lean.Parser.Command.mutual | 19/20 | `mutual↵import↵end` | <input>:5:41: unknown tactic |
| command | Lean.Parser.Command.exit | 20/20 | `#exit` |  |
| command | Lean.Parser.Command.initialize | 14/20 | `/-- doc comment text -/↵private protected unsafe builtin_ini` | <input>:4:63: unknown tactic |
| command | Lean.Parser.Command.check_failure | 13/20 | `#check_failure `x` | <input>:1:26: unknown tactic |
| command | Lean.Parser.Command.addDocString | 20/20 | `/-- doc comment text -/↵add_decl_doc z` |  |
| command | Lean.Parser.Command.init_quot | 20/20 | `init_quot` |  |
| command | Lean.Parser.Command.set_option | 20/20 | `set_option z.m false` |  |
| command | Lean.Parser.Command.omit | 18/20 | `omit ↵  a` | <input>:2:8: unknown parser `m |
| command | Lean.Parser.Command.moduleDoc | 20/20 | `/-!doc comment text -/↵` |  |
| command | Lean.Parser.Command.variable | 9/20 | `variable ↵  ⦃h : no_index private_decl% for_in% 0 x 0}}` | <input>:2:71: unknown tactic |
| command | Lean.Parser.Command.universe | 20/20 | `universe ↵  g` |  |
| command | Lean.Parser.Command.printEqns | 20/20 | `#print eqns m` |  |
| command | Lean.Parser.Command.include | 20/20 | `include ↵  f` |  |
| command | Lean.Parser.Command.initGrindNorm | 20/20 | `init_grind_norm \| b` |  |
| command | Lean.Parser.Command.elab_rules | 17/20 | `@[scoped default_instance,  scoped tactic_name n,  default_i` | <input>:7:36: expected '=>' |
| command | Lean.Parser.Command.checkAssertions | 20/20 | `#check_assertions` |  |
| command | Lean.Parser.Command.where | 20/20 | `#where` |  |
| command | Lean.Parser.Command.declaration | 0/20 | `/-- doc comment text -/↵private protected unsafe def a _n` | <input>:2:33: unexpected end of input; expected ':=', 'where |
| command | Lean.Parser.Command.print | 20/20 | `#print ""` |  |
| command | Lean.Parser.Command.macro_rules | 16/20 | `/-- doc comment text -/↵scoped macro_rules (kind:=b)↵       ` | <input>:3:110: expected '{' or tactic |
| command | Lean.Parser.Command.end | 20/20 | `end` |  |
| command | Lean.Parser.Command.version | 20/20 | `#version` |  |
| command | Lean.Parser.Command.docs_to_verso | 20/20 | `docs_to_verso n` |  |
| command | Lean.Parser.Command.deriving | 17/20 | `deriving noncomputable instance @[expose]sorry for ensure_ty` | <input>:1:49: expected forbidden token |
| command | Lean.Parser.Command.dumpAsyncEnvState | 20/20 | `#dump_async_env_state` |  |
