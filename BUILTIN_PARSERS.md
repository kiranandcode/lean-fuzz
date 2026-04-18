# Builtin Parser Definitions

## Attr.lean

### [prio] numPrio
```lean
def numPrio := checkPrec maxPrec >> numLit
```

### [attr] simple
```lean
def simple := leading_parser ident >> optional (ppSpace >> (priorityParser <|> ident))
```

### [attr] macro
```lean
def «macro» := leading_parser "macro " >> ident
```

### [attr] export
```lean
def «export» := leading_parser "export " >> ident
```

### [attr] recursor
```lean
def recursor := leading_parser nonReservedSymbol "recursor " >> numLit
```

### [attr] class
```lean
def «class» := leading_parser "class"
```

### [attr] instance
```lean
def «instance» := leading_parser "instance" >> optional (ppSpace >> priorityParser)
```

### [attr] default_instance
```lean
def default_instance := leading_parser nonReservedSymbol "default_instance" >> optional (ppSpace >> priorityParser)
```

### [attr] specialize
```lean
def «specialize» := leading_parser (nonReservedSymbol "specialize") >> many (ppSpace >> (ident <|> numLit))
```

### [attr] extern
```lean
def extern := leading_parser
  nonReservedSymbol "extern" >> many (ppSpace >> externEntry)
```

### [attr] tactic_alt
```lean
def «tactic_alt» := leading_parser
  "tactic_alt" >> ppSpace >> ident
```

### [attr] tactic_tag
```lean
def «tactic_tag» := leading_parser
  "tactic_tag" >> many1 (ppSpace >> ident)
```

### [attr] tactic_name
```lean
def «tactic_name» := leading_parser
  "tactic_name" >> ppSpace >> (ident <|> strLit)
```

## Level.lean

### [level] paren
```lean
def paren := leading_parser
  "(" >> withoutPosition levelParser >> ")"
```

### [level] max
```lean
def max := leading_parser
  nonReservedSymbol "max" true >> many1 (ppSpace >> levelParser maxPrec)
```

### [level] imax
```lean
def imax := leading_parser
  nonReservedSymbol "imax" true >> many1 (ppSpace >> levelParser maxPrec)
```

### [level] hole
```lean
def hole := leading_parser
  "_"
```

### [level] num
```lean
def num :=
  checkPrec maxPrec >> numLit
```

### [level] ident
```lean
def ident :=
  checkPrec maxPrec >> Parser.ident
```

### [level] addLit
```lean
def addLit := trailing_parser:65
  " + " >> numLit
```

## Syntax.lean

### [prec] numPrec
```lean
def numPrec := checkPrec maxPrec >> numLit
```

### [syntax] paren
```lean
def paren := leading_parser
  "(" >> withoutPosition (many1 syntaxParser) >> ")"
```

### [syntax] cat
```lean
def cat := leading_parser
  ident >> optPrecedence
```

### [syntax] unary
```lean
def unary := leading_parser
  ident >> checkNoWsBefore >> "(" >> withoutPosition (many1 syntaxParser) >> ")"
```

### [syntax] binary
```lean
def binary := leading_parser
  ident >> checkNoWsBefore >> "(" >> withoutPosition (many1 syntaxParser >> ", " >> many1 syntaxParser) >> ")"
```

### [syntax] sepBy
```lean
def sepBy := leading_parser
  "sepBy(" >> withoutPosition (many1 syntaxParser >> ", " >> strLit >>
    optional (", " >> many1 syntaxParser) >> optional (", " >> nonReservedSymbol "allowTrailingSep")) >> ")"
```

### [syntax] sepBy1
```lean
def sepBy1 := leading_parser
  "sepBy1(" >> withoutPosition (many1 syntaxParser >> ", " >> strLit >>
    optional (", " >> many1 syntaxParser) >> optional (", " >> nonReservedSymbol "allowTrailingSep")) >> ")"
```

### [syntax] atom
```lean
def atom := leading_parser
  strLit
```

### [syntax] nonReserved
```lean
def nonReserved := leading_parser
  "&" >> strLit
```

### [syntax] unicodeAtom
```lean
def unicodeAtom := leading_parser
  "unicode(" >> strLit >> ", " >> strLit >> optional (", " >> nonReservedSymbol "preserveForPP") >> ")"
```

### [command] mixfix
```lean
def «mixfix» := leading_parser
  optional docComment >> optional Term.«attributes» >> Term.attrKind >> mixfixKind >>
  precedence >> optNamedName >> optNamedPrio >> ppSpace >> notationItem >> darrow >> termParser
```

