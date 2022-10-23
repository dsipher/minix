/*****************************************************************************

   dirent.h                                            ux/64 system header

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

#include <sys/defs.h>

#ifndef __INO_T
#define __INO_T
typedef __ino_t ino_t;
#endif /* __INO_T */

/* description of a directory entry */

struct dirent
{
    ino_t           d_ino;          /* inode associated with entry */
    int             __pad0;         /* (high bits of ino_t, n/a in ux/64) */
    long            __pad1;         /* (linux calls this d_off) */
    unsigned short  d_reclen;       /* length of this dirent struct */
    char            d_name[];       /* NUL-terminated name of entry */
};

/* read a set of variable-length directory entries. this is the
   system call behind readdir(). (unlike glibc, we expose it.) */

extern int getdents(int fildes, struct dirent *dirp, int count);

/* a directory stream for opendir(), readdir(), et al.
   the contents of DIR are opaque to the user. */

typedef struct __DIR DIR;

struct __DIR
{
    int     fildes;                 /* handle to directory file */
    int     pos;                    /* current position in buf[] */
    int     count;                  /* # of valid bytes in buf[] */

    /* the size of the buffer isn't critical; larger results in
       fewer syscalls and is thus more efficient (to a point).
       we choose a value to keep the size of DIR a power of two
       minus 8, which makes the most efficient use of RAM with
       our implementation of malloc. */

    char    buf[1004];
};

/* open a directory stream */

DIR *opendir(const char *dirname);

/* read the next entry from a directory stream */

struct dirent *readdir(DIR *dirp);

/* rewind a directory stream to the beginning */

void rewinddir(DIR *dirp);

/* close a directory stream */

int closedir(DIR *dirp);

#endif /* _DIRENT_H */

/* vi: set ts=4 expandtab: */
