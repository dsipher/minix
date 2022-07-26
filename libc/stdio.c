/*****************************************************************************

  stdio.c                                           tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>

struct __iobuf __stdin      = { 0, 0, _IOREAD, 0, 0, 0 };
struct __iobuf __stdout     = { 0, 1, _IOWRITE, 0, 0, 0 };
struct __iobuf __stderr     = { 0, 2, _IOWRITE | _IOLBF, 0, 0, 0 };
FILE *__iotab[FOPEN_MAX]    = { &__stdin, &__stdout, &__stderr };

/* vi: set ts=4 expandtab: */
