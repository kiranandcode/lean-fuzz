import Lean

namespace LeanFuzz

/-- Byte stream with LCG fallback for deterministic input generation.
    AFL++ provides the initial bytes; the LCG extends when exhausted. -/
structure ByteStream where
  data : ByteArray
  pos : Nat := 0
  seed : UInt64 := 42

/-- Generation monad: produces structured values from a byte stream. -/
abbrev Gen := StateM ByteStream

namespace Gen

def byte : Gen UInt8 := do
  let s ← get
  if s.pos < s.data.size then
    let b := s.data.get! s.pos
    set { s with pos := s.pos + 1 }
    return b
  else
    let seed := s.seed * 6364136223846793005 + 1442695040888963407
    set { s with seed }
    return (seed >>> 56).toUInt8

def bytes (n : Nat) : Gen ByteArray := do
  let mut result : ByteArray := .empty
  for _ in List.range n do
    result := result.push (← byte)
  return result

def nat (bound : Nat) : Gen Nat := do
  if bound <= 1 then return 0
  if bound <= 256 then
    return (← byte).toNat % bound
  else if bound <= 65536 then
    let b0 ← byte
    let b1 ← byte
    return (b0.toNat * 256 + b1.toNat) % bound
  else
    let b0 ← byte
    let b1 ← byte
    let b2 ← byte
    let b3 ← byte
    return (b0.toNat * 16777216 + b1.toNat * 65536 + b2.toNat * 256 + b3.toNat) % bound

def bool : Gen Bool := do
  return (← byte).toNat % 2 == 0

def char : Gen Char := do
  let c ← nat 95
  return Char.ofNat (c + 32)

def string (maxLen : Nat := 64) : Gen String := do
  let len ← nat (maxLen + 1)
  let mut s := ""
  for _ in List.range len do
    s := s.push (← char)
  return s

def int (lo hi : Int) : Gen Int := do
  let range := (hi - lo).toNat + 1
  let n ← nat range
  return lo + n

def list (gen : Gen α) (maxLen : Nat := 16) : Gen (List α) := do
  let len ← nat (maxLen + 1)
  let mut result : List α := []
  for _ in List.range len do
    result := (← gen) :: result
  return result.reverse

def array (gen : Gen α) (maxLen : Nat := 16) : Gen (Array α) := do
  return (← list gen maxLen).toArray

def option (gen : Gen α) : Gen (Option α) := do
  if ← bool then return some (← gen)
  else return none

def oneOf [Inhabited α] (options : Array α) : Gen α := do
  if options.isEmpty then return default
  let i ← nat options.size
  return options[i]!

def frequency [Inhabited α] (gens : Array (Nat × Gen α)) : Gen α := do
  let total := gens.foldl (fun acc (w, _) => acc + w) 0
  if total == 0 then return default
  let mut n ← nat total
  for (w, gen) in gens do
    if n < w then return ← gen
    n := n - w
  return default

def exec (data : ByteArray) (gen : Gen α) : α × ByteStream :=
  StateT.run gen ⟨data, 0, 42⟩

def exec' (data : ByteArray) (gen : Gen α) : α :=
  (StateT.run gen ⟨data, 0, 42⟩).1

end Gen
end LeanFuzz
