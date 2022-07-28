/*****************************************************************************

  peep.c                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "opt.h"
#include "block.h"
#include "peep.h"

/* lowering chooses LEA for additions and shifts when possible. if we
   determine that a simple ADD or SHL will suffice, we substitute. as
   the register allocator progresses, new opportunities appear through
   coalsecing (and after final allocation). we want to rewrite these
   insns as soon as we can, mostly because ADD/SHL can be fused.

   LEA doesn't affect the flags, whereas ADD/SHL do, so we can't make the
   substitution if REG_CC is alive across the LEA. on the other hand, if
   we do substitute, OPT_MCH_CMP may have a new opportunity to exploit. */

static void lea0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct operand *ea = &insn->operand[1];     /* O_EA */
    struct operand *dst = &insn->operand[0];    /* O_REG */
    struct insn *new;
    int add, shl, mov;

    if (live_across(b, REG_CC, i)) return;

    switch (insn->op)
    {
    case I_MCH_LEAB:    add = I_MCH_ADDB;
                        shl = I_MCH_SHLB;
                        mov = I_MCH_MOVB;
                        break;

    case I_MCH_LEAW:    add = I_MCH_ADDW;
                        shl = I_MCH_SHLW;
                        mov = I_MCH_MOVW;
                        break;

    case I_MCH_LEAL:    add = I_MCH_ADDL;
                        shl = I_MCH_SHLL;
                        mov = I_MCH_MOVL;
                        break;

    case I_MCH_LEAQ:    add = I_MCH_ADDQ;
                        shl = I_MCH_SHLQ;
                        mov = I_MCH_MOVQ;
                        break;
    }

    if ((ea->reg == dst->reg) && (ea->index == REG_NONE)) {
        /* LEAx c(%dst), %dst -> ADDx $c, %dst.
           (c will already be properly normalized.) */

        new = new_insn(add, 0);
        IMM_OPERAND(&new->operand[1], 0, 0, ea->con, ea->sym);
        goto replace;
    }

    if ((ea->sym == 0) && (ea->con.i == 0)) {
        if ((ea->reg == REG_NONE) && (ea->index == dst->reg)) {
            /* LEAx (,%dst,n), %dst -> SHLx $LOG2(n), %dst */

            new = new_insn(shl, 0);
            I_OPERAND(&new->operand[1], 0, 0, ea->scale);
            goto replace;
        }

        if (ea->scale == 0) {
            if (ea->reg == dst->reg) {
                /* LEAx (%dst,%reg), %dst -> ADDx %reg, %dst */
                new = new_insn(add, 0);
                REG_OPERAND(&new->operand[1], 0, 0, ea->index);
                goto replace;
            }

            if (ea->index == dst->reg) {
                /* LEAx (%reg,%dst), %dst -> ADDx %reg, %dst */
                new = new_insn(add, 0);
                REG_OPERAND(&new->operand[1], 0, 0, ea->reg);
                goto replace;
            }

            if (ea->index == REG_NONE) {
                /* LEAx (%reg), %dst -> MOVx %reg, %dst */
                new = new_insn(mov, 0);
                REG_OPERAND(&new->operand[1], 0, 0, ea->reg);
                goto replace;
            }
        }
    }

    return;

replace:
    REG_OPERAND(&new->operand[0], 0, 0, dst->reg);
    INSN(b, i) = new;
    opt_request |= OPT_MCH_FUSE | OPT_MCH_CMP;
}

/* if we encounter an ANDx insn whose result is tossed, we can
   rewrite as TESTx. because this doesn't require a scratch reg
   this eases pressure and can eliminate unnecessary copies. */

static void and0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct operand *dst = &insn->operand[0];
    int op;

    if (!OPERAND_REG(dst) || !range_doa(b, dst->reg, i))
        return;

    switch (insn->op)
    {
    case I_MCH_ANDB:    op = I_MCH_TESTB; break;
    case I_MCH_ANDW:    op = I_MCH_TESTW; break;
    case I_MCH_ANDL:    op = I_MCH_TESTL; break;
    case I_MCH_ANDQ:    op = I_MCH_TESTQ; break;
    }

    /* and ANDx insns with a reg dst are valid
       TSTx insns, so we can twiddle in place. */

    insn->op = op;
}

