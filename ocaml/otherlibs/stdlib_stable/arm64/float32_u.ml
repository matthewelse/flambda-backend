(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*                 Chris Casinghino, Jane Street, New York                *)
(*                                                                        *)
(*   Copyright 2023 Jane Street Group LLC                                 *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

open! Stdlib

[@@@ocaml.flambda_o3]

include Float32_u_common

let[@inline always] round_down x = of_float32 (Float32.round_down (to_float32 x))

let[@inline always] round_up x = of_float32 (Float32.round_up (to_float32 x))

let[@inline always] round_towards_zero x = of_float32 (Float32.round_towards_zero (to_float32 x))
