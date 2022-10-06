/*****************************************************************************

   init.c                                              jewel/os c compiler

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

#include "cc1.h"
#include "type.h"
#include "lex.h"
#include "expr.h"
#include "tree.h"
#include "heap.h"
#include "string.h"
#include "symbol.h"
#include "block.h"
#include "gen.h"
#include "init.h"

static struct tnode *init(struct tnode *type, int flags, int offset);

/* we parse static and automatic initializers with the same code.

   static initializers are processed immediately and output directly. this
   is the classic approach. it's fast and avoids building potentially huge
   intermediate data structures for large initialized tables. it's limited
   though: if we ever want to implement designated initializers, a la C99,
   with no ordering limitations, this strategy will not work. (not likely)

   automatic initializers are transformed into a sequence of assignment
   statements in a tree which is then generated like any other expression.

   initializers may nest because of statement expressions, e.g.,

                    int a = ({ int b = 32; b + 1; });

   so we must track 'global' initializer state in a stack. */

struct init_state
{
    struct symbol *sym;         /* symbol being initialized (0 == static) */
    struct tree *tree;          /* the assignment tree */

    struct init_state *prev;    /* stack link */
};

static struct init_state *state;

static void push(struct symbol *sym)
{
    struct init_state *new;

    new = arena_alloc(&stmt_arena, sizeof(struct init_state), 0);
    new->sym = sym;
    new->tree = 0;
    new->prev = state;
    state = new;
}

#define POP() do { state = state->prev; } while (0)

/* output header for static symbol data. */

static void header(struct symbol *sym)
{
    int align;

    seg(CONST_TYPE(sym->type) ? SEG_TEXT : SEG_DATA);
    align = align_of(sym->type);
    if (align > 1) out(".align %d\n", align);
    out("%g:\n", sym);
}

/* return a pointer to the an object of the specified
   type that lives at offset in the state->sym. (used
   only when initializing automatic aggregates.) */

static struct tree *ref(struct tnode *type, int offset)
{
    struct tree *tree;

    tree = sym_tree(state->sym);
    tree = unary_tree(E_ADDROF, PTR(type), tree);

    if (offset) tree = binary_tree(E_ADD, PTR(type), tree,
                                   I_TREE(&long_type, offset));

    return tree;
}

/* when looking for an aggregate initializer (for a struct or union), we
   don't know if an expression initializes the entire aggregate or just
   its first member until we know its type, so we need lookahead. */

static struct tree *pushback;

static struct tree *next(void)
{
    struct tree *tree;

    if (pushback) {
        tree = pushback;
        pushback = 0;
    } else
        if (state->sym)
            tree = assignment();
        else
            tree = static_expr();

    return tree;
}

/* output a bitfield value n bits wide. we keep a little (byte)
   buffer and output whole bytes as they form. this is slow. */

static void out_bits(long i, int n)
{
    static char buf;
    static int pos;

    while (n--) {
        buf >>= 1;

        if (i & 1)
            buf |= 0x80;
        else
            buf &= 0x7F;

        i >>= 1;
        ++pos;

        if ((pos % BITS_PER_BYTE) == 0)
            out("\t.byte %d\n", buf & 0xFF);
    }
}

/* tree is an E_CON; output its value with
   an appropriate assembler pseudo-op. */

void out_word(long t, union con con, struct symbol *sym)
{
    if (t & T_FLOATING) {
        switch (T_BASE(t))
        {
        case T_FLOAT:       {
                                float f = con.f;
                                out("\t.int %x", *(int *)&f);
#ifdef DEBUG
                                out(" # %f", f);
#endif /* DEBUG */
                                OUTC('\n');
                                break;
                            }

        case T_DOUBLE:
        case T_LDOUBLE:     out("\t.quad %X", con.i);
#ifdef DEBUG
                            out(" # %f", con.f);
#endif /* DEBUG */
                            OUTC('\n');
                            break;
        }
    } else {
        switch (T_BASE(t))
        {
        case T_CHAR:
        case T_SCHAR:
        case T_UCHAR:       OUTS("\t.byte"); break;

        case T_SHORT:
        case T_USHORT:      OUTS("\t.short"); break;

        case T_INT:
        case T_UINT:        OUTS("\t.int"); break;

        case T_PTR:
        case T_LONG:
        case T_ULONG:       OUTS("\t.quad"); break;
        }

        out(" %G\n", sym, con.i);
    }
}

