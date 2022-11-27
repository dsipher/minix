/*****************************************************************************

   tree.c                                                 minix c compiler

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

#include <stdio.h>
#include "cc1.h"
#include "heap.h"
#include "fold.h"
#include "type.h"
#include "symbol.h"
#include "string.h"
#include "tree.h"

struct tree void_tree = { E_NONE, 0, &void_type };

#define NEW_TREE(_op, _type)                                                \
    ({                                                                      \
        struct tree *_new;                                                  \
                                                                            \
        _new = arena_alloc(&stmt_arena, sizeof(struct tree), 0);            \
        _new->op = (_op);                                                   \
        _new->nr_args = 0;                                                  \
        _new->type = (_type);                                               \
                                                                            \
        _new;                                                               \
    })

/* this is recursive, and thus, not especially fast.
   we don't use dup_tree() very often, though (only
   for loop inversion in stmt.c at the moment), and
   when do, the trees tend to be small... */

struct tree *dup_tree(struct tree *tree)
{
    struct tree *new;
    int n;

    new = NEW_TREE(tree->op, tree->type);

    if (LEAF_TREE(new)) {
        new->con = tree->con;
        new->sym = tree->sym;
    } else if (UNARY_TREE(new)) {
        new->child = dup_tree(tree->child);

        for (n = 0; n < tree->nr_args; ++n)
            actual(new, dup_tree(tree->args[n]));
    } else { /* BINARY_TREE(new) */
        new->left = dup_tree(tree->left);
        new->right = dup_tree(tree->right);
    }

    return new;
}

#define CHOP0(C)                                                            \
     do {                                                                   \
        tree->C->type = tree->type;                                         \
        tree = tree->C;                                                     \
                                                                            \
        if (tree->op == E_CON)                                              \
            normalize_con(TYPE_BASE(tree->type), &tree->con);               \
                                                                            \
        return tree;                                                        \
    } while (0)

struct tree *chop(struct tree *tree)        { CHOP0(child); }
struct tree *chop_left(struct tree *tree)   { CHOP0(left); }
struct tree *chop_right(struct tree *tree)  { CHOP0(right); }

struct tree *unary_tree(int op, struct tnode *type, struct tree *child)
{
    struct tree *new;

    new = NEW_TREE(op, type);
    new->child = child;
    new->args = 0;

    return new;
}

struct tree *binary_tree(int op, struct tnode *type, struct tree *left,
                                                     struct tree *right)
{
    struct tree *new;

    new = NEW_TREE(op, type);
    new->left = left;
    new->right = right;

    return new;
}

struct tree *con_tree(struct tnode *type, union con *conp)
{
    struct tree *new;

    new = NEW_TREE(E_CON, type);
    new->con = *conp;
    new->sym = 0;

    return new;
}

struct tree *sym_tree(struct symbol *sym)
{
    struct tree *new;

    new = NEW_TREE(E_SYM, sym->type);
    new->sym = sym;
    new->con.i = 0;

    return new;
}

struct tree *seq_tree(struct tree *left, struct tree *right)
{
    struct tree *new;

    if (left == 0) return right;
    if (right == 0) return left;

    new = NEW_TREE(E_SEQ, &void_type);
    new->left = left;
    new->right = right;

    return new;
}

struct tree *blk_tree(int op, struct tree *left, struct tree *right,
                              struct tree *size)
{
    struct tree *tree;

    tree = NEW_TREE(op, left->type);
    tree->left = NEW_TREE(E_COLON, &void_type);
    tree->left->left = left;
    tree->left->right = right;

    tree->right = size;

    return tree;
}

/* we avoid general vector routines because our needs are simple; it
   looks a bit gnarlier than it really is. we grow the vector when:

        1. it's not yet been allocated at all (call->nr_args == 0), OR
        2. when the vector is already full. this is when the current
           size is a power of two, but not before we've reached the
           the minimum allocation (MIN_NR_ARGS). */

#define MIN_ARGS_ALLOC      4       /* must be a power of two */

void actual(struct tree *call, struct tree *arg)
{
    struct tree **new_args;
    int new_nr_args;
    int i;

    if (call->nr_args == MAX_ARGS)
        error(SORRY, 0, "can't handle that many arguments");

    if ((call->nr_args == 0) || ((call->nr_args >= MIN_ARGS_ALLOC)
                                    && POW2(call->nr_args)))
    {
        new_nr_args = call->nr_args ? (call->nr_args << 1)
                                    : MIN_ARGS_ALLOC;

        new_args = arena_alloc(&stmt_arena,
                               new_nr_args * sizeof(struct tree *), 0);

        for (i = 0; i < call->nr_args; ++i)
            new_args[i] = call->args[i];

        call->args = new_args;
    }

    call->args[call->nr_args] = arg;
    ++call->nr_args;
}

#define CON_TREE0(VAL, OP)                                                  \
    {                                                                       \
        if (PURE_CON_TREE(tree))                                            \
            if (FLOATING_TYPE(tree->type))                                  \
                return tree->con.f OP VAL;                                  \
            else                                                            \
                return tree->con.i OP VAL;                                  \
                                                                            \
        return 0;                                                           \
    }

