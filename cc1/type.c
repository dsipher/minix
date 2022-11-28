/*****************************************************************************

   type.c                                                 minix c compiler

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).

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
#include "lex.h"
#include "symbol.h"
#include "string.h"
#include "type.h"

#define NR_TNODE_BUCKETS    (1 << LOG2_NR_TNODE_BUCKETS)
#define BUCKET(h)           ((h) % NR_TNODE_BUCKETS)

static struct tnode *buckets[NR_TNODE_BUCKETS];

static SLAB_DEFINE(tnode, 100);
static SLAB_DEFINE(formal, 100);

struct tnode void_type      = { T_VOID };
struct tnode char_type      = { T_CHAR };
struct tnode schar_type     = { T_SCHAR };
struct tnode uchar_type     = { T_UCHAR };
struct tnode short_type     = { T_SHORT };
struct tnode ushort_type    = { T_USHORT };
struct tnode int_type       = { T_INT };
struct tnode uint_type      = { T_UINT };
struct tnode long_type      = { T_LONG };
struct tnode ulong_type     = { T_ULONG };
struct tnode float_type     = { T_FLOAT };
struct tnode double_type    = { T_DOUBLE };
struct tnode ldouble_type   = { T_LDOUBLE };

/* this map does double duty. its primary purpose is to support map_type(),
   in the obvious way. (for that capacity, it should be re-ordered by real-
   world type frequency for efficiency; surely K_SPEC_INT should be first.)

   it is also used by seed_types() since every predefined type appears here */

static struct { int ks; struct tnode *type; } map[] =
{
    K_SPEC_VOID,                                    &void_type,
    K_SPEC_CHAR,                                    &char_type,
    K_SPEC_SIGNED | K_SPEC_CHAR,                    &schar_type,
    K_SPEC_UNSIGNED | K_SPEC_CHAR,                  &uchar_type,
    K_SPEC_SHORT,                                   &short_type,
    K_SPEC_SHORT | K_SPEC_INT,                      &short_type,
    K_SPEC_SIGNED | K_SPEC_SHORT,                   &short_type,
    K_SPEC_SIGNED | K_SPEC_SHORT | K_SPEC_INT,      &short_type,
    K_SPEC_UNSIGNED | K_SPEC_SHORT,                 &ushort_type,
    K_SPEC_UNSIGNED | K_SPEC_SHORT | K_SPEC_INT,    &ushort_type,
    K_SPEC_INT,                                     &int_type,
    K_SPEC_SIGNED,                                  &int_type,
    K_SPEC_SIGNED | K_SPEC_INT,                     &int_type,
    K_SPEC_UNSIGNED,                                &uint_type,
    K_SPEC_UNSIGNED | K_SPEC_INT,                   &uint_type,
    K_SPEC_LONG,                                    &long_type,
    K_SPEC_LONG | K_SPEC_INT,                       &long_type,
    K_SPEC_SIGNED | K_SPEC_LONG,                    &long_type,
    K_SPEC_SIGNED | K_SPEC_LONG | K_SPEC_INT,       &long_type,
    K_SPEC_UNSIGNED | K_SPEC_LONG,                  &ulong_type,
    K_SPEC_UNSIGNED | K_SPEC_LONG | K_SPEC_INT,     &ulong_type,
    K_SPEC_FLOAT,                                   &float_type,
    K_SPEC_DOUBLE,                                  &double_type,
    K_SPEC_DOUBLE | K_SPEC_LONG,                    &ldouble_type
};

struct tnode *map_type(int ks)
{
    int i;

    for (i = 0; i < ARRAY_SIZE(map); ++i)
        if (map[i].ks == ks)
            return map[i].type;

    error(ERROR, 0, "invalid type specification");
}

/* put a tnode into the forest */

#define PUT(tn)                                                             \
    do {                                                                    \
        struct tnode *_tn = (tn);                                           \
        int _b = BUCKET(_tn->hash);                                         \
        _tn->link = buckets[_b];                                            \
        buckets[_b] = _tn;                                                  \
    } while (0)


/* using this, creating a list of formals is an
   O(n^2) operation. call the algorithm police.

   note: formals are stripped of top-level qualifiers.
   they're ignored outside of function definitions */

