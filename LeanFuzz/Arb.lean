import LeanFuzz.Gen

namespace LeanFuzz

/-- Types that can be randomly generated from a byte stream.
    Implement this for your own types to use `FuzzTarget.typed`. -/
class Arbitrary (α : Type) where
  arbitrary : Gen α

instance : Arbitrary UInt8 where
  arbitrary := Gen.byte

instance : Arbitrary Bool where
  arbitrary := Gen.bool

instance : Arbitrary Nat where
  arbitrary := Gen.nat 10000

instance : Arbitrary Char where
  arbitrary := Gen.char

instance : Arbitrary String where
  arbitrary := Gen.string

instance : Arbitrary Int where
  arbitrary := Gen.int (-10000) 10000

instance : Arbitrary UInt16 where
  arbitrary := do return UInt16.ofNat (← Gen.nat 65536)

instance : Arbitrary UInt32 where
  arbitrary := do return UInt32.ofNat (← Gen.nat 4294967296)

instance : Arbitrary ByteArray where
  arbitrary := Gen.bytes 64

instance : Arbitrary Unit where
  arbitrary := pure ()

instance [Arbitrary α] : Arbitrary (Option α) where
  arbitrary := Gen.option Arbitrary.arbitrary

instance [Arbitrary α] : Arbitrary (Array α) where
  arbitrary := Gen.array Arbitrary.arbitrary

instance [Arbitrary α] : Arbitrary (List α) where
  arbitrary := Gen.list Arbitrary.arbitrary

instance [Arbitrary α] [Arbitrary β] : Arbitrary (α × β) where
  arbitrary := do return (← Arbitrary.arbitrary, ← Arbitrary.arbitrary)

end LeanFuzz
