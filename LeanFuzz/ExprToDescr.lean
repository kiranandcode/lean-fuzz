import Lean

/-!
# Expr → ParserDescr extraction

Converts compiled `Parser` definitions back to `ParserDescr` by
pattern-matching on the `Expr` tree of combinator applications.
-/

open Lean Lean.Parser

namespace LeanFuzz

/-- Strip wrapping combinators (withCache, withAntiquot, evalInsideQuot, etc.) -/
partial def stripWrappers : Expr → Expr
  | .app (.app (.const ``withCache _) _) body => stripWrappers body
  | .app (.app (.const ``withAntiquot _) _) body => stripWrappers body
  | .app (.app (.const ``evalInsideQuot _) _) body => stripWrappers body
  -- NOTE: withFn is NOT stripped here — it's handled in exprToDescrCore
  -- because withFn wrapping can change semantics (e.g., lookahead = withFn lookaheadFn)
  | .app (.const ``withResetCache _) body => stripWrappers body
  | .mdata _ e => stripWrappers e
  | e => e

/-- Collect the head constant and all arguments from a nested .app chain. -/
private def collectApp (e : Expr) : Expr × Array Expr :=
  go e #[]
where
  go : Expr → Array Expr → Expr × Array Expr
    | .app f a, args => go f (args.push a)
    | e, args => (e, args.reverse)

/-- Extract a Lean Name from an Expr.
    Handles Name.str, Name.anonymous, Name.mkSimple, and any Name.mkStr*
    by unfolding through the environment and beta-reducing. -/
private partial def exprToName (env : Environment) (e : Expr) : Option Name :=
  let (head, args) := collectApp e
  match head with
  | .const n _ =>
    -- Name.str parent s — direct constructor
    if n == ``Name.str && args.size == 2 then do
      let .lit (.strVal s) := args[1]! | none
      let p ← exprToName env args[0]!
      some (Name.str p s)
    -- Name.anonymous
    else if n == ``Name.anonymous then
      some Name.anonymous
    -- Name.mkSimple _ s
    else if n == ``Name.mkSimple && args.size >= 2 then
      match args[1]! with
      | .lit (.strVal s) => some (Name.mkSimple s)
      | _ => none
    -- Any applied constant — unfold and beta-reduce
    else if args.size > 0 then do
      let ci ← env.find? n
      let val ← ci.value?
      exprToName env (Expr.beta val args)
    -- Bare constant — unfold
    else
      match env.find? n |>.bind (·.value?) with
      | some val => exprToName env val
      | none => some n
  | _ => none

/-- Extract a Nat from an Expr, unfolding constants like leadPrec/maxPrec. -/
private partial def exprToNat (env : Environment) : Expr → Option Nat
  | .lit (.natVal n) => some n
  | .app (.app (.app (.const ``OfNat.ofNat _) _) (.lit (.natVal n))) _ => some n
  | .const n _ => do exprToNat env (← (← env.find? n).value?)
  | _ => none

/-- Extract a Bool from an Expr. -/
private def exprToBool : Expr → Option Bool
  | .const ``Bool.true _ => some true
  | .const ``Bool.false _ => some false
  | _ => none

/-- Extract a Char from an Expr. -/
private def exprToChar : Expr → Option Char
  | .lit (.natVal n) => Char.ofNat n
  | .app (.app (.app (.const ``OfNat.ofNat _) _) (.lit (.natVal n))) _ => Char.ofNat n
  | .app (.const ``Char.ofNat _) (.lit (.natVal n)) => Char.ofNat n
  | _ => none

/-- Collect symbol strings from a ParserDescr (used to extract forbidden token sets). -/
partial def extractSymbols : ParserDescr → Array String
  | .symbol s => #[s.trim]
  | .nonReservedSymbol s _ => #[s.trim]
  | .binary name p₁ p₂ =>
    if name == `Lean.Parser.orelse || name == `orelse then
      extractSymbols p₁ ++ extractSymbols p₂
    else if name == `Lean.Parser.andthen || name == `andthen then
      extractSymbols p₁ ++ extractSymbols p₂
    else #[]
  | .unary _ p => extractSymbols p
  | .node _ _ p => extractSymbols p
  | _ => #[]

