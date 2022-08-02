/*****************************************************************************

   as.c                                                 tahoe/64 assembler

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

#include "as.h"

/* shockingly, the first pass will be FIRST_PASS. */

int pass = FIRST_PASS;

/* the default code size (set by .code16, .code32 or .code64).
   we use O_MEM_16 .. O_MEM_64 as values, because they're just
   as good as any, plus they are convenient in some places */

int code_size;

/* we count the number of changes in symbol values during
   a pass. if a pass completes with nr_changes == 0, then
   the symbol table has converged. */

static int nr_changes;

/* `sources' records the point in argv[] after options, i.e.,
   the start of the input source paths from the command line.
   `source' is a cursor which indicates the current source. */

static char **sources;
static char **source;

/* the current input file (and its line number
   for error reporting and/or list generation) */

static FILE *inf;
static int lineno;

/* the output path (defaults to "a.out") and its
   descriptor. we deliberately bypass stdio. */

static char *out_path;
static int outfd;

/* rather than trying to synchronize with lex/yacc, during the
   listing pass we `shadow' the input file with a second handle
   from which we read input lines to echo to the list output. */

static char *list_path;     /* path to listing file (if requested) */
static FILE *list_outf;     /* ... and its handle */
static FILE *list_inf;      /* shadow input for list generation */

/* generating a listing requires a coroutine structure, so we effectively
   implement a state machine. at the beginning of each line we record the
   address in the current segment in list_addr. as the line is processed,
   we collect the emitted bytes in list_bytes[], and in end_of_line() we
   put it all together. */

static char list_bytes[MAX_LIST_BYTES];         /* buffered output bytes */
static int nr_list_bytes;                       /* and a count of them */
static unsigned list_addr;  /* address in segment at start of this line */

/* the resulting a.out header. we use its fields as counters
   while assembling; after the final pass they have the right
   values, so the header can then be written out verbatim. */

struct exec header;

/* we don't do any `real' dynamic allocation in the assembler'
   all of our data areas are statically sized. this may seem
   to many to be a step backward, but it is in fact the right
   approach in a virtual-memory system: allocate arbitrarily
   large chunks of virtual address space, and let the system
   deal with actual memory allocation if/when it's needed. */

static char text[MAX_SEGMENT_SIZE];
static char data[MAX_SEGMENT_SIZE];
static struct nlist syms[MAX_SYMS];
static struct name names[MAX_SYMS];
static struct reloc relocs[MAX_RELOCS];
static char strtab[A_MAX_STRTAB];

/* the index of the next string in the strtab
   (which is also the length of the strtab). */

static int stridx;

/* we maintain a pool of POOL_SIZE bytes for dynamic storage during
   the processing of a line. end_of_line() discards its contents. */

char pool[POOL_SIZE];       /* pool storage */
char *pool_pos = pool;      /* next available byte */

/* points to &header.a_text or &header.a_data depending
   on whether we're in the .text or .data segment */

unsigned *segofs;

/* report an error using a printf()-style format string
   and arguments, clean up any partial output, and abort */

void error(const char *fmt, ...)
{
    va_list args;

    fprintf(stderr, "[as] ");

    if (*source) {
        fprintf(stderr, "`%s'", *source);
        if (lineno) fprintf(stderr, " (%d)", lineno);
        fprintf(stderr, ": ");
    }

    fprintf(stderr, "ERROR: ");
    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);
    fputc('\n', stderr);

    if (outfd != -1)    { close(outfd); remove(out_path); }
    if (list_outf)      { fclose(list_outf); remove(list_path); }

    exit(1);
}

/* yacc only calls yyerror() on syntax errors,
   or when the its stack overflows. our grammar
   is not cyclic, so the latter can't happen. */

void yyerror(const char *s) { error("syntax"); }

/* list n bytes from list_bytes[], starting at index i.
   if we run out of buffered bytes, pad with spaces. */

static void list_buffered(int i, int n)
{
    while (n--) {
        if (i < nr_list_bytes)
            fprintf(list_outf, "%02x", list_bytes[i] & 0xFF);
        else
            fprintf(list_outf, "  ");

        ++i;
    }
}

static void list_spaces(int n) { while (n--) putc(' ', list_outf); }

/* the list_line grammar rule invokes this after we finish processing each
   line; we maintain the line counter here and do listing when appropriate.

   the format of a listing line is

        LLLL  AAAAAA  XXXXXXXXXXXXXXXX  text-from-source-file-copied-here
                      XXXXXXXXXXXXXX..

   where L is the line number, right-justified, space padded on the left,
   and A is the address (offset) in the current section (text or data),
   in hex, right-justified with leading zeros. the XXs are the hex-encoded
   bytes of the instruction or pseudo-op on this line, at most 15 bytes.
   the second line is only displayed if more than 8 bytes are present. if
   more than 15 bytes are encoded, they are truncated and the trailing '..'
   is displayed (only for pseudo-ops; no AMD64 insns exceed this limit).

   the listing is not meant to be pretty. it is primarily for debugging. */

