# 1 "exec.c"

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
# 57 "exec.c"
extern char     linebuf[];
extern sedcmd   cmds[];
extern long     linenum[];


extern short    nflag;
extern int      eargc;
extern sedcmd   *pending;

extern int      last_line_used;






static const char LTLMSG[]      = "sed: line too long\n";

static char     *spend;
static long     lnum = 0L;


static sedcmd   *appends[20];
static sedcmd   **aptr = appends;


static char     genbuf[4000];
static char     *loc1;
static char     *loc2;
static char     *locs;


static int      lastline;
static int      line_with_newline;
static int      jump;
static int      delete;


static char     *bracend[9];
static char     *brastart[9];


static char *sed_getline(char *buf, int max);
static char *place(char* asp, char* al1, char* al2);
static int advance(char* lp, char* ep, char** eob);
static int match(char *expbuf, int gf);
static int selected(sedcmd *ipc);
static int substitute(sedcmd *ipc);
static void command(sedcmd *ipc);
static void dosub(char *rhsbuf);
static void dumpto(char *p1, FILE *fp);
static void listto(char *p1, FILE *fp);
static void readout(void);
static void truncated(int h);



void execute(char* file)
{
        register sedcmd         *ipc;
        char                    *execp;

        if (file != ((void *) 0))
                if (freopen(file, "r", (&__stdin)) == ((void *) 0))
                        fprintf((&__stderr), "sed: can't open %s\n", file);

        if (pending)
        {
                ipc = pending;
                pending = 0;
                goto doit;
        }


        for(;;)
        {

                if ((execp = sed_getline(linebuf, 4000+1)) == ((char *) -1))
                        return;
                spend = execp;


                for(ipc = cmds; ipc->command; )
                {


                        if (ipc->addr1 || ipc->flags.allbut) {
                                if (!ipc->addr1 || !selected(ipc)) {
                                        ipc++;
                                        continue;
                                }
                        }
        doit:
                        command(ipc);

                        if (delete)
                                break;

                        if (jump)
                        {
                                jump = 0;
                                if ((ipc = ipc->u.link) == 0)
                                {
                                        ipc = cmds;
                                        break;
                                }
                        }
                        else
                                ipc++;
                }



                if (!nflag && !delete)
                {
                        fwrite(linebuf, spend - linebuf, 1, (&__stdout));
                        if (line_with_newline)
                                (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));
                }


                if (aptr > appends)
                        readout();

                delete = 0;
        }
}


static int selected(sedcmd *ipc)
{
        register char   *p1 = ipc->addr1;
        register char   *p2 = ipc->addr2;
        unsigned char   c;
        int selected = 0;

        if (ipc->flags.inrange)
        {
                selected = 1;
                if (*p2 == 20)
                        ;
                else if (*p2 == 18)
                {
                        c = p2[1];
                        if (lnum >= linenum[c])
                                ipc->flags.inrange = 0;
                }
                else if (match(p2, 0))
                        ipc->flags.inrange = 0;
        }
        else if (*p1 == 20)
        {
                if (lastline)
                        selected = 1;
        }
        else if (*p1 == 18)
        {
                c = p1[1];
                if (lnum == linenum[c]) {
                        selected = 1;
                        if (p2)
                                ipc->flags.inrange = 1;
                }
        }
        else if (match(p1, 0))
        {
                selected = 1;
                if (p2)
                        ipc->flags.inrange = 1;
        }
        return ipc->flags.allbut ? !selected : selected;
}


static int _match(char *expbuf, int gf)
{
        char *p1, *p2, c;

        if (!gf)
        {
                p1 = linebuf;
                locs = ((void *) 0);
        }
        else
        {
                if (*expbuf)
                        return 0;

                if (loc2 - loc1 == 0) {
                        loc2++;
                }
                locs = p1 = loc2;
        }

        p2 = expbuf;
        if (*p2++)
        {
                loc1 = p1;
                if (*p2 == 2 && p2[1] != *p1)
                        return 0;
                return advance(p1, p2, ((void *) 0));
        }


        if (*p2 == 2)
        {
                c = p2[1];
                do {
                        if (*p1 != c)
                                continue;
                        if (advance(p1, p2, ((void *) 0)))
                                return loc1 = p1, 1;
                } while (*p1++);
                return 0;
        }


        do {
                if (advance(p1, p2, ((void *) 0)))
                        return loc1 = p1, 1;
        } while (*p1++);


        return 0;
}

