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

/* compared to `modern' POSIX systems, memory management in jewel
   is deliberately primitive. except for early static allocations
   for block headers, process descriptors, etc. (see pginit), we
   deal exclusively in whole pages. we maintain linked lists of
   free pages organized by color; the free pages themselves are
   used to store the list links. as with [almost] all pointers in
   the kernel, the links use virtual addresses (>=PHYSICAL_BASE). */

static SLIST_HEAD(, free_page) free_pages[PAGE_COLORS];
struct free_page { SLIST_ENTRY(free_page) link; };

/* XXX */

caddr_t
pgall(caddr_t hint)
{
}

/* XXX */

void
pgfree(caddr_t a)
{
}

/* the E820 map as given is not page-granular.
   to rectify this, we expand unusable regions
   outward and shrink usable regions inward.

   then we sort the map by base address, which
   will guarantee that memall() will take from
   the lowest available memory regions first. */

static void
init_e820(void)
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
   chosen: this is vitally important to early_pgall(). */

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

/* XXX */

void
pginit(void)
{
    int i;

    init_e820();

    for (i = 0; i < e820_count; ++i) {
        printf("type = %d base = %x length = %x\n", e820_map[i].type,
                                                    e820_map[i].base,
                                                    e820_map[i].len);
    }
}

/* vi: set ts=4 expandtab: */
