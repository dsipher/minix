/*****************************************************************************

   config/vbox.h                                              ux/64 kernel

*****************************************************************************/

#ifndef CONFIG_H
#define CONFIG_H

/* virtualbox as configured for development */

#define NPROC       128
#define NBUF        8192
#define NBUFQ       512
#define NMBUF       1024
#define NINODE      4096
#define NINODEQ     256
#define CONFIG      "VBOX"
#define NCPU        2

#define KBD_IRQ     1
#define PIT_IRQ     2
#define IPI_IRQ     29
#define TMR_IRQ     30

#define NBLKDEV     1
#define NCHRDEV     1

/* PIIX3 PCI IDE controller at 00:01.1,
   running in ISA compatibility mode. */

#define IDE_BDF     PCI_DEV(0, 1, 1)

#define IDE_IRQA    14              /* primary channel ISA IRQ */
#define IDE_IRQB    15              /* secondary ............. */

#endif /* CONFIG_H */

/* vi: set ts=4 expandtab: */
