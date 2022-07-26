/*****************************************************************************

  strcmp.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <string.h>

int strcmp(const char *s1, const char *s2)
{
    while (*s1 == *s2++)
        if (*s1++ == '\0')
            return 0;

    if (*s1 == '\0')
        return -1;

    if (*--s2 == '\0')
        return 1;

    return (unsigned char) *s1 - (unsigned char) *s2;
}

/* vi: set ts=4 expandtab: */
