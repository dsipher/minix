/*****************************************************************************

  fgetpos.c                                         tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>

int fgetpos(FILE *fp, fpos_t *pos)
{
    *pos = ftell(fp);

    if (*pos == -1)
        return -1;
    else
        return 0;
}

/* vi: set ts=4 expandtab: */
