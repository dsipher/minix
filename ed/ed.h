/*****************************************************************************

   ed.h                                                  minix line editor

******************************************************************************

    derived from source found in Minix 2, Copyright 1987 Brian Beattie.

              Permission to copy and/or distribute granted
              under the following conditions:

                 (1) No charge may be made other than
                     reasonable charges for reproduction.
                 (2) This notice must remain intact.
                 (3) No further restrictions may be added.

*****************************************************************************/

#define FATAL	(ERR - 1)

struct line {
    int         l_stat;			/* empty, mark */
    struct line *l_prev;
    struct line *l_next;
    char        l_buff[1];
};

typedef struct line LINE;

#define LINFREE     1		/* entry not in use */
#define LGLOB	    2		/* line marked global */

#define MAXLINE	    8192    /* max chars per line */
#define MAXPAT	    256		/* max chars per replacement pattern */
#define MAXFNAME    1024    /* max file name size */

extern LINE     line0;
extern int      curln, lastln, line1, line2, nlines;

extern int      nflg;		            /* print line number flag */
extern int      lflg;		            /* print line in verbose mode */
extern char     *inptr;		            /* tty input buffer */
extern char     linbuf[], *linptr;	    /* current line */
extern int      truncflg;		        /* truncate long line flag */
extern int      eightbit;		        /* save eighth bit */
extern int      nonascii;		        /* count of non-ascii chars read */
extern int      nullchar;		        /* count of null chars read */
extern int      truncated;		        /* count of lines truncated */
extern int      fchanged;		        /* file changed */

extern int      diag;

#define nextln(l)	((l)+1 > lastln ? 0 : (l)+1)
#define prevln(l)	((l)-1 < 0 ? lastln : (l)-1)

char    *amatch(char *lin, TOKEN *pat, char *boln);
char    *match(char *lin, TOKEN *pat, char *boln);
int     append(int line, int glob);
BITMAP  *makebitmap(unsigned size);
int     setbit(unsigned c, char *map, unsigned val);
int     testbit(unsigned c, char *map);
char    *catsub(char *from, char *to, char *sub, char *new, char *newend);
int     ckglob(void);
int     deflt(int def1, int def2);
int     del(int from, int to);
int     docmd(int glob);
int     dolst(int line1, int line2);
char    *dodash(int delim, char *src, char *map);
int     doglob(void);
int     doprnt(int from, int to);
void    prntln(char *str, int vflg, int lin);
void    putcntl(int c, FILE *stream);
int     doread(int lin, char *fname);
int     dowrite(int from, int to, char *fname, int apflg);
void    intr(int sig);
int     egets(char *str, int size, FILE *stream);
int     esc(char **s);
int     find(TOKEN *pat, int dir);
char    *getfn(void);
int     getlst(void);
int     getnum(int first);
int     getone(void);
TOKEN   *getpat(char *arg);
LINE    *getptr(int num);
int     getrhs(char *sub);
char    *gettxt(int num);
int     ins(char *str);
int     sys(char *c);
int     join(int first, int last);
TOKEN   *makepat(char *arg, int delim);
char    *maksub(char *sub, int subsz);
char    *matchs(char *line, TOKEN *pat, int ret_endp);
int     move(int num);
int     transfer(int num);
int     omatch(char **linp, TOKEN *pat, char *boln);
TOKEN   *optpat(void);
int     set(void);
int     show(void);
void    relink(LINE *a, LINE *x, LINE *y, LINE *b);
void    clrbuf(void);
void    set_buf(void);
int     subst(TOKEN *pat, char *sub, int gflg, int pflag);
void    unmakepat(TOKEN *head);

/* vi: set ts=4 expandtab: */
