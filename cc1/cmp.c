/*****************************************************************************

   cmp.c                                                  minix c compiler

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

#include "cc1.h"
#include "block.h"
#include "opt.h"
#include "cmp.h"

/* sometimes we I_LIR_CMP values, branch, and then
   repeat the same comparison:

                    if (a > b) ...... ;
                    if (a < b) ...... ;

   as long as REG_CC hasn't been touched and a and b
   have the same values, there's no need to repeat.

   in b->cmp we track the last I_LIR_CMP which has
   not been invalidated, and if we see a textually-
   identical version (OPT_LIR_NORM helps with this),
   we NOP it away. we can inherit the last comparison
   from our predecessors, provided they all agree on
   what it was.

   OPT_LIR_CMP is scheduled late because:

    1. since we nuke I_LIR_CMPs, we open up the
       possibility that REG_CC is live across
       blocks, which limits some other passes'
       ability to optimize (e.g., hoisting), AND
    2. we only run once (no one requests us), and
       we want to be sure we recognize redundant
       comparisons (which might not be obvious
       until after normalization, folding, etc.) */

void opt_lir_cmp(void)
{
    VECTOR(reg) defs;
    struct block *b;
    struct insn *insn;
    struct insn *meet;
    int i, n;

    INIT_VECTOR(defs, &local_arena);

    sequence_blocks(0);
    FOR_ALL_BLOCKS(b) b->cmp = 0;

    FOR_ALL_BLOCKS(b) {
        /* the meet is intersection across all predecessors. don't
           use b->cmp for the meet (in case b precedes itself).*/

        meet = 0;

        if (NR_PREDS(b)) {
            meet = PRED(b, 0)->cmp;

            for (n = 1; meet && (n < NR_PREDS(b)); ++n)
                if (PRED(b, n)->cmp != meet)
                    meet = 0;
        }

        b->cmp = meet;

        FOR_EACH_INSN(b, i, insn) {
            if (insn->op == I_LIR_CMP) {
                if (b->cmp && same_insn(insn, b->cmp)) {
                    INSN(b, i) = &nop_insn;
                    opt_request |= OPT_PRUNE;
                } else
                    b->cmp = insn;
            } else if (b->cmp) {
                /* the reuslt of I_LIR_CMP is invalidated if REG_CC
                   is modified or any registers compared are modified.
                   (since so many insns modify REG_CC and we can tell
                   quickly, we shortcut instead of using I_FLAG_DEFS_CC.) */

                if (INSN_DEFS_CC(insn))
                    b->cmp = 0;
                else {
                    TRUNC_VECTOR(defs);
                    insn_defs(insn, &defs, 0);

                    if ((OPERAND_REG(&b->cmp->operand[0]) &&
                         contains_reg(&defs, b->cmp->operand[0].reg))
                      || (OPERAND_REG(&b->cmp->operand[1]) &&
                         contains_reg(&defs, b->cmp->operand[1].reg)))
                        b->cmp = 0;
                }
            }
        }

        /* because of table-driven switches,
           we can't guarantee the flags will
           remain untouched out of a B_SWITCH */

        if (SWITCH_BLOCK(b)) b->cmp = 0;
    }

    ARENA_FREE(&local_arena);
}

/* the arith[] table tells us the effect on an insn on REG_CC. if
   1, then the Z and S flags are reliably set based on the result.

   if 0, then whether the insn affects the flags be determined the
   usual way, i.e., INSN_DEFS_CC(), and if so, it must be assumed
   the Z and S flags are trashed. */

