/*****************************************************************************

   ckglob.c                                              ux/64 line editor

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

int ckglob(void)
{
    TOKEN *glbpat;
    char c, delim;
    char lin[MAXLINE];
    int num;
    LINE *ptr;

    c = *inptr;

    if (c != 'g' && c != 'v') return(0);
    if (deflt(1, lastln) < 0) return(ERR);

    delim = *++inptr;
    if (delim <= ' ') return(ERR);

    glbpat = optpat();
    if (*inptr == delim) inptr++;
    ptr = getptr(1);

    for (num = 1; num <= lastln; num++) {
	    ptr->l_stat &= ~LGLOB;

	    if (line1 <= num && num <= line2) {
		    strcpy(lin, ptr->l_buff);
		    strcat(lin, "\n");

		    if (matchs(lin, glbpat, 0)) {
			    if (c == 'g') ptr->l_stat |= LGLOB;
		    } else {
			    if (c == 'v') ptr->l_stat |= LGLOB;
		    }
	    }

	    ptr = ptr->l_next;
    }

    return 1;
}

/* vi: set ts=4 expandtab: */
