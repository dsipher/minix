/*****************************************************************************

   doprnt.c                                              ux/64 line editor

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

int doprnt(int from, int to)
{
    int i;
    LINE *lptr;

    from = from < 1 ? 1 : from;
    to = to > lastln ? lastln : to;

    if (to != 0) {
	    lptr = getptr(from);

	    for (i = from; i <= to; i++) {
		    prntln(lptr->l_buff, lflg, (nflg ? i : 0));
		    lptr = lptr->l_next;
	    }

	    curln = to;
    }

    return(0);
}

void prntln(char *str, int vflg, int lin)
{
    if (lin) printf("%7d ", lin);

    while (*str && *str != NL) {
	    if (*str < ' ' || *str >= 0x7f) {
		    switch (*str) {
		    case '\t':
			    if (vflg)
				    putcntl(*str, stdout);
			    else
				    putc(*str, stdout);
			    break;

		    case DEL:
			    putc('^', stdout);
			    putc('?', stdout);
			    break;

		    default:
			    putcntl(*str, stdout);
			    break;
		    }
	    } else
		    putc(*str, stdout);

	    str++;
    }

    if (vflg) putc('$', stdout);
    putc('\n', stdout);
}

void putcntl(int c, FILE *stream)
{
    putc('^', stream);
    putc((c & 31) | '@', stream);
}

/* vi: set ts=4 expandtab: */
