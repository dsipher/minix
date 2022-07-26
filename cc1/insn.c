/*****************************************************************************

  insn.c                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "reg.h"
#include "lex.h"
#include "func.h"
#include "fold.h"
#include "heap.h"
#include "insn.h"

struct insn nop_insn = { I_NOP };

/* keyed to the values of the CC_* constants */

const char * const cc_text[] =
{
    "jz",   "jnz",  "js",   "jns",  "jg",   "jle",
    "jge",  "jl",   "ja",   "jbe",  "jae",  "jb",
    "jmp"   /* CC_NEVER .. CC_SWITCH not present */
};

/* we never attempt to commute CC_S or CC_NS
   since they don't arise from I_LIR_CMP */

const char commuted_cc[] =
{
    CC_Z,   CC_NZ,  0,      0,      CC_L,   CC_GE,
    CC_LE,  CC_G,   CC_B,   CC_AE,  CC_BE,  CC_A
};

/* table of union (or) and intersection (and) of condition codes for
   union_cc() and intersect_cc(). this excludes identities and other
   properties handled in those functions.

   we do not account for cases that 'cannot happen', like attempting
   to combine CC_A and CC_LE somehow. the LIR semantics never offer
   occasions where we'd need to do so- that would be a compiler bug.

   there is a clever way to do this by choosing CC_* values carefully:
   e.g., if CC_NEVER, CC_G, CC_Z, CC_AE, CC_B, CC_NZ, CC_BE, CC_ALWAYS
   are given the values 0..7 sequentially, then intersection and union
   are bitwise and and or, respectively. inverting a condition becomes
   a bitwise complement. unfortunately this scheme is not as elegant
   for us as we have to account for two different sets of conditions. */

static const struct { char cc[2]; char or; char and; } ccops[] =
{
    {   CC_G,   CC_Z,               CC_GE,          CC_NEVER    },
    {   CC_G,   CC_GE,              CC_GE,          CC_G        },
    {   CC_G,   CC_L,               CC_NZ,          CC_NEVER    },
    {   CC_G,   CC_NZ,              CC_NZ,          CC_G        },
    {   CC_G,   CC_LE,              CC_ALWAYS,      CC_NEVER    },
    {   CC_Z,   CC_GE,              CC_GE,          CC_Z        },
    {   CC_Z,   CC_L,               CC_LE,          CC_NEVER    },
    {   CC_Z,   CC_NZ,              CC_ALWAYS,      CC_NEVER    },
    {   CC_Z,   CC_LE,              CC_LE,          CC_Z        },
    {   CC_GE,  CC_L,               CC_ALWAYS,      CC_NEVER    },
    {   CC_GE,  CC_NZ,              CC_ALWAYS,      CC_G        },
    {   CC_GE,  CC_LE,              CC_ALWAYS,      CC_Z        },
    {   CC_L,   CC_NZ,              CC_NZ,          CC_L        },
    {   CC_L,   CC_LE,              CC_LE,          CC_L        },
    {   CC_NZ,  CC_LE,              CC_ALWAYS,      CC_L        },

    {   CC_A,   CC_Z,               CC_AE,          CC_NEVER    },
    {   CC_A,   CC_AE,              CC_AE,          CC_A        },
    {   CC_A,   CC_B,               CC_NZ,          CC_NEVER    },
    {   CC_A,   CC_NZ,              CC_NZ,          CC_A        },
    {   CC_A,   CC_BE,              CC_ALWAYS,      CC_NEVER    },
    {   CC_Z,   CC_AE,              CC_AE,          CC_Z        },
    {   CC_Z,   CC_B,               CC_BE,          CC_NEVER    },
    {   CC_Z,   CC_NZ,              CC_ALWAYS,      CC_NEVER    },
    {   CC_Z,   CC_BE,              CC_BE,          CC_Z        },
    {   CC_AE,  CC_B,               CC_ALWAYS,      CC_NEVER    },
    {   CC_AE,  CC_NZ,              CC_ALWAYS,      CC_A        },
    {   CC_AE,  CC_BE,              CC_ALWAYS,      CC_Z        },
    {   CC_B,   CC_NZ,              CC_NZ,          CC_B        },
    {   CC_B,   CC_BE,              CC_BE,          CC_B        },
    {   CC_NZ,  CC_BE,              CC_ALWAYS,      CC_B        }
};

