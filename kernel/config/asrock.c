/*****************************************************************************

   config/asrock.c                                            ux/64 kernel

*****************************************************************************/

#include <sys/apic.h>
#include <sys/clock.h>
#include <sys/proc.h>
#include <sys/boot.h>
#include <sys/ps2.h>
#include <sys/ide.h>
#include <sys/dev.h>
#include "config.h"

struct bdevsw bdevsw[NBLKDEV] =
{
    { ideinit,  idestrat,   ideflush,   nulldev,    nulldev }
};

struct cdevsw cdevsw[NCHRDEV] =
{
    { ps2init }
};

void (*isr[NIRQ])(int irq) =
{
    /*  0 */    pitisr,         /*  1 */    ps2isr,
    /*  2 */    0,              /*  3 */    0,
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
    /* 24 */    ideisr,         /* 25 */    0,
    /* 26 */    0,              /* 27 */    0,
    /* 28 */    0,              /* 29 */    ipiisr,
    /* 30 */    tmrisr
};

/* vi: set ts=4 expandtab: */
