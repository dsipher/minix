/*****************************************************************************

   gettxt.c                                              minix line editor

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
#include <string.h>
#include "tools.h"
#include "ed.h"

char *gettxt(int num)
{
    LINE *lin;
    static char txtbuf[MAXLINE];

    lin = getptr(num);
    strcpy(txtbuf, lin->l_buff);
    strcat(txtbuf, "\n");
    return(txtbuf);
}

/* vi: set ts=4 expandtab: */
