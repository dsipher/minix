/*****************************************************************************

   apic.c                                                     ux/64 kernel

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

#include <sys/page.h>
#include <sys/spin.h>
#include <sys/apic.h>

/* the APICs technically has a floating base
   addresses, but in practice they're fixed. */

volatile unsigned *lapic  = (volatile unsigned *) PTOV(0xFEE00000);
volatile unsigned *ioapic = (volatile unsigned *) PTOV(0xFEC00000);

/* accesses to the I/O APIC must be atomic */

static spinlock_t ioapic_lock;

/* reconstruct the redirection entry every time
   rather than reading it and toggling a bit. */

void
enable(int irq, int on)
{
    unsigned lo;

    lo = VECTOR(irq);
    lo |= ISAIRQ(irq) ? IOREDISA : IOREDPCI;
    lo |= on ? 0 : IOREDMASK;

    acquire(&ioapic_lock);
    IOREGSEL = IOREDHI(irq);
    IOREGWIN = 0; /* BSP */
    IOREGSEL = IOREDLO(irq);
    IOREGWIN = lo;
    release(&ioapic_lock);
}

/* set up all redirection entries, and mask
   them all off. enable() does all the work! */

void
irqinit(void)
{
    int irq;

    for (irq = 0; irq < NIRQ; ++irq)
        if (IOAPICIRQ(irq))
            enable(irq, 0);
}

/* vi: set ts=4 expandtab: */
