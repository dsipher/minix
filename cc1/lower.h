/*****************************************************************************

  lower.h                                                 tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#ifndef LOWER_H
#define LOWER_H

#include "heap.h"
#include "insn.h"

/* lower current function from LIR to MCH */

void lower(void);

/* eliminate synthetic MCH insns before output */

void desynth(void);

/* generate a machine move instruction appropriate to t. the
   caller must ensure the type/operand combination is valid. */

struct insn *move(long t, struct operand *dst, struct operand *src);

/* instead of tree matching, we do symbolic interpretation to build address
   operands. as we step through a block, we track the relationships between
   registers and equivalent values expressed as address operands in a cache.
   we perform global data-flow analysis to populate the cache at block entry.
   the lattice looks very much like that of constant propagation:

    undef (top):    not in cache. no definition for the reg seen yet.
    address:        the register has an equivalent operand in the cache.
    naa (bottom):   not an address operand. not in cache, naa bit set.

   cached operands are stored in normalized form. see normalize_operand(). */

struct cache { int reg; struct operand operand; };

DEFINE_VECTOR(cache, struct cache);

struct cache_state
{
    VECTOR(bitvec) naa;         /* indexed by REG_INDEX() */
    VECTOR(cache) cache;        /* ordered by REG_PRECEDES() */
};

/* per-block lowering data. this is ephemeral, from the local_arena.
   we maintain two caches: a working state, used as we step through
   the block, and the exit state which is fed to successor blocks. */

struct lower { struct cache_state state, exit; };

#define NR_CACHE(b)         VECTOR_SIZE((b)->lower.state.cache)
#define NR_EXIT(b)          VECTOR_SIZE((b)->lower.exit.cache)

#define CACHE(b, n)         VECTOR_ELEM((b)->lower.state.cache, (n))
#define EXIT(b, n)          VECTOR_ELEM((b)->lower.exit.cache, (n))

#define CACHE_IS_NAA(b, r)  BITVEC_IS_SET((b)->lower.state.naa, REG_INDEX(r))
#define CACHE_SET_NAA(b, r) BITVEC_SET((b)->lower.state.naa, REG_INDEX(r))
#define CACHE_CLR_NAA(b, r) BITVEC_CLR((b)->lower.state.naa, REG_INDEX(r))

#define EXIT_IS_NAA(b, r)   BITVEC_IS_SET((b)->lower.exit.naa, REG_INDEX(r))

#endif /* LOWER_H */

/* vi: set ts=4 expandtab: */
