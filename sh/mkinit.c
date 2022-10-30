/*****************************************************************************

   mkinit.c                                                    ux/64 shell

******************************************************************************

   derived from ash, contributed to Berkeley by Kenneth Almquist.
   Copyright (c) 1991 The Regents of the University of California.

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

/*
 * This program scans all the source files for code to handle various
 * special events and combines this code into one file.  This (allegedly)
 * improves the structure of the program since there is no need for
 * anyone outside of a module to know that that module performs special
 * operations on particular events.  The command is executed iff init.c
 * is actually changed.
 *
 * Usage:  mkinit command sourcefile...
 */


#include <sys/cdefs.h>

#include <sys/types.h>
#include <stdio.h>
#include <fcntl.h>


/*
 * OUTFILE is the name of the output file.  Output is initially written
 * to the file OUTTEMP, which is then moved to OUTFILE if OUTTEMP and
 * OUTFILE are different.
 */

#define OUTFILE "init.c"
#define OUTTEMP "init.c.new"
#define OUTOBJ "init.o"


/*
 * A text structure is basicly just a string that grows as more characters
 * are added onto the end of it.  It is implemented as a linked list of
 * blocks of characters.  The routines addstr and addchar append a string
 * or a single character, respectively, to a text structure.  Writetext
 * writes the contents of a text structure to a file.
 */

#define BLOCKSIZE 512

struct text {
    char *nextc;
    int nleft;
    struct block *start;
    struct block *last;
};

struct block {
    struct block *next;
    char text[BLOCKSIZE];
};


/*
 * There is one event structure for each event that mkinit handles.
 */

struct event {
    char *name;     /* name of event (e.g. INIT) */
    char *routine;      /* name of routine called on event */
    char *comment;      /* comment describing routine */
    struct text code;       /* code for handling event */
};


char writer[] = "\
/*\n\
 * This file was generated by the mkinit program.\n\
 */\n\
\n";

char init[] = "\
/*\n\
 * Initialization code.\n\
 */\n";

char reset[] = "\
/*\n\
 * This routine is called when an error or an interrupt occurs in an\n\
 * interactive shell and control is returned to the main command loop.\n\
 */\n";

char shellproc[] = "\
/*\n\
 * This routine is called to initialize the shell to run a shell procedure.\n\
 */\n";


struct event event[] = {
    {"INIT", "init", init},
    {"RESET", "reset", reset},
    {"SHELLPROC", "initshellproc", shellproc},
    {NULL, NULL}
};


char *curfile;              /* current file */
int linno;              /* current line */
char *header_files[200];        /* list of header files */
struct text defines;            /* #define statements */
struct text decls;          /* declarations */
int amiddecls;              /* for formatting */


void readfile(), doevent(), doinclude(), dodecl(), output();
void addstr(), addchar(), writetext();

#define equal(s1, s2)   (strcmp(s1, s2) == 0)

FILE *ckfopen();
char *savestr();
void *ckmalloc __P((int));
void error();

main(argc, argv)
    char **argv;
    {
    char **ap;
    int fd;
    char c;

    if (argc < 2)
        error("Usage:  mkinit command file...");
    header_files[0] = "\"shell.h\"";
    header_files[1] = "\"mystring.h\"";
    for (ap = argv + 2 ; *ap ; ap++)
        readfile(*ap);
    output();
    if (file_changed()) {
        unlink(OUTFILE);
        link(OUTTEMP, OUTFILE);
        unlink(OUTTEMP);
    } else {
        unlink(OUTTEMP);
        if (touch(OUTOBJ))
            exit(0);        /* no compilation necessary */
    }
    printf("%s\n", argv[1]);
    execl("/bin/sh", "sh", "-c", argv[1], (char *)0);
    error("Can't exec shell");
}


/*
 * Parse an input file.
 */

