# 1 "comp.c"

# 39 "/home/charles/xcc/linux/include/sys/defs.h"
typedef unsigned long   __caddr_t;
typedef unsigned        __daddr_t;
typedef unsigned        __dev_t;
typedef unsigned        __gid_t;
typedef unsigned        __ino_t;
typedef unsigned        __mode_t;
typedef unsigned        __nlink_t;
typedef long            __off_t;
typedef int             __pid_t;
typedef unsigned long   __size_t;
typedef long            __ssize_t;
typedef long            __time_t;
typedef unsigned        __uid_t;
typedef char            *__va_list;
# 43 "/home/charles/xcc/linux/include/stdlib.h"
typedef __size_t size_t;









extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern double atof(const char *);
extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void abort(void);
extern void exit(int);

extern int abs(int);
extern long labs(long);
extern void *calloc(size_t, size_t);
extern void free(void *);
extern char *getenv(const char *);
extern void *malloc(size_t);
extern char *mktemp(char *);
extern void *realloc(void *, size_t);
extern float strtof(const char *, char **);
extern double strtod(const char *, char **);
extern long strtol(const char *, char **, int);
extern unsigned long strtoul(const char *, char **, int);

extern void qsort(void *, size_t, size_t,
                  int (*compar)(const void *, const void *));



extern int rand(void);
extern void srand(unsigned);



int putenv(char *string);



int system(const char *command);
# 48 "/home/charles/xcc/linux/include/stdio.h"
typedef __off_t fpos_t;












typedef struct __iobuf
{
    int _count;
    int _fd;
    int _flags;
    int _bufsiz;
    unsigned char *_buf;
    unsigned char *_ptr;
} FILE;

















extern FILE *__iotab[16];
extern FILE __stdin, __stdout, __stderr;








extern int __fillbuf(FILE *);
extern int __flushbuf(int, FILE *);

extern void clearerr(FILE *);
extern int fclose(FILE *);
extern int fflush(FILE *);
extern int fileno(FILE *);
extern int fgetc(FILE *);
extern char *fgets(char *, int n, FILE *);
extern int fgetpos(FILE *, fpos_t *);
extern int fsetpos(FILE *, fpos_t *);
extern int fprintf(FILE *, const char *, ...);
extern int fputc(int, FILE *);
extern int fputs(const char *, FILE *);
extern FILE *fopen(const char *, const char *);
extern size_t fread(void *, size_t, size_t, FILE *);
extern FILE *freopen(const char *, const char *, FILE *);
extern int fscanf(FILE *, const char *, ...);
extern int fseek(FILE *, long, int);
extern long ftell(FILE *);
extern size_t fwrite(const void *, size_t, size_t, FILE *);
extern char *gets(char *);
extern void perror(const char *s);
extern int printf(const char *, ...);
extern int puts(const char *);
extern int remove(const char *);
extern void rewind(FILE *);
extern int rename(const char *, const char *);
extern int scanf(const char *, ...);
extern int sscanf(const char *, const char *, ...);
extern void setbuf(FILE *, char *);
extern int setvbuf(FILE *, char *, int, size_t);
extern int sprintf(char *, const char *, ...);
extern int ungetc(int, FILE *);
extern int vfprintf(FILE *, const char *, __va_list);
extern int vfscanf(FILE *, const char *, __va_list);
extern int vsprintf(char *, const char *, __va_list);


















extern char *tmpnam(char *);



extern FILE *popen(const char *command, const char *type);



extern int pclose(FILE *stream);



extern FILE *fdopen(int fildes, const char *mode);
# 44 "/home/charles/xcc/linux/include/ctype.h"
extern char __ctype[];









