/*****************************************************************************

   ar.c                                                  jewel/os archiver

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
   derived from UNIX (Seventh Edition), which is in the public domain.

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
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <time.h>
#include <string.h>
#include <errno.h>
#include <ar.h>
#include <sys/types.h>
#include <sys/stat.h>

#define BUFSZ   4096        /* size of transfer I/O buffer (configurable) */

char man[] = "mrxtdpq";     /* mandatory command-line options */
char opt[] = "uvnbail";     /* optional ..................... */

/* signals to catch or block, as appropriate */

int signum[] = { SIGHUP, SIGINT, SIGQUIT, 0 };

/* command line flags 'a' .. 'z' */

char flg[26];

/* the member names mentioned on the command line
   end up in namv[0..namc-1] (exactly analogous to
   argc/argv). as members are processed, their names
   are set to 0 in this vector. */

char **namv;    int namc;

/* we create up to three temporary files when creating
   or modifying an archive. they are ultimately pieced
   together by install(). */

#define TMPDIR  "/tmp/"         /* default directory for temp files */
#define TMPNAM  "arXXXXXX"      /* and mktemp() template for them */

char tmp0nam[] = TMPDIR TMPNAM,         /* we default to using /tmp */
     tmp1nam[] = TMPDIR TMPNAM,         /* for all temporaries, unless */
     tmp2nam[] = TMPDIR TMPNAM;         /* the `l' option is specified */

char *tf0nam;   int tf0;
char *tf1nam;   int tf1;
char *tf2nam;   int tf2;

char *arnam;    int af;         /* archive file path and its descriptor */
char *ponam;                    /* positional member name (if any) */
char *file;                     /* name of member currently being processed */

int qf;                         /* file descriptor for qcmd() */

/* read the next header from the archive file.
   on success, sets `file' to the name of the
   member whose header was read and returns 0.
   if there are no more members, returns 1. */

struct ar_hdr arbuf;

int
getdir(void)
{
    static char name[NAME_MAX+1];
    int i;

    i = read(af, &arbuf, sizeof arbuf);

    if(i != sizeof arbuf) {
        if (tf1nam) {
            i = tf0;        /* undo the swap done by */
            tf0 = tf1;      /* positioning logic, see */
            tf1 = i;        /* comments for bamatch() */
        }

        return(1);
    }

    for(i = 0; i < NAME_MAX; i++)
        name[i] = arbuf.ar_name[i];

    file = name;
    return(0);
}

/* scans the member-name vector and returns
   the number of members still outstanding. */

int
morefil(void)
{
    int i, n;

    n = 0;

    for (i=0; i < namc; i++)
        if (namv[i])
            n++;

    return n;
}

/* open the path in `file' for reading, fill `stbuf' with its
   stats, and return the descriptor. returns -1 on error. */

struct stat stbuf;

int
stats(void)
{
    int f;

    f = open(file, 0);
    if (f < 0) return(f);

    if (fstat(f, &stbuf) < 0) {
        close(f);
        return(-1);
    }

    return(f);
}

/* trim a pathname `s' down to its basename - i.e.,
   remove directory components and trailing slashes */

char *
trim(char *s)
{
    char *p1, *p2;

    for (p1 = s; *p1; p1++)
        ;

    while (p1 > s) {
        if(*--p1 != '/')
            break;

        *p1 = 0;
    }

    p2 = s;

    for (p1 = s; *p1; p1++)
        if (*p1 == '/')
            p2 = p1+1;

    return(p2);
}

/* produce a status message labeled with action letter `c'. */

void
mesg(int c)
{
    if(flg['v'-'a']) /* quiet by default */
        if(c != 'c' || flg['v'-'a'] > 1)
            printf("%c - %s\n", c, file);
}

/* clean up temporary files and
   exit with the given status */

void
done(int status)
{
    if(tf0nam) unlink(tf0nam);
    if(tf1nam) unlink(tf1nam);
    if(tf2nam) unlink(tf2nam);
    exit(status);
}