/* we leave most peephole optimizations to opt_mch_late(), but some
   substitutions must be interleaved with register allocation (and
   the other interleaved passes) for best results. we call these the
   EARLY substitutions, which are handled here ... */

void opt_mch_early(void)
{
    struct block *b;
    struct insn *insn;
    int i;

    live_analyze(LIVE_ANALYZE_REGS | LIVE_ANALYZE_CC);

    FOR_ALL_BLOCKS(b)
        FOR_EACH_INSN(b, i, insn)
            switch (insn->op)
            {
            case I_MCH_ANDB:
            case I_MCH_ANDW:
            case I_MCH_ANDL:
            case I_MCH_ANDQ:    and0(b, i); break;

            case I_MCH_LEAB:
            case I_MCH_LEAW:
            case I_MCH_LEAL:
            case I_MCH_LEAQ:    lea0(b, i); break;
            }

}

/* map indicating which possible optimizations are available for each
   MCH insn. these entries must be in sync with the handler functions:
   they'll be confused if they see an op they're not prepared for. */

#define XOR0    0x0001      /* MOVx $0,%R -> XORL %R,%R */
#define INC0    0x0002      /* ADDx $1,Y -> INCx Y, et al. */
#define LOAD0   0x0004      /* widen sub-word loads from memory */
#define WIDE0   0x0008      /* widen sub-word operations */
#define CMP0    0x0010      /* replace CMPx $0,%R with TESTx %R,%R */
#define TRUNC0  0x0020      /* truncate MOVQ/ANDQ -> MOVL/ANDL */
#define MUL0    0x0040      /* IMUL -> LEA/ADD/SHL equivalents */