int zero_tree(struct tree *tree) CON_TREE0(0, ==)
int nonzero_tree(struct tree *tree) CON_TREE0(0, !=)

/* constant folding: simple in concept. a tedious mess in the details.

   we leave untouched any operations that have undefined results (e.g.,
   division by 0) and leave the user to their fortunes at runtime. if
   such operations arise where a constant expression is required, the
   compiler will report that the expression isn't constant, which is
   correct, but probably confusing.

   we perform all floating-point operations in doubles, which conforms with
   C89 6.4 which requires that the precision and range be 'at least as great
   as if the expression were being evaluated in the execution environment'. */

#define FOLD_UNARY_TREE(T, OP)                                              \
    do {                                                                    \
        FOLD_UNARY(TYPE_BASE(T->child->type), T->child, OP);                \
        T = chop(T);                                                        \
    } while (0)

#define FOLD_UNARY_I_TREE(T, OP)                                            \
    do {                                                                    \
        FOLD_UNARY_I(TYPE_BASE(T->child->type), T->child, OP);              \
        T = chop(T);                                                        \
    } while (0)

#define FOLD_BINARY_TREE(T, OP)                                             \
    do {                                                                    \
        FOLD_BINARY(TYPE_BASE(T->left->type), T->left, T->right, OP);       \
        T = chop_left(T);                                                   \
    } while (0)

#define FOLD_BINARY_I_TREE(T, OP)                                           \
    do {                                                                    \
        FOLD_BINARY_I(TYPE_BASE(T->left->type), T->left, T->right, OP);     \
        T = chop_left(T);                                                   \
    } while (0)

#define FOLD_SHIFT_TREE(T, OP)                                              \
    do {                                                                    \
        FOLD_SHIFT(TYPE_BASE(T->left->type), T->left, T->right, OP);        \
        T = chop_left(T);                                                   \
    } while (0)

#define FOLD_EQUALITY_TREE(T, OP)                                           \
    do {                                                                    \
        int _result;                                                        \
                                                                            \
        if (FLOATING_TYPE(T->left->type))                                   \
            _result = T->left->con.f OP T->right->con.f;                    \
        else                                                                \
            _result = T->left->con.u OP T->right->con.u;                    \
                                                                            \
        T = I_TREE(&int_type, _result);                                     \
    } while (0)

#define FOLD_RELATIONAL_TREE(T, OP)                                         \
    do {                                                                    \
        int _result;                                                        \
                                                                            \
        if (FLOATING_TYPE(T->left->type))                                   \
            _result = T->left->con.f OP T->right->con.f;                    \
        else if (SIGNED_TYPE(T->left->type))                                \
            _result = T->left->con.i OP T->right->con.i;                    \
        else                                                                \
            _result = T->left->con.u OP T->right->con.u;                    \
                                                                            \
        T = I_TREE(&int_type, _result);                                     \
    } while (0)

static struct tree *fold0(struct tree *tree)
{
    if (UNARY_TREE(tree)) {
        if ((tree->op == E_CAST) && CON_TREE(tree->child)) {
            if (cast_con(TYPE_BASE(tree->type),
                         TYPE_BASE(tree->child->type),
                         &tree->child->con,
                         (tree->child->sym == 0)))
            {
                tree = chop(tree);
            }

            return tree;
        }

        if (PURE_CON_TREE(tree->child)) {
            switch (tree->op)
            {
            case E_PLUS:    tree = chop(tree); return tree;
            case E_NEG:     FOLD_UNARY_TREE(tree, -); return tree;
            case E_COM:     FOLD_UNARY_I_TREE(tree, ~); return tree;
            }
        }
    } else if (BINARY_TREE(tree)) {
        if (nonzero_tree(tree->left)) {
            switch (tree->op)
            {
            case E_QUEST:   tree = chop_right(tree);
                            tree = chop_left(tree);
                            return tree;

            case E_LAND:    tree = chop_right(tree);
                            return tree;

            case E_LOR:     return I_TREE(&int_type, 1);
            }
        } else if (zero_tree(tree->left)) {
            switch (tree->op)
            {
            case E_QUEST:   tree = chop_right(tree);
                            tree = chop_right(tree);
                            return tree;

            case E_LAND:    return I_TREE(&int_type, 0);

            case E_LOR:     tree = chop_right(tree);
                            return tree;
            }
        }

        if (COMMUTATIVE_TREE(tree)      /* put any impure constant on left */
          && CON_TREE(tree->left)
          && CON_TREE(tree->right))
            FOLD_COMMUTE(struct tree *, tree->left, tree->right);

        if ((tree->op == E_SUB)         /* attempt to 'purify' operands */
          && CON_TREE(tree->left)
          && CON_TREE(tree->right))
            FOLD_PRESUBTRACT(tree->left, tree->right);

        if (PURE_CON_TREE(tree->right)) {
            if (CON_TREE(tree->left)) {
                switch (tree->op)
                {
                case E_ADD:     FOLD_BINARY_TREE(tree, +); return tree;
                case E_SUB:     FOLD_BINARY_TREE(tree, -); return tree;
                }
            }

            if (PURE_CON_TREE(tree->left)) {
                switch (tree->op)
                {
                case E_DIV:     /* integer division by zero would be fatal to
                                   the compiler, but this prevents floating-
                                   point division by zero, too, which is not
                                   strictly necessary. it will fold in LIR */

                                if (!zero_tree(tree->right))
                                    FOLD_BINARY_TREE(tree, /);

                                return tree;

                case E_MOD:     if (!zero_tree(tree->right))
                                    FOLD_BINARY_I_TREE(tree, %);

                                return tree;

                case E_MUL:     FOLD_BINARY_TREE(tree, *); return tree;
                case E_SHL:     FOLD_SHIFT_TREE(tree, <<); return tree;
                case E_SHR:     FOLD_SHIFT_TREE(tree, >>); return tree;
                case E_AND:     FOLD_BINARY_I_TREE(tree, &); return tree;
                case E_OR:      FOLD_BINARY_I_TREE(tree, |); return tree;
                case E_XOR:     FOLD_BINARY_I_TREE(tree, ^); return tree;
                case E_EQ:      FOLD_EQUALITY_TREE(tree, ==); return tree;
                case E_NEQ:     FOLD_EQUALITY_TREE(tree, !=); return tree;
                case E_GT:      FOLD_RELATIONAL_TREE(tree, >); return tree;
                case E_GTEQ:    FOLD_RELATIONAL_TREE(tree, >=); return tree;
                case E_LT:      FOLD_RELATIONAL_TREE(tree, <); return tree;
                case E_LTEQ:    FOLD_RELATIONAL_TREE(tree, <=); return tree;
                }
            }
        }
    }

