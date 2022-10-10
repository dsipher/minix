/*****************************************************************************

   config/vbox.h                                           jewel/os kernel

*****************************************************************************/

#ifndef CONFIG_H
#define CONFIG_H

#define NPROC       128
#define NBUF        8192
#define NMBUF       1024

/* virtualbox used for development:

   2 CPUs, PIIX3 chipset (w/ PIIX3 PCI IDE),
   PS/2 mouse, bridged AM79C970A Ethernet */

#define CONFIG      "VBOX"
#define NCPU        2

#define KBD_IRQ     1
#define PIT_IRQ     2
#define IPI_IRQ     29
#define TMR_IRQ     30

#endif /* CONFIG_H */

/* vi: set ts=4 expandtab: */
