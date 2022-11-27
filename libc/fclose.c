/*****************************************************************************

   fclose.c                                         minix standard library

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from MINIX 2, Copyright (c) 1987, 1997 by Prentice Hall.

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
#include <unistd.h>

int fclose(FILE *fp)
{
    int i;
    int retval = 0;

    for (i = 0; i < FOPEN_MAX; ++i)
        if (fp == __iotab[i]) {
            __iotab[i] = 0;
            break;
        }

    if (i >= FOPEN_MAX)
        return EOF;

    /* only fflush() if we're _IOWRITING: it's a waste of
       time if we're not. even worse, fflush() reports an
       error if the stream is _IOREADING and non-seekable. */

    if ((fp->_flags & _IOWRITING) && fflush(fp))
        retval = EOF;

    if (close(fp->_fd))
        retval = EOF;

    if ((fp->_flags & _IOMYBUF) && (fp->_buf))
        free(fp->_buf);

    if ((fp != stdin) && (fp != stdout) && (fp != stderr))
        free(fp);

    return retval;
}

/* vi: set ts=4 expandtab: */
