/*****************************************************************************

   switch.c                                            jewel/os c compiler

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

#include <stdlib.h>
#include "cc1.h"
#include "block.h"
#include "func.h"
#include "init.h"
#include "switch.h"

/* the number of insns at which we consider a function to be long.
   when we generate table-based switches, we either use full 32-bit
   addresses (remember our memory model means code < 2GB), or 16-bit
   offsets from the beginning of the function. the latter obviously
   takes less space, but fails if the function text exceeds 64K. we
   can't directly correlate insn count to byte count, but we err on
   the side of caution (assume 32 bytes/insn, VERY conservative). */

#define LONG_FUNC       2048

/* the number of cases in the switch, EXCLUDING default */

#define NR_CASES(b)     (NR_SUCCS(b) - 1)

/* pointers the min/max case labels, interpreted as b->control's type.
   these do not work until the switch block is sorted in lir_switch(),
   and assume the switch is not degenerate (i.e., only has CC_DEFAULT) */

#define MIN_CASE(b)     (&SUCC((b), 1)) /* always first after CC_DEFAULT */
#define MAX_CASE(b)     (&SUCC((b), NR_SUCCS(b) - 1))   /* always last */

/* returns the density of the switch cases between min and max, (0, 1].
   we compute the distance between their values as signed quantities;
   if max >> min and this will be negative, which is just fine. like
   MIN_CASE/MAX_CASE above, we assume the switch block has been sorted. */

#define DENSITY(min, max)   ((1.0 + ((max) - (min)))                        \
                            / (1.0 + (max)->label.i - (min)->label.i))

#define SWITCH_DENSITY(b)   DENSITY(MIN_CASE(b), MAX_CASE(b))

/* the maximum number of switch cases
   in what we consider a dumb switch.
   switches with MAX_DUMB of fewer cases
   do not qualify for any other strategy */

#define MAX_DUMB    4       /* must be at least 1 or chain0() can break */

/* the maximum number of switch cases that
   we will process with a basic strategy */

#define MAX_BASIC   10

/* the minimum number of dense switch cases we will split into a subswitch */

#define MIN_DENSE           5

/* the minimum density that qualifies a set of cases as dense */

#define MIN_DENSITY         0.5

/* we distinguish two types when processing case statements: the control
   type, which is the type of the expression in the switch() itself (which
   has not been subject to integral promotion) statement, and the case type,
   which is the smallest type that can represent the values of the cases.
   the case type is always the same size or smaller than the control type,
   as impossible cases have been already been removed by trim_switch_block().

   for example,

                    int a;

                    switch (a)
                    {
                    case -2:    ... ;
                    case 1:     ... ;
                    case 5:     ... ;
                    }

   has a control type of int, but a case type of char; if we can establish
   that -2 <= a <= 5, then we need only switch on the lower byte, which is
   quite a bit more efficient in space and, to a lesser degree, time.

   the parser has already removed impossible cases via trim_switch_block(). */

long case_type(struct block *b)
{
    long t;
    int n;

    /* brute force:  perform an exhaustive search
       between T_SCHAR .. T_ULONG until we hit it. */

    t = T_SCHAR;

next:
    for (n = 1; n < NR_SUCCS(b); ++n)
        if (!con_in_range(t, &SUCC(b, n).label)) {
            t <<= 1;
            goto next;
        }

    /* there's no advantage if the case_type is
       different but the same size as the control. */

    if (T_SIMPATICO(t, b->control.t))
        return b->control.t;
    else
        return t;
}

/* return an I_LIR_CMP insn comparing operand (which may be a constant) are
   a constant u. all constants present are normalized to the control type. */

#define CMP0(dst, src)                                                      \
    do {                                                                    \
        *(dst) = *(src);                                                    \
        (dst)->t = t;                                                       \
        if (OPERAND_IMM(dst)) normalize_con(t, &(dst)->con);                \
    } while (0)

static struct insn *cmp0(struct operand *control, unsigned long u)
{
    struct insn *new;
    struct operand label;
    long t = control->t;

    I_OPERAND(&label, 0, 0, u);

    new = new_insn(I_LIR_CMP, 0);
    CMP0(&new->operand[0], control);
    CMP0(&new->operand[1], &label);
    return new;
}

/* return the head of a two-block LIR sequence which checks the range
   of switch's controlling expression and dispatches accordingly... */