void new_formal(struct tnode *tn, struct tnode *type)
{
    struct formal **ff, *f;

    f = SLAB_ALLOC(formal);
    f->type = unqualify(type);
    f->next = 0;

    for (ff = &tn->formals; *ff; ff = &(*ff)->next) ;
    *ff = f;
}

struct tnode *new_tnode(long t, long u, struct tnode *next)
{
    struct formal *f;
    struct tnode *tn;

    tn = SLAB_ALLOC(tnode);
    tn->t = t;
    tn->u = u;
    tn->next = next;

    if ((t & T_FUNC) && u) {
        tn->u = 0;

        for (f = (struct formal *) u; f; f = f->next)
            new_formal(tn, f->type);
    }

    return tn;
}

/* compute the hash for the described tnode. this is complicated and slow as
   far as hash functions go, but it should pay for itself with a half-decent
   distribution across buckets. really need to test and tune empirically.

   when tuning remember seed_types() requires that seed types not hash to 0 */

static unsigned long tnode_hash(long t, long u, struct tnode *next)
{
    unsigned long hash;
    struct formal *f;

    /* first, we convert the base bit to a value between 1..17 and
       then shift it to spread it out to (4, 8, .. 68), then apply
       the qualifiers fill in the gaps. the resulting 7-bit value
       (4..71) is spread across all 64 bits by the multiplication. */

    hash = (CTZ(T_BASE(t)) + 1) << 2;
    if (t & T_CONST) hash += 2;
    if (t & T_VOLATILE) hash += 1;
    hash *= 0x810204080204081L;

    if (t & T_FIELD) hash = (hash ^ 0xFFFFFFFFFFFFFFFFL) +
                            (T_GET_WIDTH(t) + T_GET_LSB(t));

    switch (T_BASE(t))
    {
    case T_ARRAY:   hash ^= u; break;
    case T_STRUN:   hash ^= (u >> 5); break;

    case T_FUNC:    for (f = (struct formal *) u; f; f = f->next)
                        hash ^= f->type->hash;
    }

    hash ^= ((long) next) >> 5;
    return hash;
}

/* find a tnode in the forest hash. if it does not exist, return 0. */

static struct tnode *tnode_find(long t, long u, struct tnode *next,
                                unsigned long hash)
{
    struct tnode *tn;
    struct formal *old_f, *new_f;
    int b = BUCKET(hash);

    for (tn = buckets[b]; tn; tn = tn->link) {
        if ((tn->hash != hash) || (tn->t != t) || (tn->next != next))
            continue;

        if (tn->t & T_FUNC) {
            for (old_f = tn->formals, new_f = (struct formal *) u;
              old_f && new_f && (old_f->type == new_f->type);
              old_f = old_f->next, new_f = new_f->next) ;

            if (old_f || new_f) continue;   /* both 0 iff formals match */
        } else
            if (tn->u != u) continue;

        return tn;  /* match */
    }

    return 0;
}

/* it's mentioned in the header, but bears repeating here: do
   NOT call this with t == T_FUNC. any formals u will leak. */

struct tnode *get_tnode(long t, long u, struct tnode *next)
{
    unsigned long hash;
    struct tnode *tn;

    hash = tnode_hash(t, u, next);
    tn = tnode_find(t, u, next, hash);

    if (tn == 0) {
        tn = new_tnode(t, u, next);
        tn->hash = hash;
        PUT(tn);
    }

    return tn;
}

struct tnode *graft(struct tnode *prefix, struct tnode *type)
{
    struct tnode *tn, *tmp;

    while (tn = prefix) {
        prefix = prefix->next;
        tn->next = type;
        tn->hash = tnode_hash(tn->t, tn->u, tn->next);
        tmp = tnode_find(tn->t, tn->u, tn->next, tn->hash);

        if (tmp == 0) {
            PUT(tn);
            type = tn;
        } else {
            /* discard the prefix tnode (including its formals, if any).
               this is the only place tnodes or formals are ever freed. */

            struct formal *f, *tmp_f;

            if (tn->t & T_FUNC) {
                for (f = tn->formals; f; f = tmp_f) {
                    tmp_f = f->next;
                    SLAB_FREE(formal, f);
                }
            }

            SLAB_FREE(tnode, tn);
            type = tmp;
        }
    }

