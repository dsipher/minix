/*****************************************************************************

   as.c                                                    minix assembler

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).

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
#include "y.tab.h"

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
   is displayed (only for pseudo-ops; no ATOM insns exceed this limit).

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
    int size;
    int i;
    char *p;
    int rel = 0;

    switch (o->classes & (O_REL | O_IMM | O_ABS))
    {
    case O_REL_8:       rel = 1;
    case O_ABS_8:
    case O_IMM_8:
    case O_IMM_S8:
    case O_IMM_U8:      size = 1;
                        break;

    case O_REL_16:      rel = 1;
    case O_ABS_16:      size = 2;
    case O_IMM_16:
    case O_IMM_S16:
    case O_IMM_U16:     size = 2;
                        break;

    case O_REL_32:      rel = 1;
    case O_ABS_32:
    case O_IMM_32:
    case O_IMM_S32:
    case O_IMM_U32:     size = 4;
                        break;

    case O_ABS_64:
    case O_IMM_64:      size = 8;
                        break;

    default:            return;     /* nothing to emit */
    }

    if (rel) resolve(o, size, 1);

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

    for (p = (char *) &o->value, i = 0; i < size; ++p, ++i) emit(*p);
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

/* return the O_IMM_* classes in which `value' can be represented. */

long immclass(long value)
{
    long classes = O_IMM_64;    /* of course, everything fits in 64 bits */

    if (value >= CHAR_MIN  &&  value <= CHAR_MAX)   classes |= O_IMM_S8;
    if (value >= 0         &&  value <= UCHAR_MAX)  classes |= O_IMM_U8;
    if (value >= SHRT_MIN  &&  value <= SHRT_MAX)   classes |= O_IMM_S16;
    if (value >= 0         &&  value <= USHRT_MAX)  classes |= O_IMM_U16;
    if (value >= INT_MIN   &&  value <= INT_MAX)    classes |= O_IMM_S32;
    if (value >= 0         &&  value <= UINT_MAX)   classes |= O_IMM_U32;

    if (value >= (USHRT_MAX - 127) && value <= USHRT_MAX) classes |= O_HI16;
    if (value >=  (UINT_MAX - 127) &&  value <= UINT_MAX) classes |= O_HI32;

    if (value == 1) classes |= O_IMM_1;

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
    case O_MEM_16:  bad_i_flags = I_NO_CODE16 | I_DATA_64; break;
    case O_MEM_32:  bad_i_flags = I_NO_CODE32 | I_DATA_64; break;
    case O_MEM_64:  bad_i_flags = I_NO_CODE64; break;
    }

    do {

        if (insn->i_flags & bad_i_flags) goto mismatch;

        for (i = 0; i < MAX_OPERANDS; ++i) {
            if (!insn->formals[i].classes && !operands[i])
                goto match; /* no more operands to check */

            if (!insn->formals[i].classes || !operands[i])
                goto mismatch; /* operand counts do not agree */

            if ((  O_CLASSES                        /* classes must have */
                 & insn->formals[i].classes     /* non-empty intersection */
                 & operands[i]->classes ) == 0)
                goto mismatch;

            if ((  O_CONSTRAINTS                /* constraints must match */
                 & insn->formals[i].classes
                 & operands[i]->classes )    != (insn->formals[i].classes
                                                        & O_CONSTRAINTS))
                goto mismatch;
        }

        goto match;

mismatch:
        ++insn;
    } while (insn->nr_opcodes);

    error("invalid instruction or operand(s)");

match:
    /* now, normalize the operands by pruning their classes
       to match their templates, and normalizing them. */

    for (i = 0; i < MAX_OPERANDS && insn->formals[i].classes; ++i) {
        operands[i]->classes &= insn->formals[i].classes & O_CLASSES;

        switch (operands[i]->classes)
        {
                        /* O_HI_* means high unsigned values should be
                           recast as [negative] 8-bit signed quantities. */

        case O_HI16:
        case O_HI32:    operands[i]->value = (char) operands[i]->value;
                        operands[i]->classes = O_IMM_S8;
                        break;
        }
    }

    return insn;
}

