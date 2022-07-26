/*****************************************************************************

  fread.c                                           tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>

size_t fread(void *ptr, size_t size, size_t nmemb, FILE *fp)
{
    char *cp = ptr;
    int c;
    size_t ndone = 0;
    size_t s;

    if (size)
        while (ndone < nmemb) {
            s = size;

            do {
                if ((c = getc(fp)) != EOF)
                    *cp++ = c;
                else
                    return ndone;
            } while (--s);

            ndone++;
        }

    return ndone;
}

/* vi: set ts=4 expandtab: */
