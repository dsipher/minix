/*****************************************************************************

  sys/mman.h                                        tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef _SYS_MMAN_H
#define _SYS_MMAN_H

#include <sys/tahoe.h>

extern void *mmap(void *addr, __size_t length, int prot,
                  int flags, int fd, __off_t offset);

#define PROT_NONE       0x00000000          /* prot */
#define PROT_READ       0x00000001
#define PROT_WRITE      0x00000002
#define PROT_EXEC       0x00000004

#define MAP_PRIVATE     0x00000002          /* flags */
#define MAP_FIXED       0x00000010
#define MAP_ANON        0x00000020

#define MAP_FAILED      ((void *) -1L)

#endif /* _SYS_MMAN_H */

/* vi: set ts=4 expandtab: */
