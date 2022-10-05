/*****************************************************************************

   heap.h                                              jewel/os c compiler

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

#ifndef HEAP_H
#define HEAP_H

#include <stddef.h>

/* arena sizes. these are intended to be large enough to be effectively
   infinite: as these are allocations of virtual address space, not RAM,
   there is little (no?) incentive to keep them small.

   the global_arena is never freed, but its objects are slab-allocated
   (see heap.h) and thus can be recycled on an individual basis as needed.
   specifically: symbols, type nodes/formals, and string entries go here.

   objects in the func_arena live for the duration of a function definition.
   here we find the IR data: blocks, insns, and various related structures.

   the stmt_arena holds transient data used during parsing. in particular,
   the nodes of expression trees are always allocated here. this arena is
   freed after every external definition (because initializer expressions)
   and after each statement in the outermost block of a function definition.

   the local_arena is a general-purpose arena for code which requires
   non-persistent dynamic allocation. the primary use case here is an
   optimization pass that accumulates data during its pass which is
   discarded when it's done, e.g., constant propagation.

   the string_arena is backing storage for the string text. never freed. */

#define DEFAULT_ARENA_SIZE      (1L << 27)              /* 128MB */

#define GLOBAL_ARENA_SIZE       DEFAULT_ARENA_SIZE      /* global_arena */
#define FUNC_ARENA_SIZE         DEFAULT_ARENA_SIZE      /* func_arena */
#define STMT_ARENA_SIZE         DEFAULT_ARENA_SIZE      /* stmt_arena */
#define LOCAL_ARENA_SIZE        DEFAULT_ARENA_SIZE      /* local_arena */
#define STRING_ARENA_SIZE       DEFAULT_ARENA_SIZE      /* string_arena */

/* an arena is a fixed-size region of anonymous-backed memory
   where we allocate objects which all have the same lifetime. */

struct arena { void *bottom; void *top; };

extern struct arena global_arena;
extern struct arena func_arena;
extern struct arena stmt_arena;
extern struct arena local_arena;
extern struct arena string_arena;

/* allocate backing storage for the above arenas */

void init_arenas(void);

/* allocate n (unaligned) bytes from the arena
   and return a pointer to the storage */

#define ARENA_ALLOC(a, n)                                                   \
    ({                                                                      \
        struct arena *_a = (a);                                             \
        void *_p = _a->top;                                                 \
        _a->top = (char *) _p + (n);                                        \
        (_p);                                                               \
    })

/* align an arena to a modulo n boundary */

#define ARENA_ALIGN(a, n)                                                   \
    do {                                                                    \
        struct arena *_a = (a);                                             \
        size_t _n = (n);                                                    \
        unsigned long _p = (unsigned long) _a->top;                         \
        if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; }       \
    } while (0)

/* release all objects allocated in the arena */

#define ARENA_FREE(a)                                                       \
    do {                                                                    \
        struct arena *_a = (a);                                             \
        _a->top = _a->bottom;                                               \
    } while (0)

/* freeze the contents of an arena. all objects currently allocated
   will live forever, unaffected by future calls to free_arena(). */

#define ARENA_FREEZE(a)                                                     \
    do {                                                                    \
        struct arena *_a = (a);                                             \
        _a->bottom = _a->top;                                               \
    } while (0)

/* we use a kind of half-baked slab allocation for objects that live in the
   global arena. these objects live forever but are recycled when possible. */

struct slab
{
    int per_obj;
    int per_slab;
    struct slab_obj { struct slab_obj *next; } *free;
    int alloc, avail; /* debugging stats */
};

struct slab_obj *refill_slab(struct slab *s);   /* for SLAB_ALLOC() */

#define SLAB(T)     T##_slab
#define SLAB_OBJ(p) ((struct slab_obj *) (p))

/* printf() helpers for debug stats */

#define SLAB_STATS_FMT      "%d allocated / %d available"
#define SLAB_STATS_ARG(T)   SLAB(T).alloc, SLAB(T).avail

/* define a new slab allocator for objects of struct T,
   configured to allocate slabs of n objects at a time */

#define SLAB_DEFINE(T, n)   struct slab SLAB(T) = { sizeof(struct T), (n) }

/* get a struct T from the slab allocator. if no
   objects are available, allocates a new slab */

