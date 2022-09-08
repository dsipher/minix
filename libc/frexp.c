/*****************************************************************************

   frexp.c                                       jewel/os standard library

                       Copyright (c) 2004 David Schultz <das@freebsd.org>.
  Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

           FIXME: replace with version derived from MINIX or COHERENT libc

*****************************************************************************/

#include <math.h>

double frexp(double d, int *ex)
{
    union __ieee_double u;

    u.value = d;

    switch (u.bits.exp) {
    case 0:     /* 0 or subnormal */
        if ((u.bits.manl | u.bits.manh) == 0) {
            *ex = 0;
        } else {
            u.value *= __frexp_adj;
            *ex = u.bits.exp - 1536;
            u.bits.exp = 1022;
        }
        break;

    case 2047:  /* infinity or NaN; value of *ex is unspecified */
        break;

    default:    /* normal */
        *ex = u.bits.exp - 1022;
        u.bits.exp = 1022;
        break;
    }

    return (u.value);
}

/* vi: set ts=4 expandtab: */
