/*
 * libFuzzer harness for lean-fuzz.
 *
 * Initializes the Lean runtime and LeanFuzz module once, then for each
 * fuzzer input: creates a ByteArray from the input bytes and calls
 * lean_fuzz_one_input which generates a program and runs it through
 * Lean's parse + elaborate pipeline.
 *
 * Build with: fuzz/build.sh [asan|valgrind]
 */

#include <lean/lean.h>
#include <stdint.h>

/* Module initializer — transitively inits all LeanFuzz sub-modules + Init + Lean */
extern lean_object* initialize_lean_x2dfuzz_LeanFuzz(uint8_t builtin);

/* @[export] functions from LeanFuzz.Fuzz (no world token — compiler eliminates it) */
extern lean_object* lean_fuzz_init(void);
extern lean_object* lean_fuzz_one_input(lean_object* data);

/* Lean runtime symbols */
void lean_initialize(void);
void lean_set_panic_messages(bool flag);
void lean_io_mark_end_initialization(void);
void lean_init_task_manager(void);
void lean_io_result_show_error(lean_object* r);

int LLVMFuzzerInitialize(int *argc, char ***argv) {
    (void)argc; (void)argv;
    lean_object* res;

    /* 1. Initialize Lean runtime */
    lean_initialize();
    lean_set_panic_messages(false);

    /* 2. Run module initializers (LeanFuzz + all dependencies) */
    res = initialize_lean_x2dfuzz_LeanFuzz(1 /* builtin */);
    lean_set_panic_messages(true);
    lean_io_mark_end_initialization();

    if (!lean_io_result_is_ok(res)) {
        lean_io_result_show_error(res);
        lean_dec(res);
        return 1;
    }
    lean_dec_ref(res);

    lean_init_task_manager();

    /* 3. Load environment, extract grammar, store in global state */
    res = lean_fuzz_init();
    if (!lean_io_result_is_ok(res)) {
        lean_io_result_show_error(res);
        lean_dec(res);
        return 1;
    }
    lean_dec_ref(res);

    return 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    /* Create Lean ByteArray from fuzzer input.
     * lean_fuzz_one_input CONSUMES the reference (no lean_dec after). */
    lean_object* ba = lean_alloc_sarray(1, size, size);
    if (size > 0)
        __builtin_memcpy(lean_sarray_cptr(ba), data, size);

    lean_object* res = lean_fuzz_one_input(ba);
    /* ba is now consumed by the callee */

    if (lean_io_result_is_ok(res))
        lean_dec_ref(res);
    else
        lean_dec(res);

    return 0;
}
