/*****************************************************************************

   errno.h                                             ux/64 system header

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

#ifndef _ERRNO_H
#define _ERRNO_H

#ifndef _KERNEL

extern int errno;

#endif /* _KERNEL */

#define ENOENT      2       /* no such file or directory */
#define EINTR       4       /* interrupted system call */
#define EIO         5       /* input/output error */
#define ENXIO       6       /* no such device or address */
#define ENOEXEC     8       /* exec format error */
#define EBADF       9       /* bad file descriptor */
#define EAGAIN      11      /* resource temporarily unavailable */
#define ENOMEM      12      /* out of memory */
#define EACCES      13      /* permission denied */
#define EFAULT      14      /* bad address */
#define ENOTBLK     15      /* block device required */
#define EBUSY       16      /* device or resource busy */
#define EEXIST      17      /* file exists */
#define ENODEV      19      /* no such device */
#define ENOTDIR     20      /* not a directory */
#define EISDIR      21      /* is a directory */
#define EINVAL      22      /* invalid argument */
#define ENFILE      23      /* too many open files in system */
#define EMFILE      24      /* too many open files */
#define ENOTTY      25      /* not a typewriter */
#define ETXTBSY     26      /* text file busy */
#define EFBIG       27      /* file too large */
#define ENOSPC      28      /* no space left on device */
#define EPIPE       32      /* broken pipe */
#define EDOM        33      /* math argument out of domain of func */
#define ERANGE      34      /* math result not representable */
#define ENOSYS      38      /* function not implemented */

#endif /* _ERRNO_H */

/* vi: set ts=4 expandtab: */
