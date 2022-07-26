/*****************************************************************************

  tcgetattr.c                                       tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <termios.h>
#include <sys/ioctl.h>

int tcgetattr(int fd, struct termios *termios_p)
{
    return ioctl(fd, TCGETS, termios_p);
}

/* vi: set ts=4 expandtab: */
