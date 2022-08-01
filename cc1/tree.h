/*****************************************************************************

   tree.h                                              tahoe/64 c compiler

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

#ifndef TREE_H
#define TREE_H

#include "heap.h"

/* expression trees */

struct tree
{
    int op;             /* E_* */
    int nr_args;        /* E_CALL: size of args[] */

    struct tnode *type;

    union
    {
        struct  /* leaves: E_CON / E_SYM */
        {
            union con con;
            struct symbol *sym;
        };

        struct  /* unary operators */
        {
            struct tree *child;
            struct tree **args;     /* function arguments (E_CALL only) */
        };

        struct  /* binary operators */
        {
            struct tree *left;
            struct tree *right;
        };
    };
};

/* bits[31:30] distinguish between union variants. (no flag = binary) */

#define E_LEAF          0x80000000
#define E_UNARY         0x40000000

/* bit[29] indicates the operation is commutative */

#define E_COMMUTATIVE   0x20000000

/* bit[28] is set on node ops that represent an lvalue */

#define E_LVALUE        0x10000000

/* bit[27] is set to indicate possible half-promotion. this
   is for some assignment operators, see E_ADDASG et al. */

#define E_HALF          0x08000000

/* bits[5:0] uniquely identify the node op and provide an
   index into the text[] table in tree.c (for debug output) */

#define E_TEXT(op)      ((op) & 0x0000003F)

/* an E_NONE node is for dummy or no-op nodes, like
   a T_VOID 'value' or a placeholder for fake() */

#define E_NONE      (  0 | E_LEAF )

/* an E_SYM node means the value stored in a symbol. con must be 0. */

#define E_SYM       (  1 | E_LEAF | E_LVALUE )

/* an E_CON is a constant. if sym is present, it must be a global
   (S_STATIC or S_EXTERN, visible to the assembler), and the node
   value is the symbol's global address offset by the constant. */

#define E_CON       (  2 | E_LEAF )

/* E_FETCH and E_RFETCH perform the same action (indirection), but
   an E_FETCH is semantically an lvalue whereas an E_RFETCH is not.

   the child of a fetch node may have pointer-to-bitfield type, in
   which case extraction/insertion is part of the fetch operation.
   bitfield types do not appear anywhere else in trees! */

#define E_FETCH     (  3 | E_UNARY | E_LVALUE )             /*    *      */
#define E_RFETCH    (  4 | E_UNARY )

#define E_CALL      (  5 | E_UNARY )                    /* function call */
#define E_CAST      (  6 | E_UNARY )                        /* ( cast )  */
#define E_ADDROF    (  7 | E_UNARY )                        /*    &      */
#define E_NEG       (  8 | E_UNARY )                        /*    -      */
#define E_COM       (  9 | E_UNARY )                        /*    ~      */
#define E_PLUS      ( 10 | E_UNARY )                        /*    +      */

#define E_ASG       ( 11 )                                      /*  =    */

/* these compound assignment trees can be `half-promoted', that is,
   the left and right operands can have different types. when that
   happens, the right side has the common type that results from the
   usual promotions, and is the type that must be used for the op
   implied by the operator. gen_compound() does the heavy lifting. */

#define E_MULASG    ( 12 | E_HALF )                             /*  *=   */
#define E_DIVASG    ( 13 | E_HALF )                             /*  /=   */
#define E_MODASG    ( 14 | E_HALF )                             /*  %=   */
#define E_ADDASG    ( 15 | E_HALF )                             /*  +=   */
#define E_SUBASG    ( 16 | E_HALF )                             /*  -=   */

/* the compound shift operators, like their non-compound
   counterparts, always have a T_CHAR on the right side. */

#define E_SHLASG    ( 17 )                                      /*  <<=  */
#define E_SHRASG    ( 18 )                                      /*  >>=  */

/* these compound operators always have matching operands */

#define E_ANDASG    ( 19 )                                      /*  &=   */
#define E_ORASG     ( 20 )                                      /*  |=   */
#define E_XORASG    ( 21 )                                      /*  ^=   */

