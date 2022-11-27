/*****************************************************************************

   tar.c                                               minix tape archiver

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from John Gilmore's public domain tar (USENET, Nov 1987)

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

#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define DEFBLOCKING     20          /* default blocking factor */
#define DEF_AR_FILE     "-"         /* if no archive file specified */

/* the following causes "tar.h" to produce definitions of al lthe
   global variables, rather than just "extern" declarations of them. */

#define TAR_EXTERN
#include "tar.h"

static FILE     *namef;         /* file to read names from */
static char     **n_argv;       /* argv used by name routines */
static int      n_argc;         /* argc used by name routines */
                                /* (they also use `optind' from getopt) */

/* usage. we should trim this down, this is what manpages are for */

static void
describe(void)
{
    fputs(
        "tar: valid options:\n"
        "-b N    blocking factor N (block size = Nx512 bytes)\n"
        "-B  reblock as we read (for reading 4.2BSD pipes)\n"
        "-c  create an archive\n"
        "-D  don't dump the contents of directories, just the directory\n"
        "-f F read/write archive from file or device F (or hostname:/ForD)\n"
        "-h  don't dump symbolic links; dump the files they point to\n"
        "-i  ignore blocks of zeros in the archive, which normally mean EOF\n"
        "-k  keep existing files, don't overwrite them from the archive\n"
        "-l  stay in the local file system when creating an archive\n"
        "-m  don't extract file modified time\n"
        "-o  write an old V7 format archive, rather than POSIX format\n"
        "-p  do extract all protection information\n"
        "-R  dump record number within archive with each message\n"
        "-s  list of names to extract is sorted to match the archive\n"
        "-t  list a table of contents of an archive\n"
        "-T F    get names to extract or create from file F\n"
        "-v  verbosely list what files we process\n"
        "-x  extract files from an archive\n"
        "-z or Z run the archive through compress\n", stderr);
}

/* parse options for tar */

static int
options(int argc, char **argv)
{
    int c;

    /* set default option values */

    blocking = DEFBLOCKING;
    ar_file = getenv("TAPE");

    if (ar_file == 0)
        ar_file = DEF_AR_FILE;

    while ((c = getoldopt(argc, argv, "b:BcDf:hiklmopRstT:vxzZ")) != EOF) {
        switch (c) {

        case 'b':
            blocking = atoi(optarg);
            break;

        case 'B':
            f_reblock++;        /* For reading 4.2BSD pipes */
            break;

        case 'c':
            f_create++;
            break;

        case 'D':
            f_dironly++;        /* Dump dir, not contents */
            break;

        case 'f':
            ar_file = optarg;
            break;

        case 'h':
            f_follow_links++;   /* follow symbolic links */
            break;

        case 'i':
            f_ignorez++;        /* Ignore zero records (eofs) */
            /*
             * This can't be the default, because Unix tar
             * writes two records of zeros, then pads out the
             * block with garbage.
             */
            break;

        case 'k':               /* don't overwrite files */
            f_keep++;
            break;

        case 'l':
            f_local_filesys++;
            break;

        case 'm':
            f_modified++;
            break;

        case 'o':               /* generate old archive */
            f_oldarch++;
            break;

        case 'p':
            f_use_protection++;
            break;

        case 'R':
            f_sayblock++;       /* print block #s for debug */
            break;              /* of bad tar archives */

        case 's':
            f_sorted_names++;   /* names to extr are sorted */
            break;

        case 't':
            f_list++;
            f_verbose++;        /* "t" output == "cv" or "xv" */
            break;

        case 'T':
            name_file = optarg;
            f_namefile++;
            break;

        case 'v':
            f_verbose++;
            break;

        case 'x':
            f_extract++;
            break;

        case 'z':               /* easy to type */
        case 'Z':               /* like the filename extension .Z */
            f_compress++;
            break;

        case '?':
            describe();
            exit(EX_ARGSBAD);

        }
    }

    blocksize = blocking * RECORDSIZE;
}


/* set up to gather file names for tar. they
   can either come from stdin or from argv. */

static void
name_init(int argc, char **argv)
{
    if (f_namefile) {
        if (optind < argc) {
            fprintf(stderr, "tar: too many args with -T option\n");
            exit(EX_ARGSBAD);
        }
        if (!strcmp(name_file, "-")) {
            namef = stdin;
        } else {
            namef = fopen(name_file, "r");
            if (namef == NULL) {
                fprintf(stderr, "tar: ");
                perror(name_file);
                exit(EX_BADFILE);
            }
        }
    } else {
        /* Get file names from argv, after options. */
        n_argc = argc;
        n_argv = argv;
    }
}

/* get the next name from argv or the name file. result is in
 * static storage and can't be relied upon across two calls. */

char *
name_next(void)
{
    static char buffer[NAMSIZ+2];   /* holding pattern */

    char *p;
    char *q;

    if (namef == NULL) {
        /* names come from argv, after options */
        if (optind < n_argc)
            return n_argv[optind++];

        return NULL;
    }

    for (;;) {
        p = fgets(buffer, NAMSIZ+1 /*nl*/, namef);
        if (p == NULL) return p;                    /* end of file */
        q = p+strlen(p)-1;                          /* find the newline */
        if (q <= p) continue;                       /* ignore empty lines */
        *q-- = '\0';                                /* zap the newline */
        while (q > p && *q == '/')  *q-- = '\0';    /* zap trailing /s */
        return p;
    }
}

