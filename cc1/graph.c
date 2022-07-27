/*****************************************************************************

  graph.c                                                 tahoe/64 c compiler

     Copyright (c) 2021, 2022 Charles E. Youse. see LICENSE for more details.

*****************************************************************************/

#include "cc1.h"
#include "opt.h"
#include "dom.h"
#include "live.h"
#include "reach.h"
#include "func.h"
#include "type.h"
#include "fuse.h"
#include "graph.h"

static VECTOR(reg) tmp_regs;
static VECTOR(reg) tmp2_regs;

DEFINE_VECTOR(node_ref, struct node *);

struct node
{
    int reg;        /* register as it appears in the IR */
    int color;      /* assigned machine reg, or REG_NONE */

    /* spill cost. invalid unless we need to spill a node, at which
       point this is used as an accumulator as costs are computed. */

    int cost;

    /* two nodes connected in the graph (read: which interfere)
       each have an edge entry pointing at the other. when a node
       is disconnected and put on the stack, its neighbors (which
       remain in the graph) remove their edges to the disconnected
       node, but the disconnected node retains `half-edges' to its
       erstwhile neighbors, so we know where to reconnect it. */

    VECTOR(node_ref) edges;

    /* when two nodes coalesce, one node is absorbed into the
       other. the absorbed node is kept solely as a marker to
       the node which absorbed it, which we point to here. */

    struct node *coalesced;

    /* when the node is in the graph, links to the next node in the
       hash bucket. when on the stack, links to the previous cell. */

    struct node *link;
};

#define NR_EDGES(n)     VECTOR_SIZE((n)->edges)
#define EDGE(n, m)      VECTOR_ELEM((n)->edges, (m))

/* a node can be in one of three states: if it's connected to the graph,
   then it is linked in the hash table (graph). if it's disconnected, it
   is on the stack. if the node has been absorbed by another node through
   coalescing, then it floats, neither in the hash table nor on the stack,
   but it may be referenced by disconnected nodes. */

static VECTOR(node_ref) graph;      /* indexed by REG_INDEX of node reg */
static struct node *stack;          /* top of disconnected node stack */

#define GRAPH(reg)  VECTOR_ELEM(graph, REG_INDEX(reg))

/* our aim is to have a K-colorable graph. (actually,
   we're really coloring two disjoint graphs at the
   same time, one for general-purpose regs and the
   other for floating-point regs, with different Ks). */

static VECTOR(reg) gp_colors;
static VECTOR(reg) xmm_colors;

#define GP_K    VECTOR_SIZE(gp_colors)
#define XMM_K   VECTOR_SIZE(xmm_colors)

/* attach node n to the graph */

static void put(struct node *n)
{
    int reg = n->reg;

    n->link = GRAPH(reg);
    GRAPH(reg) = n;
}

/* remove node n from the graph. */

static void get(struct node *n)
{
    struct node **p = &GRAPH(n->reg);

    while (*p != n) p = &(*p)->link;
    *p = n->link;
}

/* return the node in the graph associated
   with reg. if it isn't there, create will
   force a new one to be created, otherwise
   returns 0. */

static struct node *find(int reg, int create)
{
    struct node *n;

    n = GRAPH(reg);

    while (n && (n->reg != reg))
        n = n->link;

    if ((n == 0) && create) {
        ARENA_ALIGN(&local_arena, UNIVERSAL_ALIGN);
        n = ARENA_ALLOC(&local_arena, sizeof(struct node));
        __builtin_memset(n, 0, sizeof(struct node));
        INIT_VECTOR(n->edges, &local_arena);

        n->reg = reg;

        if (MACHINE_REG(reg))       /* nodes for machine */
            n->color = reg;         /* regs are precolored */

        put(n);
    }

    return n;
}

/* add a half edge from n1 to n2 */

static void add_half(struct node *n1, struct node *n2)
{
    int m;

    for (m = 0; m < NR_EDGES(n1); ++m)
        if (EDGE(n1, m) == n2)
            return; /* already there */

    GROW_VECTOR(n1->edges, 1);
    VECTOR_LAST(n1->edges) = n2;
}

