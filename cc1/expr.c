/*****************************************************************************

   expr.c                                              jewel/os c compiler

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

#include <limits.h>
#include "cc1.h"
#include "lex.h"
#include "type.h"
#include "tree.h"
#include "decl.h"
#include "func.h"
#include "fold.h"
#include "stmt.h"
#include "symbol.h"
#include "string.h"
#include "expr.h"

static struct tree *cast(void);

/* normalize an E_ADD tree by putting the pointer
   on the left when a pointer meets an integer. */

#define POINTER_LEFT(T)                                                     \
    do {                                                                    \
        if ((T->op == E_ADD) && PTR_TYPE(T->right->type))                   \
            COMMUTE_TREE(T);                                                \
    } while (0)

/* we strip qualifiers from types when we know we no longer need them:
   once we've decided that an expression is an rvalue, or after we've
   enforced any semantics on an lvalue on its way to becoming an rvalue.
   we never discard the qualifiers on structs or unions, since we need
   them to qualify member accesses, even when they're rvalues.

   this is mainly a matter of hygiene. it is simple enough to ignore
   qualifiers when they're irrevelant, and indeed we do just that. */

#define STRIP_QUALIFIERS(type)                                              \
    do {                                                                    \
        if (TYPE_QUALS(type) && !STRUN_TYPE(type))                          \
            (type) = unqualify(type);                                       \
    } while (0)

/* perform promotions. here we perform integral promotions
   (C89 6.2.1.1) and lvalue conversions (C89 6.2.2.1), and
   (if old_arg is non-zero) default argument promotions as
   specified in (C89 6.3.2.2). in short, this means:

   1. arrays become pointers to their first elements,
   2. functions become pointer-to-function, and
   3. chars and shorts are promoted to full ints
   4. floats are promoted to doubles (if old_arg) */

static struct tree *promote(struct tree *tree, int old_arg)
{
    if (FUNC_TYPE(tree->type))
        tree = unary_tree(E_ADDROF, PTR(tree->type), tree);
    else if (ARRAY_TYPE(tree->type))
        tree = unary_tree(E_ADDROF, PTR(DEREF(tree->type)), tree);
    else if (CHARS_TYPE(tree->type) || SHORTS_TYPE(tree->type))
        tree = unary_tree(E_CAST, &int_type, tree);
    else if (old_arg && FLOAT_TYPE(tree->type))
        tree = unary_tree(E_CAST, &double_type, tree);
    else
        STRIP_QUALIFIERS(tree->type);

    return tree;
}

/* perform pointer scaling (if applicable) and assign an
   appropriate result type. if no pointers are involved,
   the result inherits its type from the left operand.

   the caller must ensure the tree op is subject to scaling,
   and mixed-type trees have the pointer on the left */

static struct tree *scale(struct tree *tree)
{
    struct tree *left = tree->left;
    struct tree *right = tree->right;
    struct tree *icon;
    int size;

    if (PTR_TYPE(left->type)) {
        size = size_of(DEREF(left->type), 0);
        icon = I_TREE(&long_type, size);

        if (!PTR_TYPE(right->type)) {
            /* pointer +/- integer */
            right = unary_tree(E_CAST, &long_type, right);
            right = binary_tree(E_MUL, &long_type, right, icon);
            tree->right = right;
            tree->type = left->type;
        } else {
            /* pointer - pointer */
            tree->type = &long_type;
            tree = binary_tree(E_DIV, &long_type, tree, icon);
        }
    } else
        tree->type = left->type;

    return tree;
}

/* helper for build_tree(). if ptr is a pointer type, and con
   is a null pointer constant, then promote the constant to the
   pointer type. returns the (possibly unmodified) con. */

static struct tree *null0(struct tree *con, struct tree *ptr)
{
    if (PTR_TYPE(ptr->type) && INTEGRAL_TYPE(con->type)) {
        /* we must fold: a null pointer constant is an integral
           constant EXPRESSION which evalutes to 0 (C89 6.2.2.3) */

        con = fold(con);

        if (NULL_CON_TREE(con))
            con = unary_tree(E_CAST, ptr->type, con);
    }

    return con;
}

/* map binary operator tokens to tree ops, indexed by K_MAP_IDX()
   of the operator's token class- keep in sync with lex.h. idx and
   len reference a contiguous set of entries in operands[] below.
   the BUILD_* flags drive the logic in build_tree(). */