extern int isalnum(int);
extern int isalpha(int);
extern int iscntrl(int);
extern int isdigit(int);
extern int isgraph(int);
extern int islower(int);
extern int isprint(int);
extern int ispunct(int);
extern int isspace(int);
extern int isupper(int);
extern int isxdigit(int);
extern int tolower(int);
extern int toupper(int);
# 44 "/home/charles/xcc/linux/include/string.h"
extern void *memmove(void *, const void *, size_t);
extern void *memset(void *, int, size_t);
extern void *memchr(const void *, int, size_t);
extern int memcmp(const void *, const void *, size_t);
extern void *memcpy(void *, const void *, size_t);
extern char *strcat(char *, const char *);
extern char *strchr(const char *, int);
extern int strcmp(const char *, const char *);
extern char *strcpy(char *, const char *);
extern char *strerror(int);
extern size_t strlen(const char *);
extern char *strncat(char *, const char *, size_t);
extern int strncmp(const char *, const char *, size_t);
extern char *strncpy(char *, const char *, size_t);
extern char *strrchr(const char *, int);



extern char *strdup(const char *s);
# 77 "sed.h"
typedef struct  cmd_t
{
        char    *addr1;
        char    *addr2;
        union
        {
                char            *lhs;
                struct cmd_t    *link;
        } u;
        char    command;
        char    *rhs;
        FILE    *fout;
        struct
        {
                unsigned allbut  : 1;
                unsigned global  : 1;
                unsigned print   : 2;
                unsigned inrange : 1;
        } flags;
        unsigned nth;
}
sedcmd;
# 66 "comp.c"
char    linebuf[4000+1];
sedcmd  cmds[200+1];
long    linenum[256];


short   nflag;
int     eargc;
sedcmd  *pending        = ((void *) 0);

short   last_line_used = 0;

void die (const char* msg) {
        fprintf((&__stderr), "sed: ");
        fprintf((&__stderr), msg, linebuf);
        fprintf((&__stderr), "\n");
        exit(2);
}













static const char       AGMSG[] = "garbled address %s";
static const char       CGMSG[] = "garbled command %s";
static const char       TMTXT[] = "too much text: %s";
static const char       AD1NG[] = "no addresses allowed for %s";
static const char       AD2NG[] = "only one address allowed for %s";
static const char       TMCDS[] = "too many commands, last was %s";
static const char       COCFI[] = "cannot open command-file %s";
static const char       UFLAG[] = "unknown flag %c";
static const char       CCOFI[] = "cannot create %s\n";
static const char       ULABL[] = "undefined label %s\n";
static const char       TMLBR[] = "too many {'s";
static const char       FRENL[] = "first RE must be non-null";
static const char       NSCAX[] = "no such command as %s";
static const char       TMRBR[] = "too many }'s";
static const char       DLABL[] = "duplicate label %s";
static const char       TMLAB[] = "too many labels: %s";
static const char       TMWFI[] = "too many w files";
static const char       REITL[] = "RE too long: %s";
static const char       TMLNR[] = "too many line numbers";
static const char       TRAIL[] = "command \"%s\" has trailing garbage";
static const char       RETER[] = "RE not terminated: %s";
static const char       CCERR[] = "unknown character class: %s";


static const char* cclasses[] = {
        "alnum", "a-zA-Z0-9",
        "lower", "a-z",
        "space", " \f\n\r\t\v",
        "alpha", "a-zA-Z",
        "digit", "0-9",
        "upper", "A-Z",
        "blank", " \t",
        "xdigit", "0-9A-Fa-f",
        "cntrl", "\x01-\x1f\x7e",
        "print", " -\x7e",
        "graph", "!-\x7e",
        "punct", "!-/:-@[-`{-\x7e",
        ((void *) 0)};

typedef struct
{
        char            *name;
        sedcmd          *last;
        sedcmd          *address;
} label;


static label    labels[50];
static label    *lab    = labels + 1;
static label    *lablst = labels;


static char     pool[10000];
static char     *fp     = pool;
static char     *poolend = pool + 10000;


static FILE     *cmdf   = ((void *) 0);
static char     *cp;
static sedcmd   *cmdp   = cmds;
static char     *lastre = ((void *) 0);
static int      bdepth  = 0;
static int      bcount  = 0;
static char     **eargv;


static short    eflag;
static short    gflag;


static char *address(char *expbuf);
static char *gettext(char* txp);
static char *recomp(char *expbuf, char redelim);
static char *rhscomp(char* rhsp, char delim);
static char *ycomp(char *ep, char delim);
static int cmdcomp(char cchar);
static int cmdline(char *cbuf);
static label *search(label *ptr);
static void compile(void);
static void resolve(void);


