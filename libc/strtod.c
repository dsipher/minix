/*****************************************************************************

  strtod.c                                          tahoe/64 standard library

             derived from COHERENT, Copyright (C) 1977-1995 by Robert Swartz.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>
#include <limits.h>
#include <float.h>
#include <ctype.h>
#include <errno.h>
#include <math.h>

#define DBL_EXP_10_DIG  3       /* max digits in legal IEEE double exponent */

/* flag bits */

#define NEG     ( 0x00000001 )          /* negative significand */
#define DOT     ( 0x00000002 )          /* decimal point seen */
#define NEGEXP  ( 0x00000004 )          /* negative exponent */
#define BIG     ( 0x00000008 )          /* significand too big for ulong */
#define OVER    ( 0x00000010 )          /* overflow */
#define UNDER   ( 0x00000020 )          /* underflow */

double strtod(const char *nptr, char **endptr)
{
    const char *cp;
    const char *savcp;
    int c, flag, eexp;
    unsigned long val;
    int exp, edigits, sdigits, vdigits;
    double d;

    cp = nptr;
    val = flag = exp = sdigits = vdigits = 0;
    d = 0;

    while (isspace(c = *cp++))          /* leading whitespace */
        ;

    switch (c)
    {
    case '-':
        flag |= NEG;
        /* fall thru */
    case '+':
        c = *cp++;
    }

    /* next character must be a decimal digit,
       or '.' followed by a decimal digit. */

    if (!isdigit(c) && ((c != '.') || ((c == '.') && !isdigit(*cp)))) {
        cp = nptr;
        goto done;
    }

    /* significand: sequence of decimal digits with optional '.'.
       compute chunks in val (for efficiency) until it overflows.
       d * _pow10(vdigits) + val contains the current significand. */

    for (; ; c = *cp++) {
        if (isdigit(c)) {
            c -= '0';

            if (c == 0 && (flag & DOT)) {
                /* check for trailing zeros to avoid imprecision.  */

                const char *look;
                int d;

                for (look = cp; (d = *look++) == '0'; )
                    ;               /* skip a trailing zero */

                if (!isdigit(d)) {      /* ignore zeroes */
                    cp = look;
                    c = d;
                    break;
                }
            }

            if (sdigits != 0 || c != 0)
                ++sdigits;      /* significant digits seen */

            if (val > (ULONG_MAX - 9) / 10) {
                /* significand too big for val, use d */
                if (flag & BIG)
                    d = d * __pow10(vdigits) + val;
                else {
                    d = val;
                    flag |= BIG;
                }

                vdigits = 1;
                val = c;
            } else {
                ++vdigits;      /* decimal digits in val */
                val = val * 10 + c;
            }

            if (flag & DOT)
                --exp;          /* implicit exponent */
        } else if (c == '.' && (flag & DOT) == 0)
            flag |= DOT;
        else
            break;
    }

    /* significand to d */

    if (flag & BIG)
        d = d * __pow10(vdigits) + val;
    else
        d = val;

    /* optional exponent: 'E' or 'e', optional sign, decimal digits */

    if (c == 'e'  ||  c == 'E') {
        savcp = cp - 1;         /* save in case exponent absent */

        switch (c = *cp++) {        /* optional sign */
        case '-':
            flag |= NEGEXP;
            /* fall thru */
        case '+':
            c = *cp++;
        }

        /* next character must be decimal digit */

        if (!isdigit(c)) {
            cp = savcp;             /* restore pre-'E' value */
            goto done;
        }

        /* decimal digits */

        for (eexp = edigits = 0; isdigit(c); c = *cp++) {
            if (edigits != 0 || c != '0')
                ++edigits;      /* count exp digits for overflow */

            eexp = eexp * 10 + c - '0';
        }

        if (edigits > DBL_EXP_10_DIG) {
            flag |= ((flag & NEGEXP) ? UNDER : OVER);
            --cp;
            goto done;
        }

        /* adjust explicit exponent for digits read after '.' */

        if (flag & NEGEXP)
            exp -= eexp;
        else
            exp += eexp;
    }
    --cp;

    /* reconcile the significand with the exponent */

    if (exp <= DBL_MIN_10_EXP)
        flag |= UNDER;          /* exponent underflow */
    else if (exp + sdigits - 1 >= DBL_MAX_10_EXP)
        flag |= OVER;           /* exponent overflow */
    else if (exp != 0)
        d *= __pow10(exp);

done:
    if (endptr != 0)
        *endptr = (char *) cp;

    if (flag & UNDER) {
        errno = ERANGE;
        return 0.0;
    }

    if (flag & OVER) {
        errno = ERANGE;
        d = HUGE_VAL;
    }

    return ((flag & NEG) ? -d : d);
}

/* vi: set ts=4 expandtab: */