#define BUILD_PROMOTE_LHS   0x00000001  /* promote the lhs */
#define BUILD_NULL0_LHS     0x00000002  /* honor null constants on lhs */
#define BUILD_NULL0_RHS     0x00000004  /* ....................... rhs */
#define BUILD_LOGICAL       0x00000008  /* operands are logic/truth values */
#define BUILD_ARITH_LHS     0x00000010  /* mixed arith types take lhs type */
#define BUILD_ARITH_USUALS  0x00000020  /* usual promotions for arith types */
#define BUILD_ARITH_HALF    0x00000040  /* `half' usual promotions (rhs) */
#define BUILD_UPGRADE_LHS   0x00000080  /* if lhs is void*, promote to rhs */
#define BUILD_UPGRADE_RHS   0x00000100  /* .. rhs .................... lhs */
#define BUILD_DOWNGRADE_LHS 0x00000200  /* if rhs is void *, downgrade lhs */
#define BUILD_DOWNGRADE_RHS 0x00000400  /* .. lhs .................... rhs */
#define BUILD_BITCOUNT_RHS  0x00000800  /* force rhs to char (shift count) */
#define BUILD_SCALE_RESULT  0x00001000  /* scale result with pointer rules */
#define BUILD_INT_RESULT    0x00002000  /* result is always int */

static struct { int op, idx, len, flags; } map[] =
{
    /*  0 */    { E_ASG,        2,  3,  BUILD_NULL0_RHS         |
                                        BUILD_UPGRADE_RHS       |
                                        BUILD_DOWNGRADE_RHS     |
                                        BUILD_ARITH_LHS         },

    /*  1 */    { E_MULASG,     2,  1,  BUILD_ARITH_HALF        },
    /*  2 */    { E_DIVASG,     2,  1,  BUILD_ARITH_HALF        },
    /*  3 */    { E_MODASG,     0,  1,  BUILD_ARITH_HALF        },

    /*  4 */    { E_ADDASG,     1,  2,  BUILD_ARITH_HALF        |
                                        BUILD_SCALE_RESULT      },

    /*  5 */    { E_SUBASG,     1,  2,  BUILD_ARITH_HALF        |
                                        BUILD_SCALE_RESULT      },

    /*  6 */    { E_SHLASG,     0,  1,  BUILD_BITCOUNT_RHS      },
    /*  7 */    { E_SHRASG,     0,  1,  BUILD_BITCOUNT_RHS      },
    /*  8 */    { E_ANDASG,     0,  1,  BUILD_ARITH_LHS         },
    /*  9 */    { E_ORASG,      0,  1,  BUILD_ARITH_LHS         },
    /* 10 */    { E_XORASG,     0,  1,  BUILD_ARITH_LHS         },

    /* 11 */    { E_XOR,        0,  1,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      },

    /* 12 */    { E_DIV,        2,  1,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      },

    /* 13 */    { E_MUL,        2,  1,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      },

    /* 14 */    { E_ADD,        1,  2,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      |
                                        BUILD_SCALE_RESULT      },

    /* 15 */    { E_SUB,        1,  3,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      |
                                        BUILD_SCALE_RESULT      },

    /* 16 */    { E_GT,         2,  2,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      |
                                        BUILD_INT_RESULT        },

    /* 17 */    { E_SHR,        0,  1,  BUILD_PROMOTE_LHS       |
                                        BUILD_BITCOUNT_RHS      },

    /* 18 */    { E_GTEQ,       2,  2,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      |
                                        BUILD_INT_RESULT        },

    /* 19 */    { E_LT,         2,  2,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      |
                                        BUILD_INT_RESULT        },

    /* 20 */    { E_SHL,        0,  1,  BUILD_PROMOTE_LHS       |
                                        BUILD_BITCOUNT_RHS      },

    /* 21 */    { E_LTEQ,       2,  2,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      |
                                        BUILD_INT_RESULT        },

    /* 22 */    { E_AND,        0,  1,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      },

    /* 23 */    { E_LAND,       0,  1,  BUILD_PROMOTE_LHS       |
                                        BUILD_LOGICAL           |
                                        BUILD_INT_RESULT        },

    /* 24 */    { E_EQ,         2,  2,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      |
                                        BUILD_NULL0_LHS         |
                                        BUILD_NULL0_RHS         |
                                        BUILD_UPGRADE_LHS       |
                                        BUILD_UPGRADE_RHS       |
                                        BUILD_INT_RESULT        },

