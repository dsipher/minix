/*****************************************************************************

   pci.c                                                      minix kernel

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

#include <sys/pci.h>
#include <sys/io.h>
#include <sys/spin.h>
#include <sys/apic.h>
#include <sys/log.h>

/* protects access to PCI configuration space */

static spinlock_t pci_lock;


int pci_read_conf(pcidev_t dev, int reg)
{
    int data;

    acquire(&pci_lock);

    OUTL(PCI_ADDR, PCI_ADDR_REG(dev, reg));
    data = INL(PCI_DATA);

    release(&pci_lock);
    return data;
}

void pci_write_conf(pcidev_t dev, int reg, int data)
{
    acquire(&pci_lock);

    OUTL(PCI_ADDR, PCI_ADDR_REG(dev, reg));
    OUTL(PCI_DATA, data);

    release(&pci_lock);
}

/* traverse the capabilities list to find the MSI MAR and MDR, and stuff
   them accordingly. we panic if we don't find everything in order. */

void pci_enable_msi(pcidev_t dev, int irq)
{
    unsigned index;
    unsigned config;

    config = pci_read_conf(dev, PCI_CONF_CMDSTAT);
    if ((config & PCI_STAT_CAPS) == 0) goto panic;

    config = pci_read_conf(dev, PCI_CONF_CAPS);
    index = PCI_CAPS_FIRST(config);

    while (index)
    {
        config = pci_read_conf(dev, index);

        if (PCI_CAP_ID(config) == PCI_MSI_CAP)
        {
            unsigned mar = PCI_MSI_MAR(0); /* BSP */
            unsigned mdr = PCI_MSI_MDR(VECTOR(irq));

            if (config & PCI_MSI_CAP_64BIT)
            {
                pci_write_conf(dev, index + PCI_MSI64_MARL, mar);
                pci_write_conf(dev, index + PCI_MSI64_MARH, 0);
                pci_write_conf(dev, index + PCI_MSI64_MDR, mdr);
            } else {
                pci_write_conf(dev, index + PCI_MSI32_MAR, mar);
                pci_write_conf(dev, index + PCI_MSI32_MDR, mdr);
            }

            config |= PCI_MSI_CAP_EN;
            pci_write_conf(dev, index, config);
            return; /* success */
        }

        index = PCI_CAP_NEXT(config);
    }

panic:
    panic("msi");
}

/* vi: set ts=4 expandtab: */