void execute(char* file);


int main(int argc, char *argv[])
{
        eargc   = argc;
        eargv   = argv;
        cmdp->addr1 = pool;
        if (eargc == 1)
                return 0;


        while ((--eargc > 0) && (**++eargv == '-'))
                switch (eargv[0][1])
                {
                case 'e':
                        eflag = 1; compile();
                        eflag = 0;
                        continue;
                case 'f':
                        if (eargc-- <= 0)
                                return 2;
                        if ((cmdf = fopen(*++eargv, "r")) == ((void *) 0))
                        {
                                fprintf((&__stderr), COCFI, *eargv);
                                return 2;
                        }
                        compile();
                        fclose(cmdf);
                        continue;
                case 'g':
                        gflag = 1;
                        continue;
                case 'n':
                        nflag = 1;
                        continue;
                default:
                        fprintf((&__stdout), UFLAG, eargv[0][1]);
                        continue;
                }

        if (cmdp == cmds)
        {
                eargv--; eargc++;
                eflag = 1; compile(); eflag = 0;
                eargv++; eargc--;
        }

        if (bdepth)
                die(TMLBR);

        lablst->address = cmdp;
        resolve();
        if (eargc <= 0)
                execute(((void *) 0));
        else while(--eargc>=0)
                execute(*eargv++);
        return 0;
}





static char     cmdmask[] =
{
        0,      0,      0x80,      0,      0,      0x80+0x01,0,      0,
        0,      0,      0,      0,      0x80+0x06,0,      0,      0x08,
        0x0A,  0,      0,      0,      0x80+0x20,0,      0x0E,  0,
        0x10,  0,      0,      0,      0x80+0x15,0,      0,      0x80+0x17,
        0,      0,      0,      0,      0,      0,      0,      0,
        0,      0x80+0x02, 0x80+0x03, 0x80+0x04, 0x05,   0,      0,      0x07,
        0x09,   0x80+0x0B, 0,      0,      0x80+0x0C, 0,      0x0D,   0,
        0x0F,   0x80+0x11, 0x80+0x12, 0x80+0x13, 0x80+0x14, 0,      0,      0x80+0x16,
        0x18,   0x80+0x19, 0,      0x80+0x03, 0,      0x80,      0,      0,
};


static void compile(void)
{
        char    ccode;
        if (cmdline(cp = linebuf) < 0)
                return;

        if (cmdp == cmds && *cp == '#' && cp[1] == 'n')
                nflag = 1;

        for(;;)
        {
                while ((*cp==' ') || (*cp=='\t')) cp++;
                if (*cp == ';') {
                        cp++;
                        while ((*cp==' ') || (*cp=='\t')) cp++;
                }

                if (*cp == '\0' || *cp == '#')
                        if (cmdline(cp = linebuf) < 0)
                                break;
                while ((*cp==' ') || (*cp=='\t')) cp++;

                if (*cp == '\0' || *cp == '#')
                        continue;


                if (fp > poolend)
                        die(TMTXT);
                else if ((fp = address(cmdp->addr1 = fp)) == ((char *) -1))
                        die(AGMSG);

                if (fp == cmdp->addr1)
                {
                        if (lastre)
                                cmdp->addr1 = lastre;
                        else
                                die(FRENL);
                }
                else if (fp == ((void *) 0))
                {
                        fp = cmdp->addr1;
                        cmdp->addr1 = ((void *) 0);
                }
                else
                {
                        lastre = cmdp->addr1;
                        if (*cp == ',' || *cp == ';')
                        {
                                cp++;
                                if (fp > poolend) die(TMTXT);
                                fp = address(cmdp->addr2 = fp);
                                if (fp == ((char *) -1) || fp == ((void *) 0)) die(AGMSG);
                                if (fp == cmdp->addr2)
                                        cmdp->addr2 = lastre;
                                else
                                        lastre = cmdp->addr2;
                        }
                        else
                                cmdp->addr2 = ((void *) 0);
                }
                if (fp > poolend) die(TMTXT);

                while ((*cp==' ') || (*cp=='\t')) cp++;

                if (*cp == '!') {
                        cmdp->flags.allbut = 1;
                        cp++; while ((*cp==' ') || (*cp=='\t')) cp++;
                }


                if ((*cp < 56) || (*cp > '~')
                        || ((ccode = cmdmask[*cp - 56]) == 0))
                                die(NSCAX);

                cmdp->command = ccode & ~0x80;
                if ((ccode & 0x80) == 0)
                        cp++;
                else if (cmdcomp(*cp++))
                        continue;

                if (++cmdp >= cmds + 200) die(TMCDS);

                while ((*cp==' ') || (*cp=='\t')) cp++;
                if (*cp != '\0')
                {
                        if (*cp == ';')
                        {
                                continue;
                        }
                        else if (*cp != '#' && *cp != '}')
                                die(TRAIL);
                }
        }
}