/* close the name file, if any */

void
name_close(void)
{
    if (namef != NULL && namef != stdin) fclose(namef);
}

/* add a name to the namelist */

static void
addname(char *name)
{
    struct name *p;     /* current struct pointer */
    int         i;      /* length of string */

    i = strlen(name);
    p = malloc((i + sizeof(struct name) - NAMSIZ));

    if (!p) {
        fprintf(stderr,"tar: cannot allocate mem for namelist entry\n");
        exit(EX_SYSTEM);
    }

    p->next = (struct name *)NULL;
    p->length = i;
    strncpy(p->name, name, i);
    p->name[i] = '\0';
    p->found = 0;
    p->regexp = 0;      /* assume not a regular expression */
    p->firstch = 1;     /* assume first char is literal */

    if (strchr(name, '*') || strchr(name, '[') || strchr(name, '?')) {
        p->regexp = 1;  /* no, it's a regexp */
        if (name[0] == '*' || name[0] == '[' || name[0] == '?')
            p->firstch = 0;     /* not even 1st char literal */
    }

    if (namelast) namelast->next = p;
    namelast = p;
    if (!namelist) namelist = p;
}

/* gather names in a list for scanning. could hash them later if we really
   care. if the names are already sorted to match the archive, we just read
   them one by one. name_gather() reads the first one, and it is called by
   name_match() as appropriate to read the next ones. at EOF, the last name
   read is just left in the buffer. this option lets users of small machines
   extract an arbitrary number of files by doing "tar t" and editing down the
   list of files. */

void
name_gather(void)
{
    static struct name namebuf[1];  /* one-name buffer */

    char *p;

    if (f_sorted_names) {
        p = name_next();

        if (p) {
            namebuf[0].length = strlen(p);

            if (namebuf[0].length >= sizeof namebuf[0].name) {
                fprintf(stderr, "Argument name too long: %s\n", p);
                namebuf[0].length = (sizeof namebuf[0].name) - 1;
            }

            strncpy(namebuf[0].name, p, namebuf[0].length);
            namebuf[0].name[ namebuf[0].length ] = 0;
            namebuf[0].next = (struct name *)NULL;
            namebuf[0].found = 0;
            namelist = namebuf;
            namelast = namelist;
        }
        return;
    }

    /* non sorted names -- read them all in */

    while (NULL != (p = name_next()))
        addname(p);
}

/* match a name from an archive, p, with a name from the namelist. */

int
name_match(char *p)
{
    struct name *nlp;
    int         len;

again:
    if (0 == (nlp = namelist))  /* empty namelist is easy */
        return 1;

    len = strlen(p);
    for (; nlp != 0; nlp = nlp->next) {
        /* if first chars don't match, quick skip */

        if (nlp->firstch && nlp->name[0] != p[0])
            continue;

        /* regular expressions */

        if (nlp->regexp) {
            if (wildmat(p, nlp->name)) {
                nlp->found = 1;         /* remember it matched */
                return 1;               /* we got a match */
            }
            continue;
        }

        /* plain old strings */

        if (nlp->length <= len      /* archive len >= specified */
         && (p[nlp->length] == '\0' || p[nlp->length] == '/')
                        /* Full match on file/dirname */
         && strncmp(p, nlp->name, nlp->length) == 0) /* Name compare */
        {
            nlp->found = 1;             /* remember it matched */
            return 1;                   /* we got a match */
        }
    }

    /* filename from archive not found in namelist.
       if we have the whole namelist here, just return 0.
       otherwise, read the next name in and compare it.
       if this was the last name, namelist->found will remain on.
       if not, we loop to compare the newly read name. */

    if (f_sorted_names && namelist->found) {
        name_gather(); /* read one more */
        if (!namelist->found) goto again;
    }

    return 0;
}

/* print the names of things in the namelist that were not matched */

void
names_notfound(void)
{
    register struct name    *nlp;
    register char       *p;

    for (nlp = namelist; nlp != 0; nlp = nlp->next) {
        if (!nlp->found) {
            fprintf(stderr, "tar: %s not found in archive\n",
                nlp->name);
        }
    }

    namelist = NULL;
    namelast = NULL;

    if (f_sorted_names) {
        while (0 != (p = name_next()))
            fprintf(stderr, "tar: %s not found in archive\n", p);
    }
}

/* main routine for tar */

int
main(int argc, char **argv)
{
    tar = "tar";        /* set program name */

    options(argc, argv);
    name_init(argc, argv);

    if (f_create) {
        if (f_extract || f_list) goto dupflags;
        create_archive();
    } else if (f_extract) {
        if (f_list) goto dupflags;
        extr_init();
        read_and(extract_archive);
    } else if (f_list) {
        read_and(list_archive);
    } else {
dupflags:
        fprintf (stderr, "tar: you must specify exactly "
                         " one of the c, t, or x options\n");
        describe();
        exit(EX_ARGSBAD);
    }

    exit(0);
}

/* vi: set ts=4 expandtab: */
