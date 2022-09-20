/*****************************************************************************

   page.c                                                  jewel/os kernel

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

#include <sys/boot.h>
#include <sys/log.h>
#include <sys/types.h>
#include <sys/page.h>
#include <sys/slist.h>
#include <sys/spin.h>

/* compared to `modern' POSIX systems, memory management in jewel
   is deliberately primitive. except for early static allocations
   for block headers, process descriptors, etc. (see pginit), we
   deal exclusively in whole pages. we maintain linked lists of
   free pages organized by color; the free pages themselves are
   used to store the list links. as with [almost] all pointers in
   the kernel, the links use virtual addresses (>=PHYSICAL_BASE). */

static spinlock_t page_lock;        /* protects the free page data */

static int nr_free_pages;           /* simple count */
static int last_color;              /* for unhinted pgall() */

static SLIST_HEAD(, free_page) free_pages[PAGE_COLORS];
struct free_page { SLIST_ENTRY(free_page) link; };

/* using 0 as a sentinel value is unambiguous,
   that's never a valid kernel virtual address. */

#define NEXT_COLOR(c)   (((c) + 1) & PAGE_COLOR_MASK)

caddr_t
pgall(caddr_t hint)
{
    caddr_t a;
    int color;

    acquire(&page_lock);

    if (nr_free_pages == 0) {
        a = 0;
        goto out;
    }

    /* if the caller hasn't provided a hint, we rotate amongst
       the available colors to spread out the allocations. */

    if (hint)
        color = PAGE_COLOR(hint);
    else {
        color = NEXT_COLOR(last_color);
        last_color = color;
    }

    /* we loop because we may not have any pages of the
       right color. if not, we check succeeding buckets
       until we find one. this loop will always terminate,
       since we know there's one free page SOMEWHERE. */

    while (SLIST_EMPTY(&free_pages[color]))
        color = NEXT_COLOR(color);

    a = (caddr_t) SLIST_FIRST(&free_pages[color]);
    SLIST_REMOVE_HEAD(&free_pages[color], link);
    --nr_free_pages;

out:
    release(&page_lock);
    return a;
}

/* release page beginning at address `a' back to its free_pages list.
   `a' may be the physical or kernel virtual address of the page. */

void
pgfree(caddr_t a)
{
    struct free_page *p;
    int color;

    color = PAGE_COLOR(a);
    p = (struct free_page *) PTOV(a);

    acquire(&page_lock);
    SLIST_INSERT_HEAD(&free_pages[color], p, link);
    ++nr_free_pages;
    release(&page_lock);
}

/* the E820 map as given is not page-granular.
   to rectify this, we expand unusable regions
   outward and shrink usable regions inward.

   then we sort the map by base address, which
   will guarantee that memall() will take from
   the lowest available memory regions first. */

static void
fix_e820(void)
{
    struct e820 *entry;
    struct e820 tmp;
    caddr_t base;
    int i, swaps;

    for (i = 0, entry = e820_map; i < e820_count; ++i, ++entry) {
        if (entry->type == E820_TYPE_FREE) {
            base = PAGE_UP(entry->base);
            entry->len -= (base - entry->base);
            entry->base = base;
            entry->len = PAGE_DOWN(entry->len);
        } else {
            base = PAGE_DOWN(entry->base);
            entry->len += entry->base - base;
            entry->base = base;
            entry->len = PAGE_UP(entry->len);
        }
    }

    /* ah, yes, my favorite, the
       much-despised bubble sort */

    do {
        swaps = 0;

        for (i = 0, entry = e820_map; i < (e820_count - 1); ++i, ++entry)
            if (entry[0].base > entry[1].base) {
                tmp = entry[0];
                entry[0] = entry[1];
                entry[1] = tmp;
                ++swaps;
            }
    } while (swaps);
}

