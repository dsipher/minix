/*****************************************************************************

  memcmp.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <string.h>

int memcmp(const void *s1, const void *s2, size_t n)
{
    const unsigned char *p1 = s1;
    const unsigned char *p2 = s2;

    if (n) {
        n++;

        while (--n > 0) {
            if (*p1++ == *p2++)
                continue;

            return *--p1 - *--p2;
        }
    }

    return 0;
}

/* vi: set ts=4 expandtab: */