void end_of_line(void)
{
    int c;

    if (list_outf) {
        fprintf(list_outf, "%4d  ", lineno % 10000);
        fprintf(list_outf, "%06x  ", list_addr & 0x00FFFFFF);
        list_buffered(0, 8);
        list_spaces(2);

        for (;;)
        {
            c = getc(list_inf);
            if ((c == -1) || (c == '\n')) break;
            putc(c, list_outf);
        }

        putc('\n', list_outf);

        if (nr_list_bytes > 8) {
            list_spaces(14);
            list_buffered(8, 7);

            if (nr_list_bytes > MAX_LIST_BYTES)
                fprintf(list_outf, "..");

            putc('\n', list_outf);
        }

        nr_list_bytes = 0;
        list_addr = *segofs;
    }

    ++lineno;
    pool_pos = pool;        /* free the pool */
}

/* emit a byte to the current segment and bump the location
   counter. if on the listing pass, update the listing state. */

void emit(int byte)
{
    if (*segofs >= MAX_SEGMENT_SIZE)
        error("maximum segment size exceeded");

    (CURSEG() == N_TEXT) ? (text[*segofs] = byte)
                         : (data[*segofs] = byte);

    if (list_outf) {
        if (nr_list_bytes < MAX_LIST_BYTES)
            list_bytes[nr_list_bytes] = byte;

        ++nr_list_bytes;
    }

    ++*segofs;
}

/* emit the value of an operand to the current segment
   and issue a relocation if a symbol is referenced. */

void emit_value(struct operand *o)
{
    int size = 0;
    int i;
    char *p;
    int rel = 0;

    switch (o->classes)
    {
    case O_REL_8:   rel = 1;
    case O_IMM_8:   size = 1; break;

    case O_REL_16:  rel = 1;
    case O_IMM_16:  size = 2; break;

    case O_REL_32:  rel = 1;
    case O_IMM_32:  size = 4; break;

    case O_IMM_64:  size = 8; break;
    }

    if (rel) resolve(o, size, 1);

    for (p = (char *) &o->value, i = 0; i < size; ++p, ++i) emit(*p);

    if (o->sym) {
        struct reloc *r = &relocs[header.a_relocs];

        if (header.a_relocs++ == MAX_RELOCS)
            error("too many relocations");

        r->r_symidx = o->sym - syms;
        r->r_rel = rel;
        r->r_text = (CURSEG() == N_TEXT);
        r->r_size = size2(size, 0);
        r->r_offset = *segofs;
    }
}

/* recompute the value of an operand as %rip-relative, after applying a
   fudge factor (`adj'). returns true if the resulting value is within
   short branch distance. takes into account that o->sym may be defined
   in the current segment, and thus may be eliminated from the operand.

   the operand is not modified with the results unless `fixup' is true. */

int resolve(struct operand *o, int adj, int fixup)
{
    long value = o->value;
    struct nlist *sym = o->sym;
    long rip = *segofs + adj;

    if (sym && sym->n_type == CURSEG()) {
        value += sym->n_value - rip;
        sym = 0;
    }

    if (fixup) {
        o->value = value;
        o->sym = sym;
    }

    /* short branch distance is -128/+127 with no unresolved symbol */

    return ((value >= SCHAR_MIN) && (value <= SCHAR_MAX) && sym == 0);
}

/* place the string described into the string section
   and return a pointer to its in-memory image. */

static char *string(const char *text, int len)
{
    char *s = strtab + stridx;

    ++len; /* include NUL */
    stridx += len;

    if (stridx > A_MAX_STRTAB)
        error("string table overflow");

    memcpy(s, text, len);
    return s;
}

/* returns the struct name associated with the specified text, creating
   a new one with an associated N_UNDF nlist if it does not exist. this
   is derived from cc1/string.c, so similarities are not accidental. */

struct name *lookup(const char *text, int len)
{
    struct name **namep;
    struct name *name;
    unsigned hash;
    int b;

    hash = crc32c(0, text, len);
    b = BUCKET(hash);

    for (namep = &table[b]; name = *namep; namep = &(name->link)) {
        if (name->hash != hash) continue;
        if (name->len != len) continue;
        if (memcmp(name->text, text, len)) continue;

        /* found it. unlink it from the bucket. we'll put it back (in
           front) on the way out. this keeps the bucket in MRU order. */

        *namep = name->link;
        break;
    }

