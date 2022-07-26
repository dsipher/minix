/*****************************************************************************

  sys/tahoe.h                                       tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _SYS_TAHOE_H
#define _SYS_TAHOE_H

#define __NULL      ((void *) 0)

typedef long            __blkcnt_t;
typedef long            __blksize_t;
typedef unsigned long   __dev_t;
typedef unsigned        __gid_t;
typedef unsigned long   __ino_t;
typedef unsigned        __mode_t;
typedef unsigned long   __nlink_t;
typedef long            __off_t;
typedef int             __pid_t;
typedef unsigned long   __size_t;
typedef long            __ssize_t;
typedef unsigned        __uid_t;
typedef char            *__va_list;

#define __SEEK_SET  0
#define __SEEK_CUR  1
#define __SEEK_END  2

#define __WEXITSTATUS(status)   (((status) & 0xff00) >> 8)
#define __WIFEXITED(status)     (__WTERMSIG(status) == 0)
#define __WIFSTOPPED(status)    (((status) & 0xff) == 0x7f)
#define __WIFSIGNALED(status)   (((signed char) (((status)&0x7f)+1)>>1)>0)
#define __WSTOPSIG(status)      __WEXITSTATUS(status)
#define __WTERMSIG(status)      ((status) & 0x7f)

#endif /* _SYS_TAHOE_H */

/* vi: set ts=4 expandtab: */