/* report a write error and abort */

void
wrerr(void)
{
    perror("ar write error");
    done(1);
}

/* print usage message and abort */

void
usage(void)
{
    printf("usage: ar [%s][%s] archive files ...\n", opt, man);
    done(1);
}

/* caught an unmasked signal */

void
sigdone(int sig)
{
    done(100);
}

/* opens the archive file `arnam' for reading
   as `af', and verifies its magic.

   returns zero on success.

   if the file can't be opened, then returns
   non-zero, unless `must' is true, in which
   case it errors out.

   aborts with an error if the magic is wrong. */

int
getaf(int must)
{
    armag_t mbuf;

    af = open(arnam, 0);

    if (af < 0)
        if (must) {
            fprintf(stderr, "ar: %s does not exist\n", arnam);
            done(1);
        } else
            return(1);

    if (read(af, &mbuf, sizeof(mbuf)) != sizeof(mbuf) || mbuf!=ARMAG) {
        fprintf(stderr, "ar: %s not in archive format\n", arnam);
        done(1);
    }

    return(0);
}

/* open a temporary `tf0' where we'll build the resulting archive. seed
   it with ARMAGIC. use `tmp0nam' as the template for its path `tf0nam'. */

void
init(void)
{
    static armag_t mbuf = ARMAG;

    tf0nam = mktemp(tmp0nam);
    close(creat(tf0nam, 0600));
    tf0 = open(tf0nam, 2);

    if(tf0 < 0) {
        fprintf(stderr, "ar: cannot create temp file\n");
        done(1);
    }

    if (write(tf0, &mbuf, sizeof(mbuf)) != sizeof(mbuf))
        wrerr();
}

/* bamatch() handles positioning. when a before or after position is
   specified on the command line, bastate is set to BA_SEARCH. as the
   archive processing proceeds, bamatch() is called for each member to
   see if it's the position member, and if so, moves on to BA_FOUND
   (either immediately, or at the next member, depending on whether the
   position desired is before or after the position member). BA_FOUND
   opens a new temporary and swaps it out from underneath everyone else,
   so that subsequent members will be copied to the new temporary. once
   all old members are processed, getdir() will undo the swap. install()
   glues the files together in the right order. */

#define BA_IDLE     0
#define BA_SEARCH   1
#define BA_FOUND    2

int bastate;

void
bamatch(void)
{
    int f;

    switch(bastate) {

    case BA_SEARCH:
        if(strcmp(file, ponam) != 0)
            return;

        bastate = BA_FOUND;

        if(flg['a'-'a'])        /* if positioning `before', */
            return;             /* we fall through immediately */

    case BA_FOUND:
        bastate = BA_IDLE;
        tf1nam = mktemp(tmp1nam);
        close(creat(tf1nam, 0600));
        f = open(tf1nam, 2);

        if(f < 0) {
            fprintf(stderr, "ar: cannot create second temp\n");
            return;
        }

        tf1 = tf0;
        tf0 = f;
    }
}

/* copy bytes from file `fi' to file `fo'. the
   number of bytes is given in arbuf.ar_size. */

#define SKIP 1          /* skip the file specified, do not copy it */
#define IODD 2          /* pad the input size to an ARPAD boundary */
#define OODD 4          /* pad the output size to an ARPAD boundary */
#define HEAD 8          /* prefix the output with contents of ar_hdr */

