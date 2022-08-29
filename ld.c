/*****************************************************************************

   ld.c                                                    tahoe/64 linker

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
#include <stdarg.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <ar.h>
#include <a.out.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <crc32c.h>

#define LOG2_NR_BUCKETS     9 /* 512 name buckets */
#define NR_BUCKETS          (1 << LOG2_NR_BUCKETS)
#define BUCKET(h)           ((h) & (NR_BUCKETS - 1))

char            *aout = "a.out";        /* path to output file */
int             outfd = -1;             /* ... and its descriptor */
struct exec     exec;                   /* output exec header */
struct nlist    *syms;                  /* ...... symbol table */
char            *strtab;                /* ...... string table */
size_t          a_strsz;                /* size of string table */
struct object   *objects;               /* all-objects list (in order) */
struct globl    *globls[NR_BUCKETS];    /* all globl symbols (hashed) */
unsigned        base = A_EXEC_BASE;     /* base virtual address */
unsigned        address;                /* current virtual address */
char            s_flag;                 /* produce stripped output */

/* since we have virtual memories these days (especially relative to the
   size of a typical tahoe/64 binary), do everything in memory, which is
   not only much simpler but also more efficient. a struct object is the
   in-memory representation of a relocatable object. */

struct object
{
    char            *path;      /* to the containing file */
    char            *member;    /* member name (if archive) */
    int             flags;      /* MARKED, RESOLVED */
    struct exec     *hdr;       /* in-memory copy of its header */
    char            *text;      /* ..................... text segment */
    char            *data;      /* ..................... data segment */
    unsigned        text_base;  /* [virtual] base address of text in exec */
    unsigned        data_base;  /* ......................... data ....... */
    struct nlist    *syms;      /* ..................... symbol table */
    struct reloc    *relocs;    /* ..................... relocations */
    char            *strtab;    /* ..................... string table */
    struct object   *link;      /* to next object in `objects' list */
};

/* an object is MARKED iff it must appear in the output. the first object
   specified on the command line is MARKED by default; others are MARKED
   if they define symbols referenced in other MARKED objects (recursively) */

#define MARKED      0x00000001

/* once an object has been MARKED, it will eventually be RESOLVED, which
   means any other objects it depends on have been identified and MARKED. */

#define RESOLVED    0x00000002

/* return the NUL-terminated string at idx in object o's strtab */

#define STRING(o, idx)  (((o)->strtab) + (idx))

/* globl definitions. the definitions exported
   from each object are stored in a hash table. */

struct globl
{
    char            *name;      /* of symbol (points into object's strtab) */
    unsigned        len;        /* of name (not including NUL terminator) */
    unsigned        hash;       /* CRC-32C, used to select hash bucket */
    struct object   *object;    /* the object this definition is found in */
    struct nlist    *nlist;     /* and its corresponding nlist entry */
    struct globl    *link;      /* to next globl in this hash bucket */
};

/* report an error with a printf()-style format string,
   clean up any partial output, exit with error status. */

static void
error(const char *fmt, ...)
{
    va_list args;

    fprintf(stderr, "[ld] ERROR: ");
    va_start(args, fmt);

    while (*fmt)
    {
        if (*fmt != '%')
            fputc(*fmt, stderr);
        else switch (*++fmt)
        {
        case 's':   fprintf(stderr, "%s", va_arg(args, char *)); break;
        case 'E':   fprintf(stderr, "%s", strerror(errno)); break;

        case 'O':   {
                        struct object *o = va_arg(args, struct object *);

                        fprintf(stderr, "`%s'", o->path);
                        if (o->member) fprintf(stderr, " [%s]", o->member);
                        break;
                    }

        default:    fputc(*fmt, stderr);
        }

        ++fmt;
    }

    va_end(args);
    fputc('\n', stderr);
    if (outfd != -1) unlink(aout);

    exit(1);
}

/* a safe allocation function. malloc() should
   never fail on a vm system unless our request
   is ridiculous, but ... */

static void *
alloc(size_t sz, int zero)
{
    char *p, *p2;

    p = malloc(sz);
    if (sz != 0 && p == 0) error("allocation failed (%E)");

    if (zero)                       /* we are never asked to zero large */
        for (p2 = p; sz--; ++p2)    /* regions, only smallish buffers, */
            *p2 = 0;                /* so it's best to do this inline. */

    return p;
}

/* we have a relocatable object at `buf' (we hope). validate
   it, create a new struct object, and add it to the list. */

