/*****************************************************************************

   compress.c                                               minix compress

******************************************************************************

   derived from the public domain compress 4.1 utility originally written
   by Spencer W. Thomas, Jim McKie, Steve Davies, Ken Turkowski, James A.
   Woods and Joe Orost; later modified by Richard Todd and Andy Tanenbaum.

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

#include <stdio.h>
#include <fcntl.h>
#include <ctype.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <utime.h>
#include <unistd.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/stat.h>

#define min(a,b)    ((a>b) ? b : a)

#define DOTZ ".Z"

#define DEFAULTBITS     16          /* default bits (-b) setting */
#define BITS            16          /* most bits we support (16 max) */
#define HSIZE           69001       /* htab[] size (95% occupancy) */
#define CHECK_GAP       10000       /* compression ratio check interval */

unsigned char magic_header[] = "\037\235";  /* 1F 9D */

/* defines for third byte of header */

#define BIT_MASK    0x1f
#define BLOCK_MASK  0x80

/* masks 0x40 and 0x20 are free. I think 0x20 should mean
   that there is a fourth header byte (for expansion). */

#define INIT_BITS 9         /* initial number of bits/code */

#define ARGVAL() (*++(*argv) || (--argc && *++argv))

int n_bits;                         /* number of bits/code */
int maxbits = DEFAULTBITS;          /* user settable max # bits/code */
int maxcode;                        /* maximum code, given n_bits */
int maxmaxcode = 1 << BITS;         /* should NEVER generate this code */

#define MAXCODE(n_bits)    ((1 << (n_bits)) - 1)

int             hsize = HSIZE;      /* for dynamic table sizing */
long            fsize;

long            htab [HSIZE];
unsigned short  codetab [HSIZE];

/* to save much memory, we overlay the table used by compress() with those
   used by decompress(). the tab_prefix table is the same size and type as
   the codetab. the tab_suffix table needs 2**BITS characters. we get this
   from the beginning of htab. the output stack uses the rest of htab, and
   contains characters. there is plenty of room for any possible stack (stack
   used to be 8000 characters). */

#define tab_prefixof(i)     codetab[i]
#define tab_suffixof(i)     ((unsigned char *)(htab))[i]
#define de_stack            ((unsigned char *)&tab_suffixof(1<<BITS))

int free_ent;              /* first unused entry */
int exit_stat;

void    Usage(void);
void    compress(void);
void    onintr(int dummy);
void    oops(int dummy);
void    output(int code);
int     foreground(void);
void    decompress(void);
int     getcode(void);
void    writeerr(void);
void    copystat(char *ifname, char *ofname);
int     foreground(void);
void    cl_block(void);
void    cl_hash(long hsize);
void    prratio(FILE *stream, long num, long den);
void    version(void);

void Usage() {
#ifdef DEBUG
    fprintf(stderr,"Usage: compress [-dDVfc] [-b maxbits] [file ...]\n");
}
int debug = 0;
#else
    fprintf(stderr,"Usage: compress [-dfvcV] [-b maxbits] [file ...]\n");
}
#endif /* DEBUG */

int     nomagic;        /* 3-byte magic number header, unless old file */
int     zcat_flg;       /* write output on stdout, suppress messages */
int     quiet;          /* don't tell me about compression */

/* block compression parameters -- after all codes are
   used up and compression rate changes, start over. */

int     block_compress  = BLOCK_MASK;
long    checkpoint      = CHECK_GAP;
int     clear_flg;
long    ratio;

/* the next two codes should not be changed lightly, as they
 * must not lie within the contiguous general code space. */

#define FIRST   257             /* first free entry */
#define CLEAR   256             /* table clear output code */

void    (*bgnd_flag)(int);
int     do_decomp;
int     force;
char    ofname[PATH_MAX];
#ifdef DEBUG
int     verbose;
#endif /* DEBUG */


