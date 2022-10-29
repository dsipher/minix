/*****************************************************************************

   egets.c                                               ux/64 line editor

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

int     eightbit = 1;		/* save eighth bit */
int     nonascii, nullchar, truncated;

int egets(char *str, int size, FILE *stream)
{
    int c, count;
    char *cp;

    for (count = 0, cp = str; size > count;) {
	    c = getc(stream);

	    if (c == EOF) {
		    *cp++ = '\n';
		    *cp = EOS;

		    if (count) printf("[Incomplete last line]\n");
		    return(count);
	    }

	    if (c == NL) {
		    *cp++ = c;
		    *cp = EOS;
		    return(++count);
	    }

	    if (c > 127) {
		    if (!eightbit)	    /* if not saving eighth bit */
			    c = c & 127;	/* strip eighth bit */
		        nonascii++;	    /* count it */
	    }

	    if (c) {
		    *cp++ = c;	        /* not null, keep it */
		    count++;
	    } else
		    nullchar++;	        /* count nulls */
    }

    str[count - 1] = EOS;

    if (c != NL) {
	    printf("truncating line\n");
	    truncated++;

	    while ((c = getc(stream)) != EOF)
		    if (c == NL)
                break;
    }

    return(count);
}

/* vi: set ts=4 expandtab: */
