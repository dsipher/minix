/*****************************************************************************

  termios.h                                         tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _TERMIOS_H
#define _TERMIOS_H

typedef unsigned char cc_t;
typedef unsigned int speed_t;
typedef unsigned int tcflag_t;

#define NCCS 19

struct termios
{
    tcflag_t c_iflag;       /* input modes */
    tcflag_t c_oflag;       /* output modes */
    tcflag_t c_cflag;       /* control modes */
    tcflag_t c_lflag;       /* local modes */
    cc_t c_line;            /* line discipline */
    cc_t c_cc[NCCS];        /* control characters */
};

extern int tcgetattr(int, struct termios *);

#endif /* _TERMIOS_H */

/* vi: set ts=4 expandtab: */