#define SLAB_ALLOC(T)                                                       \
    ({                                                                      \
        struct slab_obj *_obj;                                              \
                                                                            \
        if (_obj = SLAB(T).free)                                            \
            SLAB(T).free = _obj->next;                                      \
        else                                                                \
            _obj = refill_slab(&SLAB(T));                                   \
                                                                            \
        --SLAB(T).avail;                                                    \
        ((struct T *) (_obj));                                              \
    })

/* return a struct T to the slab allocator */

#define SLAB_FREE(T, p)                                                     \
    do {                                                                    \
        struct T *_p = (p);   /* force type check */                        \
        SLAB_OBJ(p)->next = SLAB(T).free;                                   \
        SLAB(T).free = SLAB_OBJ(p);                                         \
        ++SLAB(T).avail;                                                    \
    } while (0)

/* vectors are dynamic arrays. we use type punning between struct vector
   and the structs declared by DEFINE_VECTOR() to (somewhat ironically)
   provide better type checking, and allow macro wrappers to magically
   pass on type size information. a vector draws all of its allocations
   from an arena which is set at its initialization with VECTOR_INIT(). */

struct vector
{
    int cap;                /* capacity in elements; always a power of 2 */
    int size;               /* current size. of course size always <= cap */
    void *elements;         /* the array itself */
    struct arena *arena;    /* where to allocate elements */
};

/* define a type for vector-of-TYPE which
   can then be referred to as VECTOR(NAME) */

#define DEFINE_VECTOR(NAME, TYPE)                                           \
    struct NAME##_vector                                                    \
    {                                                                       \
        int cap;                                                            \
        int size;                                                           \
        TYPE *elements;                                                     \
        struct arena *arena;                                                \
    }

#define VECTOR(NAME)                struct NAME##_vector

#define VECTOR_ELEM_SIZE(v)         sizeof(*((v).elements))
#define VECTOR_ELEM(v, i)           ((v).elements[i])
#define VECTOR_SIZE(v)              ((v).size)
#define VECTOR_CAP(v)               ((v).cap)
#define VECTOR_LAST(v)              ((v).elements[(v).size - 1])

#define EMPTY_VECTOR(v)             (VECTOR_SIZE(v) == 0)

DEFINE_VECTOR(int, int);            /* general vector of ints */
DEFINE_VECTOR(long, long);          /* ................ longs */

/* minimum capacity for an allocation; a vector may have zero capacity,
   but if it has any capacity at all, it is >= MIN_VECTOR_CAP. it must
   be a multiple of 8; with this constraint, regardless of the size of
   an element, the size of elements[] is always (1) a quadword multiple.
   in the future, vector_insert() will rely on this for efficiency. */

#define MIN_VECTOR_CAP              8

/* make room for n new elements in vector v at index i. trailing elements
   are shifted rearwards and the vector grows in size. an 'insertion' is
   permitted at the end of the vector. n may not be zero (or negative). */

void vector_insert(struct vector *v, int i, int n, int elem_size);

#define VECTOR_INSERT(v, i, n)                                              \
    vector_insert((struct vector *) &(v), (i), (n), VECTOR_ELEM_SIZE(v))

/* delete n elements from vector v at index i. trailing elements
   are shifted towards the front and the vector shrinks in size. */

void vector_delete(struct vector *v, int i, int n, int elem_size);

#define VECTOR_DELETE(v, i, n)                                              \
    vector_delete((struct vector *) &(v), (i), (n), VECTOR_ELEM_SIZE(v))

/* make a (shallow) vector copy. vectors must have the same underlying type */

void dup_vector(struct vector *dst, struct vector *src, int elem_size);

#define DUP_VECTOR(dst, src)                                                \
    do {                                                                    \
        int _dummy = &(dst) == &(src);      /* ensure same type */          \
                                                                            \
        dup_vector((struct vector *) &(dst), (struct vector *) &(src),      \
                    VECTOR_ELEM_SIZE(dst));                                 \
    } while (0)

/* initialize a vector, specifying its backing arena (a). */

#define INIT_VECTOR(v, a)                                                   \
    do {                                                                    \
        (v).cap = 0;                                                        \
        (v).size = 0;                                                       \
        (v).elements = 0;                                                   \
        (v).arena = (a);                                                    \
    } while (0)

/* set the size of the vector to n elements.
   performs a new allocation if required. */

