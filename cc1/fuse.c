/*****************************************************************************

   fuse.c                                              tahoe/64 c compiler

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
#include "heap.h"
#include "insn.h"
#include "block.h"
#include "opt.h"
#include "fuse.h"

/* the flags[] table tells us which actions
   to take based on the MCH insn op. */

#define LOAD0       0x01        /* try load0() */
#define UPDATE0     0x02        /* ... update0() */
#define READ0       0x04        /* ... read0() */
#define READ1       0x08        /* ... read1() */
#define WRITE0      0x10        /* ... write0() */

static char flags[] =   /* indexed by I_INDEX */
{
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  /* LIR */
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,

    0     | 0       | 0     | 0     | 0         , /*   64  I_MCH_CALL       */
    0     | 0       | 0     | 0     | 0         , /*   65  I_MCH_RET        */
    0     | 0       | 0     | 0     | 0         , /*   66  I_MCH_RETI       */
    0     | 0       | 0     | 0     | 0         , /*   67  I_MCH_RETF       */
    LOAD0 | 0       | 0     | READ1 | WRITE0    , /*   68  I_MCH_MOVB       */
    LOAD0 | 0       | 0     | READ1 | WRITE0    , /*   69  I_MCH_MOVW       */
    LOAD0 | 0       | 0     | READ1 | WRITE0    , /*   70  I_MCH_MOVL       */
    LOAD0 | 0       | 0     | READ1 | WRITE0    , /*   71  I_MCH_MOVQ       */
    LOAD0 | 0       | 0     | READ1 | WRITE0    , /*   72  I_MCH_MOVSS      */
    LOAD0 | 0       | 0     | READ1 | WRITE0    , /*   73  I_MCH_MOVSD      */
    0     | 0       | 0     | READ1 | 0         , /*   74  I_MCH_MOVZBW     */
    0     | 0       | 0     | READ1 | 0         , /*   75  I_MCH_MOVZBL     */
    0     | 0       | 0     | READ1 | 0         , /*   76  I_MCH_MOVZBQ     */
    0     | 0       | 0     | READ1 | 0         , /*   77  I_MCH_MOVSBW     */
    0     | 0       | 0     | READ1 | 0         , /*   78  I_MCH_MOVSBL     */
    0     | 0       | 0     | READ1 | 0         , /*   79  I_MCH_MOVSBQ     */
    0     | 0       | 0     | READ1 | 0         , /*   80  I_MCH_MOVZWL     */
    0     | 0       | 0     | READ1 | 0         , /*   81  I_MCH_MOVZWQ     */
    0     | 0       | 0     | READ1 | 0         , /*   82  I_MCH_MOVSWL     */
    0     | 0       | 0     | READ1 | 0         , /*   83  I_MCH_MOVSWQ     */
    0     | 0       | 0     | READ1 | 0         , /*   84  I_MCH_MOVZLQ     */
    0     | 0       | 0     | READ1 | 0         , /*   85  I_MCH_MOVSLQ     */
    0     | 0       | 0     | READ1 | 0         , /*   86  I_MCH_CVTSI2SSL  */
    0     | 0       | 0     | READ1 | 0         , /*   87  I_MCH_CVTSI2SSQ  */
    0     | 0       | 0     | READ1 | 0         , /*   88  I_MCH_CVTSI2SDL  */
    0     | 0       | 0     | READ1 | 0         , /*   89  I_MCH_CVTSI2SDQ  */
    0     | 0       | 0     | READ1 | 0         , /*   90  I_MCH_CVTSS2SIL  */
    0     | 0       | 0     | READ1 | 0         , /*   91  I_MCH_CVTSS2SIQ  */
    0     | 0       | 0     | READ1 | 0         , /*   92  I_MCH_CVTSD2SIL  */
    0     | 0       | 0     | READ1 | 0         , /*   93  I_MCH_CVTSD2SIQ  */
    0     | 0       | READ0 | READ1 | 0         , /*   94  I_MCH_CMPB       */
    0     | 0       | READ0 | READ1 | 0         , /*   95  I_MCH_CMPW       */
    0     | 0       | READ0 | READ1 | 0         , /*   96  I_MCH_CMPL       */
    0     | 0       | READ0 | READ1 | 0         , /*   97  I_MCH_CMPQ       */
    0     | 0       | 0     | READ1 | 0         , /*   98  I_MCH_UCOMISS    */
    0     | 0       | 0     | READ1 | 0         , /*   99  I_MCH_UCOMISD    */
    0     | 0       | 0     | 0     | 0         , /*  100  I_MCH_LEAB       */
    0     | 0       | 0     | 0     | 0         , /*  101  I_MCH_LEAW       */
    0     | 0       | 0     | 0     | 0         , /*  102  I_MCH_LEAL       */
    0     | 0       | 0     | 0     | 0         , /*  103  I_MCH_LEAQ       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  104  I_MCH_NOTB       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  105  I_MCH_NOTW       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  106  I_MCH_NOTL       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  107  I_MCH_NOTQ       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  108  I_MCH_NEGB       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  109  I_MCH_NEGW       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  110  I_MCH_NEGL       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  111  I_MCH_NEGQ       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  112  I_MCH_ADDB       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  113  I_MCH_ADDW       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  114  I_MCH_ADDL       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  115  I_MCH_ADDQ       */
    0     | 0       | 0     | READ1 | 0         , /*  116  I_MCH_ADDSS      */
    0     | 0       | 0     | READ1 | 0         , /*  117  I_MCH_ADDSD      */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  118  I_MCH_SUBB       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  119  I_MCH_SUBW       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  120  I_MCH_SUBL       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  121  I_MCH_SUBQ       */
    0     | 0       | 0     | READ1 | 0         , /*  122  I_MCH_SUBSS      */
    0     | 0       | 0     | READ1 | 0         , /*  123  I_MCH_SUBSD      */
    0     | 0       | READ0 | 0     | 0         , /*  124  I_MCH_IMULB      */
    0     | 0       | 0     | READ1 | 0         , /*  125  I_MCH_IMULW      */
    0     | 0       | 0     | READ1 | 0         , /*  126  I_MCH_IMULL      */
    0     | 0       | 0     | READ1 | 0         , /*  127  I_MCH_IMULQ      */
    0     | 0       | 0     | READ1 | 0         , /*  128  I_MCH_IMUL3W     */
    0     | 0       | 0     | READ1 | 0         , /*  129  I_MCH_IMUL3L     */
    0     | 0       | 0     | READ1 | 0         , /*  130  I_MCH_IMUL3Q     */
    0     | 0       | 0     | READ1 | 0         , /*  131  I_MCH_MULSS      */
    0     | 0       | 0     | READ1 | 0         , /*  132  I_MCH_MULSD      */
    0     | 0       | 0     | READ1 | 0         , /*  133  I_MCH_DIVSS      */
    0     | 0       | 0     | READ1 | 0         , /*  134  I_MCH_DIVSD      */
    0     | 0       | READ0 | 0     | 0         , /*  135  I_MCH_IDIVB      */
    0     | 0       | READ0 | 0     | 0         , /*  136  I_MCH_IDIVW      */
    0     | 0       | READ0 | 0     | 0         , /*  137  I_MCH_IDIVL      */
    0     | 0       | READ0 | 0     | 0         , /*  138  I_MCH_IDIVQ      */
    0     | 0       | READ0 | 0     | 0         , /*  139  I_MCH_DIVB       */
    0     | 0       | READ0 | 0     | 0         , /*  140  I_MCH_DIVW       */
    0     | 0       | READ0 | 0     | 0         , /*  141  I_MCH_DIVL       */
    0     | 0       | READ0 | 0     | 0         , /*  142  I_MCH_DIVQ       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  143  I_MCH_SHRB       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  144  I_MCH_SHRW       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  145  I_MCH_SHRL       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  146  I_MCH_SHRQ       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  147  I_MCH_SARB       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  148  I_MCH_SARW       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  149  I_MCH_SARL       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  150  I_MCH_SARQ       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  151  I_MCH_SHLB       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  152  I_MCH_SHLW       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  153  I_MCH_SHLL       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  154  I_MCH_SHLQ       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  155  I_MCH_ANDB       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  156  I_MCH_ANDW       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  157  I_MCH_ANDL       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  158  I_MCH_ANDQ       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  159  I_MCH_ORB        */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  160  I_MCH_ORW        */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  161  I_MCH_ORL        */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  162  I_MCH_ORQ        */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  163  I_MCH_XORB       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  164  I_MCH_XORW       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  165  I_MCH_XORL       */
    0     | UPDATE0 | 0     | READ1 | 0         , /*  166  I_MCH_XORQ       */
    0     | 0       | 0     | 0     | WRITE0    , /*  167  I_MCH_SETZ       */
    0     | 0       | 0     | 0     | WRITE0    , /*  168  I_MCH_SETNZ      */
    0     | 0       | 0     | 0     | WRITE0    , /*  169  I_MCH_SETS       */
    0     | 0       | 0     | 0     | WRITE0    , /*  170  I_MCH_SETNS      */
    0     | 0       | 0     | 0     | WRITE0    , /*  171  I_MCH_SETG       */
    0     | 0       | 0     | 0     | WRITE0    , /*  172  I_MCH_SETLE      */
    0     | 0       | 0     | 0     | WRITE0    , /*  173  I_MCH_SETGE      */
    0     | 0       | 0     | 0     | WRITE0    , /*  174  I_MCH_SETL       */
    0     | 0       | 0     | 0     | WRITE0    , /*  175  I_MCH_SETA       */
    0     | 0       | 0     | 0     | WRITE0    , /*  176  I_MCH_SETBE      */
    0     | 0       | 0     | 0     | WRITE0    , /*  177  I_MCH_SETAE      */
    0     | 0       | 0     | 0     | WRITE0    , /*  178  I_MCH_SETB       */
    0     | 0       | 0     | READ1 | 0         , /*  179  I_MCH_BSFL       */
    0     | 0       | 0     | READ1 | 0         , /*  180  I_MCH_BSFQ       */
    0     | 0       | 0     | READ1 | 0         , /*  181  I_MCH_BSRL       */
    0     | 0       | 0     | READ1 | 0         , /*  182  I_MCH_BSRQ       */
    0     | 0       | 0     | 0     | 0         , /*  183  I_MCH_MOVSB      */
    0     | 0       | 0     | 0     | 0         , /*  184  I_MCH_STOSB      */
    0     | 0       | 0     | 0     | 0         , /*  185  I_MCH_REP        */
    0     | 0       | 0     | 0     | 0         , /*  186  I_MCH_CBTW       */
    0     | 0       | 0     | 0     | 0         , /*  187  I_MCH_CWTD       */
    0     | 0       | 0     | 0     | 0         , /*  188  I_MCH_CLTD       */
    0     | 0       | 0     | 0     | 0         , /*  189  I_MCH_CQTO       */
    0     | 0       | 0     | READ1 | 0         , /*  190  I_MCH_CVTSS2SD   */
    0     | 0       | 0     | READ1 | 0         , /*  191  I_MCH_CVTSD2SS   */
    0     | 0       | READ0 | 0     | 0         , /*  192  I_MCH_PUSHQ      */
    0     | 0       | 0     | 0     | 0         , /*  193  I_MCH_POPQ       */
    0     | 0       | READ0 | 0     | 0         , /*  194  I_MCH_TESTB      */
    0     | 0       | READ0 | 0     | 0         , /*  195  I_MCH_TESTW      */
    0     | 0       | READ0 | 0     | 0         , /*  196  I_MCH_TESTL      */
    0     | 0       | READ0 | 0     | 0         , /*  197  I_MCH_TESTQ      */
    0     | UPDATE0 | 0     | 0     | 0         , /*  198  I_MCH_DECB       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  199  I_MCH_DECW       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  200  I_MCH_DECL       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  201  I_MCH_DECQ       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  202  I_MCH_INCB       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  203  I_MCH_INCW       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  204  I_MCH_INCL       */
    0     | UPDATE0 | 0     | 0     | 0         , /*  205  I_MCH_INCQ       */
    0     | 0       | 0     | 0     | 0         , /*  206  I_MCH_CMOVZL     */
    0     | 0       | 0     | 0     | 0         , /*  207  I_MCH_CMOVNZL    */
    0     | 0       | 0     | 0     | 0         , /*  208  I_MCH_CMOVSL     */
    0     | 0       | 0     | 0     | 0         , /*  209  I_MCH_CMOVNSL    */
    0     | 0       | 0     | 0     | 0         , /*  210  I_MCH_CMOVGL     */
    0     | 0       | 0     | 0     | 0         , /*  211  I_MCH_CMOVLEL    */
    0     | 0       | 0     | 0     | 0         , /*  212  I_MCH_CMOVGEL    */
    0     | 0       | 0     | 0     | 0         , /*  213  I_MCH_CMOVLL     */
    0     | 0       | 0     | 0     | 0         , /*  214  I_MCH_CMOVAL     */
    0     | 0       | 0     | 0     | 0         , /*  215  I_MCH_CMOVBEL    */
    0     | 0       | 0     | 0     | 0         , /*  216  I_MCH_CMOVAEL    */
    0     | 0       | 0     | 0     | 0         , /*  217  I_MCH_CMOVBL     */
    0     | 0       | 0     | 0     | 0         , /*  218  I_MCH_CMOVZQ     */
    0     | 0       | 0     | 0     | 0         , /*  219  I_MCH_CMOVNZQ    */
    0     | 0       | 0     | 0     | 0         , /*  220  I_MCH_CMOVSQ     */
    0     | 0       | 0     | 0     | 0         , /*  221  I_MCH_CMOVNSQ    */
    0     | 0       | 0     | 0     | 0         , /*  222  I_MCH_CMOVGQ     */
    0     | 0       | 0     | 0     | 0         , /*  223  I_MCH_CMOVLEQ    */
    0     | 0       | 0     | 0     | 0         , /*  224  I_MCH_CMOVGEQ    */
    0     | 0       | 0     | 0     | 0         , /*  225  I_MCH_CMOVLQ     */
    0     | 0       | 0     | 0     | 0         , /*  226  I_MCH_CMOVAQ     */
    0     | 0       | 0     | 0     | 0         , /*  227  I_MCH_CMOVBEQ    */
    0     | 0       | 0     | 0     | 0         , /*  228  I_MCH_CMOVAEQ    */
    0     | 0       | 0     | 0     | 0           /*  229  I_MCH_CMOVBQ     */
};

