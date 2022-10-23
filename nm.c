/*****************************************************************************

   nm.c                                             ux/64 object inspector

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
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <a.out.h>
#include <errno.h>
#include <string.h>
#include <ctype.h>
#include <sys/stat.h>

char            *path;          /* path to current file */
struct stat     statbuf;        /* ... and its vitals */
int             fd = -1;        /* ... and its descriptor */
struct exec     exec;           /* ... and its a.out header */
int             r_flag;         /* -r flag: display relocs */

struct nlist    *syms;          /* memory copy of symbol table */
char            *strtab;        /* .............. string table */
struct reloc    *relocs;        /* .............. reloc table */

size_t          symsiz;         /* and their respective sizes */
size_t          strsiz;
size_t          relsiz;

int             errors;         /* count of errors encountered */

/* text of the string in string table at stridx */

#define STRING(stridx)  (strtab + (stridx))

/* print w spaces to stdout */

#define PAD(w)  printf("%*s", (w), "")

/* report an error for the current file with the specified `msg'.
   if `system' is true, report the system error in errno, too.
   bumps the error count so we'll exit with a non-zero status. */

void error(int system, char *msg)
{
    fprintf(stderr, "nm: `%s': %s", path, msg);
    if (system) fprintf(stderr, " (%s)", strerror(errno));
    fputc('\n', stderr);
    ++errors;
}

/* a safe read() function. if the read is short
   or an error is indicated, reports the error
   and returns zero; otherwise returns true */

int read0(void *buf, size_t n)
{
    ssize_t cnt;
    int ret = 1;

    cnt = read(fd, buf, n);

    if (cnt < 0) { error(1, "I/O error"); ret = 0; }
    if (cnt != n) { error(0, "short read"); ret = 0; }

    return ret;
}


int main(int argc, char **argv)
{
    int opt;

    while ((opt = getopt(argc, argv, "r")) != -1)
    {
        switch (opt)
        {
        case 'r':   ++r_flag; break;
        default:    goto usage;
        }
    }

    if (argv[optind] == 0) goto usage;

    for (; path = argv[optind]; ++optind) {
        if (syms) { free(syms); syms = 0; }
        if (strtab) { free(strtab); strtab = 0; }
        if (relocs) { free(relocs); relocs = 0; }
        if (fd != -1) { close(fd); fd = -1; }

        if ((fd = open(path, O_RDONLY)) == -1)
            { error(1, "can't open"); continue; }

        if (fstat(fd, &statbuf) == -1)
            { error(1, "can't stat"); continue; }

        if (!S_ISREG(statbuf.st_mode))
            { error(0, "not a regular file"); continue; }

        if (statbuf.st_size < sizeof(exec))
            { error(0, "not a.out (too small)"); continue; }

        if (!read0(&exec, sizeof(exec))) continue;

        if (N_BADMAG(exec))
            { error(0, "not a.out (bad magic)"); continue; }

        /* looks like an a.out; from here, we'll protect against
           truncated files (via read0) but otherwise blindly trust
           that the header (and referenced metadata) aren't bogus.

           this extends to assuming malloc() always succeeds, as
           a valid a.out will never require that we allocate an
           unreasonable amount of memory, and reasonable requests
           will always succeed (otherwise, why have a vm system?)

           lseek() also never fails when given a reasonable offset */

        symsiz = exec.a_syms * sizeof(struct nlist);
        syms = malloc(symsiz);
        lseek(fd, N_SYMOFF(exec), SEEK_SET);
        if (!read0(syms, symsiz)) continue;

        strsiz = statbuf.st_size - N_STROFF(exec);
        strtab = malloc(strsiz);
        lseek(fd, N_STROFF(exec), SEEK_SET);
        if (!read0(strtab, strsiz)) continue;

        if (!r_flag) {
            /* dump the symbol table. unlike V7 nm, which presumably
               had its origins before pipes were a thing, we perform
               no sorting or filtering here. that's for `sort' et al;
               we try to format the output to make their jobs easy. */

            struct nlist *n;

            for (n = syms; exec.a_syms--; ++n) {
                int type /* = "uatdb"[n->n_type] tempting but naughty */ ;

                switch (n->n_type)
                {
                case N_UNDF:    type = 'u'; break;
                case N_ABS:     type = 'a'; break;
                case N_TEXT:    type = 't'; break;
                case N_DATA:    type = 'd'; break;
                case N_BSS:     type = 'b'; break;
                }

                fputc(n->n_globl ? toupper(type) : type, stdout);

                if (n->n_type != N_UNDF)
                    printf(" %016x ", n->n_value);
                else
                    PAD(18);

                if (n->n_type == N_BSS)
                    printf("(%d) ", 1 << n->n_align);
                else
                    PAD(4);

                printf("%s\n", STRING(n->n_stridx));
            }
        } else {
            struct reloc *r;

            relsiz = exec.a_relocs * sizeof(struct reloc);
            relocs = malloc(relsiz);
            lseek(fd, N_RELOFF(exec), SEEK_SET);
            if (!read0(relocs, relsiz)) continue;

            for (r = relocs; exec.a_relocs--; ++r)
            {
                struct nlist *n = &syms[r->r_symidx];

                printf("%c %08x (%d) %c %s\n", r->r_text ? 't' : 'd',
                                               r->r_offset,
                                               1 << r->r_size,
                                               r->r_rel ? '+' : ' ',
                                               STRING(n->n_stridx));
            }
        }
    }

    return errors;

usage:
    fprintf(stderr, "usage: nm [-r] files...\n");
    return 1;
}

/* vi: set ts=4 expandtab: */
