/*****************************************************************************

   clock.c                                                    minix kernel

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).

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

#include <sys/types.h>
#include <sys/tailq.h>
#include <sys/io.h>
#include <sys/clock.h>
#include <sys/apic.h>
#include <sys/cmos.h>
#include <sys/proc.h>
#include <sys/log.h>
#include <sys/cons.h>
#include <sys/ps2.h>
#include "config.h"

/* the `lightning bolt' sleep channel */

char lbolt;

/* these are read-only outside of this compilation unit. no need
   to protect them with locsk since they're updated atomically. */

volatile time_t time;
volatile long jiffies;

/* if the system console bell is ringing, this contains the
   number of ticks remaining before it should be turned off.
   this is a specialized callout, protected by callo_lock. */

static char ringing;

/* protects callouts (and `ringing' as mentioned above) */

static spinlock_t callo_lock;

/* queued callouts. kept in order of expiration.
   in queue, c_ticks is a differential count */

static TAILQ_HEAD(, callo) callouts = TAILQ_HEAD_INITIALIZER(callouts);

/* we don't need fine resolution for scheduling,
   so we use the max APIC clock divider (128). */

#define DIVIDER             0x0000000A  /* DCR */
#define APICS_TO_MHZ(x)     (((x) * 128) / 1000000)

/* bits in the timer LVT */

#define TIMER_MASKED        0x00010000      /* interrupt masked */
#define TIMER_PERIODIC      0x00020000      /* automatic restart */

/* the maximum counter value */

#define TIMER_MAX           0xFFFFFFFF

/* the number of APIC timer ticks per second */

static unsigned apics_per_sec;

/* convert a byte in BCD format to binary. */

#define UNBCD(bcd)  ((((bcd) & 0xF0) >> 4) * 10 + ((bcd) & 0x0F))

/* howard hinnant's method for computing the number
   of days between the epoch (Jan 1 1970) and m/d/y. */

static int
hinnant(int y, int m, int d)
{
    unsigned    yoe, doy, doe;
    int         era;

    y -= (m <= 2);
    era = ((y >= 0) ? y : (y - 399)) / 400;
    yoe = y - era * 400;
    doy = (153 * (m + ((m > 2) ? -3 : 9)) + 2)/5 + d - 1;
    doe = yoe * 365 + yoe / 4 - yoe / 100 + doy;

    return era * 146097 + ((int) doe) - 719468;
}

/* read the CMOS RTC and return the time as UNIX epoch time.
   this should only be called during system initialization,
   since it assumes interrupts are disabled and busy-waits
   for up to a second while waiting for the RTC to update,
   and we don't synchronize CMOS access. assumes RTC is UTC. */

#define SECOND          0           /* indices into state[] */
#define MINUTE          1
#define HOUR            2
#define DAY             3
#define MONTH           4
#define YEAR            5
#define STATUS_A        6
#define STATUS_B        7

#define A_BUSY          0x80        /* update in progress */
#define B_24HR          0x02        /* time is in 24-hour format */
#define B_BIN           0x01        /* values are binary (not BCD) */

static time_t
rtcread(void)
{
    /* the RTC registers we want are not
       at contiguous addresses, so map 'em */

    static const char map[] = {     CMOS_SECOND,
                                    CMOS_MINUTE,
                                    CMOS_HOUR,
                                    CMOS_DAY,
                                    CMOS_MONTH,
                                    CMOS_YEAR,
                                    CMOS_STATUS_A,
                                    CMOS_STATUS_B    };

    /* if the RTC is in BCD format, these are the
       elements of state[] that are BCD-encoded */

    static const char bcd[] = {     SECOND,
                                    MINUTE,
                                    HOUR,
                                    DAY,
                                    MONTH,
                                    YEAR            };

    char state[sizeof(map)];    /* state (indexed by SECOND, HOUR, etc.) */
    time_t time;                /* epoch time */
    int pm;                     /* AM/PM (set if PM) */

    int i;

    /* we must read the clock when it's not updating. the
       easiest way to avoid races is to wait to observe an
       update, then read the state (within the next second).

       there are faster ways to synchronize, but this way
       back-to-back calls to rtcread() mark out one second,
       which is handy for clkinit(). */

    while (!(READ_CMOS(CMOS_STATUS_A) & A_BUSY)) ;  /* wait for update */
    while (READ_CMOS(CMOS_STATUS_A) & A_BUSY) ;     /* and let it finish */

    for (i = 0; i < sizeof(map); ++i) state[i] = READ_CMOS(map[i]);

    /* if the RTC is in 12-hour format, then bit 7 of HOUR
       is the AM/PM bit (set = PM). strip the bit for now. */

    if (state[STATUS_B] & B_24HR)
        pm = 0;
    else {
        pm = state[HOUR] & 0x80;
        state[HOUR] &= 0x7F;
    }

    /* and if the RTC is in BCD format, normalize as binary */

    if (!(state[STATUS_B] & B_BIN))
        for (i = 0; i < sizeof(bcd); ++i)
            state[bcd[i]] = UNBCD(state[bcd[i]]);

    if (pm) state[HOUR] += 12;      /* normalize to 24-hour clock */

    time = hinnant(2000 + state[YEAR], state[MONTH], state[DAY]);

    time *= 86400;
    time += state[HOUR] * 3600;
    time += state[MINUTE] * 60;
    time += state[SECOND];

    return time;
}

