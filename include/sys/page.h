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
   the startup code in page.c. this is not easily changed: do not move. */

#define PHYSICAL_BASE   0xFFFFFF8000000000L     /* last 512GB */

/* convert a physical address to a virtual address or vice-versa.
   an address already in the desired class is left unchanged. */

#define PTOV(a)         ((a) | PHYSICAL_BASE)
#define VTOP(a)         ((a) & ~PHYSICAL_BASE)

/* regardless of the amount of RAM, we always map at least the first
   4GB of physical address space, because we need to access the local
   APIC and other memory-mapped devices (it's possible for the BIOS
   to map PCI MMIO BARs above this limit, but in practice it won't) */

#define MIN_PHYSICAL    0x0000000100000000L     /* 4GB */

/* physical memory above this address is guaranteed to not be occupied by the
   kernel image. used to decide what memory is free during initialization. */

#define FIRST_FREE      0x0000000000100000L     /* 1MB */

/* the u. area for the current process is always found at USER_ADDR.
   it is USER_PAGES pages long; the remaining space is used for the
   process KERNEL_STACK. it is not a coincidence that USER_ADDR is
   FIRST_FREE: the bootstrapping process relies on this. see page.c.

   KERNEL_STACK must agree with the value found in the TSS (in boot.s) */

#define USER_ADDR       0x0000000000100000L    /* 1MB = FIRST_FREE */
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

/* the entries of each level of page table are given their
   own names in the Intel literature; we call them all PTEs,
   and for the most part, treat them identically. */

typedef unsigned long pte_t;

#define PTE_P           0x0001          /* entry is present */
#define PTE_W           0x0002          /* page is writable */
#define PTE_U           0x0004          /* user-accessible */
#define PTE_2MB         0x0080          /* 2MB page (PTL1) */
#define PTE_G           0x0100          /* page is global */

/* we use PTE_SHARE (an AVL `available bit' in the PTE) to indicate a
   PTE which governs address space that should be shared rather than
   duplicated across a fork, e.g., the kernel image, or shared text. */

#define PTE_SHARE       0x0200          /* duplicate entry verbatim */

/* calculate the index of the PTE associated with
   virtual address `v' at page table level `ptl'. */

#define PTE_INDEX(ptl, v)       (((v) >> ((ptl) * 9 + PAGE_SHIFT))      \
                                        & (PTES_PER_PAGE - 1))

#define PTES_PER_PAGE           (PAGE_SIZE / sizeof(pte_t))

/* return the physical page referenced by the PTE */

#define PTE_ADDR(pte)           ((pte) & 0x0000FFFFFFFFF000)

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

/* map a page `addr' into the address space headed by `ptl3' at virtual
   address `vaddr', with the PTE_* `flags'. returns non-zero on success,
   or zero on failure; can only fail when new intermediate page tables
   are needed and there are no free pages for them. */

extern int mapin(caddr_t addr, pte_t *ptl3, caddr_t vaddr, int flags);

/* unmaps the page at `vaddr' in the address space headed
   by `ptl3'. if no page is mapped there, this is a no-op.
   the caller is responsible for invalidating TLBs if needed */

extern void mapout(pte_t *ptl3, caddr_t vaddr);

#endif /* _KERNEL */

#endif /* _SYS_PAGE_H */

/* vi: set ts=4 expandtab: */
