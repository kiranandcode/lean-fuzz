#!/usr/bin/env bash
set -euo pipefail

# Build Lean 4 from source with coverage instrumentation for libFuzzer.
#
# This produces an instrumented Lean toolchain where all of Lean's internals
# (parser, elaborator, kernel, runtime) have coverage counters that libFuzzer
# can use to guide fuzzing.
#
# Usage:
#   ./fuzz/build-lean.sh                    # build in ./lean4-fuzz/
#   ./fuzz/build-lean.sh /path/to/builddir  # build in custom directory
#
# After building, use the instrumented Lean with the fuzzer:
#   LEAN_SYSROOT=/path/to/lean4-fuzz/build/release/stage1 ./fuzz/build.sh
#
# Requirements:
#   - cmake, make, clang (with libFuzzer support)
#   - ~4 GB disk space, ~30-60 min build time

LEAN_VERSION="v4.29.0"
BUILD_ROOT="${1:-$(pwd)/lean4-fuzz}"
JOBS="${JOBS:-$(nproc 2>/dev/null || sysctl -n hw.logicalcpu 2>/dev/null || echo 4)}"

echo "Building instrumented Lean $LEAN_VERSION"
echo "Build directory: $BUILD_ROOT"
echo "Parallel jobs: $JOBS"
echo ""

# --- Clone Lean ---
if [ ! -d "$BUILD_ROOT" ]; then
    echo "=== Cloning Lean $LEAN_VERSION ==="
    git clone --depth 1 --branch "$LEAN_VERSION" https://github.com/leanprover/lean4 "$BUILD_ROOT"
else
    echo "=== Using existing Lean source at $BUILD_ROOT ==="
fi

cd "$BUILD_ROOT"

# --- Configure with coverage instrumentation ---
echo "=== Configuring with fuzzer coverage instrumentation ==="

# LEAN_EXTRA_CXX_FLAGS:    instruments C++ runtime (parser, allocator, kernel)
# LEANC_EXTRA_CC_FLAGS:    instruments Lean-generated C (Init, Std, Lean modules)
# LEAN_EXTRA_LINKER_FLAGS: linker flags for all binaries
# SMALL_ALLOCATOR=OFF:     Lean's small allocator conflicts with sanitizers
# USE_MIMALLOC=OFF:        mimalloc conflicts with sanitizers
# BSYMBOLIC=OFF:           incompatible with fuzzer instrumentation
cmake --preset release \
    -DLEAN_EXTRA_CXX_FLAGS="-fsanitize=fuzzer-no-link,undefined" \
    -DLEANC_EXTRA_CC_FLAGS="-fsanitize=fuzzer-no-link,undefined" \
    -DLEAN_EXTRA_LINKER_FLAGS="-fsanitize=fuzzer-no-link,undefined" \
    -DSMALL_ALLOCATOR=OFF \
    -DUSE_MIMALLOC=OFF \
    -DBSYMBOLIC=OFF

# --- Build ---
echo "=== Building (this takes 30-60 minutes) ==="
make -C build/release -j"$JOBS"

STAGE1="$BUILD_ROOT/build/release/stage1"
echo ""
echo "=== Build complete ==="
echo ""
echo "Instrumented Lean at: $STAGE1"
echo ""
echo "To use with the fuzzer:"
echo "  LEAN_SYSROOT=$STAGE1 ./fuzz/build.sh"
echo ""
echo "To register as an elan toolchain:"
echo "  elan toolchain link lean4-fuzz $STAGE1"
