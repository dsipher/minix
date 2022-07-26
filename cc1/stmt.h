/*****************************************************************************

  stmt.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef STMT_H
#define STMT_H

struct tree;

/* upon exiting compound(), the caller can consult stmt_tree to retrieve
   the value of the last statement (&void_tree if the last statement was
   not an expression statement). this facilitates statement expressions. */

extern struct tree *stmt_tree;

/* process a compound statement. caller must enter/exit the enclosed scope.
   if body is true, then the statement is the body of a function definition */

void compound(int body);

#endif /* STMT_H */

/* vi: set ts=4 expandtab: */
