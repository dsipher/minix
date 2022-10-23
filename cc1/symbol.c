/*****************************************************************************

   symbol.c                                               ux/64 c compiler

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

#include <stdio.h>
#include "cc1.h"
#include "lex.h"
#include "reg.h"
#include "type.h"
#include "func.h"
#include "string.h"
#include "block.h"
#include "symbol.h"

/* the symbol table is a hash table (surprise) based on the
   id hash value. we keep an additional bucket for anonymous
   symbols since they mostly get in the way. each bucket is
   layered by scope, outermost symbols first. */

#define NR_SYMTAB_BUCKETS       (1 << LOG2_NR_SYMTAB_BUCKETS)
#define ANON_BUCKET             NR_SYMTAB_BUCKETS

#define BUCKET(id)              ((id) ? ((id)->hash % NR_SYMTAB_BUCKETS)    \
                                      : ANON_BUCKET)

static struct symbol *symtab[NR_SYMTAB_BUCKETS + 1];

/* remove a symbol from its bucket. this ability to quickly yank a
   symbol out of the table is the primary reason we doubly-link them */

#define REMOVE(sym)                                                         \
    do {                                                                    \
        struct symbol *_sym = (sym);                                        \
        if (_sym->next) _sym->next->prev = _sym->prev;                      \
        *_sym->prev = _sym->next;                                           \
    } while (0)

/* insert a symbol into a bucket/member list, either at the head of the list
   (if symp = &head), or after an existing element (if symp = &elem->next). */

#define INSERT(symp, sym)                                                   \
    do {                                                                    \
        struct symbol **_symp = (symp);                                     \
        struct symbol *_sym = (sym);                                        \
        _sym->prev = _symp;                                                 \
        _sym->next = *_symp;                                                \
        if (*_symp) (*_symp)->prev = &_sym->next;                           \
        *_symp = _sym;                                                      \
    } while (0)

/* in addition to the current_scope, we maintain outer_scope, which is the
   nearest-enclosing non-strun scope, and strun_scopes, a set of flag bits
   indicating which scopes have been opened for a struct/union definition.
   strun scopes do not nest logically, but they nest in the symbol table. */

int current_scope;      /* initial value == 0 == LURKER_SCOPE */
int outer_scope;

#define SCOPE_BIT(sc)                   (1L << (sc))
#define CLEAR_STRUN_SCOPE(scopes, sc)   ((scopes) &= ~SCOPE_BIT(sc))
#define SET_STRUN_SCOPE(scopes, sc)     ((scopes) |= SCOPE_BIT(sc))
#define IS_STRUN_SCOPE(scopes, sc)      (((scopes) & SCOPE_BIT(sc)) != 0)

static long strun_scopes;

/* in every scope we maintain a chain of symbols declared in that scope, in
   the order they are declared. LURKER_SCOPE is exempt; because lurkers can
   be promoted to file scope, there's no simple way to maintain its chain. */

static struct symbol *chains[NR_SCOPES];
static struct symbol **linkp[NR_SCOPES];

static SLAB_DEFINE(symbol, 100);

struct symbol *new_symbol(struct string *id, int s)
{
    static int last_num;
    struct symbol *sym;

    sym = SLAB_ALLOC(symbol);
    memset(sym, 0, sizeof(*sym));

    sym->id = id;
    sym->s = s;
    sym->num = ++last_num;
    HERE_SYMBOL(sym);

    return sym;
}

/* we usually return symbols to the slab for re-use, but we never discard
   S_TAG symbols because scope holes in c mean references may outlive the
   tag's scope. instead, their members are discarded and they become undead */

static struct symbol *zombies;
static int nr_zombies;  /* statistic */

void free_symbols(struct symbol **chainp)
{
    struct symbol *sym;

    while (sym = *chainp) {
        *chainp = (*chainp)->link;

        if (sym->s & S_TAG) {
            free_symbols(&sym->chain);
            sym->link = zombies;
            zombies = sym;
            ++nr_zombies;
        } else
            SLAB_FREE(symbol, sym);
    }
}

/* iterate through the bucket until we've found the right scope.
   then insert the symbol, and link it to the end of the chain. */

void insert(struct symbol *sym, int scope)
{
    struct symbol **symp;

    sym->scope = scope;

    for (symp = &symtab[BUCKET(sym->id)];
         *symp && ((*symp)->scope > scope);
         symp = &(*symp)->next) ;

    INSERT(symp, sym);

    if (scope != LURKER_SCOPE) {
        *linkp[scope] = sym;
        linkp[scope] = &sym->link;
    }
}

