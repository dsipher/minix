/*****************************************************************************

  sscanf.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <stdarg.h>
#include <string.h>

int sscanf(const char *s, const char *format, ...)
{
    va_list ap;
    int retval;
    FILE tmp_stream;

    va_start(ap, format);

    tmp_stream._fd     = -1;
    tmp_stream._flags  = _IOREAD + _IONBF + _IOREADING;
    tmp_stream._buf    = (unsigned char *) s;
    tmp_stream._ptr    = (unsigned char *) s;
    tmp_stream._count  = strlen(s);

    retval = vfscanf(&tmp_stream, format, ap);

    va_end(ap);

    return retval;
}

/* vi: set ts=4 expandtab: */
