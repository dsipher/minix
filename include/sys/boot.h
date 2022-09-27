/*****************************************************************************

   sys/boot.h                                    jewel/os standard library

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

#ifndef _SYS_BOOT_H
#define _SYS_BOOT_H

#include <sys/types.h>
#include <sys/page.h>

/* the limit of the kernel image in low/conventional memory. all pages
   below kernel_top, except for the zero page, are part of the kernel's
   text/data/bss. computed by main() from the kernel a.out header. */

extern caddr_t kernel_top;      /* page-aligned for convenience */

/* definitions useful during bootstrapping. must agree with boot.s!

   boot is [ultimately] loaded at 0x1000. it's only a page long, but
   it builds permanenent data structures (shared with the kernel) in
   [BOOT_ADDR, KERNEL_ADDR), so none of that RAM is available. the
   zero page is only used for the boot stack, so it can be freed and
   unmapped to catch null references once all the APs are started. */

#define BOOT_ADDR       0x00001000          /* boot starts here ... */
#define KERNEL_ADDR     0x00008000          /* ... and kernel here */

/* important addresses in the prototype page tables built by boot block */

#define PTL3_ADDR       0x00002000          /* the whole table */
#define PTL2P_ADDR      0x00006000          /* mid-table for physical map */

/* physical addresses up to [but not including] BOOT_MAPPED
   are guaranteed to be identity-mapped by the boot block */

#define BOOT_MAPPED     0x00200000          /* the first 2MB are mapped */

/* general communication vector between the boot code and the
   kernel. it's called the boot configuration vector because
   many of these values are [will be] tunable by the user. */

struct boot_config
{
    void            (*entry_addr)(void);    /* AP kernel entry function */
    pte_t           *entry_ptl3;            /* ............... page tables */
    void            (*trap_addr)(void);     /* kernel trap handler */

    unsigned short  nproc;                  /* number of processes */
    unsigned short  nbuf;                   /* number of block buffers */
    unsigned short  nmbuf;                  /* number of network buffers */
};

extern struct boot_config boot_config;      /* exported by locore.s */

#define NPROC       (boot_config.nproc)     /* traditional names */
#define NBUF        (boot_config.nbuf)
#define NMBUF       (boot_config.nmbuf)

/* boot retrieves the so-called E820 memory map from the BIOS */

struct e820
{
    caddr_t     base;               /* base address of region */
    size_t      len;                /* and its length in bytes */
    int         type;               /* see E820_TYPE_* below */
    int         unused0;
};

extern int e820_count;              /* these are exported as absolute */
extern struct e820 e820_map[];      /* symbols from locore.s */

#define E820_TYPE_FREE  1           /* the only type we care about */

#endif /* _SYS_BOOT_H */

/* vi: set ts=4 expandtab: */
