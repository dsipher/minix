/*****************************************************************************

   qemu.h                                                  jewel/os kernel

*****************************************************************************/

#ifndef CONFIG_H
#define CONFIG_H

#define NPROC       128
#define NBUF        8192
#define NMBUF       1024

/* QEMU used for development
   (as configured in qemu.sh) */

#define CONFIG      "QEMU"
#define NCPU        2

#define KBD_IRQ     1
#define PIT_IRQ     2
#define IPI_IRQ     29
#define TMR_IRQ     30

#endif /* CONFIG_H */

/* vi: set ts=4 expandtab: */
