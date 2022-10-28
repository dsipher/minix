/*****************************************************************************

   sys/pci.h                                           ux/64 system header

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
#define PCI_STAT_CAPS           0x00000010      /* capabilities present */

/* PCI_CONF_CLASS */

#define PCI_CLASS(x)            (0xFF000000 & (x))      /* device class */
#define PCI_SBCLS(x)            (0x00FF0000 & (x))      /* device subclass */

#define PCI_CLASS_STORAGE       0x01000000              /* mass storage */
#define PCI_SBCLS_IDE           0x00010000              /* IDE controller */


#ifdef _KERNEL

/* read configuration register `reg' of device `dev' */

extern int pci_read_conf(pcidev_t dev, int reg);

/* write configuration register `reg' of device `dev' */

extern void pci_write_conf(pcidev_t dev, int reg, int data);

#endif /* _KERNEL */


#endif /* _SYS_PCI_H */

/* vi: set ts=4 expandtab: */
