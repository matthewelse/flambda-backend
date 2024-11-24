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

type int_datatype =
  | Int8x8
  | Int8x16
  | Int16x4
  | Int16x8
  | Int32x2
  | Int32x4
  | Int64x2

type operation = Add of int_datatype

let reg_suffix_for_int_datatype dt =
  match dt with
  | Int8x8 -> ".8b"
  | Int8x16 -> ".16b"
  | Int16x4 -> ".4h"
  | Int16x8 -> ".8h"
  | Int32x2 -> ".2s"
  | Int32x4 -> ".4s"
  | Int64x2 -> ".2d"

let print_int_datatype ppf dt =
  let suffix = reg_suffix_for_int_datatype dt in
  Format.pp_print_string ppf suffix

let printreg_dt dt printreg ppf reg =
  fprintf ppf "%a.%a" printreg reg print_int_datatype dt

let print_operation printreg op ppf arg =
  match op with
  | Add dt ->
    fprintf ppf "add%a %a %a" print_int_datatype dt (printreg_dt dt printreg)
      arg.(0) (printreg_dt dt printreg) arg.(1)

let equal_operation op1 op2 = match op1, op2 with Add dt, Add dt' -> dt = dt'

let operation_is_pure op = match op with Add _ -> true