### [command] notation
```lean
def «notation» := leading_parser
  optional docComment >> optional Term.«attributes» >> Term.attrKind >>
  "notation" >> optPrecedence >> optNamedName >> optNamedPrio >> many (ppSpace >> notationItem) >> darrow >> termParser
```

### [command] macro_rules
```lean
def «macro_rules» := suppressInsideQuot <| leading_parser
  optional docComment >> optional Term.«attributes» >> Term.attrKind >>
  "macro_rules" >> optKind >> Term.matchAlts
```

### [command] syntax
```lean
def «syntax» := leading_parser
  optional docComment >> optional Term.«attributes» >> Term.attrKind >>
  "syntax " >> optPrecedence >> optNamedName >> optNamedPrio >> many1 (ppSpace >> syntaxParser argPrec) >> " : " >> ident
```

### [command] syntaxAbbrev
```lean
def syntaxAbbrev := leading_parser
  optional docComment >> optional visibility >> "syntax " >> ident >> " := " >> many1 syntaxParser
```

### [command] syntaxCat
```lean
def syntaxCat := leading_parser
  optional docComment >> "declare_syntax_cat " >> ident >> catBehavior
```

### [command] macro
```lean
def «macro» := leading_parser suppressInsideQuot <|
  optional docComment >> optional Term.«attributes» >> Term.attrKind >>
  "macro" >> optPrecedence >> optNamedName >> optNamedPrio >> many1 (ppSpace >> macroArg) >> macroTail
```

### [command] elab_rules
```lean
def «elab_rules» := leading_parser suppressInsideQuot <|
  optional docComment >> optional Term.«attributes» >> Term.attrKind >>
  "elab_rules" >> optKind >> optional (" : " >> ident) >> optional (" <= " >> ident) >> Term.matchAlts
```

### [command] elab
```lean
def «elab» := leading_parser suppressInsideQuot <|
  optional docComment >> optional Term.«attributes» >> Term.attrKind >>
  "elab" >> optPrecedence >> optNamedName >> optNamedPrio >> many1 (ppSpace >> elabArg) >> elabTail
```

### [command] binderPredicate
```lean
def binderPredicate := leading_parser
   optional docComment >> optional Term.attributes >> optional Term.attrKind >>
   "binder_predicate" >> optNamedName >> optNamedPrio >> ppSpace >> ident >> many (ppSpace >> macroArg) >> " => " >> termParser
```

## Term/Basic.lean

### [term] hole
```lean
def hole := leading_parser
  "_"
```

### [term] syntheticHole
```lean
def syntheticHole := leading_parser
  "?" >> (ident <|> "_")
```

### [term] omission
```lean
def omission := leading_parser
  "⋯"
```

### [structInstFieldDecl] structInstFieldDef
```lean
def structInstFieldDef := leading_parser
  " := " >> optional "private" >> termParser
```

### [structInstFieldDecl] structInstFieldEqns
```lean
def structInstFieldEqns := leading_parser
  optional "private" >> matchAlts
```

## Term.lean (Lean/Parser/Term.lean)

### [term] byTactic
```lean
def byTactic := leading_parser:leadPrec
  ppAllowUngrouped >> "by " >> Tactic.tacticSeqIndentGt
```

### [term] ident
```lean
def ident :=
  checkPrec maxPrec >> Parser.ident
```

### [term] num
```lean
def num : Parser :=
  checkPrec maxPrec >> numLit
```

### [term] scientific
```lean
def scientific : Parser :=
  checkPrec maxPrec >> scientificLit
```

### [term] str
```lean
def str : Parser :=
  checkPrec maxPrec >> strLit
```

### [term] char
```lean
def char : Parser :=
  checkPrec maxPrec >> charLit
```

### [term] type
```lean
def type := leading_parser
  "Type" >> optional (checkWsBefore "" >> checkPrec leadPrec >> checkColGt >> levelParser maxPrec)
```

### [term] sort
```lean
def sort := leading_parser
  "Sort" >> optional (checkWsBefore "" >> checkPrec leadPrec >> checkColGt >> levelParser maxPrec)
```

### [term] prop
```lean
def prop := leading_parser
  "Prop"
```

### [term] sorry
```lean
def «sorry» := leading_parser
  "sorry"
```

### [term] cdot
```lean
def cdot := leading_parser
  unicodeSymbol "·" "." >> hygieneInfo
```

### [term] typeAscription
```lean
def typeAscription := leading_parser
  hygienicLParen >> (withoutPosition (withoutForbidden (termParser >> " :" >> optional (ppSpace >> termParser)))) >> ")"
```

### [term] tuple
```lean
def tuple := leading_parser
  hygienicLParen >> optional (withoutPosition (withoutForbidden (termParser >> ", " >> sepBy1 termParser ", " (allowTrailingSep := true)))) >> ")"
```

