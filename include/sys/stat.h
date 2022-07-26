/*****************************************************************************

  sys/stat.h                                        tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _SYS_STAT_H
#define _SYS_STAT_H

#include <sys/tahoe.h>

struct stat
{
    __dev_t         st_dev;
    __ino_t         st_ino;
    __nlink_t       st_nlink;

    __mode_t        st_mode;
    __uid_t         st_uid;
    __gid_t         st_gid;
    int             __pad0;

    __dev_t         st_rdev;
    __off_t         st_size;
    __blksize_t     st_blksize;
    __blkcnt_t      st_blocks;

    long            _st_atim[2];        /* no struct timespec yet */
    long            _st_mtim[2];
    long            _st_ctim[2];

    unsigned long   __reserved[3];
};

extern int fstat(int fd, struct stat *statbuf);

#endif /* _SYS_STAT_H */

/* vi: set ts=4 expandtab: */