/* true if `reg' is a new low-byte register */

static int lobyte(int reg)
{
    switch (reg)
    {
    case SIL:
    case DIL:
    case BPL:
    case SPL:   return 1;

    default:    return 0;
    }
}

/* true if `reg' is a legacy high-byte register */

static int hibyte(int reg)
{
    switch (reg)
    {
    case AH:
    case BH:
    case CH:
    case DH:    return 1;

    default:    return 0;
    }
}

/* return the 4-bit encoding of `reg'. this is tiresome,
   but thankfully the compiler does a good job with this.
   if `reg' has no encoding (e.g., it's not a valid reg,
   or otherwise), we return 0; this overlaps with %al et
   al., but is intentional: it means that a test for the
   high register bit (bit 3) will return 0 for not-a-reg */

static int encode_reg(int reg)
{
    switch (reg)
    {
    case ES:    default:
    case AL:    case AX:    case EAX:
    case RAX:   case CR0:   case XMM0:      return 0;

    case CS:
    case CL:    case CX:    case ECX:
    case RCX:   case CR1:   case XMM1:      return 1;

    case SS:
    case DL:    case DX:    case EDX:
    case RDX:   case CR2:   case XMM2:      return 2;

    case DS:
    case BL:    case BX:    case EBX:
    case RBX:   case CR3:   case XMM3:      return 3;

    case FS:    case AH:
    case SPL:   case SP:    case ESP:
    case RSP:   case CR4:   case XMM4:      return 4;

    case GS:    case CH:
    case BPL:   case BP:    case EBP:
    case RBP:   case CR5:   case XMM5:      return 5;

    case DH:
    case SIL:   case SI:    case ESI:
    case RSI:   case CR6:   case XMM6:      return 6;

    case BH:
    case DIL:   case DI:    case EDI:
    case RDI:   case CR7:   case XMM7:      return 7;

    case R8B:   case R8W:   case R8D:
    case R8:    case CR8:   case XMM8:      return 8;

    case R9B:   case R9W:   case R9D:
    case R9:    case CR9:   case XMM9:      return 9;

    case R10B:  case R10W:  case R10D:
    case R10:   case CR10:  case XMM10:     return 10;

    case R11B:  case R11W:  case R11D:
    case R11:   case CR11:  case XMM11:     return 11;

    case R12B:  case R12W:  case R12D:
    case R12:   case CR12:  case XMM12:     return 12;

    case R13B:  case R13W:  case R13D:
    case R13:   case CR13:  case XMM13:     return 13;

    case R14B:  case R14W:  case R14D:
    case R14:   case CR14:  case XMM14:     return 14;

    case R15B:  case R15W:  case R15D:
    case R15:   case CR15:  case XMM15:     return 15;
    }
}

/* valid index forms for 16-bit addresses. order
   is important! the index into rm16[] is the value
   to stuf into the rm field of the mod/rm byte. */

static struct { int reg; int index; } rm16[] =  {   { BX, SI },
                                                    { BX, DI },
                                                    { BP, SI },
                                                    { BP, DI },
                                                    { SI     },
                                                    { DI     },
                                                    { BP     },
                                                    { BX     }  };

static int lookup_rm16(struct operand *o)
{
    int i;

    for (i = 0; i < (sizeof(rm16) / sizeof(*rm16)); ++i)
        if ((o->reg == rm16[i].reg) && (o->index == rm16[i].index))
            return i;

    error("invalid base/index combination");
}

#define NR_RM16 (sizeof(rm16) / sizeof(*rm16))

/* encode the mod/rm field. start with `modrm' as a template.
   the operand to encode is `operands' at index `i'. emit the
   mod/rm byte, the sib if necessary, and any displacement.

   this is a giant pain in the @$$, because of the myriad
   variations of address sizes and index modes. an effort
   has been made to keep it clean and tidy, but ... sigh.

   grammar.y has only done minimal validation on address modes.
   it has ensured that if base and index are both present, they
   are the same size, but it hasn't checked for invalid combos. */