/* remove half edge from n1 to n2 */

static void remove_half(struct node *n1, struct node *n2)
{
    int m;

    for (m = 0; m < NR_EDGES(n1); ++m)
        if (EDGE(n1, m) == n2) {
            VECTOR_DELETE(n1->edges, m, 1);
            break;
        }
}

/* disconnect node n from graph
   and push it on the stack */

static void push(struct node *n)
{
    int m;

    for (m = 0; m < NR_EDGES(n); ++m)
        remove_half(EDGE(n, m), n);

    get(n);
    n->link = stack;
    stack = n;
}

/* pop the top of the stack and reconnect it
   to the graph. returns the node popped. */

static struct node *pop(void)
{
    struct node *n;
    struct node *n2;
    int m;

    n = stack;
    stack = n->link;

again:

    /* if any node we connected to coalesced, we need to redraw
       the edge to the new node. this is tricky: because we might
       already have an edge to the new node, we can't just plug
       in the new pointer. we remove it and let add_half() dedup. */

    for (m = 0; m < NR_EDGES(n); ++m) {
        n2 = EDGE(n, m);

        if (n2->coalesced) {
            while (n2->coalesced)       /* follow the chain: the node it */
                n2 = n2->coalesced;     /* merged into might have merged */

            VECTOR_DELETE(n->edges, m, 1);  /* remove edge to old node */
            add_half(n, n2);                /* connect to new node */

            goto again;         /* no idea where m is anymore, start over */
        }
    }

    for (m = 0; m < NR_EDGES(n); ++m)   /* draw edges from the nodes */
        add_half(EDGE(n, m), n);        /* in the graph back to us */

    put(n);
    return n;
}

/* returns true if nodes n1 and n2 interfere. */

static int is_neighbor(struct node *n1, struct node *n2)
{
    int m;

    for (m = 0; m < NR_EDGES(n1); ++m)
        if (EDGE(n1, m) == n2)
            return 1;

    return 0;
}

/* build the interference graph. most
   of the work is done by range_interf(). */

static void build0(void)
{
    struct block *b;
    struct node *n1, *n2;
    int j, reg;
    int r;

    FOR_ALL_BLOCKS(b)
        for (r = 0; r < NR_RANGES(b); ++r)
            if (RANGE_HEAD(b, r)) {
                n1 = find(RANGE(b, r).reg, 1);

                TRUNC_VECTOR(tmp_regs);
                range_interf(b, r, &tmp_regs);

                FOR_EACH_REG(tmp_regs, j, reg) {
                    n2 = find(reg, 1);
                    add_half(n1, n2);
                    add_half(n2, n1);
                }
            }
}

/* try to merge/coalesce two nodes. we do this conservatively,
   only merging nodes if their combination would have fewer
   than K neighbors of significant degree, per briggs. there
   are other restrictions; see the comments for the tests.

   returns true on success, false on failure. */

static struct node dummy;

