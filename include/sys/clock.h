/*****************************************************************************

   sys/clock.h                                      jewel/os system header

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

#ifndef _SYS_CLOCK_H
#define _SYS_CLOCK_H

#include <sys/tailq.h>

/* both the local scheduling clocks and the
   global event clock fire at TICKS_PER_SEC. */

#define TICKS_PER_SEC   100

/* the number of ticks in a scheduling quantum */

#define QUANTUM         10

/* definitions associated with the 8254 PIT */

#define PITCH0          0x40        /* I/O registers */
#define PITCH1          0x41
#define PITCH2          0x42
#define PITCTL          0x43

#define PITFREQ         1193182     /* 1.193182 MHz */

/* shamelessly stolen from v7. to paraphrase the comments there:

     the callout structure is for a routine arranging to be
     called by the the global clock interrupt pitisr() with
     a specified argument, after a specified amount of ticks.

   unlike v7, we maintain callouts as a linked list rather than
   a fixed array. the caller is responsible for allocating the
   callo struct's storage and loaning it to timeout() while it
   is queued. when the callo expires, the callo is unqueued and
   c_func is invoked with interrupts disabled. */

struct callo
{
    long c_ticks;                   /* incremental time */
    void *c_arg;                    /* argument to routine */
    void (*c_func)(void *);         /* routine */
    TAILQ_ENTRY(callo) links;       /* queue links */
};

#ifdef _KERNEL

#include <sys/types.h>

/* a dummy variable whose address is used
   as the `lightning bolt', a sleep channel
   which is awakened roughly once a second. */

extern char lbolt;

/* the current time */

extern volatile time_t time;

/* called by the BSP at boot time to

    (a) determine the APIC timer frequency
    (b) read the CMOS time-of-day clock
    (c) start the global timer (8254 PIT) */

extern void clkinit(void);

/* called only by the BSP, after clkinit() but
   before schedclk(), for [rough] usec delays. */

extern void udelay(int usec);

/* the global timer ISR; update time-of-day
   clock and fire off global events */

extern void pitisr(int irq);

/* called on each CPU to start its local clock (its
   APIC) firing at TICKS_PER_SEC, for scheduling */

extern void tmrinit(void);

/* ring the console bell */

extern void bell(void);

/* add the callout to the timeout queue. `ticks' MUST
   be greater than 0 or Bad Things(tm) will happen. */

extern void timeout(struct callo *callo, long ticks);

#endif /* _KERNEL */

#endif /* _SYS_CLOCK_H */

/* vi: set ts=4 expandtab: */