    return type;
}

/* flesh out the predefined tnodes and put them in the type forest. we
   rely on the facts that (a) every predefined node appears in map[] at
   least once and (b) no predefined node will have a 0 hash value. */

static int nr_static_tnodes;        /* statistic, see dump_forest() */

void seed_types(void)
{
    struct tnode *tn;
    int i;

    for (i = 0; i < ARRAY_SIZE(map); ++i) {
        tn = map[i].type;

        if (tn->hash == 0) {
            tn->hash = tnode_hash(tn->t, 0, 0);
            ++nr_static_tnodes;
            PUT(tn);
        }
    }
}

/* if qualifying an array type, we must apply the qualifier to the elements
   of the array, not the array itself. attempting to qualify a function type
   is undefined behavior: we prohibit it and error out. see C89 6.5.3. */

struct tnode *qualify(struct tnode *type, long quals)
{
    struct tnode *prefix;

    /* first, check to see if the type is already
       carries quals, to save ourselves busywork */

    prefix = type;
    while (ARRAY_TYPE(prefix)) prefix = prefix->next;
    if ((type->t & quals) == quals) return type;

    prefix = 0;

    while (ARRAY_TYPE(type)) {
        prefix = new_tnode(T_ARRAY, type->nelem, prefix);
        type = type->next;
    }

    if (FUNC_TYPE(type)) error(ERROR, 0, "can't qualify function types");

    prefix = new_tnode(type->t | quals, type->u, prefix);
    return graft(prefix, type->next);
}

/* we do not try to unqualify anything that isn't qualified. this is not
   just a time saver (though it is that), it also keeps us from invoking
   get_tnode() on a T_FUNC (which is never qualified), which is a no-no. */

struct tnode *unqualify(struct tnode *type)
{
    if (TYPE_QUALS(type))
        type = get_tnode(T_UNQUAL(type->t), type->u, type->next);

    return type;
}

/* returns true if the two tnodes are, at a first
   approximation, compatible. this means they are
   identically qualified, and:

        they are both terminal nodes of same type, OR

        they are both pointers, OR

        they are both arrays with the same dimension, or at least
        one of them is unbounded, OR

        they are both functions which agree in 'variadicity' and have
        the same number of arguments (or one of them is old-style) */

static int tnode_compat(struct tnode *tn1, struct tnode *tn2)
{
    struct formal *f1, *f2;

    if (T_QUALS(tn1->t) != T_QUALS(tn2->t)) return 0;
    if (T_BASE(tn1->t) != T_BASE(tn2->t)) return 0;

    switch (T_BASE(tn1->t))
    {
    case T_STRUN:   return (tn1->tag == tn2->tag);

    case T_ARRAY:   if (tn1->nelem && tn2->nelem)
                        return tn1->nelem == tn2->nelem;

                    return 1;  /* at least one is unbounded */

    case T_FUNC:    if (VARIADIC_FUNC(tn1) != VARIADIC_FUNC(tn2))
                        return 0;  /* must both be variadic or not */

                    if (OLD_STYLE_FUNC(tn1) || OLD_STYLE_FUNC(tn2))
                        return 1;  /* at least one is old style */

                    for (f1 = tn1->formals, f2 = tn2->formals;
                         f1 && f2; f1 = f1->next, f2 = f2->next) ;

                    return (f1 == f2);  /* true iff same formal count */

    default:        return 1;
    }
}

/* in most cases, this will be very fast, owing to the structure of
   the tnode forest: type1 and type2 are identical iff type1 == type2.
   unfortunately, less-than-identical types might still be compatible,
   so we may still have to traverse the types. tnode_compat() does most
   of the work for us, but we do need to check prototyped arguments for
   compatibility -- the need for this should be exceedingly rare. */