/* E_POST is just like E_ADDASG, except that its value is that of the
   left operand before the addition, and it's never half-promoted. */

#define E_POST      ( 22 )

#define E_DIV       ( 23 )                                      /*  /   */
#define E_MOD       ( 24 )                                      /*  %   */
#define E_MUL       ( 25 | E_COMMUTATIVE )                      /*  *   */
#define E_ADD       ( 26 | E_COMMUTATIVE )                      /*  +   */
#define E_SUB       ( 27 )                                      /*  -   */

/* the bitcounts on the right side of E_SHR and E_SHL are always T_CHAR */

#define E_SHR       ( 28 )                                      /*  >>  */
#define E_SHL       ( 29 )                                      /*  <<  */

#define E_XOR       ( 30 | E_COMMUTATIVE )                      /*  ^   */
#define E_AND       ( 31 | E_COMMUTATIVE )                      /*  &   */
#define E_OR        ( 32 | E_COMMUTATIVE )                      /*  |   */

#define E_EQ        ( 33 | E_COMMUTATIVE )                      /*  ==  */
#define E_NEQ       ( 34 | E_COMMUTATIVE )                      /*  !=  */
#define E_GT        ( 35 )                                      /*  >   */
#define E_GTEQ      ( 36 )                                      /*  >=  */
#define E_LTEQ      ( 37 )                                      /*  <=  */
#define E_LT        ( 38 )                                      /*  <   */

#define E_LOR       ( 39 )                                      /*  ||  */
#define E_LAND      ( 40 )                                      /*  &&  */

/* the ternary operator is represented by two binary nodes: an E_QUEST node
   with the controlling expression on its left and E_COLON on its right. */

#define E_QUEST     ( 41 )                                      /*  ? :  */
#define E_COLON     ( 42 )

#define E_COMMA     ( 43 )                                      /*   ,   */

/* the sequence operator is like comma: it evaluates its left operand, then
   its right, in that order. unlike the comma, its result is always void */

#define E_SEQ       ( 44 )

/* block operations. roughly analogous to memcpy() and memset(). we
   must use E_COLON children to provide room for the all the operands.

   E_BLKCPY
        E_COLON
            (pointer)           destination memory block
            (pointer)           source memory block
        E_COLON
            (unsigned long)     size of block to copy
            (int)               worst-case alignment of blocks

   E_BLKSET
        E_COLON
            (pointer)           destination memory block
            (int)               byte value to write
        E_COLON
            (unsigned long)     size of block to set
            (int)               worst-case alignment of block

   in both cases, the result is a copy of the destination pointer. */

#define E_BLKCPY    ( 45 )
#define E_BLKSET    ( 46 )

/* bit-scanning operators, with the semantics of the
   x86 instructions. used to implement builtins. */

#define E_BSF       ( 47 | E_UNARY )
#define E_BSR       ( 48 | E_UNARY )

/* return a duplicate of an entire tree */

struct tree *dup_tree(struct tree *tree);

/* tree constructors. nodes are always allocated out of stmt_arena,
   so trees only live for the duration of an external definition or
   an 'outermost' statement in a function body. */

struct tree *unary_tree(int op, struct tnode *type, struct tree *child);

struct tree *binary_tree(int op, struct tnode *type, struct tree *left,
                                                     struct tree *right);

#define LEAF_TREE(_tree)            ((_tree)->op & E_LEAF)
#define UNARY_TREE(_tree)           ((_tree)->op & E_UNARY)
#define BINARY_TREE(_tree)          (!LEAF_TREE(_tree) && !UNARY_TREE(_tree))
#define COMMUTATIVE_TREE(_tree)     ((_tree)->op & E_COMMUTATIVE)
#define LVALUE_TREE(_tree)          ((_tree)->op & E_LVALUE)

#define COMMUTE_TREE(_tree)         SWAP(struct tree *, (_tree)->left,  \
                                                        (_tree)->right)

#define FETCH_TREE(_tree)           (((_tree)->op == E_FETCH) ||        \
                                     ((_tree)->op == E_RFETCH))