static short peeps[] =      /* indexed by I_INDEX */
{
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  /* LIR */
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,

    0,                                          /*   64  I_MCH_CALL       */
    0,                                          /*   65  I_MCH_RET        */
    0,                                          /*   66  I_MCH_RETI       */
    0,                                          /*   67  I_MCH_RETF       */
    XOR0 | LOAD0 | WIDE0,                       /*   68  I_MCH_MOVB       */
    XOR0 | LOAD0 | WIDE0,                       /*   69  I_MCH_MOVW       */
    XOR0,                                       /*   70  I_MCH_MOVL       */
    XOR0 | TRUNC0,                              /*   71  I_MCH_MOVQ       */
    0,                                          /*   72  I_MCH_MOVSS      */
    0,                                          /*   73  I_MCH_MOVSD      */
    LOAD0,                                      /*   74  I_MCH_MOVZBW     */
    0,                                          /*   75  I_MCH_MOVZBL     */
    0,                                          /*   76  I_MCH_MOVZBQ     */
    LOAD0,                                      /*   77  I_MCH_MOVSBW     */
    0,                                          /*   78  I_MCH_MOVSBL     */
    0,                                          /*   79  I_MCH_MOVSBQ     */
    0,                                          /*   80  I_MCH_MOVZWL     */
    0,                                          /*   81  I_MCH_MOVZWQ     */
    0,                                          /*   82  I_MCH_MOVSWL     */
    0,                                          /*   83  I_MCH_MOVSWQ     */
    0,                                          /*   84  I_MCH_MOVZLQ     */
    0,                                          /*   85  I_MCH_MOVSLQ     */
    0,                                          /*   86  I_MCH_CVTSI2SSL  */
    0,                                          /*   87  I_MCH_CVTSI2SSQ  */
    0,                                          /*   88  I_MCH_CVTSI2SDL  */
    0,                                          /*   89  I_MCH_CVTSI2SDQ  */
    0,                                          /*   90  I_MCH_CVTSS2SIL  */
    0,                                          /*   91  I_MCH_CVTSS2SIQ  */
    0,                                          /*   92  I_MCH_CVTSD2SIL  */
    0,                                          /*   93  I_MCH_CVTSD2SIQ  */
    CMP0,                                       /*   94  I_MCH_CMPB       */
    CMP0,                                       /*   95  I_MCH_CMPW       */
    CMP0,                                       /*   96  I_MCH_CMPL       */
    CMP0,                                       /*   97  I_MCH_CMPQ       */
    0,                                          /*   98  I_MCH_UCOMISS    */
    0,                                          /*   99  I_MCH_UCOMISD    */
    0,                                          /*  100  I_MCH_LEAB       */
    0,                                          /*  101  I_MCH_LEAW       */
    0,                                          /*  102  I_MCH_LEAL       */
    0,                                          /*  103  I_MCH_LEAQ       */
    0,                                          /*  104  I_MCH_NOTB       */
    0,                                          /*  105  I_MCH_NOTW       */
    0,                                          /*  106  I_MCH_NOTL       */
    0,                                          /*  107  I_MCH_NOTQ       */
    0,                                          /*  108  I_MCH_NEGB       */
    0,                                          /*  109  I_MCH_NEGW       */
    0,                                          /*  110  I_MCH_NEGL       */
    0,                                          /*  111  I_MCH_NEGQ       */
    INC0 | WIDE0,                               /*  112  I_MCH_ADDB       */
    INC0 | WIDE0,                               /*  113  I_MCH_ADDW       */
    INC0,                                       /*  114  I_MCH_ADDL       */
    INC0,                                       /*  115  I_MCH_ADDQ       */
    0,                                          /*  116  I_MCH_ADDSS      */
    0,                                          /*  117  I_MCH_ADDSD      */
    INC0 | WIDE0,                               /*  118  I_MCH_SUBB       */
    INC0 | WIDE0,                               /*  119  I_MCH_SUBW       */
    INC0,                                       /*  120  I_MCH_SUBL       */
    INC0,                                       /*  121  I_MCH_SUBQ       */
    0,                                          /*  122  I_MCH_SUBSS      */
    0,                                          /*  123  I_MCH_SUBSD      */
    0,                                          /*  124  I_MCH_IMULB      */
    0,                                          /*  125  I_MCH_IMULW      */
    0,                                          /*  126  I_MCH_IMULL      */
    0,                                          /*  127  I_MCH_IMULQ      */
    MUL0,                                       /*  128  I_MCH_IMUL3W     */
    MUL0,                                       /*  129  I_MCH_IMUL3L     */
    MUL0,                                       /*  130  I_MCH_IMUL3Q     */
    0,                                          /*  131  I_MCH_MULSS      */
    0,                                          /*  132  I_MCH_MULSD      */
    0,                                          /*  133  I_MCH_DIVSS      */
    0,                                          /*  134  I_MCH_DIVSD      */
    0,                                          /*  135  I_MCH_IDIVB      */
    0,                                          /*  136  I_MCH_IDIVW      */
    0,                                          /*  137  I_MCH_IDIVL      */
    0,                                          /*  138  I_MCH_IDIVQ      */
    0,                                          /*  139  I_MCH_DIVB       */
    0,                                          /*  140  I_MCH_DIVW       */
    0,                                          /*  141  I_MCH_DIVL       */
    0,                                          /*  142  I_MCH_DIVQ       */
    0,                                          /*  143  I_MCH_SHRB       */
    0,                                          /*  144  I_MCH_SHRW       */
    0,                                          /*  145  I_MCH_SHRL       */
    0,                                          /*  146  I_MCH_SHRQ       */
    0,                                          /*  147  I_MCH_SARB       */
    0,                                          /*  148  I_MCH_SARW       */
    0,                                          /*  149  I_MCH_SARL       */
    0,                                          /*  150  I_MCH_SARQ       */
    WIDE0,                                      /*  151  I_MCH_SHLB       */
    WIDE0,                                      /*  152  I_MCH_SHLW       */
    0,                                          /*  153  I_MCH_SHLL       */
    0,                                          /*  154  I_MCH_SHLQ       */
    WIDE0,                                      /*  155  I_MCH_ANDB       */
    WIDE0,                                      /*  156  I_MCH_ANDW       */
    0,                                          /*  157  I_MCH_ANDL       */
    TRUNC0,                                     /*  158  I_MCH_ANDQ       */
    WIDE0,                                      /*  159  I_MCH_ORB        */
    WIDE0,                                      /*  160  I_MCH_ORW        */
    0,                                          /*  161  I_MCH_ORL        */
    0,                                          /*  162  I_MCH_ORQ        */
    WIDE0,                                      /*  163  I_MCH_XORB       */
    WIDE0,                                      /*  164  I_MCH_XORW       */
    0,                                          /*  165  I_MCH_XORL       */
    0,                                          /*  166  I_MCH_XORQ       */
    0,                                          /*  167  I_MCH_SETZ       */
    0,                                          /*  168  I_MCH_SETNZ      */
    0,                                          /*  169  I_MCH_SETS       */
    0,                                          /*  170  I_MCH_SETNS      */
    0,                                          /*  171  I_MCH_SETG       */
    0,                                          /*  172  I_MCH_SETLE      */
    0,                                          /*  173  I_MCH_SETGE      */
    0,                                          /*  174  I_MCH_SETL       */
    0,                                          /*  175  I_MCH_SETA       */
    0,                                          /*  176  I_MCH_SETBE      */
    0,                                          /*  177  I_MCH_SETAE      */
    0,                                          /*  178  I_MCH_SETB       */
    0,                                          /*  179  I_MCH_BSFL       */
    0,                                          /*  180  I_MCH_BSFQ       */
    0,                                          /*  181  I_MCH_BSRL       */
    0,                                          /*  182  I_MCH_BSRQ       */
    0,                                          /*  183  I_MCH_MOVSB      */
    0,                                          /*  184  I_MCH_STOSB      */
    0,                                          /*  185  I_MCH_REP        */
    0,                                          /*  186  I_MCH_CBTW       */
    0,                                          /*  187  I_MCH_CWTD       */
    0,                                          /*  188  I_MCH_CLTD       */
    0,                                          /*  189  I_MCH_CQTO       */
    0,                                          /*  190  I_MCH_CVTSS2SD   */
    0,                                          /*  191  I_MCH_CVTSD2SS   */
    0,                                          /*  192  I_MCH_PUSHQ      */
    0,                                          /*  193  I_MCH_POPQ       */
    0,                                          /*  194  I_MCH_TESTB      */
    0,                                          /*  195  I_MCH_TESTW      */
    0,                                          /*  196  I_MCH_TESTL      */
    0,                                          /*  197  I_MCH_TESTQ      */
    0,                                          /*  198  I_MCH_DECB       */
    0,                                          /*  199  I_MCH_DECW       */
    0,                                          /*  200  I_MCH_DECL       */
    0,                                          /*  201  I_MCH_DECQ       */
    0,                                          /*  202  I_MCH_INCB       */
    0,                                          /*  203  I_MCH_INCW       */
    0,                                          /*  204  I_MCH_INCL       */
    0,                                          /*  205  I_MCH_INCQ       */
    0,                                          /*  206  I_MCH_CMOVZL     */
    0,                                          /*  207  I_MCH_CMOVNZL    */
    0,                                          /*  208  I_MCH_CMOVSL     */
    0,                                          /*  209  I_MCH_CMOVNSL    */
    0,                                          /*  210  I_MCH_CMOVGL     */
    0,                                          /*  211  I_MCH_CMOVLEL    */
    0,                                          /*  212  I_MCH_CMOVGEL    */
    0,                                          /*  213  I_MCH_CMOVLL     */
    0,                                          /*  214  I_MCH_CMOVAL     */
    0,                                          /*  215  I_MCH_CMOVBEL    */
    0,                                          /*  216  I_MCH_CMOVAEL    */
    0,                                          /*  217  I_MCH_CMOVBL     */
    0,                                          /*  218  I_MCH_CMOVZQ     */
    0,                                          /*  219  I_MCH_CMOVNZQ    */
    0,                                          /*  220  I_MCH_CMOVSQ     */
    0,                                          /*  221  I_MCH_CMOVNSQ    */
    0,                                          /*  222  I_MCH_CMOVGQ     */
    0,                                          /*  223  I_MCH_CMOVLEQ    */
    0,                                          /*  224  I_MCH_CMOVGEQ    */
    0,                                          /*  225  I_MCH_CMOVLQ     */
    0,                                          /*  226  I_MCH_CMOVAQ     */
    0,                                          /*  227  I_MCH_CMOVBEQ    */
    0,                                          /*  228  I_MCH_CMOVAEQ    */
    0,                                          /*  229  I_MCH_CMOVBQ     */
    0                                           /*  230  I_MCH_ZERO       */
};

