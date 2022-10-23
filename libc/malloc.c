/*****************************************************************************

   malloc.c                                         ux/64 standard library

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

#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <errno.h>

/* this is a simple but fast allocator in the vein of Chris Kingsley's
   allocator (as found in 4.3BSD). we round up every request to a power
   of two, and return regions of that size (minus overhead). we never
   return memory to the system, instead keeping freed regions in buckets
   for later re-use. this works well in a virtual memory environment, for
   two reasons:

        1. we are not really allocating memory, but address space. if the
           caller requests a 520k allocation and we give them a 1GB region,
           the caller will (should) never touch the unused portion, and thus
           the VM system will never have occasion to assign real memory there.
        2. there's little need to return unused memory to the system. if an
           unused region lives in a free bucket for too long, the system will
           eventually page it to disk. disk storage is cheap, and so are the
           I/O operations (even if they are ultimately wasted).

   we allocate small objects in PAGE_SIZE slabs, since extra spaces in pages
   really WOULD get wasted. */

#define PAGE_SIZE       4096

#define LOG2_SMALLEST   5       /* log2 smallest region (32 bytes) */
#define LOG2_LARGEST    30      /* log2 largest region (1GB) */

#define ROUND_UP(a,b)           ((((a) + ((b) - 1)) / (b)) * (b))
#define NR_BUCKETS              ((LOG2_LARGEST - LOG2_SMALLEST) + 1)

/* return the size of regions in bucket `b' */

#define BUCKET_TO_SIZE(b)       (((size_t) 1) << ((b) + LOG2_SMALLEST))

/* return the size of the data[] payload of regions in bucket `b' */

#define BUCKET_TO_CAP(b)        (BUCKET_TO_SIZE(b) -                    \
                                        offsetof(struct region, data))

#define REGION_MAGIC    0x4B696E67      /* 'King', homage to original */

struct region
{
    /* regions are allocated starting on page boundaries,
       and the header union is 8 bytes, so the data field
       is guaranteed to be aligned on an 8-byte boundary. */

    union {
        struct region *next_free;       /* when in a bucket */

        struct {
            int magic;                  /* REGION_MAGIC */
            int bucket;                 /* bucket this came from */
        };
    };

    char data[];                        /* user data starts here */
};

static struct region *buckets[NR_BUCKETS];

/* convert pointer to region data[] -> pointer to region header */

#define TO_REGION(ptr)      ((struct region *) ((char *) (ptr) -        \
                                offsetof(struct region, data)))

/* get memory from the system to put at least
   one free region in the given bucket. returns
   the number of regions added to the bucket. */

static int refill(int bucket)
{
    size_t size;
    uintptr_t brk;
    int alloc;
    struct region *new;
    int n;
    int i;

    size = BUCKET_TO_SIZE(bucket);
    brk = (uintptr_t) sbrk(0);
    alloc = ROUND_UP(brk, PAGE_SIZE) - brk;

    if (size < PAGE_SIZE)
        n = (PAGE_SIZE / size);
    else
        n = 1;

    alloc += n * size;
    new = sbrk(alloc);

    if (new == (void *) -1)     /* sbrk() has already */
        return 0;               /* set errno = ENOMEM */

    for (i = 0; i < n; ++i) {
        new->next_free = buckets[bucket];
        buckets[bucket] = new;
        new = (struct region *) (((char *) new) + size);
    }

    return n;
}

void *malloc(size_t size)
{
    struct region *r;
    int bucket;

    if (size == 0) return 0;

    for (bucket = 0; bucket < NR_BUCKETS; ++bucket)
        if (size <= BUCKET_TO_CAP(bucket))
            break;

    if (bucket == NR_BUCKETS) {
        /* this is a fib; it's not that we don't have
           memory, we simply don't support allocations
           this large. EINVAL would probably be better. */

        errno = ENOMEM;
        return 0;
    }

    if (buckets[bucket] == 0)
        if (refill(bucket) == 0)        /* we pass through the */
            return 0;                   /* ENOMEM from refill() */

    r = buckets[bucket];
    buckets[bucket] = r->next_free;

    r->bucket = bucket;
    r->magic = REGION_MAGIC;

    return r->data;
}

void *realloc(void *ptr, size_t size)
{
    struct region *r;
    void *newptr;
    int bucket;
    size_t old_size;

    if (ptr == 0) return malloc(size);
    r = TO_REGION(ptr);

    if (r->magic == REGION_MAGIC) {
        old_size = BUCKET_TO_CAP(r->bucket);

        if (size > old_size) {
            newptr = malloc(size);
            if (newptr == 0) return 0;
            memcpy(newptr, ptr, old_size);
            free(ptr);
            ptr = newptr;
        } else
            /* nothing to do; the existing
               region is big enough, and we
               never attempt to downsize */ ;
    }

    return ptr;
}

void free(void *ptr)
{
    struct region *r;
    int bucket;

    if (ptr == 0) return;
    r = TO_REGION(ptr);

    if (r->magic == REGION_MAGIC) {
        bucket = r->bucket;
        r->next_free = buckets[bucket];
        buckets[bucket] = r;
    }
}

/* vi: set ts=4 expandtab: */
