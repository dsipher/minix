/*****************************************************************************

   a.out.h                                       tahoe/64 standard library

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

#ifndef _A_OUT_H
#define _A_OUT_H

/* a.out files are executables, relocatable objects, or shared libraries.
   each begins with a 32-byte header, followed by the sections described
   by that header, in the order they appear in the header (except for the
   bss, which has no on-disk representation). the segments must be padded
   A_PAD_SIZE boundaries, and the segment sizes must reflect this padding. */

struct exec
{
    unsigned a_magic;       /* one of the MAGICs */
    unsigned a_text;        /* size of the text segment (r/o) */
    unsigned a_data;        /* ........... data segment (r/w) */
    unsigned a_bss;         /* ........... zero segment (r/w) */

    unsigned a_syms;        /* number of symbols */
    unsigned a_relocs;      /* number of relocations */

    /* we have two reserved words for future expansion.
       in said future these must hold SIZES because we
       use them to compute the start of the string table. */

    unsigned a_reserved[2];     /* must be zero for now */
};

#define A_PAD_SIZE      8

/* executables require that some sections be aligned to A_PAGE_SIZE
   boundaries to facilitate demand-paging and sharing. unlike padding,
   the segment sizes are NOT adjusted to account for this alignment. */

#define A_PAGE_SIZE     4096

/* the string table is limited to 16Mb due to the format of struct nlist */

#define A_MAX_STRTAB    (16 * 1024 * 1024)

/* the base address of ZMAGIC files not stated, but
   implied. for userspace it is fixed at A_EXEC_BASE. */

#define A_EXEC_BASE     0x04000000      /* 64Mb */

/* we reuse the classic xMAGIC names from 4.3BSD, but we redefine both their
   values and their meanings. 0x1eeb is not arbitrary; it encodes `jmp 0x20'.
   since executables are entered at offset 0, this jmp bypasses the header. */

#define ZMAGIC      0x17b81eeb          /* executable */
#define OMAGIC      0x16d61eeb          /* relocatable object */

/* true if the a.out header `x' does not have a valid magic number */

#define N_BADMAG(x)     (   ((x).a_magic != ZMAGIC)                         \
                        &&  ((x).a_magic != OMAGIC) )

/* round a value `a' up to the nearest multiple of
   of `b'. only works when n is a power of two. */

#define N_ROUNDUP(a, b)     ({                                              \
                                unsigned _a = (a);                          \
                                unsigned _b = (b);                          \
                                                                            \
                                if (_a & (_b - 1))                          \
                                    _a += _b - (_a & (_b - 1));             \
                                                                            \
                                (_a);                                       \
                            })

/* selectively page-align the offset given, if header `x' has a ZMAGIC. */

#define N_MAYBE_ALIGN(x, c)     ({                                          \
                                    unsigned _c = (c);                      \
                                                                            \
                                    if ((x).a_magic == ZMAGIC)              \
                                        _c = N_ROUNDUP(_c, A_PAGE_SIZE);    \
                                                                            \
                                    (_c);                                   \
                                })

/* compute the file offset to the beginning of the text segment.
   (executables consider the header to be part of the text.) */

#define N_TXTOFF(x)     (((x).a_magic == OMAGIC) ? sizeof(struct exec) : 0)

/* the data segment follows the text; page-aligned for exectubles
   so we can separate the read-only text from read-write data. */

#define N_DATOFF(x)     N_MAYBE_ALIGN(x, N_TXTOFF(x) + ((x).a_text))

/* the bss obviously does not exist on disk; in
   memory it immediately follows the data segment. */

#define N_BSSOFF(x)     (N_DATOFF(x) + ((x).a_data))

/* the symbols are never loaded into memory; they are page-aligned in
   executables for hygiene (so we don't read them when paging in data).
   the symbol table is an array of struct nlist with a_syms elements. */

#define N_SYMOFF(x)     N_MAYBE_ALIGN(x, N_DATOFF(x) + ((x).a_data))

struct nlist
{
    unsigned n_stridx : 24;     /* offset to name in string table */
    unsigned n_type   : 3;      /* see N_* types below */
    unsigned n_globl  : 1;      /* visible outside this object file */
    unsigned n_align  : 2;      /* log2 of alignment (for N_BSS only) */
    unsigned long     : 34;     /* (reserved) */

    unsigned long   n_value;    /* invalid for N_UNDF, size for N_BSS */
};

#define N_UNDF  0               /* undefined symbol */
#define N_ABS   1               /* absolute value */
#define N_TEXT  2               /* offset into text segment */
#define N_DATA  3               /* offset into data segment */
#define N_BSS   4               /* uninitialized data */

/* relocation data is an array of struct reloc with a_relocs elements. */

#define N_RELOFF(x)     (N_SYMOFF(x) + ((x).a_syms * sizeof(struct nlist)))

struct reloc
{
    unsigned r_symidx : 28;     /* index of symbol whose value is needed */
    unsigned r_rel    : 1;      /* true if fixup is %rip-relative */
    unsigned r_text   : 1;      /* true if text fixup, data otherwise */
    unsigned r_size   : 2;      /* log2 of size of fixup (so 1, 2, 4 or 8) */

    unsigned r_offset;          /* into the segment to fixup */
};

/* the string table is a collection of NUL-terminated strings used to
   name symbols (and, in the future, perhaps other things). it appears
   last, after all the other sections in the file.

   a string is uniquely identified by its offset from the beginning of
   the string table. the table is limited to 16Mb because struct nlist
   has only 3 bytes to represent an offset. */

#define N_STROFF(x)     ( N_RELOFF(x) +                                     \
                          + ((x).a_relocs * sizeof(struct reloc))           \
                          + ((x).a_reserved[0])                             \
                          + ((x).a_reserved[1]) )

#endif /* _A_OUT_H */

/* vi: set ts=4 expandtab: */
