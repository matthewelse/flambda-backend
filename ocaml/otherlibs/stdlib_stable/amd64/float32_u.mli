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

module With_weird_nan_behavior : sig
    val min : t -> t -> t
    (** [min x y] returns the minimum of [x] and [y].
        If either [x] or [y] is [nan], [y] is returned.
        If both [x] and [y] equal zero, [y] is returned.
        The amd64 flambda-backend compiler translates this call to MINSS. *)

    val max : t -> t -> t
    (** [max x y] returns the maximum of [x] and [y].
        If either [x] or [y] is [nan], [y] is returned.
        If both [x] and [y] equal zero, [y] is returned.
        The amd64 flambda-backend compiler translates this call to MAXSS. *)
end

val iround_current : t -> int64#
(** Rounds a [float32#] to an [int64#] using the current rounding mode. The default
    rounding mode on amd64 is "round half to even", and we expect that no
    program will change the mode. The default mode may differ on other platforms.
    If the argument is NaN or infinite or if the rounded value cannot be
    represented, then the result is unspecified.
    The amd64 flambda-backend compiler translates this call to CVTSS2SI. *)

val round_current : t -> t
(** Rounds a [float32#] to an integer [float32#] using the current rounding mode.
    The default rounding mode on amd64 is "round half to even", and we
    expect that no program will change the mode. The default mode may differ
    on other platforms.
    The amd64 flambda-backend compiler translates this call to ROUNDSS. *)

val round_down : t -> t
(** Rounds a [float32#] down to the next integer [float32#] toward negative infinity.
    The amd64 flambda-backend compiler translates this call to ROUNDSS.*)

val round_up : t -> t
(** Rounds a [float32#] up to the next integer [float32#] toward positive infinity.
    The amd64 flambda-backend compiler translates this call to ROUNDSS.*)

val round_towards_zero : t -> t
(** Rounds a [float32#] to the next integer [float32#] toward zero.
    The amd64 flambda-backend compiler translates this call to ROUNDSS.*)
