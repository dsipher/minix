/*****************************************************************************

  getenv.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>

char *getenv(const char *name)
{
    extern char **environ;
    char **v = environ;
    const char *p, *q;

    if (v == 0 || name == 0)
        return 0;

    while ((p = *v++) != 0) {
        q = name;

        while (*q && (*q == *p++))
            q++;

        if (*q || (*p != '='))
            continue;

        return (char *) p + 1;
    }

    return 0;
}

/* vi: set ts=4 expandtab: */
