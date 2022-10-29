/*****************************************************************************

   optpat.c                                              ux/64 line editor

******************************************************************************

    derived from source found in Minix 2, Copyright 1987 Brian Beattie.

              Permission to copy and/or distribute granted
              under the following conditions:

                 (1) No charge may be made other than
                     reasonable charges for reproduction.
                 (2) This notice must remain intact.
                 (3) No further restrictions may be added.

*****************************************************************************/

#include <stdio.h>
#include "tools.h"
#include "ed.h"

TOKEN *oldpat;

TOKEN *optpat(void)
{
    char delim, str[MAXPAT], *cp;

    delim = *inptr++;
    cp = str;

    while (*inptr != delim && *inptr != NL) {
        if (*inptr == ESCAPE && inptr[1] != NL)
            *cp++ = *inptr++;

        *cp++ = *inptr++;
    }

    *cp = EOS;
    if (*str == EOS) return(oldpat);
    if (oldpat) unmakepat(oldpat);
    oldpat = getpat(str);

    return(oldpat);
}

/* vi: set ts=4 expandtab: */