static int merge0(int r1, int r2)
{
    struct node *n1 = find(r1, 0);
    struct node *n2 = find(r2, 0);
    int nr_sigs;
    int m;
    int k = REG_GP(r1) ? GP_K : XMM_K;

    if (!n1 || !n2) return 0;   /* can't merge any disconnected nodes */
    if (n1 == n2) return 0;     /* can't merge any node with itself */
    if (is_neighbor(n1, n2)) return 0;      /* or nodes that interfere */

    if (MACHINE_REG(n1->reg) && MACHINE_REG(n2->reg))   /* or two machine */
        return 0;                                       /* regs together */

    if (MACHINE_REG(n2->reg))           /* if machine reg is present, */
        SWAP(struct node *, n1, n2);    /* make sure we merge into it */

    /* if merging two non-machine nodes, the nodes may have different types
       (though they will be in the same cast class, of course). in that case,
       we must merge into the larger of the two, since no appearance of a reg
       in the IR can have a size larger than its associated symbol's type. */

    if (!MACHINE_REG(n1->reg) && !MACHINE_REG(n2->reg)
      && (size_of(REG_TO_SYMBOL(n2->reg)->type, 0) >
          size_of(REG_TO_SYMBOL(n1->reg)->type, 0)))
    {
        SWAP(struct node *, n1, n2);
    }

    /* now, populate our dummy node with the union of
       edges from the proposed merged nodes, and count
       how many significant neighbors it would have. */

    TRUNC_VECTOR(dummy.edges);
    DUP_VECTOR(dummy.edges, n1->edges);

    for (m = 0; m < NR_EDGES(n2); ++m)
        add_half(&dummy, EDGE(n2, m));

    for (nr_sigs = 0, m = 0; m < NR_EDGES(&dummy); ++m)
        if (NR_EDGES(EDGE(&dummy, m)) > k)
            ++nr_sigs;

    if (nr_sigs >= k) return 0;     /* too many for briggs */

    /* looks good, let's merge the nodes.
       move the neighbors from n2 to n1. */

    for (m = 0; m < NR_EDGES(n2); ++m) {
        remove_half(EDGE(n2, m), n2);

        if (EDGE(n2, m) != n1) {
            add_half(n1, EDGE(n2, m));
            add_half(EDGE(n2, m), n1);
        }
    }

    substitute_reg(n2->reg, n1->reg);   /* n2->reg is gone */
    n2->coalesced = n1;                 /* leave a breadcrumb */
    TRUNC_VECTOR(n2->edges);            /* (just to be tidy) */
    get(n2);                            /* and remove from the graph */

    return 1;   /* success */
}

/* coalescing pass. starting with the innermost loops, we find candidates
   for coalescing and pass these to merge0() for possible coalescing. we
   repeat exhaustively until nothing can be coalesced, and return the
   number of nodes merged. */

static int coalesce0(void)
{
    struct block *b;
    struct insn *insn;
    int total;
    int src, dst;
    int depth;
    int i;

    total = 0;

restart:
    /* first, we try to merge classic copy insns. these are
       always the best candidates since the copies disappear. */

    for (depth = loop_max_depth; depth >= 0; --depth)
        FOR_ALL_BLOCKS(b) {
            if (b->loop_depth != depth) continue;

            FOR_EACH_INSN(b, i, insn)
                if (insn_is_copy(insn, &dst, &src))
                    if (dst == src) {
                        /* earlier merges can create self-copies
                           in oblique ways. pruning would take
                           care of these eventually, but might
                           as well clean up after ourselves ... */

                        INSN(b, i) = &nop_insn;
                    } else if (merge0(dst, src)) {
                        INSN(b, i) = &nop_insn;
                        goto success;
                    }

        }

    /* next, we look for LEAx that are really three-address
       additions. if we can merge one of the src regs with
       the dst, it'll degenerate to ADDx or SHLx. */

    for (depth = loop_max_depth; depth >= 0; --depth)
        FOR_ALL_BLOCKS(b) {
            if (b->loop_depth != depth) continue;

            FOR_EACH_INSN(b, i, insn) {
                struct operand *src;
                struct operand *dst;

                switch (insn->op)
                {
                case I_MCH_LEAB:
                case I_MCH_LEAW:
                case I_MCH_LEAL:
                case I_MCH_LEAQ:    break;
                default:            continue;
                }

                dst = &insn->operand[0];
                src = &insn->operand[1];

                if (src->index == 0)
                {
                    /* LEA c(%reg), %reg */

                    if (merge0(src->reg, dst->reg))
                        goto success;
                }

                if ((src->con.i == 0) && (src->sym == 0)) {
                    if (src->reg == REG_NONE)
                    {
                        /* LEA (,%reg,n), %reg */

                        if (merge0(src->index, dst->reg))
                            goto success;
                    }

                    if (src->index && (src->scale == 0))
                    {
                        /* LEA (%reg,%reg), %reg */

                        if (merge0(src->reg, dst->reg)
                          || merge0(src->index, dst->reg))
                            goto success;
                    }
                }
            }
        }

    /* finally, try to merge the source/destination of casts. (among other
       things, this helps us eliminate them later if they are unnecessary.) */

    for (depth = loop_max_depth; depth >= 0; --depth)
        FOR_ALL_BLOCKS(b) {
            if (b->loop_depth != depth) continue;

            FOR_EACH_INSN(b, i, insn) {
                struct operand *src;
                struct operand *dst;

                switch (insn->op)
                {
                case I_MCH_MOVZBW: case I_MCH_MOVZBL: case I_MCH_MOVZBQ:
                case I_MCH_MOVSBW: case I_MCH_MOVSBL: case I_MCH_MOVSBQ:
                case I_MCH_MOVZWL: case I_MCH_MOVZWQ: case I_MCH_MOVSWL:
                case I_MCH_MOVSWQ: case I_MCH_MOVZLQ: case I_MCH_MOVSLQ:

                case I_MCH_CVTSS2SD:
                case I_MCH_CVTSD2SS:   break;

                default:                continue;
                }

                dst = &insn->operand[0];
                src = &insn->operand[1];

                if (!OPERAND_REG(dst) || !OPERAND_REG(src))
                    continue;

                if (merge0(dst->reg, src->reg)) goto success;
            }
        }

    return total;

success:
    ++total;
    goto restart;
}

