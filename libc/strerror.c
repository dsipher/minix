/*****************************************************************************

  strerror.c                                        tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <string.h>

static const char * const errors[] =
{
    /*  0 */    "no error",
    /*  1 */    0,
    /*  2 */    0,
    /*  3 */    0,
    /*  4 */    0,
    /*  5 */    0,
    /*  6 */    0,
    /*  7 */    0,
    /*  8 */    0,
    /*  9 */    0,
    /* 10 */    0,
    /* 11 */    0,
    /* 12 */    "out of memory",                            /* ENOMEM */
    /* 13 */    0,
    /* 14 */    0,
    /* 15 */    0,
    /* 16 */    0,
    /* 17 */    0,
    /* 18 */    0,
    /* 19 */    0,
    /* 20 */    0,
    /* 21 */    0,
    /* 22 */    0,
    /* 23 */    0,
    /* 24 */    0,
    /* 25 */    "not a typewriter",                         /* ENOTTY */
    /* 26 */    0,
    /* 27 */    0,
    /* 28 */    0,
    /* 29 */    0,
    /* 30 */    0,
    /* 31 */    0,
    /* 32 */    0,
    /* 33 */    "math argument out of domain of func",      /* EDOM */
    /* 34 */    "math result not representable"             /* ERANGE */
};

#define NR_ERRORS (sizeof(errors) / sizeof(*errors))

char *strerror(int errno)
{
    if ((errno < 0) || (errno >= NR_ERRORS) || (errors[errno] == 0))
        return "unknown error";
    else
        return (char *) errors[errno];
}

/* vi: set ts=4 expandtab: */
