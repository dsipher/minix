/*****************************************************************************

  malloc.c                                          tahoe/64 standard library

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>

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

#define ROUND_UP(a,b)       ((((a) + ((b) - 1)) / (b)) * (b))

#define LOG2_SMALLEST   5           /* log2 smallest block (32 bytes) */
#define LOG2_LARGEST    30          /* log2 largest block (1GB) */

#define NR_BUCKETS      ((LOG2_LARGEST - LOG2_SMALLEST) + 1)

#define BUCKET_TO_SIZE(b)       (((size_t) 1) << ((b) + LOG2_SMALLEST))

#define REGION_MAGIC    0x4B696E67      /* 'King', homage to original */

struct region
{
    /* regions are allocated starting on page boundaries, and the header union
       is 8 bytes, so data is guaranteed aligned on an 8-byte boundary. */

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

    if (new == (void *) -1)
        return 0;

    for (i = 0; i < n; ++i) {
        new->next_free = buckets[bucket];
        buckets[bucket] = new;
        new = (struct region *) (((char *) new) + size);
    }

    return n;
}

void *malloc(size_t bytes)
{
    struct region *r;
    int bucket;

    bytes += offsetof(struct region, data);

    for (bucket = 0; bucket < NR_BUCKETS; ++bucket)
        if (bytes <= BUCKET_TO_SIZE(bucket))
            break;

    if (bucket == NR_BUCKETS)
        return 0;

    if (buckets[bucket] == 0)
        if (refill(bucket) == 0)
            return 0;

    r = buckets[bucket];
    buckets[bucket] = r->next_free;

    r->bucket = bucket;
    r->magic = REGION_MAGIC;

    return r->data;
}

void free(void *ptr)
{
    struct region *r;
    int bucket;

    r = (struct region *) ((char *) ptr - offsetof(struct region, data));

    if (r->magic == REGION_MAGIC) {
        bucket = r->bucket;
        r->next_free = buckets[bucket];
        buckets[bucket] = r;
    }
}

/* vi: set ts=4 expandtab: */
