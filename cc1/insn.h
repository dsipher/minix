/*****************************************************************************

   insn.h                                              jewel/os c compiler

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

#ifndef INSN_H
#define INSN_H

#include <limits.h>
#include "reg.h"
#include "heap.h"
#include "type.h"

/* condition codes: a bit of a misnomer, because what we refer to are the
   conditions deduced from the condition codes, not the codes themselves.

   the names align with ATOM mnemonics where applicable. the values of
   the constants are not arbitrary; do not change.

   CC_S and CC_NS are oddballs. they can't be mixed in the same block
   with other condition codes (since union/intersection make no sense
   in those circumstances). this currently poses no problem because
   they aren't introduced until after lowering, and only OPT_LIR_CMP
   removes barriers between blocks that would require mixing them. */

#define CC_Z            0               /*           zero/equal         */
#define CC_NZ           1               /*       not zero/not equal     */

#define CC_S            2               /*            negative          */
#define CC_NS           3               /*          non-negative        */

#define CC_G            4               /*      >           signed      */
#define CC_LE           5               /*      <=                      */
#define CC_GE           6               /*      >=                      */
#define CC_L            7               /*      <                       */

#define CC_A            8               /*      >          unsigned     */
#define CC_BE           9               /*      <=            or        */
#define CC_AE           10              /*      >=         floating     */
#define CC_B            11              /*      <            point      */

/* conditions that are not state-dependent */

#define CC_ALWAYS       12
#define CC_NEVER        13

/* pseudo-conditions used for the controlling block of a switch() */

#define CC_DEFAULT      14
#define CC_SWITCH       15

/* true if a condition is actually dependent on flags */

#define CONDITIONAL_CC(cc)      ((cc) <= CC_B)

/* invert the truth value of a condition code. this depends on
   the fact that opposite conditions differ only in their lsb.
   (this obviously produces nonsense for pseudo conditions.) */

#define INVERT_CC(cc)           ((cc) ^ 1)

/* we can use an int as a fast, simple bitset
   to represent a set of condition codes. */

#define CCSET_SET(ccs, cc)          ((ccs) |=  (1 << (cc)))
#define CCSET_CLR(ccs, cc)          ((ccs) &= ~(1 << (cc)))
#define CCSET_IS_SET(ccs, cc)       ((ccs) &   (1 << (cc)))

#define CCSET_ALL                   0xFFF   /* CC_Z .. CC_B */

/* output a CCSET in human-readable form for debugging/verbose output */

void out_ccs(int ccs);

/* table mapping CC_* constants CC_Z .. CC_ALWAYS to assembler branch
   mnemonics. (CC_NEVER .. CC_SWITCH never appear in the output phase) */

extern const char * const cc_text[];

/* given two conditions, return the condition that
   combines them both (e.g., CC_L + CC_Z == CC_LE). */

int union_cc(int cc1, int cc2);

/* given two conditions, return the condition that
   satisfies them both (e.g., CC_LE + CC_Z = CC_Z) */

int intersect_cc(int cc1, int cc2);

/* maps conditional CCs to their 'commuted' equivalents,
   i.e., what they are if I_LIR_CMP operands are swapped */

extern const char commuted_cc[];

/* instructions are broadly divided into two classes, LIR and MCH. LIR is for
   the 'linear intermediate representation' and is the form in which most/all
   optimization is done. MCH insns map directly to ATOM mnemonics. all insns
   occupy the same containers and are manipulated by the same functions, but
   LIR and MCH insns do not intermingle in the same block (though a handful
   of insns are universal and can be treated as LIR or MCH, e.g., I_NOP). */

   /* insns may have zero or more source operands and at most one destination
      operand; if present, the latter is always operand[0]. the destination
      may also be a source; this is the case in most MCH two-address insns. */

#define I_FLAG_HAS_DST      0x80000000      /* bit[31]: operand[0] is dst */
#define I_FLAG_USES_DST     0x40000000      /* bit[30]: dst is also a src */

    /* insns have at most 3 operands. (note that I_LIR_CALL insns have
       additional operands for actual arguments, the number of which is
       specified at creation time and recorded the insn.nr_args field.)
       operands appear in the output in reverse order (because AT&T). */

#define I_ENC_OPERANDS(n)   ((n) << 28)                     /* bits[29:28] */
#define I_OPERANDS(op)      (((op) & 0x30000000) >> 28)

    /* set if the insn uses or defs the condition codes or (aliased) memory.
       these flags are shortcuts, not dispositive; if a flag is set, then the
       insn definitely uses or defs as indicated. if a flag is not set, then
       we may need to inspect the insn operands to make the determination. */

#define I_FLAG_USES_CC       0x08000000                     /* bit[27] */
#define I_FLAG_DEFS_CC       0x04000000                     /* bit[26] */
#define I_FLAG_USES_MEM      0x02000000                     /* bit[25] */
#define I_FLAG_DEFS_MEM      0x01000000                     /* bit[24] */

    /* set if the insn has effects not otherwise visible to optimizer */

#define I_FLAG_SIDEFFS      0x00800000                      /* bit[23] */

    /* bits[22:8] encode default type indices for the operands. this is
       solely a convenience for MCH insns, whose operand types are fixed
       by the op: the types from the op are auto-populated at creation. */