/* if an entry already exists in scope, then it
   already refers to sym: otherwise is impossible
   (modulo bugs), so no need to check */

void redirect(struct symbol *sym, int scope)
{
    struct symbol *old, *new;

    old = lookup(sym->id, S_REDIRECT, scope, scope);

    if (old == 0) {
        new = new_symbol(sym->id, S_REDIRECT);
        new->redirect = sym;
        insert(new, scope);
    }
}

struct symbol *lookup(struct string *id, int ss, int inner, int outer)
{
    struct symbol *sym, *next;
    long scopes;

    if (inner == outer)
        scopes = 0;         /* ignore strun_scopes */
    else
        scopes = strun_scopes;

    for (sym = symtab[BUCKET(id)]; sym; sym = next) {
        next = sym->next;

        if (sym->scope < outer) break;
        if (sym->scope > inner) continue;
        if (IS_STRUN_SCOPE(scopes, sym->scope)) continue;
        if (sym->id != id) continue;

        if (sym->s & S_REDIRECT) sym = sym->redirect;
        if (sym->s & ss) return sym;
    }

    return 0;
}

/* when looking up a member, we use the members list, rather than the
   chain. when we find a member, we shuffle it to the front. for very
   large structures there should be some locality of reference and we
   save ourselves time and cache-clobbering. for smaller structures,
   this slows us down, but negligibly */

struct symbol *lookup_member(struct string *id, struct symbol *tag)
{
    struct symbol *member;

    for (member = tag->members; member; member = member->next)
        if (member->id == id) {
            REMOVE(member);
            INSERT(&tag->members, member);
            return member;
        }

    error(ERROR, id, "no such member in %T", tag);
}

struct tnode *named_type(struct string *id)
{
    struct symbol *sym;

    sym = lookup(id, S_NORMAL, outer_scope, FILE_SCOPE);

    if (sym && (sym->s & S_TYPEDEF))
        return sym->type;
    else
        return 0;
}

/* if a global with the given id already exists, we need to be sure
   the new declaration's storage class makes sense, and absorb any
   new type information it provided. then if the declaration exposes
   a lurker, then it's not a lurker anymore.

   if no such global already exists, we make a new entry at scope.

   should only be called with s == S_STATIC or S_EXTERN. */

struct symbol *global(struct string *id, int s,
                      struct tnode *type, int scope)
{
    struct symbol *sym;
    int ss;

    sym = lookup(id, S_EXTERN | S_STATIC, FILE_SCOPE, LURKER_SCOPE);

    if (sym) {
        if ((sym->s & S_EXTERN) && (s & S_STATIC))
            error(ERROR, id, "previously declared non-static");

        sym->type = compose(sym->type, type, sym);

        if (scope > sym->scope) {
            /* only happens when scope == FILE_SCOPE and
               sym->scope == LURKER_SCOPE, i.e., this is
               a file-scope declaration for an erstwhile
               lurker, so we promote it to file scope. */

            REMOVE(sym);
            insert(sym, FILE_SCOPE);
        }
    } else {
        sym = new_symbol(id, s);
        sym->type = type;
        insert(sym, scope);
    }

    return sym;
}

/* we make sure the fixed scope data is clean upon
   entry rather than cleaning it up properly on exit */

void enter_scope(int strun)
{
    if (++current_scope == NR_SCOPES) /* really? */
        error(SORRY, 0, "scope nesting too deep");

    chains[current_scope] = 0;
    linkp[current_scope] = &chains[current_scope];

    if (strun)
        SET_STRUN_SCOPE(strun_scopes, current_scope);
    else {
        CLEAR_STRUN_SCOPE(strun_scopes, current_scope);
        outer_scope = current_scope;
    }
}

void walk_scope(int scope, int ss, void f(struct symbol *))
{
    struct symbol *sym;

    for (sym = chains[scope]; sym; sym = sym->link)
        if (sym->s & ss) f(sym);
}

void exit_scope(struct symbol **chainp)
{
    struct symbol *sym;

    for (sym = chains[current_scope]; sym; sym = sym->link) REMOVE(sym);

    if (chainp) {
        *linkp[current_scope] = *chainp;    /* append caller's symbols */
        *chainp = chains[current_scope];    /* and give caller entire chain */
    } else
        free_symbols(&chains[current_scope]);

    /* if exiting an outer scope, we have
       to leapfrog any strun scopes */

    if (outer_scope == current_scope) {
        do --outer_scope;
        while (IS_STRUN_SCOPE(strun_scopes, outer_scope));
    }

    --current_scope;
}

