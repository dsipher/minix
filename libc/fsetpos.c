/*****************************************************************************

  fsetpos.c                                         tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>

int fsetpos(FILE *fp, fpos_t *pos)
{
    return fseek(fp, *pos, SEEK_SET);
}

/* vi: set ts=4 expandtab: */
