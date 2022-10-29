/*****************************************************************************

   unmkpat.c                                             ux/64 line editor

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
#include <stdlib.h>
#include "tools.h"

/* free up the memory usde for token string */

void unmakepat(TOKEN *head)
{
    TOKEN *old_head;

    while (head) {
	    switch (head->tok) {
	    case CCL:
	    case NCCL:  free(head->bitmap);
		            /* FALLTHRU */

	    default:    old_head = head;
		            head = head->next;
		            free(old_head);
	    }
    }
}

/* vi: set ts=4 expandtab: */