### [term] paren
```lean
def paren := leading_parser
  hygienicLParen >> withoutPosition (withoutForbidden (ppDedentIfGrouped termParser)) >> ")"
```

### [term] anonymousCtor
```lean
def anonymousCtor := leading_parser
  "⟨" >> withoutPosition (withoutForbidden (sepBy termParser ", " (allowTrailingSep := true))) >> "⟩"
```

### [term] suffices
```lean
def «suffices» := leading_parser:leadPrec
  withPosition ("suffices " >> sufficesDecl) >> optSemicolon termParser
```

### [term] show
```lean
def «show» := leading_parser:leadPrec "show " >> termParser >> ppSpace >> showRhs
```

### [term] explicit
```lean
def explicit := leading_parser
  "@" >> termParser maxPrec
```

### [term] inaccessible
```lean
def inaccessible := leading_parser
  ".(" >> withoutPosition termParser >> ")"
```

### [term] depArrow
```lean
def depArrow := leading_parser:25
  bracketedBinder true >> unicodeSymbol " → " " -> " >> termParser
```

### [term] forall
```lean
def «forall» := leading_parser:leadPrec
  unicodeSymbol "∀" "forall" >>
  many1 (ppSpace >> (binderIdent <|> bracketedBinder)) >>
  optType >> ", " >> termParser
```

### [term] match
```lean
def «match» := leading_parser:leadPrec
  "match " >> optional generalizingParam >> optional motive >> sepBy1 matchDiscr ", " >>
  " with" >> ppDedent matchAlts
```

### [term] nomatch
```lean
def «nomatch» := leading_parser:leadPrec "nomatch " >> sepBy1 termParser ", "
```

### [term] nofun
```lean
def «nofun» := leading_parser "nofun"
```

### [term] structInst
```lean
def structInst := leading_parser
  "{ " >> withoutPosition (optional (atomic (sepBy1 termParser ", " >> " with "))
    >> structInstFields (sepByIndent structInstField ", " (allowTrailingSep := true))
    >> optEllipsis
    >> optional (" : " >> termParser)) >> " }"
```

### [term] fun
```lean
def «fun» := leading_parser:maxPrec
  ppAllowUngrouped >> unicodeSymbol "λ" "fun" (preserveForPP := true) >> (basicFun <|> matchAlts)
```

### [term] leading_parser
```lean
def «leading_parser» := leading_parser:leadPrec
  "leading_parser" >> optExprPrecedence >> optional withAnonymousAntiquot >> ppSpace >> termParser
```

### [term] trailing_parser
```lean
def «trailing_parser» := leading_parser:leadPrec
  "trailing_parser" >> optExprPrecedence >> optExprPrecedence >> ppSpace >> termParser
```

### [term] borrowed
```lean
def borrowed := leading_parser
  "@& " >> termParser leadPrec
```

### [term] quotedName
```lean
def quotedName := leading_parser nameLit
```

### [term] doubleQuotedName
```lean
def doubleQuotedName := leading_parser
  "`" >> checkNoWsBefore >> rawCh '`' (trailingWs := false) >> ident
```

### [term] let
```lean
def «let» := leading_parser:leadPrec
  withPosition ("let" >> letConfig >> letDecl) >> optSemicolon termParser
```

### [term] have
```lean
def «have» := leading_parser:leadPrec
  withPosition ("have" >> letConfig >> letDecl) >> optSemicolon termParser
```

### [term] let_fun
```lean
def «let_fun» := leading_parser:leadPrec
  withPosition ((symbol "let_fun " <|> "let_λ ") >> letDecl) >> optSemicolon termParser
```

### [term] let_delayed
```lean
def «let_delayed» := leading_parser:leadPrec
  withPosition ("let_delayed " >> letDecl) >> optSemicolon termParser
```

### [term] let_tmp
```lean
def «let_tmp» := leading_parser:leadPrec
  withPosition ("let_tmp " >> letDecl) >> optSemicolon termParser
```

### [term] haveI
```lean
def «haveI» := leading_parser
  withPosition ("haveI " >> letConfig >> letDecl) >> optSemicolon termParser
```

### [term] letI
```lean
def «letI» := leading_parser
  withPosition ("letI " >> letConfig >> letDecl) >> optSemicolon termParser
```

### [term] letrec
```lean
def «letrec» := leading_parser:leadPrec
  withPosition (group ("let " >> nonReservedSymbol "rec ") >> letRecDecls) >>
  optSemicolon termParser
```

### [term] noindex
```lean
def noindex := leading_parser
  "no_index " >> termParser maxPrec