/* replace MOVx $0,%reg with XORL %reg, %reg.

   this can't be done in early peep because the IR would see a false
   dependency on the previous value of %reg (though most CPUs do not).
   we wouldn't want to, anyway, because this would prevent fusing.

   MOVs don't affect the flags; XORs do. be on the lookout. */

static int xor0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct insn *new;
    struct operand *dst = &insn->operand[0];
    struct operand *src = &insn->operand[1];

    if (OPERAND_ZERO(src)
      && OPERAND_REG(dst)
      && !live_across(b, REG_CC, i))
    {
        new = new_insn(I_MCH_ZERO, 0);
        REG_OPERAND(&new->operand[0], 0, 0, dst->reg);
        INSN(b, i) = new;
        return 1;
    } else
        return 0;
}

/* replace ADDx $ 1,Y with INCx Y,      these are slightly smaller.
           SUBx $ 1,Y with DECx Y,      some CPUs actually perform
           ADDx $-1,Y with DECx Y,      worse with these vs. their
           SUBx $-1,Y with INCx Y.      ADD/SUB equivalents. eyeroll.

   no need to worry about the flags: INC/DEC don't affect carry but
   we never examine carry. Z and S are set identically, so from our
   perspective the effect on the flags is identical. */

static int inc0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct insn *new;
    struct operand *dst = &insn->operand[0];
    struct operand *src = &insn->operand[1];
    int op;

    if (OPERAND_ONE(src)) {
        switch (insn->op)
        {
        case I_MCH_ADDB: op = I_MCH_INCB; break;
        case I_MCH_ADDW: op = I_MCH_INCW; break;
        case I_MCH_ADDL: op = I_MCH_INCL; break;
        case I_MCH_ADDQ: op = I_MCH_INCQ; break;
        case I_MCH_SUBB: op = I_MCH_DECB; break;
        case I_MCH_SUBW: op = I_MCH_DECW; break;
        case I_MCH_SUBL: op = I_MCH_DECL; break;
        case I_MCH_SUBQ: op = I_MCH_DECQ; break;
        }
    } else if (OPERAND_NEG1(src)) {
        switch (insn->op)
        {
        case I_MCH_ADDB: op = I_MCH_DECB; break;
        case I_MCH_ADDW: op = I_MCH_DECW; break;
        case I_MCH_ADDL: op = I_MCH_DECL; break;
        case I_MCH_ADDQ: op = I_MCH_DECQ; break;
        case I_MCH_SUBB: op = I_MCH_INCB; break;
        case I_MCH_SUBW: op = I_MCH_INCW; break;
        case I_MCH_SUBL: op = I_MCH_INCL; break;
        case I_MCH_SUBQ: op = I_MCH_INCQ; break;
        }
    } else
        return 0;

    new = new_insn(op, 0);
    MCH_OPERAND(&new->operand[0], dst);
    INSN(b, i) = new;
    return 1;
}

