/*****************************************************************************

  strncpy.c                                         tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <string.h>

char *strncpy(char *ret, const char *s2, size_t n)
{
    char *s1 = ret;

    if (n > 0) {
        while((*s1++ = *s2++) && --n > 0)
            /* EMPTY */ ;

        if ((*--s2 == '\0') && --n > 0) {
            do {
                *s1++ = '\0';
            } while(--n > 0);
        }
    }

    return ret;
}

/* vi: set ts=4 expandtab: */
