/*****************************************************************************

   freopen.c                                        ux/64 standard library

******************************************************************************

   derived from MINIX, Copyright (c) 1987, 1997 by Prentice Hall.

   Redistribution and use of the MINIX operating system in source and
   binary forms, with or without modification, are permitted provided
   that the following conditions are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above
     copyright notice, this list of conditions and the following
     disclaimer in the documentation and/or other materials provided
     with the distribution.

   * Neither the name of Prentice Hall nor the names of the software
     authors or contributors may be used to endorse or promote
     products derived from this software without specific prior
     written permission.

   THIS  SOFTWARE  IS  PROVIDED  BY  THE  COPYRIGHT HOLDERS,  AUTHORS, AND
   CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED  WARRANTIES, INCLUDING,
   BUT  NOT LIMITED TO,  THE IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND
   FITNESS FOR  A PARTICULAR  PURPOSE ARE  DISCLAIMED.  IN NO  EVENT SHALL
   PRENTICE HALL  OR ANY AUTHORS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
   INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY,  OR  CONSEQUENTIAL DAMAGES
   (INCLUDING,  BUT NOT  LIMITED TO,  PROCUREMENT  OF SUBSTITUTE  GOODS OR
   SERVICES;  LOSS OF USE,  DATA, OR  PROFITS; OR  BUSINESS  INTERRUPTION)
   HOWEVER  CAUSED AND  ON ANY THEORY OF  LIABILITY,  WHETHER IN CONTRACT,
   STRICT LIABILITY, OR TORT  (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING
   IN ANY WAY  OUT  OF THE  USE OF  THIS SOFTWARE,  EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.

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
   ux/64 does indeed support O_CREAT so we should use it - cey) */

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