/* we don't need to be especially accurate when determining
   the local APIC frequency, as we only use the timer for
   scheduling. note that we don't account for local APICs
   whose timers vary in frequency with power state (or even
   stop ticking). this doesn't apply to ATOM; that sort of
   complexity is precisely what minix is trying to escape. */

void
clkinit(void)
{
    /* first, we stop the local APIC timer in case it's
       running, plug in our chosen divider (which we'll
       use on all APICs) and arm it for one-shot */

    LAPIC_TIMER = TIMER_MASKED;         /* one-shot, no IRQs please */
    LAPIC_TIMER_DCR = DIVIDER;          /* (see apic.h for divisor) */

    /* then read the real-time clock. we're not interested in
       the value; we want to synchronize to a second boundary.
       then quickly start the local APIC timer. */

    rtcread();
    LAPIC_TIMER_ICR = TIMER_MAX;

    /* the next rtcread() returns approximately one second
       after the first call did, so we can count APIC ticks.
       (we stash the current time of day this time, too.) */

    time = rtcread();
    apics_per_sec = TIMER_MAX - LAPIC_TIMER_CCR;

    printf(", timer %d MHz", APICS_TO_MHZ(apics_per_sec));

    /* and now tell the PIT to start firing at TICKS_PER_SEC */

    OUTB(PITCTL, 0x36);                             /* ch0 sq wave */
    OUTB(PITCH0, PITFREQ / TICKS_PER_SEC);          /* divider LSB */
    OUTB(PITCH0, (PITFREQ / TICKS_PER_SEC) >> 8);   /* ....... MSB */

    /* and configure channel 2 for the console BEL */

    OUTB(PITCTL, 0xB6);                             /* ch2 sq wave */
    OUTB(PITCH2, PITFREQ / BEL_FREQ);
    OUTB(PITCH2, (PITFREQ / BEL_FREQ) >> 8);

    enable(PIT_IRQ, 1);
}

/* we borrow the local APIC timer to effect delays on
   the order of usec; they are necessarily approximate.
   we try to err on the side of longer-than-requested.
   since we are (1) busy waiting and (2) clobbering the
   APIC timer, this is only used during initialization */

void
udelay(int usec)
{
    unsigned deadline;

    deadline = TIMER_MAX - (((apics_per_sec) / 1000000) + 1) * usec;

    /* udelay() is only called by the BSP, which also called clkinit(),
       so we know LAPIC_TIMER and LAPIC_TIMER_DCR are already set... */

    LAPIC_TIMER_ICR = TIMER_MAX;            /* start counting */
    while (LAPIC_TIMER_CCR > deadline) ;    /* and wait for the deadline */
}

/* we slightly vary the period of the scheduling
   timer on every CPU so they won't synchronize. */

void
tmrinit(void)
{
    LAPIC_TIMER_ICR = 0;
    LAPIC_TIMER_DCR = DIVIDER;
    LAPIC_TIMER = TIMER_PERIODIC | VECTOR(TMR_IRQ);
    LAPIC_TIMER_ICR = (apics_per_sec / TICKS_PER_SEC) - (CURCPU * 512);
}

void
pitisr(int irq)
{
    static unsigned char ticks;
    struct callo *callo;

    ++jiffies;

    /* update time of day. wake
       up lbolt every second. */

    if (++ticks == TICKS_PER_SEC) {
        ticks = 0;
        ++time;
        wakeup(&lbolt);
    }

    acquire(&callo_lock);

    /* if the console `bell' is `ringing', count
       down a tick and turn it off if it's time */

    if (ringing && --ringing == 0)
    {
        unsigned char b;

        b = INB(PS2_PORTB);
        b &= ~PS2_PORTB_SPK;
        OUTB(PS2_PORTB, b);
    }

    /* now decrement callout counter and run expired callouts. we
       dequeue the callo and release the callo_lock before calling
       the handler, so the callout may be requeued if desired. */

    callo = TAILQ_FIRST(&callouts);
    if (callo) --callo->c_ticks;

    while (callo && callo->c_ticks == 0)
    {
        TAILQ_REMOVE(&callouts, callo, links);
        release(&callo_lock);
        callo->c_func(callo->c_arg);
        acquire(&callo_lock);
        callo = TAILQ_FIRST(&callouts);
    }

    release(&callo_lock);
}

/* ring the console bell. if it's already on,
   we extend the duration another full period. */

void
bell(void)
{
    unsigned char b;

    acquire(&callo_lock);

    if (ringing == 0)
    {
        b = INB(PS2_PORTB);
        b |= PS2_PORTB_SPK;
        OUTB(PS2_PORTB, b);
    }

    ringing = BEL_TICKS;

    release(&callo_lock);
}

/* again, to paraphrase v7: a callout is sorted into the
   queue. c_ticks in each structure is the number of ticks
   more than the previous entry. in this way, decrementing
   the first entry has the effect of updating all entries. */

void
timeout(struct callo *callo, long ticks)
{
    struct callo *before;

    callo->c_ticks = ticks;
    acquire(&callo_lock);

    for (before = TAILQ_FIRST(&callouts);
         before;
         before = TAILQ_NEXT(before, links))
    {
        if (callo->c_ticks >= before->c_ticks)
            callo->c_ticks -= before->c_ticks;
        else {
            TAILQ_INSERT_BEFORE(before, callo, links);
            before->c_ticks -= callo->c_ticks;
            break;
        }
    }

    if (before == 0)
        /* fell off end of queue, tack onto end */
        TAILQ_INSERT_TAIL(&callouts, callo, links);

    release(&callo_lock);
}

/* vi: set ts=4 expandtab: */
