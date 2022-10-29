/*****************************************************************************

   dowrite.c                                             ux/64 line editor

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

int dowrite(int from, int to, char *fname, int apflg)
{
    FILE *fp;
    int lin, err;
    int lines;
    long bytes;
    char *str;
    LINE *lptr;

    err = 0;

    lines = bytes = 0;
    if (diag) printf("\"%s\" ", fname);

    if ((fp = fopen(fname, (apflg ? "a" : "w"))) == NULL) {
	    printf("file open error\n");
	    return(ERR);
    }

    lptr = getptr(from);

    for (lin = from; lin <= to; lin++) {
	    str = lptr->l_buff;
	    lines++;
	    bytes += strlen(str) + 1;

	    if (fputs(str, fp) == EOF) {
		    printf("file write error\n");
		    err++;
		    break;
	    }

	    fputc('\n', fp);
	    lptr = lptr->l_next;
    }

    if (diag) printf("%d lines %ld bytes\n", lines, bytes);
    fclose(fp);

    return(err);
}

/* vi: set ts=4 expandtab: */