#define CCOPS0(which)                                                       \
    ({                                                                      \
        int _i;                                                             \
        int _cc;                                                            \
                                                                            \
        for (_i = 0; _i < ARRAY_SIZE(ccops); ++_i)                          \
        if (((cc1 == ccops[_i].cc[0]) && (cc2 == ccops[_i].cc[1]))          \
          || ((cc2 == ccops[_i].cc[0]) && (cc1 == ccops[_i].cc[1])))        \
        {                                                                   \
            _cc = ccops[_i].which;                                          \
            break;                                                          \
        }                                                                   \
                                                                            \
        (_cc);                                                              \
    })

int union_cc(int cc1, int cc2)
{
    if (cc1 == INVERT_CC(cc2)) return CC_ALWAYS;        /* a V ~a = T */
    if (cc1 == cc2) return cc1;                         /* a V a = a */
    if (cc1 == CC_NEVER) return cc2;                    /* a V F = a */
    if (cc2 == CC_NEVER) return cc1;                    /* F V a = a */

    if ((cc1 == CC_ALWAYS) || (cc2 == CC_ALWAYS))       /* a V T = T */
        return CC_ALWAYS;                               /* T V a = T */

    return CCOPS0(or);
}

int intersect_cc(int cc1, int cc2)
{
    if (cc1 == INVERT_CC(cc2)) return CC_NEVER;         /* a ^ ~a = F */
    if (cc1 == cc2) return cc1;                         /* a ^ a = a */
    if (cc1 == CC_ALWAYS) return cc2;                   /* a ^ T = a */
    if (cc2 == CC_ALWAYS) return cc1;                   /* T ^ a = a */

    if ((cc1 == CC_NEVER) || (cc2 == CC_NEVER))         /* a ^ F = F */
        return CC_NEVER;                                /* F ^ a = F */

    return CCOPS0(and);
}

/* LIR mnemonics are in ALL CAPS to distiguish them from
   MCH mnemonics, which are lowercase since as requires it. */

static const char * const insn_text[] =
{
    /*   0 */   "NOP",          /* ASM */ 0,    /* .line */ 0,  "FRAME",
    /*   4 */   "LOAD",         "STORE",        /* CALL */ 0,   "ARG",
    /*   8 */   "RETURN",       "MOVE",         "CAST",         "CMP",
    /*  12 */   "NEG",          "COM",          "ADD",          "SUB",
    /*  16 */   "MUL",          "DIV",          "MOD",          "SHR",
    /*  20 */   "SHL",          "AND",          "OR",           "XOR",
    /*  24 */   "SETZ",         "SETNZ",        "SETS",         "SETNS",
    /*  28 */   "SETG",         "SETLE",        "SETGE",        "SETL",
    /*  32 */   "SETA",         "SETBE",        "SETAE",        "SETB",
    /*  36 */   "BSF",          "BSR",          "BLKCPY",       "BLKSET",
    /*  40 */   0,              0,              0,              0,
    /*  44 */   0,              0,              0,              0,
    /*  48 */   0,              0,              0,              0,
    /*  52 */   0,              0,              0,              0,
    /*  56 */   0,              0,              0,              0,
    /*  60 */   0,              0,              0,              0,

    /*  64 */   "call",         "ret",          "ret",          "ret",
    /*  68 */   "movb",         "movw",         "movl",         "movq",
    /*  72 */   "movss",        "movsd",        "movzbw",       "movzbl",
    /*  76 */   "movzbq",       "movsbw",       "movsbl",       "movsbq",
    /*  80 */   "movzwl",       "movzwq",       "movswl",       "movswq",
    /*  84 */   "MOVZLQ",       "movslq",       "cvtsi2ssl",    "cvtsi2ssq",
    /*  88 */   "cvtsi2sdl",    "cvtsi2sdq",    "cvttss2sil",   "cvttss2siq",
    /*  92 */   "cvttsd2sil",   "cvttsd2siq",   "cmpb",         "cmpw",
    /*  96 */   "cmpl",         "cmpq",         "ucomiss",      "ucomisd",
    /* 100 */   "LEAB",         "leaw",         "leal",         "leaq",
    /* 104 */   "notb",         "notw",         "notl",         "notq",
    /* 108 */   "negb",         "negw",         "negl",         "negq",
    /* 112 */   "addb",         "addw",         "addl",         "addq",
    /* 116 */   "addss",        "addsd",        "subb",         "subw",
    /* 120 */   "subl",         "subq",         "subss",        "subsd",
    /* 124 */   "imulb",        "imulw",        "imull",        "imulq",
    /* 128 */   "imulw",        "imull",        "imulq",        "mulss",
    /* 132 */   "mulsd",        "divss",        "divsd",        "idivb",
    /* 136 */   "idivw",        "idivl",        "idivq",        "divb",
    /* 140 */   "divw",         "divl",         "divq",         "shrb",
    /* 144 */   "shrw",         "shrl",         "shrq",         "sarb",
    /* 148 */   "sarw",         "sarl",         "sarq",         "shlb",
    /* 152 */   "shlw",         "shll",         "shlq",         "andb",
    /* 156 */   "andw",         "andl",         "andq",         "orb",
    /* 160 */   "orw",          "orl",          "orq",          "xorb",
    /* 164 */   "xorw",         "xorl",         "xorq",         "setz",
    /* 168 */   "setnz",        "sets",         "setns",        "setg",
    /* 172 */   "setle",        "setge",        "setl",         "seta",
    /* 176 */   "setbe",        "setae",        "setb",         "bsfl",
    /* 180 */   "bsfq",         "bsrl",         "bsrq",         "movsb",
    /* 184 */   "stosb",        "rep",          "cbtw",         "cwtd",
    /* 188 */   "cltd",         "cqto",         "cvtss2sd",     "cvtsd2ss",
    /* 192 */   "pushq",        "popq",         "testb",        "testw",
    /* 196 */   "testl",        "testq",        "decb",         "decw",
    /* 200 */   "decl",         "decq",         "incb",         "incw",
    /* 204 */   "incl",         "incq",         "cmovzl",       "cmovnzl",
    /* 208 */   "cmovsl",       "cmovnsl",      "cmovgl",       "cmovlel",
    /* 212 */   "cmovgel",      "cmovll",       "cmoval",       "cmovbel",
    /* 216 */   "cmovael",      "cmovbl",       "cmovzq",       "cmovnzq",
    /* 220 */   "cmovsq",       "cmovnsq",      "cmovgq",       "cmovleq",
    /* 224 */   "cmovgeq",      "cmovlq",       "cmovaq",       "cmovbeq",
    /* 228 */   "cmovaeq",      "cmovbq",       "ZERO"
};