    return tree;
}

/* indirect0() simplifies addressing and indirection. it:

        1. rewrites E_ADDROF nodes as E_CON leaves when possible, and
        2. collapses E_FETCH/E_ADDROF and E_ADDROF/E_FETCH pairs.

   these are not just optimizations, they are required:

   the front end needs the first to completely evaluate static initializers.
   the tree generator can't handle stacks of E_ADDROF/E_FETCH operations. */

static struct tree *indirect0(struct tree *tree)
{
    struct tree *child = tree->child;

    switch (tree->op)
    {
    case E_ADDROF:
        if ((child->op == E_SYM) && (child->sym->s & (S_EXTERN | S_STATIC))) {
            tree = chop(tree);              /* a global symbol address */
            tree->op = E_CON;               /* is known to the assembler. */
            tree->con.i = 0;                /* rewrite as impure constant */
        } else if (FETCH_TREE(child)) {
            tree = chop(tree);
            tree = chop(tree);
        }

        break;

    case E_FETCH:
    case E_RFETCH:

        /* we must exercise caution in the presence of type punning to
           avoid creating an E_SYM with a type at odds with its symbol's.

            if      int i;

            then    *(&i);              can be rewritten E_SYM(int, i)
            but     *(float *)(&i);     CANNOT be rewritten E_SYM(float, i)

           the danger has its roots in constant folding and/or cast
           simplification, where conceptual pointer casts are elided. */

        if ((child->op == E_CON) && child->sym && (child->con.i == 0)) {
            if (simpatico(tree->type, child->sym->type))
            {
                tree = chop(tree);          /* inverse of E_ADDROF above, */
                tree->op = E_SYM;           /* change E_CON back to E_SYM */
            }
        } else if (child->op == E_ADDROF) {
            if ((child->child->op != E_SYM)
              || simpatico(tree->type, child->child->sym->type))
            {
                tree = chop(tree);
                tree = chop(tree);
            }
        }

        break;
    }

    return tree;
}

/* shift operations automatically imply a mask of the
   shift count, by 63 if the lhs is long, 31 otherwise.
   this reflects the semantics of ATOM shift insns. if
   the user masks explicitly, their mask is redundant,
   and thus can be eliminated. e.g.,

     long l; l <<= (j & 63)  becomes  l <<= j;
     int i;  i << (x & 31)   becomes  i << x;    etc. */

static struct tree *shiftmask0(struct tree *tree)
{
    switch (tree->op)
    {
    case E_SHR:
    case E_SHL:
    case E_SHRASG:
    case E_SHLASG:      break;

    default:            return tree;
    }

    if (tree->right->op != E_AND) return tree;

    /* fold0() will have put any pure constant
       on the right side of the E_AND... */

    if (!PURE_CON_TREE(tree->right->right)) return tree;

    if (tree->right->right->con.i
      != (LONGS_TYPE(tree->left->type) ? 63 : 31))
        return tree;

    tree->right = chop_left(tree->right);   /* skip E_AND */

    return tree;
}

/* rewrite comparisons between unsigned types
   and zero. given an unsigned value `n',

    n > 0    is more simply expressed as    n != 0
    n <= 0                                  n == 0
    n >= 0                                  1 (constant)
    n < 0                                   0 (constant)

   the first two allow us to exploit the Z flag more thoroughly.
   whether the last two should draw a warning is up for debate. */

static struct tree *unsigned0(struct tree *tree)
{
    if (!BINARY_TREE(tree)) return tree;

    /* fold0() has already placed
       any zero on the right */

