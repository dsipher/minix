/*****************************************************************************

   dirent.h                                      jewel/os standard library

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

#ifndef _DIRENT_H
#define _DIRENT_H

#include <sys/jewel.h>

#ifndef __INO_T
#define __INO_T
typedef __ino_t ino_t;
#endif /* __INO_T */

/* description of a directory entry */

struct dirent
{
    ino_t           d_ino;          /* inode associated with entry */
    int             __pad0;         /* (high bits of ino_t, n/a in jewel) */
    long            __pad1;         /* (linux calls this d_off) */
    unsigned short  d_reclen;       /* length of this dirent struct */
    char            d_name[];       /* NUL-terminated name of entry */
};

/* read a set of variable-length directory entries. this is the
   system call behind readdir(). (unlike glibc, we expose it.) */

extern int getdents(int fildes, struct dirent *dirp, int count);

#endif /* _DIRENT_H */

/* vi: set ts=4 expandtab: */
