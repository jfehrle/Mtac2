Require Import MetaCoq.MetaCoq.

Goal True.
MProof.
  (s <- get_binder_name (fun name:nat=>name);
  match String.string_dec s "name" with
  | Specif.left _ => ret I
  | _ => raise exception
  end)%MC.
Qed.

Goal forall x:nat, True.
MProof.
  ret (fun name=>_).
  (s <- get_binder_name name;
  match String.string_dec s "name" with
  | Specif.left _ => ret I
  | _ => raise exception
  end)%MC.
Qed.

Goal True.
MProof.
  nu "name" None (fun x:nat=>
  s <- get_binder_name x;
  match String.string_dec s "name" with
  | Specif.left _ => ret I
  | _ => raise exception
  end)%MC.
Qed.

Goal True.
MProof.
  (r <- nu "name" None (fun x:nat=>abs_fun x x);
  s <- get_binder_name r;
  match String.string_dec s "name" with
  | Specif.left _ => ret I
  | _ => raise exception
  end)%MC.
Qed.

Example fresh_name_works_with_same_name (x:nat) : True.
MProof.
  (s <- fresh_binder_name (fun y:nat=>y);
  match String.string_dec s "y" with
  | Specif.left _ => ret I
  | _ => raise exception
  end)%MC.
Qed.

Example existing_name_works_with_diff_name (x:nat) : True.
MProof.
  (s <- fresh_binder_name (fun x:nat=>x);
  match String.string_dec s "x_" with
  | Specif.left _ => ret I
  | _ => raise exception
  end)%MC.
Qed.