void
copyfil(int fi, int fo, int flag)
{
    int i, o;
    int pe;
    int pad;
    char buf[BUFSZ];

    if (flag & HEAD)
        if (write(fo, (char *)&arbuf, sizeof arbuf) != sizeof arbuf)
            wrerr();

    pe = 0;

    while (arbuf.ar_size > 0) {
        i = o = BUFSZ;

        if (arbuf.ar_size < i) {
            i = o = arbuf.ar_size;

            if (i & (ARPAD - 1)) {
                pad = ARPAD - (i & (ARPAD - 1));
                if(flag & IODD) i += pad;
                if(flag & OODD) o += pad;
            }
        }

        if (read(fi, buf, i) != i) pe++;

        if ((flag & SKIP) == 0)
            if (write(fo, buf, o) != o)
                wrerr();

        arbuf.ar_size -= BUFSZ;
    }

    if (pe) fprintf(stderr, "ar: phase error on %s\n", file);
}

/* in the final step of write operations (except `q'), we
   create/overwrite the archive by piecing together up to
   three temp files (tf0, tf2, tf1 ... in that order). */

void
install0(char *nam, int tf)
{
    int i;
    char buf[BUFSZ];

    if (nam) {
        lseek(tf, 0, SEEK_SET);

        while ((i = read(tf, buf, BUFSZ)) > 0)
            if (write(af, buf, i) != i)
                wrerr();
    }
}

void
install(void)
{
    int i;

    for(i=0; signum[i]; i++)            /* don't allow interrupts or */
        signal(signum[i], SIG_IGN);     /* the archive will be trashed */

    if(af < 0)
        if(!flg['c'-'a'])
            fprintf(stderr, "ar: creating %s\n", arnam);

    close(af);
    af = creat(arnam, 0666);

    if (af < 0) {
        fprintf(stderr, "ar: cannot create %s\n", arnam);
        done(1);
    }

    install0(tf0nam, tf0);
    install0(tf2nam, tf2);
    install0(tf1nam, tf1);
}

/* insert the file `file' into the temporary file,
   prepending an appropriately initialized ar_hdr,
   then close `f'. */

void
movefil(int f)
{
    char *cp;
    int i;

    cp = trim(file);

    for (i = 0; i < NAME_MAX; i++)
        if(arbuf.ar_name[i] = *cp)
            cp++;

    arbuf.ar_size = stbuf.st_size;
    arbuf.ar_date = stbuf.st_mtime;
    arbuf.ar_uid = stbuf.st_uid;
    arbuf.ar_gid = stbuf.st_gid;
    arbuf.ar_mode = stbuf.st_mode;
    copyfil(f, tf0, OODD+HEAD);
    close(f);
}

/* determine if the name in `file' matches any of the member names
   specified on the command line. names match if they have the same
   base name. if a match is found, `file' is replaced with the full
   name from the command line, the command-line entry is obliterated,
   and true is returned. otherwise does nothing and returns false. */

int
match(void)
{
    int i;

    for(i=0; i<namc; i++) {
        if(namv[i] == 0)
            continue;

        if (strcmp(trim(namv[i]), file) == 0) {
            file = namv[i];
            namv[i] = 0;
            return(1);
        }
    }

    return(0);
}

/* r: replace files in archive */

void
rcmd(void)
{
    int f, i;

    init();
    getaf(0);

    while(!getdir()) {
        bamatch();

        if(namc == 0 || match()) {
            f = stats();

            if(f < 0) {
                if(namc)
                    fprintf(stderr, "ar: cannot open %s\n", file);
                goto cp;
            }

            if(flg['u'-'a'])
                if(stbuf.st_mtime <= arbuf.ar_date) {
                    close(f);
                    goto cp;
                }

            mesg('r');
            copyfil(af, -1, IODD+SKIP);
            movefil(f);
            continue;
        }

cp:
        mesg('c');
        copyfil(af, tf0, IODD+OODD+HEAD);
    }

    for (i = 0; i < namc; i++) {
        file = namv[i];
        if (file == 0) continue;

        namv[i] = 0;
        mesg('a');
        f = stats();

        if (f < 0) {
            fprintf(stderr, "ar: %s cannot open\n", file);
            continue;
        }

        movefil(f);
    }

    install();
}

/* d: delete files from archive */

