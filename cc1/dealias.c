/*****************************************************************************

   dealias.c                                              minix c compiler

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
#include "heap.h"
#include "reg.h"
#include "block.h"
#include "gen.h"
#include "init.h"
#include "insn.h"
#include "func.h"
#include "dealias.h"

/* this pass is invoked early to force load-before-use and store-after-def
   for aliased variables, shielding the optimizer from aliasing issues. we
   do this very naively, splitting the aliased variable into many tiny live
   ranges around each access (the optimizer will coalesce the accesses). we
   ignore volatile regs/symbols: these only appear in the function prologue
   generated by arg0(), which has already dealt with them. (see func.c.) */

#define DEALIAS1(op, reg, n)                                                \
    do {                                                                    \
        sym = REG_TO_SYMBOL(reg);                                           \
                                                                            \
        if (ALIASED_SYMBOL(sym) && !VOLATILE_TYPE(sym->type))               \
            i += loadstore(op, sym, b, i + n);                              \
    } while (0)

#define DEALIAS0(defuse, op, n)                                             \
    do {                                                                    \
        int j;                                                              \
        int reg;                                                            \
                                                                            \
        TRUNC_VECTOR(regs);                                                 \
        insn_##defuse##s(insn, &regs, 0);                                   \
        FOR_EACH_REG(regs, j, reg) DEALIAS1(op, reg, n);                    \
    } while (0)

void dealias(void)
{
    struct symbol *sym;
    VECTOR(reg) regs;
    struct block *b;
    struct insn *insn;
    int i;

    INIT_VECTOR(regs, &local_arena);

    FOR_ALL_BLOCKS(b) {
        FOR_EACH_INSN(b, i, insn) {
            DEALIAS0(use, I_LIR_LOAD, 0);
            DEALIAS0(def, I_LIR_STORE, 1);
        }

        if (SWITCH_BLOCK(b) && OPERAND_REG(&b->control))
            DEALIAS1(I_LIR_LOAD, b->control.reg, 0);
    }

    ARENA_FREE(&local_arena);
}

/* on ATOM, there are no such things as floating-point or long immediate
   operands (the only exception to the latter being for movabsq). this is
   called before lower() to load such immediates into temporaries instead.

   we also take the opportunity here to rewrite floating-point I_LIR_NEG
   operations as multiplication by -1.0. this may seem an odd place, but:

            (a) deconst() is not an optional pass (as OPT_NORM is)
                and lower.c can't handle floating-point I_LIR_NEG

            (b) the resulting I_LIR_MUL is an immediate candidate for
                `deconstification', and will benefit from the opt()
                pass that immediately follows (see exit_func). */

int deconst(void)
{
    struct block *b;
    struct insn *insn;
    int i, n;
    int changes;

    changes = 0;

    FOR_ALL_BLOCKS(b)
        FOR_EACH_INSN(b, i, insn) {

            if ((insn->op == I_LIR_NEG) && (insn->operand[0].t & T_FLOATING))
            {
                struct insn *new = new_insn(I_LIR_MUL, 0);

                new->operand[0] = insn->operand[0];
                new->operand[1] = insn->operand[1];
                F_OPERAND(&new->operand[2], 0, insn->operand[0].t, -1.0);

                INSN(b, i) = insn = new;
            }

            for (n = 0; n < NR_OPERANDS(insn); ++n) {
                struct operand *o = &insn->operand[n];

                if ((o->class == O_IMM) && (o->t & T_FLOATING)) {
                    struct symbol *sym = floateral(o->t, o->con.f);
                    loadstore(I_LIR_LOAD, sym, b, i);
                    o->class = O_REG;
                    o->reg = symbol_to_reg(sym);
                    ++changes;
                } else if (OPERAND_HUGE(o)) {
                    int reg = temp_reg(T_LONG);
                    struct insn *new = new_insn(I_LIR_MOVE, 0);

                    REG_OPERAND(&new->operand[0], &long_type, 0, reg);
                    IMM_OPERAND(&new->operand[1], &long_type, 0, o->con, 0);
                    insert_insn(new, b, i);

                    /* OPT_LIR_FOLD would propagate this constant,
                       undoing all our work, so tell it not to. */

                    new->force_nac = 1;

                    o->class = O_REG;
                    o->reg = reg;
                    ++changes;
                }
            }
        }

    return changes;
}

/* vi: set ts=4 expandtab: */
