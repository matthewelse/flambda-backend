(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*                      Max Slater, Jane Street                           *)
(*                                                                        *)
(*   Copyright 2023 Jane Street Group LLC                                 *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

open Simd
open Format

(* SIMD instruction selection for ARM64 *)

let select_operation op args =
  match op with
  | "caml_neon_float32_round_neg_inf" -> Some (Round_f32 Neg_inf, args)
  | "caml_neon_float32_round_pos_inf" -> Some (Round_f32 Pos_inf, args)
  | "caml_neon_float32_round_towards_zero" -> Some (Round_f32 Zero, args)
  | "caml_neon_float32_round_current" -> Some (Round_f32 Current, args)
  | "caml_neon_cast_float32_int64" -> Some (Round_f32_i64, args)
  | _ -> None

let pseudoregs_for_operation _ arg res = arg, res