struct insn *new_insn(int op, int nr_args)
{
    struct insn *insn;

    ARENA_ALIGN(&func_arena, UNIVERSAL_ALIGN);

    switch (op)
    {
    case I_ASM:
        {
            struct asm_insn *asm_insn;

            asm_insn = ARENA_ALLOC(&func_arena, sizeof(struct asm_insn));
            __builtin_memset(asm_insn, 0, sizeof(struct asm_insn));
            INIT_VECTOR(asm_insn->uses, &func_arena);
            INIT_VECTOR(asm_insn->defs, &func_arena);

            insn = (struct insn *) asm_insn;
            break;
        }

    case I_LINE:
        {
            struct line_insn *line_insn;

            line_insn = ARENA_ALLOC(&func_arena, sizeof(struct line_insn));
            __builtin_memset(line_insn, 0, sizeof(struct line_insn));
            line_insn->path = path;
            line_insn->line_no = line_no;

            insn = (struct insn *) line_insn;
            break;
        }

    default:
        {
            int i = I_OPERANDS(op) + nr_args;
            size_t size = sizeof(struct insn) + i * sizeof(struct operand);

            insn = ARENA_ALLOC(&func_arena, size);
            __builtin_memset(insn, 0, size);
            insn->nr_args = nr_args;

            for (i = I_OPERANDS(op); i--; )
                insn->operand[i].t = T_INDEX_BASE(I_TYPE(op, i));

            break;
        }
    }

    insn->op = op;
    return insn;
}

/* piggybacking on top of new_insn() is slightly cleaner than doing
   everything ourselves, but slightly less efficient. dup_insn() is
   hardly a hotspot- if that changes, we can/should refactor. */

struct insn *dup_insn(struct insn *src)
{
    struct insn *insn;

    insn = new_insn(src->op, src->nr_args);
    *insn = *src; /* n.b., does not copy payload */

