<<<<<<< HEAD
(* TEST *)
||||||| 121bedcfd2
(* TEST
   flags = "-g"
   * skip
   reason = "port stat-mem-prof : https://github.com/ocaml/ocaml/pull/8634"
*)
=======
(* TEST
 flags = "-g";
 reason = "port stat-mem-prof : https://github.com/ocaml/ocaml/pull/8634";
 skip;
*)
>>>>>>> 5.2.0

module MP = Gc.Memprof

(* Tests that array allocation in the minor heap is properly counted
   and managed by statmemprof. *)

(* Use a big array as a GC root, to keep allocated arrays alive. *)

let roots = Array.make 1000000 [||]
let roots_pos = ref 0
let add_root r =
  roots.(!roots_pos) <- r;
  incr roots_pos
let clear_roots () =
  Array.fill roots 0 !roots_pos [||];
  roots_pos := 0

(* Allocate arrays of all sizes from `lo` to `hi`, `cnt` times. If
   `keep`, then keep all the arrays, otherwise discard them all. *)

let[@inline never] allocate_arrays lo hi cnt keep =
  assert (0 < lo && hi <= 250);  (* Fits in minor heap. *)
  for j = 0 to cnt-1 do
    for i = lo to hi do
      add_root (Array.make i 0)
    done;
    if not keep then clear_roots ()
  done

(* Check that no allocation callbacks are called if the sampling rate
   is zero. *)

let check_nosample () =
  Printf.printf "check_nosample\n%!";
  let alloc _ =
    Printf.printf "Callback called with sampling_rate = 0\n";
    assert(false) in
  let _ = MP.start ~callstack_size:10 ~sampling_rate:0.
    { MP.null_tracker with alloc_minor = alloc; alloc_major = alloc }
  in
  allocate_arrays 1 250 100 false;
  MP.stop ()

let () = check_nosample ()

(* Cross-check counts of allocations, promotions, and deallocations,
   and check that they change appropriately at major collections
   depending on reachability. Occasionally trigger minor
   collections. Check that every dealloc callback from the major heap
   is for a block which has been promoted from the minor heap, and
   every dealloc callback from the minor heap is for a block which was
   allocated on the minor heap and has not been promoted. *)

let check_counts_full_major force_promote =
  Printf.printf "check_counts_full_major\n%!";
  let nalloc_minor = ref 0 in
  let enable = ref true in
  let promotes_allowed = ref true in
  let npromote = ref 0 in
  let ndealloc_minor = ref 0 in
  let ndealloc_major = ref 0 in
  let _:MP.t = MP.start ~callstack_size:10 ~sampling_rate:0.01
    {
      alloc_minor = (fun info ->
        if !enable then begin
          incr nalloc_minor; if !nalloc_minor mod 100 = 0 then Gc.minor ();
          Some (ref 42)
        end else begin
          allocate_arrays 1 250 1 true;
          None
        end);
      alloc_major = (fun _ -> assert false);
      promote = (fun k ->
        assert (!k = 42 && !promotes_allowed);
        incr npromote; if !npromote mod 1097 = 0 then Gc.minor ();
        Some (ref 17));
      dealloc_minor = (fun k ->
        assert (!k = 42);
        incr ndealloc_minor);
      dealloc_major = (fun r ->
        assert (!r = 17);
        incr ndealloc_major);
    }
  in
  allocate_arrays 1 250 100 true;
  enable := false; (* stop sampling *)
  (* everything is still reachable from root, no deallocs *)
  assert (!ndealloc_minor = 0 && !ndealloc_major = 0);

  if force_promote then begin
    Gc.full_major ();
    promotes_allowed := false;
    (* everything is still reachable from root, and
       everything allocated in the minor heap has now been
       promoted *)
    allocate_arrays 1 250 10 true;
    Gc.full_major ();
    assert (!ndealloc_minor = 0 && !ndealloc_major = 0 &&
            !npromote = !nalloc_minor);
    clear_roots ();
    Gc.full_major ();
    assert (!ndealloc_minor = 0 && !ndealloc_major = !nalloc_minor);
  end else begin
    clear_roots ();
    Gc.minor ();
    Gc.full_major ();
    Gc.full_major ();
    assert (!nalloc_minor = !ndealloc_minor + !npromote &&
            !ndealloc_major = !npromote)
  end;
  MP.stop ()

let () =
  check_counts_full_major false;
  check_counts_full_major true

let check_no_nested () =
  Printf.printf "check_no_nested\n%!";
  let in_callback = ref false in
  let cb _ =
    assert (not !in_callback);
    in_callback := true;
    allocate_arrays 1 100 10 false;
    ignore (Array.to_list (Array.make 1000 0));
    in_callback := false;
    () in
  let cb' _ = cb (); Some () in
  let _:MP.t = MP.start ~callstack_size:10 ~sampling_rate:1.
    {
      alloc_minor = cb';
      alloc_major = cb';
      promote = cb';
      dealloc_minor = cb;
      dealloc_major = cb;
    }
  in
  allocate_arrays 1 250 5 false;
  MP.stop ()

let () = check_no_nested ()

let check_distrib lo hi cnt rate =
  Printf.printf "check_distrib %d %d %d %f\n%!" lo hi cnt rate;
  let smp = ref 0 in
  let _:MP.t = MP.start ~callstack_size:10 ~sampling_rate:rate
    { MP.null_tracker with
      alloc_major = (fun _ -> assert false);
      alloc_minor = (fun info ->
        assert (info.size >= lo && info.size <= hi);
        assert (info.n_samples > 0);
        assert (info.source = Normal);
        smp := !smp + info.n_samples;
        None
      );
    }
  in
  allocate_arrays lo hi cnt false;
  MP.stop ();

  (* The probability distribution of the number of samples follows a
     binomial distribution of parameters tot_alloc and rate. Given
     that tot_alloc*rate and tot_alloc*(1-rate) are large (i.e., >
     100), this distribution is approximately equal to a normal
     distribution. We compute a 1e-8 confidence interval for !smp
     using quantiles of the normal distribution, and check that we are
     in this confidence interval. *)
  let tot_alloc = cnt*(lo+hi+2)*(hi-lo+1)/2 in
  assert (float tot_alloc *. rate > 100. &&
          float tot_alloc *. (1. -. rate) > 100.);
  let mean = float tot_alloc *. rate in
  let stddev = sqrt (float tot_alloc *. rate *. (1. -. rate)) in
  (* This assertion has probability to fail close to 1e-8. *)
  assert (abs_float (mean -. float !smp) <= stddev *. 5.7)

let () =
  check_distrib 1 250 1000 0.00001;
  check_distrib 1 250 1000 0.0001;
  check_distrib 1 250 1000 0.01;
  check_distrib 1 250 1000 0.9;
  check_distrib 1 1   10000000 0.01;
  check_distrib 250 250 100000 0.1

let () =
  Printf.printf "OK !\n"