void
dcmd(void)
{
    init();
    getaf(1);

    while (!getdir()) {
        if (match()) {
            mesg('d');
            copyfil(af, -1, IODD+SKIP);
        } else {
            mesg('c');
            copyfil(af, tf0, IODD+OODD+HEAD);
        }
    }

    install();
}

/* x: extract files from archive */

void
xcmd(void)
{
    int f;

    getaf(1);

    while(!getdir()) {
        if(namc == 0 || match()) {
            f = creat(file, arbuf.ar_mode & 0777);
            if(f < 0) {
                fprintf(stderr, "ar: %s cannot create\n", file);
                goto sk;
            }
            mesg('x');
            copyfil(af, f, IODD);
            close(f);
            continue;
        }
sk:
        mesg('c');
        copyfil(af, -1, IODD+SKIP);

        if (namc > 0 && !morefil())
            done(0);
    }
}

/* p: print files from archive */

void
pcmd(void)
{
    getaf(1);

    while (!getdir()) {
        if (namc == 0 || match()) {
            if(flg['v'-'a']) {
                printf("\n<%s>\n\n", file);
                fflush(stdout);
            }
            copyfil(af, 1, IODD);
        } else
            copyfil(af, -1, IODD+SKIP);
    }
}

/* m: move files around inside archive */

void
mcmd(void)
{
    init();
    getaf(1);

    tf2nam = mktemp(tmp2nam);
    close(creat(tf2nam, 0600));
    tf2 = open(tf2nam, 2);
    if(tf2 < 0) {
        fprintf(stderr, "ar: cannot create third temp\n");
        done(1);
    }
    while(!getdir()) {
        bamatch();
        if(match()) {
            mesg('m');
            copyfil(af, tf2, IODD+OODD+HEAD);
            continue;
        }
        mesg('c');
        copyfil(af, tf0, IODD+OODD+HEAD);
    }
    install();
}

/* when `v' is specified with `t', longt()
   prints out a long table of contents.

   the formatting here could use some work. */

int m1[] = { 1, S_IRUSR, 'r', '-' };
int m2[] = { 1, S_IWUSR, 'w', '-' };
int m3[] = { 2, S_ISUID, 's', S_IXUSR, 'x', '-' };
int m4[] = { 1, S_IRGRP, 'r', '-' };
int m5[] = { 1, S_IWGRP, 'w', '-' };
int m6[] = { 2, S_ISGID, 's', S_IXGRP, 'x', '-' };
int m7[] = { 1, S_IROTH, 'r', '-' };
int m8[] = { 1, S_IWOTH, 'w', '-' };
int m9[] = { 2, S_ISVTX, 't', S_IXOTH, 'x', '-' };

int *m[] = { m1, m2, m3, m4, m5, m6, m7, m8, m9};

void
longt(void)
{
    char *cp;
    int n, *ap, **mp;

    for (mp = &m[0]; mp < &m[9];) {
        int n, *ap;

        ap = *mp++;
        n = *ap++;

        while (--n >= 0 && (arbuf.ar_mode & *ap++) == 0)
            ap++;

        putchar(*ap);
    }

    cp = ctime(&arbuf.ar_date);

    printf("  %-12.12s %-4.4s (%d/%d) %ld", cp+4,
                                            cp+20,
                                            arbuf.ar_uid,
                                            arbuf.ar_gid,
                                            arbuf.ar_size);
}

/* t: table of contents */

void
tcmd(void)
{
    getaf(1);

    while(!getdir()) {
        if(namc == 0 || match()) {
            printf("%-*s", NAME_MAX + 2, trim(file));

            if(flg['v'-'a'])
                longt();

            putchar('\n');
        }
        copyfil(af, -1, IODD+SKIP);
    }
}

/* helper for qcmd(). should be merged into its body. */

