/*****************************************************************************

   del.c                                                 ux/64 line editor

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
#include <stdlib.h>
#include "tools.h"
#include "ed.h"

int del(int from, int to)
{
    LINE *first, *last, *next, *tmp;

    if (from < 1) from = 1;
    first = getptr(prevln(from));
    last = getptr(nextln(to));
    next = first->l_next;

    while (next != last && next != &line0) {
	    tmp = next->l_next;
	    free(next);
	    next = tmp;
    }

    relink(first, last, first, last);
    lastln -= (to - from) + 1;
    curln = prevln(from);

    return(0);
}

/* vi: set ts=4 expandtab: */