    /* 25 */    { E_NEQ,        2,  2,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      |
                                        BUILD_NULL0_LHS         |
                                        BUILD_NULL0_RHS         |
                                        BUILD_UPGRADE_LHS       |
                                        BUILD_UPGRADE_RHS       |
                                        BUILD_INT_RESULT        },

    /* 26 */    { E_OR,         0,  1,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      },

    /* 27 */    { E_LOR,        0,  1,  BUILD_PROMOTE_LHS       |
                                        BUILD_LOGICAL           |
                                        BUILD_INT_RESULT        },

    /* 28 */    { E_MOD,        0,  1,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      },

    /* 29 */    { E_COLON,      2,  4,  BUILD_PROMOTE_LHS       |
                                        BUILD_ARITH_USUALS      |
                                        BUILD_DOWNGRADE_LHS     |
                                        BUILD_DOWNGRADE_RHS     |
                                        BUILD_NULL0_LHS         |
                                        BUILD_NULL0_RHS         }
};

/* [rough] valid operand combinations. these are used in (idx, len)
   tuples which are associated with operators in the above map[] */

static struct { long left_ts; long right_ts; } operands[] =
{
    /* 0 */     { T_INTEGRAL,               T_INTEGRAL                  },
    /* 1 */     { T_PTR,                    T_INTEGRAL                  },
    /* 2 */     { T_ARITH,                  T_ARITH                     },
    /* 3 */     { T_PTR,                    T_PTR                       },
    /* 4 */     { T_STRUN,                  T_STRUN                     },
    /* 5 */     { T_VOID,                   T_VOID                      }
};

/* perform the usual arithmetic conversions (C89 6.2.1.5).
   the caller has already determined that the operands are
   arithmetic types and has promoted them as necessary.

   the flags argument comes from map[] below. we use it to
   differentiate those cases (specifically, many compound
   assignment operators) where only the right side should
   be cast to the common type.

   this is fast, but perhaps too clever. it relies on
   the ordering of T_INT .. T_LDOUBLE bits (see type.h). */

#define USUALS0(C)                                                          \
    do {                                                                    \
        if ((TYPE_BASE(tree->C->type) & t) == 0)                            \
            tree->C = unary_tree(E_CAST, get_tnode(t, 0, 0), tree->C);      \
    } while (0)

static void usuals(struct tree *tree, int flags)
{
    long t = MAX(TYPE_BASE(tree->left->type),
             TYPE_BASE(tree->right->type));

    if (flags & BUILD_ARITH_USUALS)         /* if BUILD_ARITH_HALF, ...*/
        USUALS0(left);                      /* left is not promoted ... */

    STRIP_QUALIFIERS(tree->left->type);     /* ... but we do strip it */

    USUALS0(right);
    STRIP_QUALIFIERS(tree->right->type);
}

/* upgrade or downgrade pointers in the presence of a void pointer.

   if we upgrade a void pointer, we inherit the qualifiers of the target
   pointer type, because they are ultimately ignored by all the operators
   which do upgrading (relational and equality operators) or have already
   been considered (assignment). when downgrading, however, we must take
   pains to preserve the original qualifiers, since the ternary operator
   needs them to construct its composite result type.

   this macro is written left-handed for easy comprehension. we
   pass in the arguments' duals to get the right-handed version. */

