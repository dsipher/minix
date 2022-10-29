/*****************************************************************************

   append.c                                              ux/64 line editor

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

int append(int line, int glob)
{
    int stat;
    char lin[MAXLINE];

    if (glob) return(ERR);
    curln = line;

    while (1) {
	    if (nflg) printf("%6d. ", curln + 1);
	    if (fgets(lin, MAXLINE, stdin) == NULL) return(EOF);
	    if (lin[0] == '.' && lin[1] == '\n') return (0);
	    stat = ins(lin);
	    if (stat < 0) return(ERR);
  }
}

/* vi: set ts=4 expandtab: */