static int match(char *expbuf, int gf)
{
        const char *loc2i = loc2;
        const int ret = _match(expbuf, gf);


        if (loc2i && loc1 == loc2i && loc2 - loc1 == 0) {
                loc2++;
                return _match(expbuf, gf);
        }
        return ret;
}




static int advance(char* lp, char* ep, char** eob)
{
        char    *curlp;
        char    c;
        char    *bbeg;
        int     ct;
        signed int      bcount = -1;

        for (;;)
                switch (*ep++)
                {
                case 2:
                        if (*ep++ == *lp++)
                                continue;
                        return 0;

                case 4:
                        if (*lp++)
                                continue;
                        return 0;

                case 8:
                case 10:
                        if (*lp == 0)
                                continue;
                        return 0;

                case 22:
                        loc2 = lp;
                        return 1;

                case 6:
                        c = *lp++;
                        if (ep[((unsigned char)c)>>3] & (1 << (c & 07)))
                        {
                                ep += 32;
                                continue;
                        }
                        return 0;

                case 12:
                        brastart[(unsigned char)*ep++] = lp;
                        continue;

                case 14:
                        bcount = *ep;
                        if (eob) {
                                *eob = lp;
                                return 1;
                        }
                        else
                                bracend[(unsigned char)*ep++] = lp;
                        continue;

                case 16:
                        bbeg = brastart[(unsigned char)*ep];
                        ct = bracend[(unsigned char)*ep++] - bbeg;

                        if (memcmp(bbeg, lp, ct) == 0)
                        {
                                lp += ct;
                                continue;
                        }
                        return 0;

                case 12|1:
                {
                        char *lastlp;
                        curlp = lp;

                        if (*ep > bcount)
                                brastart[(unsigned char)*ep] = bracend[(unsigned char)*ep] = lp;

                        while (advance(lastlp=lp, ep+1, &lp)) {
                                if (*ep > bcount && lp != lastlp) {
                                        bracend[(unsigned char)*ep] = lp;
                                        brastart[(unsigned char)*ep] = lastlp;
                                }
                                if (lp == lastlp) break;
                        }
                        ep++;


                        while (*ep != 14)
                                ep++;
                        ep+=2;

                        if (lp == curlp)
                                continue;
                        lp++;
                        goto star;
                }
                case 16|1:
                        bbeg = brastart[(unsigned char)*ep];
                        ct = bracend[(unsigned char)*ep++] - bbeg;
                        curlp = lp;
                        while(memcmp(bbeg, lp, ct) == 0)
                                lp += ct;

                        while(lp >= curlp)
                        {
                                if (advance(lp, ep, eob))
                                        return 1;
                                lp -= ct;
                        }
                        return 0;

                case 4|1:
                        curlp = lp;
                        while (*lp++);
                        goto star;

                case 2|1:
                        curlp = lp;
                        while (*lp++ == *ep);
                        ep++;
                        goto star;

                case 6|1:
                        curlp = lp;
                        do {
                                c = *lp++;
                        } while (ep[((unsigned char)c)>>3] & (1 << (c & 07)));
                        ep += 32;
                        goto star;

                star:
                        if (--lp == curlp) {
                                continue;
                        }
# 455 "exec.c"
                        do {
                                if (lp == locs)
                                        break;
                                if (advance(lp, ep, eob))
                                        return 1;
                        } while (lp-- > curlp);
                        return 0;

                default:
                        fprintf((&__stderr), "sed: internal RE error, %o\n", *--ep);
                        exit (2);
                }
}



static int substitute(sedcmd *ipc)
{
        unsigned int n = 0;

        while (match(ipc->u.lhs, n                            )) {

                n++;
                if (!ipc->nth || n == ipc->nth) {
                        dosub(ipc->rhs);
                        break;
                }
        }
        if (n == 0)
                return 0;

        if (ipc->flags.global)
                do {
                        if (match(ipc->u.lhs, 1)) {
                                dosub(ipc->rhs);
                        }
                        else
                                break;
                } while (*loc2);
        return 1;
}