    switch (insn->op)
    {
    case I_ASM:
        {
            struct asm_insn *asm_insn = (struct asm_insn *) insn;
            struct asm_insn *src_asm_insn = (struct asm_insn *) src;

            asm_insn->text = src_asm_insn->text;
            DUP_VECTOR(asm_insn->uses, src_asm_insn->uses);
            DUP_VECTOR(asm_insn->defs, src_asm_insn->defs);

            break;
        }

    case I_LINE:
        {
            /* it's hard to see what possible good could come from
               copying an I_LINE, or under what circumstances that
               might arise (-g + optimization?) but we'll do it... */

            struct line_insn *line_insn;
            struct line_insn *src_line_insn = (struct line_insn *) src;

            line_insn->path = src_line_insn->path;
            line_insn->line_no = src_line_insn->line_no;

            break;
        }

    default:
        __builtin_memcpy(insn->operand, src->operand,
                         (I_OPERANDS(insn->op) + insn->nr_args)
                            * sizeof(struct operand));
    }

    return insn;
}

void commute_insn(struct insn *insn)
{
    switch (insn->op)
    {
    case I_LIR_ADD:
    case I_LIR_MUL:
    case I_LIR_AND:
    case I_LIR_OR:
    case I_LIR_XOR:         SWAP(struct operand, insn->operand[1],
                                                 insn->operand[2]);
    }
}

/* clean up and normalize an operand.

   cleaning up means zeroing unused fields. (normally, fields
   not relevant to the operand class/type are filled with junk).

   normalize in this case means

        1. selecting the appropriate class. an O_EA operand which
           consists solely of one register term is really an O_REG;
           similarly an O_EA which references no registers is O_IMM.

        2. if only one register is used in an O_EA or O_MEM, and it
           is not scaled, then it must be the base register (reg). */

void normalize_operand(struct operand *o)
{
    if (o->t != T_STRUN) {
        o->size = 0;
        o->align = 0;
    }

    switch (o->class)
    {
    case O_IMM:     o->reg = REG_NONE;
                    o->index = REG_NONE;
                    o->scale = 0;
                    break;

    case O_REG:     o->index = REG_NONE;
                    o->scale = 0;
                    o->con.i = 0;
                    o->sym = 0;
    }

    if ((o->index != REG_NONE)      /* single unscaled register */
      && (o->scale == 0)            /* is always the base reg */
      && (o->reg == REG_NONE))
    {
        o->reg = o->index;
        o->index = REG_NONE;
    }

    if (o->class != O_MEM) {
        o->class = O_EA;

        if ((o->reg == REG_NONE)        /* no registers at all */
          && (o->index == REG_NONE))    /* must be a constant */
            o->class = O_IMM;

        if ((o->reg != REG_NONE)        /* if only references a */
          && (o->index == REG_NONE)     /* register, must be O_REG */
          && (o->con.i == 0)
          && (o->sym == 0))
            o->class = O_REG;
    }
}


/* same_operand() and same_insn() are unfortunately
   pretty slow because of the bitfields. we try to
   keep the number of fields checked to a minimum */

int same_operand(struct operand *o1, struct operand *o2)
{
    if (o1->class != o2->class) return 0;
    if (o1->class == O_NONE) return 1;
    if (o1->t != o2->t) return 0;

    if (o1->t & T_STRUN) {
        if (o1->size != o2->size) return 0;
        if (o1->align != o2->align) return 0;
    }

    switch (o1->class)
    {
    case O_REG:     if (o1->reg != o2->reg) return 0;
                    break;

    case O_MEM:
    case O_EA:      if (o1->reg != o2->reg) return 0;
                    if (o1->index != o2->index) return 0;
                    if (o1->scale != o2->scale) return 0;

                    /* FALLTHRU */

    case O_IMM:     /* this has been repeated in many places, but again:
                       comparing con.i for equality also works for floats */

                    if (o1->con.i != o2->con.i) return 0;
                    if (o1->sym != o2->sym) return 0;
                    break;
    }

    return 1;
}

