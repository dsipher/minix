/*****************************************************************************

   dvn.h                                                  minix c compiler

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

#ifndef DVN_H
#define DVN_H

#include "heap.h"
#include "type.h"

/* dominator value numbering */

void opt_lir_dvn(void);

/* each value in a function is assigned a number (which serves as an index
   into the values vector) and an associated struct value. all values have
   valid v, number, and t. the use of other fields is determined by class:

            V_NONE is for opaque values.

            V_IMM represents a constant value; the con and sym fields are
            as expected. simpatico values share an entry normalized to t.

            V_EXPR is for computed values: insn points to the insn which
            generated the original value; t is the type of the result. */

#define V_NONE      0
#define V_IMM       1
#define V_EXPR      2

struct value
{
    int v;                          /* value class (V_*) */
    int number;                     /* and its number */

    unsigned t : T_BASE_BITS;

    union
    {
        struct                          /* V_IMM */
        {
            union con con;
            struct symbol *sym;
        };

        struct insn *insn;              /* V_EXPR */
    };
};

DEFINE_VECTOR(value, struct value);
DEFINE_VECTOR(value_ref, struct value *);

/* special value numbers. FRAME_NUMBER and GLOBAL_NUMBER
   only appear in the base field of reload entries. */

#define NO_NUMBER       -1
#define FRAME_NUMBER    -2
#define GLOBAL_NUMBER   -3

#define REAL_NUMBER(v)  (v >= 0)

/* we track which values are held by which registers in a simple map.
   a number may appear multiple times, since multiple regs may/often
   do hold the same value, but a reg can have at most one entry. */

struct regval { int reg; int number; };
DEFINE_VECTOR(regval, struct regval);

/* a reload represents a value of stored in memory. the address of the
   value is base (itself a value) plus sym+offset. two special values for
   base, FRAME_NUMBER and GLOBAL_NUMBER, represent offsets from the frame
   or from virtual address 0, respectively. store holds the address of the
   insn which stored this value to its address, if it is known and has not
   yet been committed. (in practice, sym is 0 unless base is GLOBAL_NUMBER.) */

struct reload
{
    int number;
    int base;
    long offset;
    struct symbol *sym;
    struct insn **store;
};

DEFINE_VECTOR(reload, struct reload);

/* per-block DVN data. does not persist, so it is
   allocated by opt_dvn() in the local_arena only. */

struct dvn
{
    VECTOR(value_ref) exprs;    /* ordered by value number */
    VECTOR(regval) regvals;     /* ordered by reg (with REG_PRECEDES) */
    VECTOR(reload) reloads;     /* ordered by (base, offset, sym, t) */
};

#define EXPR(b, n)          VECTOR_ELEM((b)->dvn.exprs, (n))
#define NR_EXPRS(b)         VECTOR_SIZE((b)->dvn.exprs)
#define REGVAL(b, n)        VECTOR_ELEM((b)->dvn.regvals, (n))
#define NR_REGVALS(b)       VECTOR_SIZE((b)->dvn.regvals)
#define RELOAD(b, n)        VECTOR_ELEM((b)->dvn.reloads, (n))
#define NR_RELOADS(b)       VECTOR_SIZE((b)->dvn.reloads)

#endif /* DVN_H */

/* vi: set ts=4 expandtab: */