```

### [term] unsafe
```lean
def «unsafe» := leading_parser:leadPrec "unsafe " >> termParser
```

### [term] binrel
```lean
def binrel := leading_parser
  "binrel% " >> ident >> ppSpace >> termParser maxPrec >> ppSpace >> termParser maxPrec
```

### [term] binrel_no_prop
```lean
def binrel_no_prop := leading_parser
  "binrel_no_prop% " >> ident >> ppSpace >> termParser maxPrec >> ppSpace >> termParser maxPrec
```

### [term] binop
```lean
def binop := leading_parser
  "binop% " >> ident >> ppSpace >> termParser maxPrec >> ppSpace >> termParser maxPrec
```

### [term] binop_lazy
```lean
def binop_lazy := leading_parser
  "binop_lazy% " >> ident >> ppSpace >> termParser maxPrec >> ppSpace >> termParser maxPrec
```

### [term] leftact
```lean
def leftact := leading_parser
  "leftact% " >> ident >> ppSpace >> termParser maxPrec >> ppSpace >> termParser maxPrec
```

### [term] rightact
```lean
def rightact := leading_parser
  "rightact% " >> ident >> ppSpace >> termParser maxPrec >> ppSpace >> termParser maxPrec
```

### [term] unop
```lean
def unop := leading_parser
  "unop% " >> ident >> ppSpace >> termParser maxPrec
```

### [term] forInMacro
```lean
def forInMacro := leading_parser
  "for_in% " >> termParser maxPrec >> termParser maxPrec >> ppSpace >> termParser maxPrec
```

### [term] forInMacro'
```lean
def forInMacro' := leading_parser
  "for_in'% " >> termParser maxPrec >> termParser maxPrec >> ppSpace >> termParser maxPrec
```

### [term] declName
```lean
def declName := leading_parser "decl_name%"
```

### [term] privateDecl
```lean
def «privateDecl» :=
  leading_parser "private_decl% " >> termParser maxPrec
```

### [term] withDeclName
```lean
def withDeclName := leading_parser
  "with_decl_name% " >> optional "?" >> ident >> ppSpace >> termParser
```

### [term] typeOf
```lean
def typeOf := leading_parser
  "type_of% " >> termParser maxPrec
```

### [term] ensureTypeOf
```lean
def ensureTypeOf := leading_parser
  "ensure_type_of% " >> termParser maxPrec >> strLit >> ppSpace >> termParser
```

### [term] ensureExpectedType
```lean
def ensureExpectedType := leading_parser
  "ensure_expected_type% " >> strLit >> ppSpace >> termParser maxPrec
```

### [term] noImplicitLambda
```lean
def noImplicitLambda := leading_parser
  "no_implicit_lambda% " >> termParser maxPrec
```

### [term] inferInstanceAs
```lean
def «inferInstanceAs» := leading_parser
  "inferInstanceAs" >> (((" $ " <|> " <| ") >> termParser minPrec) <|> (ppSpace >> termParser argPrec))
```

### [term] valueOf
```lean
def valueOf := leading_parser
  "value_of% " >> ident
```

### [term] clear
```lean
def clear := leading_parser
  "clear% " >> ident >> semicolonOrLinebreak >> ppDedent ppLine >> termParser
```

### [term] letMVar
```lean
def letMVar := leading_parser
  "let_mvar% " >> "?" >> ident >> " := " >> termParser >> "; " >> termParser
```

### [term] waitIfTypeMVar
```lean
def waitIfTypeMVar := leading_parser
  "wait_if_type_mvar% " >> "?" >> ident >> "; " >> termParser
```

### [term] waitIfTypeContainsMVar
```lean
def waitIfTypeContainsMVar := leading_parser
  "wait_if_type_contains_mvar% " >> "?" >> ident >> "; " >> termParser
```

### [term] waitIfContainsMVar
```lean
def waitIfContainsMVar := leading_parser
  "wait_if_contains_mvar% " >> "?" >> ident >> "; " >> termParser
```

### [term] defaultOrOfNonempty
```lean
def defaultOrOfNonempty := leading_parser
  "default_or_ofNonempty% " >> optional "unsafe"
```

### [term] noErrorIfUnused
```lean
def noErrorIfUnused := leading_parser
  "no_error_if_unused% " >> termParser
```

### [term] app
```lean
def app := trailing_parser:leadPrec:maxPrec many1 argument
```

### [term] proj
```lean
def proj := trailing_parser
  checkNoWsBefore >> "." >> checkNoWsBefore >> (fieldIdx <|> rawIdent)
```

### [term] completion
```lean
def completion := trailing_parser
  checkNoWsBefore >> "."