void
readfile(fname)
    char *fname;
    {
    FILE *fp;
    char line[1024];
    struct event *ep;

    fp = ckfopen(fname, "r");
    curfile = fname;
    linno = 0;
    amiddecls = 0;
    while (fgets(line, sizeof line, fp) != NULL) {
        linno++;
        for (ep = event ; ep->name ; ep++) {
            if (line[0] == ep->name[0] && match(ep->name, line)) {
                doevent(ep, fp, fname);
                break;
            }
        }
        if (line[0] == 'I' && match("INCLUDE", line))
            doinclude(line);
        if (line[0] == 'M' && match("MKINIT", line))
            dodecl(line, fp);
        if (line[0] == '#' && gooddefine(line))
            addstr(line, &defines);
    }
    fclose(fp);
}


int
match(name, line)
    char *name;
    char *line;
    {
    register char *p, *q;

    p = name, q = line;
    while (*p) {
        if (*p++ != *q++)
            return 0;
    }
    if (*q != '{' && *q != ' ' && *q != '\t' && *q != '\n')
        return 0;
    return 1;
}


int
gooddefine(line)
    char *line;
    {
    register char *p;

    if (! match("#define", line))
        return 0;           /* not a define */
    p = line + 7;
    while (*p == ' ' || *p == '\t')
        p++;
    while (*p != ' ' && *p != '\t') {
        if (*p == '(')
            return 0;       /* macro definition */
        p++;
    }
    while (*p != '\n' && *p != '\0')
        p++;
    if (p[-1] == '\\')
        return 0;           /* multi-line definition */
    return 1;
}


void
doevent(ep, fp, fname)
    register struct event *ep;
    FILE *fp;
    char *fname;
    {
    char line[1024];
    int indent;
    char *p;

    sprintf(line, "\n      /* from %s: */\n", fname);
    addstr(line, &ep->code);
    addstr("      {\n", &ep->code);
    for (;;) {
        linno++;
        if (fgets(line, sizeof line, fp) == NULL)
            error("Unexpected EOF");
        if (equal(line, "}\n"))
            break;
        indent = 6;
        for (p = line ; *p == '\t' ; p++)
            indent += 8;
        for ( ; *p == ' ' ; p++)
            indent++;
        if (*p == '\n' || *p == '#')
            indent = 0;
        while (indent >= 8) {
            addchar('\t', &ep->code);
            indent -= 8;
        }
        while (indent > 0) {
            addchar(' ', &ep->code);
            indent--;
        }
        addstr(p, &ep->code);
    }
    addstr("      }\n", &ep->code);
}


void
doinclude(line)
    char *line;
    {
    register char *p;
    char *name;
    register char **pp;

    for (p = line ; *p != '"' && *p != '<' && *p != '\0' ; p++);
    if (*p == '\0')
        error("Expecting '\"' or '<'");
    name = p;
    while (*p != ' ' && *p != '\t' && *p != '\n')
        p++;
    if (p[-1] != '"' && p[-1] != '>')
        error("Missing terminator");
    *p = '\0';

    /* name now contains the name of the include file */
    for (pp = header_files ; *pp && ! equal(*pp, name) ; pp++);
    if (*pp == NULL)
        *pp = savestr(name);
}


void
dodecl(line1, fp)
    char *line1;
    FILE *fp;
    {
    char line[1024];
    register char *p, *q;

    if (strcmp(line1, "MKINIT\n") == 0) { /* start of struct/union decl */
        addchar('\n', &decls);
        do {
            linno++;
            if (fgets(line, sizeof line, fp) == NULL)
                error("Unterminated structure declaration");
            addstr(line, &decls);
        } while (line[0] != '}');
        amiddecls = 0;
    } else {
        if (! amiddecls)
            addchar('\n', &decls);
        q = NULL;
        for (p = line1 + 6 ; *p != '=' && *p != '/' ; p++);
        if (*p == '=') {        /* eliminate initialization */
            for (q = p ; *q && *q != ';' ; q++);
            if (*q == '\0')
                q = NULL;
            else {
                while (p[-1] == ' ')
                    p--;
                *p = '\0';
            }
        }
        addstr("extern", &decls);
        addstr(line1 + 6, &decls);
        if (q != NULL)
            addstr(q, &decls);
        amiddecls = 1;
    }
}



