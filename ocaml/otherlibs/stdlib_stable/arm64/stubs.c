#include "assert.h"

#define BUILTIN(name) void name() { assert(0); }

BUILTIN(caml_neon_unreachable);
BUILTIN(caml_neon_float32_round_neg_inf);
BUILTIN(caml_neon_float32_round_pos_inf);
BUILTIN(caml_neon_float32_round_towards_zero);
BUILTIN(caml_neon_float32_round_current);
BUILTIN(caml_neon_cast_float32_int64);
