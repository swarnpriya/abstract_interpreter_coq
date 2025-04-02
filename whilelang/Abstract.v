Require Import compcert.lib.Coqlib Wlang Maps.
From mathcomp Require Import all_ssreflect.

Module Type Abstract_Domain.
Parameter t : Type.
Parameter bot : t.
Parameter top : t.
Parameter eq : t -> t -> t.
Parameter join : t -> t -> t.
Parameter widen : t -> t -> t.
Parameter narrow : t -> t -> t.

(* Abstract operators *)
Parameter aplus : t -> t -> t.
Parameter asub : t -> t -> t.
Parameter amult : t -> t -> t.

(* Concretization function *)
Parameter to_con : t -> Z.
(* Abstraction function *)
Parameter to_abs : Z -> t.

(* Properties about join operation *)
Axiom join_eq : forall a, join a a = a.
Axiom join_bottom : forall a, join a bot = bot. 
Axiom join_comm : forall a a', join a a' = join a' a.
End Abstract_Domain.

Module Abi(Ab : Abstract_Domain).
Import Ab.

(* Abstract state is map from index(var) to abstract domain *)
Definition ab_state := PTree.t Ab.t.

(* Semantics of abstract expressions *) Print bop.
Fixpoint asem_aexpr (ab_s : ab_state) (ae : Wlang.aexpr) {struct ae} : Ab.t :=
match ae with 
| Const z => to_abs z
| Var x => match (PTree.get x ab_s) with 
           | Some z => z
           | None => bot
           end
| Bop o ae1 ae2 => match o with 
                   | Add => (Ab.aplus (asem_aexpr ab_s ae1) (asem_aexpr ab_s ae2))
                   | Minus => (Ab.asub (asem_aexpr ab_s ae1) (asem_aexpr ab_s ae2))
                   | Mul => (Ab.amult (asem_aexpr ab_s ae1) (asem_aexpr ab_s ae2))
                   end
end.
