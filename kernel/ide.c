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
#include <errno.h>
#include "config.h"

/* we wait at most IDENTIFY_TIMEOUT + 1 jiffies for an
   identify to complete, or we assume no disk present */

#define IDENTIFY_TIMEOUT        10      /* 1/10th of a second */

/* the number of times to try a block before giving up */

#define MAX_TRIES               3

/* an IDE device works in 512-byte sectors.
   the kernel of course works in 4k blocks */

#define SECTOR_SIZE             512
#define SECTORS_PER_BLOCK       (FS_BLOCK_SIZE / SECTOR_SIZE)
#define BLOCK_TO_SECTOR(d)      (((long) (d)) * SECTORS_PER_BLOCK)

/* true if LBA28 is insufficient to address sector `s' */

#define USE_LBA48(s)            ((s) >= (1 << 28))

/* a PCI IDE controller has two [mostly] independent
   channels, and at most two devices per channel. */

#define NR_CHANNELS             2
#define DEVS_PER_CHANNEL        2

struct channel
{
    unsigned short  base;   /* base port of main i/o region */
    unsigned short  dma;    /* base port of busmastering region */
    unsigned short  ctrl;   /* control port (alt status/interrupts) */

    unsigned char   state;  /* current FSM state (STATE_*) */
    unsigned char   flags;  /* driver status flags (FLAG_*) */

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

    union
    {
        long dummy;

        struct
        {
            unsigned addr;       /* address of buffer data */
            unsigned count;      /* count (and terminator) */
        };
    } prd;
};

static struct channel channel[NR_CHANNELS];

/* protects global data channel[] and
   access to the controller itself */

static spinlock_t ide_lock;

/* states of the finite state machine */

#define STATE_IDLE      0           /* waiting for work */
#define STATE_IO        1           /* doing i/o on head of requestq */
#define STATE_SYNC      2           /* syncing write of head of requestq */
#define STATE_FLUSH     3           /* performing flush */

/* channel flags */

#define FLAG_FLUSH0     0x01        /* device 0 needs flush */
#define FLAG_FLUSH1     0x02        /* device 1 needs flash */

#define FLAG_FLUSH      (FLAG_FLUSH0 | FLAG_FLUSH1)

/* we map minors to devices in a straightforward manner: bit[1] is
   the controller, bit[0] the dev on the controller (0 == master).
   CHANNEL() and DEVICE() work on both full dev_t and pure minors.

   note that CHANNEL() and DEVICE() will always evaluate to value
   values, since we only ever examine bits[1:0]. they wrap around. */

#define NR_MINORS           (NR_CHANNELS * DEVS_PER_CHANNEL)
#define CHANNEL(dev)        (((dev) >> 1) & 1)
#define DEVICE(dev)         ((dev) & 1)

/* bits set in the PCI class configuration register
   when the specified channel is in native PCI mode */

#define PIF_0               0x00000100      /* primary */
#define PIF_1               0x00000400      /* secondary */

/* base i/o ports (offsets from channel.base) */

#define BASE_DATA           0       /* 16-bit data window */
#define BASE_ERRFEAT        1       /* feature (w) or error (r) */
#define BASE_COUNT          2       /* sector count */
#define BASE_LBALO          3       /* lba[7:0] */
#define BASE_LBAMD          4       /* lba[15:8] */
#define BASE_LBAHI          5       /* lba[23:16] */
#define BASE_DRVHD          6       /* drive, head, lba[27:24] */
#define BASE_CMDSTAT        7       /* command (w) or status (r) */

/* bits in BASE_CMDSTAT */

#define BASE_STAT_ERR       0x01    /* error */
#define BASE_STAT_DRQ       0x08    /* data request */
#define BASE_STAT_RDY       0x40    /* drive ready */
#define BASE_STAT_BSY       0x80    /* drive busy */

/* commands for BASE_CMDSTAT */

#define BASE_CMD_READ28     0xC8    /* read dma (28-bit) */
#define BASE_CMD_READ48     0x25    /* ........ (48-bit) */
#define BASE_CMD_WRITE28    0xCA    /* write dma (28-bit) */
#define BASE_CMD_WRITE48    0x35    /* ......... (48-bit) */

#define BASE_CMD_IDENTIFY   0xEC    /* identify device */
#define BASE_CMD_FLUSH      0xE7    /* flush cached writes to medium */

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

/* compute the BASE_DRVHD value given a dev_t
   (or just the minor). bit 6 enables LBA */

