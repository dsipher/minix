/*****************************************************************************

   getnum.c                                              ux/64 line editor

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

int mark['z' - 'a' + 1];

int getnum(int first)
{
    TOKEN *srchpat;
    int num;
    char c;

    while (*inptr == SP || *inptr == HT) inptr++;

    if (*inptr >= '0' && *inptr <= '9') {	/* line number */
	    for (num = 0; *inptr >= '0' && *inptr <= '9';) {
		    num = (num * 10) + *inptr - '0';
		    inptr++;
	    }

	    return num;
    }

    switch (c = *inptr) {
    case '.':
	    inptr++;
	    return(curln);

    case '$':
	    inptr++;
	    return(lastln);

    case '/':
    case '?':
	    srchpat = optpat();
	    if (*inptr == c) inptr++;
	    return(find(srchpat, c == '/' ? 1 : 0));

    case '-':
    case '+':
	    return(first ? curln : 1);

    case '\'':
	    inptr++;
	    if (*inptr < 'a' || *inptr > 'z') return(EOF);
	    return mark[*inptr++ - 'a'];

    default:
	    return(first ? EOF : 1); /* unknown address */
    }
}

/* vi: set ts=4 expandtab: */
