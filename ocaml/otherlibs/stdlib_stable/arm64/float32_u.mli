(**************************************************************************)
(*                                                                        *)
(*                                 OCaml                                  *)
(*                                                                        *)
(*             Xavier Leroy, projet Cristal, INRIA Rocquencourt           *)
(*                        Nicolas Ojeda Bar, LexiFi                       *)
(*                 Chris Casinghino, Jane Street, New York                *)
(*                                                                        *)
(*   Copyright 2018 Institut National de Recherche en Informatique et     *)
(*     en Automatique.                                                    *)
(*   Copyright 2023 Jane Street Group LLC                                 *)
(*                                                                        *)
(*   All rights reserved.  This file is distributed under the terms of    *)
(*   the GNU Lesser General Public License version 2.1, with the          *)
(*   special exception on linking described in the file LICENSE.          *)
(*                                                                        *)
(**************************************************************************)

open! Stdlib

include module type of Float32_u_common

val round_down : t -> t
(** Rounds a [float32#] down to the next integer [float32#] toward negative infinity.
    The arm64 flambda-backend compiler translates this call to frintm.*)

val round_up : t -> t
(** Rounds a [float32#] up to the next integer [float32#] toward positive infinity.
    The amd64 flambda-backend compiler translates this call to frintp.*)

val round_towards_zero : t -> t
(** Rounds a [float32#] to the next integer [float32#] toward zero.
    The amd64 flambda-backend compiler translates this call to frintz.*)