int main(int argc, char **argv)
{
    int         overwrite = 0;      /* do not overwrite unless given -f */
    char        tempname[PATH_MAX];
    char        **filelist, **fileptr;
    char        *cp;
    struct stat statbuf;

    if ((bgnd_flag = signal(SIGINT, SIG_IGN)) != SIG_IGN) {
        signal(SIGINT, onintr);
        signal(SIGSEGV, oops);
    }

    filelist = fileptr = (char **)(malloc((size_t)(argc * sizeof(*argv))));
    *filelist = NULL;

    if ((cp = strrchr(argv[0], '/')) != 0)
        cp++;
    else
        cp = argv[0];

    if (strcmp(cp, "uncompress") == 0)
        do_decomp = 1;
    else if (strcmp(cp, "zcat") == 0) {
        do_decomp = 1;
        zcat_flg = 1;
    }

    setvbuf(stderr, NULL, _IOLBF, 0);

    for (argc--, argv++; argc > 0; argc--, argv++)
    {
        if (**argv == '-')
        {
            while (*++(*argv))
            {
                switch (**argv)
                {
#ifdef DEBUG
                case 'D':   debug = 1;
                            break;

                case 'V':   verbose = 1;
                            version();
                            break;
#else
                case 'V':   version();
                            break;
#endif /* DEBUG */
                case 'v':   quiet = 0;
                            break;

                case 'd':   do_decomp = 1;
                            break;

                case 'f':
                case 'F':   overwrite = 1;
                            force = 1;
                            break;

                case 'n':   nomagic = 1;
                            break;

                case 'C':   block_compress = 0;
                            break;

                case 'b':   if (!ARGVAL())
                            {
                                fprintf(stderr, "Missing maxbits\n");
                                Usage();
                                exit(1);
                            }

                            maxbits = atoi(*argv);
                            goto nextarg;

                case 'c':   zcat_flg = 1;
                            break;

                case 'q':   quiet = 1;
                            break;

                default:    fprintf(stderr, "Unknown flag: '%c'; ", **argv);
                            Usage();
                            exit(1);
                }
            }
        } else {
            *fileptr++ = *argv;     /* build input file list */
            *fileptr = NULL;
        }

        nextarg: continue;
    }

    if (maxbits < INIT_BITS) maxbits = INIT_BITS;
    if (maxbits > BITS) maxbits = BITS;
    maxmaxcode = 1 << maxbits;

    if (*filelist != NULL)
    {
        for (fileptr = filelist; *fileptr; fileptr++)
        {
            exit_stat = 0;

            if (do_decomp != 0)
            {
                /* check for .Z suffix */

                if (strcmp(*fileptr + strlen(*fileptr) - 2, DOTZ) != 0)
                {
                    /* No .Z: tack one on */
                    strcpy(tempname, *fileptr);
                    strcat(tempname, DOTZ);
                    *fileptr = tempname;
                }

                /* open input file */

                if ((freopen(*fileptr, "r", stdin)) == NULL)
                {
                    perror(*fileptr); continue;
                }

                /* check the magic number */

                if (nomagic == 0)
                {
                    unsigned magic1, magic2;

                    if (((magic1 = getc(stdin)) != (magic_header[0] & 0xFF))
                     || ((magic2 = getc(stdin)) != (magic_header[1] & 0xFF)))
                    {
                        fprintf(stderr,
                            "%s: not in compressed format %x %x\n",
                            *fileptr, magic1, magic2);

                        continue;
                    }

                    maxbits = getc(stdin);  /* set -b from file */
                    block_compress = maxbits & BLOCK_MASK;
                    maxbits &= BIT_MASK;
                    maxmaxcode = 1 << maxbits;

                    if (maxbits > BITS)
                    {
                        fprintf(stderr, "%s: compressed with %d bits, "
                                        "can only handle %d bits\n",
                                        *fileptr, maxbits, BITS);

                        continue;
                    }
                }

                /* Generate output filename */

                strcpy(ofname, *fileptr);
                ofname[strlen(*fileptr) - 2] = '\0';  /* Strip off .Z */
            } else {
                if (strcmp(*fileptr + strlen(*fileptr) - 2, DOTZ) == 0)
                {
                    fprintf(stderr,
                            "%s: already has .Z suffix -- no change\n",
                            *fileptr);

                    continue;
                }

                /* open input file */

                if ((freopen(*fileptr, "r", stdin)) == NULL)
                {
                    perror(*fileptr);
                    continue;
                }

                stat(*fileptr, &statbuf);
                fsize = statbuf.st_size;

                /* tune hash table size for small files -- ad hoc,
                   but the sizes match earlier #defines, which serve
                   as upper bounds on the number of output codes. */

                hsize = HSIZE;

                if ( fsize < (1 << 12) )
                    hsize = min ( 5003, HSIZE );
                else if ( fsize < (1 << 13) )
                    hsize = min ( 9001, HSIZE );
                else if ( fsize < (1 << 14) )
                    hsize = min ( 18013, HSIZE );
                else if ( fsize < (1 << 15) )
                    hsize = min ( 35023, HSIZE );
                else if ( fsize < 47000 )
                    hsize = min ( 50021, HSIZE );

                /* generate output filename */

                strcpy(ofname, *fileptr);

                if ((cp=strrchr(ofname,'/')) != NULL)
                    cp++;
                else
                    cp = ofname;

                if (strlen(cp) > (NAME_MAX - 2))
                {
                    fprintf(stderr, "%s: filename too long for .Z\n", cp);
                    continue;
                }

                strcat(ofname, DOTZ);
            }

            /* check for overwrite of existing file */

            if (overwrite == 0 && zcat_flg == 0)
            {
                if (stat(ofname, &statbuf) == 0)
                {
                    char response[2];
                    int fd;

                    response[0] = 'n';
                    fprintf(stderr, "%s already exists;", ofname);

                    if (foreground())
                    {
                        fd = open("/dev/tty", O_RDONLY);

                        fprintf(stderr,
                                " do you wish to overwrite %s (y or n)? ",
                                ofname);

                        fflush(stderr);
                        read(fd, response, 2);

                        while (response[1] != '\n')
                        {
                            if (read(fd, response+1, 1) < 0)
                            {   /* Ack! */
                                perror("stderr");
                                break;
                            }
                        }

                        close(fd);
                    }

                    if (response[0] != 'y')
                    {
                        fprintf(stderr, "\tnot overwritten\n");
                        continue;
                    }
                }
            }

            if (zcat_flg == 0)
            {
                if (freopen(ofname, "w", stdout) == NULL)
                {
                    perror(ofname);
                    continue;
                }

                if (!quiet)
                    fprintf(stderr, "%s: ", *fileptr);
            }

            /* actually do the compression/decompression */

            if (do_decomp == 0)
                compress();

#ifndef DEBUG
            else
                decompress();
#else
            else if (debug == 0)
                decompress();
            else
                printcodes();

            if (verbose)
                dump_tab();
#endif

            if (zcat_flg == 0)
            {
                copystat(*fileptr, ofname);

                if (exit_stat == 1 || !quiet)
                    putc('\n', stderr);
            }
        }
    } else {
        /* standard input */

        if (do_decomp == 0)
        {
            compress();
#ifdef DEBUG
            if(verbose)     dump_tab();
#endif /* DEBUG */
            if(!quiet)
                putc('\n', stderr);
        } else {
            /* check the magic number */

            if (nomagic == 0)
            {
                if ((getc(stdin)!=(magic_header[0] & 0xFF))
                 || (getc(stdin)!=(magic_header[1] & 0xFF)))
                {
                    fprintf(stderr, "stdin: not in compressed format\n");
                    exit(1);
                }

                maxbits = getc(stdin);  /* set -b from file */
                block_compress = maxbits & BLOCK_MASK;
                maxbits &= BIT_MASK;
                maxmaxcode = 1 << maxbits;
                fsize = 100000;

                if (maxbits > BITS)
                {
                    fprintf(stderr, "stdin: compressed with %d bits, "
                                    "can only handle %d bits\n",
                                    maxbits, BITS);

                    exit(1);
                }
            }
#ifndef DEBUG
            decompress();
#else
            if (debug == 0) decompress();
            else        printcodes();
            if (verbose)    dump_tab();
#endif /* DEBUG */
        }
    }

    return(exit_stat);
}

