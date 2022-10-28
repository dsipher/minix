/*****************************************************************************

   config/fx160.h                                             ux/64 kernel

*****************************************************************************/

#ifndef CONFIG_H
#define CONFIG_H

#define NPROC       128
#define NBUF        8192
#define NMBUF       1024

/* Dell Optiplex FX160 (SiS chipset). these can be equipped with either
   an ATOM 230 or a 330; to be safe we must choose NCPU == 2, which works
   for either. change and recompile to enable additional ATOM 330 cores. */

#define CONFIG      "FX160"
#define NCPU        2

#define KBD_IRQ     1
#define PIT_IRQ     2
#define IPI_IRQ     29
#define TMR_IRQ     30

#endif /* CONFIG_H */

/* vi: set ts=4 expandtab: */