static char arith[] =   /* indexed by I_INDEX */
{
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  /* LIR */
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,

    0,  /*   64  I_MCH_CALL       */        0,  /*   65  I_MCH_RET        */
    0,  /*   66  I_MCH_RETI       */        0,  /*   67  I_MCH_RETF       */
    0,  /*   68  I_MCH_MOVB       */        0,  /*   69  I_MCH_MOVW       */
    0,  /*   70  I_MCH_MOVL       */        0,  /*   71  I_MCH_MOVQ       */
    0,  /*   72  I_MCH_MOVSS      */        0,  /*   73  I_MCH_MOVSD      */
    0,  /*   74  I_MCH_MOVZBW     */        0,  /*   75  I_MCH_MOVZBL     */
    0,  /*   76  I_MCH_MOVZBQ     */        0,  /*   77  I_MCH_MOVSBW     */
    0,  /*   78  I_MCH_MOVSBL     */        0,  /*   79  I_MCH_MOVSBQ     */
    0,  /*   80  I_MCH_MOVZWL     */        0,  /*   81  I_MCH_MOVZWQ     */
    0,  /*   82  I_MCH_MOVSWL     */        0,  /*   83  I_MCH_MOVSWQ     */
    0,  /*   84  I_MCH_MOVZLQ     */        0,  /*   85  I_MCH_MOVSLQ     */
    0,  /*   86  I_MCH_CVTSI2SSL  */        0,  /*   87  I_MCH_CVTSI2SSQ  */
    0,  /*   88  I_MCH_CVTSI2SDL  */        0,  /*   89  I_MCH_CVTSI2SDQ  */
    0,  /*   90  I_MCH_CVTSS2SIL  */        0,  /*   91  I_MCH_CVTSS2SIQ  */
    0,  /*   92  I_MCH_CVTSD2SIL  */        0,  /*   93  I_MCH_CVTSD2SIQ  */
    0,  /*   94  I_MCH_CMPB       */        0,  /*   95  I_MCH_CMPW       */
    0,  /*   96  I_MCH_CMPL       */        0,  /*   97  I_MCH_CMPQ       */
    0,  /*   98  I_MCH_UCOMISS    */        0,  /*   99  I_MCH_UCOMISD    */
    0,  /*  100  I_MCH_LEAB       */        0,  /*  101  I_MCH_LEAW       */
    0,  /*  102  I_MCH_LEAL       */        0,  /*  103  I_MCH_LEAQ       */
    0,  /*  104  I_MCH_NOTB       */        0,  /*  105  I_MCH_NOTW       */
    0,  /*  106  I_MCH_NOTL       */        0,  /*  107  I_MCH_NOTQ       */
    1,  /*  108  I_MCH_NEGB       */        1,  /*  109  I_MCH_NEGW       */
    1,  /*  110  I_MCH_NEGL       */        1,  /*  111  I_MCH_NEGQ       */
    1,  /*  112  I_MCH_ADDB       */        1,  /*  113  I_MCH_ADDW       */
    1,  /*  114  I_MCH_ADDL       */        1,  /*  115  I_MCH_ADDQ       */
    0,  /*  116  I_MCH_ADDSS      */        0,  /*  117  I_MCH_ADDSD      */
    1,  /*  118  I_MCH_SUBB       */        1,  /*  119  I_MCH_SUBW       */
    1,  /*  120  I_MCH_SUBL       */        1,  /*  121  I_MCH_SUBQ       */
    0,  /*  122  I_MCH_SUBSS      */        0,  /*  123  I_MCH_SUBSD      */
    0,  /*  124  I_MCH_IMULB      */        0,  /*  125  I_MCH_IMULW      */
    0,  /*  126  I_MCH_IMULL      */        0,  /*  127  I_MCH_IMULQ      */
    0,  /*  128  I_MCH_IMUL3W     */        0,  /*  129  I_MCH_IMUL3L     */
    0,  /*  130  I_MCH_IMUL3Q     */        0,  /*  131  I_MCH_MULSS      */
    0,  /*  132  I_MCH_MULSD      */        0,  /*  133  I_MCH_DIVSS      */
    0,  /*  134  I_MCH_DIVSD      */        0,  /*  135  I_MCH_IDIVB      */
    0,  /*  136  I_MCH_IDIVW      */        0,  /*  137  I_MCH_IDIVL      */
    0,  /*  138  I_MCH_IDIVQ      */        0,  /*  139  I_MCH_DIVB       */
    0,  /*  140  I_MCH_DIVW       */        0,  /*  141  I_MCH_DIVL       */
    0,  /*  142  I_MCH_DIVQ       */        1,  /*  143  I_MCH_SHRB       */
    1,  /*  144  I_MCH_SHRW       */        1,  /*  145  I_MCH_SHRL       */
    1,  /*  146  I_MCH_SHRQ       */        1,  /*  147  I_MCH_SARB       */
    1,  /*  148  I_MCH_SARW       */        1,  /*  149  I_MCH_SARL       */
    1,  /*  150  I_MCH_SARQ       */        1,  /*  151  I_MCH_SHLB       */
    1,  /*  152  I_MCH_SHLW       */        1,  /*  153  I_MCH_SHLL       */
    1,  /*  154  I_MCH_SHLQ       */        1,  /*  155  I_MCH_ANDB       */
    1,  /*  156  I_MCH_ANDW       */        1,  /*  157  I_MCH_ANDL       */
    1,  /*  158  I_MCH_ANDQ       */        1,  /*  159  I_MCH_ORB        */
    1,  /*  160  I_MCH_ORW        */        1,  /*  161  I_MCH_ORL        */
    1,  /*  162  I_MCH_ORQ        */        1,  /*  163  I_MCH_XORB       */
    1,  /*  164  I_MCH_XORW       */        1,  /*  165  I_MCH_XORL       */
    1,  /*  166  I_MCH_XORQ       */        0,  /*  167  I_MCH_SETZ       */
    0,  /*  168  I_MCH_SETNZ      */        0,  /*  169  I_MCH_SETS       */
    0,  /*  170  I_MCH_SETNS      */        0,  /*  171  I_MCH_SETG       */
    0,  /*  172  I_MCH_SETLE      */        0,  /*  173  I_MCH_SETGE      */
    0,  /*  174  I_MCH_SETL       */        0,  /*  175  I_MCH_SETA       */
    0,  /*  176  I_MCH_SETBE      */        0,  /*  177  I_MCH_SETAE      */
    0,  /*  178  I_MCH_SETB       */        0,  /*  179  (unused)         */
    0,  /*  180  (unused)         */        0,  /*  181  (unused)         */
    0,  /*  182  (unused)         */        0,  /*  183  I_MCH_MOVSB      */
    0,  /*  184  I_MCH_STOSB      */        0,  /*  185  I_MCH_REP        */
    0,  /*  186  I_MCH_CBTW       */        0,  /*  187  I_MCH_CWTD       */
    0,  /*  188  I_MCH_CLTD       */        0,  /*  189  I_MCH_CQTO       */
    0,  /*  190  I_MCH_CVTSS2SD   */        0,  /*  191  I_MCH_CVTSD2SS   */
    0,  /*  192  I_MCH_PUSHQ      */        0,  /*  193  I_MCH_POPQ       */
    0,  /*  194  I_MCH_TESTB      */        0,  /*  195  I_MCH_TESTW      */
    0,  /*  196  I_MCH_TESTL      */        0,  /*  197  I_MCH_TESTQ      */
    0,  /*  198  I_MCH_DECB       */        0,  /*  199  I_MCH_DECW       */
    0,  /*  200  I_MCH_DECL       */        0,  /*  201  I_MCH_DECQ       */
    0,  /*  202  I_MCH_INCB       */        0,  /*  203  I_MCH_INCW       */
    0,  /*  204  I_MCH_INCL       */        0,  /*  205  I_MCH_INCQ       */
    0,  /*  206  I_MCH_CMOVZL     */        0,  /*  207  I_MCH_CMOVNZL    */
    0,  /*  208  I_MCH_CMOVSL     */        0,  /*  209  I_MCH_CMOVNSL    */
    0,  /*  210  I_MCH_CMOVGL     */        0,  /*  211  I_MCH_CMOVLEL    */
    0,  /*  212  I_MCH_CMOVGEL    */        0,  /*  213  I_MCH_CMOVLL     */
    0,  /*  214  I_MCH_CMOVAL     */        0,  /*  215  I_MCH_CMOVBEL    */
    0,  /*  216  I_MCH_CMOVAEL    */        0,  /*  217  I_MCH_CMOVBL     */
    0,  /*  218  I_MCH_CMOVZQ     */        0,  /*  219  I_MCH_CMOVNZQ    */
    0,  /*  220  I_MCH_CMOVSQ     */        0,  /*  221  I_MCH_CMOVNSQ    */
    0,  /*  222  I_MCH_CMOVGQ     */        0,  /*  223  I_MCH_CMOVLEQ    */
    0,  /*  224  I_MCH_CMOVGEQ    */        0,  /*  225  I_MCH_CMOVLQ     */
    0,  /*  226  I_MCH_CMOVAQ     */        0,  /*  227  I_MCH_CMOVBEQ    */
    0,  /*  228  I_MCH_CMOVAEQ    */        0   /*  229  I_MCH_CMOVBQ     */
};