int     offset;
long    in_count = 1;       /* length of input */
long    bytes_out;          /* length of compressed output */
long    out_count;          /* # of codes output (for debugging) */

/* compress stdin to stdout.

   algorithm: use open addressing double hashing (no chaining) on the
   prefix code / next character combination. we do a variant of Knuth's
   algorithm D (vol. 3, sec. 6.4) along with G. Knott's relatively-prime
   secondary probe. here, the modular division first probe is gives way
   to a faster exclusive-or manipulation. also do block compression with
   an adaptive reset, whereby the code table is cleared when the compression
   ratio decreases, but after the table fills. the variable-length output
   codes are re-sized at this point, and a special CLEAR code is generated
   for the decompressor. late addition: construct the table according to
   file size for noticeable speed improvement on small files. */

void compress()
{
    long fcode;
    int i = 0;
    int c;
    int ent;
    int disp;
    int hsize_reg;
    int hshift;

    if (nomagic == 0)
    {
        putc(magic_header[0],stdout);
        putc(magic_header[1],stdout);
        putc((char)(maxbits | block_compress),stdout);
        if(ferror(stdout))
            writeerr();
    }

    offset = 0;
    bytes_out = 3;      /* includes 3-byte header mojo */
    out_count = 0;
    clear_flg = 0;
    ratio = 0;
    in_count = 1;
    checkpoint = CHECK_GAP;
    maxcode = MAXCODE(n_bits = INIT_BITS);
    free_ent = ((block_compress) ? FIRST : 256 );

    ent = getc(stdin);

    hshift = 0;
    for ( fcode = (long) hsize;  fcode < 65536L; fcode *= 2L )
        hshift++;
    hshift = 8 - hshift;        /* set hash code range bound */

    hsize_reg = hsize;
    cl_hash( (long) hsize_reg);        /* clear hash table */

    while ( (c = getc(stdin)) != EOF )
    {
        in_count++;
        fcode = ((long) c << maxbits) + ent;
        i = ((c << hshift) ^ ent);  /* xor hashing */

        if (htab[i] == fcode)
        {
            ent = codetab[i];
            continue;
        } else if (htab[i] < 0)  /* empty slot */
            goto nomatch;

        disp = hsize_reg - i;       /* secondary hash (after G. Knott) */

        if (i == 0)
            disp = 1;
probe:
        if ((i -= disp) < 0)
            i += hsize_reg;

        if (htab[i] == fcode)
        {
            ent = codetab[i];
            continue;
        }

        if (htab[i] > 0)
            goto probe;
nomatch:
        output(ent);
        out_count++;
        ent = c;

        if (free_ent < maxmaxcode)
        {
            codetab[i] = free_ent++;    /* code -> hashtable */
            htab[i] = fcode;
        } else if (in_count >= checkpoint && block_compress)
            cl_block();
    }

    /* put out the final code */

    output(ent);
    ++out_count;
    output(-1);

    /* print out stats on stderr */

    if (zcat_flg == 0 && !quiet)
    {
#ifdef DEBUG
        fprintf(stderr, "%ld chars in, %ld codes (%ld bytes) out, "
                        "compression factor: ", in_count,
                                                out_count,
                                                bytes_out);

        prratio(stderr, in_count, bytes_out);
        fprintf(stderr, "\n");
        fprintf(stderr, "\tCompression as in compact: ");
        prratio(stderr, in_count-bytes_out, in_count);
        fprintf(stderr, "\n");
        fprintf(stderr, "\tLargest code (of last block) was %d (%d bits)\n",
                        free_ent - 1, n_bits);
#else /* !DEBUG */
        fprintf(stderr, "Compression: ");
        prratio(stderr, in_count-bytes_out, in_count);
#endif /* DEBUG */
    }

    if (bytes_out > in_count)   /* exit(2) if no savings */
        exit_stat = 2;
}

