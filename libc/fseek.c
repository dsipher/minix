/*****************************************************************************

  fseek.c                                           tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <unistd.h>

int fseek(FILE *fp, long offset, int whence)
{
    int adjust = 0;
    long pos;

    fp->_flags &= ~(_IOEOF | _IOERR);

    if (fp->_flags & _IOREADING) {
        if (whence == SEEK_CUR && fp->_buf && !(fp->_flags & _IONBF))
            adjust = fp->_count;

        fp->_count = 0;
    } else if (fp->_flags & _IOWRITING) {
        fflush(fp);
    } else /* neither reading nor writing. The buffer must be empty */
        /* EMPTY */ ;

    pos = lseek(fileno(fp), offset - adjust, whence);

    if ((fp->_flags & _IOREAD) && (fp->_flags &  _IOWRITE))
        fp->_flags &= ~(_IOREADING | _IOWRITING);

    fp->_ptr = fp->_buf;

    return ((pos == -1) ? -1 : 0);
}

/* vi: set ts=4 expandtab: */
