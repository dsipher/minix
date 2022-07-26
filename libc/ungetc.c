/*****************************************************************************

  ungetc.c                                          tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>

int ungetc(int ch, FILE *fp)
{
    if (ch == EOF  || !(fp->_flags & _IOREADING))
        return EOF;

    if (fp->_ptr == fp->_buf) {
        if (fp->_count != 0) return EOF;
        fp->_ptr++;
    }

    fp->_count++;
    *(--(fp->_ptr)) = ch;

    return ch;
}

/* vi: set ts=4 expandtab: */