static int cmdcomp(char cchar)
{
        static sedcmd   **cmpstk[20];
        static const char *fname[10];
        static FILE     *fout[10];
        static int      nwfiles = 2;
        int             i;
        sedcmd          *sp1, *sp2;
        label           *lpt;
        char            redelim;

        fout[0] = (&__stdout);
        fout[1] = (&__stderr);

        fname[0] = "/dev/stdout";
        fname[1] = "/dev/stderr";

        switch(cchar)
        {
        case '{':
                cmdp->flags.allbut = !cmdp->flags.allbut;
                cmpstk[bdepth++] = &(cmdp->u.link);
                if (++cmdp >= cmds + 200) die(TMCDS);
                if (*cp == '\0') *cp++ = ';', *cp = '\0';
                return 1;

        case '}':
                if (cmdp->addr1) die(AD1NG);
                if (--bdepth < 0) die(TMRBR);
                *cmpstk[bdepth] = cmdp;
                return 1;

        case '=':
        case 'q':
                if (cmdp->addr2) die(AD2NG);
                break;

        case ':':
                if (cmdp->addr1) die(AD1NG);
                fp = gettext(lab->name = fp);
                if ((lpt = search(lab)))
                {
                        if (lpt->address) die(DLABL);
                }
                else
                {
                        lab->last = ((void *) 0);
                        lpt = lab;
                        if (++lab >= labels + 50) die(TMLAB);
                }
                lpt->address = cmdp;
                return 1;

        case 'b':
        case 't':
        case 'T':
                while ((*cp==' ') || (*cp=='\t')) cp++;
                if (*cp == '\0')
                {

                        if ((sp1 = lablst->last))
                        {
                                while((sp2 = sp1->u.link))
                                        sp1 = sp2;
                                sp1->u.link = cmdp;
                        }
                        else
                                lablst->last = cmdp;
                        break;
                }
                fp = gettext(lab->name = fp);
                if ((lpt = search(lab)))
                {
                        if (lpt->address)
                                cmdp->u.link = lpt->address;
                        else
                        {
                                sp1 = lpt->last;
                                while((sp2 = sp1->u.link))
                                        sp1 = sp2;
                                sp1->u.link = cmdp;
                        }
                }
                else
                {
                        lab->last = cmdp;
                        lab->address = ((void *) 0);
                        if (++lab >= labels + 50)
                                die(TMLAB);
                }
                break;

        case 'a':
        case 'i':
        case 'r':
                if (cmdp->addr2) die(AD2NG);
        case 'c':
                if ((*cp == '\\') && (*++cp == '\n')) cp++;
                fp = gettext(cmdp->u.lhs = fp);
                break;

        case 'D':
                cmdp->u.link = cmds;
                break;

        case 's':
                if (*cp == 0)
                        die(RETER);
                else
                        redelim = *cp++;

                if ((fp = recomp(cmdp->u.lhs = fp, redelim)) == ((char *) -1))
                        die(CGMSG);
                if (fp == cmdp->u.lhs) {
                        if (lastre) {
                                cmdp->u.lhs = lastre;
                                cp++;
                        }
                        else
                                die(FRENL);
                }
                else
                        lastre = cmdp->u.lhs;

                if ((cmdp->rhs = fp) > poolend) die(TMTXT);
                if ((fp = rhscomp(cmdp->rhs, redelim)) == ((char *) -1)) die(CGMSG);
                if (gflag) cmdp->flags.global++;
                while (*cp == 'g' || *cp == 'p' || *cp == 'P' || ((__ctype+1)[*cp]&0x04))
                {
                        if (*cp == 'g') cp++ , cmdp->flags.global++;
                        if (*cp == 'p') cp++ , cmdp->flags.print = 1;
                        if (*cp == 'P') cp++ , cmdp->flags.print = 2;
                        if (((__ctype+1)[*cp]&0x04))
                        {
                                if (cmdp->nth)
                                        break;

                                cmdp->nth = atoi(cp);
                                while (((__ctype+1)[*cp]&0x04)) cp++;
                        }
                }

        case 'l':
        case 'L':
                if (*cp == 'w')
                        cp++;
                else
                        break;

        case 'w':
        case 'W':
                if (nwfiles >= 10) die(TMWFI);
                fname[nwfiles] = fp;
                fp = gettext((fname[nwfiles] = fp, fp));
                for(i = nwfiles-1; i >= 0; i--)
                        if (strcmp(fname[nwfiles], fname[i]) == 0)
                        {
                                cmdp->fout = fout[i];
                                return 0;
                        }

                if ((cmdp->fout = fopen(fname[nwfiles], "w")) == ((void *) 0))
                {
                        fprintf((&__stderr), CCOFI, fname[nwfiles]);
                        return 2;
                }
                fout[nwfiles++] = cmdp->fout;
                break;

        case 'y':
                fp = ycomp(cmdp->u.lhs = fp, *cp++);
                if (fp == ((char *) -1)) die(CGMSG);
                if (fp > poolend) die(TMTXT);
                break;
        }
        return 0;
}




