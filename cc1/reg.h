/*****************************************************************************

   reg.h                                                  minix c compiler

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

#ifndef REG_H
#define REG_H

#include "symbol.h"
#include "heap.h"

/* maximum number of registers used for passing function arguments
   (of each class) and the number of bits needed to count them. */

#define MAX_IARGS_BITS  3
#define MAX_FARGS_BITS  4

#define MAX_IARGS       6
#define MAX_FARGS       8

extern int iargs[MAX_IARGS];    /* registers used for discrete arguments */
extern int fargs[MAX_FARGS];    /* .................. floating-point ... */

/* scratch registers- those not preserved
   across function calls- enumerated */

#define MAX_ISCRATCH    9
#define MAX_FSCRATCH    8

extern int iscratch[MAX_ISCRATCH];
extern int fscratch[MAX_FSCRATCH];

/* we represent registers as simple 32-bit integers divided into 3 fields:

        the type indicates the register class, either integer
        (general purpose), floating-point (xmm), or special.

        the index is a unique 0-based index value for the register. the
        first NR_MACHINE_REGS indices are reserved for machine registers.
        all others are pseudo registers, whose indices are allocated in a
        contiguous range starting immediately after the machine registers.

        the sub is the subscript of the register, used when we split a
        pseudo register into separate instances for analysis (e.g., as
        one would do in SSA). no machine registers or special registers
        are ever subscripted.

   the fields are arranged so that REG_PRECEDES() is trivial. */

#define REG_TYPE_MASK       0xC0000000                      /* bits [31:30] */

#define REG_TYPE_SPECIAL    0x40000000
#define REG_TYPE_GP         0x80000000
#define REG_TYPE_XMM        0xC0000000
#define REG_TYPE_NONE       0x00000000

#define REG_TYPE(r)         ((r) & REG_TYPE_MASK)
#define REG_SPECIAL(r)      (REG_TYPE(r) == REG_TYPE_SPECIAL)
#define REG_XMM(r)          (REG_TYPE(r) == REG_TYPE_XMM)
#define REG_GP(r)           (REG_TYPE(r) == REG_TYPE_GP)

#define REG_INDEX_MASK      0x3FFFC000                      /* bits[29:14] */
#define MAX_REGS            65536
#define REG_INDEX_SHIFT     14
#define REG_INDEX(r)        (((r) & REG_INDEX_MASK) >> REG_INDEX_SHIFT)

#define REG_SET_INDEX(r, i) ((r) = (((r) & ~REG_INDEX_MASK)                 \
                                 |  ((i) << REG_INDEX_SHIFT)))

#define REG_SUB_MASK        0x00003FFF                      /* bits[13:0] */
#define MAX_REG_SUBS        16384
#define REG_SUB_SHIFT       0
#define REG_SUB(r)          (((r) & REG_SUB_MASK) >> REG_SUB_SHIFT)

#define REG_SET_SUB(r, s)   ((r) = ((r) & ~REG_SUB_MASK)                    \
                                 |  ((s) << REG_SUB_SHIFT))

#define REG_BASIS(r)        ((r) & ~REG_SUB_MASK)

#define NR_GP_REGS          16      /* indices  0 .. 15 */
#define NR_XMM_REGS         16      /*    then 16 .. 31 */
#define NR_SPECIAL_REGS     2       /* finally 32 .. 33 */

#define NR_MACHINE_REGS     (NR_GP_REGS + NR_XMM_REGS + NR_SPECIAL_REGS)

#define MACHINE_REG(r)      (REG_INDEX(r) < NR_MACHINE_REGS)
#define PSEUDO_REG(r)       (!MACHINE_REG(r))

/* for machine GP and XMM registers ONLY, we can convert
   a REG_INDEX into a correctly-classified REG value. */

#define REG(r)              (((r) < NR_GP_REGS)                             \
                                    ? (((r) << REG_INDEX_SHIFT)             \
                                                 | REG_TYPE_GP)             \
                                    : (((r) << REG_INDEX_SHIFT)             \
                                                 | REG_TYPE_XMM))

#define REG_NONE            0           /* must remain 0 */

#define REG_RAX             REG(0)
#define REG_RCX             REG(1)
#define REG_RDX             REG(2)
#define REG_RSI             REG(3)
#define REG_RDI             REG(4)
#define REG_R8              REG(5)
#define REG_R9              REG(6)
#define REG_R10             REG(7)
#define REG_R11             REG(8)
#define REG_RBX             REG(9)
#define REG_RSP             REG(10)
#define REG_RBP             REG(11)
#define REG_R12             REG(12)
#define REG_R13             REG(13)
#define REG_R14             REG(14)
#define REG_R15             REG(15)

#define REG_XMM0            REG(16)
#define REG_XMM1            REG(17)
#define REG_XMM2            REG(18)
#define REG_XMM3            REG(19)
#define REG_XMM4            REG(20)
#define REG_XMM5            REG(21)
#define REG_XMM6            REG(22)
#define REG_XMM7            REG(23)
#define REG_XMM8            REG(24)
#define REG_XMM9            REG(25)
#define REG_XMM10           REG(26)
#define REG_XMM11           REG(27)
#define REG_XMM12           REG(28)
#define REG_XMM13           REG(29)
#define REG_XMM14           REG(30)
#define REG_XMM15           REG(31)

/* special registers: REG_CC is for the condition codes, which are of course
   (part of) an actual register. we never mention the register explicitly, but
   it is DEFd and USEd implicitly in many instructions. REG_MEM is for aliased
   memory; we don't do extensive alias analysis, but instead treat all reads
   or writes to aliased memory as operations on this special register. */

