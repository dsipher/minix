/*****************************************************************************

   sys/proc.h                                    jewel/os standard library

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

#ifndef _SYS_PROC_H
#define _SYS_PROC_H

#include <sys/types.h>
#include <sys/page.h>
#include <sys/tailq.h>

/* locore.s accesses some of these fields, so keep
   the offsets in sync with the definitions there.
   ditto for the bit definitions for p_state, etc. */

struct proc
{
    pte_t               *p_ptl3;        /* 0x0000: handle to page tables */
    struct user         *p_u;           /* 0x0008: address of u. area */
    pid_t               p_pid;          /* 0x0010: the process ID */
    char                p_state;        /* 0x0014: P_STATE_* (below) */
    char                p_flags;        /* 0x0015: P_FLAG_* (below) */
    char                p_cpu;          /* 0x0016: CPU last run on */
    unsigned char       p_age;          /* 0x0017: ticks since last run */
    void                *p_chan;        /* 0x0018: sleep channel */
    TAILQ_ENTRY(proc)   p_qlinks;       /* 0x0020: for sleepq or readyq */
};

/* process states are represented as a bitset so we can refer to groups
   of states easily, but a process may only be in one state at a time. */

#define P_STATE_NEW     0x01        /* embryonic, just created */
#define P_STATE_RUN     0x02        /* currently running on a CPU */
#define P_STATE_READY   0x04        /* ready to run (on readyq) */
#define P_STATE_SLEEP   0x08        /* sleeping (on sleepq); interruptible */
#define P_STATE_COMA    0x10        /* sleeping (on sleepq); no signals */
#define P_STATE_ZOMBIE  0x20        /* dead. waiting for parent to claim */

/* sched() refuses to pick a READY process from a different p_cpu unless
   proc.p_age >= P_AGE_OLD ticks. this adds some hysteresis to prevent a
   process from jumping between CPUs and needlessly thrashing the caches. */

#define P_AGE_OLD       30
#define P_AGE_MAX       255

/* there is one idle process per CPU in the system. they are special in
   two ways: (1) they're never scheduled unless there's nothing else for
   a CPU to do, and (2) they are preemptible, despite being system-mode. */

#define P_FLAG_IDLE     0x01

/* saving and restoring SSE state with FXSAVE/FXRSTOR is expensive, so we
   don't bother unless the process uses SSE, which we mark with this flag */

#define P_FLAG_SSE      0x02

#ifdef _KERNEL

extern struct proc proc0;

/* save the current context and switch to a new process
   `to'. must be called with the scheduler lock held. */

extern void swtch(struct proc *to);

#endif /* _KERNEL */

#endif /* _SYS_PROC_H */

/* vi: set ts=4 expandtab: */
