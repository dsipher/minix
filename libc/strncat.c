/*****************************************************************************

  strncat.c                                         tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <string.h>

char *strncat(char *ret, const char *s2, size_t n)
{
    char *s1 = ret;

    if (n > 0) {
        while (*s1++)
            /* EMPTY */ ;

        s1--;

        while (*s1++ = *s2++)  {
            if (--n > 0)
                continue;

            *s1 = '\0';
            break;
        }

        return ret;
    } else
        return s1;
}

/* vi: set ts=4 expandtab: */
