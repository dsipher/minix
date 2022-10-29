/*****************************************************************************

   getpat.c                                              ux/64 line editor

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

/* translate arg into a TOKEN string */

TOKEN *getpat(char *arg)
{
    return(makepat(arg, '\000'));
}

/* vi: set ts=4 expandtab: */
