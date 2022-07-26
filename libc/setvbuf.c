/*****************************************************************************

  setvbuf.c                                         tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>

int setvbuf(FILE *fp, char *buf, int mode, size_t size)
{
    int retval = 0;

    __exit_cleanup = __stdio_cleanup;

    if (mode != _IOFBF && mode != _IOLBF && mode != _IONBF)
        return EOF;

    if (fp->_buf && (fp->_flags & _IOMYBUF))
        free(fp->_buf);

    fp->_flags &= ~(_IOMYBUF | _IONBF | _IOLBF);

    if (buf && size == 0)
        retval = EOF;

    if (!buf && (mode != _IONBF)) {
        if (size == 0 || (buf = malloc(size)) == 0)
            retval = EOF;
        else
            fp->_flags |= _IOMYBUF;
    }

    fp->_buf = (unsigned char *) buf;
    fp->_count = 0;
    fp->_flags |= mode;
    fp->_ptr = fp->_buf;

    if (!buf) {
        fp->_bufsiz = 1;
    } else {
        fp->_bufsiz = size;
    }

    return retval;
}

/* vi: set ts=4 expandtab: */
