/*****************************************************************************

  setbuf.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>

void setbuf(FILE *stream, char *buf)
{
    setvbuf(stream, buf, (buf ? _IOFBF : _IONBF), (size_t) BUFSIZ);
}

/* vi: set ts=4 expandtab: */
