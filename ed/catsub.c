/*****************************************************************************

   catsub.c                                              minix line editor

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

extern char *paropen[9], *parclose[9];

char *catsub(char *from, char *to, char *sub, char *new, char *newend)
{
    char *cp, *cp2;

    for (cp = new; *sub != EOS && cp < newend;) {
	    if (*sub == DITTO) for (cp2 = from; cp2 < to;) {
			*cp++ = *cp2++;
			if (cp >= newend) break;
		}
	    else if (*sub == ESCAPE) {
		    sub++;

		    if ('1' <= *sub && *sub <= '9') {
			    char *parcl = parclose[*sub - '1'];

			    for (cp2 = paropen[*sub - '1']; cp2 < parcl;) {
				    *cp++ = *cp2++;
				    if (cp >= newend) break;
			    }
		    } else
			    *cp++ = *sub;
	    } else
		    *cp++ = *sub;

	    sub++;
    }

    return (cp);
}

/* vi: set ts=4 expandtab: */
