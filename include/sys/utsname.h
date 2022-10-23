/*****************************************************************************

   sys/utsname.h                                       ux/64 system header

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

#ifndef _SYS_UTSNAME_H
#define _SYS_UTSNAME_H

/* each field has room for a 64-byte
   string, plus the NUL terminator */

#define _UTSNAME_N  65

struct utsname
{
    char sysname[_UTSNAME_N];       /* operating system */
    char nodename[_UTSNAME_N];      /* machine name */
    char release[_UTSNAME_N];       /* release level */
    char version[_UTSNAME_N];       /* version of release */
    char machine[_UTSNAME_N];       /* machine type */

    char __pad[_UTSNAME_N];         /* not POSIX: domainname[] on Linux */
};

#ifndef _KERNEL

extern int uname(struct utsname *);

#else

extern struct utsname utsname;

#endif /* _KERNEL */

#endif /* _SYS_UTSNAME_H */

/* vi: set ts=4 expandtab: */
