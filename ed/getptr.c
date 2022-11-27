/*****************************************************************************

   getptr.c                                              minix line editor

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

LINE *getptr(int num)
{
    LINE *ptr;
    int j;

    if (2 * num > lastln && num <= lastln) {
        /* high line numbers */

        ptr = line0.l_prev;

        for (j = lastln; j > num; j--)
            ptr = ptr->l_prev;
    } else {
        /* low line numbers */

        ptr = &line0;

        for (j = 0; j < num; j++)
            ptr = ptr->l_next;
    }

    return (ptr);
}

/* vi: set ts=4 expandtab: */