static void
new_object(char *path, char *member, char *buf)
{
    static struct object **next = &objects;

    struct object *o;

    o = alloc(sizeof(struct object), 0);

    o->path = path;
    o->member = member;
    o->flags = 0;

    o->hdr = (struct exec *) buf;
    if (o->hdr->a_magic != OMAGIC) error("%O is not an object", o);

    o->text     =                  (buf + N_TXTOFF(*o->hdr));
    o->data     =                  (buf + N_DATOFF(*o->hdr));
    o->syms     = (struct nlist *) (buf + N_SYMOFF(*o->hdr));
    o->relocs   = (struct reloc *) (buf + N_RELOFF(*o->hdr));
    o->strtab   =                  (buf + N_STROFF(*o->hdr));

    o->link = 0;        /* we preserve the order */
    *next = o;          /* of the objects in the */
    next = &o->link;    /* all-objects list */
}

/* PASS 1: read each input file into memory. create a
   struct object for each of the constituent objects. */

static void
pass1(char **paths)
{
    char *path;

    for (; path = *paths; ++paths)
    {
        /* open path
           allocate storage
           read its contents */

        int inf;
        char *buf;
        struct stat sb;

        inf = open(path, O_RDONLY);
        if (inf == -1) error("`%s': can't open (%E)", path);
        if (fstat(inf, &sb) == -1) error("`%s': can't stat (%E)", path);
        if (!S_ISREG(sb.st_mode)) error("`%s': not a regular file", path);

        buf = alloc(sb.st_size, 0);

        if (read(inf, buf, sb.st_size) != sb.st_size)
            error("`%s': read error (%E)", path);

        close(inf);

        if (*((armag_t *) buf) == ARMAG) {
            /* it's an archive; iterate over members
               creating a struct object for each */

            struct ar_hdr *ar;
            char *member;

            buf += sizeof(armag_t);                     /* skip ARMAG */
            sb.st_size -= sizeof(armag_t);

            while (sb.st_size)
            {
                ar = (struct ar_hdr *) buf;
                member = alloc(NAME_MAX + 1, 1);
                strncpy(member, ar->ar_name, NAME_MAX);

                buf += sizeof(struct ar_hdr);           /* skip header */
                sb.st_size -= sizeof(struct ar_hdr);

                new_object(path, member, buf);

                if (ar->ar_size & (ARPAD - 1)) /* adjust for padding */
                    ar->ar_size += ARPAD - (ar->ar_size & (ARPAD - 1));

                buf += ar->ar_size;                     /* to next member */
                sb.st_size -= ar->ar_size;
            }
        } else
            /* not an archive; assume
               a standalone object */

            new_object(path, 0, buf);
    }
}

/* look for the globl definition of `name' and return its entry. if none
   exists, create one (which can be distinguished by nlist/object == 0). */

static struct globl *
lookup(char *name)
{
    struct globl *g;
    unsigned hash, len;
    int b; /* bucket */

    len = strlen(name);
    hash = crc32c(0, name, len);
    b = BUCKET(hash);

    for (g = globls[b]; g; g = g->link)
        if ((g->hash == hash)
          && (g->len == len)
          && !memcmp(g->name, name, len)) return g;

    /* not found, make a new entry
       and put it in its bucket */

    g = alloc(sizeof(struct globl), 0);

    g->name = name;
    g->hash = hash;
    g->len = len;
    g->nlist = 0;
    g->object = 0;
    g->link = globls[b];
    globls[b] = g;

    return g;
}

/* PASS 2: scan each object for globl definitions and insert them into
   the globls[] hash, keeping an eye out for multiple definitions. */

static void
pass2(void)
{
    struct object   *o;
    struct nlist    *n;
    struct globl    *g;
    int             i;

    for (o = objects; o; o = o->link)
        for (i = 0; i < o->hdr->a_syms; ++i) {
            n = &o->syms[i];

            if (n->n_type == N_UNDF || n->n_globl == 0)
                continue;   /* only .globl definitions please */

            g = lookup(STRING(o, n->n_stridx));

            if (g->nlist) /* will be 0 if g is a new entry */
                error("%O: `%s' redefined (previously in %O)", o,
                                                               g->name,
                                                               g->object);

            g->object = o;
            g->nlist = n;
        }
}

/* PASS 3: resolve undefined symbols. for each MARKED object, search
   globls[] to find the objects that define its N_UNDF symbols, and
   mark them; loop to resolve those objects' symbols in turn. when
   done, we know which objects must be included in the output. */