    if (name == 0) {
        if (header.a_syms == MAX_SYMS)
            error("symbol table overflow");

        name = &names[header.a_syms];
        name->text = string(text, len);
        name->len = len;
        name->mnemonic = 0;
        name->hash = hash;

        name->sym = &syms[header.a_syms];
        name->sym->n_stridx = name->text - strtab;
        name->sym->n_type = N_UNDF;
        name->sym->n_globl = 0;
        name->sym->n_align = 0;

        ++header.a_syms;
    }

    name->link = table[b];
    table[b] = name;
    return name;
}

/* return the log (base 2) of `value' for 1, 2, 4,
   or 8; bomb if the value is not one of these. */

int size2(long align, const char *kind)
{
    switch (align)
    {
    case 1:     return 0;
    case 2:     return 1;
    case 4:     return 2;
    case 8:     return 3;

    default:    error("invalid %s", kind);
    }
}

/* enter a definition for a symbol with the specified `type' and `value'.
   for an N_BSS symbol, `value' is the size. other types ignore `align'. */

void define(struct nlist *sym, int type, long value, long align)
{
    if (pass == FIRST_PASS) {
        if (sym->n_type != N_UNDF)
            error("`%s' redefined", &strtab[sym->n_stridx]);

        if (type == N_BSS)
            sym->n_align = size2(align, "alignment");

        sym->n_value = value;
        sym->n_type = type;
    } else {
        switch (type)
        {
        case N_TEXT:
        case N_DATA:    if (sym->n_value != value) {
                            ++nr_changes;
                            sym->n_value = value;
                        }

        case N_BSS:     /* these do not change, so ... */
        case N_ABS:     /* ... there's nothing to do */     ;
        }
    }
}

/* called (by the lexer) to enforce the requirement that symbols
   be defined or declared external by the end of the first pass. */

void undef(struct nlist *sym)
{
    if (pass != FIRST_PASS
      && sym->n_type == N_UNDF
      && sym->n_globl == 0)
    {
        error("unresolved symbol `%s'", &strtab[sym->n_stridx]);
    }
}

/* return the O_IMM_* classes in which `value' can be represented.
   this could be done faster with less branching, but who cares? */

int immclass(long value)
{
    int classes = O_IMM_64;     /* of course, everything fits in 64 bits */

    if ( value >= CHAR_MIN  &&  value <= CHAR_MAX  ) classes |= O_IMM_S8;
    if ( value >= 0         &&  value <= UCHAR_MAX ) classes |= O_IMM_U8;
    if ( value >= SHRT_MIN  &&  value <= SHRT_MAX  ) classes |= O_IMM_S16;
    if ( value >= 0         &&  value <= USHRT_MAX ) classes |= O_IMM_U16;
    if ( value >= INT_MIN   &&  value <= INT_MAX   ) classes |= O_IMM_S32;
    if ( value >= 0         &&  value <= UINT_MAX  ) classes |= O_IMM_U32;

    return classes;
}

/* find and return the first insn template which
   matches the operands. error if none found. */

static struct insn *match(struct insn *insns, struct operand **operands)
{
    struct insn *insn = insns;
    int bad_i_flags;
    int i;

    switch (code_size)
    {
    case O_MEM_16:  bad_i_flags = I_NO_CODE16; break;
    case O_MEM_32:  bad_i_flags = I_NO_CODE32; break;
    case O_MEM_64:  bad_i_flags = I_NO_CODE64; break;
    }

    do {

        if (insn->i_flags & bad_i_flags) goto mismatch;

        for (i = 0; i < MAX_OPERANDS; ++i) {
            if (!insn->formals[i].classes && !operands[i])
                goto match; /* no more operands to check */

            if (!insn->formals[i].classes || !operands[i])
                goto mismatch; /* operand counts do not agree */

            if (!(insn->formals[i].classes & operands[i]->classes))
                goto mismatch;  /* classes do not match */
        }
match:
        return insn;

mismatch:
        ++insn;
    } while (insn->nr_opcodes);

    error("invalid instruction or operand(s)");
}

/* try to encode an insn given a set of templates and operands.
   note that the operands are backwards with respect to how they
   appear in the source, i.e., they are in intel syntax order. */

void encode(struct insn *insns, struct operand *operand0,
                                struct operand *operand1,
                                struct operand *operand2)
{
    struct operand *operands[4] = { operand0, operand1, operand2, 0 };
    struct insn *insn = match(insns, operands);
    char byte;
    int i;

    /* XXX 1. operand size override prefix */
    /* XXX 2. address size override prefix */
    /* XXX 3. other prefixes */
    /* XXX 4. REX prefix */

    /* 5. output the opcode bytes. we output all but the last byte in
          the table, as the last byte is subject to modification when
          the operands are processed (it might be the mod/rm byte). */

