/*****************************************************************************

   config/asrock.h                                            minix kernel

*****************************************************************************/

#ifndef CONFIG_H
#define CONFIG_H

/* ASRock NetTop ION 330 */

#define NMOUNT      4
#define NPROC       128
#define NBUF        8192
#define NBUFQ       512
#define NMBUF       1024
#define NINODE      4096
#define NINODEQ     256
#define CONFIG      "ASROCK"
#define NCPU        4

#define PIT_IRQ     0
#define KBD_IRQ     1
#define IPI_IRQ     29
#define TMR_IRQ     30

#define NBLKDEV     1
#define NCHRDEV     1

/* MCP79 SATA native-only controller at
   00:0b.0. BIOS set for IDE (not AHCI) */

#define IDE_BDF     PCI_DEV(0, 11, 0)

#define IDE_IRQA    24                      /* shared .. */
#define IDE_IRQB    IDE_IRQA                /* .. MSI IRQ */

#endif /* CONFIG_H */

/* vi: set ts=4 expandtab: */
