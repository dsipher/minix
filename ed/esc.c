/*****************************************************************************

   esc.c                                                 ux/64 line editor

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

/* map escape sequences into their equivalent symbols. returns the
   correct ASCII character. if no escape prefix is present then s
   is untouched and *s is returned, otherwise **s is advanced to point
   at the escaped character and the translated character is returned. */

int esc(char **s)
{
    int rval;

    if (**s != ESCAPE)
	    rval = **s;
    else {
	    (*s)++;

	    switch (toupper(**s)) {
	    case '\000':	rval = ESCAPE;	break;
	    case 'S':	    rval = ' ';	    break;
	    case 'N':	    rval = '\n';	break;
	    case 'T':	    rval = '\t';	break;
	    case 'B':	    rval = '\b';	break;
	    case 'R':	    rval = '\r';	break;
	    default:	    rval = **s;	    break;
	    }
    }

    return (rval);
}

/* vi: set ts=4 expandtab: */