/* output the given code. `code' is an (n_bits - bit) integer.
 * if == -1, then EOF. this assumes that n_bits =< wordsize - 1.
 *
 * we maintain a BITS character long buffer (so that 8 codes will
 * fit in it exactly). insert each code in turn. when the buffer
 * fills up, we empty it and start over. */

static char buf[BITS];

unsigned char lmask[9] = {  0xff, 0xfe, 0xfc,
                            0xf8, 0xf0, 0xe0,
                            0xc0, 0x80, 0x00 };

unsigned char rmask[9] = {  0x00, 0x01, 0x03,
                            0x07, 0x0f, 0x1f,
                            0x3f, 0x7f, 0xff };

void output(int code)
{
#ifdef DEBUG
    static int col = 0;
#endif /* DEBUG */

    int r_off = offset, bits = n_bits;
    char * bp = buf;

#ifdef DEBUG
    if ( verbose )
        fprintf( stderr, "%5d%c", code,
            (col+=6) >= 74 ? (col = 0, '\n') : ' ' );
#endif /* DEBUG */

    if (code >= 0)
    {
        /* if this seems strange, it's because it was originally written
           for the VAX; this codes simulates its bit/byte numbering. */

        /* get to the first byte */

        bp += (r_off >> 3);
        r_off &= 7;

        /* since code is always >= 8 bits, only need
           to mask the first hunk on the left. */

        *bp = (*bp & rmask[r_off]) | ((code << r_off) & lmask[r_off]);
        bp++;
        bits -= (8 - r_off);
        code >>= (8 - r_off);

        /* get any 8 bit parts in the middle (<=1 for up to 16 bits). */

        if (bits >= 8)
        {
            *bp++ = code;
            code >>= 8;
            bits -= 8;
        }

        /* last bits */

        if (bits)
            *bp = code;

        offset += n_bits;

        if (offset == (n_bits << 3))
        {
            bp = buf;
            bits = n_bits;
            bytes_out += bits;

            do
                putc(*bp++,stdout);
            while(--bits);

            offset = 0;
        }

        /* if the next entry is going to be too big for
           the code size, then increase it, if possible. */

        if (free_ent > maxcode || (clear_flg > 0))
        {
            /* write the whole buffer, because the input side won't
               discover the size increase until after it has read it. */

            if (offset > 0)
            {
                if (fwrite( buf, 1, n_bits, stdout) != n_bits)
                    writeerr();

                bytes_out += n_bits;
            }

            offset = 0;

            if (clear_flg)
            {
                maxcode = MAXCODE (n_bits = INIT_BITS);
                clear_flg = 0;
            } else {
                n_bits++;

                if (n_bits == maxbits)
                    maxcode = maxmaxcode;
                else
                    maxcode = MAXCODE(n_bits);
            }
#ifdef DEBUG
            if (debug)
            {
                fprintf( stderr, "\nChange to %d bits\n", n_bits );
                col = 0;
            }
#endif /* DEBUG */
        }
    } else {
        /* at EOF, write the rest of the buffer */

        if (offset > 0)
            fwrite( buf, 1, (offset + 7) / 8, stdout );

        bytes_out += (offset + 7) / 8;
        offset = 0;
        fflush(stdout);

#ifdef DEBUG
        if (verbose)
            fprintf(stderr, "\n" );
#endif /* DEBUG */

        if (ferror(stdout))
            writeerr();
    }
}