static struct block *range0(struct block *b,        /* switch block */
                            struct block *in,       /* target if in range */
                            struct succ *min,       /* min label of range */
                            struct block *below,    /* target if < min */
                            struct succ *max,       /* max label of range */
                            struct block *above)    /* target if > max */
{
    struct block *first = new_block();
    struct block *second = new_block();
    long t = b->control.t;

    append_insn(cmp0(&b->control, min->label.u), first);
    add_succ(first, (t & T_UNSIGNED) ? CC_B : CC_L, below);
    add_succ(first, (t & T_UNSIGNED) ? CC_AE : CC_GE, second);

    append_insn(cmp0(&b->control, max->label.u), second);
    add_succ(second, (t & T_UNSIGNED) ? CC_BE : CC_LE, in);
    add_succ(second, (t & T_UNSIGNED) ? CC_A : CC_G, above);

    return first;
}

/* turn a switch into a chain of LIR compare/branch insns.
   there are two related strategies: the `dumb' strategy,
   which is direct conversion, and the `basic' strategy,
   which does a little more work up front if we can do the
   comparisons with a smaller case_t. */

static void chain0(struct block *b, long case_t)
{
    struct block *first;
    struct block *this;
    struct block *next;
    struct succ *min = 0;
    struct succ *max = 0;
    struct block *def = SUCC(b, 0).b;       /* CC_DEFAULT */
    struct insn *insn;                      /* for I_LIR_CAST */
    long t = b->control.t;
    int n, tmp;

    first = this = new_block();
    next = new_block();

    if (case_t != t) {
        /* if case_t != b->control.t, then we can assume that we have at
           least 2 cases, since MAX_DUMB >= 1 and lir_switch() guarantees
           case_t == t when n <= MAX_DUMB. thus we have distinct min, max.

           we issue the first chain blocks for min and max, which are
           special because they are three-ways in b->control.t, NOT
           case_t. we use them to ensure that min <= control <= max. */

        min = MIN_CASE(b);
        max = MAX_CASE(b);

        append_insn(cmp0(&b->control, min->label.u), this);
        add_succ(this, CC_Z, min->b);
        add_succ(this, (t & T_UNSIGNED) ? CC_B : CC_L, def);
        add_succ(this, (t & T_UNSIGNED) ? CC_A : CC_G, next);
        this = next; next = new_block();

        append_insn(cmp0(&b->control, max->label.u), this);
        add_succ(this, CC_Z, max->b);
        add_succ(this, (t & T_UNSIGNED) ? CC_A : CC_G, def);
        add_succ(this, (t & T_UNSIGNED) ? CC_B : CC_L, next);
        this = next; next = new_block();

        /* now that we're sure the controlling expression is
           in range of case_t, we can downcast it and perform
           the remaining tests in the smaller type. this cast
           is conceptual and will almost certainly disappear,
           but in LIR, a reg must always have the same size. */

        tmp = temp_reg(case_t);
        insn = new_insn(I_LIR_CAST, 0);
        REG_OPERAND(&insn->operand[0], 0, case_t, tmp);
        insn->operand[1] = b->control;
        append_insn(insn, this);

        b->control = insn->operand[0];      /* switch on downcast value */
    }

    for (n = 1; n < NR_SUCCS(b); ++n) {
        if (&SUCC(b, n) == min) continue;
        if (&SUCC(b, n) == max) continue;

        append_insn(cmp0(&b->control, SUCC(b, n).label.u), this);
        add_succ(this, CC_Z, SUCC(b, n).b);
        add_succ(this, CC_NZ, next);
        this = next; next = new_block();
    }

    add_succ(this, CC_ALWAYS, def);

    remove_succs(b);                    /* no longer a B_SWITCH ... */
    add_succ(b, CC_ALWAYS, first);      /* jump to chain just created */
}

/* split0() has identified a dense region of block b, starting at SUCC(b, m)
   and spanning len successors. we create two new switch blocks, new and rem,
   and divide up the cases between them, then divert b to a range test which
   dispatches to the correct switch. note that in so doing we have fulfilled
   the requirement of mch_switch() that B_DENSE switches be reachable iff
   b->control is in the correct range, so we mark new B_DENSE accordingly.

   the range checks are deliberately naive. OPT_LIR_CMP will clean up.

   this could be more efficient if we wanted it to be, especially if we
   break the block abstraction (or made some specialty code in block.c):
   add_switch_succ() does unnecessary work, we could shuffle successors
   around rather than copying and deleting. not worth the headache. */