#define GRADE(L, R, LHS, RHS, RQ)                                           \
    do {                                                                    \
        if (VOID_PTR_TYPE(tree->L->type))                                   \
            if (flags & BUILD_UPGRADE_##LHS)                                \
                tree->L->type = tree->R->type;                              \
            else if (flags & BUILD_DOWNGRADE_##RHS)                         \
                tree->R->type = PTR(qualify(&void_type, RQ));               \
    } while (0)

/* this function is big, gnarly, and brittle, but c operator semantics are
   fixed, so we should have no headaches from maintenance and modification */

struct tree *build_tree(int k, struct tree *left, struct tree *right)
{
    int flags = map[K_MAP_IDX(k)].flags;
    struct tree *tree;

    right = promote(right, 0);
    if (flags & BUILD_PROMOTE_LHS) left = promote(left, 0);
    if (flags & BUILD_NULL0_LHS) left = null0(left, right);
    if (flags & BUILD_NULL0_RHS) right = null0(right, left);
    tree = binary_tree(map[K_MAP_IDX(k)].op, 0, left, right);
    POINTER_LEFT(tree);

    if (flags & BUILD_LOGICAL)
    {
        tree->right = test(tree->right, K_NOTEQ, k);
        tree->left = test(tree->left, K_NOTEQ, k);
    } else {
        int len = map[K_MAP_IDX(k)].len;
        int idx = map[K_MAP_IDX(k)].idx;
        int i;

        for (i = 0; i < len; ++i)
            if ((TYPE_BASE(tree->left->type) & operands[idx + i].left_ts)
              && (TYPE_BASE(tree->right->type) & operands[idx + i].right_ts))
                break;

        if (i == len) goto incompatible;
    }

    if (PTR_TYPE(tree->left->type) && PTR_TYPE(tree->right->type))
    {
        long lquals = TYPE_QUALS(DEREF(tree->left->type));
        long rquals = TYPE_QUALS(DEREF(tree->right->type));

        if ((tree->op == E_ASG) && ((lquals & rquals) != rquals))
            error(ERROR, 0, "%k discards %q", k, (lquals & rquals) ^ rquals);

        GRADE(left, right, LHS, RHS, rquals);
        GRADE(right, left, RHS, LHS, lquals);

        if (compat(unqualify(DEREF(tree->left->type)),
                   unqualify(DEREF(tree->right->type))) == 0)
            goto incompatible;

        /* C89 6.3.8 [inexplicably] disallows comparisons between otherwise
           compatible pointer types if one is complete and the other is not.
           this pecularity of relational operators is withdrawn in C11, so
           we don't enforce it, but right here would be the place to check. */

        if (tree->op == E_COLON) {
            /* the ternary operator is definitely the black sheep. the
               result type is the composition of the lhs and rhs types
               with the qualifiers of both (C89 6.3.15). */

            struct tnode *composite;

            composite = compose(unqualify(DEREF(tree->left->type)),
                                unqualify(DEREF(tree->right->type)), 0);

            composite = PTR(qualify(composite, lquals | rquals));
            tree->left->type = composite;
            tree->right->type = composite;
        }
    }

    if (STRUN_TYPE(tree->left->type) && STRUN_TYPE(tree->right->type)
      && (STRUN_TAG(tree->left->type) != STRUN_TAG(tree->right->type)))
        goto incompatible;

    if (ARITH_TYPE(tree->left->type) && ARITH_TYPE(tree->right->type))
    {
        if (flags & (BUILD_ARITH_USUALS | BUILD_ARITH_HALF))
            usuals(tree, flags);

        if (flags & BUILD_ARITH_LHS)
            tree->right = unary_tree(E_CAST, tree->left->type, tree->right);
    }

    if (flags & BUILD_BITCOUNT_RHS)
        tree->right = unary_tree(E_CAST, &char_type, tree->right);

    if (flags & BUILD_INT_RESULT)
        tree->type = &int_type;
    else if (flags & BUILD_SCALE_RESULT)
        tree = scale(tree);
    else /* default to type of lhs */
        tree->type = tree->left->type;

    return tree;

incompatible:
    error(ERROR, 0, "incompatible type(s) for %k", k);
}

/* we could use build_tree() to do the work, but we can do it
   faster ourselves AND save the optimizer some work later */

struct tree *test(struct tree *tree, int cmp, int k)
{
    struct tree *zero;

    zero = I_TREE(&int_type, 0);

    if (!SCALAR_TYPE(tree->type)) {     /* try to avoid promotion, but it */
        tree = promote(tree, 0);        /* might be an array or function */

        if (!SCALAR_TYPE(tree->type))
            error(ERROR, 0, "%k requires a scalar expression", k);
    }

    zero = unary_tree(E_CAST, tree->type, zero);
    return binary_tree((cmp == K_EQEQ) ? E_EQ : E_NEQ, &int_type, tree, zero);
}

/* ensure the tree is an lvalue, and test for related
   properties. token class k is for error reporting. */

#define LVALUE_MUTABLE  0x00000001      /* is not const */
#define LVALUE_NOREG    0x00000002      /* can't have register class */
#define LVALUE_STRIP    0x00000004      /* strip qualifiers after check */

static void lvalue(struct tree *tree, int k, int flags)
{
    if (!LVALUE_TREE(tree))
        error(ERROR, 0, "%k requires an lvalue", k);

    if (((flags & LVALUE_NOREG) && (tree->op == E_SYM)
      && (tree->sym->s & S_REGISTER)))
        error(ERROR, 0, "can't apply %k to register variable", k);

    if ((flags & LVALUE_MUTABLE) && IMMUTABLE_TYPE(tree->type))
        error(ERROR, 0, "%k requires non-`const' target", k);

    if (flags & LVALUE_STRIP) STRIP_QUALIFIERS(tree->type);
}

/* build a tree for pre- or post-increment/decrement operators.
   op is either E_ADDASG or E_POST (pre or post, respectively),
   and k is either K_INC or K_DEC (increment or decrement). */

static struct tree *crement(struct tree *tree, int op, int k)
{
    struct tree *addend;
    int inc = (k == K_INC) ? 1 : -1;

    lvalue(tree, k, LVALUE_MUTABLE | LVALUE_STRIP);

    if (PTR_TYPE(tree->type))
        addend = I_TREE(&long_type, inc);
    else if (INTEGRAL_TYPE(tree->type))
        addend = I_TREE(tree->type, inc);
    else if (FLOATING_TYPE(tree->type))
        addend = F_TREE(tree->type, inc);
    else
        error(ERROR, 0, "%k requires scalar operand", k);

    tree = binary_tree(op, 0, tree, addend);
    tree = scale(tree);
    return tree;
}

/* primary-expression
            :   <identifier>
            |   <constant>
            |   <string-literal>
            |   '(' expression ')'
            |   '(' compound-statement ')'  */

static int no_stmt_expr;

static struct tree *primary(void)
{
    struct string *id;
    struct symbol *sym;
    struct tree *tree;

    switch (token.k)
    {
    case K_ICON:    tree = I_TREE(&int_type, token.con.i); lex(); break;
    case K_UCON:    tree = I_TREE(&uint_type, token.con.i); lex(); break;
    case K_LCON:    tree = I_TREE(&long_type, token.con.i); lex(); break;
    case K_ULCON:   tree = I_TREE(&ulong_type, token.con.i); lex(); break;
    case K_FCON:    tree = F_TREE(&float_type, token.con.f); lex(); break;
    case K_DCON:    tree = F_TREE(&double_type, token.con.f); lex(); break;
    case K_LDCON:   tree = F_TREE(&ldouble_type, token.con.f); lex(); break;

    case K_STRLIT:  sym = literal(token.s);
                    tree = sym_tree(sym);
                    lex();
                    break;

    case K_LPAREN:  lex();

                    if (token.k == K_LBRACE) {
                        if (no_stmt_expr)
                            error(ERROR, 0, "statement expressions"
                                            " prohibited here");

                        enter_scope(0);
                        compound(0);
                        exit_scope(&func_chain);
                        tree = stmt_tree;
                    } else
                        tree = expression();

                    MATCH(K_RPAREN);
                    break;

    case K_IDENT:   id = token.s;
                    lex();
                    sym = lookup(id, S_NORMAL, outer_scope, FILE_SCOPE);

                    if (sym) {
                        if (sym->s & S_CONST) {
                            tree = I_TREE(&int_type, sym->value);
                            break;
                        }
                    } else {
                        if (token.k == K_LPAREN)
                            sym = implicit(id);
                        else
                            error(ERROR, id, "unknown identifier");
                    }

                    if (sym->s & S_TYPEDEF)
                        error(ERROR, id, "misplaced typedef name");

                    sym->s |= S_REFERENCED;
                    tree = sym_tree(sym);
                    break;

    default:        error(ERROR, 0, "expected expression (got %k)", token.k);
    }

    return tree;
}

/* perform member access for . and -> operators. conceptually
   simple, but we need to account for a few real-world issues:

   1. if the struct/union being accessed isn't an
      lvalue, then the accessed member isn't either.

   2. if the struct or union is qualified, then the
      accessed member inherits those qualifiers.

   3. a member can be a bitfield, but its accessed value cannot. */

static struct tree *access(struct tree *tree)
{
    struct symbol *tag;
    struct symbol *member;
    int fetch = E_FETCH;
    long quals;

    if (token.k == K_DOT) {
        if (!LVALUE_TREE(tree)) fetch = E_RFETCH;
        tree = unary_tree(E_ADDROF, PTR(tree->type), tree);
    }

    if (!STRUN_PTR_TYPE(tree->type))
        error(ERROR, 0, "%k requires struct or union type", token.k);

    tag = STRUN_TAG(DEREF(tree->type));
    quals = TYPE_QUALS(DEREF(tree->type));

    if (!DEFINED_SYMBOL(tag))
        error(ERROR, 0, "%k cannot be applied to incomplete %T", token.k,
                                                                 tag);

    lex();
    expect(K_IDENT);
    member = lookup_member(token.s, tag);
    lex();

    tree = binary_tree(E_ADD, PTR(qualify(member->type, quals)),
                       tree, I_TREE(&long_type, member->offset));

    tree = unary_tree(fetch, DEREF(tree->type), tree);
    tree->type = unfieldify(tree->type);

    return tree;
}

/* function call is messy, as it must handle the vicissitudes of prototyped
   functions, unprototyped functions, variadic functions, struct returns... */

static struct tree *call(struct tree *tree)
{
    struct tnode *func;
    struct tnode *ret;
    struct tree *call;
    struct tree *arg;
    struct formal *formal;
    struct string *id;

    lex();

    /* most often, the left-hand-side is a simple expression consisting of
       just a symbol- either a function name or a function pointer variable.
       in either case, we can provide some better error context. */

    id = (tree->op == E_SYM) ? tree->sym->id : 0;

    tree = promote(tree, 0);        /* pointer-to-func (we hope) */
    func = DEREF(tree->type);       /* recover function type */

    if (!func || !FUNC_TYPE(func))
        error(ERROR, 0, "() requires function or pointer-to-function");

    ret = DEREF(func);              /* return type */

    tree = call = unary_tree(E_CALL, ret, tree);
    formal = func->formals;

   /* if the function returns a struct, we create a temporary to hold the
      value and insert a pointer to it as a hidden argument. then we adjust
      the node type to pointer-to-struct, and fetch the result. */

    if (STRUN_TYPE(ret)) {
        tree = sym_tree(temp(ret));
        tree = unary_tree(E_ADDROF, PTR(ret), tree);
        actual(call, tree);
        call->type = PTR(ret);
        tree = unary_tree(E_RFETCH, ret, call);
    }

    if (token.k != K_RPAREN) {
        for (;;) {
            arg = assignment();

            if (formal == 0) {
                if (OLD_STYLE_FUNC(func) || VARIADIC_FUNC(func))
                    arg = promote(arg, 1);
                else
                    error(ERROR, id, "too many function arguments");
            } else {
                arg = fake(arg, formal->type, K_ARG);
                formal = formal->next;
            }

            size_of(arg->type, 0);
            actual(call, arg);

            if (token.k == K_RPAREN)
                break;
            else
                MATCH(K_COMMA);
        }
    }

    MATCH(K_RPAREN);
    if (formal) error(ERROR, id, "too few function arguments");

    return tree;
}

/* postfix-expression
            :   primary-expression
            |   postfix-expression '[' expression ']'
            |   postfix-expression '(' [ argument-expression-list ] ')'
            |   postfix-expression '.' <identifier>
            |   postfix-expression '->' <identifier>
            |   postfix-expression '++'
            |   postfix-expression '--'     */

static struct tree *postfix(void)
{
    struct tree *tree;
    struct tree *rhs;

    tree = primary();

    for (;;)
    {
        switch (token.k)
        {
        case K_INC:
        case K_DEC:     tree = crement(tree, E_POST, token.k);
                        lex();
                        break;

        case K_LPAREN:  tree = call(tree);
                        break;

        case K_DOT:
        case K_ARROW:   tree = access(tree);
                        break;

        case K_LBRACK:  lex();
                        tree = promote(tree, 0);
                        rhs = promote(expression(), 0);
                        tree = binary_tree(E_ADD, 0, tree, rhs);
                        MATCH(K_RBRACK);
                        POINTER_LEFT(tree);

                        if (!PTR_TYPE(tree->left->type)
                          || !INTEGRAL_TYPE(tree->right->type))
                            error(ERROR, 0, "invalid operands to []");

                        tree = scale(tree);
                        tree = unary_tree(E_FETCH, DEREF(tree->type), tree);
                        break;

        default:        return tree;
        }
    }
}

/* unary-expression
            :   postfix-expression
            |   '++' unary-expression
            |   '--' unary-expression
            |   unary-operator cast-expression
            |   'sizeof' unary-expression
            |   'sizeof' '(' type-name ')'

   unary-operator   :   '&' | '*' | '+' | '-' | '~' | '!'   */

static struct tree *unary(void)
{
    struct tree *tree;
    struct tnode *type;
    struct token peek;
    long ts;
    int op;
    int k;

    switch (k = token.k)
    {
    case K_MUL:     lex();
                    tree = cast();
                    tree = promote(tree, 0);

                    if (!PTR_TYPE(tree->type))
                        error(ERROR, 0, "illegal indirection");

                    return unary_tree(E_FETCH, DEREF(tree->type), tree);

    case K_AND:     lex();
                    tree = cast();
                    lvalue(tree, K_AND, LVALUE_NOREG);

                    /* C89 6.3.3.2 says the operand must be an lvalue, and
                       and C89 6.2.2.1 says that a void is never an lvalue.
                       this seems to make sense, but it means that:

                                    void *vp;
                                    void *vp2 = &*vp;

                       should be prohibited, and we would check for it here;
                       C99 6.5.3.2 relaxes the rule, so we don't enforce it */

                    if (FIELD_TREE(tree))
                        error(ERROR, 0, "can't apply %k to bitfield", K_AND);

                    return unary_tree(E_ADDROF, PTR(tree->type), tree);

    case K_NOT:     lex();
                    tree = cast();
                    return test(tree, K_EQEQ, K_NOT);

    case K_INC:
    case K_DEC:     lex();
                    return crement(unary(), E_ADDASG, k);

    case K_SIZEOF:  lex();
                    peek = lookahead();

                    if ((token.k == K_LPAREN) && K_IS_DECL(peek)) {
                        lex();
                        type = abstract();
                        MATCH(K_RPAREN);
                        tree = I_TREE(&ulong_type, size_of(type, 0));
                    } else {
                        tree = unary();
                        tree = I_TREE(&ulong_type, size_of(tree->type, 0));
                    }

                    return tree;

    default:        return postfix();

    /* these are the only operators that break the switch;
       the logic following is common to all three */

    case K_MINUS:   op = E_NEG; ts = T_ARITH; break;
    case K_PLUS:    op = E_PLUS; ts = T_ARITH; break;
    case K_TILDE:   op = E_COM; ts = T_INTEGRAL; break;
    }

    lex();
    tree = cast();
    tree = promote(tree, 0);

    if ((TYPE_BASE(tree->type) & ts) == 0)
        error(ERROR, 0, "illegal operand to unary %k", k);

    return unary_tree(op, tree->type, tree);
}

/* cast-expression
            :   unary-expression
            |   '(' type-name ')' cast-expression

   C89 6.3.4 requires only that the target type and the source expression have
   scalar types. it does not specifically prohibit casts between pointer types
   and floating-point types, though such a prohibition is implied.

   cast of a pointer to any int shorter than long results in truncation,
   and this may someday merit a warning, but we don't call it an error. */

static struct tree *cast(void)
{
    struct token peek;
    struct tnode *type;
    struct tree *tree;

    if (token.k == K_LPAREN) {
        peek = lookahead();

        if (K_IS_DECL(peek)) {
            lex();
            type = abstract();
            MATCH(K_RPAREN);
            tree = cast();
            tree = promote(tree, 0);

            if ((!SCALAR_TYPE(type) && !VOID_TYPE(type))
              || (FLOATING_TYPE(type) && PTR_TYPE(tree->type))
              || (FLOATING_TYPE(tree->type) && PTR_TYPE(type))
              || !SCALAR_TYPE(tree->type))
                error(ERROR, 0, "invalid cast");

            return unary_tree(E_CAST, type, tree);
        }
    }

    return unary();
}

/* binary-expression
            :   cast-expression
            |   binary-expression binary-operator cast-expression

   binary-operator  :   '*' | '/' | '%' | '+' | '-'
                    |   '<<' | '>>' | '<' | '>' | '>='
                    |   '<=' | '==' | '!=' | '&' | '^'
                    |   '|' | '&&' | '||'

   obviously this abbreviated grammar does not account for precedence.
   this function does precedence parsing for all these binary levels */

static struct tree *binary(struct tree *lhs, int prec)
{
    struct tree *rhs;
    int k;

    while (K_PREC(token.k) >= prec) {
        k = token.k;
        lex();
        rhs = cast();

        while (K_PREC(token.k) > K_PREC(k))
            rhs = binary(rhs, K_PREC_NEXT(k));

        lhs = build_tree(k, lhs, rhs);
    }

    return lhs;
}

/* ternary-expression
            :   binary-expression
            |   binary-expression '?' expression ':' ternary-expression

   if b and c are struns, we rewrite (a ? b : c) as *(a ? &b : &c).

   the former implies an aggregate temporary, which is not only inefficient,
   but also impossible for the tree generator. the latter also preserves the
   qualifiers of the strun in precisely the way we wish: the qualifiers of b
   and c are merged, so if either is volatile, so is the result, e.g.:

            given:
                    struct S { int member; ... };

                    int a;
                    const struct S b;
                    volatile struct S c;

            then:
                    (a ? b : c).member

   results in a volatile access to member, which is the desired behavior.
   (it is const access, too, but that is irrelevant; it is not an lvalue.)
   this [probably] behaves in the way intended by C89, and is unsurprising
   to the programmer, even if it does not adhere to the letter of the law. */

static struct tree *ternary(void)
{
    struct tree *tree;
    struct tree *lhs;
    struct tree *rhs;
    int wrap = 0;

    tree = binary(cast(), K_PREC_LOR);

    if (token.k == K_QUEST) {
        tree = test(tree, K_NOTEQ, K_QUEST);
        lex();
        lhs = expression();
        MATCH(K_COLON);
        rhs = ternary();

        if (STRUN_TYPE(lhs->type) && STRUN_TYPE(rhs->type)) {
            wrap = 1;
            lhs = unary_tree(E_ADDROF, PTR(lhs->type), lhs);
            rhs = unary_tree(E_ADDROF, PTR(rhs->type), rhs);
        }

        lhs = build_tree(K_COLON, lhs, rhs);
        tree = binary_tree(E_QUEST, lhs->type, tree, lhs);
        if (wrap) tree = unary_tree(E_RFETCH, DEREF(tree->type), tree);
    }

    return tree;
}

/* assignment-expression
            :   ternary-expression
            |   unary-expression assignment-operator assignment-expression

   assignment-operator  :   '=' | '*=' | '/=' | '%=' | '+=' | '-='
                        |   '<<=' | '>>=' | '&=' | '|=' | '^='          */

struct tree *assignment(void)
{
    struct tree *tree;
    struct tree *right;
    int k;

    tree = ternary();

    if (K_PREC(token.k) == K_PREC_ASG) {
        k = token.k;
        lex();
        right = assignment();
        lvalue(tree, k, LVALUE_MUTABLE | LVALUE_STRIP);
        tree = build_tree(k, tree, right);
    }

    return tree;
}

/* expression
            :   assignment-expression
            |   expression ',' assignment-expression

    the comma operator is left-associative, but we write comma trees as if
    it were right-associative. this does not affect evaluation order and is
    slightly more convenient.

    if b is a struct/union, we rewrite (a, b) as *(a, &b). see ternary(). */

struct tree *expression(void)
{
    struct tree *tree;
    struct tree *right;
    int wrap;

    tree = assignment();

    if (token.k == K_COMMA) {
        lex();
        right = expression();

        if (wrap = (STRUN_TYPE(right->type) != 0))
            right = unary_tree(E_ADDROF, PTR(right->type), right);

        tree = binary_tree(E_COMMA, right->type, tree, right);
        if (wrap) tree = unary_tree(E_RFETCH, DEREF(tree->type), tree);
    }

    return tree;
}

struct tree *fake(struct tree *tree, struct tnode *type, int k)
{
    static struct tree none = { E_NONE };

    none.type = type;
    tree = build_tree(k, &none, tree);
    tree = chop_right(tree);

    return tree;
}

struct tree *case_expr(void)
{
    struct tree *tree;

    ++no_stmt_expr;
    tree = assignment();
    tree = fold(tree);
    --no_stmt_expr;

    if (!PURE_CON_TREE(tree) || !INTEGRAL_TYPE(tree->type))
        error(ERROR, 0, "integral constant expression required");

    return tree;
}

int constant_expr(void)
{
    struct tree *tree;

    tree = case_expr();

    if (!con_in_range(T_INT, &tree->con))
        error(ERROR, 0, "constant expression out of range");

    return tree->con.i;
}

struct tree *static_expr(void)
{
    struct tree *tree;

    ++no_stmt_expr;
    tree = ternary();
    tree = promote(tree, 0);
    tree = fold(tree);
    --no_stmt_expr;

    if (!CON_TREE(tree))
        error(ERROR, 0, "constant expression required");

    return tree;
}

/* vi: set ts=4 expandtab: */
