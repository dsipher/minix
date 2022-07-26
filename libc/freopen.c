/*****************************************************************************

  freopen.c                                         tahoe/64 standard library

                  derived from MINIX, Copyright (c) 1987, 1997 Prentice Hall.
     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>

#define PMODE 0666      /* default mode for file creation */

/* Do not "optimize" this file to use the open with O_CREAT if
   the file does not exist. The reason is given in fopen.c.

   (n.b. this comment, like that in fopen.c, is not applicable.
   tahoe does indeed support O_CREAT so we should use it - cey) */

FILE *freopen(const char *name, const char *mode, FILE *stream)
{
    int i;
    int rwmode = 0, rwflags = 0;
    int fd, flags = stream->_flags & (_IONBF | _IOFBF | _IOLBF | _IOMYBUF);

    fflush(stream);             /* ignore errors */
    close(fileno(stream));

    switch(*mode++) {
    case 'r':
        flags |= _IOREAD;
        rwmode = O_RDONLY;
        break;
    case 'w':
        flags |= _IOWRITE;
        rwmode = O_WRONLY;
        rwflags = O_CREAT | O_TRUNC;
        break;
    case 'a':
        flags |= _IOWRITE | _IOAPPEND;
        rwmode = O_WRONLY;
        rwflags |= O_APPEND | O_CREAT;
        break;
    default:
        return (FILE *)NULL;
    }

    while (*mode) {
        switch(*mode++) {
        case 'b':
            continue;
        case '+':
            rwmode = O_RDWR;
            flags |= _IOREAD | _IOWRITE;
            continue;
        /* The sequence may be followed by aditional characters */
        default:
            break;
        }
        break;
    }

    if ((rwflags & O_TRUNC)
        || (((fd = open(name, rwmode)) < 0)
            && (rwflags & O_CREAT))) {
        if (((fd = creat(name, PMODE)) < 0) && flags | _IOREAD) {
            close(fd);
            fd = open(name, rwmode);
        }
    }

    if (fd < 0) {
        for(i = 0; i < FOPEN_MAX; i++) {
            if (stream == __iotab[i]) {
                __iotab[i] = 0;
                break;
            }
        }

        if (stream != stdin && stream != stdout && stream != stderr)
            free(stream);

        return NULL;
    }

    stream->_count = 0;
    stream->_fd = fd;
    stream->_flags = flags;
    return stream;
}

/* vi: set ts=4 expandtab: */
