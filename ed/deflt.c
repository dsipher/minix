/*****************************************************************************

   deflt.c                                               minix line editor

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

int deflt(int def1, int def2)
{
    if (nlines == 0) {
	    line1 = def1;
	    line2 = def2;
    }

    if (line1 > line2 || line1 <= 0) return(ERR);
    return(0);
}

/* vi: set ts=4 expandtab: */
