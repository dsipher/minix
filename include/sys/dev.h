/*****************************************************************************

   sys/dev.h                                           minix system header

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

#ifndef _SYS_DEV_H
#define _SYS_DEV_H

#include <sys/types.h>

struct buf; /* sys/buf.h */

#define NODEV   ((dev_t) -1)        /* a non-existent device */

/* to put in devsw entries that have nothing to do, or
   those which should produce an error when triggered.
   we purposely do not prototype these so the compiler
   will not look at the types (arguments) too closely. */

extern void nulldev();              /* no error */
extern void enodev();               /* raise ENODEV */

/* classic device switches: one for block devices (which can be
   mounted) and one for character devices (read: everything else) */

struct bdevsw
{
    /* boot-time driver initialization. called in the init process
       with multi-tasking running but before exec'ing /bin/init. */

    void    (*d_init)(void);

    /* the classic interface to the buffer cache. */

    void    (*d_strategy)(struct buf *bp);

    /* initiate flush of all device-cached writes to medium. */

    void    (*d_flush)(void);

    /* tell `dev' that `blkno' has been allocated or freed, respectively.
       provided for SSD devices so they can TRIM blocks if they wish. */

    void    (*d_alloc)(dev_t dev, daddr_t blkno);
    void    (*d_free)(dev_t dev, daddr_t blkno);
};

struct cdevsw
{
    void    (*d_init)(void);                    /* same as bdevsw.d_init */
};

#ifdef _KERNEL

extern struct bdevsw bdevsw[];      /* these instances are populated */
extern struct cdevsw cdevsw[];      /* in platform-specific config.c */

#endif /* _KERNEL */

#endif /* _SYS_DEV_H */

/* vi: set ts=4 expandtab: */
