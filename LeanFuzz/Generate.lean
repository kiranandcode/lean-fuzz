import Lean
import LeanFuzz.Grammar

/-!
# Random program generation from ParserDescr grammar

Walks the `ParserDescr` tree to produce random syntactically-plausible strings.
Tracks column position to satisfy indentation constraints (checkColGt, etc.).
-/

open Lean

namespace LeanFuzz

/-- Configuration for token pools and fallback atoms. All fields have defaults
    matching the built-in behavior, so `{}` gives the standard config. -/
structure GenConfig where
  -- Primary token pools
  identPool : Array String := #["x", "y", "z", "a", "b", "n", "m", "f", "g", "h"]
  numPool : Array String := #["1", "2", "42", "100"]
  strPool : Array String := #["\"hello\"", "\"world\"", "\"\"", "\"test\""]
  -- Parser-specific pools
  hexPool : Array String := #["0", "1", "a", "ff", "10"]
  termBeforeDoPool : Array String := #["x", "true", "false", "0"]
  optionValuePool : Array String := #["true", "false", "0", "1"]
  attrKindPool : Array String := #["", "local ", "scoped "]
  visibilityPool : Array String := #["", "private ", "protected "]
  -- Parser-specific literals
  docCommentBody : String := "doc comment text -/"
  scientificLit : String := "1.5e10"
  charLit : String := "'a'"
  nameLit : String := "`x"
  tacticSeqAtom : String := "{ skip }"
  doSeqAtom : String := "{ pure () }"
  holeAtom : String := "_"
  letDeclAtom : String := "x := 0"
  sufficesDeclAtom : String := "x : Nat by skip"
  letRecDeclsAtom : String := "f : Nat := 0"
  declIdAtom : String := "myDecl"
  antiquotAtom : String := "$x"
  inCommandLhs : String := "set_option x false"
  -- Category atom pools
  tacticAtom : String := "set_option x false in { }"
  termAtomPool : Array String := #["x", "0", "true", "false", "()", "\"hello\""]
  commandAtomPool : Array String := #["#check 0", "#eval 0", "#check Nat"]
  doElemAtomPool : Array String := #["pure ()", "return x", "return 0"]
  levelAtomPool : Array String := #["0", "1", "u"]
  attrAtomPool : Array String := #["inline", "simp", "reducible"]
  convAtomPool : Array String := #["skip", "simp", "rfl", "ext"]
  jsonAtomPool : Array String := #["1", "\"hello\"", "true", "null"]
  precAtom : String := "0"
  prioAtom : String := "1000"
  structFieldAtom : String := "x := 0"
  binderPredAtom : String := "> 0"
  grindAtom : String := "skip"
  grindRefAtom : String := "#1"
  grindFilterAtom : String := "gen = 1"
  stxAtom : String := "x"
  patternAtom : String := "_"

/-- Generation state: RNG + column tracking + recursion guard. -/
structure GenState where
  config : GenConfig := {}
  seed : UInt64
  col : Nat              -- current column (0-indexed)
  savedCol : Nat         -- saved column from withPosition (indent anchor)
  visiting : Lean.NameSet -- categories currently being expanded (recursion guard)
  noNewlines : Bool      -- inside withoutPosition (brackets) — emit spaces not newlines
  noWsBefore : Bool      -- next token must have no whitespace before it
  forbiddenPrefixes : Array String -- tokens the next term must not start with
  tokenTrie : Lean.Parser.TokenTable -- runtime token table for needsSpace checks
  lastWasSymbol : Bool             -- last emit was a grammar symbol (not ident/term)
  suppressTrail : Bool             -- suppress withPosition trail (inside non-last sepBy element)
  buffer : ByteArray := ByteArray.empty  -- fuzzer input bytes (empty = use LCG PRNG)
  bufPos : Nat := 0                      -- current read position in buffer

def GenState.next (s : GenState) : GenState × UInt64 :=
  let seed := s.seed * 6364136223846793005 + 1442695040888963407
  ({ s with seed }, seed)

def GenState.nextNat (s : GenState) (n : Nat) : GenState × Nat :=
  if n <= 1 then (s, 0)
  else if s.buffer.size > 0 && s.bufPos < s.buffer.size then
    -- Byte-driven mode: consume bytes from fuzzer input buffer
    if n <= 256 then
      let b := s.buffer.get! s.bufPos
      ({ s with bufPos := s.bufPos + 1 }, b.toNat % n)
    else
      let b0 := s.buffer.get! s.bufPos
      let b1 := if s.bufPos + 1 < s.buffer.size
                then s.buffer.get! (s.bufPos + 1) else 0
      ({ s with bufPos := s.bufPos + 2 }, (b0.toNat * 256 + b1.toNat) % n)
  else
    -- LCG PRNG mode (default, or fallback when buffer exhausted)
    let (s, v) := s.next
    (s, v.toNat % n.max 1)

