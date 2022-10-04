/*****************************************************************************

   config/qemu.c                                           jewel/os kernel

*****************************************************************************/

#include <sys/apic.h>
#include <sys/clock.h>
#include <sys/proc.h>
#include "config.h"

void (*isr[NIRQ])(int irq) =
{
    /*  0 */    0,              /*  1 */    0,
    /*  2 */    pitisr,         /*  3 */    0,
    /*  4 */    0,              /*  5 */    0,
    /*  6 */    0,              /*  7 */    0,
    /*  8 */    0,              /*  9 */    0,
    /* 10 */    0,              /* 11 */    0,
    /* 12 */    0,              /* 13 */    0,
    /* 14 */    0,              /* 15 */    0,
    /* 16 */    0,              /* 17 */    0,
    /* 18 */    0,              /* 19 */    0,
    /* 20 */    0,              /* 21 */    0,
    /* 22 */    0,              /* 23 */    0,
    /* 24 */    0,              /* 25 */    0,
    /* 26 */    0,              /* 27 */    0,
    /* 28 */    0,              /* 29 */    ipiisr,
    /* 30 */    tmrisr
};

/* vi: set ts=4 expandtab: */