static void dosub(char *rhsbuf)
{
        char    *lp, *sp, *rp;
        int     c;


        lp = linebuf; sp = genbuf;
        while (lp < loc1) *sp++ = *lp++;


        for (rp = rhsbuf; (c = *rp++); )
        {
                if (c & 0200 && (c & 0177) == '0')
                {
                        sp = place(sp, loc1, loc2);
                        continue;
                }
                else if (c & 0200 && (c &= 0177) >= '1' && c < 9+'1')
                {
                        sp = place(sp, brastart[c-'1'], bracend[c-'1']);
                        continue;
                }
                *sp++ = c & 0177;
                if (sp >= genbuf + 4000)
                        fprintf((&__stderr), LTLMSG);

        }


        lp = loc2;
        {
                long len = loc2 - loc1;
                loc2 = sp - genbuf + linebuf;
                loc1 = loc2 - len;
        }
        while ((*sp++ = *lp++))
                if (sp >= genbuf + 4000)
                        fprintf((&__stderr), LTLMSG);
        lp = linebuf; sp = genbuf;
        while ((*lp++ = *sp++));
        spend = lp-1;
}


static char *place(char* asp, char* al1, char* al2)
{
        while (al1 < al2)
        {
                *asp++ = *al1++;
                if (asp >= genbuf + 4000)
                        fprintf((&__stderr), LTLMSG);
        }
        return asp;
}




static void listto(char *p1, FILE *fp)
{
        for (; p1<spend; p1++)
                if (((unsigned) ((*p1)-' ') < 95))
                        (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = (*p1)) : __flushbuf((*p1),(fp)));
                else
                {
                        (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('\\')) : __flushbuf(('\\'),(fp)));
                        switch(*p1)
                        {
                        case '\b':      (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('b')) : __flushbuf(('b'),(fp))); break;
                        case '\t':      (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('t')) : __flushbuf(('t'),(fp))); break;
                        case '\n':      (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('n')) : __flushbuf(('n'),(fp))); break;
                        case '\r':      (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('r')) : __flushbuf(('r'),(fp))); break;
                        case '\033':    (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('e')) : __flushbuf(('e'),(fp))); break;
                        default:        fprintf(fp, "%02x", *p1);
                        }
                }
        (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('\n')) : __flushbuf(('\n'),(fp)));
}




static void dumpto(char *p1, FILE *fp)
{
        for (; p1<spend; p1++)
                fprintf(fp, "%02x", *p1);
        fprintf(fp, "%02x", '\n');
        (--(fp)->_count >= 0 ? (int) (*(fp)->_ptr++ = ('\n')) : __flushbuf(('\n'),(fp)));
}

static void truncated(int h)
{
        static long last = 0L;

        if (lnum == last) return;
        last = lnum;

        fprintf((&__stderr), "sed: ");
        fprintf((&__stderr), h ? "hold space" : "line %ld", lnum);
        fprintf((&__stderr), " truncated to %d characters\n", 4000);
}


