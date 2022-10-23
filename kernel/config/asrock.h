/*****************************************************************************

   config/asrock.h                                            ux/64 kernel

*****************************************************************************/

#ifndef CONFIG_H
#define CONFIG_H

#define NPROC       128
#define NBUF        8192
#define NMBUF       1024

/* ASRock NetTop ION 330 (ATOM 330, Nvidia ION chipset) */

#define CONFIG      "ASROCK"
#define NCPU        4

#define PIT_IRQ     0
#define KBD_IRQ     1
#define IPI_IRQ     29
#define TMR_IRQ     30

#endif /* CONFIG_H */

/* vi: set ts=4 expandtab: */