#define DEVSEL(dev)         (0x40 | (((dev) & 1) << 4))

/* i/o ports (offsets from channel.dma) */

#define DMA_CMD             0           /* bus master command register */
#define DMA_STAT            2           /* bus master status register */
#define DMA_PRD             4           /* bus master PRD base address */

/* bits in the DMA_CMD register */

#define DMA_CMD_START       0x01        /* start/stop bit */
#define DMA_CMD_DIR         0x08        /* dma direction bit */

/* ........... DMA_STAT register */

#define DMA_STAT_INTR       0x04        /* device interrupt */
#define DMA_STAT_ERROR      0x02        /* dma error */
#define DMA_STAT_ACTIVE     0x01        /* transfer active */

/* attempt to IDENTIFY DEVICE associated with `dev'. print some pretty
   messages for the user. on success, the size[] entry for `dev' on the
   appropriate channel will be set accordingly. per our usual arrangement,
   we assume the BIOS has left the drive in a reasonable state. */

static void
identify(dev_t dev)
{
    struct channel *chanp;      /* handle to channel */
    unsigned short *ident;      /* identification sector */
    long timeout;               /* deadline for timeout */
    int base;                   /* base i/o of controller */
    unsigned long blocks;       /* computed size in blocks */

    chanp = &channel[CHANNEL(dev)];
    base = chanp->base;

    OUTB(base + BASE_DRVHD, DEVSEL(dev));
    OUTB(base + BASE_CMDSTAT, BASE_CMD_IDENTIFY);

    /* look for an ATAPI signature. we don't do ATAPI (yet?) */

    if (    INB(base + BASE_COUNT) == ATAPI_SIG_COUNT
         && INB(base + BASE_LBALO) == ATAPI_SIG_LBALO
         && INB(base + BASE_LBAMD) == ATAPI_SIG_LBAMD
         && INB(base + BASE_LBAHI) == ATAPI_SIG_LBAHI) return;

    /* IDENTIFY is always a PIO-mode command: we poll for the data. a drive
       should de-assert BSY and assert DRQ when the data is ready. if this
       doesn't happen in a reasonable time, then it's wedged or not there. */

    timeout = jiffies + IDENTIFY_TIMEOUT + 1;

    while (jiffies < timeout && (INB(base + BASE_CMDSTAT) & BASE_STAT_BSY)) ;
    while (jiffies < timeout && !(INB(base + BASE_CMDSTAT) & BASE_STAT_DRQ)) ;

    if (jiffies >= timeout || (INB(base + BASE_CMDSTAT) & BASE_STAT_ERR))
        return; /* error, not present, or not responding */

    /* read the identification sector data -> ident[] */

    ident = (unsigned short *) pgall(0);
    if (ident == 0) panic("ide ident");

    INSW(base + BASE_DATA, ident, SECTOR_SIZE / 2);

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
    chanp->size[DEVICE(dev)] = blocks;
    printf(" %u blocks\n", blocks);
}

/* probe the channel for error conditions. if an error occurred,
   log a message, reporting the error on block `bp' if supplied.
   if `dma' is non-zero will also check for busmastering errors.
   returns an appropriate value for errno (EIO or 0 on success). */

static int  /* held: ide_lock */
chkerr(int c, struct buf *bp, int dma, char *note)
{
    struct channel *chanp;
    int errno = 0;
    int status;

    chanp = &channel[c];

    if (         (INB(chanp->base + BASE_CMDSTAT) & BASE_STAT_ERR)
      || (dma && (INB(chanp->dma  + DMA_STAT)     & DMA_STAT_ERROR)))
    {
        status = INB(chanp->base + BASE_ERRFEAT);
        errno = EIO;

        if (bp)
            printf("ide %d.%d %s error, blkno %u, status = %x\n",
                    c, DEVICE(bp->b_dev), note, bp->b_blkno, status);
        else
            printf("ide %d %s error, status = %x\n", c, note, status);
    }

    return errno;
}

/* prepare `chanp' for dma of `len' bytes to/from `buffer'. */

#define PREPARE_DMA(chanp, buffer, len)        /* held: ide_lock */         \
    do {                                                                    \
        (chanp)->prd.addr = VTOP((caddr_t) (buffer));                       \
        (chanp)->prd.count = 0x80000000 | (len);                            \
        OUTL((chanp)->dma + DMA_PRD, (int) &chanp->prd);                    \
        OUTB((chanp)->dma + DMA_STAT, DMA_STAT_ERROR | DMA_STAT_INTR);      \
    } while (0)