int same_insn(struct insn *insn1, struct insn *insn2)
{
    int m, n;

    if (insn1->op != insn2->op) return 0;
    if (insn1->is_volatile != insn2->is_volatile) return 0;

    switch (insn1->op)
    {
    case I_ASM:
        if (insn1->uses_mem != insn2->uses_mem) return 0;
        if (insn1->defs_mem != insn2->defs_mem) return 0;
        if (insn1->defs_cc != insn2->defs_cc) return 0;

        {
            struct asm_insn *asm_insn1 = (struct asm_insn *) insn1;
            struct asm_insn *asm_insn2 = (struct asm_insn *) insn2;

            if (asm_insn1->text != asm_insn2->text) return 0;
            if (!same_regmap(&asm_insn1->uses, &asm_insn2->uses)) return 0;
            if (!same_regmap(&asm_insn1->defs, &asm_insn2->defs)) return 0;
        }

        break;

    case I_LIR_CALL:
        if (insn1->nr_args != insn2->nr_args) return 0;
        if (insn1->is_variadic != insn2->is_variadic) return 0;
        break;

    case I_MCH_CALL:
        if (insn1->nr_iargs != insn2->nr_iargs) return 0;
        if (insn1->nr_fargs != insn2->nr_fargs) return 0;
        break;
    }

    m = I_OPERANDS(insn1->op) + insn1->nr_args;

    for (n = 0; n < m; ++n)
        if (!same_operand(&insn1->operand[n], &insn2->operand[n]))
            return 0;

    return 1;
}

/* when the operand names the target of a I_MCH_CALL or I_MCH_JMP,
   (rel == 1), then O_IMM really means a relative operand, and no
   $ prefix is permitted. O_MEM still means O_MEM, but the assembler
   requires a * prefix to distinguish it from a relative operand,
   even when it can't possibly be confused (for historical reasons). */

void out_operand(struct operand *o, int rel)
{
    switch (o->class)
    {
    case O_REG:     if (rel) OUTC('*');
                    out("%R", o->reg, o->t);
                    break;

    case O_IMM:     if (!rel) OUTC('$');

                    if (o->t & T_FLOATING)
                        out("%f", o->con.f);
                    else
                        out("%G", o->sym, o->con.i);

                    break;

    case O_EA:
    case O_MEM:     if (rel) OUTC('*');

                    /* when we express an int > INT_MAX as an unsigned
                       quantity in a memory address, gas always thinks
                       it's out-of range, even in an LEAL where we're
                       tossing the upper bits; so we force such values
                       to their signed representation. (we can modify
                       the operand in place since this is the last time
                       it'll be used before it's garbage-collected.) */

                    if (o->t & T_INTS) o->con.i = (int) o->con.i;

                    if (o->sym || o->con.i || !(o->reg || o->index))
                        out("%G", o->sym, o->con.i);

                    if (o->reg || o->index) {
                        OUTC('(');
                        if (o->reg) out("%r", o->reg);
                        if (o->index) out(",%r", o->index);
                        if (o->scale) out(",%d", 1 << o->scale);
                        OUTC(')');
                    } else
                        OUTS("(%rip)");

                    break;
    }
}

void out_ccs(int ccs)
{
    static const char *text[] = {   "Z",    "NZ",   "S",    "NS",
                                    "G",    "LE",   "GE",   "L",
                                    "A",    "BE",   "AE",   "B"     };

    int cc;

    OUTS("[ ");

    for (cc = 0; cc < ARRAY_SIZE(text); ++cc)
        if (CCSET_IS_SET(ccs, cc))
            out("%s ", text[cc]);

    OUTC(']');
}

/* nothing complex here, just lots of annoying formatting. much of the
   output is for debugging only, and can be removed or made optional. */