#define I_TYPE_SHIFT(n)     (I_INDEX_BITS + (n) * T_INDEX_BITS)
#define I_TYPE(op, n)       (((op) >> I_TYPE_SHIFT(n)) & T_INDEX_MASK)
#define I_TYPE_ENC(n, t)    ((t) << I_TYPE_SHIFT(n))

    /* bits[7:0] serve as a unique identifying number
       as well as an index into several tables:

                    insn_text[]     (insn.c)
                    sel[]           (lower.c)
                    flags[]         (fuse.c)
                    arith[]         (cmp.c)
                    peeps[]         (peep.c)

       so obviously it's important to keep these all in sync. */

#define I_INDEX_BITS        8
#define I_INDEX_MASK        0x000000FF
#define I_INDEX(op)         ((op) & I_INDEX_MASK)

    /* for the purposes of I_LIR_BINARY(op), a binary
       has the form:  I_LIR_op src2, src1, dst  */

#define I_LIR_BINARY(op)    ((I_OPERANDS(op) == 3) &&                       \
                             (op & I_FLAG_HAS_DST) &&                       \
                             !(op & I_FLAG_USES_DST))

    /* and for I_LIR_UNARY(op), I_LIR_op src, dst */

#define I_LIR_UNARY(op)     ((I_OPERANDS(op) == 2) &&                       \
                             (op & I_FLAG_HAS_DST) &&                       \
                             !(op & I_FLAG_USES_DST))

    /* universal insns. I_ASM has a non-standard
       payload and needs special handling */

#define I_NOP               (   0 )
#define I_ASM               (   1 | I_FLAG_SIDEFFS  /* struct asm_insn */   )

    /* we reserve index 2 for I_LINE, for when/if we
       decide to reintroduce debug info generation */

    /* since we can't reference machine registers in the LIR, we can't
       access the frame directly via the frame register, instead use:

                    FRAME (L) offset, (PTR) dst

       which loads the dst with a pointer to the offset in the frame. */

#define I_LIR_FRAME         (   3 | I_ENC_OPERANDS(2) | I_FLAG_HAS_DST )

    /* all memory accesses in LIR are effected through explicit
       loads and stores, since no O_MEM operands are permitted:

                    LOAD (PTR) addr, (ANY) dst
                    STORE (ANY) src, (PTR) addr

       the type of the dst/src operand controls the size of the access */

#define I_LIR_LOAD          (   4 | I_ENC_OPERANDS(2) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_MEM                         )

#define I_LIR_STORE         (   5 | I_ENC_OPERANDS(2) | I_FLAG_DEFS_MEM     )

    /* function call takes two forms:

                CALL (PTR) func[({ (ANY) arg, ... })]
                CALL (PTR) func[({ (ANY) arg, ... })], (ANY) dst

       arguments may be any type, including (unique to I_LIR_CALL
       insns) T_STRUN; the return value must be scalar if present.
       if the function is void, dst has class O_NONE: this too is
       unique to I_LIR_CALL insns. */

#define I_LIR_CALL          (   6 | I_ENC_OPERANDS(2) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_MEM                         \
                                  | I_FLAG_DEFS_MEM                         \
                                  | I_FLAG_DEFS_CC                          )

    /* in the function prologue, incoming register arguments
       are assigned to their pseudo registers with I_LIR_ARG:

                            ARG (ANY) dst

       order is important, as the source physical registers are implied
       by the order as well as the types of the destinations. */

#define I_LIR_ARG           (   7 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_SIDEFFS                          )

    /* I_LIR_RETURN appears in the exit_block to provide a place to hang
       post-function dependencies (e.g., aliased memory). if the function
       returns a scalar value, I_LIR_RETURN is dependent upon the return
       symbol's register and copies its value to its proper place. */

#define I_LIR_RETURN        (   8 | I_FLAG_SIDEFFS | I_FLAG_USES_MEM        )

    /* I_LIR_MOVE and I_LIR CAST both move a value from one place to another:

                        MOVE (ANY) src, (ANY) dst
                        CAST (ANY) src, (ANY) dst

       the difference is that MOVE requires that the src and dst types be the
       same (or simpatico), whereas CAST requires that they be different. */

#define I_LIR_MOVE          (   9 | I_ENC_OPERANDS(2) | I_FLAG_HAS_DST      )
#define I_LIR_CAST          (  10 | I_ENC_OPERANDS(2) | I_FLAG_HAS_DST      )

    /* compare two operands (of the same type) and set the condition codes:

                        CMP (ANY) rhs, (ANY) lhs

       a subtle point here is that LIR doesn't really have condition codes,
       of course. so when this is evaluated at compile-time, the result is
       a CCSET of true conditions rather than a set of CF, ZF, etc. flags;
       this is however meant to be completely analogous to I_MCH_CMP et al. */

#define I_LIR_CMP           (  11 | I_ENC_OPERANDS(2) | I_FLAG_DEFS_CC      )

    /* arithmetic operations; should be self-explanatory. the permitted
       types and results closely follow c semantics, though there is no
       pointer scaling, and pointer and integer types are freely mixed. */

#define I_LIR_NEG           (  12 | I_ENC_OPERANDS(2) | I_FLAG_HAS_DST      )

#define I_LIR_COM           (  13 | I_ENC_OPERANDS(2) | I_FLAG_HAS_DST      \
                                  | I_FLAG_DEFS_CC                          )

