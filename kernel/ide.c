/*****************************************************************************

   ide.c                                                      ux/64 kernel

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
#include <sys/ide.h>
#include <sys/spin.h>
#include <sys/log.h>
#include <sys/buf.h>
#include <sys/io.h>
#include <sys/apic.h>
#include <sys/clock.h>
#include <sys/page.h>
#include <sys/fs.h>
#include "config.h"

/* we wait at most TIMEOUT + 1 seconds for a
   command to complete, or we call it an error */

#define TIMEOUT             1

/* an IDE device works in 512-byte sectors */

#define SECTOR_SIZE         512

/* a PCI IDE controller has two [mostly] independent
   channels, and at most two devices per channel. */

#define NR_IDE_CHANNELS     2
#define DEVS_PER_CHANNEL    2

struct ide_channel
{
    unsigned short base;    /* base port of main i/o region */
    unsigned short dma;     /* base port of busmastering region */
    unsigned short ctrl;    /* control port (alt status/interrupts) */
    unsigned short flags;   /* see CHANNEL_F_* below */

    /* at startup, we probe the bus and populate the size
       for each device. if size == 0, then the device is
       either not present or it's unsupported. (n.b.: the
       the size is in ux/64 blocks, not sectors, so a disk
       whose size is not a multiple of 4k is truncated.) */

    daddr_t size[DEVS_PER_CHANNEL];

    /* requests pending for this channel. the request
       in progress, if any, is at the head of the q */

    struct bufq requestq;

    /* physical region descriptor for DMA. since there is at most one
       request in progress per channel, we only need one of these. per
       the spec, a PRD can't cross a 64k boundary, so we use the dummy
       field to force quadword alignment, which achieves the same */

    struct
    {
        long dummy;

        union
        {
            unsigned addr;       /* address of buffer data */
            unsigned count;      /* count (and terminator) */
        };
    } prd;
};

static struct ide_channel channel[NR_IDE_CHANNELS];

/* protects global data channel[] and
   access to the controller itself */

static spinlock_t ide_lock;

/* channel flags. BUSY and WANTED have the semantics they
   do just about everywhere else (e.g., the buffer cache) */

#define CHANNEL_F_BUSY      0x0001      /* channel is in use */
#define CHANNEL_F_WANTED    0x0002      /* someone wants channel */

/* we map minors to devices in a straightforward manner: bit[1] is
   the controller, bit[0] the dev on the controller (0 == master).
   CHANNEL() and DEVICE() work on both full dev_t and pure minors. */

#define NR_MINORS           (NR_IDE_CHANNELS * DEVS_PER_CHANNEL)
#define CHANNEL(dev)        (((dev) >> 1) & 1)
#define DEVICE(dev)         ((dev) & 1)

/* bits set in the PCI class configuration register
   when the specified channel is in native PCI mode */

#define PIF_0               0x00000100      /* primary */
#define PIF_1               0x00000400      /* secondary */

/* i/o ports (offsets from channel->base) */

#define IDE_BASE_DATA       0       /* 16-bit data window */
#define IDE_BASE_ERRFEAT    1       /* feature (w) or error (r) */
#define IDE_BASE_COUNT      2       /* sector count */
#define IDE_BASE_LBALO      3       /* lba[7:0] */
#define IDE_BASE_LBAMD      4       /* lba[15:8] */
#define IDE_BASE_LBAHI      5       /* lba[23:16] */
#define IDE_BASE_DRVHD      6       /* drive, head, lba[27:24] */
#define IDE_BASE_CMDSTAT    7       /* command (w) or status (r) */

/* bits in IDE_BASE_CMDSTAT */

#define IDE_STAT_ERR        0x01    /* error */
#define IDE_STAT_DRQ        0x08    /* data request */
#define IDE_STAT_RDY        0x40    /* drive ready */
#define IDE_STAT_BSY        0x80    /* drive busy */

/* commands for IDE_BASE_CMDSTAT */

