/*****************************************************************************

   pwd.h                                               minix system header

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

#ifndef _PWD_H
#define _PWD_H

#include <sys/defs.h>

#ifndef __GID_T
#define __GID_T
typedef __gid_t gid_t;
#endif /* __GID_T */

#ifndef __UID_T
#define __UID_T
typedef __uid_t uid_t;
#endif /* __UID_T */

/* fields are in order of their appearance in /etc/passwd */

struct passwd
{
    char    *pw_name;           /* login name */
    char    *pw_passwd;         /* password info */
    uid_t   pw_uid;             /* user id */
    gid_t   pw_gid;             /* group id */
    char    *pw_gecos;          /* full name */
    char    *pw_dir;            /* home directory */
    char    *pw_shell;          /* chosen shell */
};

/* retrieve password file entry by uid */

extern struct passwd *getpwuid(uid_t uid);

/* retrieve password file entry by username */

extern struct passwd *getpwnam(const char *name);

/* rewind the password database cursor */

extern void setpwent(void);

/* get the next password entry, advance cursor */

extern struct passwd *getpwent(void);

/* close the password database */

extern void endpwent(void);

#endif /* _PWD_H */

/* vi: set ts=4 expandtab: */
