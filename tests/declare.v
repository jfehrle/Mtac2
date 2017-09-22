From Mtac2 Require Import Mtac2.

Goal unit.
  MProof.
  (c <- M.declare dok_Definition "bla" false 1; M.print_term c;; M.ret tt)%MC.
Qed.



Typeclasses eauto := debug.
Structure ST := mkS { s : nat }.

Require Mtac2.List.
Import Mtac2.List.ListNotations.

Compute ltac:(mrun (c1 <- M.declare dok_CanonicalStructure "bla" false (fun (x : nat) => (fun x => mkS x) x);
                    c2 <- M.declare dok_Definition "bli" true c1;
                    M.declare_implicits c2 [m: ia_Implicit];;
                    M.ret tt)%MC).
Print bla.
Print Coercions.
Print Canonical Projections.
Print bli.
Fail Compute (bli 1).
Compute (@bli 1).

Module DeclareTest.
  Fail Compute ltac:(mrun (M.declare_implicits (1+1) [m:])).
  Local Arguments Nat.add {_ _}.
  Fail Compute ltac:(mrun (M.declare_implicits (Nat.add) [m:])).
  Fail Compute ltac:(mrun (M.declare_implicits (Nat.add (n:=1)) [m:])).
  Compute ltac:(mrun (M.declare_implicits (@Nat.add) [m:])).
  Compute ltac:(mrun (M.declare_implicits (@Nat.add) [m: ia_Explicit | ia_Explicit])).
  Definition should_work := Nat.add 3 2.
End DeclareTest.
Require Import Strings.String.
Import M.notations.

Fixpoint defineN (n : nat) : M unit :=
  match n with
  | 0 => M.ret tt
  | S n =>
    s <- M.pretty_print n;
    M.declare dok_Definition ("NAT"++s)%string false n;;
    defineN n
  end.
Fail Print N0.
Compute ltac:(mrun (defineN 4)).

Print NAT0.
Print NAT1.
Print NAT2.
Print NAT3.
Fail Print NAT4.

Set Printing All. (* nasty *)
Compute ltac:(mrun (defineN 4)).
Print NATO.
Search "NAT". (* ouch, there are definitions like "NATS (S O)" *)
Compute ltac:(mrun (M.get_reference "NATS O")).
Compute (M.eval (c <- M.declare dok_Definition "_" true (S O); M.print_term c)).
Unset Printing All.

(* ouch, there should be a catchable error. but what about previously declared objects? *)
Fail Compute ltac:(mrun (mtry defineN 5 with _ => M.ret tt end)).

Fail Print NAT4. (* ah, it is failing. *)

Fail Compute fun x y => ltac:(mrun (M.declare dok_Definition "lenS" true (Le.le_n_S x y))). (* we should check that the terms are closed w.r.t. section variables *)

(* Fail Compute ltac:(mrun (M.declare dok_Definition "lenS" true (Le.le_n_S))). *) (* what is going on here? *)
Compute M.eval (c <- M.declare dok_Definition "blu" true (Le.le_n_S); M.print_term c). (* what is going on here? *)
