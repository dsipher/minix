/*****************************************************************************

   fcntl.h                                             ux/64 system header

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

#ifndef _FCNTL_H
#define _FCNTL_H

#include <sys/defs.h>

#ifndef __MODE_T
#define __MODE_T
typedef __mode_t mode_t;
#endif /* __MODE_T */

/* create a new file or
   rewrite an existing one */

int creat(const char *path, mode_t mode);

/* open a file */

#define O_RDONLY    00000000
#define O_WRONLY    00000001
#define O_RDWR      00000002
#define O_CREAT     00000100
#define O_EXCL      00000200
#define O_NOCTTY    00000400
#define O_TRUNC     00001000
#define O_APPEND    00002000
#define O_NONBLOCK  00004000

#define O_ACCMODE   (O_WRONLY | O_RDWR)

int open(const char *path, int oflag, ...);

/* file control */

#define F_DUPFD     0       /* duplicate file descriptor */
#define F_GETFD     1       /* get descriptor flags (FD_*) */
#define F_SETFD     2       /* set ........................ */
#define F_GETFL     3       /* get status flags (O_*) */
#define F_SETFL     4       /* set .................. */

#define FD_CLOEXEC  1       /* close-on-exec: for F_SETFD/F_GETFD */

int fcntl(int fildes, int cmd, ...);

#endif /* _FCNTL_H */

/* vi: set ts=4 expandtab: */