/* when loading a char/short from memory, force it to
   be zero- or sign-extended to cover the full target
   register to avoid unnecessary partial register stalls. */

static int load0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct insn *new;
    struct operand *dst = &insn->operand[0];
    struct operand *src = &insn->operand[1];
    int op;

    if (!OPERAND_REG(dst)) return 0;
    if (!OPERAND_MEM(src)) return 0;

    switch (insn->op)
    {
    case I_MCH_MOVB:    op = I_MCH_MOVZBL; break;
    case I_MCH_MOVW:    op = I_MCH_MOVZWL; break;
    case I_MCH_MOVSBW:  op = I_MCH_MOVSBL; break;
    case I_MCH_MOVZBW:  op = I_MCH_MOVZBL; break;
    }

    new = new_insn(op, 0);
    MCH_OPERAND(&new->operand[0], dst);
    MCH_OPERAND(&new->operand[1], src);
    INSN(b, i) = new;
    return 1;
}

/* unless we're interested in the resulting condition codes, or are
   consulting a memory operand, there is little reason to perform
   most operations in less-than-32-bit sizes. any cost in enlarged
   encoding (not always the case!) is supposedly paid for by the
   avoidance of partial register stalls and/or decoding hiccups. */

static int wide0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct insn *new;
    struct operand *dst = &insn->operand[0];
    struct operand *src = &insn->operand[1];
    int op;

    if (!OPERAND_REG(dst)) return 0;
    if (OPERAND_MEM(src)) return 0;
    if (INSN_DEFS_CC(insn) && !range_doa(b, REG_CC, i)) return 0;

    switch (insn->op)
    {
    case I_MCH_MOVB:
    case I_MCH_MOVW:    op = I_MCH_MOVL; break;

    case I_MCH_ADDB:
    case I_MCH_ADDW:    op = I_MCH_ADDL; break;

    case I_MCH_SUBB:
    case I_MCH_SUBW:    op = I_MCH_SUBL; break;

    case I_MCH_SHLB:
    case I_MCH_SHLW:    op = I_MCH_SHLL; break;

    case I_MCH_ANDB:
    case I_MCH_ANDW:    op = I_MCH_ANDL; break;

    case I_MCH_XORB:
    case I_MCH_XORW:    op = I_MCH_XORL; break;

    case I_MCH_ORB:
    case I_MCH_ORW:     op = I_MCH_ORL; break;
    }

    new = new_insn(op, 0);
    MCH_OPERAND(&new->operand[0], dst);
    MCH_OPERAND(&new->operand[1], src);
    INSN(b, i) = new;

    return 1;
}