void out_insn(struct insn *insn)
{
    int op = insn->op;
    int i;

    switch (op)
    {
    case I_ASM:
        {
            struct asm_insn *asm_insn = (struct asm_insn *) insn;

#ifdef DEBUG
            OUTS("; __asm ");
            out_regmap(&asm_insn->uses);
            OUTC('\n');
#endif /* DEBUG */

            out("%S", asm_insn->text);

#ifdef DEBUG
            out("\n; end __asm ", asm_insn->text);
            out_regmap(&asm_insn->defs);
#endif /* DEBUG */

            out("\n");
            break;
        }

#ifndef DEBUG
    case I_NOP:         /* if we're not debugging, */
        return;         /* suppress output of NOPs */
#endif /* !DEBUG */

    case I_LINE:
        {
            /* we remember the path from the last .line directive and
               omit it if unchanged to keep the noise to a minimum */

            static struct string *last_path;

            struct line_insn *line_insn = (struct line_insn *) insn;

            out("\t.line %d", line_insn->line_no);

            if (line_insn->path != last_path) {
                out(",\"%S\"", line_insn->path);
                last_path = path;
            }

            break;
        }

    case I_LIR_CALL:
        OUTS("\tCALL ");
        out_operand(&insn->operand[1], 1);
        OUTC('(');

        if (insn->nr_args)
            for (i = 0; i < insn->nr_args; ++i) {
                if (i) OUTC(',');
                out_operand(&insn->operand[2 + i], 0);

                if (insn->operand[2 + i].t & T_STRUN) {
                    out(" <%d:%d>", insn->operand[2 + i].size,
                                    insn->operand[2 + i].align);
                }
            }

        OUTC(')');

        if (insn->operand[0].class != O_NONE) {
            OUTC(',');
            out_operand(&insn->operand[0], 0);
        }

        break;

    case I_MCH_ZERO:        /* yuck */
        OUTS("\txorl ");
        out_operand(&insn->operand[0], 0);
        OUTC(',');
        out_operand(&insn->operand[0], 0);
        break;

    default:
        out("\t%s ", insn_text[I_INDEX(op)]);

        for (i = I_OPERANDS(op); i--; ) {
            out_operand(&insn->operand[i], insn->op == I_MCH_CALL);
            if (i) OUTC(',');
        }

        break;
    }

#ifdef DEBUG

    {
        static VECTOR(reg) regs;

        if (regs.arena == 0)
            INIT_VECTOR(regs, &global_arena);

        RESIZE_VECTOR(regs, 0);
        OUTS("\t\t; USE ");
        insn_uses(insn, &regs, I_FLAG_USES_CC | I_FLAG_USES_MEM);
        out_regs(&regs);

        OUTS(" DEF ");
        RESIZE_VECTOR(regs, 0);
        insn_defs(insn, &regs, I_FLAG_DEFS_CC | I_FLAG_DEFS_MEM);
        out_regs(&regs);

        if (insn->is_variadic) OUTS(" is_variadic");
        if (insn->is_volatile) OUTS(" is_volatile");
    }

#endif /* DEBUG */

    OUTC('\n');
}

/* insn_defs_cc0/insn_uses_mem0/insn_defs_mem0 rely on
   the wrapper macros to check for the I_FLAG_* shortcuts */

int insn_defs_cc0(struct insn *insn)
{
    switch (insn->op)
    {
    case I_ASM:         return insn->defs_cc;

    case I_LIR_NEG:     /* the SSE operations will not */
    case I_LIR_ADD:     /* affect the condition codes, */
    case I_LIR_SUB:     /* but the GP operations do... */
    case I_LIR_MUL:
    case I_LIR_DIV:     if (insn->operand[0].t & T_DISCRETE)
                            return 1;
                        else
                            return 0;
    }

    return 0;
}

/* insn_uses_mem0/insn_defs_mem0 do not need to account for the
   nr_args extra operands of I_LIR_CALL, because they never get
   to these functions; they are I_FLAG_USE_MEM/I_FLAG_DEF_MEM */

int insn_uses_mem0(struct insn *insn)
{
    int i;

    switch (insn->op)
    {
    case I_ASM:     return insn->uses_mem;
    }

    i = 0;

    if (insn->op & I_FLAG_HAS_DST)              /* skip first operand */
        i = !((insn->op) & I_FLAG_USES_DST);    /* if it is not USEd */

    for (; i < I_OPERANDS(insn->op); ++i)
        if (insn->operand[i].class == O_MEM)
            return 1;

    return 0;
}

int insn_defs_mem0(struct insn *insn)
{
    switch (insn->op)
    {
    case I_ASM:     return insn->defs_mem;
    }

    if ((insn->op & I_FLAG_HAS_DST) && (insn->operand[0].class == O_MEM))
        return 1;

    return 0;
}

