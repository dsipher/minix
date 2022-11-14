/*****************************************************************************

   strerror.c                                       ux/64 standard library

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

#include <string.h>

static const char * const errors[] =
{
    /*  0 */    "success",
    /*  1 */    0,
    /*  2 */    "no such file or directory",                /* ENOENT */
    /*  3 */    0,
    /*  4 */    "interrupted system call",                  /* EINTR */
    /*  5 */    "input/output error",                       /* EIO */
    /*  6 */    "no such device or address",                /* ENXIO */
    /*  7 */    0,
    /*  8 */    "exec format error",                        /* ENOEXEC */
    /*  9 */    "bad file descriptor",                      /* EBADF */
    /* 10 */    0,
    /* 11 */    "resource temporarily unavailable",         /* EAGAIN */
    /* 12 */    "not enough space",                         /* ENOMEM */
    /* 13 */    "permission denied",                        /* EACCES */
    /* 14 */    "bad address",                              /* EFAULT */
    /* 15 */    "block device required",                    /* ENOTBLK */
    /* 16 */    "device or resource busy",                  /* EBUSY */
    /* 17 */    "file exists",                              /* EEXIST */
    /* 18 */    0,
    /* 19 */    "no such device",                           /* ENODEV */
    /* 20 */    "not a directory",                          /* ENOTDIR */
    /* 21 */    0,
    /* 22 */    "invalid argument",                         /* EINVAL */
    /* 23 */    "too many open files in system",            /* ENFILE */
    /* 24 */    "too many open files",                      /* EMFILE */
    /* 25 */    "inappropriate ioctl",                      /* ENOTTY */
    /* 26 */    "text file busy",                           /* ETXTBSY */
    /* 27 */    "file too large",                           /* EFBIG */
    /* 28 */    "no space left on device",                  /* ENOSPC */
    /* 29 */    0,
    /* 30 */    0,
    /* 31 */    0,
    /* 32 */    "broken pipe",                              /* EPIPE */
    /* 33 */    "argument not in domain",                   /* EDOM */
    /* 34 */    "result out of range"                       /* ERANGE */
};

#define NR_ERRORS (sizeof(errors) / sizeof(*errors))

char *strerror(int errno)
{
    if ((errno < 0) || (errno >= NR_ERRORS) || (errors[errno] == 0))
        return "unknown error";
    else
        return (char *) errors[errno];
}

/* vi: set ts=4 expandtab: */