static char *rhscomp(char* rhsp, char delim)
{
        register char   *p = cp;

        for(;;)

                if ((*rhsp = *p++) == '\\')
                {
                        if (*p >= '0' && *p <= '9')
                        {
                        dobackref:
                                *rhsp = *p++;

                                if (*rhsp > bcount + '0')
                                        return ((char *) -1);
                                *rhsp++ |= 0x80;
                        }
                        else
                        {
                                switch (*p) {
                                        case 'n': *rhsp = '\n'; break;
                                        case 'r': *rhsp = '\r'; break;
                                        case 't': *rhsp = '\t'; break;
                                        default: *rhsp = *p;
                                }
                                rhsp++; p++;
                        }
                }
                else if (*rhsp == delim)
                {
                        *rhsp++ = '\0';
                        cp = p;
                        return rhsp;
                }
                else if (*rhsp == '&')
                {
                        *--p = '0';
                        goto dobackref;
                }
                else if (*rhsp++ == '\0')
                        return ((char *) -1);
}




static char *recomp(char *expbuf, char redelim)
{
        register char   *ep = expbuf;
        register char   *sp = cp;
        register int    c;
        char            negclass;
        char            *lastep;
        char            *lastep2;
        char            *svclass;
        char            brnest[9];
        char            *brnestp;
        char            *pp;
        int             classct;
        int             tags;

        if (*cp == redelim) {
            return ep;
        }

        lastep = lastep2 = ((void *) 0);
        brnestp = brnest;
        tags = bcount = 0;

        if ((*ep++ = (*sp == '^')))
                sp++;

        for (;;)
        {
                if (*sp == 0)
                        die (RETER);
                if (ep >= expbuf + 256)
                        return cp = sp, ((char *) -1);
                if ((c = *sp++) == redelim)
                {
                        cp = sp;
                        if (brnestp != brnest)
                                return ((char *) -1);
                        *ep++ = 22;
                        return ep;
                }

                lastep = lastep2;
                lastep2 = ep;

                switch (c)
                {
                case '\\':
                        if ((c = *sp++) == '(')
                        {
                                if (bcount >= 9)
                                        return cp = sp, ((char *) -1);
                                *brnestp++ = bcount;
                                *ep++ = 12;
                                *ep++ = bcount++;
                                lastep2 = ((void *) 0);
                                continue;
                        }
                        else if (c == ')')
                        {
                                if (brnestp <= brnest)
                                        return cp = sp, ((char *) -1);
                                *ep++ = 14;
                                *ep++ = *--brnestp;
                                tags++;
                                for (lastep2 = ep-1; *lastep2 != 12; )
                                        --lastep2;
                                continue;
                        }
                        else if (c >= '1' && c <= '9' && c != redelim)
                        {
                                if ((c -= '1') >= tags)
                                        return ((char *) -1);
                                *ep++ = 16;
                                *ep++ = c;
                                continue;
                        }
                        else if (c == '\n')
                                return cp = sp, ((char *) -1);
                        else if (c == 'n')
                                c = '\n';
                        else if (c == 't')
                                c = '\t';
                        else if (c == 'r')
                                c = '\r';
                        else if (c == '+')
                        {
                          if (lastep == ((void *) 0))
                                goto defchar;
                          pp = ep;
                          *ep++ = *lastep++ | 1;
                          while (lastep < pp)
                                *ep++ = *lastep++;
                          lastep2 = lastep;
                          continue;
                        }
                        goto defchar;

                case '\0':
                        continue;

                case '\n':
                        return cp = sp, ((char *) -1);

                case '.':
                        *ep++ = 4;
                        continue;

                case '*':
                        if (lastep == ((void *) 0))
                                goto defchar;
                        *lastep |= 1;
                        lastep2 = lastep;
                        continue;

                case '$':
                        if (*sp != redelim)
                                goto defchar;
                        *ep++ = 10;
                        continue;

                case '[':
                        if (ep + 33 >= expbuf + 256)
                                die(REITL);
                        *ep++ = 6;
                        if ((negclass = ((c = *sp++) == '^')))
                                c = *sp++;
                        svclass = sp;
                        do {
                                if (c == '\0') die(CGMSG);

                                if (c == '[' && *sp == ':')
                                {

                                  char *p;
                                  const char *p2;
                                  for (p = sp+3; *p; p++)
                                    if  (*p == ']' &&
                                         *(p-1) == ']' &&
                                         *(p-2) == ':')
                                        {
                                          char cc[8];
                                          const char **it;
                                          p2 = sp+1;
                                          for (p2 = sp+1;
                                               p2 < p-2 && p2-sp-1 < sizeof(cc) - 1;
                                               p2++)
                                            cc[p2-sp-1] = *p2;
                                          cc[p2-sp-1] = 0;

                                          it = cclasses;
                                          while (*it && strcmp(*it, cc))
                                                it += 2;
                                          if (!*it++)
                                            die(CCERR);


                                          p2 = *it;
                                          while (*p2) {
                                            if (p2[1] == '-' && p2[2]) {
                                                for (c = *p2; c <= p2[2]; c++)
                                                  ep[c >> 3] |= (1 << (c & 7));
                                                p2 += 3;
                                            }
                                            else {
                                                c = *p2++;
                                                ep[c >> 3] |= (1 << (c & 7));
                                            }
                                          }
                                          sp = p; c = 0; break;
                                        }
                                }


                                if (c == '-' && sp > svclass && *sp != ']')
                                        for (c = sp[-2]; c < *sp; c++)
                                                ep[c >> 3] |= (1 << (c & 7));


                                if (c == '\\')
                                {
                                        if ((c = *sp++) == 'n')
                                                c = '\n';
                                        else if (c == 't')
                                                c = '\t';
                                        else if (c == 'r')
                                                c = '\r';
                                }


                                if (c)
                                  ep[((unsigned char)c) >> 3] |= (1 << (c & 7));
                        } while
                                ((c = *sp++) != ']');


                        if (negclass)
                                for(classct = 0; classct < 32; classct++)
                                        ep[classct] ^= 0xFF;
                        ep[0] &= 0xFE;
                        ep += 32;
                        continue;

                defchar:
                default:
                        *ep++ = 2;
                        *ep++ = c;
                }
        }
}