void insn_uses(struct insn *insn, VECTOR(reg) *set, int flags)
{
    int i, n;

    if ((flags & I_FLAG_USES_CC) && INSN_USES_CC(insn))
        add_reg(set, REG_CC);

    if ((flags & I_FLAG_USES_MEM) && INSN_USES_MEM(insn))
        add_reg(set, REG_MEM);

    switch (insn->op)
    {
    case I_ASM:         regmap_regs(&((struct asm_insn *) insn)->uses, set);
                        return;

    case I_LINE:        return;

    case I_LIR_RETURN:  if (!VOID_TYPE(func_ret_type))
                            add_reg(set, symbol_to_reg(func_ret_sym));

                        return;

    case I_MCH_CALL:    for (i = 0; i < insn->nr_iargs; ++i)
                            add_reg(set, iargs[i]);

                        for (i = 0; i < insn->nr_fargs; ++i)
                            add_reg(set, fargs[i]);

                        break;

    case I_MCH_RETF:    add_reg(set, REG_XMM0); return;
    case I_MCH_RETI:    add_reg(set, REG_RAX);  return;

    case I_MCH_DIVB:
    case I_MCH_IMULB:
    case I_MCH_IDIVB:   add_reg(set, REG_RAX); break;

    case I_MCH_DIVW:
    case I_MCH_DIVL:
    case I_MCH_DIVQ:

    case I_MCH_IDIVW:
    case I_MCH_IDIVL:
    case I_MCH_IDIVQ:   add_reg(set, REG_RAX);
                        add_reg(set, REG_RDX); break;

    case I_MCH_MOVSB:   add_reg(set, REG_RSI);
                        add_reg(set, REG_RDI);
                        add_reg(set, REG_RCX); return;

    case I_MCH_STOSB:   add_reg(set, REG_RDI);
                        add_reg(set, REG_RCX);
                        add_reg(set, REG_RAX); return;

    case I_MCH_CBTW:
    case I_MCH_CWTD:
    case I_MCH_CLTD:
    case I_MCH_CQTO:    add_reg(set, REG_RAX); return;
    }

    n = I_OPERANDS(insn->op) + insn->nr_args;

    for (i = 0; i < n; ++i)
        if (OPERAND_USES_REGS(insn, i)) {
            struct operand *o = &insn->operand[i];

            switch (o->class)
            {
            case O_MEM:
            case O_EA:      if (o->index) add_reg(set, o->index);
            case O_REG:     if (o->reg) add_reg(set, o->reg);
            }
        }
}

void insn_defs(struct insn *insn, VECTOR(reg) *set, int flags)
{
    int i;

    if ((flags & I_FLAG_DEFS_CC) && INSN_DEFS_CC(insn))
        add_reg(set, REG_CC);

    if ((flags & I_FLAG_DEFS_MEM) && INSN_DEFS_MEM(insn))
        add_reg(set, REG_MEM);

    switch (insn->op)
    {
    case I_ASM:         regmap_regs(&((struct asm_insn *) insn)->defs, set);
                        break;

    case I_LINE:        break;

    case I_MCH_CALL:    for (i = 0; i < MAX_ISCRATCH; ++i)
                            add_reg(set, iscratch[i]);

                        for (i = 0; i < MAX_FSCRATCH; ++i)
                            add_reg(set, fscratch[i]);

                        break;

    case I_MCH_DIVB:
    case I_MCH_IMULB:
    case I_MCH_IDIVB:   add_reg(set, REG_RAX); break;

    case I_MCH_DIVW:
    case I_MCH_DIVL:
    case I_MCH_DIVQ:

    case I_MCH_IDIVW:
    case I_MCH_IDIVL:
    case I_MCH_IDIVQ:   add_reg(set, REG_RAX);
                        add_reg(set, REG_RDX); break;

    case I_MCH_MOVSB:   add_reg(set, REG_RSI);
    case I_MCH_STOSB:   add_reg(set, REG_RDI);
                        add_reg(set, REG_RCX); return;

    case I_MCH_CWTD:
    case I_MCH_CLTD:
    case I_MCH_CQTO:    add_reg(set, REG_RDX);
    case I_MCH_CBTW:    add_reg(set, REG_RAX); return;

    default:        if (OPERAND_DEFS_REGS(insn, 0))
                        add_reg(set, insn->operand[0].reg);
    }
}

int insn_substitute_con(struct insn *insn, int reg,
                        union con con, struct symbol *sym)
{
    int count = 0;
    int i, n;

    n = I_OPERANDS(insn->op) + insn->nr_args;

    for (i = 0; i < n; ++i)
        if (OPERAND_USES_REGS(insn, i)
          && OPERAND_REG(&insn->operand[i])
          && (insn->operand[i].reg == reg))
        {
            normalize_con(insn->operand[i].t, &con);
            IMM_OPERAND(&insn->operand[i], 0, 0, con, sym);
            ++count;
        }

    return count;
}

