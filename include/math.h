/*****************************************************************************

  math.h                                            tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _MATH_H
#define _MATH_H

extern double __huge_val;
extern double __frexp_adj;

#define HUGE_VAL    (__huge_val)

extern char *__dtefg(char *, double *, int, int, int, int *);

extern double modf(double, double *);
extern double frexp(double, int *);
extern double __pow10(int);

/* an IEEE 754 double broken down in multiple
   ways for the convenience of c functions */

#define __DBL_MANH_SIZE     20
#define __DBL_MANL_SIZE     32

union __ieee_double
{
    double value;

    struct
    {
        int lsw;
        int msw;
    } words;

    struct
    {
        unsigned manl : __DBL_MANL_SIZE;
        unsigned manh : __DBL_MANH_SIZE;
        unsigned exp : 11;
        unsigned sign : 1;
    } bits;
};

#endif /* _MATH_H */

/* vi: set ts=4 expandtab: */