/* when we have an active load this points to
   the load insn, and the following fields are
   filled in accordingly. 0 = no load available.
   it's double-indirect so we can I_NOP it when
   we successfully fuse the load. */

static struct insn **load;

/* these are all filled in when load is
   set. when load is 0, they are invalid. */

static long t;                  /* type of loaded value */
static int reg;                 /* register holding it */
static int span;                /* last use of reg */
static struct operand *mem;     /* where value is from */


/* if the insn is a qualified load from memory,
   update the load state stored above. the only
   loads that do not qualify are those that are
   self-referential, i.e.,

                movl (%eax), %eax

   there are pitfalls with such operands. the
   code generator should not emit such things;
   they will pop up during register allocation,
   but by then most fusion will be done. missed
   opportunities for fusion as a result of this
   restriction should be exceedingly uncommon.

   it's safe to fuse volatiles, since fusing will
   not change the number, kind, size, or ordering
   of memory accesses in any way inconsistent with
   volatile semantics. (at least... we hope not.) */

static int load0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    int r;

    if (OPERAND_REG(&insn->operand[0])
      && OPERAND_MEM(&insn->operand[1]))
    {
        t = insn->operand[0].t;
        reg = insn->operand[0].reg;
        mem = &insn->operand[1];
        normalize_operand(mem);

        if ((mem->reg == reg)           /* self-referential */
          || (mem->index == reg))
            return 0;

        r = range_by_def(b, reg, i);
        span = range_span(b, r);

        load = &INSN(b, i);
        return 1;
    }

    return 0;
}