    if (!zero_tree(tree->right)) return tree;
    if (!UNSIGNED_TYPE(tree->left->type)) return tree;

    switch (tree->op)
    {
    case E_GT:      tree->op = E_NEQ; break;
    case E_LTEQ:    tree->op = E_EQ; break;
    case E_GTEQ:    tree = I_TREE(&int_type, 1); break;
    case E_LT:      tree = I_TREE(&int_type, 0); break;
    }

    return tree;
}

/* rewrite struct assignments. in the most straightforward case (1), we
   convert the E_ASG to a E_BLKCPY. functions which return structs, we
   attempt to elide the assignment by passing in the target directly (2).

        given:
                struct S { .... } a, b, f(void);

        1.      (a = b)                         ->  *(&a BLKCPY &b)

        2.      (a = f())   ->  (a = *f(&tmp))  ->  *(f(&a))
                            [see call() in expr.c]

   this 'simplification' is mandatory, since the tree generator can't
   process E_ASGs with struct operands. we delay this rewrite to this
   stage (not during parsing) to maximize the applicability of (2). */

#define RESTRUN0(LHS, LEFT)                                                 \
    do {                                                                    \
        LHS = tree->LEFT;                                                   \
        LHS = addrof(LHS, PTR(LHS->type));                                  \
    } while (0)

static struct tree *restrun0(struct tree *tree)
{
    struct tree *lhs;
    struct tree *rhs;

    if ((tree->op == E_ASG) && STRUN_TYPE(tree->type)) {
        RESTRUN0(lhs, left);
        RESTRUN0(rhs, right);

        /* it is sufficient to see a pointer to a temporary as the first
           argument in the E_CALL, since they never appear except when
           call() makes them in precisely the circumstances we need. */

        if ((rhs->op == E_CALL)
          && (rhs->nr_args)
          && (rhs->args[0]->op == E_ADDROF)
          && (rhs->args[0]->child->op == E_SYM)
          && (TEMP_SYMBOL(rhs->args[0]->child->sym)))
        {
            rhs->args[0] = lhs;
            tree = unary_tree(E_RFETCH, tree->type, rhs);
        } else {
            lhs = blk_tree(E_BLKCPY, lhs, rhs,
                           I_TREE(&ulong_type, size_of(tree->type, 0)));

            tree = unary_tree(E_RFETCH, tree->type, lhs);
        }
    }

    return tree;
}

#define NARROWING_CAST(T)       ((T->op == E_CAST) &&                       \
                                 narrower(T->type, T->child->type))

#define WIDENING_CAST(T)        ((T->op == E_CAST) &&                       \
                                 wider(T->type, T->child->type))

#define RECLASS_CAST(T)         ((T->op == E_CAST) &&                       \
                                 !SAME_CAST_CLASS(T->type, T->child->type))

/* eliminate conceptual and/or excessive casts. the aim is to reduce a
   chain of casts to the minimum number needed to produce the result. */

static struct tree *recast0(struct tree *tree)
{
    while (tree->op == E_CAST)
    {
        /* if the types are simpatico, the cast is
           conceptual only, i.e., it's a no-op. */

        if (simpatico(tree->type, tree->child->type))
            goto chop;

        /* if we're widening a widening cast:

                        char c; ((long) (int) c) == ((long) c)

           except this doesn't work if signedness is stripped in the middle:

                        char c; ((long) (unsigned) c) != ((long) c)

           or narrowing a widening cast:

                        float f; ((float) (double) f) == ((float) f)
                                    i.e., just f

           or narrowing a narrowing cast:

                        long l; ((char) (int) l) == ((char) l)

           we can skip the intervening cast. the third example
           is a good illustration of why we need to loop. */

        if (WIDENING_CAST(tree) && WIDENING_CAST(tree->child)
          && !(UNSIGNED_TYPE(tree->child->type)
          && SIGNED_TYPE(tree->child->child->type)))
            goto chop;

        if (NARROWING_CAST(tree) && WIDENING_CAST(tree->child))
            goto chop;

        if (NARROWING_CAST(tree) && NARROWING_CAST(tree->child))
            goto chop;

        /* if we're widening a value just to reclass it,

                    char c; ((float) (int) c) == ((float) c);
                    int i; ((double) (long) i) == ((double) i);

           we can skip the intervening cast. for the first case above,
           fpcast0() will reintroduce the cast because ATOM can't cast
           sub-int values to floats, but the second elimination is a win. */

        if (RECLASS_CAST(tree) && WIDENING_CAST(tree->child))
            goto chop;

        break;      /* no changes, exit */

chop:
        tree = chop(tree);
    }

    return tree;
}

/* ATOM has no insns which convert directly from chars, shorts, or
   unsigned ints to floating-point numbers, so we inject casts here.
   this sometimes undoes over-eager work done by recast0() above.

   there are no insns to convert between floating-point types and
   unsigned longs either, but the solution is more complex. that
   is not addressed here, but rather left to gen_cast() in gen.c. */