#define IDE_CMD_IDENTIFY    0xEC    /* identify device */

/* offsets into the IDENTIFY DEVICE buffer */

#define IDENT_MODEL         26      /* 40 bytes: model string */

#define IDENT_SIZE28        60      /* 2 words: LBA28 sector count */
#define IDENT_FEATURES      86      /* 1 word: command set/features */
#define IDENT_SIZE48        100     /* 4 words: LBA48 sector count */

#define MODEL_LEN           40      /* length (in bytes) of IDENT_MODEL */
#define FEATURE_LBA48       0x400   /* in IDENT_FEATURES if LBA48 supported */

/* an ATAPI device will put these magic values in the
   indicated registers when we try IDENTIFY DEVICE */

#define ATAPI_SIG_COUNT     0x01
#define ATAPI_SIG_LBALO     0x01
#define ATAPI_SIG_LBAMD     0x14
#define ATAPI_SIG_LBAHI     0xEB

/* compute the DEV bit for IDE_BASE_DRVHD
   given a dev_t (or just the minor) */

#define DEVSEL(dev)         (((dev) & 1) << 4)

/* attempt to IDENTIFY DEVICE associated with `dev'. print some pretty
   messages for the user. on success, the size[] entry for `dev' on the
   appropriate channel will be set accordingly. per our usual arrangement,
   we assume the BIOS has left the drive in a reasonable state. */

static void
identify(dev_t dev)
{
    struct ide_channel *chan;   /* handle to channel */
    unsigned short *ident;      /* identification sector */
    time_t timeout;             /* deadline for timeout */
    int base;                   /* base i/o of controller */
    unsigned long blocks;       /* computed size in blocks */

    chan = &channel[CHANNEL(dev)];
    base = chan->base;

    OUTB(base + IDE_BASE_DRVHD, DEVSEL(dev));
    OUTB(base + IDE_BASE_CMDSTAT, IDE_CMD_IDENTIFY);

    /* look for an ATAPI signature. we don't do ATAPI (yet?) */

    if (    INB(base + IDE_BASE_COUNT) == ATAPI_SIG_COUNT
         && INB(base + IDE_BASE_LBALO) == ATAPI_SIG_LBALO
         && INB(base + IDE_BASE_LBAMD) == ATAPI_SIG_LBAMD
         && INB(base + IDE_BASE_LBAHI) == ATAPI_SIG_LBAHI) return;

    /* IDENTIFY is always a PIO-mode command: we poll for the data. a drive
       should de-assert BUSY and assert DRQ when the data is ready. if this
       doesn't happen in a reasonable time, then it's wedged or not there. */

    timeout = time + TIMEOUT + 1;

    while (time < timeout && (INB(base + IDE_BASE_CMDSTAT) & IDE_STAT_BSY)) ;
    while (time < timeout && !(INB(base + IDE_BASE_CMDSTAT) & IDE_STAT_DRQ)) ;

    if (time >= timeout || (INB(base + IDE_BASE_CMDSTAT) & IDE_STAT_ERR))
        return; /* error, not present, or not responding */

    /* read the identification sector data -> ident[] */

    ident = (unsigned short *) pgall(0);
    if (ident == 0) panic("ide ident");

    INSW(base + IDE_BASE_DATA, ident, SECTOR_SIZE / 2);

    /* print the disk model string for the user */

    printf("ide %d.%d: ", CHANNEL(dev), DEVICE(dev));

    {
        char *cp = (char *) &ident[IDENT_MODEL];
        int i;

        for (i = 0; i < MODEL_LEN; i += 2, cp += 2)
            printf("%c%c", cp[1], cp[0]);
    }

    /* and compute the size. this can be
       in one of two places, depending on
       whether the disk supports LBA-48. */

    if (ident[IDENT_FEATURES] & FEATURE_LBA48) {
        printf("   LBA48");
        blocks = * (unsigned long *) &ident[IDENT_SIZE48];
    } else {
        printf("   LBA28");
        blocks = * (unsigned int *) &ident[IDENT_SIZE28];
    }

    pgfree((caddr_t) ident);

    blocks /= FS_BLOCK_SIZE / SECTOR_SIZE;
    chan->size[DEVICE(dev)] = blocks;
    printf(" %u blocks\n", chan->size[DEVICE(dev)]);
}

