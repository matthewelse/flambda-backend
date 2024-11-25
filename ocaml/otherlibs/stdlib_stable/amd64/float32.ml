(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                        Nicolas Ojeda Bar, LexiFi                       *)
(*                                                                        *)
(*   Copyright 2018 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

[@@@ocaml.flambda_o3]

include Float32_common

module With_weird_nan_behavior = struct
  external min : t -> t -> t
    = "caml_sse_float32_min_bytecode" "caml_sse_float32_min"
    [@@noalloc] [@@unboxed] [@@builtin]

  external max : t -> t -> t
    = "caml_sse_float32_max_bytecode" "caml_sse_float32_max"
    [@@noalloc] [@@unboxed] [@@builtin]
end

external iround_current : t -> int64
  = "caml_sse_cast_float32_int64_bytecode" "caml_sse_cast_float32_int64"
  [@@noalloc] [@@unboxed] [@@builtin]

external round_intrinsic : (int[@untagged]) -> (t[@unboxed]) -> (t[@unboxed])
  = "caml_sse41_float32_round_bytecode" "caml_sse41_float32_round"
  [@@noalloc] [@@builtin]

(* On amd64, these constants also imply _MM_FROUND_NO_EXC (suppress exceptions). *)
let round_neg_inf = 0x9
let round_pos_inf = 0xA
let round_zero = 0xB
let round_current_mode = 0xC
let[@inline] round_current x = round_intrinsic round_current_mode x
let[@inline] round_down x = round_intrinsic round_neg_inf x
let[@inline] round_up x = round_intrinsic round_pos_inf x
let[@inline] round_towards_zero x = round_intrinsic round_zero x
