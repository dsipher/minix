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

/* get the index into proc[] from a struct proc
   or pid. note that a given slot `n' in proc[]
   will only be assigned a pid such that:

                pid = m * NPROC + n

   for some arbitrary integer `m'. this property
   makes finding processes by pid fairly efficient,
   as evidenced by INDEX_FROM_PID; it also makes pid
   assignment easy, since we need not for duplicates. */

#define INDEX_FROM_PROC(p)      ((p) - proc)
#define INDEX_FROM_PID(pid)     ((pid) % NPROC)

/* we clamp pid values; pid_t is a 32-bit int for
   ABI reasons, but it's pointless and obnoxious
   when pids to have more than a few digits. */

#define PID_MAX     99999       /* five digits max */

/* process queues. through its p_qlinks
   field, a process may be on one of the
   following queues. */

TAILQ_HEAD(procq, proc);

    /* P_STATE_READY are put on the readyq.
       they are waiting to be scheduled. */

struct procq readyq = TAILQ_HEAD_INITIALIZER(readyq);

    /* P_STATE_SLEEP (interruptible by a signal) and
       P_STATE_COMA (not interruptible) are on sleepq */

struct procq sleepq = TAILQ_HEAD_INITIALIZER(sleepq);

    /* as a matter of convenience, P_FLAG_IDLE procs
       never go on the readyq; they are put here */

struct procq idleq = TAILQ_HEAD_INITIALIZER(idleq);

#define READYQ(p)   (((p)->p_flags & P_FLAG_IDLE) ? &idleq : &readyq)

/* a simple linear traversal to find a P_STATE_FREE entry.
   in practice, we never have to scan more entries than the
   max number of processes that have ever been live at once.

   pginit() zeroes proc[], so all entries start FREE. */

struct proc *
procall(void)
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

/* return a proc to
   the free pool */

static void
procfree(struct proc *p)
{
    acquire(&sched_lock);
    p->p_state = P_STATE_FREE;
    release(&sched_lock);
}

/* when we have such things, we'll need to
   duplicate file descriptors and such here */

struct proc *
newproc(void (*entry)(void))
{
    struct proc *p;
    pte_t *pte;
    int n;

    /* get a new process entry */

    if ((p = procall()) == 0)
        return 0; /* EAGAIN */

    /* duplicate our address space */

    p->p_ptl3 = ptcopy(CURPROC->p_ptl3);

    if (p->p_ptl3 == 0) {
        procfree(p);
        u.u_error = ENOMEM;
        return 0;
    }

    /* link this entry with its u. area.
       we need not worry about findpte()
       failing; we know there's a mapping */

    pte = findpte(p->p_ptl3, USER_ADDR, 0);
    p->p_u = (struct user *) PTOV(PTE_ADDR(*pte));
    p->p_u->u_procp = p;

    /* assign a new process id. see comments at the top
       of the file explaining the relationship between
       the proc[] index and the pid that make this work. */

    if (p->p_pid == 0) /* virgin */
        p->p_pid = INDEX_FROM_PROC(p);
    else {
        p->p_pid += NPROC;

        if (p->p_pid > PID_MAX) /* clamp */
            p->p_pid = INDEX_FROM_PROC(p);
    }

    /* other nerdlies */

    p->p_flags = CURPROC->p_flags;
    p->p_cpu = CURPROC->p_cpu;
    p->p_age = 0;

    /* finally, arrange for the process to start
       execution with a fresh stack at `entry'. */

    p->p_u->u_sys_rip = (caddr_t) entry;
    p->p_u->u_sys_rsp = KERNEL_STACK;

    return p;
}

/* everything proc ends up at run() came
   from newproc(), which has initialized
   all relevant fields; we just queue it */

void
run(struct proc *p)
{
    acquire(&sched_lock);

    p->p_state = P_STATE_READY;
    TAILQ_INSERT_TAIL(READYQ(p), p, p_qlinks);

    release(&sched_lock);
}

/* vi: set ts=4 expandtab: */