#define RESIZE_VECTOR(v, n)                                                 \
    do {                                                                    \
        int _n = (n);                                                       \
                                                                            \
        if (_n <= VECTOR_CAP(v))                                            \
            VECTOR_SIZE(v) = _n;                                            \
        else                                                                \
            vector_insert((struct vector *) &(v), VECTOR_SIZE(v),           \
                          _n - VECTOR_SIZE(v), VECTOR_ELEM_SIZE(v));        \
    } while (0)

/* fill the contents of a vector with the given byte */

#define MEMSET_VECTOR(v, b) memset((v).elements, (b),                       \
                            VECTOR_SIZE(v) * VECTOR_ELEM_SIZE(v))

/* truncates the vector to 0 length (but preserving its allocation) */

#define TRUNC_VECTOR(v)     RESIZE_VECTOR((v), 0)

/* grow the size of a vector by n elements */

#define GROW_VECTOR(v, n)                                                   \
    do {                                                                    \
        int _n = (n);                                                       \
                                                                            \
        if ((VECTOR_SIZE(v) + _n) < VECTOR_CAP(v))                          \
            VECTOR_SIZE(v) += _n;                                           \
        else                                                                \
            vector_insert((struct vector *) &(v), VECTOR_SIZE(v),           \
                          _n, VECTOR_ELEM_SIZE(v));                         \
    } while(0)

/* simple primitives to make a stack from a vector container */

#define VECTOR_PUSH(v, elem)                                                \
    do {                                                                    \
        GROW_VECTOR((v), 1);                                                \
        VECTOR_LAST(v) = (elem);                                            \
    } while (0)

#define VECTOR_TOP(v)       VECTOR_ELEM((v), VECTOR_SIZE(v) - 1)
#define VECTOR_POP(v)       (VECTOR_SIZE(v) -= 1)

/* a bitvec is a specialized vector for bit arrays with the usual
   operations. sizes for the BITVEC macros are given in bits. */

DEFINE_VECTOR(bitvec, long);

/* return the number of longs to required to hold n bits.
   doesn't look it, but it's constant-foldable when n is. */

#define BITVEC_WORDS(n)     (((n) + BITS_PER_LONG - 1) >> LOG2_BITS_PER_LONG)

/* calculate the word index or bit index of the specified bit, respectively */

#define BITVEC_WORD(n)      ((n) >> LOG2_BITS_PER_LONG)
#define BITVEC_BIT(n)       ((n) & (BITS_PER_LONG - 1))

/* wrappers analogous to their VECTOR counterparts, (with type checking) */

#define INIT_BITVEC(v, a)                                                   \
    do {                                                                    \
        VECTOR(bitvec) *_v = &(v);                                          \
        INIT_VECTOR(*_v, (a));                                              \
    } while (0)

#define RESIZE_BITVEC(v, n)                                                 \
    do {                                                                    \
        VECTOR(bitvec) *_v = &(v);                                          \
        RESIZE_VECTOR(*_v, BITVEC_WORDS(n));                                \
    } while (0)

/* truncates the length of the bitvec to 0 bits */

#define TRUNC_BITVEC(v)             TRUNC_VECTOR(v)

/* set or clear all the bits in a bitvec. */

#define SET_BITVEC(v)               MEMSET_VECTOR((v), 0xFF)
#define CLR_BITVEC(v)               MEMSET_VECTOR((v), 0)

/* set or reset the specified bit in the bitvec. */

#define BITVEC_SET(v, n)                                                    \
    do {                                                                    \
        VECTOR(bitvec) *_v = &(v);                                          \
        _v->elements[BITVEC_WORD(n)] |= (1L << BITVEC_BIT(n));              \
    } while (0)

#define BITVEC_CLR(v, n)                                                    \
    do {                                                                    \
        VECTOR(bitvec) *_v = &(v);                                          \
        _v->elements[BITVEC_WORD(n)] &= ~(1L << BITVEC_BIT(n));             \
    } while (0)

/* return true if the specified bit in a bitvec is set or reset */

#define BITVEC_IS_SET(v, n)                                                 \
    ({                                                                      \
        VECTOR(bitvec) *_v = &(v);                                          \
        ((_v->elements[BITVEC_WORD(n)] & (1L << BITVEC_BIT(n))) != 0);      \
    })

#define BITVEC_IS_CLR(v, n)                                                 \
    ({                                                                      \
        VECTOR(bitvec) *_v = &(v);                                          \
        ((_v->elements[BITVEC_WORD(n)] & (1L << BITVEC_BIT(n))) == 0);      \
    })