/* decompress stdin to stdout. this routine adapts to the codes in the
   file building the "string" table on-the-fly; requiring no table to
   be stored in the compressed file. the tables used herein are shared
   with those of the compress() routine. see the definitions above. */

void decompress(void)
{
    unsigned char *stackp;
    int finchar;
    int code, oldcode, incode;

    /* as above, initialize the first 256 entries in the table */

    maxcode = MAXCODE(n_bits = INIT_BITS);

    for (code = 255; code >= 0; code--) {
        tab_prefixof(code) = 0;
        tab_suffixof(code) = code;
    }

    free_ent = (block_compress) ? FIRST : 256;
    finchar = oldcode = getcode();

    if(oldcode == -1)   /* EOF already? */
        return;         /* get out of here */

    putc((char) finchar, stdout);   /* first code must be 8 bits = char */

    if (ferror(stdout))             /* Crash if can't write */
        writeerr();

    stackp = de_stack;

    while ((code = getcode()) > -1) {
        if ((code == CLEAR) && block_compress) {
            for (code = 255; code >= 0; code--)
                tab_prefixof(code) = 0;

            clear_flg = 1;
            free_ent = FIRST - 1;

            if ((code = getcode ()) == -1)    /* O, untimely death! */
                break;
        }

        incode = code;

        /* special case for KwKwK string */

        if (code >= free_ent) {
            *stackp++ = finchar;
            code = oldcode;
        }

        /* generate output characters in reverse order */

        while (code >= 256) {
            *stackp++ = tab_suffixof(code);
            code = tab_prefixof(code);
        }

        *stackp++ = finchar = tab_suffixof(code);

        /* and put them out in forward order */

        do
            putc (*--stackp, stdout);
        while (stackp > de_stack);

        /* generate the new entry */

        if ((code=free_ent) < maxmaxcode)
        {
            tab_prefixof(code) = (unsigned short)oldcode;
            tab_suffixof(code) = finchar;
            free_ent = code + 1;
        }

        /* remember previous code */

        oldcode = incode;
    }

    fflush(stdout);

    if (ferror(stdout))
        writeerr();
}