#define REG_CC              ( (32 << REG_INDEX_SHIFT) | REG_TYPE_SPECIAL )
#define REG_MEM             ( (33 << REG_INDEX_SHIFT) | REG_TYPE_SPECIAL )

/* register sets are simply vectors that are maintained in order and free
   of duplicates. the order is dicated by REG_PRECEDES(), which is true if
   r1 should precede r2 in the vector; it ensures that all registers with
   the same index are adjacent, and appear in ascending order of sub. */

#define REG_PRECEDES(r1, r2)    (((unsigned) (r1)) < ((unsigned) (r2)))

DEFINE_VECTOR(reg, int);

/* iterate over a register set. that this will terminate early if it
   encounters a REG_NONE element in the set (which should not happen) */

#define FOR_EACH_REG(regs, i, reg)                                          \
    for ((i) = 0; ((i) < VECTOR_SIZE(regs))                                 \
                  && ((reg) = VECTOR_ELEM((regs), (i))); ++(i))

/* reg set operations (see heap.h) */

void add_reg(VECTOR(reg) *set, int reg);                /* SET_ADD */

void remove_reg(VECTOR(reg) *set, int reg);             /* SET_REMOVE */

int contains_reg(VECTOR(reg) *set, int reg);            /* SET_CONTAINS */

int same_regs(VECTOR(reg) *set1, VECTOR(reg) *set2);    /* SAME_SET */

void union_regs(VECTOR(reg) *dst, VECTOR(reg) *src1,    /* UNION_SETS */
                                  VECTOR(reg) *src2);

void intersect_regs(VECTOR(reg) *dst,                   /* INTERSECT_SETS */
                    VECTOR(reg) *src1,
                    VECTOR(reg) *src2);

void diff_regs(VECTOR(reg) *dst, VECTOR(reg) *src1,     /* DIFF_SETS */
                                 VECTOR(reg) *src2);

/* this is a specialized union of register sets, used primarily
   in the context of reaching definitions. dst becomes the union
   of dst and src AFTER first stripped dst of any regs with the
   same index as any regs in src.

                    dst = [ %i0.1 %i0.2 %i2 %i5.1 %i5.2 ]
   and              src = [ %i0.3 %i2.3 %i2.4 %i6.3 ]
   then on return   dst = [ %i0.3 %i2.3 %i2.4 %i5.1 %i5.2 %i6.3 ]

   %i0.1 and %i0.2 have been replaced by %i0.3, and %i2 has been
   replaced by %i2.3 and %i2.4. %i5.1 and %i5.2 are undisturbed,
   since they are not mentioned in src; %i6.3 is imported from src. */

void replace_indexed_regs(VECTOR(reg) *dst, VECTOR(reg) *src);

/* select the set of registers from src which share
   a basis register with reg and add them to dst */

void select_indexed_regs(VECTOR(reg) *dst, VECTOR(reg) *src, int reg);

/* output register set in human-readable form (for verbose output) */

void out_regs(VECTOR(reg) *set);

/* we use regmaps for simple register -> register mappings. */

struct regmap { int from; int to; };
DEFINE_VECTOR(regmap, struct regmap);

/* simple [total] ordering for VECTOR(regmap). the ordering is established
   for efficiency in manipulating regmaps only. it has no other meaning so
   we do not bother to map with REG_PRECEDES */

#define REGMAP_PRECEDES(r1, r2)        (((r1).from < (r2).from) ||          \
                                            (((r1).from == (r2).from)       \
                                            && ((r1).to < (r2).to)))

/* add a new mapping to the regmap. duplicates are retained. */

void add_regmap(VECTOR(regmap) *map, int from, int to);

/* returns true if the regmaps are identical */

int same_regmap(VECTOR(regmap) *map1, VECTOR(regmap) *map2);

/* add all regs from the regmap's from fields
   (except REG_NONE) to the register set. */

void regmap_regs(VECTOR(regmap) *map, VECTOR(reg) *set);

/* replace all instances of reg src with reg dst in the
   regmap. returns the number of substitutions made. */

int regmap_substitute(VECTOR(regmap) *map, int src, int dst);

/* invert the regmap, i.e., swap to/from for every entry */

void invert_regmap(VECTOR(regmap) *map);

/* strip any subscripts from regs in the regmap */

void undecorate_regmap(VECTOR(regmap) *map);

/* output register map in human-readable form (for verbose output) */

void out_regmap(VECTOR(regmap) *map);

/* all assigned register indices fall in the range 0..(nr_assigned_regs - 1).
   since this is reset for every function, the index space is densely packed,
   and it's feasible to use register indices to index non-sparse vectors. */

extern int nr_assigned_regs;

/* map registers to the symbols they were assigned to. offset by
   NR_MACHINE_REGS, since machine registers are never assigned. */

extern VECTOR(symbol) reg_to_symbol;

#define REG_TO_SYMBOL(r)        VECTOR_ELEM(reg_to_symbol,                  \
                                            REG_INDEX(r) - NR_MACHINE_REGS)

/* discard all register <-> symbol mappings and reset nr_assigned_regs. */

void reset_regs(void);

/* assign a new pseudo-register for the specified symbol. determines the
   appropriate register type, records the assignment for REG_TO_SYMBOL(). */

int assign_reg(struct symbol *sym);

/* print a register to the specified file in a format acceptable to the
   assembler. type t is used when needed to determine the form of the reg */

void print_reg(FILE *fp, int reg, long t);

#endif /* REG_H */

/* vi: set ts=4 expandtab: */
