import LeanFuzz.Gen
import LeanFuzz.Arb

namespace LeanFuzz

/-- A fuzz target: a function to exercise with random/mutated inputs.
    Any uncaught exception, panic, or memory error is a finding. -/
structure FuzzTarget where
  name : String := "fuzz"
  run : ByteArray → IO Unit

namespace FuzzTarget

/-- Create a fuzz target from a typed function.
    Uses `Arbitrary` to generate structured inputs from raw bytes.

    ```
    def target := FuzzTarget.typed "parse" fun (input : String) => do
      let _ := MyLib.parse input
    ```
-/
def typed [Arbitrary α] (name : String := "fuzz") (f : α → IO Unit) : FuzzTarget where
  name := name
  run := fun bytes => do
    let (input, _) := Gen.exec bytes Arbitrary.arbitrary
    f input

end FuzzTarget
end LeanFuzz
