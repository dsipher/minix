/*****************************************************************************

  fflush.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <unistd.h>

int fflush(FILE *fp)
{
    int count;
    int c1;
    int i;
    int retval = 0;

    if (fp == 0) {
        for (i = 0; i < FOPEN_MAX; i++)
            if (__iotab[i] && fflush(__iotab[i]))
                retval = EOF;

        return retval;
    }

    if (!fp->_buf ||
      (!(fp->_flags & _IOREADING)
      && !(fp->_flags & _IOWRITING)))
        return 0;

    if (fp->_flags & _IOREADING) {
        /* (void) fseek(fp, 0L, SEEK_CUR); */
        int adjust = 0;

        if (fp->_buf && !(fp->_flags & _IONBF))
            adjust = -fp->_count;

        fp->_count = 0;

        if (lseek(fp->_fd, adjust, SEEK_CUR) == -1) {
            fp->_flags |= _IOERR;
            return EOF;
        }

        if (fp->_flags & _IOWRITE)
            fp->_flags &= ~(_IOREADING | _IOWRITING);

        fp->_ptr = fp->_buf;
        return 0;
    } else if (fp->_flags & _IONBF)
        return 0;

    if (fp->_flags & _IOREAD)           /* "a" or "+" mode */
        fp->_flags &= ~_IOWRITING;

    count = fp->_ptr - fp->_buf;
    fp->_ptr = fp->_buf;

    if (count <= 0)
        return 0;

    if (fp->_flags & _IOAPPEND) {
        if (lseek(fp->_fd, 0L, SEEK_END) == -1) {
            fp->_flags |= _IOERR;
            return EOF;
        }
    }

    c1 = write(fp->_fd, fp->_buf, count);
    fp->_count = 0;

    if (count == c1)
        return 0;

    fp->_flags |= _IOERR;
    return EOF;
}

void __stdio_cleanup(void)
{
    int i;

    for (i = 0; i < FOPEN_MAX; i++)
        if (__iotab[i] && (__iotab[i]->_flags & _IOWRITING))
            fflush(__iotab[i]);
}

/* vi: set ts=4 expandtab: */
