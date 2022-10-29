/*****************************************************************************

   getone.c                                              ux/64 line editor

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

#define FIRST       1
#define NOTFIRST    0

int getone(void)
{
    int c, i, num;

    if ((num = getnum(FIRST)) >= 0) {
	    while (1) {
		    while (*inptr == SP || *inptr == HT) inptr++;

		    if (*inptr != '+' && *inptr != '-') break;
		    c = *inptr++;

		    if ((i = getnum(NOTFIRST)) < 0) return(i);

		    if (c == '+')
			    num += i;
		    else
			    num -= i;
	    }
    }

    return(num > lastln ? ERR : num);
}

/* vi: set ts=4 expandtab: */
