namespace LeanFuzz

/-- Configuration for a LeanFuzz session.
    CLI arguments override these defaults at runtime. -/
structure FuzzConfig where
  /-- Number of iterations in standalone mode. -/
  iterations : Nat := 10000
  /-- RNG seed for standalone mode (none = use iteration index). -/
  seed : Option UInt64 := none
  /-- Print every crash (not just first 10). -/
  verbose : Bool := false
  /-- AFL++ timeout per input in milliseconds. -/
  aflTimeoutMs : Nat := 30000
  /-- Size range for generated inputs (min, max) in bytes. -/
  inputSizeRange : Nat × Nat := (64, 256)
  deriving Repr

end LeanFuzz
