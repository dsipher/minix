/*****************************************************************************

   sys/apic.h                                    jewel/os standard library

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

#ifndef _SYS_APIC_H
#define _SYS_APIC_H

/* the local APIC is at a fixed address, but
   because it's mapped into the RAM image it
   is faster to index through a variable. */

extern unsigned volatile *lapic;

#define LAPIC_REG(x)        (lapic[(x) >> 2])

#define LAPIC_ID            LAPIC_REG(0x020)    /* APIC ID */
#define LAPIC_ICR0          LAPIC_REG(0x300)    /* interrupt command (LSW) */
#define LAPIC_ICR1          LAPIC_REG(0x310)    /* ................. (MSW) */
#define LAPIC_TIMER         LAPIC_REG(0x320)    /* timer vector */
#define LAPIC_TIMER_ICR     LAPIC_REG(0x380)    /* initial count */
#define LAPIC_TIMER_CCR     LAPIC_REG(0x390)    /* current count */
#define LAPIC_TIMER_DCR     LAPIC_REG(0x3E0)    /* divider control */

/* the APIC ID of the current CPU. (it goes without saying that
   this is only valid for as long as interrupts are disabled.) */

#define CURCPU              ((LAPIC_ID >> 24) & 0xFF)

#endif /* _SYS_APIC_H */

/* vi: set ts=4 expandtab: */