/-- Construct a GenState with default fields for a given seed and category. -/
def GenState.initial (seed : UInt64) (catName : Name) (tokenTrie : Lean.Parser.TokenTable)
    (config : GenConfig := {}) : GenState :=
  { config, seed, col := 0, savedCol := 0, visiting := Lean.NameSet.empty,
    noNewlines := false, noWsBefore := false, forbiddenPrefixes := #[],
    tokenTrie, lastWasSymbol := false, suppressTrail := false }

/-- Construct a GenState that reads randomness from a byte buffer (for fuzzer integration).
    Falls back to LCG with seed 42 when the buffer is exhausted. -/
def GenState.initialWithBuffer (buf : ByteArray) (catName : Name)
    (tokenTrie : Lean.Parser.TokenTable) (config : GenConfig := {}) : GenState :=
  { config, seed := 42, col := 0, savedCol := 0, visiting := Lean.NameSet.empty,
    noNewlines := false, noWsBefore := false, forbiddenPrefixes := #[],
    tokenTrie, lastWasSymbol := false, suppressTrail := false,
    buffer := buf, bufPos := 0 }

/-- Generation monad. -/
abbrev GenM := StateM GenState

def choose (n : Nat) : GenM Nat := do
  let s ← get
  let (s, v) := s.nextNat n
  set s
  return v

def getCol : GenM Nat := return (← get).col
def getSavedCol : GenM Nat := return (← get).savedCol
def getConfig : GenM GenConfig := return (← get).config

/-- Update column tracking after emitting a string. -/
def updateCol (s : String) : GenM Unit := do
  let st ← get
  -- Find position of last newline
  let mut col := st.col
  for c in s.toList do
    if c == '\n' then col := 0
    else col := col + 1
  set { st with col }

/-- Emit a string and track column.
    When noNewlines is active, replaces newlines with spaces. -/
def emit (s : String) : GenM String := do
  let st ← get
  let s := if st.noNewlines && s.any (· == '\n') then
    String.mk (s.toList.map fun c => if c == '\n' then ' ' else c)
  else s
  updateCol s
  return s

/-- Emit a newline and indent to a specific column.
    Inside withoutPosition (brackets), emits a space instead of newline
    to avoid breaking bracket matching. -/
def newlineIndent (targetCol : Nat) : GenM String := do
  let st ← get
  if st.noNewlines then
    emit " "
  else
  if st.col <= targetCol then
    let pad := targetCol - st.col
    if pad == 0 then return ""
    let s := String.mk (List.replicate pad ' ')
    updateCol s
    return s
  else
    let s := "\n" ++ String.mk (List.replicate targetCol ' ')
    updateCol s
    return s

/-- Choose a random element from a pool and emit it. -/
def chooseFrom (pool : Array String) : GenM String := do
  let i ← choose pool.size
  emit pool[i]!


/-- Check if a ParserDescr references a Verso doc category (always needs content). -/
partial def referencesVersoCategory : ParserDescr → Bool
  | .cat name _ => name == `inline || name == `block || name == `desc_item
      || name == `list_item || name == `doc_arg || name == `arg_val || name == `link_target
  | .binary name p₁ p₂ =>
    (name == `Lean.Parser.andthen || name == `andthen) &&
    (referencesVersoCategory p₁ || referencesVersoCategory p₂)
  | .unary _ p => referencesVersoCategory p
  | .node _ _ p => referencesVersoCategory p
  | _ => false

/-- Check if a ParserDescr contains checkLinebreakBefore. -/
partial def containsLinebreak : ParserDescr → Bool
  | .const name => name == `Lean.Parser.checkLinebreakBefore || name == `linebreak
  | .binary _ p₁ p₂ => containsLinebreak p₁ || containsLinebreak p₂
  | .unary _ p => containsLinebreak p
  | .node _ _ p => containsLinebreak p
  | .nodeWithAntiquot _ _ p => containsLinebreak p
  | _ => false

/-- Check if a ParserDescr contains checkStackTop (LHS must be ident). -/
partial def containsCheckStackTop : ParserDescr → Bool
  | .const name => name == `Lean.Parser.checkStackTop
  | .binary name p₁ _ =>
    (name == `Lean.Parser.andthen || name == `andthen) && containsCheckStackTop p₁
  | .unary _ p => containsCheckStackTop p
  | .node _ _ p => containsCheckStackTop p
  | .nodeWithAntiquot _ _ p => containsCheckStackTop p
  | _ => false