void reenter_scope(struct symbol **chainp)
{
    struct symbol *tmp;

    enter_scope(0);

    while (*chainp) {
        tmp = (*chainp)->link;
        insert(*chainp, outer_scope);
        *chainp = tmp;
    }
}

void unique(struct string *id, int ss, int scope, struct symbol *tag)
{
    struct symbol *sym;

    if (id && (sym = lookup(id, ss, scope, scope))) {
        switch (ss & (S_ARG | S_MEMBER))
        {
        case S_ARG:
            error(ERROR, id, "duplicate argument identifier");

        case S_MEMBER:
            error(ERROR, id, "already declared in %T %L", tag, sym);

        default:
            error(ERROR, id, "already declared in this scope %L", sym);
        }
    }
}

/* absorb the members of src into dst (corresponding to the current_scope)
   at the specified offset. in other words, we make the named members of
   src visible directly from the context of dst. we mark them S_SKIP since
   they are aliases of existing members, not members themselves. */

static void absorb(struct symbol *dst, struct symbol *src, int offset)
{
    struct symbol *member;
    struct symbol *new;

    for (member = src->chain; member; member = member->link) {
        if (member->id) {
            unique(member->id, S_MEMBER, current_scope, dst);
            new = new_symbol(member->id, S_MEMBER | S_SKIP);
            new->type = member->type;
            new->offset = member->offset + offset;
            insert(new, current_scope);
        }
    }
}

/* most of the work here is aimed at computing the right offset for the
   member. this would be significantly cleaner in the absence of bitfields.
   the caller has already determined that the id/type pair are valid for a
   struct/union member, but we need to ensure that it's valid in context. */

void insert_member(struct symbol *tag, struct string *id, struct tnode *type)
{
    int type_bits;      /* number of bits in type (host type if bitfield) */
    int member_bits;    /* number of bits in type (width if bitfield) */
    int align_bytes;            /* alignment of type */
    long offset_bits;           /* working offset in tag */
    int member_offset;          /* where to put the member */
    struct symbol *member;

    unique(id, S_MEMBER, current_scope, tag);
    align_bytes = align_of(type);
    tag->align = MAX(tag->align, align_bytes);
    offset_bits = (tag->s & S_UNION) ? 0 : tag->size;

    if (tag->s & S_FLEXIBLE)
        error(ERROR, id, "no members allowed after flexible array");

    if (IMMUTABLE_TYPE(type)) tag->s |= S_IMMUTABLE;

    if (UNBOUNDED_ARRAY_TYPE(type)) {
        type_bits = 0;
        tag->s |= S_FLEXIBLE;

        /* C99 6.7.2.1 says that flexible array members can only
           be the 'last member of a structure with more than one
           named member', though the rationale is unclear. since
           the flexible member itself must be named, and must be
           last, this is equivalent to saying at least one named
           member must be declared before the flexible array. */

        if (chains[current_scope] == 0)
            error(ERROR, id, "flexible array is first named member");
    } else
        type_bits = size_of(type, 0) * BITS_PER_BYTE;

    if (FIELD_TYPE(type)) {
        member_bits = FIELD_WIDTH(type);

        /* alignment fields and fields which straddle host words
           force alignment to the next host word boundary */

        if ((member_bits == 0) || (ROUND_DOWN(offset_bits, type_bits)
          != ROUND_DOWN(offset_bits + member_bits - 1, type_bits)))
            offset_bits = ROUND_UP(offset_bits, type_bits);

        type = fieldify(type, member_bits, offset_bits % type_bits);
    } else {
        offset_bits = ROUND_UP(offset_bits, align_bytes * BITS_PER_BYTE);
        member_bits = type_bits;
    }

    member_offset = ROUND_DOWN(offset_bits / BITS_PER_BYTE, align_bytes);

    if (tag->s & S_UNION)
        tag->size = MAX(tag->size, member_bits);
    else {
        offset_bits += member_bits;
        tag->size = offset_bits;
    }

    if (offset_bits > (MAX_TYPE_BYTES * BITS_PER_BYTE))
        error(SORRY, 0, "%T exceeds maximum struct/union size", tag);

    if (id == 0) {
        if (ANONYMOUS_STRUN_TYPE(type))
            absorb(tag, type->tag, member_offset);
        else
            return;  /* don't bother to keep other anonymous fields */
    }

    member = new_symbol(id, S_MEMBER);
    member->id = id;
    member->type = type;
    member->offset = member_offset;
    insert(member, current_scope);
}