/* engage DMA on `chanp'. if `read' is true,
   the direction is from to disk to memory. */

#define ENGAGE_DMA(chanp, read)                /* held: ide_lock */         \
    do {                                                                    \
        OUTB((chanp)->dma + DMA_CMD,                                        \
             DMA_CMD_START | ((read) ? DMA_CMD_DIR : 0));                   \
    } while (0)

/* disengage DMA on `chanp' */

#define DISENGAGE_DMA(chanp)                   /* held: ide_lock */         \
    do {                                                                    \
        OUTB((chanp)->dma + DMA_CMD, 0);                                    \
    } while (0)

/* initialize the struct for channel `c' by probing
   the PCI configuration space starting at BAR `bar'.
   `dmaofs' is the offset into the bus mastering i/o
   region for this channel, and `pif' is one of the
   PIF_* constants above associated with this channel */

static void
init(int c, int bar, int dmaofs, int pif)
{
    struct channel *chanp = &channel[c];

    TAILQ_INIT(&chanp->requestq);

    /* if the channel is in native mode, then we
       must read its i/o windows out of the BARs.
       (otherwise leave defaults set by ideinit). */

    if (pci_read_conf(IDE_BDF, PCI_CONF_CLASS) & pif)
    {
        chanp->base = PCI_BAR(pci_read_conf(IDE_BDF, bar));
        chanp->ctrl = PCI_BAR(pci_read_conf(IDE_BDF, bar + 1)) + 2;
    }

    /* the bus mastering i/o base is always in BAR4 */

    chanp->dma = PCI_BAR(pci_read_conf(IDE_BDF, PCI_CONF_BAR4)) + dmaofs;
}

/* inspect the state of channel `c' to see if it's
   time to take action and transition to a new state */