    for (i = 0; i < insn->nr_opcodes - 1; ++i) emit(insn->opcodes[i]);
    byte = insn->opcodes[i];    /* last byte, possibly mod/rm */

    /* XXX 6. process pure register operands */
    /* XXX 7. process mod/rm operand */

    for (i = 0; i < MAX_OPERANDS; ++i) { /* XXX */; }

    if (i == MAX_OPERANDS) emit(byte);  /* no mod/rm, emit untouched */

    /* 8. process the remaining operands. these are immediates (O_IMM_*)
          absolute memory addresses (O_MOFS_*), and relatives (O_REL_*).
          all the work is really handled by emit_value(). */

    for (i = 0; i < MAX_OPERANDS; ++i)
        if (insn->formals[i].classes & (/* XXX O_IMM | O_MOFS |*/ O_REL))
        {
            operands[i]->classes &= insn->formals[i].classes;
            emit_value(operands[i]);
        }
}

/* simple safe wrapper for fopen() */

static FILE *safe_fopen(const char *path, const char *mode)
{
    FILE *fp;

    fp = fopen(path, mode);

    if (fp == 0)
        error("can't open `%s' (%s)", path, strerror(errno));

    return fp;
}

/* safely write `len' bytes from `buf'
   to the output file at `offset'. */

void out(off_t offset, const void *buf, size_t len)
{
    if ((lseek(outfd, offset, SEEK_SET) == -1)
      || (write(outfd, buf, len) != len))
    {
        error("can't write to output (%s)", strerror(errno));
    }
}

/* reset all state data and run an assembly pass */

#define PAD(a)                                                              \
    do {                                                                    \
        segofs = &header.a;                                                 \
        while (*segofs & (A_PAD_SIZE - 1)) emit(0);                         \
    } while (0)

static void do_pass(void)
{
    header.a_magic = OMAGIC;        /* notice that we do not reset */
    header.a_text = 0;              /* syms, because they (should be) */
    header.a_data = 0;              /* fixed after the first pass. */
    header.a_relocs = 0;            /* ditto for strtab/stridx */

    source = sources;               /* rewind to first source */
    segofs = &header.a_text;        /* default to .text segment */
    list_addr = 0;                  /* first line always at offset 0 */
    nr_changes = 0;                 /* no symbol changes (yet) */
    code_size = O_MEM_64;           /* we're almost always in long mode */

    while (*source)
    {
        inf = safe_fopen(*source, "r");

        if (list_outf) {
            fprintf(list_outf, "\n\n%s\n\n", *source);
            list_inf = safe_fopen(*source, "r");
        }

        lineno = 1;
        yyrestart(inf);             /* reset lex */
        yyparse();                  /* invoke yacc */

        if (list_outf) fclose(list_inf);
        fclose(inf);
        lineno = 0;
        ++source;
    }

    PAD(a_text);
    PAD(a_data);
}

/* somewhere in K&R it describes
   what main() does, i forget */

int main(int argc, char **argv)
{
    char *p;
    int opt;

    while ((opt = getopt(argc, argv, "l:o:")) != -1)
    {
        switch (opt)
        {
        case 'o':   out_path = optarg; break;
        case 'l':   list_path = optarg; break;
        case '?':   exit(1);
        }
    }

    source = sources = &argv[optind];
    if (*source == 0) error("no input files");
    if (out_path == 0) out_path = "a.out";

    /* obligatory first pass */

    do_pass();

    /* run delta passes repeatedly until the symbols converge.
       the check for stuck assembler is [sort of] off by one. */

    do { ++pass; do_pass(); }
    while (nr_changes && (pass < MAX_PASSES));
    if (pass == MAX_PASSES) error("SORRY, assembler stuck");

    /* run an additional pass to generate the listing, now that
       we know the listed bytes will be correct (modulo relocs).
       list_outf is not just the handle to the output, but also
       serves as a signal to subroutines (`this is a list pass') */

    if (list_path) {
        list_outf = safe_fopen(list_path, "w");
        do_pass();
        fclose(list_outf);
        list_outf = 0;
    }

    /* finally, write the output, and we're done ... */

    outfd = open(out_path, O_WRONLY | O_TRUNC | O_CREAT, 0666);
    if (outfd == -1) error("can't open `%s' for output (%s)",
                                                out_path,
                                                strerror(errno));

    out(0,                &header, sizeof(header));
    out(N_TXTOFF(header), text,    header.a_text);
    out(N_DATOFF(header), data,    header.a_data);
    out(N_SYMOFF(header), syms,    header.a_syms * sizeof(struct nlist));
    out(N_RELOFF(header), relocs,  header.a_relocs * sizeof(struct reloc));
    out(N_STROFF(header), strtab,  stridx);

    close(outfd);

    return 0;
}

/* vi: set ts=4 expandtab: */
