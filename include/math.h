/*****************************************************************************

   math.h                                              ux/64 system header

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

#ifndef _MATH_H
#define _MATH_H

/* constants difficult to represent in base 10 are in __ieee_val.s.
   aside from being unavailable to constant folding, there are no
   serious penalities associated with these as memory references;
   ATOM does not have insns with constant floating-point operands. */

extern double __huge_val;               /* +infinity */

extern double __double_2_n969;          /* 2.0 ** -969 */
extern double __double_2_514;           /* 2.0 ** 514 */
extern double __double_2_1023;          /* 2.0 ** 1023 */

#define HUGE_VAL    (__huge_val)

extern char *__dtefg(char *, double *, int, int, int, int *);

/* internal library function. compute 10.0^exp. */

extern double __pow10(int exp);

/* an IEEE 754 double broken down in various ways
   for manipulation by internal library functions */

#define __DBL_MANH_SIZE     20
#define __DBL_MANL_SIZE     32

union __ieee_double
{
    double          f;
    unsigned long   i;

    struct
    {
        int lsw;
        int msw;
    } words;

    struct
    {
        unsigned manl   : __DBL_MANL_SIZE;
        unsigned manh   : __DBL_MANH_SIZE;
        unsigned exp    : 11;
        unsigned sign   : 1;
    } bits;
};

extern double modf(double, double *);
extern double frexp(double, int *);

/* multiply double by integral power of 2 */

extern double ldexp(double x, int exp);

#endif /* _MATH_H */

/* vi: set ts=4 expandtab: */
