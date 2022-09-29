/*****************************************************************************

   sys/clock.h                                   jewel/os standard library

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

/* both the local scheduling clocks and the
   global event clock fire at TICKS_PER_SEC. */

#define TICKS_PER_SEC   100

/* the number of ticks in a scheduling quantum */

#define QUANTUM         10


#ifdef _KERNEL

#include <sys/types.h>

/* the current time */

extern time_t time;

/* called by the BSP at boot time to

    (a) determine the APIC timer frequency
    (b) read the CMOS time-of-day clock */

extern void clkinit(void);

/* called only by the BSP, after clkinit() but
   before localclk(), for [rough] usec delays. */

extern void udelay(int usec);

/* called on each CPU to start its local clock (its
   APIC) firing at TICKS_PER_SEC, for scheduling */

extern void localclk(void);

/* called at boot to start the global clock (the 8254
   PIT) firing at TICKS_PER_SEC, for time-of-day */

extern void globalclk(void);

#endif /* _KERNEL */

#endif /* _SYS_CLOCK_H */

/* vi: set ts=4 expandtab: */