#define I_LIR_ADD           (  14 | I_ENC_OPERANDS(3) | I_FLAG_HAS_DST      )
#define I_LIR_SUB           (  15 | I_ENC_OPERANDS(3) | I_FLAG_HAS_DST      )
#define I_LIR_MUL           (  16 | I_ENC_OPERANDS(3) | I_FLAG_HAS_DST      )
#define I_LIR_DIV           (  17 | I_ENC_OPERANDS(3) | I_FLAG_HAS_DST      )

#define I_LIR_MOD           (  18 | I_ENC_OPERANDS(3) | I_FLAG_HAS_DST      \
                                  | I_FLAG_DEFS_CC                          )

#define I_LIR_SHR           (  19 | I_ENC_OPERANDS(3) | I_FLAG_HAS_DST      \
                                  | I_FLAG_DEFS_CC                          )

#define I_LIR_SHL           (  20 | I_ENC_OPERANDS(3) | I_FLAG_HAS_DST      \
                                  | I_FLAG_DEFS_CC                          )

#define I_LIR_AND           (  21 | I_ENC_OPERANDS(3) | I_FLAG_HAS_DST      \
                                  | I_FLAG_DEFS_CC                          )

#define I_LIR_OR            (  22 | I_ENC_OPERANDS(3) | I_FLAG_HAS_DST      \
                                  | I_FLAG_DEFS_CC                          )

#define I_LIR_XOR           (  23 | I_ENC_OPERANDS(3) | I_FLAG_HAS_DST      \
                                  | I_FLAG_DEFS_CC                          )

    /* the LIR SETxx insns are almost identical to the MCH ops, except that
       the destination type for the LIR operation is a full int, not a byte.

                            SETxx (I) dst

       the macros that map between the CCs and the LIR ops are dependent on
       the values of the CC_* constants, and the ordering of the insn ops */

#define I_LIR_IS_SETCC(op)      ((I_INDEX(op) >= I_INDEX(I_LIR_SETZ)) &&    \
                                 (I_INDEX(op) <= I_INDEX(I_LIR_SETB)))

#define I_LIR_SETCC_TO_CC(op)       ((op) - I_LIR_SETZ)
#define I_CC_TO_LIR_SETCC(cc)       (I_LIR_SETZ + (cc))

#define I_LIR_SETZ          (  24 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETNZ         (  25 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETS          (  26 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETNS         (  27 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETG          (  28 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETLE         (  29 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETGE         (  30 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETL          (  31 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETA          (  32 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETBE         (  33 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETAE         (  34 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

#define I_LIR_SETB          (  35 | I_ENC_OPERANDS(1) | I_FLAG_HAS_DST      \
                                  | I_FLAG_USES_CC                          )

    /* indices 36 and 37 are available */

    /* block operations:

        BLKCPY (UL) size, (PTR) src, (PTR) dst
        BLKSET (UL) size, (I) value, (PTR) buf */

#define I_LIR_BLKCPY        (  38 | I_ENC_OPERANDS(3)                       \
                                  | I_FLAG_USES_MEM | I_FLAG_DEFS_MEM       )

#define I_LIR_BLKSET        (  39 | I_ENC_OPERANDS(3) | I_FLAG_DEFS_MEM     )

    /* most MCH insns map directly to machine as mnemonics and need no
       explanation; the oddballs are at the end of the list. the types
       specified for the operands are relevant only to determine their
       sizes and thus the forms of the operands for output. these are
       overspecified in the sense that, e.g., we provide the types of
       floating-point operands, though this doesn't affect the output
       at all. consistency costs little here, so we do it anyway. */

#define I_LIR(op)           (I_INDEX(op) < 64)      /* this is the */
#define I_MCH(op)           (I_INDEX(op) >= 64)     /* dividing line */

#define I_MCH_CALL          (  64 | I_ENC_OPERANDS(1)                       \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_FLAG_USES_MEM                         \
                                  | I_FLAG_DEFS_MEM                         \
                                  | I_FLAG_DEFS_CC                          )

    /* we distinguish three return insns, although they are all emitted
       as `ret': the difference is in the return type. RET is for void
       functions, RETI discrete (%rax), and RETF floating-point (%xmm0). */

#define I_MCH_RET           (  65 | I_FLAG_USES_MEM | I_FLAG_SIDEFFS        )
#define I_MCH_RETI          (  66 | I_FLAG_USES_MEM | I_FLAG_SIDEFFS        )
#define I_MCH_RETF          (  67 | I_FLAG_USES_MEM | I_FLAG_SIDEFFS        )

#define I_MCH_MOVB          (  68 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             )

#define I_MCH_MOVW          (  69 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            )

#define I_MCH_MOVL          (  70 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_MOVQ          (  71 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_MOVSS         (  72 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_FLOAT)            \
                                  | I_TYPE_ENC(1, T_INDEX_FLOAT)            )

#define I_MCH_MOVSD         (  73 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_DOUBLE)           \
                                  | I_TYPE_ENC(1, T_INDEX_DOUBLE)           )

#define I_MCH_MOVZBW        (  74 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             )

#define I_MCH_MOVZBL        (  75 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             )

#define I_MCH_MOVZBQ        (  76 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             )

#define I_MCH_MOVSBW        (  77 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             )

#define I_MCH_MOVSBL        (  78 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             )

#define I_MCH_MOVSBQ        (  79 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             )

#define I_MCH_MOVZWL        (  80 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            )

#define I_MCH_MOVZWQ        (  81 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            )

#define I_MCH_MOVSWL        (  82 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            )

