/*****************************************************************************

  fgets.c                                           tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>

char *fgets(char *s, int n, FILE *fp)
{
    int ch;
    char *ptr;

    ptr = s;

    while ((--n > 0) && ((ch = getc(fp)) != EOF)) {
        *ptr++ = ch;

        if (ch == '\n')
            break;
    }

    if (ch == EOF) {
        if (feof(fp)) {
            if (ptr == s)
                return 0;
        } else
            return 0;
    }

    *ptr = '\0';
    return s;
}

/* vi: set ts=4 expandtab: */
