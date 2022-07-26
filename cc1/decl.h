/*****************************************************************************

  decl.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef DECL_H
#define DECL_H

struct tnode;

/* process external definitions. since a c translation unit is simply
   a series of external definition, this is the parser goal symbol. */

void externals(void);

/* process declarations at the head of a block (compound statement) */

void locals(void);

/* parse an abstract type-name and return its type */

struct tnode *abstract(void);

#endif /* DECL_H */

/* vi: set ts=4 expandtab: */