static void
pass3(void)
{
    struct object   *o;
    struct nlist    *n;
    struct globl    *g;
    int             marked, i;

    objects->flags |= MARKED;

    do {
        marked = 0;

        for (o = objects; o; o = o->link) {
            if (!(o->flags & MARKED)) continue;
            if (o->flags & RESOLVED) continue;

            for (i = 0; i < o->hdr->a_syms; ++i) {
                n = &o->syms[i];
                if (n->n_type != N_UNDF) continue;
                g = lookup(STRING(o, n->n_stridx));

                if (g->nlist == 0)
                    error("%O: unresolved reference to `%s'",
                            o, STRING(o, n->n_stridx));

                if ((g->object->flags & MARKED) == 0)  {
                    g->object->flags |= MARKED;
                    ++marked;
                }
            }

            o->flags |= RESOLVED;
        }
    } while (marked);
}

/* passes 4 and 5 are [nearly] identical, except that the
   former deals with N_TEXT symbols and the latter, N_DATA.

   for each MARKED object, we compute the base address of
   the relevant segment and adjust the values of symbols
   in that segment, so they reflect their final addresses. */

#define PASSX(TYPE, BASE, SIZE)                                         \
    {                                                                   \
        struct object   *o;                                             \
        struct nlist    *n;                                             \
        int             i;                                              \
                                                                        \
        if (TYPE == N_DATA) /* page-align data seg */                   \
            address = N_ROUNDUP(address, A_PAGE_SIZE);                  \
                                                                        \
        for (o = objects; o; o = o->link) {                             \
            if (!(o->flags & MARKED)) continue;                         \
                                                                        \
            for (i = 0; i < o->hdr->a_syms; ++i) {                      \
                n = &o->syms[i];                                        \
                if (n->n_type != TYPE) continue;                        \
                n->n_value += address;                                  \
            }                                                           \
                                                                        \
            o->BASE = address;                                          \
            address += o->hdr->SIZE;                                    \
            exec.SIZE += o->hdr->SIZE;                                  \
        }                                                               \
    }

static void pass4(void) PASSX(N_TEXT, text_base, a_text)
static void pass5(void) PASSX(N_DATA, data_base, a_data)

/* pass 6 is the equivalent of passes 4/5 for N_BSS symbols.
   these must be aligned and re-written as N_DATA symbols. */

static void
pass6(void)
{
    struct object   *o;
    struct nlist    *n;
    int             i;
    unsigned        size;
    int             pad;
    int             align;

    for (o = objects; o; o = o->link) {
        if (!(o->flags & MARKED)) continue;

        for (i = 0; i < o->hdr->a_syms; ++i) {
            n = &o->syms[i];
            if (n->n_type != N_BSS) continue;

            size = n->n_value;
            align = 1 << n->n_align;

            if (address & (align - 1)) {
                pad = align - (address & (align - 1));
                address += pad;
                exec.a_bss += pad;
            }

            n->n_type = N_DATA;
            n->n_value = address;
            n->n_align = 0;

            address += size;
            exec.a_bss += size;
        }
    }
}

/* fix up relocations. this is the hairiest pass, at least
   in the sense that there is a lot of tedious arithmetic. */

static void
pass7(void)
{
    struct object   *o;
    struct globl    *g;
    struct nlist    *n;
    struct reloc    *r;
    int             i;
    long            current;
    long            value;
    char            *loc;
    int             size;
    unsigned        base;

    for (o = objects; o; o = o->link) {
        if (!(o->flags & MARKED)) continue;

        for (i = 0; i < o->hdr->a_relocs; ++i) {
            r = &o->relocs[i];

            /* loc is where in our memory
               image the fixup is located */

            loc = r->r_text ? o->text : o->data;
            loc += r->r_offset;

            size = 1 << r->r_size;

            /* we must retrieve the current value; the semantics
               of the fixups required that we ADD the value of
               the resolved symbol to the fixup's existing value */

            switch (size)
            {
            case 1:     current = *(char *)     loc; break;
            case 2:     current = *(short *)    loc; break;
            case 4:     current = *(int *)      loc; break;
            case 8:     current = *(long *)     loc; break;
            }

            n = &o->syms[r->r_symidx];

            /* if the symbol is N_UNDF in this object, then it
               must be a globl. by now we know it must exist */

            if (n->n_type == N_UNDF) {                  /* N_UNDF in this */
                g = lookup(STRING(o, n->n_stridx));     /* object, replace */
                n = g->nlist;                           /* with the globl */
            }

            value = n->n_value;

            if (r->r_rel) {
                /* RIP-relative is distance to a symbol from the
                   end of the fixup location updated by the reloc */

                base = r->r_text ? o->text_base : o->data_base;
                value -= base + r->r_offset + size;
            }

            value += current;

            /* now patch the updated value back, and we're done */

            switch (size)
            {
            case 1:     *(char *)   loc = value; break;
            case 2:     *(short *)  loc = value; break;
            case 4:     *(int *)    loc = value; break;
            case 8:     *(long *)   loc = value; break;
            }
        }
    }
}