/* fill the next n bits with zeros. this is
   a no-op when initializing an automatic */

static void init_pad(int n)
{
    if (state->sym == 0) {
        if (n % BITS_PER_BYTE)
            out_bits(0, n % BITS_PER_BYTE);

        if (n / BITS_PER_BYTE)
            out("\t.fill %d, 1, 0\n", n / BITS_PER_BYTE);
    }
}

/* we have a scalar value to assign to an object of the specified type, so
   do it. first, ensure the value is appropriate to the type. then, if it's
   an automatic variable, concoct an assignment expression to state->sym at
   offset and add it to state->tree. otherwise, output the value directly. */

#define INIT_OUTER      0x00000001      /* outermost call to init() */
#define INIT_BRACED     0x00000002      /* initializer has braces {} */

static void init_value(struct tnode *type, int offset,
                       struct tree *value, int flags)
{
    struct tree *tree;

    if (state->sym) {
        if (!SCALAR_TYPE(state->sym->type)) {
            tree = ref(type, offset);
            tree = unary_tree(E_FETCH, type, tree);
            tree->type = unfieldify(type);
        } else
            tree = sym_tree(state->sym);

        tree = build_tree(K_INIT, tree, value);
        state->tree = seq_tree(state->tree, tree);
    } else {
        value = fake(value, type, K_INIT);  /* fake() may introduce new */
        value = fold(value);                /* casts, so get rid of them */

        if (FIELD_TYPE(type)) {
            if (!PURE_CON_TREE(value))
                error(ERROR, 0, "invalid bit-field initializer");

            out_bits(value->con.i, FIELD_WIDTH(type));
        } else
            out_word(value->type->t, value->con, value->sym);
    }
}

/* initialize a char[] from string literal. the current
   token is a K_STRLIT. returns the size of the array. */

static int init_strlit(struct tnode *type, int offset, int flags)
{
    int nelem;

    if (UNBOUNDED_ARRAY_TYPE(type))
        nelem = token.s->len + 1;
    else {
        nelem = type->nelem;

        if (nelem < token.s->len)
            error(ERROR, 0, "string literal exceeds length of array");
    }

    if (state->sym) {
        struct symbol *sym;
        struct tree *tree;
        int n;

        n = MIN(nelem, token.s->len);
        sym = literal(token.s);
        tree = sym_tree(sym);
        tree = unary_tree(E_ADDROF, PTR(tree->type), tree);

        tree = blk_tree(E_BLKCPY, ref(type, offset),
                        tree, I_TREE(&ulong_type, n));

        state->tree = seq_tree(state->tree, tree);
    } else
        out_literal(token.s, nelem);

    lex();
    return nelem;
}

/* initialize an array object. returns the size (nelem) of the array. */

static int init_array(struct tnode *type, int offset, int flags)
{
    struct tnode *elem_type = DEREF(type);
    int elem_size = size_of(elem_type, 0);
    int nelem = 0;

    do {
        if (!UNBOUNDED_ARRAY_TYPE(type) && (nelem == type->nelem))
            error(ERROR, 0, "too many initializers for array");

        init(elem_type, 0, offset + (nelem * elem_size));
        ++nelem;

        if (!(flags & INIT_BRACED) && (nelem == type->nelem))
            break;
    } while (comma());

    if (!UNBOUNDED_ARRAY_TYPE(type))
        init_pad((type->nelem - nelem) * elem_size * BITS_PER_BYTE);

    return nelem;
}

/* initialize a struct or union. made messy because of static bitfields.
   remember: members marked S_SKIP are excluded during initialization. */

#define SKIP(m)                                                             \
    do {                                                                    \
        while ((m) && ((m)->s & S_SKIP))                                    \
            (m) = (m)->link;                                                \
    } while (0)

