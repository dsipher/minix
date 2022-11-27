/*****************************************************************************

   sys/types.h                                         minix system header

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

#ifndef _SYS_TYPES_H
#define _SYS_TYPES_H

#include <sys/defs.h>

#ifndef __CADDR_T
#define __CADDR_T
typedef __caddr_t caddr_t;
#endif /* __CADDR_T */

#ifndef __DADDR_T
#define __DADDR_T
typedef __daddr_t daddr_t;
#endif /* __DADDR_T */

#ifndef __DEV_T
#define __DEV_T
typedef __dev_t dev_t;
#endif /* __DEV_T */

/* these device macros are decidedly non-standard, but
   commonly used. if necessary, we can guard them.

        bits[7:0] are the minor for a device;
        bits[15:8] are for the major.

   this is how linux did these [historically], so we
   follow suit for abi compatibility (w/ stat etc.). */

#define MAKEDEV(major, minor)   ((dev_t) (((major) << 8) | (minor)))
#define MAJOR(dev)              (((dev) >> 8) & 0xFF)
#define MINOR(dev)              ((dev) & 0xFF)

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

#ifndef __NLINK_T
#define __NLINK_T
typedef __nlink_t nlink_t;
#endif /* __NLINK_T */

#ifndef __OFF_T
#define __OFF_T
typedef __off_t off_t;
#endif /* __OFF_T */

#ifndef __PID_T
#define __PID_T
typedef __pid_t pid_t;
#endif /* __PID_T */

#ifndef __SIZE_T
#define __SIZE_T
typedef __size_t size_t;
#endif /* __SIZE_T */

#ifndef __SSIZE_T
#define __SSIZE_T
typedef __ssize_t ssize_t;
#endif /* __SSIZE_T */

#ifndef __TIME_T
#define __TIME_T
typedef __time_t time_t;
#endif /* __TIME_T */

#ifndef __UID_T
#define __UID_T
typedef __uid_t uid_t;
#endif /* __UID_T */

#endif /* _SYS_TYPES_H */

/* vi: set ts=4 expandtab: */
