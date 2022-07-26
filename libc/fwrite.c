/*****************************************************************************

  fwrite.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>

size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *fp)
{
    const unsigned char *cp = ptr;
    size_t s;
    size_t ndone = 0;

    if (size)
        while (ndone < nmemb) {
            s = size;

            do {
                if (putc(*cp, fp) == EOF)
                    return ndone;

                cp++;
            } while (--s);

            ndone++;
        }

    return ndone;
}

/* vi: set ts=4 expandtab: */
