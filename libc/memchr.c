/*****************************************************************************

  memchr.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <string.h>

void *memchr(const void *s, int c, size_t n)
{
    const unsigned char *s1 = s;

    c = (unsigned char) c;

    if (n) {
        n++;

        while (--n > 0) {
            if (*s1++ != c)
                continue;

            return (void *) --s1;
        }
    }

    return 0;
}

/* vi: set ts=4 expandtab: */