int compat(struct tnode *type1, struct tnode *type2)
{
    struct formal *f1, *f2;
    struct tnode *tn1, *tn2;

    for (tn1 = type1, tn2 = type2;
         tn1 && tn2 && (tn1 != tn2) && tnode_compat(tn1, tn2);
         tn1 = tn1->next, tn2 = tn2->next)
    {
        if (FUNC_TYPE(tn1) && !OLD_STYLE_FUNC(tn1) && !OLD_STYLE_FUNC(tn2))
            for (f1 = tn1->formals, f2 = tn2->formals; f1 && f2;
              f1 = f1->next, f2 = f2->next)
                if (compat(f1->type, f2->type) == 0)
                    return 0;
    }

    return (tn1 == tn2);
}

/* see C89 6.1.2.6 for the rules of type composition. worst case,
   this function does a lot of recursion, allocates a lot of new
   type nodes, and takes a 'long time'. that should be rare; in
   most cases, this function does little to nothing.

   composition only occurs in two places: global declarations and
   the ternary operator. in the former case, there is a symbol to
   reference, and the caller provides it so we can report errors.
   in the latter, there is no symbol, but the types have already
   been checked for compatibility and no error will ever occur */

struct tnode *compose(struct tnode *type1, struct tnode *type2,
                      struct symbol *sym)
{
    struct tnode *prefix = 0;
    struct tnode *tn1, *tn2;
    struct formal *f1, *f2;

    for (tn1 = type1, tn2 = type2;
         tn1 && tn2 && (tn1 != tn2) && tnode_compat(tn1, tn2);
         tn1 = tn1->next, tn2 = tn2->next)
    {
        if (tn1->t & T_ARRAY)
            prefix = new_tnode(T_ARRAY, MAX(tn1->nelem, tn2->nelem), prefix);
        else if (tn1->t & T_FUNC) {
            if (OLD_STYLE_FUNC(tn1))
                prefix = new_tnode(tn2->t, tn2->u, prefix);
            else if (OLD_STYLE_FUNC(tn2))
                prefix = new_tnode(tn1->t, tn1->u, prefix);
            else {
                prefix = new_tnode(tn1->t, 0, prefix);

                for (f1 = tn1->formals, f2 = tn2->formals;
                  f1 && f2; f1 = f1->next, f2 = f2->next)
                    new_formal(prefix, compose(f1->type, f2->type, sym));
            }
        } else
            prefix = new_tnode(tn1->t, tn1->u, prefix);
    }

    if (tn1 != tn2)
        error(ERROR, sym->id, "conflicting types %L", sym);

    return graft(prefix, tn1);
}

/* per C89 6.7.1:

   1. array of type -> pointer to type
   2. function -> pointer to function */

struct tnode *formal_type(struct tnode *type)
{
    if (ARRAY_TYPE(type))
        type = PTR(type->next);
    else if (FUNC_TYPE(type))
        type = PTR(type);

    return type;
}

int t_size(long t)
{
    if (t & T_SHORTS) return 2;
    if (t & (T_INTS | T_FLOAT)) return 4;
    if (t & (T_LONGS | T_DOUBLE | T_LDOUBLE | T_PTR)) return 8;

    return 1;   /* T_CHARs */
}

int t_log2_size(long t)
{
    if (t & T_SHORTS) return 1;
    if (t & (T_INTS | T_FLOAT)) return 2;
    if (t & (T_LONGS | T_DOUBLE | T_LDOUBLE | T_PTR)) return 3;

    return 0;   /* T_CHARs */
}

int size_of(struct tnode *type, struct string *id)
{
    long size = 1;

    while (type) {
        switch (T_BASE(type->t))
        {
        case T_ARRAY:
            if (type->nelem > 0)
                size *= type->nelem;
            else
                error(ERROR, id, "incomplete array type");

            break;

        case T_STRUN:
            if (DEFINED_SYMBOL(type->tag))
                size *= type->tag->size;
            else
                error(ERROR, id, "%T is incomplete", type->tag);

            break;

        case T_VOID:    error(ERROR, id, "illegal use of void type");
        case T_FUNC:    error(ERROR, id, "illegal use of function type");

        default:        size *= t_size(type->t); break;
        }

        if (size > MAX_TYPE_BYTES) error(SORRY, id, "type too large");
        if (type->t & T_PTR) break;
        type = type->next;
    }

    return size;
}

