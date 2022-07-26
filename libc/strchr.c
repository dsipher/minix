/*****************************************************************************

  strchr.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <string.h>

char *strchr(const char *s, int c)
{
    c = (char) c;

    while (c != *s)
        if (*s++ == '\0')
            return 0;

    return (char *) s;
}

/* vi: set ts=4 expandtab: */
