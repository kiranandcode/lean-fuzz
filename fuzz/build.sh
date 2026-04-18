#!/usr/bin/env bash
set -euo pipefail

# Build lean-fuzz's libFuzzer harness.
#
# Usage:
#   ./fuzz/build.sh            # libFuzzer + UBSan (recommended)
#   ./fuzz/build.sh asan       # libFuzzer + ASan + UBSan (may conflict with Lean allocator)
#   ./fuzz/build.sh valgrind   # libFuzzer only (for use with valgrind)
#
# Note: ASan conflicts with Lean's custom allocator on macOS.
#       Use default (ubsan) mode or valgrind mode for memory bug detection.
#
# Requirements:
#   Linux:  apt install clang (standard clang includes libFuzzer)
#   macOS:  brew install llvm (Apple's clang lacks libFuzzer)

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LEAN_SYSROOT="${LEAN_SYSROOT:-$(lean --print-prefix)}"
LEAN_INCLUDE="$LEAN_SYSROOT/include"
LEAN_LIB="$LEAN_SYSROOT/lib/lean"
LEAN_LIB_BASE="$LEAN_SYSROOT/lib"
IR_DIR="$PROJECT_ROOT/.lake/build/ir"
FUZZ_DIR="$PROJECT_ROOT/fuzz"
BUILD_DIR="$FUZZ_DIR/build"
MODE="${1:-ubsan}"

# --- Find a clang with libFuzzer runtime ---
find_fuzz_cc() {
    # Custom FUZZ_CC from environment takes priority
    if [ -n "${FUZZ_CC:-}" ]; then
        echo "$FUZZ_CC"
        return
    fi
    # On Linux, system clang usually has libFuzzer
    if [ "$(uname)" = "Linux" ]; then
        for cc in clang-19 clang-18 clang-17 clang-16 clang; do
            if command -v "$cc" >/dev/null 2>&1; then
                echo "$cc"
                return
            fi
        done
    fi
    # On macOS, need Homebrew LLVM
    if [ -x "/opt/homebrew/opt/llvm/bin/clang" ]; then
        echo "/opt/homebrew/opt/llvm/bin/clang"
        return
    fi
    if [ -x "/usr/local/opt/llvm/bin/clang" ]; then
        echo "/usr/local/opt/llvm/bin/clang"
        return
    fi
    return 1
}

FUZZ_CC="$(find_fuzz_cc)" || {
    echo "Error: No clang with libFuzzer found."
    echo ""
    if [ "$(uname)" = "Darwin" ]; then
        echo "  macOS: brew install llvm"
    else
        echo "  Linux: apt install clang"
    fi
    echo ""
    echo "Or set FUZZ_CC=/path/to/clang with libFuzzer support."
    exit 1
}

echo "Using clang: $FUZZ_CC"
echo "Mode: $MODE"
echo ""

mkdir -p "$BUILD_DIR"

# --- Step 1: Build LeanFuzz library with Lake ---
echo "=== Step 1: lake build LeanFuzz ==="
cd "$PROJECT_ROOT"
lake build LeanFuzz

# --- Step 2: Compile Lean-generated C with coverage instrumentation ---
# Use FUZZ_CC (not leanc) for all compilation to avoid object format
# mismatch between leanc's lld and the system linker.
echo "=== Step 2: Compile Lean C with instrumentation ==="

C_FILES=(
    "$IR_DIR/LeanFuzz.c"
    "$IR_DIR/LeanFuzz/ExprToDescr.c"
    "$IR_DIR/LeanFuzz/Grammar.c"
    "$IR_DIR/LeanFuzz/Pretty.c"
    "$IR_DIR/LeanFuzz/Generate.c"
    "$IR_DIR/LeanFuzz/Validate.c"
    "$IR_DIR/LeanFuzz/Command.c"
    "$IR_DIR/LeanFuzz/Fuzz.c"
)

COMPILE_SAN="-fsanitize=fuzzer-no-link"
if [ "$MODE" = "asan" ]; then
    COMPILE_SAN="$COMPILE_SAN,address,undefined"
elif [ "$MODE" = "ubsan" ]; then
    COMPILE_SAN="$COMPILE_SAN,undefined"
fi

CFLAGS="-g -O1 -I$LEAN_INCLUDE $COMPILE_SAN"

for src in "${C_FILES[@]}"; do
    obj="$BUILD_DIR/$(basename "$src" .c).o"
    echo "  CC $(basename "$src")"
    "$FUZZ_CC" -c $CFLAGS "$src" -o "$obj"
done

# --- Step 3: Compile C harness ---
echo "=== Step 3: Compile harness ==="
"$FUZZ_CC" -c $CFLAGS "$FUZZ_DIR/harness.c" -o "$BUILD_DIR/harness.o"

# --- Step 4: Link ---
echo "=== Step 4: Link ==="

LINK_SAN="-fsanitize=fuzzer"
if [ "$MODE" = "asan" ]; then
    LINK_SAN="$LINK_SAN,address,undefined"
elif [ "$MODE" = "ubsan" ]; then
    LINK_SAN="$LINK_SAN,undefined"
fi

# Platform-specific flags
# Lean's runtime is compiled against libc++, not libstdc++
STDLIB_FLAG="-lc++"
RPATH_FLAGS="-Wl,-rpath,$LEAN_LIB -Wl,-rpath,$LEAN_LIB_BASE"
LLD_FLAGS=""
if [ "$(uname)" = "Darwin" ]; then
    # Apple's ld can't handle sanitizer coverage relocations from newer clang.
    # Use Lean's ld64.lld instead.
    LEAN_LLD="$LEAN_SYSROOT/bin/ld64.lld"
    if [ -x "$LEAN_LLD" ]; then
        LLD_DIR="$BUILD_DIR/.lld-bin"
        mkdir -p "$LLD_DIR"
        ln -sf "$LEAN_LLD" "$LLD_DIR/ld64.lld"
        export PATH="$LLD_DIR:$PATH"
        LLD_FLAGS="-fuse-ld=lld"
    fi
fi

"$FUZZ_CC" $LINK_SAN $LLD_FLAGS -g -O1 \
    "$BUILD_DIR"/*.o \
    -L"$LEAN_LIB" -L"$LEAN_LIB_BASE" \
    -lleanshared -lgmp -luv \
    $STDLIB_FLAG \
    $RPATH_FLAGS \
    -o "$BUILD_DIR/lean-fuzzer"

echo ""
echo "=== Built: $BUILD_DIR/lean-fuzzer ==="
echo ""
echo "Run:"
echo "  mkdir -p corpus"
if [ "$MODE" = "valgrind" ]; then
    echo "  valgrind $BUILD_DIR/lean-fuzzer corpus/"
else
    echo "  $BUILD_DIR/lean-fuzzer corpus/"
fi
