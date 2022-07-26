/*****************************************************************************

  strrchr.c                                         tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <string.h>

char *strrchr(const char *s, int c)
{
    const char *result = 0;

    c = (char) c;

    do {
        if (c == *s)
            result = s;
    } while (*s++ != '\0');

    return (char *) result;
}

/* vi: set ts=4 expandtab: */
