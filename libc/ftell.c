/*****************************************************************************

  ftell.c                                           tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <unistd.h>

long ftell(FILE *fp)
{
    long result;
    int adjust;

    if (fp->_flags & _IOREADING)
        adjust = -fp->_count;
    else if ((fp->_flags & _IOWRITING) && fp->_buf && !(fp->_flags & _IONBF))
        adjust = fp->_ptr - fp->_buf;
    else adjust = 0;

    result = lseek(fileno(fp), 0, SEEK_CUR);

    if (result == -1)
        return result;

    result += adjust;
    return result;
}

/* vi: set ts=4 expandtab: */