#define SET_MODRM_MOD(b, n)     ((b) = (((b) & 0x3F) | (((n) & 0x03) << 6)))
#define SET_MODRM_RM(b, n)      ((b) = (((b) & 0xF8) | ((n) & 0x07)))

#define SET_SIB_SCALE(b, n)     ((b) |= (((n) & 0x03) << 6))
#define SET_SIB_BASE(b, n)      ((b) |= ((n) & 0x07))
#define SET_SIB_INDEX(b, n)     ((b) |= (((n) & 0x07) << 3))

static void modrm(struct operand **operands, int i, int modrm)
{
    struct operand *o = operands[i];    /* operand we're encoding */
    int range = 0;                      /* for range check at exit */
    int need_sib = 0;
    char sib = 0;

    if (o->reg == RIP) {                                /* %rip-relative */
        SET_MODRM_RM(modrm, 5);

        if (o->sym == 0)
            /* if the operand is just a naked value
               (with no symbol) then take the user at
               his word and leave the offset alone */

            range = o->classes = O_IMM_32;
        else {
            range = O_IMM_S32;
            o->classes = O_REL_32;

            /* this is ugly. with %rip-relative addresses came the
               possibility that a relative address would be output
               at a position OTHER than the last in an encoding.
               we need to account for bytes that might follow. */

            while (operands[++i])
            {
                if (operands[i]->classes & O_IMM_8)  o->value -= 1;
                if (operands[i]->classes & O_IMM_16) o->value -= 2;
                if (operands[i]->classes & O_IMM_32) o->value -= 4;
                if (operands[i]->classes & O_IMM_64) o->value -= 8;
            }
        }
    } else if (o->classes & O_MEM_16) {                 /* 16-bit */
        if (!o->reg && !o->index) {
            SET_MODRM_RM(modrm, 6);
            range = o->classes = O_IMM_16;
        } else {
            SET_MODRM_RM(modrm, lookup_rm16(o));
            if (o->scale) error("illegal scaling");

            o->classes = 0;     /* default to no displacement */

            if ((o->reg == BP) && !o->index && !o->sym && !o->value)
                o->classes = O_IMM_S8;          /* (%bp) -> 0(%bp) */
            else if (o->value && !o->sym && (immclass(o->value) & O_IMM_S8))
                o->classes = O_IMM_S8;          /* 8-bit signed, constant */
            else if (o->value || o->sym)
                range = o->classes = O_IMM_16;  /* assume 16-bit, reloc */

            if (o->classes & O_IMM_S8) SET_MODRM_MOD(modrm, 1);
            if (o->classes & O_IMM_16) SET_MODRM_MOD(modrm, 2);
        }
    } else {                                            /* 32- or 64-bit */
        if (!o->reg && !o->index) {
            if (o->classes & O_MEM_64) {        /* pure 32-bit offsets */
                SET_MODRM_RM(modrm, 4);         /* have a long-winded */
                ++need_sib;                     /* encoding in 64-bit */
                SET_SIB_BASE(sib, 5);           /* since %rip-relative */
                SET_SIB_INDEX(sib, 4);          /* is more common. */
            } else
                SET_MODRM_RM(modrm, 5);

            range = o->classes = O_IMM_32;
        } else {
            if ((o->index == ESP) || (o->index == RSP))
                error("%%esp/%%rsp can't be the index");

            o->classes = 0;     /* default to no displacement */

            if (!o->sym && !o->value && ((o->reg == EBP) ||
                                         (o->reg == RBP) ||
                                         (o->reg == R13D) ||
                                         (o->reg == R13)))
                /* similar to 16-bit addressing, the frame pointer can't
                   be encoded without displacement. %r13 can't either! */

                o->classes = O_IMM_S8;
            else if (o->value && !o->sym && (immclass(o->value) & O_IMM_S8))
                o->classes = O_IMM_S8;          /* 8-bit signed, constant */
            else if (o->value || o->sym)
                range = o->classes = O_IMM_32;  /* assume 32-bit, reloc */

            if (o->classes & O_IMM_8) SET_MODRM_MOD(modrm, 1);
            if (o->classes & O_IMM_32) SET_MODRM_MOD(modrm, 2);

            if (!o->index && (o->reg != ESP)    /* if there's only a */
                          && (o->reg != RSP)    /* base reg (no index) */
                          && (o->reg != R12D)   /* and it's not one of */
                          && (o->reg != R12))   /* these, use short form */
                SET_MODRM_RM(modrm, encode_reg(o->reg));
            else {
                ++need_sib;
                SET_MODRM_RM(modrm, 4);

                if (o->reg)
                    SET_SIB_BASE(sib, encode_reg(o->reg));
                else {
                    SET_MODRM_MOD(modrm, 0);        /* if no base reg, */
                    SET_SIB_BASE(sib, 5);           /* we must use a */
                    range = o->classes = O_IMM_32;  /* full displacement */
                }

                if (o->index)
                    SET_SIB_INDEX(sib, encode_reg(o->index));
                else
                    SET_SIB_INDEX(sib, 4);

                SET_SIB_SCALE(sib, o->scale);
            }
        }
    }

    if (range && ((immclass(o->value) & range) == 0))
        error("offset/displacement out of range");

    emit(modrm);
    if (need_sib) emit(sib);

    emit_value(o);      /* we output the value (if any) now, */
    o->classes = 0;     /* so we must suppress output later */
}