#define I_MCH_MOVSWQ        (  83 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            )

    /* MOVZLQ is a synthetic instruction. lower_more() will rewrite it as
       MOVL. it is distinguished before then because of its side effect. */

#define I_MCH_MOVZLQ        (  84 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_MOVSLQ        (  85 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CVTSI2SSL     (  86 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_FLOAT)            \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CVTSI2SSQ     (  87 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_FLOAT)            \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CVTSI2SDL     (  88 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_DOUBLE)           \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CVTSI2SDQ     (  89 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_DOUBLE)           \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CVTSS2SIL     (  90 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_FLOAT)            )

#define I_MCH_CVTSS2SIQ     (  91 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_FLOAT)            )

#define I_MCH_CVTSD2SIL     (  92 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_DOUBLE)           )

#define I_MCH_CVTSD2SIQ     (  93 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_DOUBLE)           )

#define I_MCH_CMPB          (  94 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             )

#define I_MCH_CMPW          (  95 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            )

#define I_MCH_CMPL          (  96 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMPQ          (  97 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_UCOMISS       (  98 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_FLOAT)            \
                                  | I_TYPE_ENC(1, T_INDEX_FLOAT)            )

#define I_MCH_UCOMISD       (  99 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_DOUBLE)           \
                                  | I_TYPE_ENC(1, T_INDEX_DOUBLE)           )

    /* LEAB is a synthetic insn which lower_more() will rewrite
       as LEAL. we use it to express intent, so we can properly
       degenerate to ADDB/SHLB as needed. */

#define I_MCH_LEAB          ( 100 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             )

#define I_MCH_LEAW          ( 101 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            )

#define I_MCH_LEAL          ( 102 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_LEAQ          ( 103 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_NOTB          ( 104 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             )

#define I_MCH_NOTW          ( 105 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            )

#define I_MCH_NOTL          ( 106 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              )

#define I_MCH_NOTQ          ( 107 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             )

#define I_MCH_NEGB          ( 108 | I_ENC_OPERANDS(1)                      \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST       \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)            \
                                  | I_FLAG_DEFS_CC                         )

#define I_MCH_NEGW          ( 109 | I_ENC_OPERANDS(1)                      \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST       \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)           \
                                  | I_FLAG_DEFS_CC                         )

#define I_MCH_NEGL          ( 110 | I_ENC_OPERANDS(1)                      \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST       \
                                  | I_TYPE_ENC(0, T_INDEX_INT)             \
                                  | I_FLAG_DEFS_CC                         )

#define I_MCH_NEGQ          ( 111 | I_ENC_OPERANDS(1)                      \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST       \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)            \
                                  | I_FLAG_DEFS_CC                         )

#define I_MCH_ADDB          ( 112 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ADDW          ( 113 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ADDL          ( 114 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ADDQ          ( 115 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ADDSS         ( 116 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_FLOAT)            \
                                  | I_TYPE_ENC(1, T_INDEX_FLOAT)            )

#define I_MCH_ADDSD         ( 117 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_DOUBLE)           \
                                  | I_TYPE_ENC(1, T_INDEX_DOUBLE)           )

#define I_MCH_SUBB          ( 118 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SUBW          ( 119 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SUBL          ( 120 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SUBQ          ( 121 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SUBSS         ( 122 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_FLOAT)            \
                                  | I_TYPE_ENC(1, T_INDEX_FLOAT)            )

#define I_MCH_SUBSD         ( 123 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_DOUBLE)           \
                                  | I_TYPE_ENC(1, T_INDEX_DOUBLE)           )

    /* we perform all multiplications with IMUL, since we're not
       interested in the upper bits of the result. 8x8 multiplies
       must be done with the single-operand form. other sizes are
       two- or three-operand, depending on the specific operands. */

#define I_MCH_IMULB         ( 124 | I_ENC_OPERANDS(1)                       \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_IMULW         ( 125 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_IMULL         ( 126 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_IMULQ         ( 127 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_IMUL3W        ( 128 | I_ENC_OPERANDS(3)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(2, T_INDEX_SHORT)            \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_IMUL3L        ( 129 | I_ENC_OPERANDS(3)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              \
                                  | I_TYPE_ENC(2, T_INDEX_INT)              \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_IMUL3Q        ( 130 | I_ENC_OPERANDS(3)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(2, T_INDEX_LONG)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_MULSS         ( 131 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_FLOAT)            \
                                  | I_TYPE_ENC(1, T_INDEX_FLOAT)            )

#define I_MCH_MULSD         ( 132 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_DOUBLE)           \
                                  | I_TYPE_ENC(1, T_INDEX_DOUBLE)           )

#define I_MCH_DIVSS         ( 133 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_FLOAT)            \
                                  | I_TYPE_ENC(1, T_INDEX_FLOAT)            )

#define I_MCH_DIVSD         ( 134 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_DOUBLE)           \
                                  | I_TYPE_ENC(1, T_INDEX_DOUBLE)           )