/* if an insn with a write-only operand[0] writes to a reg
   which is immediately written to memory and forgotten,
   rewrite the operand to write to memory directly, e.g.,:

        OP      xxxx, %reg      ->      OP xxxx, (yyy)
        MOVE    %reg, (yyy)

           (%REG is dead)

   these are mostly two-operand operations; if present, operand[1] is
   read-only. this is the only transformation that makes no use of load
   et al; were it not required that %reg be dead, this would degenerate
   into a simple peephole optimization. */

static int write0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct insn *store;
    int r;

    /* n.b.: these locals mask the globals */

    int reg;                    /* %reg */
    struct operand *mem;        /* (yyy) */
    long t;                     /* type of %reg */

    if ((i + 1) == NR_INSNS(b)) return 0;       /* no following insn */

    if (I_OPERANDS(insn->op) == 2) {
        if (OPERAND_MEM(&insn->operand[1]))     /* only one memory */
            return 0;                           /* operand per insn */

        if (OPERAND_HUGE(&insn->operand[1]))    /* must be a movabs */
            return 0;                           /* we can't fuse it */
    }

    if (!OPERAND_REG(&insn->operand[0]))        /* dst must be a reg */
        return 0;

    reg = insn->operand[0].reg;
    t = insn->operand[0].t;

    /* next insn must be a store of reg, of
       the same size. the memory reference
       can't be dependent in reg; see load0 */

    store = INSN(b, i + 1);

    if (    !(flags[I_INDEX(store->op)] & LOAD0)    /* MOVxx */
      ||    !OPERAND_REG(&store->operand[1])        /* from reg */
      ||    (store->operand[1].reg != reg)
      ||    !OPERAND_MEM(&store->operand[0])        /* to memory */
      ||    !T_SIMPATICO(t, store->operand[0].t))   /* same size */
        return 0;

    r = range_by_def(b, reg, i);                    /* reg must be dead */
    if (range_span(b, r) != (i + 1)) return 0;      /* after the store */

    mem = &store->operand[0];
    normalize_operand(mem);

    if ((mem->reg == reg) || (mem->index == reg))   /* address can't */
        return 0;                                   /* depend on reg */

    insn->operand[0] = *mem;        /* replace operand */
    INSN(b, i + 1) = &nop_insn;     /* kill following store */

    return 1;  /* fused */
}