/* the register whose contents are properly
   reflected by the Z/S flags, or REG_NONE.
   we also need to know which type (or more
   precisely, the size) of the register the
   flags apply to. */

static int active;
static long active_t;

/* we currently restrict our analysis to basic blocks. this could be
   extended to EBBs or even global analysis in a straightforward way:
   it is unclear if that would be worth the development/runtime costs */

static void cmp0(int f(struct block *b, int i))
{
    struct block *b;
    struct insn *insn;
    int i;
    int reg;
    VECTOR(reg) tmp_regs;

    live_analyze(LIVE_ANALYZE_CC);
    INIT_VECTOR(tmp_regs, &local_arena);

    FOR_ALL_BLOCKS(b) {
        active = REG_NONE;

        FOR_EACH_INSN(b, i, insn) {

            if (arith[I_INDEX(insn->op)]) {
                /* this insn sets the arithmetic flags we want.
                   all such insns have the dst in operand[0]. */

                if (OPERAND_REG(&insn->operand[0])) {
                    active = insn->operand[0].reg;
                    active_t = insn->operand[0].t;
                    continue;
                }
            } else if (insn_is_cmpz(insn, &reg) /* on ATOM, CMPx against $0 */
                     && (reg == active)  /* must have the reg in operand[0] */
                     && T_SIMPATICO(active_t, insn->operand[0].t))
            {
                if (f(b, i)) {
                    /* handler says we should nuke the comparison. */

                    INSN(b, i) = &nop_insn;

                    /* we introduced a NOP, so we should PRUNE.
                       we might have shortened the lifetime of
                       a reg, which opens up EARLY possibilities
                       (ANDx -> TESTx) and FUSE options. */

                    opt_request |= OPT_PRUNE | OPT_MCH_EARLY | OPT_MCH_FUSE;
                    continue;
                }
            }

            /* if we neither recorded a new active reg
               nor substituted a comparison, then check
               for invalidation: DEFing the active reg
               or the flags means we must nuke state */

            if (active != REG_NONE) {
                TRUNC_VECTOR(tmp_regs);
                insn_defs(insn, &tmp_regs, I_FLAG_DEFS_CC);

                if (contains_reg(&tmp_regs, REG_CC)
                  || contains_reg(&tmp_regs, active))
                    active = 0;
            }
        }
    }

    ARENA_FREE(&local_arena);
}

