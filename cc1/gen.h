/*****************************************************************************

  gen.h                                                   tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef GEN_H
#define GEN_H

struct block;
struct operand;
struct tree;
struct symbol;

/* generate the LIR sequence to load (store) a symbol from its backing store
   and insert the insn(s) into block b at index i. if the symbol is volatile,
   the access will be marked as such. if the symbol has no backing storage,
   it will be allocated from the frame. op is I_LIR_LOAD or I_LIR_STORE, with
   the obvious meaning. returns the number of insns inserted. */

int loadstore(int op, struct symbol *sym, struct block *b, int i);

/* generate a branch based on the truth value of an int leaf tree */

void branch(struct tree *tree, struct block *true, struct block *false);

/* generate the code for tree to current_block, and return the result */

struct tree *gen(struct tree *tree);

/* convert a leaf tree into an operand.
   E_CON becomes an O_IMM, E_SYM an O_REG. */

void leaf_operand(struct operand *o, struct tree *tree);

#endif /* GEN_H */

/* vi: set ts=4 expandtab: */