#define SUBSTITUTE0(usedef)                                                 \
    do {                                                                    \
        int _count = 0;                                                     \
                                                                            \
        if ((flags & INSN_SUBSTITUTE_##usedef)                              \
          && OPERAND_##usedef##_REGS(insn, i))                              \
        {                                                                   \
            struct operand *_o = &insn->operand[i];                         \
                                                                            \
            switch (_o->class)                                              \
            {                                                               \
            case O_MEM:                                                     \
            case O_EA:      if (_o->index == src) {                         \
                                ++_count;                                   \
                                _o->index = dst;                            \
                            }                                               \
                            /* FALLTHRU */                                  \
            case O_REG:     if (_o->reg == src) {                           \
                                ++_count;                                   \
                                _o->reg = dst;                              \
                            }                                               \
            }                                                               \
                                                                            \
            if (_count)                                                     \
                if (OPERAND_MEM(_o))   /* in O_MEM the reg is used for */   \
                    t = T_LONG;        /* the address, not the operand */   \
                else                                                        \
                    t = MAX(t, _o->t);                                      \
                                                                            \
            count += _count;                                                \
        }                                                                   \
    } while (0)

int insn_substitute_reg(struct insn *insn, int src,
                        int dst, int flags, long *tp)
{
    int count = 0;
    long t = 0;

    switch (insn->op)
    {
    case I_ASM:
        {
            struct asm_insn *asm_insn = (struct asm_insn *) insn;

            if (flags & INSN_SUBSTITUTE_USES)
                count += regmap_substitute(&asm_insn->uses, src, dst);

            if (flags & INSN_SUBSTITUTE_DEFS)
                count += regmap_substitute(&asm_insn->defs, src, dst);

            t = REG_GP(src) ? T_LONG : T_DOUBLE;
            break;
        }

    case I_MCH_SHLB:    case I_MCH_SHRB:    case I_MCH_SARB:
    case I_MCH_SHLW:    case I_MCH_SHRW:    case I_MCH_SARW:
    case I_MCH_SHLL:    case I_MCH_SHRL:    case I_MCH_SARL:
    case I_MCH_SHLQ:    case I_MCH_SHRQ:    case I_MCH_SARQ:

        /* %cl looks substitutable, but it isn't. luckily,
           the compiler will never have %cl as a src with
           REG_RCX as dst, so we don't need to deal with a
           nightmare mess of special cases. */

        if (OPERAND_REG(&insn->operand[1]) && (src == REG_RCX))
           break;

    default:
        {
            int i, n;

            n = I_OPERANDS(insn->op) + insn->nr_args;

            for (i = 0; i < n; ++i) {
                SUBSTITUTE0(USES);
                SUBSTITUTE0(DEFS);
            }
        }
    }

    if (tp) *tp = t;
    return count;
}

int insn_is_copy(struct insn *insn, int *dst, int *src)
{
    switch (insn->op)
    {
    case I_LIR_MOVE:

    case I_MCH_MOVB:
    case I_MCH_MOVW:
    case I_MCH_MOVL:
    case I_MCH_MOVQ:
    case I_MCH_MOVSS:
    case I_MCH_MOVSD:       if (OPERAND_REG(&insn->operand[0])
                              && OPERAND_REG(&insn->operand[1]))
                            {
                                *dst = insn->operand[0].reg;
                                *src = insn->operand[1].reg;
                                return 1;
                            }

                            /* FALLTHRU */

    default:                return 0;
    }
}

#define CMPZ0(opr0, opr1)                                                   \
    do {                                                                    \
        if (OPERAND_ZERO(&insn->operand[opr0])                              \
          && OPERAND_REG(&insn->operand[opr1])) {                           \
            *reg = insn->operand[opr1].reg;                                 \
            return 1;                                                       \
        }                                                                   \
    } while (0)

int insn_is_cmpz(struct insn *insn, int *reg)
{
    switch (insn->op)
    {
    case I_LIR_CMP:
    case I_MCH_CMPB:
    case I_MCH_CMPW:
    case I_MCH_CMPL:
    case I_MCH_CMPQ:    CMPZ0(0, 1);
                        CMPZ0(1, 0);
                        /* FALLTHRU */

    default:            return 0;
    }
}

#define CMP_CON0(opr0, opr1)                                                \
    do {                                                                    \
        if (OPERAND_PURE_IMM(&insn->operand[opr0])                          \
          && OPERAND_REG(&insn->operand[opr1])) {                           \
            *reg = insn->operand[opr1].reg;                                 \
            return 1;                                                       \
        }                                                                   \
    } while (0)

int insn_is_cmp_con(struct insn *insn, int *reg)
{
    switch (insn->op)
    {
    case I_LIR_CMP:     CMP_CON0(0, 1);
                        CMP_CON0(1, 0);
                        /* FALLTHRU */

    default:            return 0;
    }
}

/* vi: set ts=4 expandtab: */
