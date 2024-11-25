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
  let min t t' = if t < t' then t else t' 

  let max t t' = if t > t' then t else t' 
end

external iround_current : t -> int64
  = "caml_neon_unreachable" "caml_neon_cast_float32_int64"
  [@@noalloc] [@@unboxed] [@@builtin]

external round_current : (t[@unboxed]) -> (t[@unboxed])
  = "caml_neon_unreachable" "caml_neon_float32_round_current" 
[@@noalloc] [@@builtin]

external round_down : (t[@unboxed]) -> (t[@unboxed])
  = "caml_neon_unreachable" "caml_neon_float32_round_neg_inf" 
[@@noalloc] [@@builtin]

external round_up : (t[@unboxed]) -> (t[@unboxed])
  = "caml_neon_unreachable" "caml_neon_float32_round_pos_inf" 
[@@noalloc] [@@builtin]

external round_towards_zero : (t[@unboxed]) -> (t[@unboxed])
  = "caml_neon_unreachable" "caml_neon_float32_round_towards_zero" 
[@@noalloc] [@@builtin]