/* to try replace the read-only operand[0] of an insn if the
   operand is a reg that is loaded solely for this insn:

        MOVE    (yyy), %reg         ->      OP xxxx, (yyy)

              ........

        (%reg not referenced)

              ........

        OP      xxxx, %reg

           (%REG is dead)

   this only applies to a handful of insns. MUL/DIV have one
   one operand, but CMP/TEST have a second read-only operand[1]. */

static int read0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);

    if (I_OPERANDS(insn->op) == 2) {
        if (OPERAND_MEM(&insn->operand[1]))     /* only one O_MEM */
            return 0;                           /* operand allowed */

        if (OPERAND_REG(&insn->operand[1])      /* reg can't be */
          && (insn->operand[1].reg == reg))     /* both operands */
            return 0;
    }

    if (OPERAND_REG(&insn->operand[0])          /* if the operand */
      && (insn->operand[0].reg == reg)          /* is reg, and the */
      && T_SIMPATICO(t, insn->operand[0].t))    /* size is right ... */
    {
        insn->operand[0] = *mem;            /* substitute, and */
        *load = &nop_insn;                  /* kill the load */
        return 1;                           /* restart at top of block */
    }

    return 0;
}

/* to try replace the read-only operand[1] of an insn if the
   operand is a reg that is loaded solely for this insn:

        MOVE    (yyy), %reg         ->      OP (yyy), xxxx

              ........

        (%reg not referenced)

              ........

        OP      %reg, xxxx

           (%REG is dead)

   this only applies to two- or three-operand insns (the latter being
   IMULs). operand[0] (xxxx above) may be read-only or read-write. */

