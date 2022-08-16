/*****************************************************************************

   sys/stat.h                                    tahoe/64 standard library

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

#ifndef _SYS_STAT_H
#define _SYS_STAT_H

#include <sys/tahoe.h>

#ifndef __BLKCNT_T
#define __BLKCNT_T
typedef __blkcnt_t blkcnt_t;
#endif /* __BLKCNT_T */

#ifndef __BLKSIZE_T
#define __BLKSIZE_T
typedef __blksize_t blksize_t;
#endif /* __BLKSIZE_T */

#ifndef __DEV_T
#define __DEV_T
typedef __dev_t dev_t;
#endif /* __DEV_T */

#ifndef __GID_T
#define __GID_T
typedef __gid_t gid_t;
#endif /* __GID_T */

#ifndef __INO_T
#define __INO_T
typedef __ino_t ino_t;
#endif /* __INO_T */

#ifndef __MODE_T
#define __MODE_T
typedef __mode_t mode_t;
#endif /* __MODE_T */

#define S_IFMT          0170000     /* definitions for mode_t */
#define S_IFREG         0100000
#define S_IFBLK         0060000
#define S_IFDIR         0040000
#define S_IFCHR         0020000

#define S_ISUID         0004000
#define S_ISGID         0002000
#define S_ISVTX         0001000
#define S_IRUSR         0000400
#define S_IWUSR         0000200
#define S_IXUSR         0000100
#define S_IRGRP         0000040
#define S_IWGRP         0000020
#define S_IXGRP         0000010
#define S_IROTH         0000004
#define S_IWOTH         0000002
#define S_IXOTH         0000001

#define S_ISREG(m)      (((m) & S_IFMT) == S_IFREG)
#define S_ISDIR(m)      (((m) & S_IFMT) == S_IFDIR)
#define S_ISCHR(m)      (((m) & S_IFMT) == S_IFCHR)
#define S_ISBLK(m)      (((m) & S_IFMT) == S_IFBLK)

#define S_IRWXU         (S_IRUSR | S_IWUSR | S_IXUSR)
#define S_IRWXG         (S_IRGRP | S_IWGRP | S_IXGRP)
#define S_IRWXO         (S_IROTH | S_IWOTH | S_IXOTH)

#ifndef __NLINK_T
#define __NLINK_T
typedef __nlink_t nlink_t;
#endif /* __NLINK_T */

#ifndef __OFF_T
#define __OFF_T
typedef __off_t off_t;
#endif /* __OFF_T */

#ifndef __TIME_T
#define __TIME_T
typedef __time_t time_t;
#endif /* __TIME_T */

#ifndef __UID_T
#define __UID_T
typedef __uid_t uid_t;
#endif /* __UID_T */


struct stat
{
    dev_t           st_dev;
    ino_t           st_ino;
    nlink_t         st_nlink;

    mode_t          st_mode;
    uid_t           st_uid;
    gid_t           st_gid;
    int             __pad0;

    dev_t           st_rdev;
    off_t           st_size;
    blksize_t       st_blksize;
    blkcnt_t        st_blocks;

    time_t          st_atime;           /* these are really */
    long            st_atimensec;       /* `struct timespec' */
    time_t          st_mtime;           /* but POSIX says we */
    long            st_mtimensec;       /* can't import <time.h> */
    time_t          st_ctime;
    long            st_ctimensec;

    unsigned long   __reserved[3];
};

extern int fstat(int fd, struct stat *statbuf);

#endif /* _SYS_STAT_H */

/* vi: set ts=4 expandtab: */
