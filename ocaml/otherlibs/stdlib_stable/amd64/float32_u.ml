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

module With_weird_nan_behavior = struct
  let[@inline always] min x y = of_float32 (Float32.With_weird_nan_behavior.min (to_float32 x) (to_float32 y))

  let[@inline always] max x y = of_float32 (Float32.With_weird_nan_behavior.max (to_float32 x) (to_float32 y))
end

external unbox_int64 : (int64[@local_opt]) -> int64# = "%unbox_int64"

let[@inline always] iround_current x = unbox_int64 (Float32.iround_current (to_float32 x))

let[@inline always] round_current x = of_float32 (Float32.round_current (to_float32 x))

let[@inline always] round_down x = of_float32 (Float32.round_down (to_float32 x))

let[@inline always] round_up x = of_float32 (Float32.round_up (to_float32 x))

let[@inline always] round_towards_zero x = of_float32 (Float32.round_towards_zero (to_float32 x))