/* we need to know the alignment of a type in two situations:

    1. when allocating storage
    2. when constructing a block trees (E_BLKCPY, etc.)

   in the first situation, an incomplete type is not permitted, but
   we'll always need to know the size as well: leave it to size_of()
   to generate an error. in the second situation, we are asking the
   alignment of objects pointed to, so incomplete types are allowed.
   if the alignment isn't known, we must assume worst-case (byte). */

int align_of(struct tnode *type)
{
    while (ARRAY_TYPE(type))
        type = type->next;

    switch (TYPE_BASE(type))
    {
    case T_STRUN:   if (DEFINED_SYMBOL(STRUN_TAG(type)))
                        return type->tag->align;

    case T_FUNC:
    case T_VOID:    return 1;   /* worst case */

    default:        return t_size(type->t);
    }
}

#define SIMPATICO0(type1, type2, OP)                                        \
    do {                                                                    \
        if (SCALAR_TYPE(type1)                                              \
          && SCALAR_TYPE(type2)                                             \
          && SAME_CAST_CLASS(type1, type2)                                  \
          && (t_size(TYPE_BASE(type1)) OP t_size(TYPE_BASE(type2))))        \
            return 1;                                                       \
        else                                                                \
            return 0;                                                       \
    } while (0)

int simpatico(struct tnode *type1, struct tnode *type2)
{
    SIMPATICO0(type1, type2, ==);
}

int narrower(struct tnode *dst, struct tnode *src)
{
    SIMPATICO0(dst, src, <);
}

int wider(struct tnode *dst, struct tnode *src)
{
    SIMPATICO0(dst, src, >);
}

struct tnode *fieldify(struct tnode *type, int width, int lsb)
{
    long t;

    t = T_BASE(type->t);            /* clean up t, since T_SET_*() */
    t |= T_QUALS(type->t);          /* do not clear the fields */
    t |= T_FIELD;
    T_SET_WIDTH(t, width);
    T_SET_LSB(t, lsb);

    return get_tnode(t, 0, 0);
}

struct tnode *unfieldify(struct tnode *type)
{
    long t;

    if (type->t & T_FIELD) {
        t = T_BASE(type->t);
        t |= T_QUALS(type->t);
        type = get_tnode(t, 0, 0);
    }

    return type;
}

/* if t is an integral type, return it modified to
   its simpatico unsigned equivalent (if necessary) */

long t_unsigned(long t)
{
    long tu = t & ~T_BASE_MASK;

    switch (T_BASE(t))
    {
    case T_CHAR:
    case T_SCHAR:   return tu | T_UCHAR;

    case T_SHORT:   return tu | T_USHORT;
    case T_INT:     return tu | T_UINT;
    case T_LONG:    return tu | T_ULONG;
    }

    return t;
}

/* elements of an array must be objects (C89 6.1.2.5) so they can't be:

        functions or voids
        incomplete arrays
        incomplete struct/union types

   nor can they be structs with flexible array members (C99 6.7.2.1)

   functions can't return arrays or functions (C89 6.5.4.3)

   plain void is a valid type only in limited circumstances.
   we reject it unless the caller specifically OKs it. */

void validate(struct tnode *type, struct string *id, int void_ok)
{
    struct tnode *next;

    if (VOID_TYPE(type) && !void_ok)
        error(ERROR, id, "illegal use of void type");

    for (; type; type = next) {
        next = type->next;

        if (ARRAY_TYPE(type)) {
            /* all of these cases are really ways of saying the elements
               of an array must have a size, and that size must be fixed
               and known. in that sense, we're overlapping size_of() */

            if (UNBOUNDED_ARRAY_TYPE(next))
                error(ERROR, id, "invalid array specification");

            if (FUNC_TYPE(next)) error(ERROR, id, "array of function");
            if (VOID_TYPE(next)) error(ERROR, id, "array of void");

            if (STRUN_TYPE(next)) {
                if (!DEFINED_SYMBOL(next->tag))
                    error(ERROR, id, "array of incomplete %T", next->tag);

                if (FLEXIBLE_STRUCT_SYMBOL(next->tag))
                    error(ERROR, id, "array of flexible %T", next->tag);
            }
        }

        if (FUNC_TYPE(type) && (ARRAY_TYPE(next) || FUNC_TYPE(next)))
            error(ERROR, id, "functions can't return %s", ARRAY_TYPE(next)
                                                            ? "arrays"
                                                            : "functions");
    }
}

