/*****************************************************************************

   readdir.c                                     jewel/os standard library

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

#include <dirent.h>
#include <errno.h>

struct dirent *readdir(DIR *dirp)
{
    struct dirent *dp;

    if (dirp == 0) {
        errno = EBADF;
        return 0;
    }

    /* if we've reached the end of the
       buffer, refill it with getdents().

       dirp->count may be negative if a
       previous call to getdents() failed
       with an error, so use >= not == */

    if (dirp->pos >= dirp->count) {
        dirp->pos = 0;
        dirp->count = getdents(dirp->fildes,
                               (struct dirent *) dirp->buf,
                               sizeof(dirp->buf));

        if (dirp->count <= 0)       /* either EOF */
            return 0;               /* or an error */
    }

    dp = (struct dirent *) (dirp->buf + dirp->pos);
    dirp->pos += dp->d_reclen;

    return dp;
}

/* vi: set ts=4 expandtab: */
