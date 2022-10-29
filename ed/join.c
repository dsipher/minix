/*****************************************************************************

   join.c                                                ux/64 line editor

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

int join(int first, int last)
{
    char buf[MAXLINE];
    char *cp = buf, *str;
    int num;

    if (first <= 0 || first > last || last > lastln) return(ERR);

    if (first == last) {
        curln = first;
        return 0;
    }

    for (num = first; num <= last; num++) {
        str = gettxt(num);

        while (*str != NL && cp < buf + MAXLINE - 1)
            *cp++ = *str++;

        if (cp == buf + MAXLINE - 1) {
            printf("line too long\n");
            return(ERR);
        }
    }

    *cp++ = NL;
    *cp = EOS;
    del(first, last);
    curln = first - 1;
    ins(buf);
    fchanged = TRUE;

    return 0;
}

/* vi: set ts=4 expandtab: */