static struct tree *fpcast0(struct tree *tree)
{
    if ((tree->op == E_CAST) && FLOATING_TYPE(tree->type))
    {
        if (CHARS_TYPE(tree->child->type) || SHORTS_TYPE(tree->child->type))
            /* short integers must be sign- or
               zero-extended to a full int */

            tree->child = unary_tree(E_CAST, &int_type, tree->child);

        else if (UINT_TYPE(tree->child->type))
            /* unsigned ints must be (zero-)
               extended to a signed long */

            tree->child = unary_tree(E_CAST, &long_type, tree->child);
    }

    return tree;
}

/* helper for relcast0(), bincast0() and friends.

   given the operands of a binary operator, determine if they have
   been widened from the same underlying type. if so, return that
   underlying type. returns 0 otherwise.

   a constant counts as a widened operand, provided its value is in
   range of the non-constant operand's type. */

static struct tnode *underlying(struct tree *left, struct tree *right)
{
    struct tnode *left_under = 0;
    struct tnode *right_under = 0;

    if (WIDENING_CAST(left)) left_under = left->child->type;
    if (WIDENING_CAST(right)) right_under = right->child->type;

    if (left_under && right_under) {
        /* if both sides were widened, we need the underlying types
           to be nearly identical (i.e., modulo qualifiers). */

        if (TYPE_BASE(left_under) == TYPE_BASE(right_under))
            return left_under;
    } else {
        /* if only the one operand was widened, the other must be
           a constant in range of the non-constant operand's type */

        if (left_under && PURE_CON_TREE(right)
          && con_in_range(TYPE_BASE(left_under), &right->con))
            return left_under;

        if (right_under && PURE_CON_TREE(left)
          && con_in_range(TYPE_BASE(right_under), &left->con))
            return right_under;
    }

    return 0;
}

/* if the operands of E_AND have the same underlying type, the
   result is the same whether we promote them before the mask
   or mask them and promote the result. rewrite as the latter,
   since it often results in fewer casts (never more).

   we miss an opportunity when one operand is a constant with
   the sign bit of the underlying type of the other operand set.
   underlying() [correctly] recognizes the constant is not a
   valid constant of the underlying type and rejects it. this
   tree could be rewritten, but would require more extensive
   type manipulation to guarantee the same result. rainy day. */

static struct tree *andcast0(struct tree *tree)
{
    struct tnode *under;
    struct tnode *type;

    if ((tree->op != E_AND)
      || !(under = underlying(tree->left, tree->right)))
        return tree;

    type = tree->type;

    tree->type = under;
    tree->left = simplify(unary_tree(E_CAST, under, tree->left));
    tree->right = simplify(unary_tree(E_CAST, under, tree->right));

    tree = unary_tree(E_CAST, type, tree);
    return tree;
}

/* rewrite expressions like     int a, b;  b = a & 0xFF;
                         as                b = (unsigned char) a;

   this has two benefits. first, the zero-extension can be done in
   a single, two-address, insn on ATOM. second, the cast has more
   `synergy' when it's amidst a chain of other casts (not uncommon). */

static struct tree *andcast1(struct tree *tree)
{
    struct tnode *inter;
    struct tnode *final;

    if (tree->op != E_AND) return tree;

    if (PURE_CON_TREE(tree->left)) COMMUTE_TREE(tree);
    if (!PURE_CON_TREE(tree->right)) return tree;

    final = tree->type;     /* the final type */

    switch (tree->right->con.i)
    {
    case 0x000000FF:    inter = &uchar_type; break;
    case 0x0000FFFF:    inter = &ushort_type; break;

    default:            return tree;
    }

    tree = tree->left;                          /* forget the mask */
    tree = unary_tree(E_CAST, inter, tree);     /* downcast instead */
    tree = unary_tree(E_CAST, final, tree);     /* back to original type */
    tree = simplify(tree);                      /* try to squash new casts */

    return tree;
}

/* if we're narrowing the integral result of unary - or ~, we move
   the narrowing cast to the operand instead, since 2's complement
   arithmetic yields the same result either way.

   for example,                     char c; c = ~c;
   by language rules means:         char c; c = (char) ~ (int) c;
   migrating the cast yields:       char c; c = ~ (char) (int) c;

   which gives recast0() the chance the annihilate the casts.

   this transformation is not always a win, but it's never a
   loss: we never end up with more casts than we started with. */

static struct tree *uncast0(struct tree *tree)
{
    if (!NARROWING_CAST(tree)
      || !INTEGRAL_TYPE(tree->type)
      || ((tree->child->op != E_NEG)
      && (tree->child->op != E_COM)))
        return tree;

    tree = chop(tree);
    tree->child = unary_tree(E_CAST, tree->type, tree->child);
    tree->child = simplify(tree->child);

    return tree;
}

/* we can extend the technique of uncast0() to most binary
   operators, but there are some details to worry about. */

static struct tree *bincast0(struct tree *tree)
{
    if (!NARROWING_CAST(tree) || !DISCRETE_TYPE(tree->type))
        return tree;

