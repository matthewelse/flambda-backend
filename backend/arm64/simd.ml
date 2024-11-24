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

[@@@ocaml.warning "+a-40-42"]

(* SIMD instructions for ARM64 *)

open Format

type operation = Add_i8

let print_operation printreg op ppf arg =
  match op with
  | Add_i8 -> fprintf ppf "add_i8 %a %a" printreg arg.(0) printreg arg.(1)

let equal_operation op1 op2 = match op1, op2 with Add_i8, Add_i8 -> true

let operation_is_pure op = match op with Add_i8 -> true
