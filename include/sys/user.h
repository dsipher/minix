/*****************************************************************************

   sys/user.h                                    jewel/os standard library

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

#ifndef _SYS_USER_H
#define _SYS_USER_H

/* the user structure holds partial state for the current process. it is
   always found at USER_BASE (see sys/page.h) and shares USER_PAGES with
   the process's kernel stack. the remainder of the process state can be
   found in its struct proc, cross-referenced here via u_procp.

   historically, unix split the state to preserve kernel data space: the
   user struct carried the bulk state that is only referenced from within
   the context of the process itself, whereas the much smaller proc struct
   held process information needed from other contexts. we continue this
   convention, though for slightly different reasons. in particular, the
   u. area's fixed address in kernel space allows us to avoid the headache
   of per-cpu data. (e.g., u.procp answers `which process is on this cpu?')

   if you change the layout, be sure to keep in sync with U_* in locore.s. */

struct user
{
    /* saved floating-point state. only used when the P_FLAG_SSE
       flag is set in u.procp->p_flags. it comes first to ensure
       that it's 16-byte aligned, as required by FXSAVE/FXRSTOR. */

    char            u_fxsave[512];

    struct proc     *u_procp;       /* 0x0200: associated struct proc */
    unsigned char   u_locks;        /* 0x0208: depth of `cli' nesting */
};

extern struct user u;           /* exported from locore.s */

#ifdef _KERNEL

extern void lock(void);         /* disable or enable interrupts: */
extern void unlock(void);       /* works recursively via u_locks */

#endif /* _KERNEL */

#endif /* _SYS_USER_H */

/* vi: set ts=4 expandtab: */