/* try to encode an insn given a set of templates and operands.
   note that the operands are backwards with respect to how they
   appear in the source, i.e., they are in intel syntax order. */

#define REX     0x40
#define REX_B   0x01
#define REX_X   0x02
#define REX_R   0x04
#define REX_W   0x08

void encode(struct insn *insns, struct operand *operand0,
                                struct operand *operand1,
                                struct operand *operand2)
{
    struct operand *operands[4] = { operand0, operand1, operand2, 0 };
    struct insn *insn = match(insns, operands);
    char byte;
    int enc;
    int i;

    /* 1. address-size override prefix. the insn template doesn't know
          about address sizes; we must locate an O_MEM_* and examine it. */

    for (i = 0; operands[i]; ++i)
    {
        if ((operands[i]->classes & O_MEM) == 0) continue;

        if (  ((operands[i]->classes & O_MEM_64) && (code_size != O_MEM_64))
           || ((operands[i]->classes & O_MEM_16) && (code_size == O_MEM_64)) )
        {
            error("%d-bit address modes not available", code_size == O_MEM_64
                                                            ? 16 : 64);
        }

        if (  ((code_size == O_MEM_16) && (operands[i]->classes & O_MEM_32))
           || ((code_size == O_MEM_32) && (operands[i]->classes & O_MEM_16))
           || ((code_size == O_MEM_64) && (operands[i]->classes & O_MEM_32)) )
        {
            emit(0x67);     /* address-size override */
        }

        break;  /* found the O_MEM_*; there's at most one, so stop looking */
    }

    /* 2. operand size override prefix. if we issue an insn
          with a specified data size which doesn't match the
          current default, we need to issue this prefix. */

    if (  ((insn->i_flags & I_DATA_16) && (code_size != O_MEM_16))
       || ((insn->i_flags & I_DATA_32) && (code_size == O_MEM_16)) )
    {
        emit(0x66);         /* data-size override */
    }

    /* 3. other prefixes. the difference between a `hard-coded' prefix and
          and opcode byte is that the prefixes are emitted before any REX.
          (this is unimportant but it aligns our output with that of gas).
          interestingly, these LOOK like other prefixes but obviously have
          alternate meanings (c.f. data-size override and rep prefixes) */

    if (insn->i_flags & I_PREFIX_66) emit(0x66);
    if (insn->i_flags & I_PREFIX_F2) emit(0xF2);
    if (insn->i_flags & I_PREFIX_F3) emit(0xF3);