/-- Build a notFollowedBy descriptor encoding forbidden symbols, or a no-op if empty. -/
private def mkNotFollowedByDescr (symbols : Array String) : ParserDescr :=
  if symbols.size > 0 then
    ParserDescr.const (Name.mkStr `Lean.Parser.notFollowedBy
      (String.intercalate "," symbols.toList))
  else ParserDescr.const `Lean.Parser.checkPrec

mutual

/-- Extract a ParserDescr from a ParserFn-typed Expr by recursively decomposing
    combinator compositions (nodeFn, andthenFn, orelseFn, etc.). -/
partial def parserFnToDescr (env : Environment) (e : Expr) : ParserDescr :=
  -- Handle letE / mdata at top level — substitute and recurse
  match e with
  | .letE _ _ val body _ => parserFnToDescr env (body.instantiate1 val)
  | .mdata _ inner => parserFnToDescr env inner
  | _ =>
  let (head, fnArgs) := collectApp e
  match head with
  -- proj — .fn field access on a Parser/TrailingParser struct
  | .proj ``Parser _ parserExpr => exprToDescrCore env parserExpr
  | .proj ``TrailingParser _ parserExpr => exprToDescrCore env parserExpr
  -- nodeFn kind body — wrap in node, recurse on body
  | .const n _ =>
    if n == `Lean.Parser.nodeFn then
      let kind := exprToName env fnArgs[0]! |>.getD (panic! s!"nodeFn: can't extract kind from {fnArgs[0]!}")
      let body := parserFnToDescr env fnArgs[1]!
      ParserDescr.node kind 0 body
    -- andthenFn p q — sequential composition
    else if n == `Lean.Parser.andthenFn then
      ParserDescr.binary `Lean.Parser.andthen (parserFnToDescr env fnArgs[0]!) (parserFnToDescr env fnArgs[1]!)
    -- orelseFn p q — choice
    else if n == `Lean.Parser.orelseFn || n == `Lean.Parser.orelseFnCore then
      ParserDescr.binary `Lean.Parser.orelse (parserFnToDescr env fnArgs[0]!) (parserFnToDescr env fnArgs[1]!)
    -- recoverFn p handler — error recovery, extract main parser
    else if n == `Lean.Parser.recoverFn then
      parserFnToDescr env fnArgs[0]!
    -- withResultOfFn p f — transform result, extract main parser
    else if n == `Lean.Parser.withResultOfFn then
      parserFnToDescr env fnArgs[0]!
    -- withAntiquotFn antiq body — skip antiquot, use body
    else if n == `Lean.Parser.withAntiquotFn then
      parserFnToDescr env fnArgs[1]!
    -- withAntiquotSpliceAndSuffixFn — extract the suffix parser body
    else if n == `Lean.Parser.withAntiquotSpliceAndSuffixFn then
      parserFnToDescr env fnArgs[1]!
    -- adaptCacheableContextFn f body — pass through to body
    else if n == `Lean.Parser.adaptCacheableContextFn then
      parserFnToDescr env fnArgs[1]!
    -- rawFn p trailingWs — unwrap to inner parser
    else if n == `Lean.Parser.rawFn then
      parserFnToDescr env fnArgs[0]!
    -- Zero-output checks (Fn variants — direct parser function references)
    else if n == `Lean.Parser.notFollowedByFn then
      mkNotFollowedByDescr (extractSymbols (parserFnToDescr env fnArgs[0]!))
    else if n == `Lean.Parser.checkPrecFn then
      ParserDescr.const `Lean.Parser.checkPrec
    else if n == `Lean.Parser.checkColGeFn then
      ParserDescr.const `Lean.Parser.checkColGe
    else if n == `Lean.Parser.checkColGtFn then
      ParserDescr.const `Lean.Parser.checkColGt
    else if n == `Lean.Parser.checkLineEqFn then
      ParserDescr.const `Lean.Parser.checkLineEq
    else if n == `Lean.Parser.checkNoWsBeforeFn then
      ParserDescr.const `Lean.Parser.checkNoWsBefore
    else if n == `Lean.Parser.whitespaceBeforeFn then
      ParserDescr.const `Lean.Parser.checkWsBefore
    else if n == `Lean.Parser.ppLineFn then
      ParserDescr.const `Lean.Parser.ppLine
    else if n == `Lean.Parser.ppSpaceFn then
      ParserDescr.const `Lean.Parser.ppSpace
    else if n == `Lean.Parser.hygieneInfoFn then
      ParserDescr.const `Lean.Parser.checkPrec
    else if n == `Lean.Parser.setExpectedFn then
      if fnArgs.size >= 2 then parserFnToDescr env fnArgs[1]!
      else ParserDescr.const `Lean.Parser.checkPrec
    else if n == `Lean.Parser.checkColEqFn then
      ParserDescr.const `Lean.Parser.checkLineEq
    -- lookaheadFn — zero-output, rewinds position on success
    else if n == `Lean.Parser.lookaheadFn then
      ParserDescr.const `Lean.Parser.checkPrec
    -- Opaque single-char checks
    else if n == `Lean.Parser.satisfyFn then
      ParserDescr.const `Lean.Parser.rawToken
    -- Comment body parsers
    else if n == `Lean.Parser.finishCommentBlock || n == `Lean.Parser.versoCommentBodyFn then
      ParserDescr.const `Lean.Parser.commentBody
    -- sepBy1Fn p sep psep allowTrailingSep — reconstruct sepBy1
    else if n == `Lean.Parser.sepBy1Fn then
      let p := parserFnToDescr env fnArgs[0]!
      let psep := parserFnToDescr env fnArgs[1]!
      match fnArgs[2]! with
      | .lit (.strVal sep) =>
        let trail := if fnArgs.size >= 4 then exprToBool fnArgs[3]! |>.getD false else false
        ParserDescr.sepBy1 p sep psep trail
      | other => panic! s!"sepBy1Fn: can't extract separator from {other}"
    -- sepByFn p sep psep allowTrailingSep
    else if n == `Lean.Parser.sepByFn then
      let p := parserFnToDescr env fnArgs[0]!
      let psep := parserFnToDescr env fnArgs[1]!
      match fnArgs[2]! with
      | .lit (.strVal sep) =>
        let trail := if fnArgs.size >= 4 then exprToBool fnArgs[3]! |>.getD false else false
        ParserDescr.sepBy p sep psep trail
      | other => panic! s!"sepByFn: can't extract separator from {other}"
    -- manyFn / many1Fn
    else if n == `Lean.Parser.manyFn then
      ParserDescr.unary `Lean.Parser.many (parserFnToDescr env fnArgs[0]!)
    else if n == `Lean.Parser.many1Fn then
      ParserDescr.unary `Lean.Parser.many1 (parserFnToDescr env fnArgs[0]!)
    -- optionalFn
    else if n == `Lean.Parser.optionalFn then
      ParserDescr.unary `Lean.Parser.optional (parserFnToDescr env fnArgs[0]!)
    -- tokenFn / symbolFn
    else if n == `Lean.Parser.tokenFn then
      ParserDescr.const `Lean.Parser.rawToken
    else if n == `Lean.Parser.symbolFn then
      match fnArgs[0]! with
      | .lit (.strVal s) => ParserDescr.symbol s
      | other => panic! s!"symbolFn: can't extract symbol from {other}"
    -- identFn
    else if n == `Lean.Parser.identFn then
      ParserDescr.const `ident
    -- parserOfStackFn — dynamic dispatch based on syntax stack (truly opaque)
    else if n == `Lean.Parser.parserOfStackFn || (n.toString.splitOn "parserOfStackFn").length > 1 then
      ParserDescr.const `Lean.Parser.rawToken
    -- categoryParserFn
    else if n == `Lean.Parser.categoryParserFn then
      let catName := exprToName env fnArgs[0]! |>.getD (panic! s!"categoryParserFn: can't extract catName from {fnArgs[0]!}")
      let prec := exprToNat env fnArgs[1]! |>.getD (panic! s!"categoryParserFn: can't extract prec from {fnArgs[1]!}")
      ParserDescr.cat catName prec
    -- Decidable.rec / ite — runtime conditionals in ParserFn code.
    -- These are error handling / state checks, not parser structure.
    -- Treat as opaque (the parser still consumes input via the non-error path).
    else if n == ``Decidable.rec || n == ``ite then
      ParserDescr.const `Lean.Parser.checkPrec
    -- Unknown constant — try to unfold through environment
    else
      let val := (env.find? n |>.bind (·.value?)).getD
        (panic! s!"parserFnToDescr: can't unfold {n}")
      if fnArgs.size > 0 then
        parserFnToDescr env (Expr.beta val fnArgs)
      else
        parserFnToDescr env val
  -- Lambda — strip binder and recurse
  | .lam _ _ body _ =>
    if fnArgs.size > 0 then
      parserFnToDescr env (Expr.beta (.lam `_ (.sort .zero) body .default) fnArgs)
    else
      parserFnToDescr env body
  | other => panic! s!"parserFnToDescr: unhandled head {other.ctorName}"