static void command(sedcmd *ipc)
{
        static int      didsub;
        static char     holdsp[4000];
        static char     *hspend = holdsp;
        register char   *p1, *p2;
        char            *execp;

        switch(ipc->command)
        {
        case 0x02:
                *aptr++ = ipc;
                if (aptr >= appends + 20)
                        fprintf((&__stderr),
                                "sed: too many appends after line %ld\n",
                                lnum);
                *aptr = 0;
                break;

        case 0x04:
                delete = 1;
                if (!ipc->flags.inrange || lastline)
                        printf("%s\n", ipc->u.lhs);
                break;

        case 0x05:
                delete = 1;
                break;

        case 0x06:
                p1 = p2 = linebuf;
                while(*p1 != '\n')
                        if ((delete = (*p1++ == 0)))
                                return;
                p1++;
                while((*p2++ = *p1++)) continue;
                spend = p2-1;
                jump++;
                break;

        case 0x01:
                fprintf((&__stdout), "%ld\n", lnum);
                break;

        case 0x07:
                p1 = linebuf;   p2 = holdsp;    while((*p1++ = *p2++));
                spend = p1-1;
                break;

        case 0x08:
                *spend++ = '\n';
                p1 = spend;     p2 = holdsp;
                do {
                        if (p1 > linebuf + 4000) {
                                truncated(0);
                                p1[-1] = 0;
                                break;
                        }
                } while((*p1++ = *p2++));

                spend = p1-1;
                break;

        case 0x09:
                p1 = holdsp;    p2 = linebuf;   while((*p1++ = *p2++));
                hspend = p1-1;
                break;

        case 0x0A:
                *hspend++ = '\n';
                p1 = hspend;    p2 = linebuf;
                do {
                        if (p1 > holdsp + 4000) {
                                truncated(1);
                                p1[-1] = 0;
                                break;
                        }
                } while((*p1++ = *p2++));

                hspend = p1-1;
                break;

        case 0x0B:
                printf("%s\n", ipc->u.lhs);
                break;

        case 0x03:
                jump = 1;
                break;

        case 0x0C:
                listto(linebuf, (ipc->fout != ((void *) 0))?ipc->fout:(&__stdout)); break;

        case 0x20:
                dumpto(linebuf, (ipc->fout != ((void *) 0))?ipc->fout:(&__stdout)); break;

        case 0x0D:
                if (!nflag)
                        puts(linebuf);
                if (aptr > appends)
                        readout();
                if ((execp = sed_getline(linebuf, 4000+1)) == ((char *) -1))
                {
                        pending = ipc;
                        delete = 1;
                        break;
                }
                spend = execp;
                break;

        case 0x0E:
                if (aptr > appends)
                        readout();
                *spend++ = '\n';
                if ((execp = sed_getline(spend,
                                         linebuf + 4000+1 - spend)) == ((char *) -1))
                {
                        pending = ipc;
                        delete = 1;
                        break;
                }
                spend = execp;
                break;

        case 0x0F:
                puts(linebuf);
                break;

        case 0x10:
                cpcom:
                for(p1 = linebuf; *p1 != '\n' && *p1 != '\0'; )
                        (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = (*p1++)) : __flushbuf((*p1++),((&__stdout))));
                (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stdout))));
                break;

        case 0x11:
                if (!nflag)
                        puts(linebuf);
                if (aptr > appends)
                        readout();
                exit(0);

        case 0x12:
                *aptr++ = ipc;
                if (aptr >= appends + 20)
                        fprintf((&__stderr),
                                "sed: too many reads after line %ld\n",
                                lnum);
                *aptr = 0;
                break;

        case 0x13:
                didsub = substitute(ipc);
                if (ipc->flags.print && didsub)
                {
                        if (ipc->flags.print == 1)
                                puts(linebuf);
                        else
                                goto cpcom;
                }
                if (didsub && ipc->fout)
                        fprintf(ipc->fout, "%s\n", linebuf);
                break;

        case 0x14:
        case 0x15:
                if (didsub == (ipc->command == 0x15))
                        break;
                didsub = 0;
                jump = 1;
                break;

        case 0x17:
                for(p1 = linebuf; *p1 != '\n' && *p1 != '\0'; )
                        (--(ipc->fout)->_count >= 0 ? (int) (*(ipc->fout)->_ptr++ = (*p1++)) : __flushbuf((*p1++),(ipc->fout)));
                (--(ipc->fout)->_count >= 0 ? (int) (*(ipc->fout)->_ptr++ = ('\n')) : __flushbuf(('\n'),(ipc->fout)));
                break;

        case 0x16:
                fprintf(ipc->fout, "%s\n", linebuf);
                break;

        case 0x18:
                p1 = linebuf;   p2 = genbuf;    while((*p2++ = *p1++)) continue;
                p1 = holdsp;    p2 = linebuf;   while((*p2++ = *p1++)) continue;
                spend = p2 - 1;
                p1 = genbuf;    p2 = holdsp;    while((*p2++ = *p1++)) continue;
                hspend = p2 - 1;
                break;

        case 0x19:
                p1 = linebuf;   p2 = ipc->u.lhs;
                while((*p1 = p2[(unsigned char)*p1]))
                        p1++;
                break;
        }
}




static char *sed_getline(char *buf, int max)
{
        if (fgets(buf, max, (&__stdin)) != ((void *) 0))
        {
                int c;

                lnum++;

                while (*buf != '\n' && *buf != 0)
                    buf++;
                line_with_newline = *buf == '\n';
                *buf=0;


                if  (last_line_used) {
                  if ((c = fgetc((&__stdin))) != (-1))
                        ungetc (c, (&__stdin));
                  else {
                        if (eargc == 0)
                                lastline = 1;
                  }
                }

                return buf;
        }
        else
        {
                return ((char *) -1);
        }
}


static void readout(void)
{
        register int    t;
        FILE            *fi;

        aptr = appends - 1;
        while(*++aptr)
                if ((*aptr)->command == 0x02)
                        printf("%s\n", (*aptr)->u.lhs);
                else
                {
                        if ((fi = fopen((*aptr)->u.lhs, "r")) == ((void *) 0))
                                continue;
                        while((t = (--(fi)->_count >= 0 ? (int) (*(fi)->_ptr++) : __fillbuf(fi))) != (-1))
                                (--((&__stdout))->_count >= 0 ? (int) (*((&__stdout))->_ptr++ = ((char) t)) : __flushbuf(((char) t),((&__stdout))));
                        fclose(fi);
                }
        aptr = appends;
        *aptr = 0;
}