void
getqf(void)
{
    armag_t mbuf;

    if ((qf = open(arnam, 2)) < 0) {
        if(!flg['c'-'a'])
            fprintf(stderr, "ar: creating %s\n", arnam);
        close(creat(arnam, 0666));
        if ((qf = open(arnam, 2)) < 0) {
            fprintf(stderr, "ar: cannot create %s\n", arnam);
            done(1);
        }
        mbuf = ARMAG;
        if (write(qf, &mbuf, sizeof(mbuf)) != sizeof(mbuf))
            wrerr();
    }
    else if (read(qf, &mbuf, sizeof(mbuf)) != sizeof(mbuf) || mbuf!=ARMAG) {
        fprintf(stderr, "ar: %s not in archive format\n", arnam);
        done(1);
    }
}

/* q: quick append. this is the only update command
   that writes to the archive in-place, hence `quick' */

void
qcmd(void)
{
    int i, f;

    if (flg['a'-'a'] || flg['b'-'a']) {
        fprintf(stderr, "ar: abi not allowed with q\n");
        done(1);
    }

    getqf();

    for (i = 0; signum[i]; i++)
        signal(signum[i], SIG_IGN);

    lseek(qf, 0, SEEK_END);

    for (i = 0; i < namc; i++) {
        file = namv[i];
        if (file == 0) continue;
        namv[i] = 0;
        mesg('q');
        f = stats();

        if (f < 0)
            fprintf(stderr, "ar: %s cannot open\n", file);
        else {
            tf0 = qf;
            movefil(f);
            qf = tf0;
        }
    }
}

/* main() calls this right before exit to scan the name vector
   one last time. only unprocessed elements remain, and that
   means there was a problem. (should combine with morefil) */

int
notfound(void)
{
    int i, n;

    n = 0;

    for (i = 0; i < namc; i++)
        if (namv[i]) {
            fprintf(stderr, "ar: %s not found\n", namv[i]);
            n++;
        }

    return n;
}

/* helper for main(): set selected command */

void (*comfun)(void);   /* handler for command */

void
setcom(void (*fun)(void))
{
    if (comfun != 0) {
        fprintf(stderr, "ar: only one of [%s] allowed\n", man);
        done(1);
    }

    comfun = fun;
}

int
main(int argc, char **argv)
{
    int i;
    char *cp;

    for (i = 0; signum[i]; i++)
        if (signal(signum[i], SIG_IGN) != SIG_IGN)
            signal(signum[i], sigdone);

    if (argc < 3) usage();

    for (cp = argv[1]; *cp; cp++)
        switch(*cp)
        {
        case 'l':
        case 'v':
        case 'u':
        case 'n':
        case 'a':
        case 'b':
        case 'c':
        case 'i':   flg[*cp - 'a']++; break;

        case 'r':   setcom(rcmd); break;
        case 'd':   setcom(dcmd); break;
        case 'x':   setcom(xcmd); break;
        case 't':   setcom(tcmd); break;
        case 'p':   setcom(pcmd); break;
        case 'm':   setcom(mcmd); break;
        case 'q':   setcom(qcmd); break;

        default:    fprintf(stderr, "ar: bad option `%c'\n", *cp);
                    done(1);
        }

    if (flg['l'-'a']) {
        strcpy(tmp0nam, TMPNAM);
        strcpy(tmp1nam, TMPNAM);
        strcpy(tmp2nam, TMPNAM);
    }

    if (flg['i'-'a'])
        flg['b'-'a']++;

    if (flg['a'-'a'] || flg['b'-'a']) {
        bastate = BA_SEARCH;
        ponam = trim(argv[2]);
        argv++;
        argc--;
        if(argc < 3) usage();
    }

    arnam = argv[2];
    namv = argv + 3;
    namc = argc - 3;

    if (comfun == 0) {
        if (flg['u'-'a'] == 0) {
            fprintf(stderr, "ar: one of [%s] must be specified\n", man);
            done(1);
        }

        setcom(rcmd);
    }

    (*comfun)();
    done(notfound());
}

/* vi: set ts=4 expandtab: */
