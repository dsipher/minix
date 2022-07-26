/*****************************************************************************

  heap.c                                                  tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include "cc1.h"
#include "heap.h"

struct arena global_arena;
struct arena func_arena;
struct arena local_arena;
struct arena stmt_arena;
struct arena string_arena;

void init_arenas(void)
{
    init_arena(&global_arena, GLOBAL_ARENA_SIZE);
    init_arena(&func_arena, FUNC_ARENA_SIZE);
    init_arena(&stmt_arena, STMT_ARENA_SIZE);
    init_arena(&local_arena, LOCAL_ARENA_SIZE);
    init_arena(&string_arena, STRING_ARENA_SIZE);
}

void init_arena(struct arena *a, size_t size)
{
    void *p;

    if (a->bottom == 0) {
        p = mmap(0, size, PROT_READ | PROT_WRITE,
                 MAP_ANON | MAP_PRIVATE, -1, 0);

        if (p == MAP_FAILED) error(SYSTEM, 0, "init_arena: mmap failed");
        a->bottom = a->top = p;
    }
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

    ARENA_ALIGN(&global_arena, UNIVERSAL_ALIGN);
    p = ARENA_ALLOC(&global_arena, per_obj * per_slab);

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

        v->cap = 1 << LOG2(new_size);           /* this is the floor... */
        if (v->cap < new_size) v->cap <<= 1;    /* we want the ceiling */
        v->cap = MAX(v->cap, MIN_VECTOR_CAP);

        ARENA_ALIGN(v->arena, UNIVERSAL_ALIGN);
        new_elements = ARENA_ALLOC(v->arena, v->cap * elem_size);
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

/* vi: set ts=4 expandtab: */