/* AND, OR and BIC (bit clear, i.e., AND with complement) operations. the
   dst and src sets must have the same size, or bad things will happen. */

#define BITVEC0(dst, src, OP)                                               \
    do {                                                                    \
        VECTOR(bitvec) *_dst = &(dst);                                      \
        VECTOR(bitvec) *_src = &(src);                                      \
        int _i;                                                             \
        int _size = VECTOR_SIZE(dst);                                       \
                                                                            \
        for (_i = 0; _i < _size; ++_i)                                      \
            (_dst->elements[_i]) OP (_src->elements[_i]);                   \
    } while (0)

#define BITVEC_AND(dst, src)        BITVEC0((dst), (src), &=)
#define BITVEC_OR(dst, src)         BITVEC0((dst), (src), |=)
#define BITVEC_BIC(dst, src)        BITVEC0((dst), (src), &=~)

#define SAME_BITVEC(dst, src)                                               \
    ({                                                                      \
        VECTOR(bitvec) *_dst = &(dst);                                      \
        VECTOR(bitvec) *_src = &(src);                                      \
        int _size = VECTOR_SIZE(dst);                                       \
        int _same = 1;                                                      \
        int _i;                                                             \
                                                                            \
        for (_i = 0; _i < _size; ++_i)                                      \
            if (_dst->elements[_i] != (_src->elements[_i])) {               \
                _same = 0;                                                  \
                break;                                                      \
            }                                                               \
                                                                            \
        (_same);                                                            \
    })

/* void SET_ADD(VECTOR(...) *set, ... ELEM);

   add an element ELEM to the set (if not already present) */

#define SET_ADD(ELEM, PRECEDES)                                             \
    {                                                                       \
        int i;                                                              \
                                                                            \
        for (i = 0; i < VECTOR_SIZE(*set); ++i) {                           \
            if (VECTOR_ELEM(*set, i) == ELEM)                               \
                return;                                                     \
                                                                            \
            if (PRECEDES(ELEM, VECTOR_ELEM(*set, i)))                       \
                break;                                                      \
        }                                                                   \
                                                                            \
        VECTOR_INSERT(*set, i, 1);                                          \
        VECTOR_ELEM(*set, i) = ELEM;                                        \
    }

/* void SET_REMOVE(VECTOR(...) *set, ... ELEM);

   remove an element ELEM from the set (if present) */

#define SET_REMOVE(ELEM, PRECEDES)                                          \
    {                                                                       \
        int i;                                                              \
                                                                            \
        for (i = 0; i < VECTOR_SIZE(*set); ++i) {                           \
            if (VECTOR_ELEM(*set, i) == ELEM) {                             \
                VECTOR_DELETE(*set, i, 1);                                  \
                return;                                                     \
            }                                                               \
                                                                            \
            if (PRECEDES(ELEM, VECTOR_ELEM(*set, i)))                       \
                break;   /* definitely not present */                       \
        }                                                                   \
}

/* int SET_CONTAINS(VECTOR(...) *set, ... ELEM);

   returns true if the set contains the element ELEM */

#define SET_CONTAINS(ELEM, PRECEDES)                                        \
    {                                                                       \
        int i;                                                              \
                                                                            \
        for (i = 0; i < VECTOR_SIZE(*set); ++i) {                           \
            if (VECTOR_ELEM(*set, i) == ELEM)                               \
                return 1;                                                   \
                                                                            \
            if (PRECEDES(ELEM, VECTOR_ELEM(*set, i)))                       \
                break; /* early exit */                                     \
        }                                                                   \
                                                                            \
        return 0;                                                           \
    }

/* int SAME_SET(VECTOR(...) *set1, VECTOR(...) *set2);

   returns true iff set1 and set2 contain exactly the same elements */

#define SAME_SET()                                                          \
    {                                                                       \
        int i;                                                              \
                                                                            \
        if (VECTOR_SIZE(*set1) != VECTOR_SIZE(*set2))                       \
            return 0;                                                       \
                                                                            \
        for (i = 0; i < VECTOR_SIZE(*set1); ++i)                            \
            if (VECTOR_ELEM(*set1, i) != VECTOR_ELEM(*set2, i))             \
                return 0;                                                   \
                                                                            \
        return 1;                                                           \
    }