static void init_strun(struct tnode *type, int offset, int flags)
{
    struct symbol *tag;
    struct symbol *member;
    int offset_bits = 0;
    int pad_bits;

    tag = STRUN_TAG(type);
    member = tag->chain;
    SKIP(member);

    if (!DEFINED_SYMBOL(tag))
        error(ERROR, 0, "can't initialize incomplete %T", tag);

    do {
        if (member == 0)
            error(ERROR, 0, "too many initializers for %T", tag);

        pad_bits = member->offset * BITS_PER_BYTE - offset_bits;
        if (FIELD_TYPE(member->type)) pad_bits += FIELD_LSB(member->type);
        init_pad(pad_bits);
        offset_bits += pad_bits;
        init(member->type, 0, offset + member->offset);

        if (FIELD_TYPE(member->type))
            offset_bits += FIELD_WIDTH(member->type);
        else
            offset_bits += size_of(member->type, 0) * BITS_PER_BYTE;

        member = member->link;
        SKIP(member);
        if (tag->s & S_UNION) member = 0;

        if (!(flags & INIT_BRACED) && (member == 0))
            break;
    } while (comma());

    init_pad(size_of(type, 0) * BITS_PER_BYTE - offset_bits);
}

/* handle the initialization of an object of type at offset. returns the
   type, which is updated to include the actual number of elements if the
   type was an unbounded array (only permitted when INIT_OUTER). */

static struct tnode *init(struct tnode *type, int flags, int offset)
{
    struct tree *value;
    int nelem;

    if (token.k == K_LBRACE) {
        flags |= INIT_BRACED;
        lex();
    } else
        flags &= ~INIT_BRACED;

    /* can't look ahead if it's a string literal, as the expression
       parser will assume we want a pointer to that literal, which is
       not always right. luckily, the point of lookahead is to answer
       the question "is this a struct value?", and if the token is a
       string literal, we already know the answer. */

    if ((token.k != K_STRLIT) && (token.k != K_LBRACE)) {
        value = next();
        pushback = value;
    } else
        value = 0;

    if (SCALAR_TYPE(type)               /* scalars are easy. */
      || (STRUN_TYPE(type)              /* can also initialize a struct by */
          && value                      /* direct assignment, if the next */
          && STRUN_TYPE(value->type)    /* value is a struct type, but only */
          && !(flags & INIT_BRACED)))   /* if there was no opening brace */
    {
        value = next();
        init_value(type, offset, value, flags);
    } else {
        /* the only way we end up trying to initialize an unbounded array
           type that is not outermost is if it's the flexible array member
           of a struct, and that can't be initialized: C99 6.7.8 */

        if (UNBOUNDED_ARRAY_TYPE(type) && !(flags & INIT_OUTER))
            error(ERROR, 0, "can't initialize flexible array members");

        if (CHAR_ARRAY_TYPE(type) && (token.k == K_STRLIT))
            nelem = init_strlit(type, offset, flags);
        else {
            /* braces for inner aggregates are optional, but braces
               for the outermost aggregate are not, see C89 6.5.7 */

            if ((flags & INIT_OUTER) && !(flags & INIT_BRACED))
                error(ERROR, 0, "aggregate initializer requires braces");

            if (STRUN_TYPE(type))
                init_strun(type, offset, flags);
            else
                nelem = init_array(type, offset, flags);
        }
    }

    if (flags & INIT_BRACED)
        MATCH(K_RBRACE);

    if (UNBOUNDED_ARRAY_TYPE(type))
        type = get_tnode(T_ARRAY, nelem, DEREF(type));

    return type;
}

void init_bss(struct symbol *sym)
{
    int size;
    int align;

    size = size_of(sym->type, sym->id);
    align = align_of(sym->type);

    /* with gnu binutils, .comm automatically exports
       symbol; .lcomm does not, but can't be aligned.
       we must use .local followed by .comm.

       jewel as does not automatically export .bss, so
       .globl is required. as a favor to us for now, it
       ignores .local and accepts .comm as a synonym for
       .bss; once we ditch gas we can simplify all this. */

    out("%s %g\n", ((sym->s & S_STATIC) ? ".local" : ".globl"), sym);
    out(".comm %g, %d, %d\n", sym, size, align);

    sym->s |= S_DEFINED;
}