/-- Check if a ParserDescr is many/many1/sepBy/sepBy1 whose body starts with checkColGe.
    Matches the `many1Indent(p) = withPosition(many1(checkColGe >> p))` pattern
    and similar `sepBy(checkColGe >> p, sep)` patterns (e.g., tacticSeqBracketed).
    When such a block finishes generating, the parser's manyAux will greedily
    try more iterations — if the next token starts `p` and is at col >= savedCol,
    the parser may consume input before failing (non-backtrackable). -/
partial def isColGatedRepetition : ParserDescr → Bool
  | .unary name p =>
    if name == `Lean.Parser.many1 || name == `many1
        || name == `Lean.Parser.many || name == `many then
      startsWithCheckColGe p
    else isColGatedRepetition p
  | .sepBy p _ _ _ => startsWithCheckColGe p
  | .sepBy1 p _ _ _ => startsWithCheckColGe p
  | .node _ _ p => isColGatedRepetition p
  | .nodeWithAntiquot _ _ p => isColGatedRepetition p
  | _ => false
where
  startsWithCheckColGe : ParserDescr → Bool
    | .const name => name == `Lean.Parser.checkColGe || name == `colGe
    | .binary name p₁ _ =>
      (name == `Lean.Parser.andthen || name == `andthen) && startsWithCheckColGe p₁
    | .unary _ p => startsWithCheckColGe p
    | .node _ _ p => startsWithCheckColGe p
    | .nodeWithAntiquot _ _ p => startsWithCheckColGe p
    | _ => false

/-- Extract the leading symbol from a ParserDescr, if it starts with one. -/
partial def leadingSymbol : ParserDescr → Option String
  | .symbol val => some val.trimRight
  | .nonReservedSymbol val _ => some val.trimRight
  | .binary name p₁ _ =>
    if name == `Lean.Parser.andthen || name == `andthen then leadingSymbol p₁
    else none
  | .unary _ p => leadingSymbol p
  | .node _ _ p => leadingSymbol p
  | .nodeWithAntiquot _ _ p => leadingSymbol p
  | _ => none

/-- Check if a ParserDescr ends with a category reference (e.g., <term>). -/
partial def endsWithCat : ParserDescr → Bool
  | .cat _ _ => true
  | .binary name _ p₂ =>
    if name == `Lean.Parser.andthen || name == `andthen then endsWithCat p₂
    else false
  | .unary _ p => endsWithCat p
  | .node _ _ p => endsWithCat p
  | .nodeWithAntiquot _ _ p => endsWithCat p
  | _ => false

/-- Check if a ParserDescr starts with checkNoWsBefore. -/
partial def startsWithNoWs : ParserDescr → Bool
  | .const name => name == `Lean.Parser.checkNoWsBefore || name == `noWs
  | .binary name p₁ _ =>
    (name == `Lean.Parser.andthen || name == `andthen) && startsWithNoWs p₁
  | .unary _ p => startsWithNoWs p
  | .node _ _ p => startsWithNoWs p
  | .nodeWithAntiquot _ _ p => startsWithNoWs p
  | _ => false

