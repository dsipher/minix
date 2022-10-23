/*****************************************************************************

   func.h                                                 ux/64 c compiler

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

#ifndef FUNC_H
#define FUNC_H

struct symbol;
struct tnode;

/* while processing a function definition, this
   is set to its entry in the symbol table */

extern struct symbol *current_func;

/* local symbols are collected here as they fall out of scope
   and remain here until exit_func() frees the chain. */

extern struct symbol *func_chain;

/* an anonymous symbol which holds the function return value. returns
   are effected by assigning to it, then branching to the exit_block.
   if the function returns a struct, assign a pointer to the struct to
   return- the epilogue will copy it to the caller's return buffer. */

extern struct symbol *func_ret_sym;

/* type of the return value. this is not the same as the
   type of func_ret_sym in the case of struct return. */

extern struct tnode *func_ret_type;

/* if the function returns a struct, this anonymous symbol holds the
   hidden first argument which points to the caller's return buffer. */

extern struct symbol *func_hidden_arg;

/* set if this function needs %rbp as the frame register.
   (when it has local frame storage or stacked arguments) */

extern int func_needs_frame;

/* the amount of storage allocated for locals on the frame */

extern int func_frame_size;

/* return the number of insns in the CFG */

int func_size(void);

/* initialize data for new function definition body */

void enter_func(struct symbol *sym);

/* function body complete: optimize, generate output, clean up */

void exit_func(void);

/* create a compiler temporary of the specified type */

struct symbol *temp(struct tnode *type);

/* create a compiler temporary of the specified type
   and return its associated pseudo register */

int temp_reg(long t);

/* allocate local storage for an object of the
   given type and return its frame offset */

int frame_alloc(struct tnode *type);

#endif /* FUNC_H */

/* vi: set ts=4 expandtab: */