/* void UNION_SETS(VECTOR(...) *dst, VECTOR(...) *src1,
                                     VECTOR(...) *src2);

   compute the union of sets src1 and src2 into dst. */

#define UNION_SETS(ELEM_TYPE, PRECEDES)                                     \
    {                                                                       \
        int i1 = 0;                                                         \
        int i2 = 0;                                                         \
        int size1 = VECTOR_SIZE(*src1);                                     \
        int size2 = VECTOR_SIZE(*src2);                                     \
        ELEM_TYPE elem;                                                     \
                                                                            \
        TRUNC_VECTOR(*dst);                                                 \
                                                                            \
        while ((i1 < size1) || (i2 < size2))                                \
        {                                                                   \
            if (i1 == VECTOR_SIZE(*src1))                                   \
                elem = VECTOR_ELEM(*src2, i2++);                            \
            else if (i2 == VECTOR_SIZE(*src2))                              \
                elem = VECTOR_ELEM(*src1, i1++);                            \
            else if (PRECEDES(VECTOR_ELEM(*src1, i1),                       \
                              VECTOR_ELEM(*src2, i2)))                      \
                elem = VECTOR_ELEM(*src1, i1++);                            \
            else if (PRECEDES(VECTOR_ELEM(*src2, i2),                       \
                              VECTOR_ELEM(*src1, i1)))                      \
                elem = VECTOR_ELEM(*src2, i2++);                            \
            else {                                                          \
                elem = VECTOR_ELEM(*src2, i2++);                            \
                ++i1;                                                       \
            }                                                               \
                                                                            \
            GROW_VECTOR(*dst, 1);                                           \
            VECTOR_LAST(*dst) = elem;                                       \
        }                                                                   \
    }

/* void INTERSECT_SETS(VECTOR(...) *dst, VECTOR(...) *src1,
                                         VECTOR(...) *src2);

   compute the intersection of sets src1 and src2 into dst. */

#define INTERSECT_SETS(PRECEDES)                                            \
    {                                                                       \
        int i1 = 0;                                                         \
        int i2 = 0;                                                         \
        int size1 = VECTOR_SIZE(*src1);                                     \
        int size2 = VECTOR_SIZE(*src2);                                     \
                                                                            \
        TRUNC_VECTOR(*dst);                                                 \
                                                                            \
        while ((i1 < size1) && (i2 < size2))                                \
        {                                                                   \
            if (PRECEDES(VECTOR_ELEM(*src1, i1), VECTOR_ELEM(*src2, i2)))   \
                ++i1;                                                       \
            else if (PRECEDES(VECTOR_ELEM(*src2, i2),                       \
                     VECTOR_ELEM(*src1, i1)))                               \
                ++i2;                                                       \
            else {                                                          \
                GROW_VECTOR(*dst, 1);                                       \
                VECTOR_LAST(*dst) = VECTOR_ELEM(*src1, i1);                 \
                ++i1;                                                       \
                ++i2;                                                       \
            }                                                               \
        }                                                                   \
    }

/* void DIFF_SETS(VECTOR(...) *dst, VECTOR(...) *src1,
                                    VECTOR(...) *src2);

   compute the set difference (set1 - set2) into dst. */

#define DIFF_SETS(PRECEDES)                                                 \
    {                                                                       \
        int i1 = 0;                                                         \
        int i2 = 0;                                                         \
        int size1 = VECTOR_SIZE(*src1);                                     \
        int size2 = VECTOR_SIZE(*src2);                                     \
                                                                            \
        TRUNC_VECTOR(*dst);                                                 \
                                                                            \
        while (i1 < size1)                                                  \
        {                                                                   \
            if ((i2 == size2) || PRECEDES(VECTOR_ELEM(*src1, i1),           \
                                          VECTOR_ELEM(*src2, i2)))          \
            {                                                               \
                GROW_VECTOR(*dst, 1);                                       \
                VECTOR_LAST(*dst) = VECTOR_ELEM(*src1, i1++);               \
            } else if (PRECEDES(VECTOR_ELEM(*src2, i2),                     \
                       VECTOR_ELEM(*src1, i1))) {                           \
                ++i2;                                                       \
            } else {                                                        \
                ++i1;                                                       \
                ++i2;                                                       \
            }                                                               \
        }                                                                   \
    }

#endif /* HEAP_H */

/* vi: set ts=4 expandtab: */
