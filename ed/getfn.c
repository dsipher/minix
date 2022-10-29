/*****************************************************************************

   getfn.c                                               ux/64 line editor

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

extern char fname[MAXFNAME];
int nofname;

char *getfn(void)
{
    static char file[256];
    char *cp;

    if (*inptr == NL) {
	    nofname = TRUE;
	    strcpy(file, fname);
    } else {
	    nofname = FALSE;

	    while (*inptr == SP || *inptr == HT)
            inptr++;

	    cp = file;

	    while (*inptr && *inptr != NL && *inptr != SP && *inptr != HT)
		    *cp++ = *inptr++;

	    *cp = '\0';

	    if (strlen(file) == 0) {
		    printf("bad file name\n");
		    return(NULL);
	    }
    }

    if (strlen(file) == 0) {
	    printf("no file name\n");
	    return(NULL);
    }

    return(file);
}

/* vi: set ts=4 expandtab: */