#ifdef DEBUG

static void out_graph(void)
{
    struct node *n;
    int i, m;

    for (i = 0; i < nr_assigned_regs; ++i) {
        n = VECTOR_ELEM(graph, i);

        while (n) {
            out("# %r interf", n->reg);

            for (m = 0; m < NR_EDGES(n); ++m)
                out(" %r", EDGE(n, m)->reg);

            out(" (%d)\n", n->cost);

            n = n->link;
        }
    }
}

#endif /* DEBUG */

/* compute the spill costs for all pseudo-register nodes
   and return the lowest-cost node. we compute the cost
   of spilling a node as the sum of the cost of each USE
   or DEF of the pseudo-register, where each USE of DEF
   is scaled by 64 * 2^(loop depth), then we divide that
   by the number of neighbors the node has. */

#define COST0(uses)                                                         \
    do {                                                                    \
        int j, reg;                                                         \
                                                                            \
        TRUNC_VECTOR(tmp_regs);                                             \
        insn_##uses(insn, &tmp_regs, 0);                                    \
                                                                            \
        FOR_EACH_REG(tmp_regs, j, reg) {                                    \
            if (MACHINE_REG(reg)) continue;                                 \
                                                                            \
            n = find(reg, 0);                                               \
            n->cost += 1 * (64 << b->loop_depth);                           \
        }                                                                   \
    } while (0)

static struct node *cost0(void)
{
    struct node *n;
    struct block *b;
    struct insn *insn;
    struct node *lowest;
    int i, reg;

    FOR_ALL_BLOCKS(b) {
        FOR_EACH_INSN(b, i, insn) {
            COST0(uses);    /* count USEs and */
            COST0(defs);    /* DEFs separately */
        }
    }

    lowest = 0;

    for (i = NR_MACHINE_REGS; i < nr_assigned_regs; ++i) {
        reg = 0;
        REG_SET_INDEX(reg, i);
        if (REG_TO_SYMBOL(reg)->s & S_NOSPILL) continue;

        for (n = GRAPH(reg); n; n = n->link) {
            n->cost /= NR_EDGES(n) + 1; /* +1 avoids /0 */

            if ((lowest == 0) || (n->cost < lowest->cost))
                lowest = n;
        }
    }

    return lowest;
}