/* initialize the struct for channel `c' by probing
   the PCI configuration space starting at BAR `bar'.
   `dmaofs' is the offset into the bus mastering i/o
   region for this channel, and `pif' is one of the
   PIF_* constants above associated with this channel */

static void
init(int c, int bar, int dmaofs, int pif)
{
    struct ide_channel *chan = &channel[c];

    TAILQ_INIT(&chan->requestq);

    /* if the channel is in native mode, then we
       must read its i/o windows out of the BARs.
       (otherwise leave defaults set by ideinit). */

    if (pci_read_conf(IDE_BDF, PCI_CONF_CLASS) & pif)
    {
        chan->base = PCI_BAR(pci_read_conf(IDE_BDF, bar));
        chan->ctrl = PCI_BAR(pci_read_conf(IDE_BDF, bar + 1)) + 2;
    }

    /* the bus mastering i/o base is always in BAR4 */

    chan->dma = PCI_BAR(pci_read_conf(IDE_BDF, PCI_CONF_BAR4)) + dmaofs;
}

/* configure the controller as a busmaster, find its channels'
   i/o ports, then probe the channels to find attached disks.

   as usual, since this is an initialization routine (called after
   multitasking enabled, but as the sole non-idle process), we do
   not bother trying to synchronize via the ide_lock. */

void
ideinit(void)
{
    int config;
    int i;

    /* sanity check: the bus/device/function specified by the
       configuration must be a mass-storage IDE controller */

    config = pci_read_conf(IDE_BDF, PCI_CONF_CLASS);

    if ( PCI_CLASS(config) != PCI_CLASS_STORAGE
      || PCI_SBCLS(config) != PCI_SBCLS_IDE ) panic("ide class");

    /* enable busmastering, and make sure it sticks */

    config = pci_read_conf(IDE_BDF, PCI_CONF_CMDSTAT);
    config |= PCI_CMD_BUSMASTER;
    pci_write_conf(IDE_BDF, PCI_CONF_CMDSTAT, config);
    config = pci_read_conf(IDE_BDF, PCI_CONF_CMDSTAT);
    if ((config & PCI_CMD_BUSMASTER) == 0) panic("ide master");

    /* looks good enough. read channel configs. we load default
       values in case the controller is in compatibility mode */

    channel[0].base = 0x1f0;            channel[1].base = 0x170;
    channel[0].ctrl = 0x3f6;            channel[1].ctrl = 0x176;
    init(0, PCI_CONF_BAR0, 0, PIF_0);   init(1, PCI_CONF_BAR2, 8, PIF_1);

    /* enable interrupts. a few different configurations here
       resulting in mini-spaghetti. (luckily it folds away.) */

    if (IOAPICIRQ(IDE_IRQA)) {
        enable(IDE_IRQA, 1);

        if (IDE_IRQB != IDE_IRQA)       /* in compatibility mode */
            enable(IDE_IRQB, 1);        /* there are two IRQs */
    } else
        pci_enable_msi(IDE_BDF, IDE_IRQA);

    /* probe the channels. the identify() procedure will
       trigger interrupts, but ideisr() will ignore them. */

    for (i = 0; i < NR_MINORS; ++i) identify(i);
    printf("\n");
}

void
ideisr(int irq)
{
    acquire(&ide_lock);

    /* read the status registers to silence device interrupts.
       this also serves to ensure all memory writes are posted. */

    INB(channel[0].base + IDE_BASE_CMDSTAT);
    INB(channel[1].base + IDE_BASE_CMDSTAT);

    /* XXX process interrupt! */

    release(&ide_lock);
}

/* vi: set ts=4 expandtab: */