```

### [term] arrow
```lean
def arrow := trailing_parser
  checkPrec 25 >> unicodeSymbol " → " " -> " >> termParser 25
```

### [term] explicitUniv
```lean
def explicitUniv : TrailingParser := trailing_parser
  checkStackTop isIdent "expected preceding identifier" >>
  checkNoWsBefore "no space before '.{'" >> ".{" >>
  sepBy1 levelParser ", " >> "}"
```

### [term] namedPattern
```lean
def namedPattern : TrailingParser := trailing_parser
  checkStackTop isIdent "expected preceding identifier" >>
  checkNoWsBefore "no space before '@'" >> "@" >>
  optional (atomic (ident >> ":")) >> termParser maxPrec
```

### [term] pipeProj
```lean
def pipeProj := trailing_parser:minPrec
  " |>." >> checkNoWsBefore >> (fieldIdx <|> rawIdent) >> many argument
```

### [term] pipeCompletion
```lean
def pipeCompletion := trailing_parser:minPrec
  " |>."
```

### [term] subst
```lean
def subst := trailing_parser:75
  " ▸ " >> sepBy1 (termParser 75) " ▸ "
```

### [term] panic
```lean
def panic := leading_parser:leadPrec
  "panic! " >> termParser
```

### [term] unreachable
```lean
def unreachable := leading_parser:leadPrec
  "unreachable!"
```

### [term] dbgTrace
```lean
def dbgTrace := leading_parser:leadPrec
  withPosition ("dbg_trace" >> (interpolatedStr termParser <|> termParser)) >>
  optSemicolon termParser
```

### [term] assert
```lean
def assert := leading_parser:leadPrec
  withPosition ("assert! " >> termParser) >> optSemicolon termParser
```

### [term] debugAssert
```lean
def debugAssert := leading_parser:leadPrec
  withPosition ("debug_assert! " >> termParser) >> optSemicolon termParser
```

### [term] stateRefT
```lean
def stateRefT := leading_parser
  "StateRefT " >> macroArg >> ppSpace >> macroLastArg
```

### [term] dynamicQuot
```lean
def dynamicQuot := withoutPosition <| leading_parser
  "`(" >> ident >> "| " >> incQuotDepth (parserOfStack 1) >> ")"
```

### [term] dotIdent
```lean
def dotIdent := leading_parser
  "." >> checkNoWsBefore >> rawIdent
```

### [term] showTermElabImpl
```lean
def showTermElabImpl :=
  leading_parser:leadPrec "show_term_elab " >> termParser
```

### [term] matchExpr
```lean
def matchExpr := leading_parser:leadPrec
  "match_expr " >> termParser >> " with" >> ppDedent (matchExprAlts termParser)
```

### [term] letExpr
```lean
def letExpr := leading_parser:leadPrec
  withPosition ("let_expr " >> matchExprPat >> " := " >> termParser >> checkColGt >> " | " >> termParser) >> optSemicolon termParser
```

### [term] throwNamedErrorMacro
```lean
def throwNamedErrorMacro := leading_parser
  "throwNamedError " >> identWithPartialTrailingDot >> ppSpace >> (interpolatedStr termParser <|> termParser maxPrec)
```

### [term] throwNamedErrorAtMacro
```lean
def throwNamedErrorAtMacro := leading_parser
  "throwNamedErrorAt " >> termParser maxPrec >> ppSpace >> identWithPartialTrailingDot >> ppSpace >> (interpolatedStr termParser <|> termParser maxPrec)
```

### [term] logNamedErrorMacro
```lean
def logNamedErrorMacro := leading_parser
  "logNamedError " >> identWithPartialTrailingDot >> ppSpace >> (interpolatedStr termParser <|> termParser maxPrec)
```

### [term] logNamedErrorAtMacro
```lean
def logNamedErrorAtMacro := leading_parser
  "logNamedErrorAt " >> termParser maxPrec >> ppSpace >> identWithPartialTrailingDot >> ppSpace >> (interpolatedStr termParser <|> termParser maxPrec)
```

### [term] logNamedWarningMacro
```lean
def logNamedWarningMacro := leading_parser
  "logNamedWarning " >> identWithPartialTrailingDot >> ppSpace >> (interpolatedStr termParser <|> termParser maxPrec)
```

### [term] logNamedWarningAtMacro
```lean
def logNamedWarningAtMacro := leading_parser
  "logNamedWarningAt " >> termParser maxPrec >> ppSpace >> identWithPartialTrailingDot >> ppSpace >> (interpolatedStr termParser <|> termParser maxPrec)
```

## Do.lean

### [term] liftMethod
```lean
def liftMethod := leading_parser:minPrec
  leftArrow >> termParser
