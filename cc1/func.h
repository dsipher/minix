/*****************************************************************************

  func.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

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
