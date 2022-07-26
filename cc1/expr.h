/*****************************************************************************

  expr.h                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef EXPR_H
#define EXPR_H

/* parse a constant expression and return its value. there are many kinds
   of constant expressions in c; this is for the more restricted kind used
   for array bounds, bitfield widths, and enumeration constant values. */

int constant_expr(void);

/* parse a constant expression for a case label */

struct tree *case_expr(void);

/* parse a constant expression for a static initializer */

struct tree *static_expr(void);

/* parse an assignment expression (used by automatic initializers) */

struct tree *assignment(void);

/* test a tree against zero, true if not zero (cmp == K_NOTEQ) or true if
   zero (cmp == K_EQ). if the tree is not scalar, abort with an error. k
   is only for the error message */

struct tree *test(struct tree *tree, int cmp, int k);

/* parse a general expression */

struct tree *expression(void);

/* given two operands and a binary operand token, construct an appropriate
   tree and return it. most of the nasty semantic details are buried here. */

struct tree *build_tree(int k, struct tree *left, struct tree *right);

/* fake assignment of the tree to a fictitious object of the specified type.
   this does type checking and coercion and returns the adjusted tree. k is
   either K_INIT or K_ARG, indicating whether we are faking the assignment
   for an initializer or function argument (improves the error reports). */

struct tree *fake(struct tree *tree, struct tnode *type, int k);

#endif /* EXPR_H */

/* vi: set ts=4 expandtab: */
