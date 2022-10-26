/*****************************************************************************

   fdopen.c                                         ux/64 standard library

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

FILE *fdopen(int fildes, const char *mode)
{
    int i;
    FILE *stream;
    int flags = 0;

    if (fildes < 0) return 0;

    for (i = 0; __iotab[i] != 0 ; i++)
        if (i >= FOPEN_MAX - 1)
            return 0;

    switch (*mode++)
    {
    case 'r':   flags |= _IOREAD | _IOREADING; break;
    case 'a':   flags |= _IOAPPEND; /* fallthru */
    case 'w':   flags |= _IOWRITE | _IOWRITING; break;
    default:    return 0;
    }

    while (*mode) {
        switch (*mode++)
        {
        case 'b':   continue;
        case '+':   flags |= _IOREAD | _IOWRITE; continue;
        default:    break; /* ignore any additional characters */
        }

        break;
    }

    if ((stream = malloc(sizeof(FILE))) == 0)
        return 0;

    if ((flags & _IOREAD) && (flags & _IOWRITE))
        flags &= ~(_IOREADING | _IOWRITING);

    stream->_count = 0;
    stream->_fd = fildes;
    stream->_flags = flags;
    stream->_buf = NULL;
    __iotab[i] = stream;

    return stream;
}

/* vi: set ts=4 expandtab: */
