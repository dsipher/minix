/*****************************************************************************

  sys/ioctl.h                                       tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _SYS_IOCTL_H
#define _SYS_IOCTL_H

extern int ioctl(int, int, void *);

#define TCGETS  0x5401                  /* tcgetattr() */

#endif /* _SYS_IOCTL_H */

/* vi: set ts=4 expandtab: */