```

### [doElem] doLet
```lean
def doLet := leading_parser
  "let " >> optional "mut " >> letDecl
```

### [doElem] doLetElse
```lean
def doLetElse := leading_parser withPosition <|
  "let " >> optional "mut " >> termParser >> " := " >> termParser >>
  (checkColGe >> " | " >> doSeqIndent) >> optional (checkColGe >> doSeqIndent)
```

### [doElem] doLetExpr
```lean
def doLetExpr := leading_parser withPosition <|
  "let_expr " >> matchExprPat >> " := " >> termParser >>
  (checkColGe >> " | " >> doSeqIndent) >> optional (checkColGe >> doSeqIndent)
```

### [doElem] doLetMetaExpr
```lean
def doLetMetaExpr := leading_parser withPosition <|
  "let_expr " >> matchExprPat >> leftArrow >> termParser >>
  (checkColGe >> " | " >> doSeqIndent) >> optional (checkColGe >> doSeqIndent)
```

### [doElem] doLetRec
```lean
def doLetRec := leading_parser
  group ("let " >> nonReservedSymbol "rec ") >> letRecDecls
```

### [doElem] doLetArrow
```lean
def doLetArrow := leading_parser withPosition <|
  "let " >> optional "mut " >> (doIdDecl <|> doPatDecl)
```

### [doElem] doReassign
```lean
def doReassign := leading_parser
  notFollowedByRedefinedTermToken >> (letIdDeclNoBinders <|> letPatDecl)
```

### [doElem] doReassignArrow
```lean
def doReassignArrow := leading_parser
  notFollowedByRedefinedTermToken >> (doIdDecl <|> doPatDecl)
```

### [doElem] doHave
```lean
def doHave := leading_parser
  "have" >> Term.letDecl
```

### [doElem] doIf
```lean
def doIf := leading_parser withResetCache <| withPositionAfterLinebreak <| ppRealGroup <|
  ppRealFill (ppIndent ("if " >> doIfCond >> " then") >> ppSpace >> doSeq) >>
  many (checkColGe "'else if' in 'do' must be indented" >>
    group (ppDedent ppSpace >> ppRealFill (elseIf >> doIfCond >> " then " >> doSeq))) >>
  optional (checkColGe "'else' in 'do' must be indented" >>
    ppDedent ppSpace >> ppRealFill ("else " >> doSeq))
```

### [doElem] doUnless
```lean
def doUnless := leading_parser
  "unless " >> withForbidden "do" termParser >> " do " >> doSeq
```

### [doElem] doFor
```lean
def doFor := leading_parser
  "for " >> sepBy1 doForDecl ", " >> "do " >> doSeq
```

### [doElem] doMatch
```lean
def doMatch := leading_parser:leadPrec
  "match " >> optional dependentParam >> optional Term.generalizingParam >> optional Term.motive >>
  sepBy1 matchDiscr ", " >> " with" >> doMatchAlts
```

### [doElem] doMatchExpr
```lean
def doMatchExpr := leading_parser:leadPrec
  "match_expr " >> optMetaFalse >> termParser >> " with" >> doMatchExprAlts
```

### [doElem] doTry
```lean
def doTry := leading_parser
  "try " >> doSeq >> many (doCatch <|> doCatchMatch) >> optional doFinally
```

### [doElem] doBreak
```lean
def doBreak := leading_parser "break"
```

### [doElem] doContinue
```lean
def doContinue := leading_parser "continue"
```

### [doElem] doReturn
```lean
def doReturn := leading_parser:leadPrec
  withPosition ("return" >> optional (ppSpace >> checkLineEq >> termParser))
```

### [doElem] doDbgTrace
```lean
def doDbgTrace := leading_parser:leadPrec
  "dbg_trace " >> ((interpolatedStr termParser) <|> termParser)
```

### [doElem] doAssert
```lean
def doAssert := leading_parser:leadPrec
  "assert! " >> termParser
```

### [doElem] doDebugAssert
```lean
def doDebugAssert := leading_parser:leadPrec
  "debug_assert! " >> termParser
```

### [doElem] doExpr
```lean
def doExpr := leading_parser
  notFollowedByRedefinedTermToken >> termParser >>
  notFollowedBy (symbol ":=" <|> leftArrow)
    "unexpected token after 'expr' in 'do' block"
```

### [doElem] doNested
```lean
def doNested := leading_parser
  "do " >> doSeq
```

### [term] do
```lean
def «do» := leading_parser:argPrec
  ppAllowUngrouped >> "do " >> doSeq
```

### [term] termUnless
```lean
def termUnless := leading_parser
  "unless " >> withForbidden "do" termParser >> " do " >> doSeq