#define I_MCH_IDIVB         ( 135 | I_ENC_OPERANDS(1)                       \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_IDIVW         ( 136 | I_ENC_OPERANDS(1)                       \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_IDIVL         ( 137 | I_ENC_OPERANDS(1)                       \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_IDIVQ         ( 138 | I_ENC_OPERANDS(1)                       \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_DIVB          ( 139 | I_ENC_OPERANDS(1)                       \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_DIVW          ( 140 | I_ENC_OPERANDS(1)                       \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_DIVL          ( 141 | I_ENC_OPERANDS(1)                       \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_DIVQ          ( 142 | I_ENC_OPERANDS(1)                       \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SHRB          ( 143 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SHRW          ( 144 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SHRL          ( 145 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SHRQ          ( 146 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SARB          ( 147 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SARW          ( 148 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SARL          ( 149 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SARQ          ( 150 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SHLB          ( 151 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SHLW          ( 152 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SHLL          ( 153 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_SHLQ          ( 154 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ANDB          ( 155 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ANDW          ( 156 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ANDL          ( 157 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ANDQ          ( 158 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ORB           ( 159 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ORW           ( 160 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ORL           ( 161 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_ORQ           ( 162 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_XORB          ( 163 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_XORW          ( 164 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_XORL          ( 165 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              \
                                  | I_FLAG_DEFS_CC                          )

#define I_MCH_XORQ          ( 166 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST | I_FLAG_USES_DST        \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             \
                                  | I_FLAG_DEFS_CC                          )

    /* these macros are obviously dependent on the ordering
       and values of the I_MCH_SETcc ops, so be careful */

#define I_MCH_IS_SETCC(op)      ((I_INDEX(op) >= I_INDEX(I_MCH_SETZ)) &&    \
                                 (I_INDEX(op) <= I_INDEX(I_MCH_SETB)))

#define I_MCH_SETCC_TO_CC(op)       ((op) - I_MCH_SETZ)
#define I_CC_TO_MCH_SETCC(cc)       (I_MCH_SETZ + (cc))

#define I_MCH_SETZ          ( 167 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETNZ         ( 168 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETS          ( 169 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETNS         ( 170 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETG          ( 171 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETLE         ( 172 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETGE         ( 173 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETL          ( 174 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETA          ( 175 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETBE         ( 176 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETAE         ( 177 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

#define I_MCH_SETB          ( 178 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_FLAG_USES_CC                          )

    /* indices 179 .. 182 are available */

#define I_MCH_MOVSB         ( 183 | I_FLAG_USES_MEM | I_FLAG_DEFS_MEM       )
#define I_MCH_STOSB         ( 184 | I_FLAG_DEFS_MEM                         )
#define I_MCH_REP           ( 185 | I_FLAG_SIDEFFS                          )

    /* helpers for divison instructions. (the mnemonics used by as are
       quite different from the published literature, so their functions
       are given.) CBTW obviously overlaps MOVSBx but is slightly smaller.
       whatever other advantages (or disadvantages) it has are unclear; we
       use it for consistency. CBTW and CWTD usually evaporate from the
       output; peephole will try to rewrite divisions to use full words. */

#define I_MCH_CBTW          ( 186 )         /* sign extend AL -> AX */
#define I_MCH_CWTD          ( 187 )         /* sign extend AX -> DX:AX */
#define I_MCH_CLTD          ( 188 )         /* sign extend EAX -> EDX:EAX */
#define I_MCH_CQTO          ( 189 )         /* sign extend RAX -> RDX:RAX */

#define I_MCH_CVTSS2SD      ( 190 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_DOUBLE)           \
                                  | I_TYPE_ENC(1, T_INDEX_FLOAT)            )

#define I_MCH_CVTSD2SS      ( 191 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_TYPE_ENC(0, T_INDEX_FLOAT)            \
                                  | I_TYPE_ENC(1, T_INDEX_DOUBLE)           )

#define I_MCH_PUSHQ         ( 192 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_SIDEFFS                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             )

#define I_MCH_POPQ          ( 193 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_SIDEFFS                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             )

#define I_MCH_TESTB         ( 194 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             \
                                  | I_TYPE_ENC(1, T_INDEX_CHAR)             )

#define I_MCH_TESTW         ( 195 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            \
                                  | I_TYPE_ENC(1, T_INDEX_SHORT)            )

#define I_MCH_TESTL         ( 196 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_TESTQ         ( 197 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_DECB          ( 198 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             )

#define I_MCH_DECW          ( 199 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            )

#define I_MCH_DECL          ( 200 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              )

#define I_MCH_DECQ          ( 201 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             )

#define I_MCH_INCB          ( 202 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_CHAR)             )

#define I_MCH_INCW          ( 203 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_SHORT)            )

#define I_MCH_INCL          ( 204 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              )

#define I_MCH_INCQ          ( 205 | I_ENC_OPERANDS(1)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_DEFS_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             )

    /* we only have two sizes of conditional moves: 32-bit for T_INTS
       and smaller, and 64-bit for T_LONGS (and T_PTR). ATOM supports
       16-bit CMOVs but they are useless to us in the absence of fusing
       (which we specifically avoid; see cmov.c for all the details).

       like I_LIR_SETxx/I_MCH_SETxx, these are in a specific order. */

#define I_MCH_IS_CMOVCCL(op)    ((I_INDEX(op) >= I_INDEX(I_MCH_CMOVZL)) &&  \
                                 (I_INDEX(op) <= I_INDEX(I_MCH_CMOVBL)))

#define I_MCH_CMOVCCL_TO_CC(op)     ((op) - I_MCH_CMOVZL)
#define I_CC_TO_MCH_CMOVCCL(cc)     (I_MCH_CMOVZL + (cc))