/* replace CMPx $0,%R with TESTx %R,%R, when
   our only interest is the Z or S flag.

   this is just an equivalent with a smaller encoding.
   it occurs frequently enough to warrant replacement. */

static int cmp0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct insn *new;
    int reg;

    if (insn_is_cmpz(insn, &reg)) {
        int ccs = live_ccs(b, i);
        int zs_ccs = 0;
        int op;

        CCSET_SET(zs_ccs, CC_Z); CCSET_SET(zs_ccs, CC_NZ);
        CCSET_SET(zs_ccs, CC_S); CCSET_SET(zs_ccs, CC_NS);

        if ((ccs & zs_ccs) != ccs)
            return 0;

        switch (insn->op)
        {
        case I_MCH_CMPB:    op = I_MCH_TESTB; break;
        case I_MCH_CMPW:    op = I_MCH_TESTW; break;
        case I_MCH_CMPL:    op = I_MCH_TESTL; break;
        case I_MCH_CMPQ:    op = I_MCH_TESTQ; break;
        }

        new = new_insn(op, 0);
        REG_OPERAND(&new->operand[0], 0, 0, reg);
        REG_OPERAND(&new->operand[1], 0, 0, reg);
        INSN(b, i) = new;

        return 1;
    } else
        return 0;
}

/* take advantage of the automatic zero extension the
   CPU applies when a register is written as 32 bits.
   if 0 <= imm <= UINT_MAX, then

        ANDQ $imm, %R       ->      ANDL $imm, %R
        MOVQ $imm, %R       ->      MOVL $imm, %R

   we renormalize the imm in case it exceeds INT_MAX,
   making it appear negative to shut up the assembler.

   because of the assumption of our memory model that
   all globals be <2GB, the immediate need not be pure. */

static int trunc0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct insn *new;
    struct operand *dst = &insn->operand[0];
    struct operand *src = &insn->operand[1];

    if (!OPERAND_REG(dst)) return 0;

    if (!OPERAND_IMM(src)
      || (src->con.i < 0)
      || (src->con.i > UINT_MAX))
        return 0;

    new = new_insn((insn->op == I_MCH_ANDQ) ? I_MCH_ANDL : I_MCH_MOVL, 0);
    MCH_OPERAND(&new->operand[0], dst);
    MCH_OPERAND(&new->operand[1], src);
    new->operand[1].con.i = (int) new->operand[1].con.i;
    INSN(b, i) = new;

    return 1;
}

/* multiplication by an immediate value can often be replaced by
   a short combination of LEA and/or alu insns which compute the
   equivalent. IMULx trash the flags, so we have free reign. */