/* this is the easier of the two: if we're only interested in whether or not
   the register is equal to zero, then we can nuke the comparison and carry
   on, since it would have the same effect on the state of the Z flag. */

static int cmpz0(struct block *b, int i)
{
    int ccs;
    int znz_ccs;

    ccs = live_ccs(b, i);

    znz_ccs = 0;
    CCSET_SET(znz_ccs, CC_Z);
    CCSET_SET(znz_ccs, CC_NZ);

    if ((ccs & znz_ccs) == ccs)
        return 1;
    else
        return 0;
}

/* this is a bit harder. if we compare a register against 0, and
   are interested if it's L/GE, then the S bit will tell us. we
   can nuke the comparison but, unlike the above, we also have to
   rewrite the L/GE to S/NS in dependent insns or branches. */

#define CMPS0(cc)   ((cc) = ((cc) == CC_L) ? CC_S : CC_NS)

static int cmps0(struct block *b, int i)
{
    int ccs = 0;

    CCSET_SET(ccs, CC_L);
    CCSET_SET(ccs, CC_GE);

    if (live_ccs(b, i) == ccs) {
        int r = range_by_def(b, REG_CC, i);

        /* this logic is structurally similar to the logic in norm.c cmp(),
           because we're doing much the same thing, albeit on MCH insns. */

        while (NEXT_IN_RANGE(b, r)) {
            ++r;    /* pre-increment; skips the placeholder DEF */

            if (RANGE(b, r).use == INSN_INDEX_BRANCH) {
                /* rewrite L/GE branches as S/NS. we intentionally do this
                   manually, in place, rather than using the primitives in
                   block.c because they don't really understand CC_S/CC_NS. */

                int n;

                for (n = 0; n < NR_SUCCS(b); ++n)
                    CMPS0(SUCC(b, n).cc);
            } else {
                struct insn *insn = INSN(b, RANGE(b, r).use);
                int cc;

                if (I_MCH_IS_SETCC(insn->op)) {
                    cc = I_MCH_SETCC_TO_CC(insn->op);
                    CMPS0(cc);
                    insn->op = I_CC_TO_MCH_SETCC(cc);
                } else if (I_MCH_IS_CMOVCCL(insn->op)) {
                    cc = I_MCH_CMOVCCL_TO_CC(insn->op);
                    CMPS0(cc);
                    insn->op = I_CC_TO_MCH_CMOVCCL(cc);
                } else {
                    cc = I_MCH_CMOVCCQ_TO_CC(insn->op);
                    CMPS0(cc);
                    insn->op = I_CC_TO_MCH_CMOVCCQ(cc);
                }
            }
        }

        return 1;
    }

    return 0;
}

void opt_mch_cmp(void) { cmp0(cmpz0); cmp0(cmps0); }

/* vi: set ts=4 expandtab: */