/* read one code from the standard
   input. if EOF, return -1. */

int getcode(void)
{
    static int offset = 0, size = 0;
    static unsigned char buf[BITS];

    int r_off, bits;
    int code;
    unsigned char *bp = buf;

    if (clear_flg > 0 || offset >= size || free_ent > maxcode)
    {
        /* if the next entry will be too big for the current
           code size, then we must increase the size. this
           implies reading a new buffer full, too. */

        if (free_ent > maxcode)
        {
            n_bits++;

            if (n_bits == maxbits)
                maxcode = maxmaxcode;   /* won't get any bigger now */
            else
                maxcode = MAXCODE(n_bits);
        }

        if (clear_flg > 0)
        {
            maxcode = MAXCODE(n_bits = INIT_BITS);
            clear_flg = 0;
        }

        size = fread(buf, 1, n_bits, stdin);

        if (size <= 0)
            return -1;          /* end of file */

        offset = 0;

        /* round size down to integral number of codes */

        size = (size << 3) - (n_bits - 1);
    }

    r_off = offset;
    bits = n_bits;

    /* get to the first byte */

    bp += (r_off >> 3);
    r_off &= 7;

    /* get first part (low order bits) */

    code = (*bp++ >> r_off);
    bits -= (8 - r_off);
    r_off = 8 - r_off;      /* now, offset into code word */

    /* get any 8-bit parts in the middle ( <= 1 for up to 16 bits). */

    if (bits >= 8)
    {
        code |= *bp++ << r_off;
        r_off += 8;
        bits -= 8;
    }

    /* high order bits */

    code |= (*bp & rmask[bits]) << r_off;
    offset += n_bits;

    return code;
}