#define I_MCH_CMOVZL        ( 206 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVNZL       ( 207 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVSL        ( 208 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVNSL       ( 209 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVGL        ( 210 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVLEL       ( 211 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVGEL       ( 212 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVLL        ( 213 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVAL        ( 214 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVBEL       ( 215 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVAEL       ( 216 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_CMOVBL        ( 217 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_INT)              \
                                  | I_TYPE_ENC(1, T_INDEX_INT)              )

#define I_MCH_IS_CMOVCCQ(op)    ((I_INDEX(op) >= I_INDEX(I_MCH_CMOVZQ)) &&  \
                                 (I_INDEX(op) <= I_INDEX(I_MCH_CMOVBQ)))

#define I_MCH_CMOVCCQ_TO_CC(op)     ((op) - I_MCH_CMOVZQ)
#define I_CC_TO_MCH_CMOVCCQ(cc)     (I_MCH_CMOVZQ + (cc))

#define I_MCH_CMOVZQ        ( 218 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVNZQ       ( 219 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVSQ        ( 220 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVNSQ       ( 221 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVGQ        ( 222 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVLEQ       ( 223 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVGEQ       ( 224 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVLQ        ( 225 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVAQ        ( 226 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVBEQ       ( 227 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVAEQ       ( 228 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

#define I_MCH_CMOVBQ        ( 229 | I_ENC_OPERANDS(2)                       \
                                  | I_FLAG_HAS_DST                          \
                                  | I_FLAG_USES_DST                         \
                                  | I_FLAG_USES_CC                          \
                                  | I_TYPE_ENC(0, T_INDEX_LONG)             \
                                  | I_TYPE_ENC(1, T_INDEX_LONG)             )

/* operands for insns. MCH insns may have operands of any
   class, but LIR insns may not have O_MEM or O_EA operands.

   O_NONE is a placeholder.
   O_REG is a pure register value (reg).
   O_IMM is used for constant values (con+sym).

   O_MEM means the value stored at a memory address:

                sym+con.i (reg, index, scale)

   not all elements need be present in every address.

   O_EA has the same form as O_MEM, but represents the value of
   the address itself rather than the value stored there.

   beware: fields not relevant to an operand state can be
   filled with junk; use normalize_operand() to clean up. */

#define O_NONE  0
#define O_REG   1
#define O_IMM   2
#define O_MEM   3
#define O_EA    4

struct operand
{
    unsigned class : 3;             /* O_* */
    unsigned scale : 2;             /* log2 of index scaling */

    /* t is the fundamental type of the operand. this is redundant
       information for MCH insns, whose operands have fixed sizes,
       but we set it for consistency, and to avoid special-casing.

       size and align are only valid when T == T_STRUN, which
       can only appear as an argument operand in I_LIR_CALL. */

    unsigned t      : T_BASE_BITS;
    unsigned size   : MAX_TYPE_BITS;
    unsigned align  : MAX_ALIGN_BITS;

    int reg;            /* [base] reg */

    /* only O_MEM and O_EA have index regs, and such operands do not
       appear in LIR when we're value numbering, so we share storage. */

    union
    {
        int index;          /* index reg */
        int number;         /* value number */
    };

    /* in LIR insns, the constant is unconstrained. in MCH insns,
       there are no floating-point constants, and integer values
       must be in range for the instruction, which almost always
       means 'representable in 32-bits'. we assume symbols do not
       affect the range (no large model). */

    union con con;
    struct symbol *sym;
};

DEFINE_VECTOR(operand, struct operand *);

/* normalize an operand (see definition for details) */

void normalize_operand(struct operand *o);

/* returns true iff the operands are exactly the same */

int same_operand(struct operand *o1, struct operand *o2);

/* operand constructors. if the type is specified, it is used to set the
   operand type, otherwise the type is left alone. LIR operand types are
   typically changed as they are filled in; MCH operand types are not */

#define SET_OPERAND_TYPE(o, type)                                           \
    do {                                                                    \
        struct tnode *_type = (type);                                       \
                                                                            \
        if (_type)                                                          \
            (o)->t = TYPE_BASE(_type);                                      \
    } while (0)

#define SET_OPERAND_T(o, _t)    do { if (_t) (o)->t = (_t); } while (0)

#define REG_OPERAND(o, type, t, r)                                          \
    do {                                                                    \
        (o)->class = O_REG;                                                 \
        (o)->reg = (r);                                                     \
        SET_OPERAND_TYPE((o), (type));                                      \
        SET_OPERAND_T((o), (t));                                            \
    } while (0)

#define IMM_OPERAND(o, type, t, _con, _sym)                                 \
    do {                                                                    \
        (o)->class = O_IMM;                                                 \
        (o)->con = (_con);                                                  \
        (o)->sym = (_sym);                                                  \
        SET_OPERAND_TYPE((o), (type));                                      \
        SET_OPERAND_T((o), (t));                                            \
    } while (0)

#define I_OPERAND(o, type, t, _i)                                           \
    do {                                                                    \
        (o)->class = O_IMM;                                                 \
        (o)->con.i = (_i);                                                  \
        (o)->sym = 0;                                                       \
        SET_OPERAND_TYPE((o), (type));                                      \
        SET_OPERAND_T((o), (t));                                            \
    } while (0)

#define F_OPERAND(o, type, t, _f)                                           \
    do {                                                                    \
        union con _con;                                                     \
        _con.f = (_f);                                                      \
        IMM_OPERAND((o), (type), (t), _con, 0);                             \
    } while (0)