static int mul0(struct block *b, int i)
{
    struct insn *insn = INSN(b, i);
    struct insn *new;
    struct operand *dst = &insn->operand[0];    /* always O_REG */
    struct operand *src = &insn->operand[1];    /* need O_REG here */
    struct operand *con = &insn->operand[2];    /* always O_IMM */
    int lea, shl, add;
    int scale, shift;   /* remember: scale is log2 */

    if (!OPERAND_REG(src)) return 0;    /* leave memory operands alone */

    switch (insn->op)
    {
    case I_MCH_IMUL3W:  lea = I_MCH_LEAW;
                        shl = I_MCH_SHLW;
                        add = I_MCH_ADDW;
                        break;

    case I_MCH_IMUL3L:  lea = I_MCH_LEAL;
                        shl = I_MCH_SHLL;
                        add = I_MCH_ADDL;
                        break;

    case I_MCH_IMUL3Q:  lea = I_MCH_LEAQ;
                        shl = I_MCH_SHLQ;
                        add = I_MCH_ADDQ;
    }

    switch (con->con.i)
    {
    case 3:     scale = 1; shift = 0; goto lea_shl;
    case 10:    scale = 2; shift = 1; goto lea_shl;
    case 12:    scale = 1; shift = 2; goto lea_shl;
    case 24:    scale = 1; shift = 3; goto lea_shl;
    case 40:    scale = 2; shift = 3; goto lea_shl;
    default:    return 0;
    }

    /* imulX $con, %src, %dst  ->  leaX (%src,%src*scale), %dst
                                   shlX $shift, %dst

                               OR  leaX (%src,%src*scale), %dst
                                   addX %dst, %dst (when shift == 1)

                               OR  leaX (%src,%src*scale), %dst
                                   (when shift == 0)

       this pattern is safe whether %src and %dst are the same or distinct */

lea_shl:
    new = new_insn(lea, 0);
    REG_OPERAND(&new->operand[0], 0, 0, dst->reg);
    INDEX_OPERAND(&new->operand[1], 0, 0, O_EA, src->reg, scale);
    new->operand[1].reg = src->reg;
    insert_insn(new, b, i++);

    if (shift == 1) {
        new = new_insn(add, 0);
        REG_OPERAND(&new->operand[0], 0, 0, dst->reg);
        REG_OPERAND(&new->operand[1], 0, 0, dst->reg);
        insert_insn(new, b, i++);
    } else if (shift > 0) {
        new = new_insn(shl, 0);
        REG_OPERAND(&new->operand[0], 0, 0, dst->reg);
        I_OPERAND(&new->operand[1], 0, 0, shift);
        insert_insn(new, b, i++);
    }

    delete_insn(b, i);
    return 1;
}

/* LATE peephole optimizations are done almost immediately before
   the function is output. these transformations produce [almost]
   semantically-identical behavior, but result in sequences that
   would be confusing to earlier passes and/or do not expose any
   additional opportunities the way that the EARLY peeps do.

   opt_mch_late() is followed in short order by lower_more(); the
   difference is the opt_mch_late() substitutions are optional. */

void opt_mch_late(void)
{
    struct block *b;
    struct insn *insn;
    int i;
    int peep;

    /* the first group do not care about/affect the state of
       the condition codes, so they do not need live data and
       can be fairly intrusive with their changes */

    FOR_ALL_BLOCKS(b)
        /* we don't use FOR_EACH_INSN because we
           reexamine after a replacement, in which
           case we need to reload insn anyway. */

        for (i = 0; i < NR_INSNS(b); ++i) {
nocc:
            insn = INSN(b, i);
            peep = peeps[I_INDEX(insn->op)];

            if ((peep & INC0)       && inc0(b, i))      goto nocc;
            if ((peep & MUL0)       && mul0(b, i))      goto nocc;
            if ((peep & LOAD0)      && load0(b, i))     goto nocc;
            if ((peep & TRUNC0)     && trunc0(b, i))    goto nocc;
        }

    /* the second group need the live data for REG_CC. it is
       important that they preserve its validity, since we do
       not currently do not invalidate on replacement. */

    live_analyze(LIVE_ANALYZE_CC);

    FOR_ALL_BLOCKS(b)
        for (i = 0; i < NR_INSNS(b); ++i) {
needcc:
            insn = INSN(b, i);
            peep = peeps[I_INDEX(insn->op)];

            if ((peep & XOR0)       && xor0(b, i))      goto needcc;
            if ((peep & WIDE0)      && wide0(b, i))     goto needcc;
            if ((peep & CMP0)       && cmp0(b, i))      goto needcc;
        }
}

/* vi: set ts=4 expandtab: */
