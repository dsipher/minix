/*****************************************************************************

   ins.c                                                 ux/64 line editor

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
#include <string.h>
#include "tools.h"
#include "ed.h"

int ins(char *str)
{
    char buf[MAXLINE], *cp;
    LINE *new, *cur, *nxt;

    cp = buf;

    while (1) {
        if ((*cp = *str++) == NL) *cp = EOS;

        if (*cp) {
            cp++;
            continue;
        }

        if ((new = malloc(sizeof(LINE) + strlen(buf))) == NULL)
            return (ERR);   /* no memory */

        new->l_stat = 0;
        strcpy(new->l_buff, buf);       /* build new line */
        cur = getptr(curln);            /* get current line */
        nxt = cur->l_next;              /* get next line */
        relink(cur, new, new, nxt);     /* add to linked list */
        relink(new, nxt, cur, new);
        lastln++;
        curln++;

        if (*str == EOS)    /* end of line ? */
            return(1);

        cp = buf;
    }
}

/* vi: set ts=4 expandtab: */
