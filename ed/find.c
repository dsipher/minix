/*****************************************************************************

   find.c                                                minix line editor

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
#include <string.h>
#include "tools.h"
#include "ed.h"

int find(TOKEN *pat, int dir)
{
    int i, num;
    char lin[MAXLINE];
    LINE *ptr;

    num = curln;
    ptr = getptr(curln);
    num = (dir ? nextln(num) : prevln(num));
    ptr = (dir ? ptr->l_next : ptr->l_prev);

    for (i = 0; i < lastln; i++) {
	    if (num == 0) {
		    num = (dir ? nextln(num) : prevln(num));
		    ptr = (dir ? ptr->l_next : ptr->l_prev);
	    }

	    strcpy(lin, ptr->l_buff);
	    strcat(lin, "\n");

	    if (matchs(lin, pat, 0))
		    return(num);

	    num = (dir ? nextln(num) : prevln(num));
	    ptr = (dir ? ptr->l_next : ptr->l_prev);
    }

    return(ERR);
}

/* vi: set ts=4 expandtab: */