/* we need to spill a web. pick the one with the lowest spill cost (above).
   we spill the entire web, inserting loads and stores using a new temporary
   we allocate here. we don't re-use the pseudo-reg being spilled or its
   storage (if it has any), which is suboptimal, as that's often possible.
   we would need to constrain coalescing to make that safe; we'll need to
   determine, empirically, if it's worth the effort to make that happen. */

static void spill0(void)
{
    struct block *b;
    struct insn *insn;
    struct node *n;
    struct operand reg;
    struct operand addr;
    struct symbol *sym;
    long t;
    int old, new;
    int i;

    n = cost0();
    old = n->reg;

    /* allocate a temporary for the inserted loads and stores.
       we perform all loads and stores using the type of the
       node's underlying symbol, which is guaranteed to be 
       large enough. build its frame address into addr. */

    sym = temp(REG_TO_SYMBOL(old)->type);
    new = symbol_to_reg(sym);
    t = TYPE_BASE(sym->type);
    REG_OPERAND(&reg, 0, t, new);
    BASED_OPERAND(&addr, 0, t, O_MEM, REG_RBP, symbol_offset(sym));
    sym->s |= S_NOSPILL; /* automatically disqualified */

    /* now replace all occurrences of the spilled reg old with
       new, inserting load-before-use and store-after-def insns.
       we are careful to do these loads and stores using the size
       of the reg's use or def, to enable fusing where possible */

    FOR_ALL_BLOCKS(b) {
        FOR_EACH_INSN(b, i, insn) {
            TRUNC_VECTOR(tmp_regs);             /* remember if the */
            insn_uses(insn, &tmp_regs, 0);      /* insn USEs the reg */

            /* if the insn DEFs the reg, insert a store afterward.
               if the reg is an update operand, this might also
               substitute out the only USE, hence the above */

            if (insn_substitute_reg(insn, old, new, INSN_SUBSTITUTE_DEFS))
                insert_insn(move(t, &addr, &reg), b, i + 1);

            /* if the insn USEs the reg, insert a load beforehand. if
               this fails, but we know the insn USEd the reg, it is an
               update operand, and we want the type from the DEF operand. */

            insn_substitute_reg(insn, old, new, INSN_SUBSTITUTE_USES);

            if (contains_reg(&tmp_regs, old)) {
                insert_insn(move(t, &reg, &addr), b, i);
                ++i;  /* we moved the current insn, don't re-examine it */
            }
        }

        if (SWITCH_BLOCK(b)             /* spilling the reg used as */
          && OPERAND_REG(&b->control)   /* the branch target would be */
          && (b->control.reg == old))   /* stupid, but it's possible, so .. */
        {
            append_insn(move(t, &reg, &addr), b);
            b->control.reg = new;
        }
    }
}

/* conventional Chaitin simplification. find a node with degree
   less than K, disconnect it from the graph and put it on the stack.
   repeat exhaustively. returns true if the graph is empty (except 
   for precolored nodes), or false if it can't proceed further. */

static int simplify0(void)
{
    struct node *n;
    struct node *next;

    int success;
    int failure;
    int i;

    do {
        success = 0;
        failure = 0;

        for (i = NR_MACHINE_REGS; i < nr_assigned_regs; ++i)
            for (n = VECTOR_ELEM(graph, i); n; n = next) {
                next = n->link;

                if (NR_EDGES(n) < (REG_GP(n->reg) ? GP_K : XMM_K)) {
                    push(n);
                    ++success;
                } else
                    ++failure;
            }
    } while (success);

    return !failure;
}

/* optimistic simplication. simplify0() has failed and coalesce0()
   could not help, so we need to gamble and pick a node to push in
   the hope that when its turn comes, we'll find a color for it. we
   choose the node with the lowest degree. there are perhaps better
   heuristics, we'll have to see. */

static void optimist0(void)
{
    struct node *choice;
    struct node *n;
    int i;

    choice = 0;

    for (i = NR_MACHINE_REGS; i < nr_assigned_regs; ++i)
        for (n = VECTOR_ELEM(graph, i); n; n = n->link)
            if ((choice == 0) || (NR_EDGES(choice) > NR_EDGES(n)))
                choice = n;

    push(choice);
}