#ifdef DEBUG
printcodes()
{
    /*
     * Just print out codes from input file.  For debugging.
     */
    int code;
    int col = 0, bits;

    bits = n_bits = INIT_BITS;
    maxcode = MAXCODE(n_bits);
    free_ent = ((block_compress) ? FIRST : 256 );
    while ( ( code = getcode() ) >= 0 ) {
    if ( (code == CLEAR) && block_compress ) {
        free_ent = FIRST - 1;
        clear_flg = 1;
    }
    else if ( free_ent < maxmaxcode )
        free_ent++;
    if ( bits != n_bits ) {
        fprintf(stderr, "\nChange to %d bits\n", n_bits );
        bits = n_bits;
        col = 0;
    }
    fprintf(stderr, "%5d%c", code, (col+=6) >= 74 ? (col = 0, '\n') : ' ' );
    }
    putc( '\n', stderr );
    exit( 0 );
}
#ifdef DEBUG2
int sorttab[1<<BITS];  /* sorted pointers into htab */
#define STACK_SIZE  500
static char stack[STACK_SIZE];
/* dumptab doesn't use main stack now -prevents distressing crashes */
dump_tab()  /* dump string table */
{
    int i, first;
    ent;
    int stack_top = STACK_SIZE;
    c;

    if(do_decomp == 0) {    /* compressing */
    int flag = 1;

    for(i=0; i<hsize; i++) {    /* build sort pointers */
        if((long) htab[i] >= 0) {
            sorttab[codetab[i]] = i;
        }
    }
    first = block_compress ? FIRST : 256;
    for(i = first; i < free_ent; i++) {
        fprintf(stderr, "%5d: \"", i);
        stack[--stack_top] = '\n';
        stack[--stack_top] = '"'; /* " */
        stack_top = in_stack((int)(htab[sorttab[i]]>>maxbits)&0xff,
                                     stack_top);
        for(ent=htab[sorttab[i]] & ((1<<maxbits)-1);
            ent > 256;
            ent=htab[sorttab[ent]] & ((1<<maxbits)-1)) {
            stack_top = in_stack((int)(htab[sorttab[ent]] >> maxbits),
                        stack_top);
        }
        stack_top = in_stack(ent, stack_top);
        fwrite( &stack[stack_top], (size_t)1, (size_t)(STACK_SIZE-stack_top), stderr);
        stack_top = STACK_SIZE;
    }
   } else if(!debug) {  /* decompressing */

       for ( i = 0; i < free_ent; i++ ) {
       ent = i;
       c = tab_suffixof(ent);
       if ( isascii(c) && isprint(c) )
           fprintf( stderr, "%5d: %5d/'%c'  \"",
               ent, tab_prefixof(ent), c );
       else
           fprintf( stderr, "%5d: %5d/\\%03o \"",
               ent, tab_prefixof(ent), c );
       stack[--stack_top] = '\n';
       stack[--stack_top] = '"'; /* " */
       for ( ; ent != NULL;
           ent = (ent >= FIRST ? tab_prefixof(ent) : NULL) ) {
           stack_top = in_stack(tab_suffixof(ent), stack_top);
       }
       fwrite( &stack[stack_top], (size_t)1, (size_t)(STACK_SIZE - stack_top), stderr );
       stack_top = STACK_SIZE;
       }
    }
}

int
in_stack(c, stack_top)
    int c, stack_top;
{
    if ( (isascii(c) && isprint(c) && c != '\\') || c == ' ' ) {
        stack[--stack_top] = c;
    } else {
        switch( c ) {
        case '\n': stack[--stack_top] = 'n'; break;
        case '\t': stack[--stack_top] = 't'; break;
        case '\b': stack[--stack_top] = 'b'; break;
        case '\f': stack[--stack_top] = 'f'; break;
        case '\r': stack[--stack_top] = 'r'; break;
        case '\\': stack[--stack_top] = '\\'; break;
        default:
        stack[--stack_top] = '0' + c % 8;
        stack[--stack_top] = '0' + (c / 8) % 8;
        stack[--stack_top] = '0' + c / 64;
        break;
        }
        stack[--stack_top] = '\\';
    }
    if (stack_top<0) {
        fprintf(stderr,"dump_tab stack overflow!!!\n");
        exit(1);
    }
    return stack_top;
}
#else
dump_tab() {}
#endif /* DEBUG2 */
#endif /* DEBUG */

void writeerr(void)
{
    perror(ofname);
    unlink(ofname);
    exit(1);
}

