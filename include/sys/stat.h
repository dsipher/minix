/*****************************************************************************

   sys/stat.h                                          ux/64 system header

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

#include <sys/defs.h>

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

/* the seemingly excessive padding here is used to match the
   Linux ABI as best we can; some ux/64 types have different
   sizes, and we don't support some of the fields. */

struct stat
{
    dev_t           st_dev;
    int             __pad0;
    ino_t           st_ino;
    int             __pad1;
    nlink_t         st_nlink;
    int             __pad2;

    mode_t          st_mode;
    uid_t           st_uid;
    gid_t           st_gid;
    int             __pad3;

    dev_t           st_rdev;
    int             __pad4;
    off_t           st_size;
    long            __pad5;
    long            __pad6;

    time_t          st_atime;
    long            __pad7;
    time_t          st_mtime;
    long            __pad8;
    time_t          st_ctime;
    long            __pad9;

    unsigned long   __pad[3];
};

/* get file status */

extern int stat(const char *path, struct stat *buf);
extern int fstat(int fildes, struct stat *buf);

/* set and get the file mode creation mask */

extern mode_t umask(mode_t cmask);

#endif /* _SYS_STAT_H */

/* vi: set ts=4 expandtab: */