/* attempt to color the graph. pop a node from the stack and try to
   color it distinctly from its neighbors. rinse and repeat until the
   stack is empty, and return true; if we can't color a node, false. */

static int select0(void)
{
    struct node *n;
    int m;

    while (stack) {
        n = pop();

        /* colors used by neighbors -> tmp_regs */

        TRUNC_VECTOR(tmp_regs);

        for (m = 0; m < NR_EDGES(n); ++m)
            add_reg(&tmp_regs, EDGE(n, m)->color);

        /* colors NOT used by neighbors -> tmp2_regs */

        diff_regs(&tmp2_regs,
                  REG_GP(n->reg) ? &gp_colors : &xmm_colors,
                  &tmp_regs);

        /* if there are no colors... we failed
           and are disappointments to ourselves,
           our families and our communities */

        if (EMPTY_VECTOR(tmp2_regs)) return 0;

        /* assign the first available color */

        n->color = VECTOR_ELEM(tmp2_regs, 0);
    }

    return 1;
}

/* we've successfully found a coloring, make it permanent. */

static void marker0(void)
{
    struct node *n;
    int i;

    for (i = NR_MACHINE_REGS; i < nr_assigned_regs; ++i)
        for (n = VECTOR_ELEM(graph, i); n; n = n->link)
            substitute_reg(n->reg, n->color);
}

void color(void)
{
    int i;

    /* convert registers to allocatable webs. once we've started
       coalescing, we're committed and can't undecorate; all opts
       invoked after this point must properly handle decorated CFGs. */

    reach_analyze(REACH_ANALYZE_WEBS);

retry:
    dom_analyze(DOM_ANALYZE_LOOP);      /* for spill/coalescing choices */
    live_analyze(LIVE_ANALYZE_REGS);    /* for building interference graph */

    /* TODO. if any regs appear LIVE IN to the entry_block,
       we should request an OPT_MCH_UNDEF pass to insert
       fake DEFs to reduce the spans of the webs. */

    /* compute sets of colors available to the allocator.
       currently these sets are static and could be computed
       once and for all, but we do it dynamically in case we
       decide (one day) to, e.g., allow REG_RBP to be used
       when we don't need it as a frame pointer. rainy day. */

    INIT_VECTOR(gp_colors, &local_arena);
    INIT_VECTOR(xmm_colors, &local_arena);

    for (i = 0; i < NR_GP_REGS; ++i)
        if ((REG(i) != REG_RSP) && (REG(i) != REG_RBP))
            add_reg(&gp_colors, REG(i));

    for (i = 0; i < NR_XMM_REGS; ++i)
        add_reg(&xmm_colors, REG(NR_GP_REGS + i));

    stack = 0;                                  /* empty stack */

    INIT_VECTOR(graph, &local_arena);           /* initialize hash table */
    RESIZE_VECTOR(graph, nr_assigned_regs);
    MEMSET_VECTOR(graph, 0);

    INIT_VECTOR(tmp_regs, &local_arena);
    INIT_VECTOR(tmp2_regs, &local_arena);
    INIT_VECTOR(dummy.edges, &local_arena);

    build0();
    coalesce0();

    while (simplify0() == 0) {
        if (coalesce0()) continue;
        optimist0();
    }

    if (select0() == 0) {
        while (stack) pop();        /* cost0() needs all nodes in graph */
        spill0();                   /* pick a web and spill it */
        ARENA_FREE(&local_arena);   /* and prepare to start over */

        /* the primary purpose of this pass of optimizations is
           to fuse any spill insns; n.b. all passes invoked here
           must be prepared to handle the decorated CFG. */

        opt(OPT_MCH_PASSES | OPT_ANY_PASSES, OPT_LIR_PASSES);
        goto retry;
    }

    marker0();
    ARENA_FREE(&local_arena);
}

/* vi: set ts=4 expandtab: */