void copystat(char *ifname, char *ofname)
{
    struct stat statbuf;
    int mode;
    time_t timep[2];

    fflush(stdout);
    close(fileno(stdout));

    if (stat(ifname, &statbuf))
    {
        perror(ifname);
        return;
    }

    /* meddling with UNIX-style file modes */

    if ((statbuf.st_mode & S_IFMT) != S_IFREG)
    {
        if (quiet)
            fprintf(stderr, "%s: ", ifname);

        fprintf(stderr, " -- not a regular file: unchanged");
        exit_stat = 1;
    } else if (statbuf.st_nlink > 1) {
        if (quiet)
            fprintf(stderr, "%s: ", ifname);

        fprintf(stderr, " -- has %d other links: unchanged",
        statbuf.st_nlink - 1);
        exit_stat = 1;
    } else if (exit_stat == 2 && (!force)) {
        /* no compression: remove file.Z */

        if (!quiet) fprintf(stderr, " -- file unchanged");
    } else {           /* ***** Successful Compression ***** */
        exit_stat = 0;
        mode = statbuf.st_mode & 07777;

        if (chmod(ofname, mode))
            perror(ofname);

        chown(ofname, statbuf.st_uid, statbuf.st_gid);

        timep[0] = statbuf.st_atime;
        timep[1] = statbuf.st_mtime;
        utime(ofname, (struct utimbuf *)timep);

        if (unlink(ifname))
            perror(ifname);

        if (!quiet)
            if (do_decomp == 0)
                fprintf(stderr, " -- compressed to %s", ofname);
            else
                fprintf(stderr, " -- decompressed to %s", ofname);

        return;     /* successful return */
    }

    /* unsuccessful return -- one of the tests failed */

    if (unlink(ofname)) perror(ofname);
}

/* this routine returns 1 if we are running
   in the foreground and stderr is a tty. */

int foreground(void)
{
    if (bgnd_flag)
        return 0;
    else {
        if (isatty(2))
            return 1;
        else
            return 0;
    }
}

/* SIGINT handler */

void onintr(int dummy)
{
    signal(SIGINT, SIG_IGN);
    unlink(ofname);
    exit(1);
}

/* SIGSEGV handler. if we have a
   wild pointer, assume bad input */

void oops(int dummy)
{
    signal(SIGSEGV, SIG_IGN);

    if (do_decomp == 1)
        fprintf (stderr, "uncompress: corrupt input\n");

    unlink(ofname);
    exit(1);
}

/* [here and in prratio() we go out of our way to avoid
    floating point. this isn't really necessary on ATOM - cey] */

void cl_block(void)     /* table clear for block compress */
{
    long rat;

    checkpoint = in_count + CHECK_GAP;
#ifdef DEBUG
    if ( debug ) {
            fprintf ( stderr, "count: %ld, ratio: ", in_count );
            prratio ( stderr, in_count, bytes_out );
        fprintf ( stderr, "\n");
    }
#endif /* DEBUG */

    if (in_count > 0x007fffff) { /* shift will overflow */
        rat = bytes_out >> 8;

        if (rat == 0) {      /* Don't divide by zero */
            rat = 0x7fffffff;
        } else {
            rat = in_count / rat;
        }
    } else {
        rat = (in_count << 8) / bytes_out;  /* 8 fractional bits */
    }

    if (rat > ratio) {
        ratio = rat;
    } else {
        ratio = 0;
#ifdef DEBUG
        if(verbose)
            dump_tab(); /* dump string table */
#endif
        cl_hash(hsize);
        free_ent = FIRST;
        clear_flg = 1;
        output(CLEAR);
#ifdef DEBUG
        if (debug)
            fprintf ( stderr, "clear\n" );
#endif /* DEBUG */
    }
}

void cl_hash(hsize)     /* reset code table */
    long hsize;
{
    memset(htab, -1, hsize * sizeof(long));
}

void prratio(FILE *stream, long num, long den)
{
    int q;

    if (num > 214748L)
        q = num / (den / 10000L);
    else
        q = (10000L * num / den);

    if (q < 0)
    {
        putc('-', stream);
        q = -q;
    }

    fprintf(stream, "%d.%02d%c", q / 100, q % 100, '%');
}

void version()
{
    fprintf(stderr, "compress 4.1\n");
    fprintf(stderr, "Options: ");
#ifdef _MINIX
    fprintf(stderr, "MINIX, ");
#endif
#ifdef DEBUG
    fprintf(stderr, "DEBUG, ");
#endif
    fprintf(stderr, "BITS = %d\n", BITS);
}

/* vi: set ts=4 expandtab: */
