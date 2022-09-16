/*****************************************************************************

   sys/page.h                                    jewel/os standard library

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

#ifndef _SYS_PAGE_H
#define _SYS_PAGE_H

/* ATOM supports multiple page sizes, of course, but (except for
   the physical memory image, see below) we only use 4k pages. */

#define PAGE_SHIFT          12
#define PAGE_SIZE           (1 << PAGE_SHIFT)
#define PAGE_MASK           (PAGE_SIZE - 1)

/* round an address or size up or down to a multiple of PAGE_SIZE */

#define PAGE_UP(a)          (((a) + PAGE_MASK) & ~PAGE_MASK)
#define PAGE_DOWN(a)        ((a) & ~PAGE_MASK)

/* do simple coloring to avoid pathological virtual address
   configurations, dividing pages into PAGE_COLORS sets. */

#define PAGE_COLORS         16 /* 256K, 8-way, 64 bytes/line */
#define PAGE_COLOR_MASK     (PAGE_COLORS - 1)
#define PAGE_COLOR(a)       (((a) >> PAGE_SHIFT) & PAGE_COLOR_MASK)

/* we map all of physical RAM into kernel virtual address space, starting
   at PHYSICAL_BASE. this mapping is started by boot.s, and completed by
   the startup code in page.c. if you want to move the base (uh, why?) be
   sure to update both. the base must be 512GB-aligned so that it occupies
   [exclusively] one PTL3 PTE and requires only one PTL2 for all RAM. */

#define PHYSICAL_BASE   0xFFFFFF8000000000L     /* last 512GB */

/* convert a physical address to a virtual address, or vice-versa. */

#define PTOV(a)         ((a) + PHYSICAL_BASE)
#define VTOP(a)         ((a) - PHYSICAL_BASE)

/* regardless of the amount of RAM, we always map at least the first
   4GB of physical address space, because we need to access the local
   APIC and other memory-mapped devices (it's possible for the BIOS
   to map PCI MMIO BARs above this limit, but in practice it won't) */

#define MIN_PHYSICAL    0x0000000100000000L     /* 4GB */

/* physical memory above this address is guaranteed to not be occupied by the
   kernel image. used to decide what memory is free during initialization. */

#define FIRST_FREE      0x0000000000100000L     /* 1MB */

/* the u. area for the current process is always found at USER_BASE.
   it is USER_PAGES pages long; the remaining space is used for the
   process KERNEL_STACK. it is not a coincidence that USER_BASE is
   FIRST_FREE: the bootstrapping process relies on this. see page.c.

   KERNEL_STACK must agree with the value found in the TSS (in boot.s) */

#define USER_BASE       0x0000000000100000L    /* 1MB = FIRST_FREE */
#define USER_PAGES      2                      /* 8K of user area */
#define KERNEL_STACK    0x0000000000102000L    /* thus the stack is here */

/* the initial value of RSP on entry to a user process. this value is
   placed one page below the a.out header/entry point of the process
   (A_EXEC_BASE from a.out.h) leaving a guard page to catch user stack
   underflows. it grows downwards towards the KERNEL_STACK; thus it is
   limited to ~512K, which is plenty of stack for reasonable purposes.

   we cram the first 2MB of virtual space with the kernel image, user
   area, kernel stack, and user stack to minimize the number of mid-
   level page tables required when the user text/data/bss fit in 512kB,
   which is the case for the vast majority of processes. this saves
   time and space, and the only disadvantage is the limitation on the
   user stack size, which, as noted above, isn't really restrictive. */

#define USER_STACK      0x000000000017F000L

#ifdef _KERNEL

/* called early from main(). until this completes,
   no memory-allocation functions are available */

extern void pginit(void);

/* allocate a page and return its kernel virtual address. if there
   are no more free pages, return 0. if the caller knows the user
   address that will be assigned to the page, it should pass that
   in as `hint', which will influence the page color chosen. if
   not known (or not for a user process), specify a 0 `hint'. */

extern caddr_t pgall(caddr_t hint);

/* free a page - return it to its free list */

extern void pgfree(caddr_t addr);

#endif /* _KERNEL */

#endif /* _SYS_PAGE_H */

/* vi: set ts=4 expandtab: */