    switch (tree->child->op)
    {
    case E_ADD:
    case E_SUB:
    case E_MUL:
    case E_SHL:
    case E_AND:
    case E_OR:
    case E_XOR:

        /* here we can take the same tack as uncast0(), and blindly downcast
           the operands. this may seem to lead to excessive downcasts, but
           remember that they are no-ops in the back end- mere copies which
           will coalesce away. so we can't lose. */

        tree = chop(tree);
        tree->left = unary_tree(E_CAST, tree->type, tree->left);
        tree->left = simplify(tree->left);

        /* the shift operators are asymmetric; the type of
           the right operand is unrelated to the result ... */

        if (tree->op != E_SHL) {
            tree->right = unary_tree(E_CAST, tree->type, tree->right);
            tree->right = simplify(tree->right);
        }

        break;

    case E_SHR:

        /* with right shifts, we can avoid upcasting the operand if the
           underlying type of the shifted operand is simpatico with the
           desired result type, but we must preserve the underlying type
           (rather than blindly casting it) because signedness matters. */

        if (WIDENING_CAST(tree->child->left)
          && simpatico(tree->type, tree->child->left->child->type))
        {
            tree = chop(tree);                  /* kill tree downcast */
            tree->left = tree->left->child;     /* elide widening cast */
        }

        break;

    case E_DIV:
    case E_MOD:

        /* the rules for division/modulo are essentially the same as
           for right shift above, except that we have two operands to
           worry about, and potentially a constant on either side. as
           long as the constant is in range of the smaller underlying
           type, it qualifies. relcast0() is in a similar situation. */

        {
            struct tnode *type = underlying(tree->child->left,
                                            tree->child->right);

            if (type && simpatico(type, tree->type))
            {
                tree = chop(tree);
                tree->left = unary_tree(E_CAST, type, tree->left);
                tree->right = unary_tree(E_CAST, type, tree->right);
                tree->left = simplify(tree->left);
                tree->right = simplify(tree->right);
            }
        }

        break;

    }

    return tree;
}

/* since compound assignments are binary operations with
   an implied cast to the type assigned, similar logic as
   that applied in bincast0() can be applied to them. */

static struct tree *asgcast0(struct tree *tree)
{
    if (!BINARY_TREE(tree)
      || !DISCRETE_TYPE(tree->left->type)       /* steer well clear */
      || !DISCRETE_TYPE(tree->right->type))     /* of floating point */
        return tree;

    switch (tree->op)
    {
    case E_ADDASG:
    case E_SUBASG:
    case E_MULASG:

        /* always correct to do add/sub/mul in type of lhs */

        if (!simpatico(tree->left->type, tree->right->type))
            goto rewrite;

        break;

    case E_DIVASG:
    case E_MODASG:

        /* if the rhs is a constant which can be represented
           in the type of the lhs, then we can rewrite */

        if (PURE_CON_TREE(tree->right) &&
          con_in_range(TYPE_BASE(tree->left->type), &tree->right->con))
            goto rewrite;

        /* if the rhs is a widening cast from the exact same
           underlying type as the lhs, then we can rewrite */

        if (WIDENING_CAST(tree->right) && (TYPE_BASE(tree->left->type)
                                    == TYPE_BASE(tree->right->child->type)))
            goto rewrite;

        break;
    }

    return tree;

rewrite:
    tree->right = unary_tree(E_CAST, tree->left->type, tree->right);
    tree->right = simplify(tree->right);
    return tree;
}

/* when comparing values with the same type, there is no need to promote them.
   if one operand is constant, the same thing applies when the constant is in
   range of the other's type- if it isn't, then the comparison is bogus, and
   could be resolved at compile time, and should probably draw a warning. we
   currently opt to leave such trees alone, which is safe. rainy day. */

static struct tree *relcast0(struct tree *tree)
{
    switch (tree->op)
    {
    case E_EQ:
    case E_NEQ:
    case E_GT:
    case E_GTEQ:
    case E_LTEQ:
    case E_LT:
        {
            struct tnode *type = underlying(tree->left, tree->right);

            if (type) {
                tree->left = unary_tree(E_CAST, type, tree->left);
                tree->right = unary_tree(E_CAST, type, tree->right);
                tree->left = simplify(tree->left);
                tree->right = simplify(tree->right);
            }
        }
    }

    return tree;
}

/* if we're comparing a bitfield against a constant value,
   we don't need to extract the field by double-shifting,
   we can instead mask the field in place and compare that
   against an adjusted (shifted) constant. */

static struct tree *fieldcmp0(struct tree *tree)
{
    int width, nwidth, lsb;
    struct tree *field;
    struct tree *con;
    struct tree *mask;
    long t;
    long i;

    if ((tree->op != E_EQ) && (tree->op != E_NEQ))
        return tree;

    /* fold0() has put any constant on the right
       and the field (if present) on the left. */

    if (!FIELD_TREE(tree->left)) return tree;
    if (!PURE_CON_TREE(tree->right)) return tree;

    /* ok, we've got a constant on the right
       and a field fetch on the left. */

    con = tree->right;
    field = tree->left->child;
    t = DEREF(field->type)->t;
    width = T_GET_WIDTH(t);
    lsb = T_GET_LSB(t);
    nwidth = BITS_PER_LONG - width;

    /* if the bit field extends into the high bits of
       a quadword, we're best off with the original
       sequence, rather than a huge constant */

    if ((BIT_MASK(width) << lsb) & 0xFFFFFFFF00000000)
        return tree;

