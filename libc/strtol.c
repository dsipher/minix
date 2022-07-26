/*****************************************************************************

  strtol.c                                          tahoe/64 standard library

             derived from COHERENT, Copyright (C) 1977-1995 by Robert Swartz.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>
#include <ctype.h>
#include <limits.h>
#include <errno.h>

static unsigned long __strtoul(const char *nptr, char **endptr,
                               int base, int uflag)
{
    const char *cp;
    unsigned long val;
    int c, sign, overflow, pflag, dlimit, ulimit, llimit;
    unsigned long quot, rem;

    cp = nptr;
    val = pflag = overflow = sign = 0;

    /* leading white space */

    while (isspace(c = *cp++))
        ;

    /* optional sign */

    switch(c) {
    case '-':
        sign = 1;
        /* fall through... */
    case '+':
        c = *cp++;
    }

    /* determine implicit base */

    if (base == 0) {
        if (c == '0')
            base = (*cp == 'x' || *cp == 'X') ? 16 : 8;
        else if (isdigit(c))
            base = 10;
        else {                  /* expected form not found */
            cp = nptr;
            goto done;
        }
    }

    /* skip optional hex base "0x" or "0X" */

    if (base == 16 && c == '0' && (*cp == 'x' || *cp == 'X')) {
        ++pflag;
        ++cp;
        c = *cp++;
    }

    /* initialize legal character limits */

    dlimit = '0' + base;
    ulimit = 'A' + base - 10;
    llimit = 'a' + base - 10;

    /* the next character must be a legitimate digit; e.g. " +@" fails. */
    /* watch out for e.g. "0xy", which is "0" followed by "xy". */

    if (!((isdigit(c) && c < dlimit)
      || (isupper(c) && c < ulimit)
      || (islower(c) && c < llimit))) {
        cp = (pflag) ? cp - 2 : nptr;
        goto done;
    }

    /* determine limits for overflow computation. */
    /* this would use ldiv() if it worked for unsigned long */

    if (uflag) {
        quot = ULONG_MAX / base;
        rem = ULONG_MAX % base;
    } else {
        quot = LONG_MAX / base;
        rem = LONG_MAX % base;
    }

    /* process digit string */

    for (;; c = *cp++) {
        if (isdigit(c) && c < dlimit)
            c -= '0';
        else if (isupper(c) && c < ulimit)
            c -= 'A'-10;
        else if (islower(c) && c < llimit)
            c -= 'a'-10;
        else {
            --cp;
            break;
        }

    if (val < quot || (val == quot && c <= rem))
        val = val * base + c;
    else
        ++overflow;
    }

done:

    /* store end pointer and return appropriate result */

    if (endptr != (char **) 0)
        *endptr = (char *) cp;

    if (overflow) {
        errno = ERANGE;

        if (uflag)
            return ULONG_MAX;

        return sign ? LONG_MIN : LONG_MAX;
    }

    return sign ? -val : val;
}


long strtol(const char *nptr, char **endptr, int base)
{
        return __strtoul(nptr, endptr, base, 0);
}

unsigned long strtoul(const char *nptr, char **endptr, int base)
{
        return __strtoul(nptr, endptr, base, 1);
}

/* vi: set ts=4 expandtab: */