```

### [term] termFor
```lean
def termFor := leading_parser
  "for " >> sepBy1 doForDecl ", " >> " do " >> doSeq
```

### [term] termTry
```lean
def termTry := leading_parser
  "try " >> doSeq >> many (doCatch <|> doCatchMatch) >> optional doFinally
```

### [term] termReturn
```lean
def termReturn := leading_parser:leadPrec
  withPosition ("return" >> optional (ppSpace >> checkLineEq >> termParser))
```

## Command.lean

### [term] Term.quot
```lean
def Term.quot := leading_parser
  "`(" >> withoutPosition (incQuotDepth termParser) >> ")"
```

### [term] Term.precheckedQuot
```lean
def Term.precheckedQuot := leading_parser
  "`" >> Term.quot
```

### [term] Command.quot
```lean
def quot := leading_parser
  "`(" >> withoutPosition (incQuotDepth (many1Unbox commandParser)) >> ")"
```

### [command] moduleDoc
```lean
def moduleDoc := leading_parser ppDedent <|
  "/-!" >> Doc.Parser.ifVersoModuleDocs versoCommentBody commentBody >> ppLine
```

### [command] declaration
```lean
def declaration := leading_parser
  declModifiers false >>
  («abbrev» <|> definition <|> «theorem» <|> «opaque» <|> «instance» <|> «axiom» <|> «example» <|>
   «inductive» <|> «coinductive» <|> classInductive <|> «structure»)
```

### [command] deriving
```lean
def «deriving» := leading_parser
  "deriving " >> optional "noncomputable " >> "instance " >> derivingClasses >> " for " >> sepBy1 (recover termParser skip) ", "
```

### [command] section
```lean
def «section» := leading_parser
  sectionHeader >> "section" >> optional (ppSpace >> checkColGt >> ident)
```

### [command] namespace
```lean
def «namespace» := leading_parser
  "namespace " >> checkColGt >> ident
```

### [command] withWeakNamespace
```lean
def withWeakNamespace := leading_parser
  "with_weak_namespace " >> checkColGt >> ident >> ppSpace >> checkColGt >> commandParser
```

### [command] end
```lean
def «end» := leading_parser
  "end" >> optional (ppSpace >> checkColGt >> identWithPartialTrailingDot)
```

### [command] variable
```lean
def «variable» := leading_parser
  "variable" >> many1 (ppSpace >> checkColGt >> Term.bracketedBinder)
```

### [command] universe
```lean
def «universe» := leading_parser
  "universe" >> many1 (ppSpace >> checkColGt >> ident)
```

### [command] check
```lean
def check := leading_parser
  "#check " >> termParser
```

### [command] check_failure
```lean
def check_failure := leading_parser
  "#check_failure " >> termParser
```

### [command] importPath
```lean
def importPath := leading_parser
  "#import_path " >> ident
```

### [command] assertNotExists
```lean
def assertNotExists := leading_parser
  "assert_not_exists " >> many1 ident
```

### [command] assertNotImported
```lean
def assertNotImported := leading_parser
  "assert_not_imported " >> many1 ident
```

### [command] checkAssertions
```lean
def checkAssertions := leading_parser
  "#check_assertions" >> optional "!"
```

### [command] eval
```lean
def eval := leading_parser
  "#eval " >> termParser
```

### [command] evalBang
```lean
def evalBang := leading_parser
  "#eval! " >> termParser
```

### [command] synth
```lean
def synth := leading_parser
  "#synth " >> termParser
```

### [command] exit
```lean
def exit := leading_parser
  "#exit"
```

### [command] print
```lean
def print := leading_parser
  "#print " >> (ident <|> strLit)
```

### [command] printSig
```lean
def printSig := leading_parser
  "#print " >> nonReservedSymbol "sig " >> ident
```

### [command] printAxioms
```lean
def printAxioms := leading_parser
  "#print " >> nonReservedSymbol "axioms " >> ident
```

### [command] printEqns
```lean
def printEqns := leading_parser
  "#print " >> (nonReservedSymbol "equations " <|> nonReservedSymbol "eqns ") >> ident
```

### [command] printTacTags
```lean
def printTacTags := leading_parser
  "#print " >> nonReservedSymbol "tactic " >> nonReservedSymbol "tags"
```

### [command] where
```lean
def «where» := leading_parser
  "#where"
```

### [command] version
```lean
def version := leading_parser
  "#version"
```

### [command] withExporting
```lean
def withExporting := leading_parser
  "#with_exporting " >> commandParser
```

### [command] dumpAsyncEnvState
```lean
def dumpAsyncEnvState := leading_parser
  "#dump_async_env_state"