    /* check to see if the constant is representable in the
       field. if not, we should probably fold the comparison
       accordingly and/or issue a warning. (we do neither.) */

    i = con->con.i;
    i &= BIT_MASK(width);
    i <<= nwidth;
    i = (t & T_SIGNED) ? (i >> nwidth)                      /* arith shift */
                       : ((unsigned long) i) >> nwidth;     /* logic shift */

    if (i != con->con.i) return tree;

    /* all systems go. 1. adjust the constant
       so it will match the unshifted field */

    con->con.i &= BIT_MASK(width);
    con->con.i <<= lsb;

    /* 2. mask the E_FETCHed field before comparison */

    mask = I_TREE(tree->left->type, BIT_MASK(width) << lsb);
    tree->left = binary_tree(E_AND, tree->left->type, tree->left, mask);

    /* 3. strip the E_FETCH child of its field status */

    field->type = PTR(unfieldify(DEREF(field->type)));

    return tree;
}

/* if we are comparing two fields which have the same exact
   type and position against each other, mask the fields in
   place and compare them that way. */

static struct tree *fieldcmp1(struct tree *tree)
{
    struct tree *left_field, *right_field;
    struct tree *left_mask, *right_mask;
    long mask, t;
    int width, lsb;

    if ((tree->op != E_EQ) && (tree->op != E_NEQ))
        return tree;

    if (!FIELD_TREE(tree->left) || !FIELD_TREE(tree->right))
        return tree;

    /* equality comparison for two fields.
       let's see if they're the same fields. */

    left_field = tree->left->child;
    right_field = tree->right->child;
    t = T_UNQUAL(DEREF(left_field->type)->t);

    if (T_UNQUAL(DEREF(right_field->type)->t) != t)
        return tree;

    /* indeed they are, modulo qualifiers. as in fieldcmp0()
       bail if the resulting mask would be a huge constant. */

    width = T_GET_WIDTH(t);
    lsb = T_GET_LSB(t);
    mask = BIT_MASK(width) << lsb;

    if (mask & 0xFFFFFFFF00000000L)
        return tree;

    /* now, instead of retrieving fields, just retrieve the words,
       but insert a mask between each operand and the equality op. */

    left_mask = I_TREE(tree->left->type, mask);

    tree->left = binary_tree(E_AND, tree->left->type,
                                    tree->left, left_mask);

    right_mask = I_TREE(tree->right->type, mask);

    tree->right = binary_tree(E_AND, tree->right->type,
                                     tree->right, right_mask);

    left_field->type = PTR(unfieldify(DEREF(left_field->type)));
    right_field->type = left_field->type;

    return tree;
}

/* there is no need to extract a field if we're simply testing some
   of its bits, we can just test them in place. so look for fields
   which are masked and compared for equality with 0. replace these
   with [adjusted] masks directly against the field. */

static struct tree *fieldmask0(struct tree *tree)
{
    struct tree *and_tree;
    struct tree *mask_tree;
    struct tree *field_tree;
    int width, lsb;
    long t, mask;

    if ((tree->op != E_EQ) && (tree->op != E_NEQ))
        return tree;

    /* one of the sides must be (pure) zero.
       if it's there, put it on the right. */

    if (zero_tree(tree->left)) COMMUTE_TREE(tree);
    if (!zero_tree(tree->right)) return tree;

    /* the left side now must be E_AND -> and_tree */

    and_tree = tree->left;
    if (and_tree->op != E_AND) return tree;

    /* and it must be a mask of a pure constant
       (which we put on its right) -> mask_tree
       and a field (on its left) -> field_tree */

    if (PURE_CON_TREE(and_tree->left)) COMMUTE_TREE(tree);
    if (!PURE_CON_TREE(and_tree->right)) return tree;
    if (!FIELD_TREE(and_tree->left)) return tree;

    mask_tree = and_tree->right;
    field_tree = and_tree->left->child;

    /* let's compute the field mask -> mask */

    t = DEREF(field_tree->type)->t;
    width = T_GET_WIDTH(t);
    lsb = T_GET_LSB(t);
    mask = BIT_MASK(width) << lsb;

    /* as with fieldcmp0/1() above, let's not make
       matters worse by introducing a huge constant */

    if (mask & 0xFFFFFFFF00000000L)
        return tree;

    /* the existing mask can't have any bits outside the
       field itself (this would need sign/zero extension) */

    if (((mask_tree->con.i << lsb) & mask) != (mask_tree->con.i << lsb))
        return tree;

    /* ok, looks good. all we need to do is shift the
       existing mask, combine the masks (intersection)
       and strip the field of its field status */

    mask_tree->con.i <<= lsb;
    mask_tree->con.i &= mask;
    field_tree->type = PTR(unfieldify(DEREF(field_tree->type)));

    return tree;
}

/* setting a bit field involves reading the host word, masking
   all the field's bits, ORing in the new field value, then
   storing host word back. when setting a bit field to all 1s,
   we do not need to zero the field first, just proceed to OR. */

struct tree *fieldset0(struct tree *tree)
{
    struct tree *field_tree;
    long t;

