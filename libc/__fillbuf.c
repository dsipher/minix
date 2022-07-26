/*****************************************************************************

  __fillbuf.c                                       tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int __fillbuf(FILE *fp)
{
    static unsigned char ch[FOPEN_MAX];   /* "buffers" for the unbuffered */
    int i;

    fp->_count = 0;

    if (fp->_fd < 0)
        return EOF;

    if (fp->_flags & (_IOEOF | _IOERR))
        return EOF;

    if (!(fp->_flags & _IOREAD)) {
        fp->_flags |= _IOERR;
        return EOF;
    }

    if (fp->_flags & _IOWRITING) {
        fp->_flags |= _IOERR;
        return EOF;
    }

    if (!(fp->_flags & _IOREADING))
        fp->_flags |= _IOREADING;

    if (!(fp->_flags & _IONBF) && !fp->_buf) {
        fp->_buf = malloc(BUFSIZ);

        if (!fp->_buf)
            fp->_flags |= _IONBF;
        else {
            fp->_flags |= _IOMYBUF;
            fp->_bufsiz = BUFSIZ;
        }
    }

    /* flush line-buffered output when filling an input buffer */

    for (i = 0; i < FOPEN_MAX; i++) {
        if (__iotab[i] && (__iotab[i]->_flags & _IOLBF))
            if (__iotab[i]->_flags & _IOWRITING)
                fflush(__iotab[i]);
    }

    if (!fp->_buf) {
        fp->_buf = &ch[fp->_fd];
        fp->_bufsiz = 1;
    }

    fp->_ptr = fp->_buf;
    fp->_count = read(fp->_fd, fp->_buf, fp->_bufsiz);

    if (fp->_count <= 0) {
        if (fp->_count == 0)
            fp->_flags |= _IOEOF;
        else
            fp->_flags |= _IOERR;

        return EOF;
    }

    fp->_count--;

    return *fp->_ptr++;
}

/* vi: set ts=4 expandtab: */