/-- Check if a ParserDescr contains pushNone (indicating an "absent" branch). -/
partial def containsPushNone : ParserDescr → Bool
  | .const name => name == `Lean.Parser.pushNone
  | .binary _ p₁ p₂ => containsPushNone p₁ || containsPushNone p₂
  | .unary _ p => containsPushNone p
  | .node _ _ p => containsPushNone p
  | .nodeWithAntiquot _ _ p => containsPushNone p
  | _ => false

/-- Generate a random string from a ParserDescr. -/
partial def generate (descr : ParserDescr) (categories : Array GrammarCategory) (catName : Name := Name.anonymous) : GenM String := do
  match descr with
  | ParserDescr.const name => genConst name
  | ParserDescr.unary name p => genUnary name p categories catName
  | ParserDescr.binary name p₁ p₂ => genBinary name p₁ p₂ categories catName
  | ParserDescr.node kind _prec p =>
    -- dynamicQuot needs a valid parser category name in the ident position.
    -- Use categories from the extracted grammar, filtered to those where
    -- an ident atom parses (not all categories accept identifiers).
    if kind == `Lean.Parser.Term.dynamicQuot then
      let catNames := categories.filterMap fun cat =>
        -- Categories where a bare identifier `x` parses as valid syntax
        if cat.rules.any (fun r => r.isLeading && match r.descr with
          | .node _ _ (.const n) => n == `ident || n == `rawIdent
          | _ => false) then some cat.name.toString
        else none
      let catNames := if catNames.size > 0 then catNames else #["term"]
      let i ← choose catNames.size
      let dynCatName := catNames[i]!
      emit s!"`({dynCatName}| x)"
    else generate p categories catName
  | ParserDescr.trailingNode kind _prec _lhsPrec p =>
    -- Trailing parsers need a valid lhs from the same category.
    -- Use the passed-in catName if available, otherwise look it up.
    let lhsCat := if catName != Name.anonymous then catName
      else (categories.findSome? fun cat =>
        if cat.rules.any (·.declName == kind) then some cat.name else none).getD Name.anonymous
    let lhs ← if kind == `Lean.Parser.Command.«in» then
        emit (← getConfig).inCommandLhs
      else if containsCheckStackTop p then
        -- checkStackTop isIdent: parser requires identifier as LHS
        chooseFrom (← getConfig).identPool
      else genCategoryAtom lhsCat
    let rest ← generate p categories catName
    -- If the trailing parser starts with noWs, don't insert space
    if startsWithNoWs p then return s!"{lhs}{rest}"
    else if (← needsSpaceM lhs rest) then return s!"{lhs} {rest}"
    else return s!"{lhs}{rest}"
  | ParserDescr.symbol val =>
    modify fun st => { st with lastWasSymbol := true }
    emit val
  | ParserDescr.nonReservedSymbol val _ =>
    modify fun st => { st with lastWasSymbol := true }
    emit val
  | ParserDescr.cat name rbp =>
    if rbp > 0 && name == `term then
      -- Parenthesize to prevent open binders (Σ', ∀, ∃) from consuming
      -- operators past the rbp boundary
      let open_ ← emit "("
      let result ← genFromCategory name rbp categories
      let close ← emit ")"
      return s!"{open_}{result}{close}"
    else genFromCategory name rbp categories
  | ParserDescr.parser declName =>
    if declName == `Lean.Parser.Term.matchAltsWhereDecls then
      -- matchAlts: generate a simple match arm
      let saved ← getSavedCol
      let indent ← newlineIndent saved
      let body ← genFromCategory `term 0 categories
      emit s!"{indent}| _ => {body}"
    -- attrKind: local/scoped/empty modifier
    else if declName == `Lean.Parser.Term.attrKind then
      chooseFrom (← getConfig).attrKindPool
    -- visibility: private/protected/empty
    else if declName == `Lean.Parser.Command.visibility then
      chooseFrom (← getConfig).visibilityPool
    else genAtom
  | ParserDescr.nodeWithAntiquot _name _kind p => generate p categories catName
  | ParserDescr.sepBy p sep _psep _trail => genSepByN 0 p sep categories catName
  | ParserDescr.sepBy1 p sep _psep _trail => genSepByN 1 p sep categories catName
  | ParserDescr.unicodeSymbol _val asciiVal _ => emit asciiVal
where
  genAtom : GenM String := do
    modify fun st => { st with lastWasSymbol := false }
    chooseFrom (← getConfig).identPool

  /-- Match parser name against both long (ExprToDescr) and short (alias) forms. -/
  nameIs (name : Name) (short : Name) (long : Name) : Bool :=
    name == short || name == long

  genConst (name : Name) : GenM String := do
    let cfg ← getConfig
    -- Known parser aliases (short alias name, then long ExprToDescr name)
    if name == `ident || name == `rawIdent then
      chooseFrom cfg.identPool
    else if name == `numLit || name == `num then
      chooseFrom cfg.numPool
    else if name == `strLit || name == `str then
      chooseFrom cfg.strPool
    -- Zero-output checks (genuinely consume no input)
    else if name == `Lean.Parser.skip
        || name == `Lean.Parser.checkPrec || name == `Lean.Parser.checkLhsPrec
        || name == `Lean.Parser.setLhsPrec || name == `Lean.Parser.checkStackTop
        || name == `Lean.Parser.pushNone || name == `Lean.Parser.errorAtSavedPos
        || name == `Lean.Parser.ppAllowUngrouped
        || name == `hygieneInfo || name == `Lean.Parser.hygieneInfo then
      return ""
    -- rawCh — a specific character parser, produce a space as safe default
    else if name == `Lean.Parser.rawCh then
      emit " "
    -- rawToken — opaque token parser, produce identifier as safe default
    else if name == `Lean.Parser.rawToken then
      chooseFrom cfg.identPool
    -- Indentation-sensitive checks (short alias + long name)
    else if nameIs name `colGt `Lean.Parser.checkColGt then
      let saved ← getSavedCol
      let col ← getCol
      if col > saved then return ""  -- already past savedCol
      else newlineIndent (saved + 2)
    else if nameIs name `colGe `Lean.Parser.checkColGe then
      let saved ← getSavedCol
      let col ← getCol
      if col >= saved then return ""  -- already at or past savedCol
      else newlineIndent saved
    else if nameIs name `lineEq `Lean.Parser.checkLineEq
        || nameIs name `colEq `Lean.Parser.checkColEq then
      return ""
    -- Whitespace checks
    else if nameIs name `ws `Lean.Parser.checkWsBefore
        || name == `Lean.Parser.ppSpace || name == `Lean.Parser.ppHardSpace then
      emit " "
    else if nameIs name `linebreak `Lean.Parser.checkLinebreakBefore then
      -- Parser checks for a newline before the current position — must emit one.
      -- Emit just newline (no indentation) — let colGe/colGt handle column positioning.
      let st ← get
      if st.noNewlines then emit " "
      else
        updateCol "\n"
        return "\n"
    else if name == `Lean.Parser.ppLine then
      let saved ← getSavedCol
      newlineIndent saved
    else if nameIs name `noWs `Lean.Parser.checkNoWsBefore then
      modify fun st => { st with noWsBefore := true }
      return ""  -- flag tells andthen to strip whitespace
    -- Lookahead — zero-output check
    else if name == `lookahead || name == `Lean.Parser.notFollowedBy then
      return ""
    -- notFollowedBy with extracted forbidden symbols
    else if name.getRoot == `Lean && (name.toString.splitOn "notFollowedBy").length > 1 then
      -- Extract forbidden symbols from the encoded name
      let parts := name.toString.splitOn "notFollowedBy."
      if parts.length > 1 then
        let symbolsStr := parts.getLast!
        let symbols := symbolsStr.splitOn "," |>.toArray
        modify fun st => { st with forbiddenPrefixes := symbols }
      return ""
    -- Doc comment body
    else if name == `Lean.Parser.commentBody then
      emit cfg.docCommentBody
    -- Literal parsers
    else if nameIs name `scientific `scientificLit then emit cfg.scientificLit
    else if nameIs name `char `charLit then emit cfg.charLit
    else if nameIs name `name `nameLit then emit cfg.nameLit
    else if name == `hexnum then
      -- hexnum parses raw hex digits (0-9, a-f) — NOT 0x-prefixed
      chooseFrom cfg.hexPool
    else if name == `interpolatedStr then
      chooseFrom cfg.strPool
    -- Tactic/do sequence aliases — generate brace-delimited blocks
    else if name == `tacticSeq || name == `Lean.Parser.Tactic.tacticSeq then
      emit cfg.tacticSeqAtom
    else if name == `tacticSeqIndentGt
        || name == `Lean.Parser.Tactic.tacticSeqIndentGt then
      emit cfg.tacticSeqAtom
    else if name == `matchRhsTacticSeq then
      emit cfg.tacticSeqAtom
    else if name == `doSeq || name == `Lean.Parser.Term.doSeq then
      emit cfg.doSeqAtom
    -- Term-like parser aliases
    else if name == `termBeforeDo then
      chooseFrom cfg.termBeforeDoPool
    else if name == `hole then emit cfg.holeAtom
    -- Declaration-like parser aliases
    else if name == `letDecl then
      emit cfg.letDeclAtom
    else if name == `sufficesDecl then
      emit cfg.sufficesDeclAtom
    else if name == `letRecDecls then
      emit cfg.letRecDeclsAtom
    -- Option values (for set_option)
    else if name == `optionValue then
      chooseFrom cfg.optionValuePool
    -- Declaration modifiers/binders (emit empty — they're optional in most contexts)
    else if name == `declModifiers || name == `Lean.Parser.Command.declModifiers then
      return ""
    else if name == `bracketedBinder || name == `Lean.Parser.Term.bracketedBinder then
      return ""
    else if name == `letConfig then
      return ""
    else if name == `declId || name == `Lean.Parser.Command.declId then
      emit cfg.declIdAtom
    -- Catch-all: treat unknown consts as no-ops (may be formatting hints or checks)
    else
      return ""

  genUnary (name : Name) (p : ParserDescr) (cats : Array GrammarCategory) (cn : Name) : GenM String := do
    if nameIs name `optional `Lean.Parser.optional
        || nameIs name `many `Lean.Parser.many then
      -- Inside brackets, linebreak can never fire — parser's checkLinebreakBefore
      -- would fail. So many/optional blocks containing linebreak must produce 0 elements.
      let st ← get
      if st.noNewlines && containsLinebreak p then return ""
      -- Verso categories always need content — never return empty
      if referencesVersoCategory p then
        return (← generate p cats cn)
      -- 50% chance to include optional/many content
      let coin ← choose 2
      if coin == 0 then return ""
      else generate p cats cn
    else if nameIs name `many1 `Lean.Parser.many1 then
      generate p cats cn
    else if name == `Lean.Parser.group || name == `Lean.Parser.ppGroup
        || name == `Lean.Parser.ppIndent || name == `Lean.Parser.ppDedent
        || name == `Lean.Parser.ppRealGroup || name == `Lean.Parser.ppRealFill
        || name == `Lean.Parser.ppAllowUngrouped
        || name == `manyIndent || name == `many1Indent
        || name == `recover || name == `withoutForbidden then
      generate p cats cn
    else if nameIs name `atomic `Lean.Parser.atomic then
      generate p cats cn
    -- Zero-output lookahead — suppress the inner content
    else if name == `Lean.Parser.notFollowedBy || name == `notFollowedBy
        || name == `lookahead || name == `Lean.Parser.lookahead then
      return ""
    -- interpolatedStr(p) — generate a string literal (argument p is for {} interpolation)
    else if name == `interpolatedStr then
      chooseFrom (← getConfig).strPool
    else if nameIs name `withPosition `Lean.Parser.withPosition then
      let st ← get
      let prevSaved := st.savedCol
      -- Use actual column to match the parser's withPosition (which saves
      -- the exact byte position). The cap is only applied when no trail
      -- is needed, to avoid over-indenting on long lines.
      let needsTrail := isColGatedRepetition p && st.col > prevSaved
      let newSaved := if needsTrail then st.col else min st.col (prevSaved + 4)
      set { st with savedCol := newSaved }
      let result ← generate p cats cn
      modify fun st => { st with savedCol := prevSaved }
      -- For withPosition blocks containing many/many1/sepBy(checkColGe >> ...),
      -- drop the column below newSaved after generating. This prevents
      -- the parser's greedy manyAux from consuming tokens that belong
      -- to the outer grammar — manyAux only backtracks on zero progress.
      -- Suppressed when inside a non-last sepBy element, since the trailing
      -- newline would let the parser's trailing-separator mode consume a
      -- separator that belongs to the outer repetition.
      if needsTrail then
        let postSt ← get
        if !postSt.suppressTrail && !postSt.noNewlines && postSt.col >= newSaved then
          let trail ← newlineIndent prevSaved
          return s!"{result}{trail}"
      return result
    else if nameIs name `withoutPosition `Lean.Parser.withoutPosition then
      -- Inside brackets — suppress newlines from indentation combinators
      let st ← get
      let prevNoNewlines := st.noNewlines
      set { st with noNewlines := true }
      let result ← generate p cats cn
      modify fun st => { st with noNewlines := prevNoNewlines }
      return result
    else
      generate p cats cn

  /-- Would these two strings merge into a single token if concatenated?
      Checks both identifier char merging and registered token merging
      using the runtime token trie. -/
  needsSpace (s₁ s₂ : String) (trie : Lean.Parser.TokenTable) : Bool :=
    if s₁.isEmpty || s₂.isEmpty then false
    else
      let last := s₁.back
      let first := s₂.front
      let isIdChar (c : Char) : Bool := c.isAlphanum || c == '_' || c == '\''
      -- Two identifier chars would merge tokens
      (isIdChar last && isIdChar first)
      -- Dotted name continuation: isIdCont extends identifiers through
      -- '.' + identChar, so "foo" ++ ".bar" becomes a single "foo.bar" token.
      || (isIdChar last && first == '.' && s₂.length > 1 &&
          (let second := s₂.get ⟨1⟩; isIdChar second || second == '«'))
      -- Special chars that glue to following alphanum (!, ?) — e.g., simp!, grind?
      || ((last == '!' || last == '?') && (first.isAlphanum || first == '_'))
      -- Alphanum/id followed by special chars that start new tokens
      || (isIdChar last && (first == '!' || first == '?'))
      -- Closing bracket followed by identifier char needs space
      || ((last == ')' || last == ']' || last == '}') && isIdChar first)
      -- Opening bracket followed by identifier char — avoid tokenizer confusion
      || ((last == '{' || last == '[') && isIdChar first)
      -- Digit followed by 'x' (hex prefix 0x)
      || (last.isDigit && first == 'x')
      -- ? followed by ! merges into ?! token
      || (last == '?' && first == '!')
      -- ! followed by ! or ( without space: in `name!!(args)`, the parser
      -- consumes `name!` then `!(args)` becomes a separate expression.
      -- Space ensures `name! !(args)` parses as intended.
      || (last == '!' && (first == '!' || first == '('))
      -- Operator symbol continuation: Lean's tokenizer extends tokens greedily
      -- through these chars, so `:=~~~` becomes one token instead of `:=` + `~~~`
      || (let isOpCont (c : Char) : Bool :=
            c == '~' || c == '+' || c == '*' || c == '/' || c == '<' || c == '>' ||
            c == '=' || c == '^' || c == '|' || c == '&' || c == '%' || c == '\\'
          isOpCont last && isOpCont first)
      -- Check registered multi-char tokens using the runtime trie.
      -- Prepend `last` to `s₂` and check if the trie matches a token
      -- longer than `last` alone. matchPrefix walks the full string
      -- greedily, catching tokens of any length (`:~`, `%[`, `!~>`, etc.).
      || (let lastStr := String.mk [last]
          let combo := lastStr ++ s₂
          let lastMatch := Lean.Data.Trie.matchPrefix (lastStr ++ " ") trie 0
          let comboMatch := Lean.Data.Trie.matchPrefix combo trie 0
          match lastMatch, comboMatch with
          | some tk1, some tk2 => tk2.length > tk1.length
          | none, some _ => true
          | _, _ => false)

  /-- Monadic wrapper for needsSpace that reads the token trie from state. -/
  needsSpaceM (s₁ s₂ : String) : GenM Bool := do
    return needsSpace s₁ s₂ (← get).tokenTrie

  isAndthen (name : Name) : Bool :=
    name == `Lean.Parser.andthen || name == `andthen
  isOrelse (name : Name) : Bool :=
    name == `Lean.Parser.orelse || name == `orelse

  genBinary (name : Name) (p₁ p₂ : ParserDescr) (cats : Array GrammarCategory) (cn : Name) : GenM String := do
    if isAndthen name then
      -- If p₁ ends with a category (e.g., <term>) and p₂ starts with an
      -- alphabetic keyword (e.g., "by", "do"), set forbiddenPrefixes so
      -- the category generator avoids producing terms that absorb it.
      -- Only alphabetic keywords can be absorbed — symbols like ")", "]"
      -- never start a term parser and are unambiguous.
      if endsWithCat p₁ then
        if let some sym := leadingSymbol p₂ then
          let sym := sym.trim
          if !sym.isEmpty && sym.front.isAlpha then
            modify fun st => { st with forbiddenPrefixes := st.forbiddenPrefixes.push sym }
      let s₁ ← generate p₁ cats cn
      -- If noWsBefore was set during s₁ generation OR p₂ starts with
      -- checkNoWsBefore (e.g., optional(checkNoWsBefore "." ...)),
      -- strip whitespace at the join.
      let st ← get
      if st.noWsBefore || startsWithNoWs p₂ then
        modify fun st => { st with noWsBefore := false }
        let s₂ ← generate p₂ cats cn
        -- Strip trailing ws from s₁ and leading ws from s₂
        let s₁ := s₁.trimRight
        let s₂ := s₂.trimLeft
        updateCol s₂
        return s!"{s₁}{s₂}"
      else
        let s₂ ← generate p₂ cats cn
        if (← needsSpaceM s₁ s₂) then
          updateCol " "
          return s!"{s₁} {s₂}"
        else return s!"{s₁}{s₂}"
    else if isOrelse name then
      -- Prefer branches that don't contain pushNone (absent/void paths)
      let p1HasNone := containsPushNone p₁
      let p2HasNone := containsPushNone p₂
      if p1HasNone && !p2HasNone then
        generate p₂ cats cn
      else if p2HasNone && !p1HasNone then
        generate p₁ cats cn
      else
        let coin ← choose 2
        if coin == 0 then generate p₁ cats cn
        else generate p₂ cats cn
    else
      let s₁ ← generate p₁ cats cn
      let s₂ ← generate p₂ cats cn
      return s!"{s₁} {s₂}"

  /-- Atom fallback for a category — used to break recursion. -/
  genCategoryAtom (catName : Name) : GenM String := do
    let cfg ← getConfig
    if catName == `tactic then
      -- set_option wrapper avoids brace-counting ambiguity with tacticSeqBracketed
      emit cfg.tacticAtom
    else if catName == `term then
      chooseFrom cfg.termAtomPool
    else if catName == `command then
      chooseFrom cfg.commandAtomPool
    else if catName == `doElem then
      chooseFrom cfg.doElemAtomPool
    else if catName == `level then
      chooseFrom cfg.levelAtomPool
    else if catName == `stx then emit cfg.stxAtom
    else if catName == `attr then
      chooseFrom cfg.attrAtomPool
    else if catName == `conv then
      chooseFrom cfg.convAtomPool
    else if catName == `grind then
      emit cfg.grindAtom
    else if catName == `grind_ref then
      emit cfg.grindRefAtom
    else if catName == `grind_filter then
      emit cfg.grindFilterAtom
    else if catName == `json then
      chooseFrom cfg.jsonAtomPool
    else if catName == `prec then emit cfg.precAtom
    else if catName == `prio then emit cfg.prioAtom
    else if catName == `structInstFieldDecl then emit cfg.structFieldAtom
    else if catName == `binderPred then
      emit cfg.binderPredAtom
    -- Doc/Verso categories — generate minimal valid content
    else if catName == `rawStx then
      emit cfg.antiquotAtom
    else if catName == `block || catName == `inline
        || catName == `doc_arg || catName == `arg_val || catName == `link_target
        || catName == `list_item || catName == `desc_item then
      emit cfg.antiquotAtom
    -- rcases/mcases/mrevert/mintro patterns
    else if catName == `rcasesPat || catName == `mcasesPat || catName == `mrefinePat
        || catName == `mintroPat || catName == `mrevertPat || catName == `rintroPat then
      emit cfg.patternAtom
    else genAtom

  genFromCategory (catName : Name) (rbp : Nat) (cats : Array GrammarCategory) : GenM String := do
    let st ← get
    -- If already visiting this category (recursion), use atom to break cycle
    if st.visiting.contains catName then
      return (← genCategoryAtom catName)
    -- When forbidden prefixes are active, use atom to avoid starting with forbidden tokens
    if st.forbiddenPrefixes.size > 0 then
      modify fun st => { st with forbiddenPrefixes := #[] }
      return (← genCategoryAtom catName)
    -- Categories that need special handling — skip rule expansion
    -- Verso doc categories only accept antiquotations
    -- mrefinePat: extraction loses term:max precedence, generate atom instead
    if catName == `block || catName == `inline || catName == `rawStx
        || catName == `doc_arg || catName == `arg_val || catName == `link_target
        || catName == `list_item || catName == `desc_item
        || catName == `mrefinePat then
      return (← genCategoryAtom catName)
    -- Expand a grammar rule for this category
    let prevNoNewlines := st.noNewlines
    modify fun st => { st with visiting := st.visiting.insert catName }
    let result ← do
      match cats.find? (·.name == catName) with
      | some cat =>
        let leadingRules := cat.rules.filter (·.isLeading)
        let rules := if leadingRules.size > 0 then leadingRules else cat.rules
        let eligible := if rbp > 0 then
          rules.filter fun r => match r.descr with
            | .node _ prec _ => prec >= rbp
            | .trailingNode _ prec _ _ => prec >= rbp
            | _ => true
        else rules
        let rules := if eligible.size > 0 then eligible else rules
        if rules.size == 0 then genCategoryAtom catName
        else
          let i ← choose rules.size
          generate rules[i]!.descr cats catName
      | none => genCategoryAtom catName
    modify fun st => { st with
      visiting := st.visiting.erase catName
      noNewlines := prevNoNewlines }
    return result

  /-- Generate a separated list with at least `minN` elements (0 for sepBy, 1 for sepBy1). -/
  genSepByN (minN : Nat) (p : ParserDescr) (sep : String) (cats : Array GrammarCategory) (cn : Name) : GenM String := do
    let n ← choose 3
    let n := n + minN
    if n == 0 then return ""
    let prevSuppressTrail := (← get).suppressTrail
    let mut result := ""
    for i in List.range n do
      if i > 0 then
        modify fun st => { st with suppressTrail := prevSuppressTrail }
        let s ← emit sep
        result := result ++ s
        let sp ← emit " "
        result := result ++ sp
      -- Suppress withPosition trails for non-last elements to prevent
      -- the parser's trailing-separator mode from stealing the outer separator.
      let isLast := i == n - 1
      modify fun st => { st with suppressTrail := if isLast then prevSuppressTrail else true }
      let elem ← generate p cats cn
      if (← needsSpaceM result elem) then
        updateCol " "
        result := result ++ " "
      result := result ++ elem
    modify fun st => { st with suppressTrail := prevSuppressTrail }
    return result

/-- Generate a random program from the grammar. -/
def generateProgram (grammar : Grammar) (tokenTrie : Lean.Parser.TokenTable)
    (seed : UInt64 := 42) (category : Name := `command) : String :=
  let state := GenState.initial seed category tokenTrie
  let result := generate (ParserDescr.cat category 0) grammar.categories |>.run state
  result.1

/-- Generate a random program using fuzzer input bytes as the randomness source. -/
def generateProgramFromBytes (grammar : Grammar) (tokenTrie : Lean.Parser.TokenTable)
    (buffer : ByteArray) (category : Name := `command) : String :=
  let state := GenState.initialWithBuffer buffer category tokenTrie
  let result := generate (ParserDescr.cat category 0) grammar.categories |>.run state
  result.1

end LeanFuzz