    /* must be an assignment of a
       pure constant to bit field */

    if (tree->op != E_ASG
      || !FIELD_TREE(tree->left)
      || !PURE_CON_TREE(tree->right)) return tree;

    /* and that constant must be
       all 1s to the field's width */

    field_tree = tree->left->child;
    t = DEREF(field_tree->type)->t;
    if (tree->right->con.i != BIT_MASK(T_GET_WIDTH(t)))
        return tree;

    /* looks good; rewrite the bitfield assignment
       as an OR-assignment to the host word. adjust
       the constant to account for field position */

    tree->op = E_ORASG;
    field_tree->type = PTR(unfieldify(DEREF(field_tree->type)));
    tree->right->con.i <<= T_GET_LSB(t);

    return tree;
}

/* order is important when simplifying, since
   the transformations are interdependent */

struct tree *simplify(struct tree *tree)
{
    WALK_TREE(tree, simplify);

    tree = indirect0(tree);
    tree = fold0(tree);
    tree = shiftmask0(tree);
    tree = unsigned0(tree);
    tree = restrun0(tree);
    tree = recast0(tree);
    tree = fpcast0(tree);
    tree = andcast0(tree);
    tree = andcast1(tree);
    tree = uncast0(tree);
    tree = bincast0(tree);
    tree = asgcast0(tree);
    tree = relcast0(tree);
    tree = fieldcmp0(tree);
    tree = fieldcmp1(tree);
    tree = fieldmask0(tree);
    tree = fieldset0(tree);

    return tree;
}

struct tree *addrof(struct tree *tree, struct tnode *type)
{
    tree = unary_tree(E_ADDROF, type, tree);
    tree = indirect0(tree);
    return tree;
}

struct tree *fold(struct tree *tree)
{
    WALK_TREE(tree, fold);

    tree = indirect0(tree);
    tree = fold0(tree);

    return tree;
}

/* rewrite all E_SYM nodes that refer to volatiles as explicit volatile
   memory references. this results in many E_FETCH/E_ADDROF pairs that
   are normally not found in trees (they are squashed by indirect0), so
   this should be called immediately before generating a tree. */

struct tree *rewrite_volatiles(struct tree *tree)
{
    if (tree->op == E_ADDROF)       /* no need to inspect if it's */
        return tree;                /* already a memory reference */

    if ((tree->op == E_SYM) && VOLATILE_TYPE(tree->sym->type)) {
        tree = addrof(tree, PTR(tree->sym->type));
        tree = unary_tree(E_FETCH, DEREF(tree->type), tree);
    } else
        WALK_TREE(tree, rewrite_volatiles);

    return tree;
}

#ifdef DEBUG

void dump_tree(struct tree *tree, int depth)
{
    static char *text[] =       /* indexed by E_TEXT() */
    {
        /*  0 */    "NONE",     "SYM",      "CON",      "FETCH",    "RFETCH",
        /*  5 */    "CALL",     "CAST",     "ADDROF",   "NEG",      "COM",
        /* 10 */    "PLUS",     "ASG",      "MULASG",   "DIVASG",   "MODASG",
        /* 15 */    "ADDASG",   "SUBASG",   "SHLASG",   "SHRASG",   "ANDASG",
        /* 20 */    "ORASG",    "XORASG",   "POST",     "DIV",      "MOD",
        /* 25 */    "MUL",      "ADD",      "SUB",      "SHR",      "SHL",
        /* 30 */    "XOR",      "AND",      "OR",       "EQ",       "NEQ",
        /* 35 */    "GT",       "GTEQ",     "LTEQ",     "LT",       "LOR",
        /* 40 */    "LAND",     "QUEST",    "COLON",    "COMMA",    "SEQ",
        /* 45 */    "BLKCPY",   "BLKSET"
    };

    int i;

    for (i = 0; i < depth * 5; ++i)
        putc(' ', stderr);

    fprintf(stderr, "%s <", text[E_TEXT(tree->op)]);
    dump_type(tree->type);
    putc('>', stderr);

    switch (tree->op)
    {
    case E_CON:     if (SIGNED_TYPE(tree->type))
                        fprintf(stderr, " %ld", tree->con.i);
                    else if (FLOATING_TYPE(tree->type))
                        fprintf(stderr, " %f", tree->con.f);
                    else
                        fprintf(stderr, " %lu", tree->con.u);

    case E_SYM:     if (tree->sym) {
                        if (tree->sym->id)
                            fprintf(stderr, " `" STRING_FMT "'",
                                            STRING_ARG(tree->sym->id));

                        fprintf(stderr, " #%d", tree->sym->num);
                    }

                    putc('\n', stderr);
                    break;

    default:        putc('\n', stderr);

                    if (UNARY_TREE(tree)) {
                        dump_tree(tree->child, depth + 1);

                        for (i = 0; i < tree->nr_args; ++i)
                            dump_tree(tree->args[i], depth + 1);
                    } else if (BINARY_TREE(tree)) {
                        dump_tree(tree->left, depth + 1);
                        dump_tree(tree->right, depth + 1);
                    }
    }
}

#endif /* DEBUG */

/* vi: set ts=4 expandtab: */