/* collect all globl symbols from MARKED objects
   and build the output symbol and string tables. */

static void
pass8(void)
{
    struct object   *o;
    struct nlist    *n;
    int             i;
    int             nsyms = 0;
    size_t          strsz = 0;

    /* first, count the number of symbols and
       compute the amount of string space */

    for (o = objects; o; o = o->link) {
        if (!(o->flags & MARKED)) continue;

        for (i = 0; i < o->hdr->a_syms; ++i) {
            n = &o->syms[i];

            if (n->n_type == N_UNDF || n->n_globl == 0)
                continue;

            ++nsyms;
            strsz += strlen(STRING(o, n->n_stridx)) + 1;
        }
    }

    syms = alloc(sizeof(struct nlist) * nsyms, 0);
    strtab = alloc(strsz, 0);

    /* in the second pass, we populate the tables */

    for (o = objects; o; o = o->link) {
        if (!(o->flags & MARKED)) continue;

        for (i = 0; i < o->hdr->a_syms; ++i) {
            n = &o->syms[i];

            if (n->n_type == N_UNDF || n->n_globl == 0)
                continue;

            strcpy(&strtab[a_strsz], STRING(o, n->n_stridx));
            n->n_stridx = a_strsz;
            a_strsz += strlen(&strtab[a_strsz]) + 1;

            syms[exec.a_syms++] = *n;
        }
    }
}

/* seek to position `where' in the output file and
   write `len' bytes from `buf'. bomb on errors */

static void
out(off_t where, void *buf, size_t len)
{
    if (lseek(outfd, where, SEEK_SET) != where)
        error("`%s': seek error (%E)", aout);

    if (write(outfd, buf, len) != len)
        error("`%s': write error (%E)", aout);
}

/* write the output file. finally! */

static void
pass9(void)
{
    struct object *o;

    outfd = open(aout, O_CREAT | O_TRUNC | O_WRONLY, 0777);
    if (outfd == -1) error("`%s': can't create (%E)", aout);

    out(0, &exec, sizeof(exec));

    for (o = objects; o; o = o->link) {
        if (!(o->flags & MARKED)) continue;
        out(o->text_base - base, o->text, o->hdr->a_text);
        out(o->data_base - base, o->data, o->hdr->a_data);
    }

    /* these will be no-ops if s_flag == 1 since pass8()
       will never run, thus exec.a_syms == a_strsz == 0 */

    out(N_SYMOFF(exec), syms, sizeof(struct nlist) * exec.a_syms);
    out(N_STROFF(exec), strtab, a_strsz);

    close(outfd);
}

int
main(int argc, char **argv)
{
    int opt;

    while ((opt = getopt(argc, argv, "b:e:o:s")) != -1)
    {
        switch (opt)
        {
        case 'b':   {
                        char *endptr;
                        base = strtol(optarg, &endptr, 0);
                        if (*endptr != 0) goto usage;
                        break;
                    }

        case 'e':   /* FIXME ignored */ ; break;
        case 'o':   aout = optarg; break;
        case 's':   ++s_flag; break;

        default:    goto usage;
        }
    }

    if (argv[optind] == 0) goto usage;

    exec.a_magic = ZMAGIC;              /* output is executable */
    address = base;                     /* start of text segment */
    address += sizeof(struct exec);     /* header is part of text */

    pass1(&argv[optind]);               /* load objects */
    pass2();                            /* build globls[] */
    pass3();                            /* resolve N_UNDFs */
    pass4();                            /* calculate text base, addresses */
    pass5();                            /* ......... data ................ */
    pass6();                            /* rewrite N_BSS symbols as N_DATA */
    pass7();                            /* fix up relocations */
    if (!s_flag) pass8();               /* build symbol/string tables */
    pass9();                            /* write executable a.out */

    exit(0);

usage:
    fprintf(stderr, "usage: ld [-b addr] [-s] [-o a.out] input...\n");
    exit(1);
}

/* vi: set ts=4 expandtab: */