static int cmdline(char *cbuf)
{
        register int    inc;

        cbuf--;


        if (eflag)
        {
                register char   *p;
                static char     *savep;

                if (eflag > 0)
                {
                        eflag = -1;
                        if (eargc-- <= 0)
                                exit(2);


                        p = *++eargv;
                        while((*++cbuf = *p++))
                                if (*cbuf == '\\')
                                {
                                        if ((*++cbuf = *p++) == '0')
                                                return savep = ((void *) 0), -1;
                                        else
                                                continue;
                                }
                                else if (*cbuf == '\n')
                                {
                                        *cbuf = '\0';
                                        return savep = p, 1;

                                }


                        return savep = ((void *) 0), 1;
                }

                if ((p = savep) == ((void *) 0))
                        return -1;

                while((*++cbuf = *p++))
                        if (*cbuf == '\\')
                        {
                                if ((*++cbuf = *p++) == '0')
                                        return savep = ((void *) 0), -1;
                                else
                                        continue;
                        }
                        else if (*cbuf == '\n')
                        {
                                *cbuf = '\0';
                                return savep = p, 1;
                        }

                return savep = ((void *) 0), 1;
        }


        while((inc = (--(cmdf)->_count >= 0 ? (int) (*(cmdf)->_ptr++) : __fillbuf(cmdf))) != (-1))
                if ((*++cbuf = inc) == '\\')
                        *++cbuf = inc = (--(cmdf)->_count >= 0 ? (int) (*(cmdf)->_ptr++) : __fillbuf(cmdf));
                else if (*cbuf == '\n')
                        return *cbuf = '\0', 1;

        return *++cbuf = '\0', -1;
}