#define SYM_OPERAND(o, type, _sym)                                          \
    do {                                                                    \
        (o)->class = O_IMM;                                                 \
        (o)->con.i = 0;                                                     \
        (o)->sym = (_sym);                                                  \
        SET_OPERAND_TYPE((o), (type));                                      \
    } while (0)

#define BASED_OPERAND(o, type, t, _class, _base, _i)                        \
    do {                                                                    \
        (o)->class = (_class);    /* O_EA or O_MEM */                       \
        (o)->reg = (_base);                                                 \
        (o)->index = REG_NONE;                                              \
        (o)->scale = 0;                                                     \
        (o)->con.i = (_i);                                                  \
        (o)->sym = 0;                                                       \
        SET_OPERAND_TYPE((o), (type));                                      \
        SET_OPERAND_T((o), (t));                                            \
    } while (0)

#define INDEX_OPERAND(o, type, t, _class, _index, _scale)                   \
    do {                                                                    \
        (o)->class = (_class);    /* O_EA or O_MEM */                       \
        (o)->reg = REG_NONE;                                                \
        (o)->index = (_index);                                              \
        (o)->scale = (_scale);                                              \
        (o)->con.i = 0;                                                     \
        (o)->sym = 0;                                                       \
        SET_OPERAND_TYPE((o), (type));                                      \
        SET_OPERAND_T((o), (t));                                            \
    } while (0)

    /* MCH_OPERAND() is almost like struct assignment, but it preserves
       the type of dst, so named as it's used when populating MCH insn
       operands. (as such, we don't honor T_STRUN types.) */

#define MCH_OPERAND(dst, src)                                               \
    do {                                                                    \
        long _t = (dst)->t;                                                 \
        *(dst) = *(src);                                                    \
        (dst)->t = _t;                                                      \
    } while (0)

#define OPERAND_NONE(o)         ((o)->class == O_NONE)
#define OPERAND_EA(o)           ((o)->class == O_EA)
#define OPERAND_REG(o)          ((o)->class == O_REG)
#define OPERAND_MEM(o)          ((o)->class == O_MEM)

#define OPERAND_IMM(o)          ((o)->class == O_IMM)
#define OPERAND_PURE_IMM(o)     (OPERAND_IMM(o) && ((o)->sym == 0))

#define OPERAND_C(o, c)         (OPERAND_PURE_IMM(o)                        \
                                    && ((((o)->t & T_FLOATING)              \
                                         && ((o)->con.f == (c)))            \
                                    || ((o)->con.i == (c))))

#define OPERAND_ZERO(o)         OPERAND_C((o), 0)
#define OPERAND_ONE(o)          OPERAND_C((o), 1)
#define OPERAND_NEG1(o)         OPERAND_C((o), -1)

#define OPERAND_SAME_REG(o1, o2)    (OPERAND_REG(o1) && OPERAND_REG(o2)     \
                                        && ((o1)->reg == (o2)->reg))

/* an operand is "huge" if it's a 64-bit constant with a value that
   can't be represented in 32 signed bits. these are of interest
   because ATOM doesn't actually allow them as immediate operands. */

#define HUGE(i)                 (((i) < INT_MIN) || ((i) > INT_MAX))

#define OPERAND_HUGE(o)         (((o)->class == O_IMM)                      \
                                    && ((o)->t & (T_LONGS | T_PTR))         \
                                    && HUGE((o)->con.i))

/* instructions in a block are numbered sequentially, starting at
   INSN_INDEX_FIRST and extending up to (unlikely) INSN_INDEX_LAST.
   these indexes are used for, e.g., describing local live ranges. */

#define INSN_INDEX_NONE     -3              /* no index; for sentinel use */

#define INSN_INDEX_BEFORE   -2              /* range starts before block */
#define INSN_INDEX_PHI      -1                  /* includes phi headers */

#define INSN_INDEX_FIRST    0                   /* indices into host */
#define INSN_INDEX_LAST     (INT_MAX - 2)       /* block's VECTOR(insn) */

#define INSN_INDEX_BRANCH   (INT_MAX - 1)       /* includes the branch */
#define INSN_INDEX_AFTER    INT_MAX             /* extends beyond block */

struct insn
{
    int op;                                 /* I_* */

    unsigned is_volatile : 1;               /* volatile memory access */
    unsigned was_hoisted : 1;               /* see hoist.c */

    unsigned uses_mem    : 1;               /* for I_ASM insns */
    unsigned defs_mem    : 1;
    unsigned defs_cc     : 1;

    /* an I_LIR_CALL has a variable number of operands in addition to the
       two indicated by its op encoding. these operands are the arguments
       to the function being called. we also need to remember if the call
       is to a variadic function, since the ABI is different. */

    unsigned nr_args     : MAX_ARGS_BITS;
    unsigned is_variadic : 1;

    /* in contrast, I_MCH_CALL only knows how many registers
       of each class are needed for arguments to the function. */

    unsigned nr_iargs : MAX_IARGS_BITS;
    unsigned nr_fargs : MAX_FARGS_BITS;

    struct operand operand[];
};

DEFINE_VECTOR(insn, struct insn *);

#define NR_OPERANDS(insn)       (I_OPERANDS((insn)->op) + (insn)->nr_args)

