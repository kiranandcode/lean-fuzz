# lean-fuzz

Grammar-based fuzzer for Lean 4 syntax. Extracts the complete parser grammar from Lean's runtime environment and generates random syntactically-valid programs for every parser rule.

**1067/1067 rules generate parseable output** (40 trials each, Init + Lean builtins).

## Usage

```bash
lake build
lake exe lean-fuzz                    # print grammar summary
lake exe lean-fuzz --validate         # score every rule (20 trials each)
lake exe lean-fuzz --partials         # show rules that sometimes fail
lake exe lean-fuzz --zeros            # show rules that never parse
lake exe lean-fuzz --audit            # full audit with generated examples
lake exe lean-fuzz --import Mathlib   # import additional modules
```

## Architecture

```
LeanFuzz/
  ExprToDescr.lean   Expr -> ParserDescr decompilation
  Grammar.lean       grammar extraction from parser extension state
  Generate.lean      ParserDescr -> random string generation
  Validate.lean      parse-back validation via runParserCategory
  Pretty.lean        BNF-like pretty-printing of ParserDescr
  Command.lean       #grammar / #grammar_raw elab commands
  Test.lean          test suite (lake test)
Main.lean            CLI entry point
```

### Pipeline

1. **Extract** (`Grammar.lean`): Iterates `parserExtension.getState` to collect all parser categories and their registered kinds. Activates scoped entries so `scoped syntax` rules are visible.

2. **Decompile** (`ExprToDescr.lean`): Each parser kind maps to a declaration in the environment. If its type is `ParserDescr`/`TrailingParserDescr`, evaluates directly via `evalConst`. If its type is `Parser`/`TrailingParser` (compiled parsers), recursively decompiles the `Expr` tree back to `ParserDescr` by pattern-matching on combinator applications (`andthenFn`, `orelseFn`, `nodeFn`, etc.).

3. **Generate** (`Generate.lean`): Walks the `ParserDescr` tree with a `GenM` state monad tracking column position, indentation anchors, and recursion guards. Emits random strings that satisfy indentation constraints (`checkColGe`, `checkColGt`, `withPosition`), whitespace requirements (`checkNoWsBefore`, `checkLinebreakBefore`), and token separation (`needsSpace` using the runtime token trie).

4. **Validate** (`Validate.lean`): Feeds generated strings back into `Lean.Parser.runParserCategory` to verify they parse.

### Key design decisions

- **Runtime data over hardcoding**: Token merging detection uses the runtime `TokenTable` trie (threaded through `GenState`). Category names for dynamic quotations are pulled from the extracted grammar. All literal pools (identifiers, numbers, strings, category atoms) are configurable via `GenConfig` — the defaults are only fallback values for recursion-breaking.

- **Parser-faithful generation**: The generator models Lean's parser behavior precisely:
  - `withPosition` saves the actual column and emits trailing newlines for `many1Indent`/`manyIndent` patterns (where the parser's `manyAux` only backtracks on zero progress)
  - `withoutPosition` suppresses newlines to match bracket-scoped parsing
  - `forbiddenPrefixes` prevents greedy term absorption when an alphabetic keyword follows a category reference (modeling `withForbidden`)
  - `needsSpace` checks the token trie to prevent multi-char token merging across grammar boundaries

- **No depth limits**: Recursion terminates via the `visiting` set in `GenState` -- when a category is already being expanded, `genCategoryAtom` provides a minimal valid fallback.

- **No simplification**: The generator never prefers "simpler" rules to work around bugs. It walks the `ParserDescr` faithfully and generates from the grammar as-is.

## Configuration

All token pools and fallback atoms are configurable via `GenConfig`. Pass a custom config when creating the generator state:

```lean
let config : GenConfig := {
  identPool := #["foo", "bar", "baz"],
  numPool := #["0", "1", "2"],
  termAtomPool := #["foo", "0", "true"],
}
let state := GenState.initial seed catName tokenTrie config
```

Every field has a default matching the built-in behavior, so `{}` gives the standard config. See `GenConfig` in `Generate.lean` for all available fields.

## Running tests

```bash
lake test    # 28 tests, ~2 min
```

Tests cover:
- Grammar extraction structure (category counts, rule counts)
- No zero-score rules across all builtin parsers (40 trials)
- Custom `declare_syntax_cat` / `syntax` extraction
- Full validation: 100% perfect rules at 40 trials, zero zeros
