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
  (* CR melse: caml_neon_int8x16_add *)
  match op with "caml_sse2_int8x16_add" -> Some (Add_i8, args) | _ -> None

let pseudoregs_for_operation _ arg res = arg, res