static int read1(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);

    if (OPERAND_MEM(&insn->operand[0]))     /* can't already have */
        return 0;                           /* a memory operand */

    if (!(insn->op & I_FLAG_HAS_DST) || (insn->op & I_FLAG_USES_DST))
        if (OPERAND_REG(&insn->operand[0])      /* can't substitute */
          && (insn->operand[0].reg == reg))     /* if reg is USEd */
            return 0;                           /* in the other operand */

    if (OPERAND_REG(&insn->operand[1])          /* operand[1] is a read */
      && (insn->operand[1].reg == reg)          /* from our register */
      && T_SIMPATICO(t, insn->operand[1].t))    /* of the same size */
    {
        insn->operand[1] = *mem;            /* substitute, and */
        *load = &nop_insn;                  /* kill the load */
        return 1;                           /* tell main loop to restart */
    }

    return 0;
}

/* try to replace the update (read/write) operand[0] of an insn
   if the operand is a reg that is loaded, operated on, and then
   immediately stored back, e.g.,:


        MOVE    (yyy), %reg         ->      OP XXXX, (yyy)

              ........

        (%reg not referenced)

              ........

        OP      xxxx, %reg
        MOVE    %reg, (yyy)

           (%REG is dead)

   this applies to most ALU insns, even single-address insns
   like NOT or NEG, with obvious changes in the above template. */

