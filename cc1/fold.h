/*****************************************************************************

   fold.h                                              jewel/os c compiler

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

#ifndef FOLD_H
#define FOLD_H

#include "heap.h"

struct block;

/* conditional constant propagation and constant folding */

void opt_lir_fold(void);

/* constant propagation/folding per-block data. per a typical
   optimistic algorithm, a register has one of three states:

    undef:          nothing known. no entry in constants, no bit in nac.
    constant:       known constant. constants vector holds value.
    nac:            definitely not a constant. bit set in nac.

   in the vector the constant is normalized to the type of the reg
   it is attached to, so comparisons when meeting work properly.
   the constants vector is kept sorted by REG_PRECEDES() order. */

struct constant
{
    int reg;
    union con con;
    struct symbol *sym;
};

DEFINE_VECTOR(constant, struct constant);

/* true if the constant is pure, i.e., references no assembler symbol */

#define PURE_CONSTANT(c)            ((c).sym == 0)

/* determine if two constant values are equal. we ignore the reg field.
   type punning makes this work for floating-point values, conservatively. */

#define SAME_CONSTANT(c1, c2)       (((c1).con.u == (c2).con.u) &&          \
                                       ((c1).sym == (c2).sym))

struct fold_state
{
    VECTOR(bitvec) nac;
    VECTOR(constant) constants;
};

/* we maintain two copies of the state per block. state is the
   working state; prop is the exit state propagated to successors. */

struct fold
{
    struct fold_state state;
    struct fold_state prop;
};

#define FOLD_IS_NAC(b, r)   BITVEC_IS_SET((b)->fold.state.nac, REG_INDEX(r))
#define PROP_IS_NAC(b, r)   BITVEC_IS_SET((b)->fold.prop.nac, REG_INDEX(r))

#define NR_FOLD_CONSTANTS(b)    VECTOR_SIZE((b)->fold.state.constants)
#define FOLD_CONSTANT(b, k)     VECTOR_ELEM((b)->fold.state.constants, (k))

#define NR_PROP_CONSTANTS(b)    VECTOR_SIZE((b)->fold.prop.constants)
#define PROP_CONSTANT(b, k)     VECTOR_ELEM((b)->fold.prop.constants, (k))

/* the FOLD macros are duck-typed: the operands (O, L, R) can have any
   struct type which has union con con and struct symbol *sym members
   (which just so happens to describe struct tree and struct constant).
   all of these macros expect pure operands (sym == 0), except as noted
   below. it is the caller's responsibility to normalize the results. */

#define FOLD_UNARY(T, O, OP)                                                \
    do {                                                                    \
        if ((T) & T_FLOATING)                                               \
            (O)->con.f = OP (O)->con.f;                                     \
        else                                                                \
            (O)->con.i = OP (O)->con.i;                                     \
    } while (0)

#define FOLD_UNARY_I(T, O, OP)                                              \
    do {                                                                    \
        (O)->con.i = OP (O)->con.i;                                         \
    } while (0)

/* FOLD_UNARY_B() is only for discrete types (like _I) but
   differentiates between 64-bit values and other values. */

#define BSF(x)      __builtin_ctz(x)
#define BSFL(x)     __builtin_ctzl(x)
#define BSR(x)      (__builtin_clz(x) ^ 31)
#define BSRL(x)     (__builtin_clzl(x) ^ 63)

#define FOLD_UNARY_B(T, O, OP, OPL)                                         \
    do {                                                                    \
        if ((T) & T_LONGS)                                                  \
            (O)->con.i = OPL ((O)->con.i);                                  \
        else                                                                \
            (O)->con.i = OP ((O)->con.i);                                   \
    } while (0)

/* normalize a commutative operation by placing the impure
   operand, if any, on the left, as required by FOLD_BINARY(). */

#define FOLD_COMMUTE(TYPE, L, R)                                            \
    do {                                                                    \
        if (((R)->sym) && !((L)->sym == 0))                                 \
            SWAP(TYPE, (L), (R));                                           \
    } while (0)

/* binary operations place the result in the L (left) operand. under most
   circumstances, both operands must be pure. however, addition/subtraction
   be done if L is an impure operand and R is pure. further, subtraction is
   possible if L and R reference the same symbol. in the latter case, invoke
   FOLD_PRESUBTRACT() before FOLD_BINARY(). */

#define FOLD_PRESUBTRACT(L, R)                                              \
    do {                                                                    \
        if ((L)->sym == (R)->sym)                                           \
            (L)->sym = (R)->sym = 0;                                        \
    } while (0)

/* we never actually touch sym here though it is potentially present for
   addition or subtraction; it remains in L to become part of the result */

#define FOLD_BINARY(T, L, R, OP)                                            \
    do {                                                                    \
        if ((T) & T_FLOATING)                                               \
            (L)->con.f = (L)->con.f OP (R)->con.f;                          \
        else if ((T) & T_SIGNED)                                            \
            (L)->con.i = (L)->con.i OP (R)->con.i;                          \
        else                                                                \
            (L)->con.u = (L)->con.u OP (R)->con.u;                          \
    } while (0)

#define FOLD_BINARY_I(T, L, R, OP)                                          \
    do {                                                                    \
        if ((T) & T_SIGNED)                                                 \
            (L)->con.i = (L)->con.i OP (R)->con.i;                          \
        else                                                                \
            (L)->con.u = (L)->con.u OP (R)->con.u;                          \
    } while (0)

/* shift counts greater than or equal to the number of bits
   in the shifted type are technically undefined; we apply
   these masks because the front end may have stripped off
   masks supplied by the user. see shiftmask0() in tree.c */

#define FOLD_SHIFT(T, L, R, OP)                                             \
    do {                                                                    \
        int _mask = (T & T_LONGS) ? 63 : 31;                                \
                                                                            \
        if ((T) & T_SIGNED)                                                 \
            (L)->con.i = (L)->con.i OP ((R)->con.i & _mask);                \
        else                                                                \
            (L)->con.u = (L)->con.u OP ((R)->con.u & _mask);                \
    } while (0)

/* zero- or sign-extend an integer constant
   so its value is in range of type t */

void normalize_con(long t, union con *conp);

/* returns true if the integral constant
   is in the range of type t */

int con_in_range(long t, union con *conp);

/* attempt to cast a constant from one type to another. if not possible
   (read: casting an impure constant to a float) the argument is left
   unchanged and false is returned. otherwise, performs the conversion
   and returns true. the caller must call normalize_con() afterwards.

   pure indicates whether *conp is pure; idiomatically 'sym == 0'. */

int cast_con(long to_t, long from_t, union con *conp, int pure);

#endif /* FOLD_H */

/* vi: set ts=4 expandtab: */