```

### [command] init_quot
```lean
def «init_quot» := leading_parser
  "init_quot"
```

### [command] docs_to_verso
```lean
def «docs_to_verso» := leading_parser
  "docs_to_verso " >> sepBy1 ident ", "
```

### [command] set_option
```lean
def «set_option» := leading_parser
  "set_option " >> identWithPartialTrailingDot >> ppSpace >> optionValue
```

### [command] attribute
```lean
def «attribute» := leading_parser
  "attribute " >> "[" >>
    withoutPosition (sepBy1 (eraseAttr <|> Term.attrInstance) ", ") >>
  "]" >> many1 (ppSpace >> ident)
```

### [command] export
```lean
def «export» := leading_parser
  "export " >> ident >> " (" >> many1 ident >> ")"
```

### [command] import
```lean
def «import» := leading_parser
  "import"
```

### [command] open
```lean
def «open» := leading_parser
  withPosition ("open" >> openDecl)
```

### [command] mutual
```lean
def «mutual» := leading_parser
  "mutual" >> many1 (ppLine >> notSymbol "end" >> commandParser) >>
  ppDedent (ppLine >> "end")
```

### [command] initialize
```lean
def «initialize» := leading_parser
  declModifiers false >> initializeKeyword >>
  optional (atomic (ident >> Term.typeSpec >> ppSpace >> Term.leftArrow)) >> Term.doSeq
```

### [command] in
```lean
def «in» := trailing_parser
  withOpen (ppDedent (" in" >> ppLine >> commandParser))
```

### [command] addDocString
```lean
def addDocString := leading_parser
  docComment >> "add_decl_doc " >> ident
```

### [command] register_tactic_tag
```lean
def «register_tactic_tag» := leading_parser
  optional (docComment >> ppLine) >>
  "register_tactic_tag " >> ident >> strLit
```

### [command] tactic_extension
```lean
def «tactic_extension» := leading_parser
  optional (docComment >> ppLine) >>
  "tactic_extension " >> ident
```

### [command] recommended_spelling
```lean
def «recommended_spelling» := leading_parser
  optional (docComment >> ppLine) >>
  "recommended_spelling " >> strLit >> " for " >> strLit >> " in " >>
    "[" >> sepBy1 ident ", " >> "]"
```

### [command] genInjectiveTheorems
```lean
def genInjectiveTheorems := leading_parser
  "gen_injective_theorems% " >> ident
```

### [command] include
```lean
def «include» := leading_parser "include" >> many1 (ppSpace >> checkColGt >> ident)
```

### [command] omit
```lean
def «omit» := leading_parser "omit" >>
  many1 (ppSpace >> checkColGt >> (ident <|> Term.instBinder))
```

### [command] registerErrorExplanationStx
```lean
def registerErrorExplanationStx := leading_parser
  optional docComment >> "register_error_explanation " >> ident >> termParser
```

### [term] Term.open
```lean
def «open» := leading_parser:leadPrec
  "open" >> Command.openDecl >> withOpenDecl (" in " >> termParser)
```

### [term] Term.set_option
```lean
def «set_option» := leading_parser:leadPrec
  "set_option " >> identWithPartialTrailingDot >> ppSpace >> Command.optionValue >> " in " >> termParser
```

### [tactic] Tactic.open
```lean
def «open» := leading_parser:leadPrec
  "open " >> Command.openDecl >> withOpenDecl (" in " >> tacticSeq)
```

### [tactic] Tactic.set_option
```lean
def «set_option» := leading_parser:leadPrec
  "set_option " >> identWithPartialTrailingDot >> ppSpace >> Command.optionValue >> " in " >> tacticSeq
```

### [term] Tactic.quot
```lean
def Tactic.quot : Parser := leading_parser
  "`(tactic| " >> withoutPosition (incQuotDepth tacticParser) >> ")"
```

### [term] Tactic.quotSeq
```lean
def Tactic.quotSeq : Parser := leading_parser
  "`(tactic| " >> withoutPosition (incQuotDepth Tactic.seq1) >> ")"
```

## Tactic.lean

### [tactic] unknown
```lean
def «unknown» := leading_parser
  withPosition (ident >> errorAtSavedPos "unknown tactic" true)
```

### [tactic] nestedTactic
```lean
def nestedTactic := tacticSeqBracketed
```

### [tactic] match
```lean
def «match» := leading_parser:leadPrec
  "match " >> optional Term.generalizingParam >>
  optional Term.motive >> sepBy1 Term.matchDiscr ", " >>
  " with " >> ppDedent matchAlts
```

### [tactic] introMatch
```lean
def introMatch := leading_parser
  nonReservedSymbol "intro" >> matchAlts
```