static void
advance(int c)      /* held: ide_lock */
{
    struct channel *chanp = &channel[c];
    struct buf *bp;
    int errno;

again:
    switch (chanp->state)
    {
    case STATE_IDLE:    /*************************************** IDLE ***/

        /* the controller is idle, so look for something to do.
           we do only two kinds of work: buf i/o and flushing.
           a flush take priority over i/o requests, otherwise
           we could place no bound on the its completion time */

        if (chanp->flags & FLAG_FLUSH)
        {
            if (chanp->flags & FLAG_FLUSH0) {
                chanp->flags &= ~FLAG_FLUSH0;
                OUTB(chanp->base + BASE_DRVHD, DEVSEL(0));
            } else {
                chanp->flags &= ~FLAG_FLUSH1;
                OUTB(chanp->base + BASE_DRVHD, DEVSEL(1));
            }

            OUTB(chanp->base + BASE_CMDSTAT, BASE_CMD_FLUSH);
            chanp->state = STATE_FLUSH;
        } else if (bp = TAILQ_FIRST(&chanp->requestq)) {
            /* start a new i/o request. */

            int cmd28, cmd48;
            long sector;

            PREPARE_DMA(chanp, bp->b_data, FS_BLOCK_SIZE);
            sector = BLOCK_TO_SECTOR(bp->b_blkno);

            cmd28 = (bp->b_flags & B_READ) ? BASE_CMD_READ28
                                           : BASE_CMD_WRITE28;

            cmd48 = (bp->b_flags & B_READ) ? BASE_CMD_READ48
                                           : BASE_CMD_WRITE48;

            if (USE_LBA48(sector)) {
                OUTB(chanp->base + BASE_DRVHD, DEVSEL(bp->b_dev));
                OUTB(chanp->base + BASE_COUNT, 0);
                OUTB(chanp->base + BASE_LBALO, sector >> 24);
                OUTB(chanp->base + BASE_LBAMD, sector >> 32);
                OUTB(chanp->base + BASE_LBAHI, sector >> 40);
                OUTB(chanp->base + BASE_COUNT, SECTORS_PER_BLOCK);
                OUTB(chanp->base + BASE_LBALO, sector);
                OUTB(chanp->base + BASE_LBAMD, sector >> 8);
                OUTB(chanp->base + BASE_LBAHI, sector >> 16);
                OUTB(chanp->base + BASE_CMDSTAT, cmd48);
            } else {
                OUTB(chanp->base + BASE_DRVHD, DEVSEL(bp->b_dev)
                                               | ((sector >> 24) & 0x0F));

                OUTB(chanp->base + BASE_COUNT, SECTORS_PER_BLOCK);
                OUTB(chanp->base + BASE_LBALO, sector);
                OUTB(chanp->base + BASE_LBAMD, sector >> 8);
                OUTB(chanp->base + BASE_LBAHI, sector >> 16);
                OUTB(chanp->base + BASE_CMDSTAT, cmd28);
            }

            ENGAGE_DMA(chanp, (bp->b_flags & B_READ));
            chanp->state = STATE_IO;
        }

        break;

    case STATE_IO:      /***************************************** IO ***/

        /* the I/O request is complete if the drive has
           interrupted (as reported by the DMA logic) */

        if (INB(chanp->dma + DMA_STAT) & DMA_STAT_INTR) {
            DISENGAGE_DMA(chanp);
            bp = TAILQ_FIRST(&chanp->requestq);

            errno = chkerr(CHANNEL(bp->b_dev), bp, 1,
                           bp->b_flags & B_READ ? "read" : "write");

            /* try an operation up to MAX_TRIES times. we take no
               corrective action on error; maybe we should (reset?) */

            if (errno && ++bp->b_errcnt < MAX_TRIES)
            {
                chanp->state = STATE_IDLE;
                goto again; /* try bp again */
            }

            /* if we didn't successfully complete a write, there's
               no point in trying to flush it to the medium... */

            if (errno) bp->b_flags &= ~B_SYNC;

            if (bp->b_flags & B_SYNC) {
                /* this block is synchronous, so we must ensure it's
                   flushed to the medium before we can report it done */

                OUTB(chanp->base + BASE_DRVHD, DEVSEL(bp->b_dev));
                OUTB(chanp->base + BASE_CMDSTAT, BASE_CMD_FLUSH);
                chanp->state = STATE_SYNC;
            } else {
                /* the usual case. i/o is complete, remove it from
                   the queue and return it to the buf i/o system */

                TAILQ_REMOVE(&chanp->requestq, bp, b_avail_links);
                chanp->state = STATE_IDLE;
                release(&ide_lock);
                iodone(bp, errno);
                acquire(&ide_lock);
                goto again;
            }
        }

        break;

    case STATE_SYNC:    /*************************************** SYNC ***/
    case STATE_FLUSH:   /************************************** FLUSH ***/

        /* BASE_CMD_FLUSH is complete once the BSY bit is clear */

        if (INB(chanp->base + BASE_CMDSTAT) & BASE_STAT_BSY)
            break;

        /* the only difference between SYNC and FLUSH is that the former
           is done on behalf of a specific buffer write, whereas a FLUSH
           is a general flush. we check for errors and log them, but do
           not attach them to `bp' (if we have one) because we can't be
           certain `bp' is the block which caused the error. we also do
           not retry; chances are another flush request will come soon. */

        bp = 0;
        chkerr(c, 0, 0, "flush");

        if (chanp->state == STATE_SYNC) {
            bp = TAILQ_FIRST(&chanp->requestq);
            TAILQ_REMOVE(&chanp->requestq, bp, b_avail_links);
        }

        chanp->state = STATE_IDLE;
        release(&ide_lock);
        if (bp) iodone(bp, 0);
        acquire(&ide_lock);
        goto again;
    }
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

/* read the status registers; this silences device interrupts and
   flushes posted memory writes. then try to advance the FSMs. */

void
ideisr(int irq)
{
    acquire(&ide_lock);

    INB(channel[0].base + BASE_CMDSTAT);
    INB(channel[1].base + BASE_CMDSTAT);
    advance(0); advance(1);

    release(&ide_lock);
}

/* check to see that the device is present and
   the block in bounds, then queue the request. */

void
idestrategy(struct buf *bp)
{
    int c                   = CHANNEL(bp->b_dev);
    struct channel *chanp   = &channel[c];
    daddr_t size            = chanp->size[DEVICE(bp->b_dev)];

    if (size == 0)
        iodone(bp, ENODEV);
    else if (bp->b_blkno >= size)
        iodone(bp, ENXIO);
    else {
        acquire(&ide_lock);
        TAILQ_INSERT_TAIL(&chanp->requestq, bp, b_avail_links);
        advance(c);
        release(&ide_lock);
    }
}

void
ideflush(void)
{
    acquire(&ide_lock);
    channel[0].flags |= FLAG_FLUSH; advance(0);
    channel[1].flags |= FLAG_FLUSH; advance(1);
    release(&ide_lock);
}

/* vi: set ts=4 expandtab: */
