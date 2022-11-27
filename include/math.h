/*****************************************************************************

   math.h                                              minix system header

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

/* internal library function. compute 10.0 ** exp. */

extern double __pow10(int exp);

/* internal library function.
   evaluate a polynomial of the form:

   c[n-1] * x^(n-1) + ... + c[1] * x + c[0]

   there must be at least two terms. */

extern double __poly(double x, const double c[], int n);

/* internal library function. evaluate 2.0 ** x. */

extern double __two(double x);

/* some useful [internal] constants */

#define __L2HUGE_VAL    1023.0                      /* log2(inf) */
#define __L2L2P         6                           /* log2(log2(prec)) */
#define __PI            0.31415926535897932e+01     /* pizza */
#define __SQRT2         0.14142135623730950e+01     /* sqrt(2) */
#define __LOG2B10       0.30102999566398119e+00     /* log10(2) */
#define __LOG10B2       0.33219280948873623e+01     /* log2(10) */
#define __LOG10BE       0.23025850929940456e+01     /* log(10) */
#define __LOGEB2        0.14426950408889634e+01     /* log2(e) */

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

/* compute e ** x */

extern double exp(double x);

/* multiply double by integral power of 2 */

extern double ldexp(double x, int exp);

/* compute natural logarithm */

extern double log(double x);

/* compute base 10 logarithm */

extern double log10(double x);

/* compute x ** y */

extern double pow(double x, double y);

/* compute square root of x */

extern double sqrt(double x);

/* trignometric functions */

extern double cos(double x);
extern double sin(double x);

/* inverse trigonometric functions */

extern double atan(double x);
extern double atan2(double y, double x);

#endif /* _MATH_H */

/* vi: set ts=4 expandtab: */
