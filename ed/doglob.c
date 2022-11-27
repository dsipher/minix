/*****************************************************************************

   doglob.c                                              minix line editor

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

int doglob(void)
{
    int lin, stat;
    char *cmd;
    LINE *ptr;

    cmd = inptr;

    while (1) {
	    ptr = getptr(1);

	    for (lin = 1; lin <= lastln; lin++) {
		    if (ptr->l_stat & LGLOB) break;
		    ptr = ptr->l_next;
	    }

	    if (lin > lastln) break;

	    ptr->l_stat &= ~LGLOB;
	    curln = lin;
	    inptr = cmd;
	    if ((stat = getlst()) < 0) return(stat);
	    if ((stat = docmd(1)) < 0) return (stat);
    }

    return(curln);
}

/* vi: set ts=4 expandtab: */
