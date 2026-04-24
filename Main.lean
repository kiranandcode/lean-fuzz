import LeanFuzz

def target : LeanFuzz.FuzzTarget := {
  name := "lean-json"
  run := fun bytes => do
    let input := String.fromUTF8? bytes |>.getD ""
    let _ := Lean.Json.parse input
}

def main (args : List String) : IO Unit :=
  LeanFuzz.fuzz target args
