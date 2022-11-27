/*****************************************************************************

   rsp.c                                                  minix c compiler

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
#include "block.h"
#include "rsp.h"

/* combine all addq $Xn, %rsp post-call stack adjustments in a
   basic block into one final addq $(X0 + X1 + .. + Xn), %rsp.
   in the old days, this was of course far more valuable, when
   the stack saw more action in argument passing.

   it's still worth doing. it's cheap and effective: nearly 10%
   of the adjustments in the regression suite are eliminated. */

void opt_mch_rsp(void)
{
    struct block *b;
    struct insn *insn;
    struct insn **last;
    int i;

    FOR_ALL_BLOCKS(b)
    {
        last = 0;

        FOR_EACH_INSN(b, i, insn)
        {
            if (insn->op == I_MCH_ADDQ
              && OPERAND_REG(&insn->operand[0])
              && insn->operand[0].reg == REG_RSP
              && OPERAND_PURE_IMM(&insn->operand[1]))
            {
                if (last) {
                    insn->operand[1].con.i += (*last)->operand[1].con.i;
                    *last = &nop_insn;
                }

                last = &INSN(b, i);
            }
        }
    }
}

/* vi: set ts=4 expandtab: */
