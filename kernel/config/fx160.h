/*****************************************************************************

   config/fx160.h                                             ux/64 kernel

*****************************************************************************/

#ifndef CONFIG_H
#define CONFIG_H

/* Dell Optiplex FX160 (SiS chipset). these can be equipped with either
   an ATOM 230 or a 330; to be safe we must choose NCPU == 2, which works
   for either. change and recompile to enable additional ATOM 330 cores. */

#define NMOUNT      4
#define NPROC       128
#define NBUF        8192
#define NBUFQ       512
#define NMBUF       1024
#define NINODE      4096
#define NINODEQ     256
#define CONFIG      "FX160"
#define NCPU        2

#define KBD_IRQ     1
#define PIT_IRQ     2
#define IPI_IRQ     29
#define TMR_IRQ     30

#define NBLKDEV     1
#define NCHRDEV     1

/* SiS SATA native-only controller at
   00:05.0. BIOS set for ATA (not AHCI) */

#define IDE_BDF     PCI_DEV(0, 5, 0)

#define IDE_IRQA    17                      /* shared .. */
#define IDE_IRQB    IDE_IRQA                /* .. PCI IRQ */

#endif /* CONFIG_H */

/* vi: set ts=4 expandtab: */