    /* 4. REX prefix. a REX prefix is issued when:

            (a) the insn has 64-bit data size (I_DATA_64)
            (b) when new byte registers are (%sil, %dil, %bpl, %spl) used
            (c) when high registers (%r8-%r15, %xmm8-%xmm15, ...) are used */

    byte = 0;

    if ((insn->i_flags & (I_DATA_64 | I_NO_REX)) == I_DATA_64)
        byte = REX | REX_W; /* (a) */

    for (i = 0; operands[i]; ++i)
        if (operands[i]->classes & O_REG)
            if (lobyte(operands[i]->reg))
                byte |= REX; /* (b) */

    for (i = 0; operands[i]; ++i) { /* (c) */
        if (insn->formals[i].f_flags & (F_END | F_MID)) {
            enc = encode_reg(operands[i]->reg);

            if (enc & 8) {
                if (insn->formals[i].f_flags & F_END)
                    byte |= REX | REX_B; /* (c) high bit -> REX.B */
                else if (insn->formals[i].f_flags & F_MID)
                     byte |= REX | REX_R; /* (c) high bit -> REX.R */
            }
        } else if (insn->formals[i].f_flags & F_MODRM) {
            enc = operands[i]->reg ? encode_reg(operands[i]->reg) : 0;
            if (enc & 8) byte |= REX | REX_B; /* (c) high bit -> REX.B */

            enc = operands[i]->index ? encode_reg(operands[i]->index) : 0;
            if (enc & 8) byte |= REX | REX_X; /* (c) high bit -> REX.X */
        }
    }

    if (byte) {
        /* we issued a REX; the encodings for high-byte
           regs are occupied by the new low-byte regs. */

        for (i = 0; operands[i]; ++i)
            if ((operands[i]->classes & O_REG) && hibyte(operands[i]->reg))
                error("legacy register(s) not available");

        emit(byte);
    }

    if (byte && (code_size != O_MEM_64)) error("register(s) not available");

    /* 5. output the opcode bytes. output all but the last byte,
          as it is subject to modification in the next steps. */

    for (i = 0; i < insn->nr_opcodes - 1; ++i) emit(insn->opcodes[i]);
    byte = insn->opcodes[i]; /* next steps will modify this byte */

    /* 6. process pure register operands. registers that are not encoded
          into mod/rm fields go into one of two places: the end (F_END)
          or the middle (F_MID). only the lower 3 bits are encoded here,
          as any high bits have been inserted into the REX prefix above. */

    for (i = 0; operands[i]; ++i)
        if (insn->formals[i].f_flags & (F_END | F_MID)) {
            enc = encode_reg(operands[i]->reg) & 7;
            if (insn->formals[i].f_flags & F_MID) enc <<= 3;
            byte |= enc;
        }

    /* 7. process mod/rm operand, if present. */

    for (i = 0; operands[i]; ++i) {
        if (insn->formals[i].f_flags & F_MODRM) {
            if (operands[i]->classes & O_REG) {
                /* we can fill in the mod/rm
                   for a reg straightaway */

                SET_MODRM_MOD(byte, 3);
                SET_MODRM_RM(byte, encode_reg(operands[i]->reg));
                emit(byte);
            } else
                /* modrm() will emit the `byte' for us after it's
                   been appropriately modified. it will also rewrite
                   this operand to be O_IMM_*, O_REL_*, or nothing,
                   depending on what it wants emitted in step 8. */

                modrm(operands, i, byte);

            /* exit early here since (a) there is only one mod/rm operand
               possible, and (b) we want the following code to know we've
               processed a mod/rm field, so it won't emit the byte again */

            break;
        }
    }

    if (operands[i] == 0) emit(byte);   /* no mod/rm, so emit untouched */

    /* 8. process the remaining operands. all the
          work is really handled by emit_value(). */

    for (i = 0; operands[i]; ++i)
        if (operands[i]->classes & (O_IMM | O_ABS | O_REL))
            emit_value(operands[i]);
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
