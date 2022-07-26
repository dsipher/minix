/*****************************************************************************

  atol.c                                            tahoe/64 standard library

             derived from COHERENT, Copyright (C) 1977-1995 by Robert Swartz.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>
#include <ctype.h>

long atol(const char *nptr)
{
    long val;
    int c;
    int sign;

    val = sign = 0;

    while (isspace(c = *nptr++))            /* leading whitespace */
        ;

    if (c == '-') {                         /* optional sign */
        sign = 1;
        c = *nptr++;
    } else if (c == '+')
        c = *nptr++;

    for (; isdigit(c); c = *nptr++)         /* digits */
        val = val * 10 + c - '0';

    return (sign ? -val : val);
}

/* vi: set ts=4 expandtab: */