#define FIELD_TREE(_tree)           (FETCH_TREE(_tree) &&               \
                                     FIELD_TYPE(DEREF((_tree)->child->type)))

/* create an E_SEQ tree from the given left and right trees. if
   left or right is 0, the other child is returned unchanged. */

struct tree *seq_tree(struct tree *left, struct tree *right);

/* create an E_BLK* tree as specified. the caller must ensure
   the types of the trees are correct for the node op. */

struct tree *blk_tree(int op, struct tree *left, struct tree *right,
                              struct tree *size);

/* chop the head off a tree: push its type down to the specified child, and
   return the child. normalizes the child to match its type if it's E_CON. */

struct tree *chop(struct tree *tree);           /* for unary tree */
struct tree *chop_left(struct tree *tree);      /* chop to the left */
struct tree *chop_right(struct tree *tree);     /* chop to the right */

/* walk T depth-first, invoking F on each node */

#define WALK_TREE(T, F)                                                     \
    do {                                                                    \
        int I;                                                              \
        if (UNARY_TREE(T)) {                                                \
            T->child = F(T->child);                                         \
            for (I = 0; I < T->nr_args; ++I) T->args[I] = F(T->args[I]);    \
        } else if (BINARY_TREE(T)) {                                        \
            T->left = F(T->left);                                           \
            T->right = F(T->right);                                         \
        }                                                                   \
    } while (0)

/* is the tree constant? and is it pure? pure
   constants do not reference assembler symbols */

#define CON_TREE(_tree)             ((_tree)->op == E_CON)
#define PURE_CON_TREE(_tree)        (CON_TREE(_tree) && ((_tree)->sym == 0))

/* true if a tree is *guaranteed* to be certain value. because of
   our uncertainty, in general, zero_tree(x) != !nonzero_tree(x) */

int zero_tree(struct tree *tree);
int nonzero_tree(struct tree *tree);

/* does the tree represent the null constant?
   that's any integral constant of value 0. */

#define NULL_CON_TREE(_tree)        (PURE_CON_TREE(_tree) &&            \
                                     INTEGRAL_TYPE((_tree)->type) &&    \
                                     ((_tree)->con.i == 0))

/* create an E_CON tree with the specified type and value */

struct tree *con_tree(struct tnode *type, union con *conp);

#define I_TREE(_type, _i)                                               \
    ({                                                                  \
        union con _con;                                                 \
        _con.i = (_i);                                                  \
        con_tree((_type), &_con);                                       \
    })

#define F_TREE(_type, _f)                                               \
    ({                                                                  \
        union con _con;                                                 \
        _con.f = (_f);                                                  \
        con_tree((_type), &_con);                                       \
    })

/* create an E_SYM tree referring to sym.
   the type is taken from the sym itself */

struct tree *sym_tree(struct symbol *sym);

/* add an actual argument to an E_CALL tree */

void actual(struct tree *call, struct tree *arg);

/* take the address of a tree. assign it to a pointer of the specified
   type simplifying the E_ADDROF node if necessary. this is only called
   after the tree has already been simplified, to keep it normalized. */

struct tree *addrof(struct tree *tree, struct tnode *type);

/* perform folding for constant expressions */

struct tree *fold(struct tree *tree);

/* simplify/normalize a tree. this is really a misnomer, as it does more than
   just simplification, and must be called before gen can process the tree. */

struct tree *simplify(struct tree *tree);

/* as a rule, registers allocated to volatile symbols do not appear in LIR.
   (see arg0() in func.c for the one exception). this function rewrites all
   references to volatile symbols as volatile memory references to force them
   into temps. this must be called before tree generation, and usually creates
   a denormalized tree (FETCH(ADDROF(SYM)); do not simplify() the result */

struct tree *rewrite_volatiles(struct tree *tree);

#ifdef DEBUG

/* print a tree in human-readable format to stderr.
   depth is used for recursion, pass in 0 at the root */

void dump_tree(struct tree *tree, int depth);

#endif /* DEBUG */

/* a void 'value' */

extern struct tree void_tree;

#endif /* TREE_H */

/* vi: set ts=4 expandtab: */
