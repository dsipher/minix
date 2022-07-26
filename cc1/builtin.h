/*****************************************************************************

  builtin.h                                               tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef BUILTIN_H
#define BUILTIN_H

struct string;
struct tree;

/* install the builtin with given id into the symbol table. builtins are
   declared as S_STATIC functions at FILE_SCOPE and mostly behave as such.
   of course, calling a builtin does not result in a function call, and
   because it is not real, one cannot take its address. we make no attempt
   to enforce this latter rule; the linker will complain on our behalf. */

void seed_builtin(struct string *id);

/* given an E_CALL tree, determine if the function called
   is a built-in and, if so, rewrite the tree accordingly */

struct tree *rewrite_builtin(struct tree *tree);

#endif /* BUILTIN_H */

/* vi: set ts=4 expandtab: */
