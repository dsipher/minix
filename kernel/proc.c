/*****************************************************************************

   proc.c                                                  jewel/os kernel

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

#include <errno.h>
#include <sys/boot.h>
#include <sys/proc.h>
#include <sys/spin.h>
#include <sys/user.h>

/* the scheduler lock. this protects proc[]. */

static spinlock_t sched_lock;

/* the process table. fixed size: NPROC entries
   allocated (and zeroed) at boot by pginit(). */

struct proc *proc;

/* a simple linear traversal to find a P_STATE_FREE entry.
   in practice, we never have to scan more entries than the
   max number of processes that have ever been live at once.

   pginit() zeroes proc[], so all entries start P_STATE_FREE. */

struct proc *
allproc(void)
{
    struct proc *p;
    int i;

    acquire(&sched_lock);

    for (i = 0, p = proc; i < NPROC; ++i, ++p)
        if (p->p_state == P_STATE_FREE)
        {
            p->p_state = P_STATE_NEW;
            goto out;
        }

    p = 0;
    u.u_error = EAGAIN;

out:
    release(&sched_lock);
    return p;
}

/* vi: set ts=4 expandtab: */
