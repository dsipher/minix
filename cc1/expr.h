/*****************************************************************************

   expr.h                                              jewel/os c compiler

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