/* C89 says that a structure or union containing only unnamed
   members is undefined behavior. we call it an error, for our
   convenience, since, if:

        1. all structs/unions must have at least one named member, and
        2. the only anonymous members recorded in the symbol table are
           themselves structs/unions (see logic in insert_member()),

   then it follows that if a struct or union has any recorded members
   at all, then it has at least one named member. (proof by induction.)
   this is why the test chains[current_scope] == 0 works here, but also
   in insert_member() when enforcing flexible array member rules. */

void exit_strun(struct symbol *tag)
{
    struct symbol *sym;
    long offset_bits;

    if (chains[current_scope] == 0)
        error(ERROR, 0, "%T has no named members", tag);

    exit_scope(&tag->chain);

    for (sym = tag->chain; sym; sym = sym->link)
        INSERT(&tag->members, sym);

    if (tag->size == 0)
        error(ERROR, 0, "%T has zero size", tag);

    /* no check for overflow on alignment since MAX_TYPE is
       a multiple of the maximum alignment restriction (8) */

    tag->size = ROUND_UP(tag->size, tag->align * BITS_PER_BYTE);
    tag->size /= BITS_PER_BYTE;
    tag->s |= S_DEFINED;
}

/* labels have function-wide scope so they all live in LOCAL_SCOPE.
   when we create a new label, we create its target block as well;
   the parser will switch into that block when the label is defined. */

struct symbol *lookup_label(struct string *id)
{
    struct symbol *label;

    label = lookup(id, S_LABEL, LOCAL_SCOPE, LOCAL_SCOPE);

    if (label == 0) {
        label = new_symbol(id, S_LABEL);
        label->b = new_block();
        insert(label, LOCAL_SCOPE);
    }

    return label;
}

static void check0(struct symbol *label)
{
    if (!DEFINED_SYMBOL(label))
        error(ERROR, label->id, "label never defined (%L)", label);
}

void check_labels(void)
{
    walk_scope(LOCAL_SCOPE, S_LABEL, check0);
}

/* we don't put anonymous symbols in the symbol table,
   because they would linger forever if they were used
   outside a function, and we have no need to look them
   up in the traditional sense (they're anonymous). so
   keep them in this corner and purge them occasionally. */

static struct symbol *anons;

struct symbol *anon_static(struct tnode *type, int asmlab)
{
    struct symbol *sym;

    /* don't hand out duplicates. when sym1 != sym2,
       some code will assume they are distinct globals */

    for (sym = anons; sym; sym = sym->link)
        if ((sym->asmlab == asmlab)
          && (sym->type == type))
            return sym;

    sym = new_symbol(0, S_STATIC);
    sym->type = type;
    sym->asmlab = asmlab;

    sym->link = anons;
    anons = sym;

    return sym;
}

void purge_anons(void) { free_symbols(&anons); }

struct symbol *implicit(struct string *id)
{
    struct tnode *type;
    struct symbol *sym;

    type = get_tnode(T_FUNC | T_OLD_STYLE, 0, &int_type);
    sym = global(id, S_EXTERN, type, LURKER_SCOPE);

    if (!(sym->s & S_IMPLICIT)) {
        error(WARNING, id, "implicit function declaration");
        sym->s |= S_IMPLICIT;
    }

    return sym;
}

void registerize(struct symbol **chainp)
{
    struct symbol *sym;

    for (sym = *chainp; sym; sym = sym->link)
        if (sym->s & S_LOCAL) {
            sym->s &= ~S_LOCAL;
            sym->s |= S_REGISTER;
        }
}

/* register assignment starts over with each new function. to avoid walking
   the symbol table to unassign the regs for all non-locals each time, bump
   the generation number and use that to detect stale assignments. */

int reg_generation;

int symbol_to_reg(struct symbol *sym)
{
    if (sym->generation < reg_generation) {
        sym->reg = assign_reg(sym);
        sym->generation = reg_generation;
    }

    return sym->reg;
}

int symbol_offset(struct symbol *sym)
{
    if (sym->offset == 0)
        sym->offset = frame_alloc(sym->type);

    return sym->offset;
}

