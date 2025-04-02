Require Import String ZArith Coq.FSets.FMapAVL Coq.Structures.OrderedTypeEx.
Require Import Coq.FSets.FSetProperties Coq.FSets.FMapFacts FMaps FSetAVL Nat PeanoNat.
Require Import Coq.Arith.EqNat Coq.ZArith.Int Integers AST Maps Globalenvs compcert.lib.Coqlib Ctypes.
Require Import Memory Int Cop Memtype Errors Csem SimplExpr Events.
From mathcomp Require Import all_ssreflect. 

Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Local Open Scope string_scope.
Local Open Scope gensym_monad_scope.

Inductive bop : Type :=
| Add : bop
| Minus : bop
| Mul : bop.

Inductive aexpr := 
| Const : Z -> aexpr
| Var : ident -> aexpr
| Bop : bop -> aexpr -> aexpr -> aexpr.

Inductive bexpr :=
| Bool : bool -> bexpr
| Lt : aexpr -> aexpr -> bexpr 
| Gt : aexpr -> aexpr -> bexpr
| Eq : aexpr -> aexpr -> bexpr
| Not : bexpr -> bexpr
| And : bexpr -> bexpr -> bexpr
| Or : bexpr -> bexpr -> bexpr.

Definition label := int64.

Inductive instr : Type :=
| Assert : bexpr -> instr -> instr
| Assgn : label -> ident -> aexpr -> instr
| Cond : label -> bexpr -> instr -> instr -> instr
| While : label -> bexpr -> instr -> instr
| Seq : label -> instr -> instr -> instr
| Skip : instr.

(* Map variables to Z *)
Definition state := PTree.t Z.

Record program := Prog {p_expr : instr}.