/*
 * Write the output to the file OUTTEMP.
 */

void
output() {
    FILE *fp;
    char **pp;
    struct event *ep;

    fp = ckfopen(OUTTEMP, "w");
    fputs(writer, fp);
    for (pp = header_files ; *pp ; pp++)
        fprintf(fp, "#include %s\n", *pp);
    fputs("\n\n\n", fp);
    writetext(&defines, fp);
    fputs("\n\n", fp);
    writetext(&decls, fp);
    for (ep = event ; ep->name ; ep++) {
        fputs("\n\n\n", fp);
        fputs(ep->comment, fp);
        fprintf(fp, "\nvoid\n%s() {\n", ep->routine);
        writetext(&ep->code, fp);
        fprintf(fp, "}\n");
    }
    fclose(fp);
}


/*
 * Return true if the new output file is different from the old one.
 */

int
file_changed() {
    register FILE *f1, *f2;
    register int c;

    if ((f1 = fopen(OUTFILE, "r")) == NULL
     || (f2 = fopen(OUTTEMP, "r")) == NULL)
        return 1;
    while ((c = getc(f1)) == getc(f2)) {
        if (c == EOF)
            return 0;
    }
    return 1;
}


/*
 * Touch a file.  Returns 0 on failure, 1 on success.
 */

int
touch(file)
    char *file;
    {
    int fd;
    char c;

    if ((fd = open(file, O_RDWR)) < 0)
        return 0;
    if (read(fd, &c, 1) != 1) {
        close(fd);
        return 0;
    }
    lseek(fd, 0L, 0);
    write(fd, &c, 1);
    close(fd);
    return 1;
}



/*
 * A text structure is simply a block of text that is kept in memory.
 * Addstr appends a string to the text struct, and addchar appends a single
 * character.
 */

void
addstr(s, text)
    register char *s;
    register struct text *text;
    {
    while (*s) {
        if (--text->nleft < 0)
            addchar(*s++, text);
        else
            *text->nextc++ = *s++;
    }
}


void
addchar(c, text)
    register struct text *text;
    {
    struct block *bp;

    if (--text->nleft < 0) {
        bp = ckmalloc(sizeof *bp);
        if (text->start == NULL)
            text->start = bp;
        else
            text->last->next = bp;
        text->last = bp;
        text->nextc = bp->text;
        text->nleft = BLOCKSIZE - 1;
    }
    *text->nextc++ = c;
}

/*
 * Write the contents of a text structure to a file.
 */
void
writetext(text, fp)
    struct text *text;
    FILE *fp;
    {
    struct block *bp;

    if (text->start != NULL) {
        for (bp = text->start ; bp != text->last ; bp = bp->next)
            fwrite(bp->text, sizeof (char), BLOCKSIZE, fp);
        fwrite(bp->text, sizeof (char), BLOCKSIZE - text->nleft, fp);
    }
}

FILE *
ckfopen(file, mode)
    char *file;
    char *mode;
    {
    FILE *fp;

    if ((fp = fopen(file, mode)) == NULL) {
        fprintf(stderr, "Can't open %s\n", file);
        exit(2);
    }
    return fp;
}

void *
ckmalloc(nbytes) {
    register char *p;
    char *malloc();

    if ((p = malloc(nbytes)) == NULL)
        error("Out of space");
    return p;
}

char *
savestr(s)
    char *s;
    {
    register char *p;

    p = ckmalloc(strlen(s) + 1);
    strcpy(p, s);
    return p;
}

void
error(msg)
    char *msg;
    {
    if (curfile != NULL)
        fprintf(stderr, "%s:%d: ", curfile, linno);
    fprintf(stderr, "%s\n", msg);
    exit(2);
}

/* vi: set ts=4 expandtab: */
