/*****************************************************************************

  fclose.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int fclose(FILE *fp)
{
    int i;
    int retval = 0;

    for (i = 0; i < FOPEN_MAX; ++i)
        if (fp == __iotab[i]) {
            __iotab[i] = 0;
            break;
        }

    if (i >= FOPEN_MAX)
        return EOF;

    if (fflush(fp))
        retval = EOF;

    if (close(fp->_fd))
        retval = EOF;

    if ((fp->_flags & _IOMYBUF) && (fp->_buf))
        free(fp->_buf);

    if ((fp != stdin) && (fp != stdout) && (fp != stderr))
        free(fp);

    return retval;
}

/* vi: set ts=4 expandtab: */
