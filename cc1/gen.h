/*****************************************************************************

   gen.h                                                  ux/64 c compiler

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
