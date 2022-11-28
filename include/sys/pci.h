/*****************************************************************************

   sys/pci.h                                           minix system header

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

#ifndef _SYS_PCI_H
#define _SYS_PCI_H

/* we designate PCI devices topologically: bus/device/function.
   we stuff them into a 32-bit word, which (not coincidentally)
   has the same format as the configuration address port. */

typedef unsigned pcidev_t;

#define PCI_DEV(b, d, f)    (((b) << 16) | ((d) << 11) | ((f) << 8))

/* i/o registers used to access a window in configuration space */

#define PCI_ADDR        0x0CF8          /* address port */
#define PCI_DATA        0x0CFC          /* data window */

/* compute the value to put in PCI_ADDR to access configuration
   register `reg' on device `dev' via the PCI_DATA window */

#define PCI_ADDR_REG(dev, reg)      (0x80000000 | (dev) | (reg))

/* registers in configuration space */

#define PCI_CONF_ID             0       /* device/vendor */
#define PCI_CONF_CMDSTAT        4       /* command/status */
#define PCI_CONF_CLASS          8       /* class code/rev */

#define PCI_CONF_BAR0           16      /* base address 0 */
#define PCI_CONF_BAR1           20      /* base address 1 */
#define PCI_CONF_BAR2           24      /* base address 2 */
#define PCI_CONF_BAR3           28      /* base address 3 */
#define PCI_CONF_BAR4           32      /* base address 4 */
#define PCI_CONF_BAR5           36      /* base address 5 */

#define PCI_CONF_CAPS           52      /* capabilities pointer */

/* PCI_CONF_CMDSTAT */

#define PCI_CMD_IO              0x00000001      /* i/o decoder enabled */
#define PCI_CMD_MEM             0x00000002      /* mem decoder enabled */
#define PCI_CMD_BUSMASTER       0x00000004      /* busmastering enabled */

#define PCI_STAT_CAPS           0x00100000      /* capabilities present */

/* PCI_CONF_CLASS */

#define PCI_CLASS(x)            (0xFF000000 & (x))      /* device class */
#define PCI_SBCLS(x)            (0x00FF0000 & (x))      /* device subclass */

#define PCI_CLASS_STORAGE       0x01000000              /* mass storage */
#define PCI_SBCLS_IDE           0x00010000              /* IDE controller */

/* PCI_CONF_BARx */

#define PCI_BAR_IO(x)           ((x) & 1)       /* true if i/o address */
#define PCI_BAR(x)              ((x) & ~3)      /* address bits only pls */

/* PCI_CONF_CAPS */

#define PCI_CAPS_FIRST(x)       ((x) & 0xFF)

/* the structure an entry in the PCI capabilities list */

#define PCI_CAP_ID(x)           ((x) & 0x000000FF)
#define PCI_CAP_NEXT(x)         (((x) & 0x0000FF00) >> 8)

/* the only PCI capability of interest to us is the
   MSI (message-signaled interrupts) capability */

#define PCI_MSI_CAP             0x05            /* PCI_CAP_ID() */

/* bits in the upper part of the capabilities word for MSI */

#define PCI_MSI_CAP_EN          0x00010000      /* enable MSI */
#define PCI_MSI_CAP_64BIT       0x00800000      /* 64-bit address */

/* offsets (from the capabilities reg) to the MSI registers.
   note that the offsets differ depending on address size. */

#define PCI_MSI32_MAR           4       /* offset to 32-bit address reg */
#define PCI_MSI32_MDR           8       /* and the data to store there */

#define PCI_MSI64_MARL          4       /* offset to bits[31:0] and ... */
#define PCI_MSI64_MARH          8       /* ... bits[63:31] of the address */
#define PCI_MSI64_MDR           12      /* and the data to store there */

/* the values to put in the MAR and MDR. the former determines which
   cpu it will be delivered to, the latter which vector is triggered. */

#define PCI_MSI_MAR(cpu)        (0xFEE00000 | ((cpu) << 12))
#define PCI_MSI_MDR(vec)        (0x00004000 | (vec))

#ifdef _KERNEL

/* read configuration register `reg' of device `dev' */

extern int pci_read_conf(pcidev_t dev, int reg);

/* write configuration register `reg' of device `dev' */

extern void pci_write_conf(pcidev_t dev, int reg, int data);

/* route interrupts from `dev' to `irq' via message signaling */

extern void pci_enable_msi(pcidev_t dev, int irq);

#endif /* _KERNEL */


#endif /* _SYS_PCI_H */

/* vi: set ts=4 expandtab: */