static int update0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct insn *store;
    int r;

    /* see if that next insn is a store matching our load. */

    if ((i + 1) == NR_INSNS(b)) return 0;
    store = INSN(b, i + 1);
    if (store->op != (*load)->op) return 0;
    if (!same_operand(&store->operand[0], mem)) return 0;

    /* to check the involved register, we can't use
       same_operand() as anything simpatico will do.
       we don't bother checking the type here, since
       we've matched the load/store ops exactly. */

    if (!OPERAND_REG(&store->operand[1])) return 0;
    if (store->operand[1].reg != reg) return 0;

    /* and the store must be the only use of the result */

    r = range_by_def(b, reg, i);
    if (range_span(b, r) != (i + 1)) return 0;

    if (I_OPERANDS(insn->op) == 2) {
        if (OPERAND_MEM(&insn->operand[1]))     /* we can't already have */
            return 0;                           /* a memory operand */

        if (OPERAND_REG(&insn->operand[1])      /* and it can't be the */
          && (insn->operand[1].reg == reg))     /* same reg, either */
            return 0;
    }

    if (OPERAND_REG(&insn->operand[0])          /* if the destination is */
      && (insn->operand[0].reg == reg)          /* our register, and it */
      && T_SIMPATICO(t, insn->operand[0].t))    /* has the same size ... */
    {
        insn->operand[0] = *mem;        /* substitute memory operand, */
        *load = &nop_insn;              /* kill the load, */
        INSN(b, i + 1) = &nop_insn;     /* and the store. */
        return 1;                       /* tell main loop to start over */
    }

    return 0;
}

static VECTOR(reg) tmp_regs;

/* try to fuse in a basic block. when we fuse something, return non-zero
   to force the outer loop to immediately restart. we must do this since
   most transformations unfortunately render the live data invalid. */

static int fuse0(struct block *b)
{
    struct insn *insn;
    int i, op_flags;

    load = 0;

    FOR_EACH_INSN(b, i, insn) {
        op_flags = flags[I_INDEX(insn->op)];

        if ((op_flags & LOAD0) && load0(b, i)) continue;

        if (load && (span == i)) {
            if ((op_flags & UPDATE0) && update0(b, i)) return 1;
            if ((op_flags & READ1)   && read1(b, i))   return 1;
            if ((op_flags & READ0)   && read0(b, i))   return 1;
        }

        if ((op_flags & WRITE0) && write0(b, i)) return 1;

        if (load) {
            /* we invalidate load if anyone DEFs memory, a register used in
               the address computation, or the loaded register itself. we
               must also invalidate when reg is USEd, not because the load
               itself is no longer valid, but because it can't be fused. */

            if (INSN_DEFS_MEM(insn)) goto invalidate;

            TRUNC_VECTOR(tmp_regs);
            insn_defs(insn, &tmp_regs, 0);

            if (contains_reg(&tmp_regs, mem->reg)
              || contains_reg(&tmp_regs, mem->index))
                goto invalidate;

            insn_uses(insn, &tmp_regs, 0);

            if (contains_reg(&tmp_regs, reg))
                goto invalidate;
        }

        continue;

invalidate:
        load = 0;
    }

    return 0;
}

void opt_mch_fuse(void)
{
    struct block *b;

restart:
    live_analyze(LIVE_ANALYZE_REGS);
    INIT_VECTOR(tmp_regs, &local_arena);

    FOR_ALL_BLOCKS(b)
        if (fuse0(b)) {
            ARENA_FREE(&local_arena);
            opt_request |= OPT_PRUNE;
            goto restart;
        }

    ARENA_FREE(&local_arena);
}

/* vi: set ts=4 expandtab: */