static char *address(char *expbuf)
{
        static int      numl = 0;
        register char   *rcp;
        long            lno;

        if (*cp == '$')
        {
                *expbuf++ = 20;
                *expbuf++ = 22;
                cp++;
                last_line_used = 1;
                return expbuf;
        }
        if (*cp == '/')
                return recomp(expbuf, *cp++);

        rcp = cp; lno = 0;
        while(*rcp >= '0' && *rcp <= '9')
                lno = lno*10 + *rcp++ - '0';

        if (rcp > cp)
        {
                *expbuf++ = 18;
                *expbuf++ = numl;
                linenum[numl++] = lno;
                if (numl >= 256)
                        die(TMLNR);
                *expbuf++ = 22;
                cp = rcp;
                return expbuf;
        }

        return ((void *) 0);
}



static char *gettext(char* txp)
{
        register char   *p = cp;

        while ((*p==' ') || (*p=='\t')) p++;
        do {
                if ((*txp = *p++) == '\\')
                        *txp = *p++;
                if (*txp == '\0')
                        return cp = --p, ++txp;
                else if (*txp == '\n')
                        while ((*p==' ') || (*p=='\t')) p++;
        } while (txp++);
        return txp;
}


static label *search(label *ptr)
{
        register label  *rp;
        for(rp = lablst; rp < ptr; rp++)
                if ((rp->name != ((void *) 0)) && (strcmp(rp->name, ptr->name) == 0))
                        return rp;
        return ((void *) 0);
}


static void resolve(void)
{
        register label          *lptr;
        register sedcmd         *rptr, *trptr;


        for(lptr = lablst; lptr < lab; lptr++)
                if (lptr->address == ((void *) 0))
                {
                        fprintf((&__stderr), ULABL, lptr->name);
                        exit(2);
                }
                else if (lptr->last)
                {
                        rptr = lptr->last;
                        while((trptr = rptr->u.link))
                        {
                                rptr->u.link = lptr->address;
                                rptr = trptr;
                        }
                        rptr->u.link = lptr->address;
                }
}




static char *ycomp(char *ep, char delim)
{
        char *tp, *sp;
        int c;


        for(sp = tp = cp; *tp != delim; tp++)
        {
                if (*tp == '\\')
                        tp++;
                if ((*tp == '\n') || (*tp == '\0'))
                        return ((char *) -1);
        }
        tp++;


        while((c = *sp++ & 0x7F) != delim)
        {
                if (c == '\\' && *sp == 'n')
                {
                        sp++;
                        c = '\n';
                }
                if ((ep[c] = *tp++) == '\\' && *tp == 'n')
                {
                        ep[c] = '\n';
                        tp++;
                }
                if ((ep[c] == delim) || (ep[c] == '\0'))
                        return ((char *) -1);
        }

        if (*tp != delim)
                return ((char *) -1);

        cp = ++tp;

        for(c = 0; c < 128; c++)
                if (ep[c] == 0)
                        ep[c] = c;

        return ep + 0x80;
}