static void split1(struct block *b, int m, int len)
{
    struct block *new;          /* the new, dense switch block */
    struct block *rem;          /* where the remaining cases go */
    struct block *entry;        /* the new flow-control entry point */
    struct block *def;
    int i, n;

    def = SUCC(b, 0).b;     /* CC_DEFAULT */

    new = new_block(); switch_block(new, &b->control, def);
    rem = new_block(); switch_block(rem, &b->control, def);

    new->flags |= B_DENSE;              /* we'll add the range check below */
    n = m + len - 1;                    /* last successor being migrated */

    entry = range0(b, new,                  /* if in range of the */
                   &SUCC(b, m),             /* dense block, proceed */
                   rem,                     /* to the dense block, */
                   &SUCC(b, n),             /* else continue to the */
                   rem);                    /* remainder block */

    for (i = m; i <= n; ++i)    /* migrate dense cases to new */
        add_switch_succ(new, &SUCC(b, i).label, SUCC(b, i).b);

    for (i = 1; i < NR_SUCCS(b); ++i)   /* and migrate the */
        if ((i < m) || (i > n))         /* other cases to rem */
            add_switch_succ(rem, &SUCC(b, i).label, SUCC(b, i).b);

    /* b is no longer a switch; it now leads to the range
       check which dispatches to one of two switches */

    remove_succs(b);
    add_succ(b, CC_ALWAYS, entry);
}

/* scan the block for the largest contiguous set of switch cases
   that meet the MIN_DENSITY and MIN_DENSE requirements; if found,
   invoke split1() to separate them into their own dense switch,
   and return true. otherwise return false. this is O(n^2). */

static int split0(struct block *b)
{
    int m, n;
    int max_m = 0, max_len = 0;

    for (m = 1; m <= NR_CASES(b); ++m)
    {
        for (n = m; n <= NR_CASES(b); ++n)
            if (DENSITY(&SUCC(b, m), &SUCC(b, n)) < MIN_DENSITY)
                break;

        /* if this sequence was longer
           than the current max, we've
           found the new max. */

        if ((n - m) > max_len) {
            max_m = m;
            max_len = n - m;
        }
    }

    if (max_len < MIN_DENSE)
        return 0;
    else {
        split1(b, max_m, max_len);
        return 1;
    }
}

/* we've encountered a wild dense block (i.e., not formed by
   splitting). we must add a range check for mch_switch(). */

static void dense0(struct block *b)
{
    struct block *entry;
    struct block *new;
    struct block *def = SUCC(b, 0).b;

    /* this is slightly more efficient than
       the approach we must use in split1() */

    new = new_block();
    dup_succs(new, b);
    new->flags |= B_DENSE;

    /* if the controlling expression is in range, proceed
       to the new block, else to the default case */

    entry = range0(b, new, MIN_CASE(new), def, MAX_CASE(new), def);

    /* b isn't a switch anymore; it heads to the range check */

    remove_succs(b);
    add_succ(b, CC_ALWAYS, entry);
}

/* sort the case labels by their values
   (interpreted as the type of b->control) */

#define COMPAR0(compars0, i)                                                \
    static int compars0(const void *left, const void *right)                \
    {                                                                       \
        const struct succ *l = left;                                        \
        const struct succ *r = right;                                       \
        if (l->label.i == r->label.i) return 0;   /* there's probably a */  \
        if (l->label.i > r->label.i) return 1;      /* much more clever */  \
        if (l->label.i < r->label.i) return -1;       /* way to do this */  \
    }

COMPAR0(compars0, i)        /* for signed */
COMPAR0(comparu0, u)        /* ... unsigned */

static void sort0(struct block *b)
{
    int (*compar)(const void *, const void *);

    compar = (b->control.t & T_UNSIGNED) ? comparu0 : compars0;
    qsort(&SUCC(b, 1), NR_CASES(b), sizeof(struct succ), compar);
}

/* this is our first stab at generating code for switches.
   it takes place before lowering, so all insns are LIR and
   any code generated here must also be LIR. */

