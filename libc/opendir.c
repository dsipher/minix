/*****************************************************************************

   opendir.c                                     jewel/os standard library

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
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

#include <dirent.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/stat.h>

DIR *opendir(const char *dirname)
{
    DIR *dirp;
    struct stat st;
    int d, f;

    /* only read directories. (not sure of the logic
       in checking here and then again after opening,
       but for the moment i'll leave unchanged -cey) */

    if (stat(dirname, &st) < 0) return 0;
    if (!S_ISDIR(st.st_mode)) { errno = ENOTDIR; return 0; }

    if ((d = open(dirname, O_RDONLY | O_NONBLOCK)) < 0)
        return 0;

    /* recheck the type [in case of a race between the first
       stat() and open()], mark the descriptor close-on-exec,
       and allocate the DIR structure. */

    if (   fstat(d, &st) < 0
        || (errno = ENOTDIR, !S_ISDIR(st.st_mode))
        || (f = fcntl(d, F_GETFD)) < 0
        || fcntl(d, F_SETFD, f | FD_CLOEXEC) < 0
        || (dirp = malloc(sizeof(DIR))) == 0 )
    {
        int err = errno;
        close(d);
        errno = err;
        return 0;
    }

    dirp->fildes = d;
    dirp->pos = 0;
    dirp->count = 0;

    return dirp;
}

/* vi: set ts=4 expandtab: */