#ifdef DEBUG

/* helper for dump_type() and dump_forest().
   returns the number of formals in the tnode.
   verbose == 1 when dumping the forest. */

static int dump_tnode(struct tnode *tn, int verbose)
{
    static struct { long t; char *text; } bits[] =
    {
        T_VOLATILE,     "volatile ",        T_CONST,        "const ",
        T_VOID,         "void",             T_CHAR,         "char",
        T_UCHAR,        "unsigned char",    T_SCHAR,        "signed char",
        T_SHORT,        "short",            T_USHORT,       "unsigned short",
        T_INT,          "int",              T_UINT,         "unsigned int",
        T_LONG,         "long",             T_ULONG,        "unsigned long",
        T_FLOAT,        "float",            T_DOUBLE,       "double",
        T_LDOUBLE,      "long double",      T_PTR,          "ptr to",
        T_FUNC,         "function",         T_ARRAY,        "array"
    };

    struct formal *f;
    int nr_formals = 0;
    int i;

    if (verbose) fprintf(stderr, "(%p hash %016lx) ", tn, tn->hash);

    for (i = 0; i < ARRAY_SIZE(bits); ++i)
        if (tn->t & bits[i].t)
            fputs(bits[i].text, stderr);

    if (FIELD_TYPE(tn))
        fprintf(stderr, "<%d:%d>", T_GET_WIDTH(tn->t), T_GET_LSB(tn->t));

    if (ARRAY_TYPE(tn)) {
        putc('[', stderr);

        if (tn->nelem)
            fprintf(stderr, "%d", tn->nelem);

        putc(']', stderr);
    }

    if (STRUN_TYPE(tn)) {
        fputs((tn->tag->s & S_STRUCT) ? "struct" : "union", stderr);

        if (tn->tag->id)
            fprintf(stderr, " `" STRING_FMT "'", STRING_ARG(tn->tag->id));

        fprintf(stderr, " (%p)", tn->tag);
    }

    if (FUNC_TYPE(tn)) {
        putc('(', stderr);

        if (!OLD_STYLE_FUNC(tn) && !tn->formals)
            fputs("void", stderr);

        for (f = tn->formals; f; f = f->next) {
            if (f != tn->formals) putc(',', stderr);
            dump_type(f->type);
            ++nr_formals;
        }

        if (VARIADIC_FUNC(tn)) fputs(",...", stderr);
        putc(')', stderr);
    }

    if (verbose) {
        if (tn->next) fprintf(stderr, " (-> %p)", tn->next);
        putc('\n', stderr);
    }

    return nr_formals;
}

void dump_type(struct tnode *type)
{
    while (type) {
        dump_tnode(type, 0);
        type = type->next;
        if (type) putc(' ', stderr);
    }
}

void dump_forest(void)
{
    struct tnode *tn;
    int total = 0;
    int total_formals = 0;
    int b;

    fputs("===== TNODE FOREST =====\n\n", stderr);

    for (b = 0; b < NR_TNODE_BUCKETS; ++b) {
        if (buckets[b]) {
            fprintf(stderr, "BUCKET %d\n", b);

            for (tn = buckets[b]; tn; tn = tn->link, ++total)
                total_formals += dump_tnode(tn, 1);
        }
    }

    fprintf(stderr, "\n%d total / %d dynamic tnodes in use",
                    total, total - nr_static_tnodes);

    fprintf(stderr, " (" SLAB_STATS_FMT ")\n", SLAB_STATS_ARG(tnode));
    fprintf(stderr, "%d formals in use", total_formals);
    fprintf(stderr, " (" SLAB_STATS_FMT ")\n", SLAB_STATS_ARG(formal));
}

#endif /* DEBUG */

/* vi: set ts=4 expandtab: */