void init_static(struct symbol *sym, int s)
{
    if (token.k == K_EQ) {
        push(0);

        if (s & S_EXTERN)
            error(ERROR, sym->id, "initializer on `extern' declaration");

        if (DEFINED_SYMBOL(sym))
            error(ERROR, sym->id, "redefinition %L", sym);

        lex();
        HERE_SYMBOL(sym);
        sym->s |= S_DEFINED;
        header(sym);
        sym->type = init(sym->type, INIT_OUTER, 0);

        POP();
    } else {
        if (s != S_EXTERN) {
            if (sym->scope == FILE_SCOPE) {
                /* if a file-scope object declaration is not explicitly
                   extern, then it's a tentative definition. C89 6.7.2 */

                sym->s |= S_TENTATIVE;

                /* if it's explicitly S_STATIC, it has internal
                   linkage, and must not be incomplete. ibid. */

                if (s == S_STATIC) size_of(sym->type, sym->id);
            } else
                init_bss(sym);  /* must be a function-local static symbol */
        }
    }
}

void init_auto(struct symbol *sym)
{
    struct tree *tree;

    if (token.k == K_EQ) {
        push(sym);

        lex();
        sym->type = init(sym->type, INIT_OUTER, 0);

        if (!SCALAR_TYPE(sym->type)) {
            tree = blk_tree(E_BLKSET,
                            ref(sym->type, 0),
                            I_TREE(&int_type, 0),
                            I_TREE(&ulong_type, size_of(sym->type, 0)));

            state->tree = seq_tree(tree, state->tree);
        }

        gen(state->tree);
        POP();
    } else
        size_of(sym->type, sym->id);
}

/* C89 6.7.2 is vague, but later standards (e.g. C99 6.9.2) make it
   clear that the language of C89 means that tentative definitions
   of incomplete array types are completed by the compiler-supplied
   zero initializer, giving them a dimension of [1] (ugh). meanwhile,
   an incomplete struct/union is an error, which makes more sense. */

void tentative(struct symbol *sym)
{
    if (DEFINED_SYMBOL(sym)) return;

    if (UNBOUNDED_ARRAY_TYPE(sym->type)) {
        error(WARNING, sym->id, "incomplete array assigned one element");
        sym->type = get_tnode(T_ARRAY, 1, DEREF(sym->type));
    }

    if (STRUN_TYPE(sym->type) && !DEFINED_SYMBOL(sym->type->tag))
        error(ERROR, sym->id, "has incomplete type %T", sym->type->tag);

    init_bss(sym);
}

/* as with string literals, we remember floating-point values
   we've previously emitted so there are no duplicates. since
   we'll rarely see very many of these, a simple list suffices */

struct fcon
{
    union con con;          /* the value (f) */
    int f_asmlab;           /* emitted as a 32-bit float */
    int d_asmlab;           /* ............ 64-bit double */

    struct fcon *link;
};

static struct fcon *fcons;
static SLAB_DEFINE(fcon, 10);

struct symbol *floateral(long t, double f)
{
    struct fcon *p;
    int *asmlab;

    t = T_UNQUAL(t);

    for (p = fcons; p; p = p->link)
        if (p->con.f == f)
            break;

    if (p == 0) {
        p = SLAB_ALLOC(fcon);
        p->con.f = f;
        p->f_asmlab = 0;
        p->d_asmlab = 0;
        p->link = fcons;
        fcons = p;
    }

    asmlab = (t == T_FLOAT) ? &p->f_asmlab : &p->d_asmlab;

    if (*asmlab == 0) {
        *asmlab = ++last_asmlab;
        seg(SEG_TEXT);
        out("%L:\n", *asmlab);
        out_word(t, p->con, 0);
    }

    return anon_static((t == T_FLOAT) ? &float_type : &double_type, *asmlab);
}

/* vi: set ts=4 expandtab: */