void lir_switch(void)
{
    struct block *b;
    int n;

restart:
    FOR_ALL_BLOCKS(b)
        if (SWITCH_BLOCK(b))
        {
            n = NR_CASES(b);

            /* first, eliminate any improper switches, i.e., those with
               only a CC_DEFAULT case. (these should only appear when
               OPT_PRUNE is disabled.) we must unswitch these here because
               most of the logic in this file assumes proper switches. */

            if (n == 0) {
                unswitch_block(b);
                continue;
            }

            /* if a block is marked for mch_switch(), it means we saw
               it on a previous iteration and there's nothing to do */

            if (b->flags & (B_DENSE | B_TABLE)) continue;

            /* quickly dispose of any switches with MAX_DUMB or fewer cases.
               they are so few that any other approach is a waste of time */

            if (n <= MAX_DUMB) {
                chain0(b, b->control.t);
                continue;
            }

            /* before we take a closer look, sort the cases. MIN_LABEL(),
               MAX_LABEL(), SWITCH_DENSITY(), etc. will not work otherwise */

            sort0(b);

            /* if we see a dense block here, it means it was `born that
               way', i.e., i.e., it did not arise from a split operation.
               we must guard its entry with a range check for mch_switch() */

            if (SWITCH_DENSITY(b) >= MIN_DENSITY) {
                dense0(b);
                continue;
            }

            /* attempt to split out a dense region of this switch. if
               successful, start over to reprocess the new B_SWITCHes */

            if (split0(b)) goto restart;

            /* if we get here, only two approaches remain: basic
               or table. if there are huge constants involved, we
               always use a table. otherwise if there are just a
               handful of cases, the basic approach is fine. */

            if (n <= MAX_BASIC) {
                long case_t = case_type(b);

                if (case_t < T_LONG) {
                    chain0(b, case_t);
                    continue;
                }
            }

            /* if we get here, then we'll use a table. that
               will be handled with table0() in mch_switch() */

            b->flags |= B_TABLE;
        }
}

/* issue one entry of a target address table, targeting block h;
   these are eiher 16-bit offsets from the begining of the current
   function, or full 32-bit offsets. long_func tells us which. */

static void target0(struct block *b, int long_func)
{
    int asmlab = b->asmlab;

    if (long_func)
        out("\t.int %L\n", asmlab);
    else
        out("\t.short %L-%g\n", asmlab, current_func);

    /* once we've named the block this way,
       we can't bypass or remove it */

    b->flags |= B_IMMORTAL;
}

/* the sequences generated by dense1() and table0() assume that the
   controlling expression is held in a register. (this should always
   be the case unless optimizations are disabled.) create a temporary
   and load it if necessary by appending an insn to b. */

static int control0(struct block *b)
{
    if (OPERAND_IMM(&b->control)) {     /* MOVx $control, %creg */
        long t = b->control.t;
        struct operand dst;
        int creg;

        creg = temp_reg(t);
        REG_OPERAND(&dst, 0, 0, creg);
        append_insn(move(t, &dst, &b->control), b);

        return creg;
    } else
        return b->control.reg;
}

/* pick element 0, 1, 2, or 3 from an array, given
   a type whose size is 1, 2, 4, or 8 (respectively). */

#define OP(t, ops)    (ops)[t_log2_size(t)]

/* generate the machine code for a B_DENSE switch block b.
   these have labels sufficiently densely packed that we
   use the label as the index into a table of addresses.

   lir_switch() guarantees us that upon entry to the block,
   the controlling is in range of the switch. */

