/*****************************************************************************

  __flushbuf.c                                      tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/* we must loop doing writes, because posix
   permits partial writes to return. */

static int do_write(int fd, unsigned char *buf, int nbytes)
{
    int c;

    while (((c = write(fd, buf, nbytes)) > 0) && (c < nbytes)) {
        nbytes -= c;
        buf += c;
    }

    return (c > 0);
}

int __flushbuf(int c, FILE *fp)
{
    __exit_cleanup = __stdio_cleanup;

    if (fp->_fd < 0)
        return (unsigned char) c;

    if (!(fp->_flags & _IOWRITE))
        return EOF;

    if ((fp->_flags & _IOREADING) && !feof(fp))
        return EOF;

    fp->_flags &= ~_IOREADING;
    fp->_flags |= _IOWRITING;

    if (!(fp->_flags & _IONBF)) {
        if (!fp->_buf) {
            if ((fp == stdout) && isatty(stdout->_fd)) {
                if (!(fp->_buf = malloc(BUFSIZ)))
                    fp->_flags |= _IONBF;
                else {
                    fp->_flags |= _IOLBF | _IOMYBUF;
                    fp->_bufsiz = BUFSIZ;
                    fp->_count = -1;
                }
            } else {
                if (!(fp->_buf = malloc(BUFSIZ)))
                    fp->_flags |= _IONBF;
                else {
                    fp->_flags |= _IOMYBUF;
                    fp->_bufsiz = BUFSIZ;

                    if (!(fp->_flags & _IOLBF))
                        fp->_count = BUFSIZ - 1;
                    else
                        fp->_count = -1;
                }
            }

            fp->_ptr = fp->_buf;
        }
    }

    if (fp->_flags & _IONBF) {
        char c1 = c;

        fp->_count = 0;

        if (fp->_flags & _IOAPPEND) {
            if (lseek(fp->_fd, 0L, SEEK_END) == -1) {
                fp->_flags |= _IOERR;
                return EOF;
            }
        }

        if (write(fp->_fd, &c1, 1) != 1) {
            fp->_flags |= _IOERR;
            return EOF;
        }

        return (unsigned char) c;
    } else if (fp->_flags & _IOLBF) {
        /* fp->_count has been updated in putc macro */
        *fp->_ptr++ = c;

        if (c == '\n' || fp->_count == -fp->_bufsiz) {
            int count = -fp->_count;

            fp->_ptr = fp->_buf;
            fp->_count = 0;

            if (fp->_flags & _IOAPPEND) {
                if (lseek(fp->_fd, 0L, SEEK_END) == -1) {
                    fp->_flags |= _IOERR;
                    return EOF;
                }
            }

            if (!do_write(fp->_fd, fp->_buf, count)) {
                fp->_flags |= _IOERR;
                return EOF;
            }
        }
    } else {
        int count = fp->_ptr - fp->_buf;

        fp->_count = fp->_bufsiz - 1;
        fp->_ptr = fp->_buf + 1;

        if (count > 0) {
            if (fp->_flags & _IOAPPEND) {
                if (lseek(fp->_fd, 0L, SEEK_END) == -1) {
                    fp->_flags |= _IOERR;
                    return EOF;
                }
            }

            if (!do_write(fp->_fd, fp->_buf, count)) {
                *(fp->_buf) = c;
                fp->_flags |= _IOERR;
                return EOF;
            }
        }

        *(fp->_buf) = c;
    }

    return (unsigned char) c;
}

/* vi: set ts=4 expandtab: */