/-- Main extraction: convert a parser Expr to ParserDescr.
    Fuel counts constant-unfolding steps only (structural recursion is free). -/
partial def exprToDescrCore (env : Environment) (e : Expr) : ParserDescr :=
  let e := stripWrappers e
  -- Handle letE (have/let in core Expr)
  let e := match e with
    | .letE _ _ val body _ => body.instantiate1 val
    | e => e
  let (head, args) := collectApp e
  match head with
  -- leadingNode kind prec body
  | .const ``leadingNode _ =>
    let kind := exprToName env args[0]! |>.getD (panic! s!"leadingNode: can't extract kind from {args[0]!}")
    let prec := exprToNat env args[1]! |>.getD (panic! s!"leadingNode: can't extract prec from {args[1]!}")
    ParserDescr.node kind prec (exprToDescrCore env args[2]!)

  -- trailingNode kind prec lhsPrec body
  | .const ``trailingNode _ =>
    let kind := exprToName env args[0]! |>.getD (panic! s!"trailingNode: can't extract kind")
    let prec := exprToNat env args[1]! |>.getD (panic! s!"trailingNode: can't extract prec from {args[1]!}")
    let lhsPrec := exprToNat env args[2]! |>.getD (panic! s!"trailingNode: can't extract lhsPrec from {args[2]!}")
    ParserDescr.trailingNode kind prec lhsPrec (exprToDescrCore env args[3]!)

  -- symbol str
  | .const ``symbol _ =>
    match args[0]! with
    | .lit (.strVal s) => ParserDescr.symbol s
    | other => panic! s!"symbol: expected string literal, got {other}"

  -- nonReservedSymbol str includeIdent
  | .const ``nonReservedSymbol _ =>
    match args[0]! with
    | .lit (.strVal s) =>
      let incl := if args.size >= 2 then exprToBool args[1]! |>.getD (panic! s!"nonReservedSymbol: can't extract includeIdent from {args[1]!}") else false
      ParserDescr.nonReservedSymbol s incl
    | other => panic! s!"nonReservedSymbol: expected string literal, got {other}"

  -- unicodeSymbol unicode ascii preserveForPP
  | .const ``unicodeSymbol _ =>
    match args[0]!, args[1]! with
    | .lit (.strVal u), .lit (.strVal a) =>
      let preserve := exprToBool args[2]! |>.getD (panic! s!"unicodeSymbol: can't extract preserveForPP from {args[2]!}")
      ParserDescr.unicodeSymbol u a preserve
    | _, _ => panic! s!"unicodeSymbol: expected two string literals"

  -- categoryParser catName prec
  | .const ``categoryParser _ =>
    let catName := exprToName env args[0]! |>.getD (panic! s!"categoryParser: can't extract catName")
    let prec := exprToNat env args[1]! |>.getD (panic! s!"categoryParser: can't extract prec from {args[1]!}")
    ParserDescr.cat catName prec

  -- termParser prec
  | .const ``termParser _ =>
    if args.size >= 1 then
      let prec := exprToNat env args[0]! |>.getD (panic! s!"termParser: can't extract prec from {args[0]!}")
      ParserDescr.cat `term prec
    else ParserDescr.cat `term 0

  -- HAndThen.hAndThen _ _ _ _ p1 (fun _ => p2)
  | .const ``HAndThen.hAndThen _ =>
    let p1 := args[4]!
    match args[5]! with
    | .lam _ _ p2 _ =>
      let d1 := exprToDescrCore env p1
      let d2 := exprToDescrCore env p2
      ParserDescr.binary `Lean.Parser.andthen d1 d2
    | other => panic! s!"HAndThen: expected lambda for second arg, got {other.ctorName}"

  -- HOrElse.hOrElse _ _ _ _ p1 (fun _ => p2)
  | .const ``HOrElse.hOrElse _ =>
    let p1 := args[4]!
    match args[5]! with
    | .lam _ _ p2 _ =>
      let d1 := exprToDescrCore env p1
      let d2 := exprToDescrCore env p2
      ParserDescr.binary `Lean.Parser.orelse d1 d2
    | other => panic! s!"HOrElse: expected lambda for second arg, got {other.ctorName}"

  -- Known literal parsers
  | .const ``Parser.ident _ => ParserDescr.const `ident
  | .const ``numLit _ => ParserDescr.const `numLit
  | .const ``strLit _ => ParserDescr.const `strLit
  | .const ``charLit _ => ParserDescr.const `charLit
  | .const ``scientificLit _ => ParserDescr.const `scientificLit
  | .const ``nameLit _ => ParserDescr.const `nameLit

  -- optional/many/many1/group
  | .const ``Lean.Parser.optional _ =>
    ParserDescr.unary `Lean.Parser.optional (exprToDescrCore env args[0]!)
  | .const ``Lean.Parser.many _ =>
    ParserDescr.unary `Lean.Parser.many (exprToDescrCore env args[0]!)
  | .const ``Lean.Parser.many1 _ =>
    ParserDescr.unary `Lean.Parser.many1 (exprToDescrCore env args[0]!)
  | .const ``Lean.Parser.group _ =>
    ParserDescr.unary `Lean.Parser.group (exprToDescrCore env args[0]!)

  -- sepBy / sepBy1
  | .const ``sepBy _ =>
    let p := exprToDescrCore env args[0]!
    match args[1]! with
    | .lit (.strVal sep) =>
      let psep := exprToDescrCore env args[2]!
      let trail := if args.size >= 4 then exprToBool args[3]! |>.getD (panic! s!"sepBy: can't extract trailing from {args[3]!}") else false
      ParserDescr.sepBy p sep psep trail
    | other => panic! s!"sepBy: expected string literal for separator, got {other}"
  | .const ``sepBy1 _ =>
    let p := exprToDescrCore env args[0]!
    match args[1]! with
    | .lit (.strVal sep) =>
      let psep := exprToDescrCore env args[2]!
      let trail := if args.size >= 4 then exprToBool args[3]! |>.getD (panic! s!"sepBy1: can't extract trailing from {args[3]!}") else false
      ParserDescr.sepBy1 p sep psep trail
    | other => panic! s!"sepBy1: expected string literal for separator, got {other}"

  -- interpolatedStr p
  | .const ``interpolatedStr _ =>
    if args.size >= 1 then
      -- interpolatedStr is a real parser — reference it by name for the generator
      ParserDescr.const `interpolatedStr
    else ParserDescr.const `interpolatedStr

  -- nodeWithAntiquot name kind body
  | .const ``nodeWithAntiquot _ =>
    match args[0]! with
    | .lit (.strVal name) =>
      let kind := exprToName env args[1]! |>.getD (panic! "nodeWithAntiquot: can't extract kind")
      ParserDescr.nodeWithAntiquot name kind (exprToDescrCore env args[2]!)
    | _ => exprToDescrCore env args[2]!

  -- Zero-output checks: these genuinely consume no input.
  -- They are constraints on parser state, not token producers.
  -- We use distinct names so the generator can emit appropriate whitespace.
  | .const ``checkPrec _ => ParserDescr.const `Lean.Parser.checkPrec
  | .const ``checkLhsPrec _ => ParserDescr.const `Lean.Parser.checkLhsPrec
  | .const ``setLhsPrec _ => ParserDescr.const `Lean.Parser.setLhsPrec
  | .const ``checkColGt _ => ParserDescr.const `Lean.Parser.checkColGt
  | .const ``checkColGe _ => ParserDescr.const `Lean.Parser.checkColGe
  | .const ``checkLineEq _ => ParserDescr.const `Lean.Parser.checkLineEq
  | .const ``checkWsBefore _ => ParserDescr.const `Lean.Parser.checkWsBefore
  | .const ``checkNoWsBefore _ => ParserDescr.const `Lean.Parser.checkNoWsBefore
  | .const ``checkStackTop _ => ParserDescr.const `Lean.Parser.checkStackTop
  | .const ``checkLinebreakBefore _ => ParserDescr.const `Lean.Parser.checkLinebreakBefore
  | .const ``pushNone _ => ParserDescr.const `Lean.Parser.pushNone
  | .const ``setExpected _ =>
    if args.size >= 2 then exprToDescrCore env args[1]!
    else panic! s!"setExpected with {args.size} args"
  | .const ``errorAtSavedPos _ => ParserDescr.const `Lean.Parser.errorAtSavedPos

  -- Raw parsers — these ARE real parsers but defined via ParserFn, not combinators
  | .const ``Lean.Parser.rawIdentNoAntiquot _ => ParserDescr.const `ident
  | .const ``Lean.Parser.rawIdent _ => ParserDescr.const `ident
  | .const ``Lean.Parser.fieldIdx _ => ParserDescr.const `numLit
  | .const ``Lean.Parser.rawCh _ =>
    -- rawCh parses a specific character
    if args.size >= 1 then
      match exprToChar args[0]! with
      | some c => ParserDescr.symbol c.toString
      | none => ParserDescr.const `Lean.Parser.rawCh  -- generator handles this
    else ParserDescr.const `Lean.Parser.rawCh
  | .const ``Lean.Parser.skip _ => ParserDescr.const `Lean.Parser.skip  -- actual skip combinator

  -- Doc comment parsers — opaque but we know what they do
  | .const ``Lean.Doc.Parser.ifVerso _ =>
    ParserDescr.const `Lean.Parser.commentBody
  | .const ``Lean.Doc.Parser.ifVersoModuleDocs _ =>
    ParserDescr.const `Lean.Parser.commentBody

  -- Formatting/pretty-printing hints — genuinely zero-output for parsing
  | .const ``ppAllowUngrouped _ => ParserDescr.const `Lean.Parser.ppAllowUngrouped
  | .const ``ppSpace _ => ParserDescr.const `Lean.Parser.ppSpace
  | .const ``ppLine _ => ParserDescr.const `Lean.Parser.ppLine
  | .const ``ppHardSpace _ => ParserDescr.const `Lean.Parser.ppHardSpace
  | .const ``ppHardLineUnlessUngrouped _ => ParserDescr.const `Lean.Parser.ppLine

  -- Zero-output lookahead: runs inner parser but rewinds position, produces nothing
  | .const ``lookahead _ => ParserDescr.const `Lean.Parser.checkPrec
  | .const ``notFollowedBy _ =>
    if args.size >= 1 then
      mkNotFollowedByDescr (extractSymbols (exprToDescrCore env args[0]!))
    else ParserDescr.const `Lean.Parser.checkPrec

  -- withFn f p — wraps p's fn with f. Check what f is.
  | .const ``withFn _ =>
    let f := args[0]!
    let p := args[1]!
    let (fHead, fArgs) := collectApp f
    match fHead with
    | .const n _ =>
      if n == `Lean.Parser.lookaheadFn then
        -- lookahead = withFn lookaheadFn p — zero output
        ParserDescr.const `Lean.Parser.checkPrec
      else if n == `Lean.Parser.notFollowedByFn then
        if fArgs.size > 0 then
          mkNotFollowedByDescr (extractSymbols (parserFnToDescr env fArgs[0]!))
        else ParserDescr.const `Lean.Parser.checkPrec
      else
        -- Other withFn wrappers — extract the base parser
        exprToDescrCore env p
    | _ => exprToDescrCore env p

  -- Transparent wrappers (pass through to the inner parser)
  | .const ``ppGroup _ => exprToDescrCore env args[0]!
  | .const ``ppIndent _ => exprToDescrCore env args[0]!
  | .const ``ppDedent _ => exprToDescrCore env args[0]!
  | .const ``ppRealGroup _ => exprToDescrCore env args[0]!
  | .const ``ppRealFill _ => exprToDescrCore env args[0]!
  | .const ``withPosition _ =>
    ParserDescr.unary `Lean.Parser.withPosition (exprToDescrCore env args[0]!)
  | .const ``withoutPosition _ =>
    ParserDescr.unary `Lean.Parser.withoutPosition (exprToDescrCore env args[0]!)
  | .const ``atomic _ => exprToDescrCore env args[0]!
  | .const ``suppressInsideQuot _ => exprToDescrCore env args[0]!
  | .const ``withResetCache _ => exprToDescrCore env args[0]!
  -- withAntiquotSpliceAndSuffix name p suffix — wraps p with splice handling, extract p
  | .const ``withAntiquotSpliceAndSuffix _ =>
    exprToDescrCore env args[1]!
  | .const ``incQuotDepth _ => exprToDescrCore env args[0]!
  | .const ``withForbidden _ =>
    -- withForbidden tk p — extract forbidden token and encode it before inner parser
    match args[0]! with
    | .lit (.strVal tk) =>
      let inner := exprToDescrCore env args[1]!
      ParserDescr.binary `Lean.Parser.andthen
        (ParserDescr.const (Name.mkStr `Lean.Parser.notFollowedBy tk.trim)) inner
    | _ => exprToDescrCore env args[1]!
  | .const ``withoutForbidden _ => exprToDescrCore env args[0]!
  | .const ``adaptCacheableContext _ => exprToDescrCore env args[1]!
  | .const ``orelse _ =>
    ParserDescr.binary `Lean.Parser.orelse
      (exprToDescrCore env args[0]!) (exprToDescrCore env args[1]!)
  | .const ``andthen _ =>
    ParserDescr.binary `Lean.Parser.andthen
      (exprToDescrCore env args[0]!) (exprToDescrCore env args[1]!)

  -- Category shortcuts
  | .const ``tacticParser _ =>
    if args.size >= 1 then ParserDescr.cat `tactic (exprToNat env args[0]! |>.getD (panic! s!"tacticParser: can't extract prec from {args[0]!}"))
    else ParserDescr.cat `tactic 0
  | .const ``levelParser _ =>
    if args.size >= 1 then ParserDescr.cat `level (exprToNat env args[0]! |>.getD (panic! s!"levelParser: can't extract prec from {args[0]!}"))
    else ParserDescr.cat `level 0
  | .const ``syntaxParser _ =>
    if args.size >= 1 then ParserDescr.cat `stx (exprToNat env args[0]! |>.getD (panic! s!"syntaxParser: can't extract prec from {args[0]!}"))
    else ParserDescr.cat `stx 0

  -- Parser.mk info fn — delegate to parserFnToDescr for recursive extraction
  | .const ``Parser.mk _ =>
    if args.size >= 2 then
      parserFnToDescr env args[1]!
    else
      panic! s!"exprToDescrCore: Parser.mk with {args.size} args"

  -- Decidable.rec — compile-time if/else
  | .const ``Decidable.rec _ =>
    if args.size >= 5 then
      exprToDescrCore env args[3]!
    else panic! s!"Decidable.rec with {args.size} args"

  -- Bound variable from a lambda body — this means beta reduction didn't fully
  -- substitute. This is a bug if it appears in production.
  | .bvar idx => panic! s!"exprToDescrCore: unsubstituted bvar {idx}"

  -- Reference to another constant — try to unfold it
  | .const n _ =>
    -- Known opaque parsers that we handle by name
    if n == `Lean.Parser.commentBody || n == `Lean.Parser.versoCommentBody then
      ParserDescr.const `Lean.Parser.commentBody
    -- tacticSeq* — let these unfold naturally to preserve indentation structure
    else if n == `Lean.Parser.Term.matchAltsWhereDecls then
      ParserDescr.parser n
    else if n == `Lean.Doc.Parser.ifVerso then
      if args.size >= 2 then exprToDescrCore env args[1]!
      else ParserDescr.const `Lean.Parser.commentBody
    else if args.size == 0 then
      match env.find? n |>.bind (·.value?) with
      | some val => exprToDescrCore env val
      | none => ParserDescr.parser n
    else
      -- Constant applied to arguments — unfold and beta-reduce
      let val := (env.find? n |>.bind (·.value?)).getD
        (panic! s!"exprToDescrCore: can't unfold {n}, args.size={args.size}")
      exprToDescrCore env (Expr.beta val args)

  -- Lambda (from >> thunks)
  | .lam _ _ body _ =>
    if args.size == 0 then
      exprToDescrCore env body
    else
      let reduced := Expr.beta (.lam `_ (.sort .zero) body .default) args
      exprToDescrCore env reduced

  -- proj — field access on Parser/TrailingParser struct (.fn field)
  | .proj ``Parser _ structExpr => exprToDescrCore env structExpr
  | .proj ``TrailingParser _ structExpr => exprToDescrCore env structExpr

  | other => panic! s!"exprToDescrCore: unhandled head expression: {other.ctorName}"

end -- mutual

/-- Convert a parser definition Expr to ParserDescr. -/
def exprToDescr (env : Environment) (e : Expr) : ParserDescr :=
  exprToDescrCore env e

/-- Try to extract ParserDescr for a declaration, either from its type
    (if ParserDescr/TrailingParserDescr) or from its Expr value (if Parser). -/
unsafe def extractParserDescrUnsafe (env : Environment) (declName : Name) :
    IO (Bool × ParserDescr) := do
  let some info := env.find? declName
    | panic! s!"extractParserDescr: declaration {declName} not found in environment"
  match info.type with
  | Expr.const ``ParserDescr _ =>
    match env.evalConst ParserDescr {} declName with
    | .ok d => return (true, d)
    | .error e => panic! s!"extractParserDescr: failed to eval ParserDescr for {declName}: {e}"
  | Expr.const ``TrailingParserDescr _ =>
    match env.evalConst TrailingParserDescr {} declName with
    | .ok d => return (false, d)
    | .error e => panic! s!"extractParserDescr: failed to eval TrailingParserDescr for {declName}: {e}"
  | Expr.const ``Parser _ =>
    let some val := info.value? | panic! s!"extractParserDescr: Parser {declName} has no value"
    return (true, exprToDescr env val)
  | Expr.const ``TrailingParser _ =>
    let some val := info.value? | panic! s!"extractParserDescr: TrailingParser {declName} has no value"
    return (false, exprToDescr env val)
  | other => panic! s!"extractParserDescr: unexpected type for {declName}: {other}"

@[implemented_by extractParserDescrUnsafe]
opaque extractParserDescr (env : Environment) (declName : Name) :
    IO (Bool × ParserDescr)

end LeanFuzz