void print_global(FILE *fp, struct symbol *sym)
{
    if ((sym->scope <= FILE_SCOPE) && sym->id) {
        /* only named symbols at global scope get
           to keep their names in the output */

        fprintf(fp, "_" STRING_FMT, STRING_ARG(sym->id));
    } else {
        /* everyone else is referred to by asmlab,
           assigned here on demand if not already. */

        if (sym->asmlab == 0) sym->asmlab = ++last_asmlab;
        fprintf(fp, ASMLAB_FMT, sym->asmlab);
    }
}

/* we can't use walk_scope() because the LURKER_SCOPE chain isn't maintained;
   we must scan the whole symbol table instead. this is no big deal, since the
   only symbols still in the table now are in LURKER_SCOPE..FILE_SCOPE, which
   is precisely the set of symbols we wish to inspect */

void out_globls(void)
{
    struct symbol *sym;
    int b;

    OUTC('\n');

    for (b = 0; b < NR_SYMTAB_BUCKETS; ++b)
        for (sym = symtab[b]; sym; sym = sym->next)
            if ((sym->s & S_EXTERN) && (sym->s & (S_REFERENCED | S_DEFINED)))
                out(".globl %g\n", sym);
}

#ifdef DEBUG

void dump_symbol(struct symbol *sym)
{
    static struct { int s; char *text; } bits[] =
    {
        S_STRUCT,       "struct",       S_UNION,        "union",
        S_ENUM,         "enum",         S_TYPEDEF,      "typedef",
        S_STATIC,       "static",       S_EXTERN,       "extern",
        S_AUTO,         "auto",         S_REGISTER,     "register",
        S_LOCAL,        "local",        S_CONST,        "const",
        S_REDIRECT,     "redirect",     S_MEMBER,       "member",
        S_LABEL,        "label",        S_HIDDEN,       "hidden",
        S_TEMP,         "temp",         S_IMMUTABLE,    "immutable",
        S_IMPLICIT,     "implicit",     S_FIXFLOAT,     "fixfloat",
        S_SKIP,         "skip",         S_FLEXIBLE,     "flexible",
        S_ARG,          "arg",          S_TENTATIVE,    "tentative",
        S_REFERENCED,   "referenced",   S_DEFINED,      "defined"
    };

    struct symbol *member;
    int i;

    fprintf(stderr, "%d (%p) #%d ", sym->scope, sym, sym->num);
    if (sym->id) fprintf(stderr, "`" STRING_FMT "' ", STRING_ARG(sym->id));

    fputs("[ ", stderr);

    for (i = 0; i < ARRAY_SIZE(bits); ++i)
        if (sym->s & bits[i].s)
            fprintf(stderr, "%s ", bits[i].text);

    fputs("] ", stderr);

    if (TAG_SYMBOL(sym)) {
        if (DEFINED_SYMBOL(sym)) {
            fprintf(stderr, "size=%d align=%d", sym->size, sym->align);

            for (member = sym->chain; member; member = member->link) {
                fprintf(stderr, "\n\t@ %d ", member->offset);

                if (member->id)
                    fprintf(stderr, "`" STRING_FMT "' ",
                                    STRING_ARG(member->id));

                dump_type(member->type);
                if (member->s & S_SKIP) fputs(" SKIP", stderr);
            }
        }
    } else {
        dump_type(sym->type);

        switch (S_BASE(sym->s))
        {
        case S_CONST:   fprintf(stderr, "value=%d", sym->value);
        }
    }

    putc('\n', stderr);
}

void dump_symbols(struct symbol **chainp)
{
    struct symbol *sym = *chainp;

    while (sym) {
        dump_symbol(sym);
        sym = sym->link;
    }
}

void dump_scope(int scope)
{
    dump_symbols(&chains[scope]);
}

void dump_symtab(void)
{
    struct symbol *sym;
    int total = 0;
    int b;

    fputs("===== SYMBOL TABLE =====\n\n", stderr);

    for (b = 0; b < NR_SYMTAB_BUCKETS; ++b) {
        if (symtab[b]) {
            fprintf(stderr, "BUCKET %d\n", b);

            for (sym = symtab[b]; sym; sym = sym->next, ++total)
                dump_symbol(sym);
        }
    }

    if (nr_zombies) {
        fprintf(stderr, "ZOMBIES\n");
        dump_symbols(&zombies);
    }

    fprintf(stderr, "\n%d total symbols / %d zombies",
                    total + nr_zombies, nr_zombies);

    fprintf(stderr, " (" SLAB_STATS_FMT ")\n", SLAB_STATS_ARG(symbol));
}

#endif /* DEBUG */

/* vi: set ts=4 expandtab: */