/* some broken BIOSes will report overlapping ranges; we `handle'
   this by refusing to use any RAM that appears in multiple ranges.
   overlaps() returns true if any of [base, len] is so disqualified.

   this is only a partial solution. if crucial areas needed by memall()
   are overlapped, we make no attempt to cope, and the result is panic.
   if we come across a really broken BIOS we need to work with, we'll
   have to decide how to work around it then. probably won't happen. */

#define OVERLAP0(addr, base, len)   (       ((addr) >= (base))              \
                                         && ((addr) < ((base) + (len)))     )

static int
overlaps(caddr_t base, size_t len)
{
    struct e820 *entry = e820_map;
    struct e820 *match = 0;
    int i;

    for (i = 0; i < e820_count; ++i, ++entry)
        if ( OVERLAP0(base, entry->base, entry->len)
          || OVERLAP0(entry->base, base, len) )
        {
            if (match) return 1;
            match = entry;
        }

    return 0;
}

/* allocate `n' contiguous RAM pages from the entry_map[].
   returns a physical base address, or panics if unable.
   performs first-fit. because the map is sorted by base
   address in init_entry(), the lowest RAM range will be
   chosen: this ordering is important to pginit(). */

static caddr_t
memall(size_t n)
{
    struct e820 *entry;
    caddr_t base;
    int i;

    n <<= PAGE_SHIFT;

    for (i = 0, entry = e820_map; i < e820_count; ++i, ++entry)
    {
        if ( entry->type != E820_TYPE_FREE   /* must be RAM */
          || entry->base < FIRST_FREE        /* skip ISA memory */
          || entry->len < n                  /* region too small */
          || overlaps(entry->base, n))       /* broken BIOS map */
        {
            continue;
        }

        base = entry->base;
        entry->base += n;
        entry->len -= n;

        return base;
    }

    panic("memall");
}

/* map all physical RAM into the kernel's address space
   PHYSICAL_BASE. we can't use mapin() here for several
   important reasons:

    1. the free_pages[] lists are not yet built.
    2. we must address the tables physically
    3. we want 2MB pages, rather than 4kB pages

   luckily we're mapping in a contiguous physical range
   to a contiguous virtual range, so fast and easy. */

void
physical(caddr_t ram_top)
{
    const size_t two_meg = (2 << 20);
    const size_t one_gig = (1 << 30);
    pte_t *ptl2p = (pte_t *) PTL2P_ADDR;
    pte_t *pte;
    caddr_t addr;
    int pages;

    if (ram_top < MIN_PHYSICAL) ram_top = MIN_PHYSICAL;

    pages = (ram_top + one_gig - 1) / one_gig;      /* one page for every */
    pte = (pte_t *) memall(pages);                  /* GB or part thereof */
    memset(pte, 0, PAGE_SIZE * pages);

    while (pages--)
        *ptl2p++ = ((long) &pte[pages]) | PTE_W | PTE_P;

    for (addr = 0; addr < ram_top; addr += two_meg)
        *pte++ = addr | PTE_G | PTE_2MB | PTE_W | PTE_P;
}

/* XXX */

void
pginit(void)
{
    struct e820 *entry;
    caddr_t ram_top;
    int i;

    fix_e820();

    /* we need to remove the [identity-mapped] proc0 u. area
       from the map. the pages must where we expect them! */

    if (memall(USER_PAGES) != USER_ADDR) panic("pginit");

    /* find the highest physical RAM address. the result
       is ram_top, such that all RAM addresses < ram_top. */

    for (ram_top = 0, i = 0, entry = e820_map; i < e820_count; ++i)
        if (entry->type == E820_TYPE_FREE
          && (entry->base + entry->len) > ram_top)
        {
            ram_top = entry->base + entry->len;
        }

    physical(ram_top);

    /* XXX: this is where we allocate proc[], mbuf[] etc. */
    /* XXX: free all unused pages to build free_pages[] */

    for (i = 0; i < e820_count; ++i) {  /* to be removed */
        printf("type = %d base = %x length = %x\n", e820_map[i].type,
                                                    e820_map[i].base,
                                                    e820_map[i].len);
    }
}

/* vi: set ts=4 expandtab: */