static void dense1(struct block *b, int long_func)
{
    static const int leax[] = { I_MCH_LEAB, I_MCH_LEAW,
                                I_MCH_LEAL, I_MCH_LEAQ };

    static const int zerox[] = { I_MCH_MOVZBL, I_MCH_MOVZWL, 0, 0 };

    struct symbol *ttab;        /* target address table */
    int treg;                   /* target address register */
    int creg;                   /* controlling value register */
    long t = b->control.t;
    struct insn *insn;
    long i;
    int n;

    ttab = anon_static(&void_type, ++last_asmlab);
    treg = temp_reg(T_LONG);

    /* the `treg' ends up in the b->control field when we're done.
       it's never a good spill candidate, so mark it unspillable.
       (the graph allocator will not handle it properly anyway.) */

    REG_TO_SYMBOL(treg)->s |= S_NOSPILL;

    seg(SEG_TEXT);
    out(".align %d\n", long_func ? 4 : 2);
    out("%g:\n", ttab);

    for (n = 1, i = MIN_CASE(b)->label.i; n < NR_SUCCS(b); ++i)
        if (i != SUCC(b, n).label.i)
            target0(SUCC(b, 0).b, long_func);
        else {
            target0(SUCC(b, n).b, long_func);
            ++n;
        }

    creg = control0(b);

    /* now, bias the controlling value to 0 by subtracting
       the min case value, and put the result into treg. */

    i = MIN_CASE(b)->label.i;

    if ((t & T_LONGS) && HUGE(i)) {
        /* if the minimum case value is a huge constant,
           it must be loaded separately into the treg. */

        insn = new_insn(I_MCH_MOVQ, 0);     /* movq $-min, %treg */
        REG_OPERAND(&insn->operand[0], 0, 0, treg);
        I_OPERAND(&insn->operand[1], 0, 0, -i);
        append_insn(insn, b);

        insn = new_insn(I_MCH_ADDQ, 0);     /* addq %creg, %treg */
        REG_OPERAND(&insn->operand[0], 0, 0, treg);
        REG_OPERAND(&insn->operand[1], 0, 0, creg);
        append_insn(insn, b);
    } else {
        /* otherwise, min can be used directly, though we must
           extend the result if the controlling type is sub-int. */

        /* TODO. if min is zero, there's a shorter sequence ... */

        insn = new_insn(OP(t, leax), 0);    /* leaX -min(%creg), %treg */
        REG_OPERAND(&insn->operand[0], 0, 0, treg);
        BASED_OPERAND(&insn->operand[1], 0, 0, O_EA, creg, -i);
        append_insn(insn, b);

        if (OP(t, zerox)) {
            insn = new_insn(OP(t, zerox), 0);   /* movzXl %treg, %treg */
            REG_OPERAND(&insn->operand[0], 0, 0, treg);
            REG_OPERAND(&insn->operand[1], 0, 0, treg);
            append_insn(insn, b);
        }
    }

    /* at this point, %treg holds the table index,
       conveniently zero-extended to a quadword. */

    if (long_func) {
        insn = new_insn(I_MCH_MOVL, 0);     /* movl ttab(%treg,4), %treg */
        REG_OPERAND(&insn->operand[0], 0, 0, treg);
        INDEX_OPERAND(&insn->operand[1], 0, 0, O_MEM, treg, 2);
        insn->operand[1].sym = ttab;
        append_insn(insn, b);
    } else {
        insn = new_insn(I_MCH_MOVZWL, 0);   /* movzwl ttab(%treg,2), %treg */
        REG_OPERAND(&insn->operand[0], 0, 0, treg);
        INDEX_OPERAND(&insn->operand[1], 0, 0, O_MEM, treg, 1);
        insn->operand[1].sym = ttab;
        append_insn(insn, b);

        insn = new_insn(I_MCH_ADDL, 0);     /* addl $_func, %treg */
        REG_OPERAND(&insn->operand[0], 0, 0, treg);
        SYM_OPERAND(&insn->operand[1], 0, current_func);
        append_insn(insn, b);
    }

    REG_OPERAND(&b->control, 0, T_LONG, treg);
}

/* generate the machine code for a table switch. we iterate over
   a table of values (ctab) until we find a match, then use the
   index in that table as the index into the table (ttab) of target
   code addresses. if no match is found, we head to CC_DEFAULT.
   we separate the tables so we don't waste space for alignment.

   branch prediction makes this a far better alternative than
   a binary search tree, except when the number of case labels
   is exceedingly large. times have changed. */

