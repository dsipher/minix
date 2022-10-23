/*****************************************************************************

   heap.c                                                 ux/64 c compiler

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
#include <string.h>
#include "cc1.h"
#include "heap.h"

struct arena global_arena;
struct arena func_arena;
struct arena local_arena;
struct arena stmt_arena;
struct arena string_arena;

void init_arenas(void)
{
    unsigned long adj;
    char *p;

    p = sbrk(0);
    adj = (unsigned long) p;

    if (adj % UNIVERSAL_ALIGN) {
        adj = UNIVERSAL_ALIGN - (adj % UNIVERSAL_ALIGN);
        p = sbrk(adj);

        /* we don't bother to check for failure. if
           this fails, so will the subsequent sbrk. */
    }

    p = sbrk(   GLOBAL_ARENA_SIZE
              + FUNC_ARENA_SIZE
              + STMT_ARENA_SIZE
              + LOCAL_ARENA_SIZE
              + STRING_ARENA_SIZE );

    if (p == (void *) -1) error(SYSTEM, 0, "arena allocations failed");

    global_arena.top = global_arena.bottom = p;     p += GLOBAL_ARENA_SIZE;
    func_arena.top   = func_arena.bottom   = p;     p += FUNC_ARENA_SIZE;
    stmt_arena.top   = stmt_arena.bottom   = p;     p += STMT_ARENA_SIZE;
    local_arena.top  = local_arena.bottom  = p;     p += LOCAL_ARENA_SIZE;
    string_arena.top = string_arena.bottom = p; /*  p += STRING_ARENA_SIZE; */
}

/* helper for SLAB_ALLOC(). refill a slab by allocating space from the
   global arena. puts all the new objects on the free list, except one,
   which is returned (to satisfy the current allocation request). */

struct slab_obj *refill_slab(struct slab *s)
{
    int per_obj = s->per_obj;
    int per_slab = s->per_slab;
    char *p;
    int i;

    p = arena_alloc(&global_arena, per_obj * per_slab, 0);

    for (i = 0; i < (per_slab - 1); ++i, p += per_obj) {
        SLAB_OBJ(p)->next = s->free;
        s->free = SLAB_OBJ(p);
    }

    s->alloc += per_slab;
    s->avail += per_slab;

    return SLAB_OBJ(p);
}

/* this performs not just insertions, but any kind of
   growth: an 'insertion' at the end expands the vector. */

void vector_insert(struct vector *v, int i, int n, int elem_size)
{
    int new_size = v->size + n;

    if (v->cap < new_size) {
        char *new_elements;

        /* because MIN_VECTOR_CAP is a multiple of 8
           (see heap.h) and we only grow by powers of
           2, v->cap will be always a power of 2 */

        v->cap = MAX(v->cap, MIN_VECTOR_CAP);
        while (v->cap < new_size) v->cap <<= 1;

        new_elements = arena_alloc(v->arena, v->cap * elem_size, 0);
        memcpy(new_elements, v->elements, i * elem_size);
        memcpy(new_elements + (i + n) * elem_size,
               ((char *) v->elements) + i * elem_size,
               (v->size - i) * elem_size);

        v->elements = new_elements;
    } else
        memmove(((char *) v->elements) + (i + n) * elem_size,
                ((char *) v->elements) + i * elem_size,
                (v->size - i) * elem_size);

    v->size = new_size;
}

void vector_delete(struct vector *v, int i, int n, int elem_size)
{
    char *elements = v->elements;

    memmove(elements + i * elem_size,
            elements + (i + n) * elem_size,
            (v->size - (i + n)) * elem_size);

    v->size -= n;
}

/* duplication is straightforward,
   but a bit too heavy to inline */

void dup_vector(struct vector *dst, struct vector *src, int elem_size)
{
    if (src->size > dst->cap) {
        dst->size = 0;
        vector_insert(dst, 0, src->size, elem_size);
    } else
        dst->size = src->size;

    memcpy(dst->elements, src->elements, elem_size * src->size);
}

/* we round up the allocation size to a quadword
   boundary as well, because memset() will do an
   excellent job with a quadword-aligned region
   whose length is a multiple of quadword. */

void *arena_alloc(struct arena *a, size_t n, int zero)
{
    char *p;

    p = (char *) ROUND_UP((unsigned long) a->top,
                            UNIVERSAL_ALIGN);

    n = ROUND_UP(n, UNIVERSAL_ALIGN);
    a->top = p + n;
    if (zero) memset(p, 0, n);

    return p;
}

/* vi: set ts=4 expandtab: */
