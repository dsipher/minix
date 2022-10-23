/*****************************************************************************

   strtol.c                                         ux/64 standard library

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from COHERENT, Copyright (c) 1977-1995 by Robert Swartz.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

   3. Neither the name of the copyright holder nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

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

#include <stdlib.h>
#include <ctype.h>
#include <limits.h>
#include <errno.h>

static unsigned long ulquot[] =
{
                    ULONG_MAX / 2,  ULONG_MAX / 3,  ULONG_MAX / 4,
    ULONG_MAX / 5,  ULONG_MAX / 6,  ULONG_MAX / 7,  ULONG_MAX / 8,
    ULONG_MAX / 9,  ULONG_MAX / 10, ULONG_MAX / 11, ULONG_MAX / 12,
    ULONG_MAX / 13, ULONG_MAX / 14, ULONG_MAX / 15, ULONG_MAX / 16,
    ULONG_MAX / 17, ULONG_MAX / 18, ULONG_MAX / 19, ULONG_MAX / 20,
    ULONG_MAX / 21, ULONG_MAX / 22, ULONG_MAX / 23, ULONG_MAX / 24,
    ULONG_MAX / 25, ULONG_MAX / 26, ULONG_MAX / 27, ULONG_MAX / 28,
    ULONG_MAX / 29, ULONG_MAX / 30, ULONG_MAX / 31, ULONG_MAX / 32,
    ULONG_MAX / 33, ULONG_MAX / 34, ULONG_MAX / 35, ULONG_MAX / 36
};

static unsigned char ulrem[] =
{
                    ULONG_MAX % 2,  ULONG_MAX % 3,  ULONG_MAX % 4,
    ULONG_MAX % 5,  ULONG_MAX % 6,  ULONG_MAX % 7,  ULONG_MAX % 8,
    ULONG_MAX % 9,  ULONG_MAX % 10, ULONG_MAX % 11, ULONG_MAX % 12,
    ULONG_MAX % 13, ULONG_MAX % 14, ULONG_MAX % 15, ULONG_MAX % 16,
    ULONG_MAX % 17, ULONG_MAX % 18, ULONG_MAX % 19, ULONG_MAX % 20,
    ULONG_MAX % 21, ULONG_MAX % 22, ULONG_MAX % 23, ULONG_MAX % 24,
    ULONG_MAX % 25, ULONG_MAX % 26, ULONG_MAX % 27, ULONG_MAX % 28,
    ULONG_MAX % 29, ULONG_MAX % 30, ULONG_MAX % 31, ULONG_MAX % 32,
    ULONG_MAX % 33, ULONG_MAX % 34, ULONG_MAX % 35, ULONG_MAX % 36
};

static unsigned long lquot[] =
{
                    LONG_MAX / 2,   LONG_MAX / 3,   LONG_MAX / 4,
    LONG_MAX / 5,   LONG_MAX / 6,   LONG_MAX / 7,   LONG_MAX / 8,
    LONG_MAX / 9,   LONG_MAX / 10,  LONG_MAX / 11,  LONG_MAX / 12,
    LONG_MAX / 13,  LONG_MAX / 14,  LONG_MAX / 15,  LONG_MAX / 16,
    LONG_MAX / 17,  LONG_MAX / 18,  LONG_MAX / 19,  LONG_MAX / 20,
    LONG_MAX / 21,  LONG_MAX / 22,  LONG_MAX / 23,  LONG_MAX / 24,
    LONG_MAX / 25,  LONG_MAX / 26,  LONG_MAX / 27,  LONG_MAX / 28,
    LONG_MAX / 29,  LONG_MAX / 30,  LONG_MAX / 31,  LONG_MAX / 32,
    LONG_MAX / 33,  LONG_MAX / 34,  LONG_MAX / 35,  LONG_MAX / 36
};

static unsigned char lrem[] =
{
                    LONG_MAX % 2,   LONG_MAX % 3,   LONG_MAX % 4,
    LONG_MAX % 5,   LONG_MAX % 6,   LONG_MAX % 7,   LONG_MAX % 8,
    LONG_MAX % 9,   LONG_MAX % 10,  LONG_MAX % 11,  LONG_MAX % 12,
    LONG_MAX % 13,  LONG_MAX % 14,  LONG_MAX % 15,  LONG_MAX % 16,
    LONG_MAX % 17,  LONG_MAX % 18,  LONG_MAX % 19,  LONG_MAX % 20,
    LONG_MAX % 21,  LONG_MAX % 22,  LONG_MAX % 23,  LONG_MAX % 24,
    LONG_MAX % 25,  LONG_MAX % 26,  LONG_MAX % 27,  LONG_MAX % 28,
    LONG_MAX % 29,  LONG_MAX % 30,  LONG_MAX % 31,  LONG_MAX % 32,
    LONG_MAX % 33,  LONG_MAX % 34,  LONG_MAX % 35,  LONG_MAX % 36
};

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

    /* determine limits for overflow computation. use */
    /* a table to avoid costly divisions on every call. */

    if (uflag) {
        quot = ulquot[base - 2];
        rem = ulrem[base - 2];
    } else {
        quot = lquot[base - 2];
        rem = lrem[base - 2];
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
