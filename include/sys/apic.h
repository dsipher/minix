/*****************************************************************************

   sys/apic.h                                          minix system header

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

#ifndef _SYS_APIC_H
#define _SYS_APIC_H

#include <sys/boot.h>
#include <sys/page.h>

/* the local APIC is at a fixed address, but
   because it's mapped into the RAM image it
   is simpler to index through a variable. */

extern unsigned volatile *lapic;

#define LAPIC_REG(x)        (lapic[(x) >> 2])

#define LAPIC_ID            LAPIC_REG(0x020)    /* APIC ID */
#define LAPIC_EOI           LAPIC_REG(0x0B0)    /* end-of-interrupt */
#define LAPIC_ICR0          LAPIC_REG(0x300)    /* interrupt command (LSW) */
#define LAPIC_ICR1          LAPIC_REG(0x310)    /* ................. (MSW) */
#define LAPIC_TIMER         LAPIC_REG(0x320)    /* timer vector */
#define LAPIC_TIMER_ICR     LAPIC_REG(0x380)    /* initial count */
#define LAPIC_TIMER_CCR     LAPIC_REG(0x390)    /* current count */
#define LAPIC_TIMER_DCR     LAPIC_REG(0x3E0)    /* divider control */

/* the APIC ID of the current CPU. (it goes without saying that
   this is only valid for as long as interrupts are disabled.) */

#define CURCPU              ((LAPIC_ID >> 24) & 0xFF)

/* values for LAPIC_ICR0 for various IPIs */

#define INIT_IPI            (0x00004500)
#define STARTUP_IPI         (0x00004600 | (BOOT_ADDR >> PAGE_SHIFT))
#define BROADCAST_IPI       (0x000C0000)  /* everyone but sender */

/* we reserve 31 vectors for interrupts at 0x20-0x3E (see boot.s).
   we disregard vector priorities, instead mapping I/O APIC pins
   directly to vectors, e.g., IOAPIC pin 0 -> IRQ 0 -> vector 0x20.
   IRQs 0-15 (pins 0-15) are assumed to be positive-edge triggered
   ISA sources, and IRQs 16-23 low-level PCI sources. IRQs 24-30
   are from `virtual' sources, e.g., the local APIC, MSI, or IPI. */

#define NIRQ                31

#define VECTOR(irq)         (0x20 + (irq))      /* irq # -> vector # */
#define ISAIRQ(irq)         ((irq) < 16)        /* posedge triggered */
#define IOAPICIRQ(irq)      ((irq) < 24)        /* attached to I/O APIC */

/* IRQs are fielded in locore.s by irqhook()
   then dispatched to the appropriate isr[] */

extern void irqhook(void);

/* c interrupt service handlers. these are defined
   in machdep.c (since they're platform-dependent) */

extern void (*isr[NIRQ])(int irq);

/* the I/O APIC lives at 0xFEC00000 physical but we
   access it via a pointer variable; see `lapic' */

extern volatile unsigned *ioapic;

#define IOREGSEL        (ioapic[0])     /* I/O APIC register selection */
#define IOREGWIN        (ioapic[4])     /* and the window into that reg */

/* the register numbers for the I/O APIC
   redirection entries. these are 64 bit
   registers accessed as 2x32-bit words.

   redirection entry x corresponds to pin x */

#define IOREDLO(x)      (0x10 + ((x) * 2))      /* bits[31:0] */
#define IOREDHI(x)      (IOREDLO(x) + 1)        /* ...[63:32] */

#define IOREDISA    0x00000000      /* ISA: active high, edge-triggered */
#define IOREDPCI    0x0000A000      /* PCI: active low, level-triggered */
#define IOREDMASK   0x00010000      /* mask interrupt */

/* initialize the I/O APIC at startup */

extern void irqinit(void);

/* enable (on = 1) or disable (on = 0)
   the interrupt on I/O APIC pin/irq */

extern void enable(int irq, int on);

#endif /* _SYS_APIC_H */

/* vi: set ts=4 expandtab: */
