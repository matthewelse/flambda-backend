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

include module type of Float32_common

external round_down : (t[@unboxed]) -> (t[@unboxed])
  = "caml_neon_unreachable" "caml_neon_float32_round_neg_inf" 
[@@noalloc] [@@builtin]

external round_up : (t[@unboxed]) -> (t[@unboxed])
  = "caml_neon_unreachable" "caml_neon_float32_round_pos_inf" 
[@@noalloc] [@@builtin]

external round_towards_zero : (t[@unboxed]) -> (t[@unboxed])
  = "caml_neon_unreachable" "caml_neon_float32_round_towards_zero" 
[@@noalloc] [@@builtin]