/* I_ASM insns are universal and represent __asm() statements. they have a
   special format with no operands, having instead register maps for the
   input and output specifications and the user-supplied assembler text.

   in LIR blocks, the regmaps map pseudo registers -> physical registers.
   in MCH blocks, the regmaps map physical registers -> pseudo registers.

   this reversal (which occurs during lowering) means that, regardless of
   context, we need only consult the regmap 'from' fields for def/use info. */

struct asm_insn
{
    struct insn hdr;

    struct string *text;
    VECTOR(regmap) uses;
    VECTOR(regmap) defs;
};

/* when we wish to kill an insn without screwing up the insn indices
   in a block (so we don't disturb, e.g., live data) we point it here */

extern struct insn nop_insn;

/* create a new insn with the specified op. allocated from func_arena.
   nr_args specifies the number of argument operands for op == I_LIR_CALL. */

struct insn *new_insn(int op, int nr_args);

/* create a new insn that is a duplicate of src. */

struct insn *dup_insn(struct insn *src);

/* if an insn is commutative, swap the operands. if not, do nothing */

void commute_insn(struct insn *insn);

/* returns true iff the insns are identical */

int same_insn(struct insn *insn1, struct insn *insn2);

/* true if the insn USEs or DEFs the condition codes or aliased
   memory. do not call the function(s) directly, use the macros. */

int insn_defs_cc0(struct insn *insn);
int insn_uses_mem0(struct insn *insn);
int insn_defs_mem0(struct insn *insn);

#define INSN_USES_CC(i)     ((i)->op & I_FLAG_USES_CC)
#define INSN_DEFS_CC(i)     (((i)->op & I_FLAG_DEFS_CC) || insn_defs_cc0(i))
#define INSN_USES_MEM(i)    (((i)->op & I_FLAG_USES_MEM) || insn_uses_mem0(i))
#define INSN_DEFS_MEM(i)    (((i)->op & I_FLAG_DEFS_MEM) || insn_defs_mem0(i))
#define INSN_SIDEFFS(i)     (((i)->op & I_FLAG_SIDEFFS) || (i)->is_volatile)

/* true if the registers of operand i of insn are DEFd/USEd in this
   insn. to reiterate from above (and spell out what's below), only
   an O_REG operand[0] in an insn with a dst is DEFd; it may also be
   USEd. all other register appearances are USEd only.

   no special consideration is given to O_NONE operands: such operands appear
   ONLY in I_LIR_CALL as operand[0] (to indicate a void return). these macros
   will generate the correct results for O_NONE in that circumstance, but not
   necessarily any others ... */

#define OPERAND_DEFS_REGS(insn, i)  (((i) == 0)                             \
                                    && ((insn)->op & I_FLAG_HAS_DST)        \
                                    && ((insn)->operand[0].class == O_REG))

#define OPERAND_USES_REGS(insn, i)  (((i) != 0)                             \
                                    || !((insn)->op & I_FLAG_HAS_DST)       \
                                    || ((insn)->op & I_FLAG_USES_DST)       \
                                    || ((insn)->operand[i].class != O_REG))

/* add registers USEd by insn to the set. if flags contains
   I_FLAG_USES_CC/_MEM, then REG_CC/_MEM will be included. */

void insn_uses(struct insn *insn, VECTOR(reg) *set, int flags);

/* add registers DEFd by insn to the set. if flags contains
   I_FLAG_DEFS_CC/_MEM, then REG_CC/_MEM will be included. */

void insn_defs(struct insn *insn, VECTOR(reg) *set, int flags);

/* replace all USEs of reg in an insn with constant con/sym. only works on LIR
   insns- do not invoke on MCH insns. returns the number of substitutions */

int insn_substitute_con(struct insn *insn, int reg,
                        union con con, struct symbol *sym);

/* replace all USEs or DEFs (or both) of reg src with reg dst. returns the
   number of substitutions made. unlike the above, works for LIR or MCH.
   in MCH insns, a reg need only meet one criterion to be replaced (if it
   is both USEd and DEFd, it will always match one of the flags). dst can
   be either a pseudo reg or a machine reg, but src must always be a pseudo
   reg: some machine regs are inherent to an insn and can't be replaced. */

#define INSN_SUBSTITUTE_DEFS    0x00000001
#define INSN_SUBSTITUTE_USES    0x00000002

int insn_substitute_reg(struct insn *insn, int src, int dst, int flags);

/* determine if insn merely effects a copy from one register to another. if
   so, populate *dst and *src with the destination and source registers and
   return true; otherwise return false, leaving *dst and *src unchanged. */

int insn_is_copy(struct insn *insn, int *dst, int *src);

/* determine if an insn is a non-destructive sign extension, i.e., a cast
   from register to register which preserves the significant bits of `src'
   in the `dst' reg (by `significant' here we mean those bits which are
   needed to represent all values possible for the type of the `src'). the
   return values and behavior w/r/t to *dst and *src are the same as above. */

int insn_is_ext(struct insn *insn, int *dst, int *src);

/* determine if insn compares a register with 0. if so, populate reg
   with the reg that is compared and return true. false otherwise */

int insn_is_cmpz(struct insn *insn, int *reg);

/* like the above, but true if insn compares a reg with any pure constant */

int insn_is_cmp_con(struct insn *insn, int *reg);

/* output an instruction */

void out_insn(struct insn *insn);

/* output an operand. set rel if the operand is the target of a call or
   branch opcode; this will handle the pecularities of assembler syntax */

void out_operand(struct operand *o, int rel);

#endif /* INSN_H */

/* vi: set ts=4 expandtab: */