static void table0(struct block *b, int long_func)
{
    struct symbol *ctab;        /* case value table */
    struct symbol *ttab;        /* target address table */
    int treg;                   /* target address register */
    int creg;                   /* controlling value register */
    int ireg;                   /* index counter register */
    long t = b->control.t;
    struct insn *insn;
    int n;

    static const int cmps[] = { I_MCH_CMPB, I_MCH_CMPW,
                                I_MCH_CMPL, I_MCH_CMPQ };

    struct block *test = new_block();       /* test loop */
    struct block *match = new_block();      /* entry matched */
    struct block *nomatch = new_block();    /* entry not matched */

    seg(SEG_TEXT);

    ctab = anon_static(&void_type, ++last_asmlab);      /* generate ctab */
    out(".align %d\n", t_size(t));
    out("%g:\n", ctab);

    for (n = 1; n <= NR_CASES(b); ++n)
        out_word(t, SUCC(b, n).label, 0);

    ttab = anon_static(&void_type, ++last_asmlab);      /* generate ttab */
    out(".align %d\n", long_func ? 4 : 2);
    out("%g:\n", ttab);

    for (n = 1; n <= NR_CASES(b); ++n)
        target0(SUCC(b, n).b, long_func);

    creg = control0(b);
    treg = temp_reg(T_LONG);
    ireg = temp_reg(T_INT);

    insn = new_insn(I_MCH_MOVL, 0);         /* movl $0, %ireg */
    REG_OPERAND(&insn->operand[0], 0, 0, ireg);
    I_OPERAND(&insn->operand[1], 0, 0, 0);
    append_insn(insn, b);

    insn = new_insn(OP(t, cmps), 0);        /* cmpX ctab(%ireg,n), %creg */
    REG_OPERAND(&insn->operand[0], 0, 0, creg);
    INDEX_OPERAND(&insn->operand[1], 0, 0, O_MEM, ireg, t_log2_size(t));
    insn->operand[1].sym = ctab;
    append_insn(insn, test);
    add_succ(test, CC_Z, match);
    add_succ(test, CC_NZ, nomatch);

    insn = new_insn(I_MCH_ADDL, 0);         /* addl $1, %ireg */
    REG_OPERAND(&insn->operand[0], 0, 0, ireg);
    I_OPERAND(&insn->operand[1], 0, 0, 1);
    append_insn(insn, nomatch);

    insn = new_insn(I_MCH_CMPL, 0);         /* cmpl $NR_CASES, %ireg */
    REG_OPERAND(&insn->operand[0], 0, 0, ireg);
    I_OPERAND(&insn->operand[1], 0, 0, NR_CASES(b));
    append_insn(insn, nomatch);
    add_succ(nomatch, CC_B, test);
    add_succ(nomatch, CC_AE, SUCC(b, 0).b);  /* CC_DEFAULT */

    REG_TO_SYMBOL(treg)->s |= S_NOSPILL;    /* see comment in dense1() */

    if (long_func) {
        insn = new_insn(I_MCH_MOVL, 0);     /* movl ttab(%ireg,4), %treg */
        REG_OPERAND(&insn->operand[0], 0, 0, treg);
        INDEX_OPERAND(&insn->operand[1], 0, 0, O_MEM, ireg, 2);
        insn->operand[1].sym = ttab;
        append_insn(insn, match);
    } else {
        insn = new_insn(I_MCH_MOVZWL, 0);   /* movzwl ttab(%ireg,2), %treg */
        REG_OPERAND(&insn->operand[0], 0, 0, treg);
        INDEX_OPERAND(&insn->operand[1], 0, 0, O_MEM, ireg, 1);
        insn->operand[1].sym = ttab;
        append_insn(insn, match);

        insn = new_insn(I_MCH_ADDL, 0);     /* addl $_func, %treg */
        REG_OPERAND(&insn->operand[0], 0, 0, treg);
        SYM_OPERAND(&insn->operand[1], 0, current_func);
        append_insn(insn, match);
    }

    /* most successors are reached by the match block now,
       not the original switch block. we copy them ALL here,
       despite the fact that CC_DEFAULT is not reached from
       here any more. in the future we may wish to take some
       other action here, since the CFG is overly constrained.
       it really depends on how many opportunities we miss. */

    dup_succs(match, b);
    REG_OPERAND(&match->control, 0, T_LONG, treg);

    remove_succs(b);                    /* b isn't a switch anymore; */
    add_succ(b, CC_ALWAYS, test);       /* it heads into the test loop */
}

/* immediately after lower(), mch_switch() is called upon to generate
   MCH insns for the table and dense strategies; the other strategies
   were dealt with as LIR insns and are no longer B_SWITCH blocks here.

   upon exit, the switch blocks are still labeled B_SWITCH, but the
   semantics are a little different than when the block is LIR: the
   b->control operand is not the controlling expression, but rather
   the code address of the calculated jump target. (thus the need to
   lower the switches immediately after lowering the rest of the CFG.) */

void mch_switch(void)
{
    int long_func = func_size() > LONG_FUNC;
    struct block *b;

    FOR_ALL_BLOCKS(b)
        if (SWITCH_BLOCK(b))
        {
            if (b->flags & B_DENSE)
                dense1(b, long_func);
            else if (b->flags & B_TABLE)
                table0(b, long_func);
        }
}

/* vi: set ts=4 expandtab: */
