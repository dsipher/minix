# 1 "run.c"

# 39 "/home/charles/xcc/ux64/include/sys/defs.h"
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
# 48 "/home/charles/xcc/ux64/include/stdio.h"
typedef __off_t fpos_t;



typedef __size_t size_t;








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
# 44 "/home/charles/xcc/ux64/include/ctype.h"
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
# 40 "/home/charles/xcc/ux64/include/setjmp.h"
typedef long jmp_buf[16];






extern int __setjmp(jmp_buf);
extern void longjmp(jmp_buf, int);
# 42 "/home/charles/xcc/ux64/include/math.h"
extern double __huge_val;

extern double __double_2_n969;
extern double __double_2_514;
extern double __double_2_1023;



extern char *__dtefg(char *, double *, int, int, int, int *);



extern double __pow10(int exp);








extern double __poly(double x, const double c[], int n);



extern double __two(double x);


















union __ieee_double
{
    double          f;
    unsigned long   i;

    struct
    {
        int lsw;
        int msw;
    } words;

    struct
    {
        unsigned manl   : 32;
        unsigned manh   : 20;
        unsigned exp    : 11;
        unsigned sign   : 1;
    } bits;
};

extern double modf(double, double *);
extern double frexp(double, int *);



extern double exp(double x);



extern double ldexp(double x, int exp);



extern double log(double x);



extern double log10(double x);



extern double pow(double x, double y);



extern double sqrt(double x);



extern double cos(double x);
extern double sin(double x);



extern double atan(double x);
extern double atan2(double y, double x);
# 44 "/home/charles/xcc/ux64/include/string.h"
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
# 53 "/home/charles/xcc/ux64/include/stdlib.h"
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
# 41 "/home/charles/xcc/ux64/include/time.h"
typedef __time_t time_t;







struct tm
{
    int tm_sec;
    int tm_min;
    int tm_hour;
    int tm_mday;
    int tm_mon;
    int tm_year;
    int tm_wday;
    int tm_yday;
    int tm_isdst;
};

struct timespec
{
    time_t  tv_sec;
    long    tv_nsec;
};








extern char *asctime(const struct tm *timeptr);








extern char *ctime(const time_t *timer);




extern struct tm *localtime(const time_t *timer);




extern struct tm *gmtime(const time_t *timer);




extern size_t strftime(char *s, size_t maxsize, const char *format,
                       const struct tm *timeptr);




extern time_t time(time_t *timer);



extern char *tzname[];
extern long timezone;







extern void tzset(void);




int nanosleep(const struct timespec *rqtp, struct timespec *rtmp);
# 44 "/home/charles/xcc/ux64/include/assert.h"
extern void __assert(const char *e, const char *file, int line);
# 33 "awk.h"
typedef double	Awkfloat;



typedef	unsigned char uschar;













extern int	compile_time;
extern int	safe;


extern int	recsize;

extern char	**FS;
extern char	**RS;
extern char	**ORS;
extern char	**OFS;
extern char	**OFMT;
extern Awkfloat *NR;
extern Awkfloat *FNR;
extern Awkfloat *NF;
extern char	**FILENAME;
extern char	**SUBSEP;
extern Awkfloat *RSTART;
extern Awkfloat *RLENGTH;

extern char	*record;
extern int	lineno;
extern int	errorflag;
extern int	donefld;
extern int	donerec;
extern char	inputFS[];

extern int	dbg;

extern	char	*patbeg;
extern	int	patlen;



typedef struct Cell {
	uschar	ctype;
	uschar	csub;
	char	*nval;
	char	*sval;
	Awkfloat fval;
	int	 tval;
	struct Cell *cnext;
} Cell;

typedef struct Array {
	int	nelem;
	int	size;
	Cell	**tab;
} Array;


extern Array	*symtab;

extern Cell	*nrloc;
extern Cell	*fnrloc;
extern Cell	*nfloc;
extern Cell	*rstartloc;
extern Cell	*rlengthloc;
# 138 "awk.h"
typedef struct Node {
	int	ntype;
	struct	Node *nnext;
	int	lineno;
	int	nobj;
	struct	Node *narg[1];
} Node;



extern Node	*winner;
extern Node	*nullstat;
extern Node	*nullnode;
# 185 "awk.h"
extern	int	pairstack[], paircnt;
# 214 "awk.h"
typedef struct rrow {
	long	ltype;
	union {
		int i;
		Node *np;
		uschar *up;
	} lval;
	int	*lfollow;
} rrow;

typedef struct fa {
	uschar	gototab[32][(256+3)];
	uschar	out[32];
	uschar	*restr;
	int	*posns[32];
	int	anchor;
	int	use;
	int	initstat;
	int	curstat;
	int	accept;
	int	reset;
	struct	rrow re[1];
} fa;
# 31 "proto.h"
extern	int	yywrap(void);
extern	void	setfname(Cell *);
extern	int	constnode(Node *);
extern	char	*strnode(Node *);
extern	Node	*notnull(Node *);
extern	int	yyparse(void);

extern	int	yylex(void);
extern	void	startreg(void);
extern	int	input(void);
extern	void	unput(int);
extern	void	unputstr(const char *);
extern	int	yylook(void);
extern	int	yyback(int *, int);
extern	int	yyinput(void);

extern	fa	*makedfa(const char *, int);
extern	fa	*mkdfa(const char *, int);
extern	int	makeinit(fa *, int);
extern	void	penter(Node *);
extern	void	freetr(Node *);
extern	int	hexstr(uschar **);
extern	int	quoted(uschar **);
extern	char	*cclenter(const char *);
extern	void	overflo(const char *);
extern	void	cfoll(fa *, Node *);
extern	int	first(Node *);
extern	void	follow(Node *);
extern	int	member(int, const char *);
extern	int	match(fa *, const char *);
extern	int	pmatch(fa *, const char *);
extern	int	nematch(fa *, const char *);
extern	Node	*reparse(const char *);
extern	Node	*regexp(void);
extern	Node	*primary(void);
extern	Node	*concat(Node *);
extern	Node	*alt(Node *);
extern	Node	*unary(Node *);
extern	int	relex(void);
extern	int	cgoto(fa *, int, int);
extern	void	freefa(fa *);

extern	int	pgetc(void);
extern	char	*cursource(void);

extern	Node	*nodealloc(int);
extern	Node	*exptostat(Node *);
extern	Node	*node1(int, Node *);
extern	Node	*node2(int, Node *, Node *);
extern	Node	*node3(int, Node *, Node *, Node *);
extern	Node	*node4(int, Node *, Node *, Node *, Node *);
extern	Node	*stat3(int, Node *, Node *, Node *);
extern	Node	*op2(int, Node *, Node *);
extern	Node	*op1(int, Node *);
extern	Node	*stat1(int, Node *);
extern	Node	*op3(int, Node *, Node *, Node *);
extern	Node	*op4(int, Node *, Node *, Node *, Node *);
extern	Node	*stat2(int, Node *, Node *);
extern	Node	*stat4(int, Node *, Node *, Node *, Node *);
extern	Node	*celltonode(Cell *, int);
extern	Node	*rectonode(void);
extern	Node	*makearr(Node *);
extern	Node	*pa2stat(Node *, Node *, Node *);
extern	Node	*linkum(Node *, Node *);
extern	void	defn(Cell *, Node *, Node *);
extern	int	isarg(const char *);
extern	char	*tokname(int);
extern	Cell	*(*proctab[])(Node **, int);
extern	int	ptoi(void *);
extern	Node	*itonp(int);

extern	void	syminit(void);
extern	void	arginit(int, char **);
extern	void	envinit(char **);
extern	Array	*makesymtab(int);
extern	void	freesymtab(Cell *);
extern	void	freeelem(Cell *, const char *);
extern	Cell	*setsymtab(const char *, const char *, double, unsigned int, Array *);
extern	int	hash(const char *, int);
extern	void	rehash(Array *);
extern	Cell	*lookup(const char *, Array *);
extern	double	setfval(Cell *, double);
extern	void	funnyvar(Cell *, const char *);
extern	char	*setsval(Cell *, const char *);
extern	double	getfval(Cell *);
extern	char	*getsval(Cell *);
extern	char	*getpssval(Cell *);
extern	char	*tostring(const char *);
extern	char	*qstring(const char *, int);

extern	void	recinit(unsigned int);
extern	void	initgetrec(void);
extern	void	makefields(int, int);
extern	void	growfldtab(int n);
extern	int	getrec(char **, int *, int);
extern	void	nextfile(void);
extern	int	readrec(char **buf, int *bufsize, FILE *inf);
extern	char	*getargv(int);
extern	void	setclvar(char *);
extern	void	fldbld(void);
extern	void	cleanfld(int, int);
extern	void	newfld(int);
extern	int	refldbld(const char *, const char *);
extern	void	recbld(void);
extern	Cell	*fieldadr(int);
extern	void	yyerror(const char *);
extern	void	fpecatch(int);
extern	void	bracecheck(void);
extern	void	bcheck2(int, int, int);
extern	void	SYNTAX(const char *, ...);
extern	void	FATAL(const char *, ...);
extern	void	WARNING(const char *, ...);
extern	void	error(void);
extern	void	eprint(void);
extern	void	bclass(int);
extern	double	errcheck(double, const char *);
extern	int	isclvar(const char *);
extern	int	is_number(const char *);

extern	int	adjbuf(char **pb, int *sz, int min, int q, char **pbp, const char *what);
extern	void	run(Node *);
extern	Cell	*execute(Node *);
extern	Cell	*program(Node **, int);
extern	Cell	*call(Node **, int);
extern	Cell	*copycell(Cell *);
extern	Cell	*arg(Node **, int);
extern	Cell	*jump(Node **, int);
extern	Cell	*awkgetline(Node **, int);
extern	Cell	*getnf(Node **, int);
extern	Cell	*array(Node **, int);
extern	Cell	*awkdelete(Node **, int);
extern	Cell	*intest(Node **, int);
extern	Cell	*matchop(Node **, int);
extern	Cell	*boolop(Node **, int);
extern	Cell	*relop(Node **, int);
extern	void	tfree(Cell *);
extern	Cell	*gettemp(void);
extern	Cell	*field(Node **, int);
extern	Cell	*indirect(Node **, int);
extern	Cell	*substr(Node **, int);
extern	Cell	*sindex(Node **, int);
extern	int	format(char **, int *, const char *, Node *);
extern	Cell	*awksprintf(Node **, int);
extern	Cell	*awkprintf(Node **, int);
extern	Cell	*arith(Node **, int);
extern	double	ipow(double, int);
extern	Cell	*incrdecr(Node **, int);
extern	Cell	*assign(Node **, int);
extern	Cell	*cat(Node **, int);
extern	Cell	*pastat(Node **, int);
extern	Cell	*dopa2(Node **, int);
extern	Cell	*split(Node **, int);
extern	Cell	*condexpr(Node **, int);
extern	Cell	*ifstat(Node **, int);
extern	Cell	*whilestat(Node **, int);
extern	Cell	*dostat(Node **, int);
extern	Cell	*forstat(Node **, int);
extern	Cell	*instat(Node **, int);
extern	Cell	*bltin(Node **, int);
extern	Cell	*printstat(Node **, int);
extern	Cell	*nullproc(Node **, int);
extern	FILE	*redirect(int, Node *);
extern	FILE	*openfile(int, const char *);
extern	const char	*filename(FILE *);
extern	Cell	*closefile(Node **, int);
extern	void	closeall(void);
extern	Cell	*sub(Node **, int);
extern	Cell	*gsub(Node **, int);

extern	FILE	*popen(const char *, const char *);
extern	int	pclose(FILE *);
# 94 "y.tab.h"
typedef union {
	Node	*p;
	Cell	*cp;
	int	i;
	char	*s;
} YYSTYPE;
extern YYSTYPE yylval;
# 73 "run.c"
jmp_buf env;
extern	int	pairstack[];
extern	Awkfloat	srand_seed;

Node	*winner = ((void *) 0);
Cell	*tmps;

static Cell	truecell	={ 2, 11, 0, 0, 1.0, 01 };
Cell	*True	= &truecell;
static Cell	falsecell	={ 2, 12, 0, 0, 0.0, 01 };
Cell	*False	= &falsecell;
static Cell	breakcell	={ 3, 23, 0, 0, 0.0, 01 };
Cell	*jbreak	= &breakcell;
static Cell	contcell	={ 3, 24, 0, 0, 0.0, 01 };
Cell	*jcont	= &contcell;
static Cell	nextcell	={ 3, 22, 0, 0, 0.0, 01 };
Cell	*jnext	= &nextcell;
static Cell	nextfilecell	={ 3, 26, 0, 0, 0.0, 01 };
Cell	*jnextfile	= &nextfilecell;
static Cell	exitcell	={ 3, 21, 0, 0, 0.0, 01 };
Cell	*jexit	= &exitcell;
static Cell	retcell		={ 3, 25, 0, 0, 0.0, 01 };
Cell	*jret	= &retcell;
static Cell	tempcell	={ 1, 4, 0, "", 0.0, 01|02|04 };

Node	*curnode = ((void *) 0);


int adjbuf(char **pbuf, int *psiz, int minlen, int quantum, char **pbptr,
	const char *whatrtn)









{
	if (minlen > *psiz) {
		char *tbuf;
		int rminlen = quantum ? minlen % quantum : 0;
		int boff = pbptr ? *pbptr - *pbuf : 0;

		if (rminlen)
			minlen += quantum - rminlen;
		tbuf = (char *) realloc(*pbuf, minlen);
		if (dbg) printf ("adjbuf %s: %d %d (pbuf=%p, tbuf=%p)\n", whatrtn, *psiz, minlen, *pbuf, tbuf);
		if (tbuf == ((void *) 0)) {
			if (whatrtn)
				FATAL("out of memory in %s", whatrtn);
			return 0;
		}
		*pbuf = tbuf;
		*psiz = minlen;
		if (pbptr)
			*pbptr = tbuf + boff;
	}
	return 1;
}

void run(Node *a)
{
	extern void stdinit(void);

	stdinit();
	execute(a);
	closeall();
}

Cell *execute(Node *u)
{
	Cell *(*proc)(Node **, int);
	Cell *x;
	Node *a;

	if (u == ((void *) 0))
		return(True);
	for (a = u; ; a = a->nnext) {
		curnode = a;
		if (((a)->ntype == 1)) {
			x = (Cell *) (a->narg[0]);
			if (((x)->tval & 0100) && !donefld)
				fldbld();
			else if (((x)->tval & 0200) && !donerec)
				recbld();
			return(x);
		}
		if ((a->nobj <= 257 || a->nobj >= 349 || proctab[a->nobj-257] == nullproc))
			FATAL("illegal statement");
		proc = proctab[a->nobj-257];
		x = (*proc)(a->narg, a->nobj);
		if (((x)->tval & 0100) && !donefld)
			fldbld();
		else if (((x)->tval & 0200) && !donerec)
			recbld();
		if (((a)->ntype == 3))
			return(x);
		if (((x)->ctype == 3))
			return(x);
		if (a->nnext == ((void *) 0))
			return(x);
		if (((x)->csub == 4)) tfree(x); else;
	}
}


Cell *program(Node **a, int n)
{
	Cell *x;

	if (__setjmp(env) != 0)
		goto ex;
	if (a[0]) {
		x = execute(a[0]);
		if (((x)->csub == 21))
			return(True);
		if (((x)->ctype == 3))
			FATAL("illegal break, continue, next or nextfile from BEGIN");
		if (((x)->csub == 4)) tfree(x); else;
	}
	if (a[1] || a[2])
		while (getrec(&record, &recsize, 1) > 0) {
			x = execute(a[1]);
			if (((x)->csub == 21))
				break;
			if (((x)->csub == 4)) tfree(x); else;
		}
  ex:
	if (__setjmp(env) != 0)
		goto ex1;
	if (a[2]) {
		x = execute(a[2]);
		if (((x)->csub == 23) || ((x)->csub == 22 || (x)->csub == 26) || ((x)->csub == 24))
			FATAL("illegal break, continue, next or nextfile from END");
		if (((x)->csub == 4)) tfree(x); else;
	}
  ex1:
	return(True);
}

struct Frame {
	int nargs;
	Cell *fcncell;
	Cell **args;
	Cell *retval;
};



struct Frame *frame = ((void *) 0);
int	nframe = 0;
struct Frame *fp = ((void *) 0);

Cell *call(Node **a, int n)
{
	static Cell newcopycell = { 1, 6, 0, "", 0.0, 01|02|04 };
	int i, ncall, ndef;
	int freed = 0;
	Node *x;
	Cell *args[50], *oargs[50];
	Cell *y, *z, *fcn;
	char *s;

	fcn = execute(a[0]);
	s = fcn->nval;
	if (!((fcn)->tval & 040))
		FATAL("calling undefined function %s", s);
	if (frame == ((void *) 0)) {
		fp = frame = (struct Frame *) calloc(nframe += 100, sizeof(struct Frame));
		if (frame == ((void *) 0))
			FATAL("out of space for stack frames calling %s", s);
	}
	for (ncall = 0, x = a[1]; x != ((void *) 0); x = x->nnext)
		ncall++;
	ndef = (int) fcn->fval;
	   if (dbg) printf ("calling %s, %d args (%d in defn), fp=%d\n", s, ncall, ndef, (int) (fp-frame));
	if (ncall > ndef)
		WARNING("function %s called with %d args, uses only %d",
			s, ncall, ndef);
	if (ncall + ndef > 50)
		FATAL("function %s has %d arguments, limit %d", s, ncall+ndef, 50);
	for (i = 0, x = a[1]; x != ((void *) 0); i++, x = x->nnext) {
		   if (dbg) printf ("evaluate args[%d], fp=%d:\n", i, (int) (fp-frame));
		y = execute(x);
		oargs[i] = y;
		   
if (dbg) printf ("args[%d]: %s %f <%s>, t=%o\n", i, ((y->nval) ? (y->nval) : "(null)"), y->fval, ((y)->tval & 020) ? "(array)" : ((y->sval) ? (y->sval) : "(null)"), y->tval);
		if (((y)->tval & 040))
			FATAL("can't use function %s as argument in %s", y->nval, s);
		if (((y)->tval & 020))
			args[i] = y;
		else
			args[i] = copycell(y);
		if (((y)->csub == 4)) tfree(y); else;
	}
	for ( ; i < ndef; i++) {
		args[i] = gettemp();
		*args[i] = newcopycell;
	}
	fp++;
	if (fp >= frame + nframe) {
		int dfp = fp - frame;
		frame = (struct Frame *)
			realloc((char *) frame, (nframe += 100) * sizeof(struct Frame));
		if (frame == ((void *) 0))
			FATAL("out of space for stack frames in %s", s);
		fp = frame + dfp;
	}
	fp->fcncell = fcn;
	fp->args = args;
	fp->nargs = ndef;
	fp->retval = gettemp();

	   if (dbg) printf ("start exec of %s, fp=%d\n", s, (int) (fp-frame));
	y = execute((Node *)(fcn->sval));
	   if (dbg) printf ("finished exec of %s, fp=%d\n", s, (int) (fp-frame));

	for (i = 0; i < ndef; i++) {
		Cell *t = fp->args[i];
		if (((t)->tval & 020)) {
			if (t->csub == 6) {
				if (i >= ncall) {
					freesymtab(t);
					t->csub = 4;
					if (((t)->csub == 4)) tfree(t); else;
				} else {
					oargs[i]->tval = t->tval;
					oargs[i]->tval &= ~(02|01|04);
					oargs[i]->sval = t->sval;
					if (((t)->csub == 4)) tfree(t); else;
				}
			}
		} else if (t != y) {
			t->csub = 4;
			if (((t)->csub == 4)) tfree(t); else;
		} else if (t == y && t->csub == 6) {
			t->csub = 4;
			if (((t)->csub == 4)) tfree(t); else;
			freed = 1;
		}
	}
	if (((fcn)->csub == 4)) tfree(fcn); else;
	if (((y)->csub == 21) || ((y)->csub == 22 || (y)->csub == 26))
		return y;
	if (freed == 0) {
		if (((y)->csub == 4)) tfree(y); else;
	}
	z = fp->retval;
	   if (dbg) printf ("%s returns %g |%s| %o\n", s, getfval(z), getsval(z), z->tval);
	fp--;
	return(z);
}

Cell *copycell(Cell *x)
{
	Cell *y;

	y = gettemp();
	y->csub = 6;
	y->nval = x->nval;
	if (((x)->tval & 02))
		y->sval = tostring(x->sval);
	y->fval = x->fval;
	y->tval = x->tval & ~(010|0100|0200|04);

	return y;
}

Cell *arg(Node **a, int n)
{

	n = ptoi(a[0]);
	   if (dbg) printf ("arg(%d), fp->nargs=%d\n", n, fp->nargs);
	if (n+1 > fp->nargs)
		FATAL("argument #%d of function %s was not supplied",
			n+1, fp->fcncell->nval);
	return fp->args[n];
}

Cell *jump(Node **a, int n)
{
	Cell *y;

	switch (n) {
	case 296:
		if (a[0] != ((void *) 0)) {
			y = execute(a[0]);
			errorflag = (int) getfval(y);
			if (((y)->csub == 4)) tfree(y); else;
		}
		longjmp(env, 1);
	case 338:
		if (a[0] != ((void *) 0)) {
			y = execute(a[0]);
			if ((y->tval & (02|01)) == (02|01)) {
				setsval(fp->retval, getsval(y));
				fp->retval->fval = getfval(y);
				fp->retval->tval |= 01;
			}
			else if (y->tval & 02)
				setsval(fp->retval, getsval(y));
			else if (y->tval & 01)
				setfval(fp->retval, getfval(y));
			else
				FATAL("bad type variable %d", y->tval);
			if (((y)->csub == 4)) tfree(y); else;
		}
		return(jret);
	case 305:
		return(jnext);
	case 306:
		nextfile();
		return(jnextfile);
	case 291:
		return(jbreak);
	case 293:
		return(jcont);
	default:
		FATAL("illegal jump type %d", n);
	}
	return 0;
}

Cell *awkgetline(Node **a, int n)
{
	Cell *r, *x;
	extern Cell **fldtab;
	FILE *fp;
	char *buf;
	int bufsize = recsize;
	int mode;

	if ((buf = (char *) malloc(bufsize)) == ((void *) 0))
		FATAL("out of memory in getline");

	fflush((&__stdout));
	r = gettemp();
	if (a[1] != ((void *) 0)) {
		x = execute(a[2]);
		mode = ptoi(a[1]);
		if (mode == '|')
			mode = 285;
		fp = openfile(mode, getsval(x));
		if (((x)->csub == 4)) tfree(x); else;
		if (fp == ((void *) 0))
			n = -1;
		else
			n = readrec(&buf, &bufsize, fp);
		if (n <= 0) {
			;
		} else if (a[0] != ((void *) 0)) {
			x = execute(a[0]);
			setsval(x, buf);
			if (((x)->csub == 4)) tfree(x); else;
		} else {
			setsval(fldtab[0], buf);
			if (is_number(fldtab[0]->sval)) {
				fldtab[0]->fval = atof(fldtab[0]->sval);
				fldtab[0]->tval |= 01;
			}
		}
	} else {
		if (a[0] == ((void *) 0))
			n = getrec(&record, &recsize, 1);
		else {
			n = getrec(&buf, &bufsize, 0);
			x = execute(a[0]);
			setsval(x, buf);
			if (((x)->csub == 4)) tfree(x); else;
		}
	}
	setfval(r, (Awkfloat) n);
	free(buf);
	return r;
}

Cell *getnf(Node **a, int n)
{
	if (donefld == 0)
		fldbld();
	return (Cell *) a[0];
}

Cell *array(Node **a, int n)
{
	Cell *x, *y, *z;
	char *s;
	Node *np;
	char *buf;
	int bufsz = recsize;
	int nsub = strlen(*SUBSEP);

	if ((buf = (char *) malloc(bufsz)) == ((void *) 0))
		FATAL("out of memory in array");

	x = execute(a[0]);
	buf[0] = 0;
	for (np = a[1]; np; np = np->nnext) {
		y = execute(np);
		s = getsval(y);
		if (!adjbuf(&buf, &bufsz, strlen(buf)+strlen(s)+nsub+1, recsize, 0, "array"))
			FATAL("out of memory for %s[%s...]", x->nval, buf);
		strcat(buf, s);
		if (np->nnext)
			strcat(buf, *SUBSEP);
		if (((y)->csub == 4)) tfree(y); else;
	}
	if (!((x)->tval & 020)) {
		   if (dbg) printf ("making %s into an array\n", ((x->nval) ? (x->nval) : "(null)"));
		if (( ((x)->tval & (02|04)) == 02 ))
			{ if ((x->sval) != ((void *) 0)) { free((void *) (x->sval)); (x->sval) = ((void *) 0); } };
		x->tval &= ~(02|01|04);
		x->tval |= 020;
		x->sval = (char *) makesymtab(50);
	}
	z = setsymtab(buf, "", 0.0, 02|01, (Array *) x->sval);
	z->ctype = 1;
	z->csub = 2;
	if (((x)->csub == 4)) tfree(x); else;
	free(buf);
	return(z);
}

Cell *awkdelete(Node **a, int n)
{
	Cell *x, *y;
	Node *np;
	char *s;
	int nsub = strlen(*SUBSEP);

	x = execute(a[0]);
	if (!((x)->tval & 020))
		return True;
	if (a[1] == 0) {
		freesymtab(x);
		x->tval &= ~02;
		x->tval |= 020;
		x->sval = (char *) makesymtab(50);
	} else {
		int bufsz = recsize;
		char *buf;
		if ((buf = (char *) malloc(bufsz)) == ((void *) 0))
			FATAL("out of memory in adelete");
		buf[0] = 0;
		for (np = a[1]; np; np = np->nnext) {
			y = execute(np);
			s = getsval(y);
			if (!adjbuf(&buf, &bufsz, strlen(buf)+strlen(s)+nsub+1, recsize, 0, "awkdelete"))
				FATAL("out of memory deleting %s[%s...]", x->nval, buf);
			strcat(buf, s);
			if (np->nnext)
				strcat(buf, *SUBSEP);
			if (((y)->csub == 4)) tfree(y); else;
		}
		freeelem(x, buf);
		free(buf);
	}
	if (((x)->csub == 4)) tfree(x); else;
	return True;
}

Cell *intest(Node **a, int n)
{
	Cell *x, *ap, *k;
	Node *p;
	char *buf;
	char *s;
	int bufsz = recsize;
	int nsub = strlen(*SUBSEP);

	ap = execute(a[1]);
	if (!((ap)->tval & 020)) {
		   if (dbg) printf ("making %s into an array\n", ap->nval);
		if (( ((ap)->tval & (02|04)) == 02 ))
			{ if ((ap->sval) != ((void *) 0)) { free((void *) (ap->sval)); (ap->sval) = ((void *) 0); } };
		ap->tval &= ~(02|01|04);
		ap->tval |= 020;
		ap->sval = (char *) makesymtab(50);
	}
	if ((buf = (char *) malloc(bufsz)) == ((void *) 0)) {
		FATAL("out of memory in intest");
	}
	buf[0] = 0;
	for (p = a[0]; p; p = p->nnext) {
		x = execute(p);
		s = getsval(x);
		if (!adjbuf(&buf, &bufsz, strlen(buf)+strlen(s)+nsub+1, recsize, 0, "intest"))
			FATAL("out of memory deleting %s[%s...]", x->nval, buf);
		strcat(buf, s);
		if (((x)->csub == 4)) tfree(x); else;
		if (p->nnext)
			strcat(buf, *SUBSEP);
	}
	k = lookup(buf, (Array *) ap->sval);
	if (((ap)->csub == 4)) tfree(ap); else;
	free(buf);
	if (k == ((void *) 0))
		return(False);
	else
		return(True);
}


Cell *matchop(Node **a, int n)
{
	Cell *x, *y;
	char *s, *t;
	int i;
	fa *pfa;
	int (*mf)(fa *, const char *) = match, mode = 0;

	if (n == 304) {
		mf = pmatch;
		mode = 1;
	}
	x = execute(a[1]);
	s = getsval(x);
	if (a[0] == 0)
		i = (*mf)((fa *) a[2], s);
	else {
		y = execute(a[2]);
		t = getsval(y);
		pfa = makedfa(t, mode);
		i = (*mf)(pfa, s);
		if (((y)->csub == 4)) tfree(y); else;
	}
	if (((x)->csub == 4)) tfree(x); else;
	if (n == 304) {
		int start = patbeg - s + 1;
		if (patlen < 0)
			start = 0;
		setfval(rstartloc, (Awkfloat) start);
		setfval(rlengthloc, (Awkfloat) patlen);
		x = gettemp();
		x->tval = 01;
		x->fval = start;
		return x;
	} else if ((n == 265 && i == 1) || (n == 266 && i == 0))
		return(True);
	else
		return(False);
}


Cell *boolop(Node **a, int n)
{
	Cell *x, *y;
	int i;

	x = execute(a[0]);
	i = ((x)->csub == 11);
	if (((x)->csub == 4)) tfree(x); else;
	switch (n) {
	case 280:
		if (i) return(True);
		y = execute(a[1]);
		i = ((y)->csub == 11);
		if (((y)->csub == 4)) tfree(y); else;
		if (i) return(True);
		else return(False);
	case 279:
		if ( !i ) return(False);
		y = execute(a[1]);
		i = ((y)->csub == 11);
		if (((y)->csub == 4)) tfree(y); else;
		if (i) return(True);
		else return(False);
	case 343:
		if (i) return(False);
		else return(True);
	default:
		FATAL("unknown boolean operator %d", n);
	}
	return 0;
}

Cell *relop(Node **a, int n)
{
	int i;
	Cell *x, *y;
	Awkfloat j;

	x = execute(a[0]);
	y = execute(a[1]);
	if (x->tval&01 && y->tval&01) {
		j = x->fval - y->fval;
		i = j<0? -1: (j>0? 1: 0);
	} else {
		i = strcmp(getsval(x), getsval(y));
	}
	if (((x)->csub == 4)) tfree(x); else;
	if (((y)->csub == 4)) tfree(y); else;
	switch (n) {
	case 286:	if (i<0) return(True);
			else return(False);
	case 285:	if (i<=0) return(True);
			else return(False);
	case 287:	if (i!=0) return(True);
			else return(False);
	case 282:	if (i == 0) return(True);
			else return(False);
	case 283:	if (i>=0) return(True);
			else return(False);
	case 284:	if (i>0) return(True);
			else return(False);
	default:
		FATAL("unknown relational operator %d", n);
	}
	return 0;
}

void tfree(Cell *a)
{
	if (( ((a)->tval & (02|04)) == 02 )) {
		   if (dbg) printf ("freeing %s %s %o\n", ((a->nval) ? (a->nval) : "(null)"), ((a->sval) ? (a->sval) : "(null)"), a->tval);
		{ if ((a->sval) != ((void *) 0)) { free((void *) (a->sval)); (a->sval) = ((void *) 0); } };
	}
	if (a == tmps)
		FATAL("tempcell list is curdled");
	a->cnext = tmps;
	tmps = a;
}

Cell *gettemp(void)
{	int i;
	Cell *x;

	if (!tmps) {
		tmps = (Cell *) calloc(100, sizeof(Cell));
		if (!tmps)
			FATAL("out of space for temporaries");
		for(i = 1; i < 100; i++)
			tmps[i-1].cnext = &tmps[i];
		tmps[i-1].cnext = 0;
	}
	x = tmps;
	tmps = x->cnext;
	*x = tempcell;
	return(x);
}

Cell *indirect(Node **a, int n)
{
	Awkfloat val;
	Cell *x;
	int m;
	char *s;

	x = execute(a[0]);
	val = getfval(x);
	if ((Awkfloat)2147483647 < val)
		FATAL("trying to access out of range field %s", x->nval);
	m = (int) val;
	if (m == 0 && !is_number(s = getsval(x)))
		FATAL("illegal field $(%s), name \"%s\"", s, x->nval);

	if (((x)->csub == 4)) tfree(x); else;
	x = fieldadr(m);
	x->ctype = 1;
	x->csub = 1;
	return(x);
}

Cell *substr(Node **a, int nnn)
{
	int k, m, n;
	char *s;
	int temp;
	Cell *x, *y, *z = 0;

	x = execute(a[0]);
	y = execute(a[1]);
	if (a[2] != 0)
		z = execute(a[2]);
	s = getsval(x);
	k = strlen(s) + 1;
	if (k <= 1) {
		if (((x)->csub == 4)) tfree(x); else;
		if (((y)->csub == 4)) tfree(y); else;
		if (a[2] != 0) {
			if (((z)->csub == 4)) tfree(z); else;
		}
		x = gettemp();
		setsval(x, "");
		return(x);
	}
	m = (int) getfval(y);
	if (m <= 0)
		m = 1;
	else if (m > k)
		m = k;
	if (((y)->csub == 4)) tfree(y); else;
	if (a[2] != 0) {
		n = (int) getfval(z);
		if (((z)->csub == 4)) tfree(z); else;
	} else
		n = k - 1;
	if (n < 0)
		n = 0;
	else if (n > k - m)
		n = k - m;
	   if (dbg) printf ("substr: m=%d, n=%d, s=%s\n", m, n, s);
	y = gettemp();
	temp = s[n+m-1];
	s[n+m-1] = '\0';
	setsval(y, s + m - 1);
	s[n+m-1] = temp;
	if (((x)->csub == 4)) tfree(x); else;
	return(y);
}

Cell *sindex(Node **a, int nnn)
{
	Cell *x, *y, *z;
	char *s1, *s2, *p1, *p2, *q;
	Awkfloat v = 0.0;

	x = execute(a[0]);
	s1 = getsval(x);
	y = execute(a[1]);
	s2 = getsval(y);

	z = gettemp();
	for (p1 = s1; *p1 != '\0'; p1++) {
		for (q=p1, p2=s2; *p2 != '\0' && *q == *p2; q++, p2++)
			;
		if (*p2 == '\0') {
			v = (Awkfloat) (p1 - s1 + 1);
			break;
		}
	}
	if (((x)->csub == 4)) tfree(x); else;
	if (((y)->csub == 4)) tfree(y); else;
	setfval(z, v);
	return(z);
}



int format(char **pbuf, int *pbufsize, const char *s, Node *a)
{
	char *fmt;
	char *p, *t;
	const char *os;
	Cell *x;
	int flag = 0, n;
	int fmtwd;
	int fmtsz = recsize;
	char *buf = *pbuf;
	int bufsize = *pbufsize;

	os = s;
	p = buf;
	if ((fmt = (char *) malloc(fmtsz)) == ((void *) 0))
		FATAL("out of memory in format()");
	while (*s) {
		adjbuf(&buf, &bufsize, 50+1+p-buf, recsize, &p, "format1");
		if (*s != '%') {
			*p++ = *s++;
			continue;
		}
		if (*(s+1) == '%') {
			*p++ = '%';
			s += 2;
			continue;
		}

		fmtwd = atoi(s+1);
		if (fmtwd < 0)
			fmtwd = -fmtwd;
		adjbuf(&buf, &bufsize, fmtwd+1+p-buf, recsize, &p, "format2");
		for (t = fmt; (*t++ = *s) != '\0'; s++) {
			if (!adjbuf(&fmt, &fmtsz, 50+1+t-fmt, recsize, &t, "format3"))
				FATAL("format item %.30s... ran format() out of memory", os);
			if (((__ctype+1)[(uschar)*s]&(0x01|0x02)) && *s != 'l' && *s != 'h' && *s != 'L')
				break;
			if (*s == '*') {
				x = execute(a);
				a = a->nnext;
				sprintf(t-1, "%d", fmtwd=(int) getfval(x));
				if (fmtwd < 0)
					fmtwd = -fmtwd;
				adjbuf(&buf, &bufsize, fmtwd+1+p-buf, recsize, &p, "format");
				t = fmt + strlen(fmt);
				if (((x)->csub == 4)) tfree(x); else;
			}
		}
		*t = '\0';
		if (fmtwd < 0)
			fmtwd = -fmtwd;
		adjbuf(&buf, &bufsize, fmtwd+1+p-buf, recsize, &p, "format4");

		switch (*s) {
		case 'f': case 'e': case 'g': case 'E': case 'G':
			flag = 'f';
			break;
		case 'd': case 'i':
			flag = 'd';
			if(*(s-1) == 'l') break;
			*(t-1) = 'l';
			*t = 'd';
			*++t = '\0';
			break;
		case 'o': case 'x': case 'X': case 'u':
			flag = *(s-1) == 'l' ? 'd' : 'u';
			break;
		case 's':
			flag = 's';
			break;
		case 'c':
			flag = 'c';
			break;
		default:
			WARNING("weird printf conversion %s", fmt);
			flag = '?';
			break;
		}
		if (a == ((void *) 0))
			FATAL("not enough args in printf(%s)", os);
		x = execute(a);
		a = a->nnext;
		n = 50;
		if (fmtwd > n)
			n = fmtwd;
		adjbuf(&buf, &bufsize, 1+n+p-buf, recsize, &p, "format5");
		switch (flag) {
		case '?':	sprintf(p, "%s", fmt);
			t = getsval(x);
			n = strlen(t);
			if (fmtwd > n)
				n = fmtwd;
			adjbuf(&buf, &bufsize, 1+strlen(p)+n+p-buf, recsize, &p, "format6");
			p += strlen(p);
			sprintf(p, "%s", t);
			break;
		case 'f':	sprintf(p, fmt, getfval(x)); break;
		case 'd':	sprintf(p, fmt, (long) getfval(x)); break;
		case 'u':	sprintf(p, fmt, (int) getfval(x)); break;
		case 's':
			t = getsval(x);
			n = strlen(t);
			if (fmtwd > n)
				n = fmtwd;
			if (!adjbuf(&buf, &bufsize, 1+n+p-buf, recsize, &p, "format7"))
				FATAL("huge string/format (%d chars) in printf %.30s... ran format() out of memory", n, t);
			sprintf(p, fmt, t);
			break;
		case 'c':
			if (((x)->tval & 01)) {
				if (getfval(x))
					sprintf(p, fmt, (int) getfval(x));
				else {
					*p++ = '\0';
					*p = '\0';
				}
			} else
				sprintf(p, fmt, getsval(x)[0]);
			break;
		default:
			FATAL("can't happen: bad conversion %c in format()", flag);
		}
		if (((x)->csub == 4)) tfree(x); else;
		p += strlen(p);
		s++;
	}
	*p = '\0';
	free(fmt);
	for ( ; a; a = a->nnext)
		execute(a);
	*pbuf = buf;
	*pbufsize = bufsize;
	return p - buf;
}

Cell *awksprintf(Node **a, int n)
{
	Cell *x;
	Node *y;
	char *buf;
	int bufsz=3*recsize;

	if ((buf = (char *) malloc(bufsz)) == ((void *) 0))
		FATAL("out of memory in awksprintf");
	y = a[0]->nnext;
	x = execute(a[0]);
	if (format(&buf, &bufsz, getsval(x), y) == -1)
		FATAL("sprintf string %.30s... too long.  can't happen.", buf);
	if (((x)->csub == 4)) tfree(x); else;
	x = gettemp();
	x->sval = buf;
	x->tval = 02;
	return(x);
}

Cell *awkprintf(Node **a, int n)
{

	FILE *fp;
	Cell *x;
	Node *y;
	char *buf;
	int len;
	int bufsz=3*recsize;

	if ((buf = (char *) malloc(bufsz)) == ((void *) 0))
		FATAL("out of memory in awkprintf");
	y = a[0]->nnext;
	x = execute(a[0]);
	if ((len = format(&buf, &bufsz, getsval(x), y)) == -1)
		FATAL("printf string %.30s... too long.  can't happen.", buf);
	if (((x)->csub == 4)) tfree(x); else;
	if (a[1] == ((void *) 0)) {

		fwrite(buf, len, 1, (&__stdout));
		if (((((&__stdout))->_flags & 0x020) != 0))
			FATAL("write error on stdout");
	} else {
		fp = redirect(ptoi(a[1]), a[2]);

		fwrite(buf, len, 1, fp);
		fflush(fp);
		if ((((fp)->_flags & 0x020) != 0))
			FATAL("write error on %s", filename(fp));
	}
	free(buf);
	return(True);
}

Cell *arith(Node **a, int n)
{
	Awkfloat i, j = 0;
	double v;
	Cell *x, *y, *z;

	x = execute(a[0]);
	i = getfval(x);
	if (((x)->csub == 4)) tfree(x); else;
	if (n != 344) {
		y = execute(a[1]);
		j = getfval(y);
		if (((y)->csub == 4)) tfree(y); else;
	}
	z = gettemp();
	switch (n) {
	case 307:
		i += j;
		break;
	case 308:
		i -= j;
		break;
	case 309:
		i *= j;
		break;
	case 310:
		if (j == 0)
			FATAL("division by zero");
		i /= j;
		break;
	case 311:
		if (j == 0)
			FATAL("division by zero in mod");
		modf(i/j, &v);
		i = i - j * v;
		break;
	case 344:
		i = -i;
		break;
	case 345:
		if (j >= 0 && modf(j, &v) == 0.0)
			i = ipow(i, (int) j);
		else
			i = errcheck(pow(i, j), "pow");
		break;
	default:
		FATAL("illegal arithmetic operator %d", n);
	}
	setfval(z, i);
	return(z);
}

double ipow(double x, int n)
{
	double v;

	if (n <= 0)
		return 1;
	v = ipow(x, n/2);
	if (n % 2 == 0)
		return v * v;
	else
		return x * v * v;
}

Cell *incrdecr(Node **a, int n)
{
	Cell *x, *z;
	int k;
	Awkfloat xf;

	x = execute(a[0]);
	xf = getfval(x);
	k = (n == 327 || n == 326) ? 1 : -1;
	if (n == 327 || n == 329) {
		setfval(x, xf + k);
		return(x);
	}
	z = gettemp();
	setfval(z, xf);
	setfval(x, xf + k);
	if (((x)->csub == 4)) tfree(x); else;
	return(z);
}

Cell *assign(Node **a, int n)
{
	Cell *x, *y;
	Awkfloat xf, yf;
	double v;

	y = execute(a[1]);
	x = execute(a[0]);
	if (n == 312) {
		if (x == y && !(x->tval & (0100|0200)))
			;
		else if ((y->tval & (02|01)) == (02|01)) {
			setsval(x, getsval(y));
			x->fval = getfval(y);
			x->tval |= 01;
		}
		else if (((y)->tval & 02))
			setsval(x, getsval(y));
		else if (((y)->tval & 01))
			setfval(x, getfval(y));
		else
			funnyvar(y, "read value of");
		if (((y)->csub == 4)) tfree(y); else;
		return(x);
	}
	xf = getfval(x);
	yf = getfval(y);
	switch (n) {
	case 314:
		xf += yf;
		break;
	case 315:
		xf -= yf;
		break;
	case 316:
		xf *= yf;
		break;
	case 317:
		if (yf == 0)
			FATAL("division by zero in /=");
		xf /= yf;
		break;
	case 318:
		if (yf == 0)
			FATAL("division by zero in %%=");
		modf(xf/yf, &v);
		xf = xf - yf * v;
		break;
	case 319:
		if (yf >= 0 && modf(yf, &v) == 0.0)
			xf = ipow(xf, (int) yf);
		else
			xf = errcheck(pow(xf, yf), "pow");
		break;
	default:
		FATAL("illegal assignment operator %d", n);
		break;
	}
	if (((y)->csub == 4)) tfree(y); else;
	setfval(x, xf);
	return(x);
}

Cell *cat(Node **a, int q)
{
	Cell *x, *y, *z;
	int n1, n2;
	char *s;

	x = execute(a[0]);
	y = execute(a[1]);
	getsval(x);
	getsval(y);
	n1 = strlen(x->sval);
	n2 = strlen(y->sval);
	s = (char *) malloc(n1 + n2 + 1);
	if (s == ((void *) 0))
		FATAL("out of space concatenating %.15s... and %.15s...",
			x->sval, y->sval);
	strcpy(s, x->sval);
	strcpy(s+n1, y->sval);
	if (((x)->csub == 4)) tfree(x); else;
	if (((y)->csub == 4)) tfree(y); else;
	z = gettemp();
	z->sval = s;
	z->tval = 02;
	return(z);
}

Cell *pastat(Node **a, int n)
{
	Cell *x;

	if (a[0] == 0)
		x = execute(a[1]);
	else {
		x = execute(a[0]);
		if (((x)->csub == 11)) {
			if (((x)->csub == 4)) tfree(x); else;
			x = execute(a[1]);
		}
	}
	return x;
}

Cell *dopa2(Node **a, int n)
{
	Cell *x;
	int pair;

	pair = ptoi(a[3]);
	if (pairstack[pair] == 0) {
		x = execute(a[0]);
		if (((x)->csub == 11))
			pairstack[pair] = 1;
		if (((x)->csub == 4)) tfree(x); else;
	}
	if (pairstack[pair] == 1) {
		x = execute(a[1]);
		if (((x)->csub == 11))
			pairstack[pair] = 0;
		if (((x)->csub == 4)) tfree(x); else;
		x = execute(a[2]);
		return(x);
	}
	return(False);
}

Cell *split(Node **a, int nnn)
{
	Cell *x = 0, *y, *ap;
	char *s, *origs;
	int sep;
	char *t, temp, num[50], *fs = 0;
	int n, tempstat, arg3type;

	y = execute(a[0]);
	origs = s = strdup(getsval(y));
	arg3type = ptoi(a[3]);
	if (a[2] == 0)
		fs = *FS;
	else if (arg3type == 335) {
		x = execute(a[2]);
		fs = getsval(x);
	} else if (arg3type == 336)
		fs = "(regexpr)";
	else
		FATAL("illegal type of split");
	sep = *fs;
	ap = execute(a[1]);
	freesymtab(ap);
	   if (dbg) printf ("split: s=|%s|, a=%s, sep=|%s|\n", s, ((ap->nval) ? (ap->nval) : "(null)"), fs);
	ap->tval &= ~02;
	ap->tval |= 020;
	ap->sval = (char *) makesymtab(50);

	n = 0;
        if (arg3type == 336 && strlen((char*)((fa*)a[2])->restr) == 0) {

		arg3type = 0;
		fs = "";
		sep = 0;
	}
	if (*s != '\0' && (strlen(fs) > 1 || arg3type == 336)) {
		fa *pfa;
		if (arg3type == 336) {
			pfa = (fa *) a[2];
		} else {
			pfa = makedfa(fs, 1);
		}
		if (nematch(pfa,s)) {
			tempstat = pfa->initstat;
			pfa->initstat = 2;
			do {
				n++;
				sprintf(num, "%d", n);
				temp = *patbeg;
				*patbeg = '\0';
				if (is_number(s))
					setsymtab(num, s, atof(s), 02|01, (Array *) ap->sval);
				else
					setsymtab(num, s, 0.0, 02, (Array *) ap->sval);
				*patbeg = temp;
				s = patbeg + patlen;
				if (*(patbeg+patlen-1) == 0 || *s == 0) {
					n++;
					sprintf(num, "%d", n);
					setsymtab(num, "", 0.0, 02, (Array *) ap->sval);
					pfa->initstat = tempstat;
					goto spdone;
				}
			} while (nematch(pfa,s));
			pfa->initstat = tempstat;

		}
		n++;
		sprintf(num, "%d", n);
		if (is_number(s))
			setsymtab(num, s, atof(s), 02|01, (Array *) ap->sval);
		else
			setsymtab(num, s, 0.0, 02, (Array *) ap->sval);
  spdone:
		pfa = ((void *) 0);
	} else if (sep == ' ') {
		for (n = 0; ; ) {
			while (*s == ' ' || *s == '\t' || *s == '\n')
				s++;
			if (*s == 0)
				break;
			n++;
			t = s;
			do
				s++;
			while (*s!=' ' && *s!='\t' && *s!='\n' && *s!='\0');
			temp = *s;
			*s = '\0';
			sprintf(num, "%d", n);
			if (is_number(t))
				setsymtab(num, t, atof(t), 02|01, (Array *) ap->sval);
			else
				setsymtab(num, t, 0.0, 02, (Array *) ap->sval);
			*s = temp;
			if (*s != 0)
				s++;
		}
	} else if (sep == 0) {
		for (n = 0; *s != 0; s++) {
			char buf[2];
			n++;
			sprintf(num, "%d", n);
			buf[0] = *s;
			buf[1] = 0;
			if (((__ctype+1)[(uschar)buf[0]]&0x04))
				setsymtab(num, buf, atof(buf), 02|01, (Array *) ap->sval);
			else
				setsymtab(num, buf, 0.0, 02, (Array *) ap->sval);
		}
	} else if (*s != 0) {
		for (;;) {
			n++;
			t = s;
			while (*s != sep && *s != '\n' && *s != '\0')
				s++;
			temp = *s;
			*s = '\0';
			sprintf(num, "%d", n);
			if (is_number(t))
				setsymtab(num, t, atof(t), 02|01, (Array *) ap->sval);
			else
				setsymtab(num, t, 0.0, 02, (Array *) ap->sval);
			*s = temp;
			if (*s++ == 0)
				break;
		}
	}
	if (((ap)->csub == 4)) tfree(ap); else;
	if (((y)->csub == 4)) tfree(y); else;
	free(origs);
	if (a[2] != 0 && arg3type == 335) {
		if (((x)->csub == 4)) tfree(x); else;
	}
	x = gettemp();
	x->tval = 01;
	x->fval = n;
	return(x);
}

Cell *condexpr(Node **a, int n)
{
	Cell *x;

	x = execute(a[0]);
	if (((x)->csub == 11)) {
		if (((x)->csub == 4)) tfree(x); else;
		x = execute(a[1]);
	} else {
		if (((x)->csub == 4)) tfree(x); else;
		x = execute(a[2]);
	}
	return(x);
}

Cell *ifstat(Node **a, int n)
{
	Cell *x;

	x = execute(a[0]);
	if (((x)->csub == 11)) {
		if (((x)->csub == 4)) tfree(x); else;
		x = execute(a[1]);
	} else if (a[2] != 0) {
		if (((x)->csub == 4)) tfree(x); else;
		x = execute(a[2]);
	}
	return(x);
}

Cell *whilestat(Node **a, int n)
{
	Cell *x;

	for (;;) {
		x = execute(a[0]);
		if (!((x)->csub == 11))
			return(x);
		if (((x)->csub == 4)) tfree(x); else;
		x = execute(a[1]);
		if (((x)->csub == 23)) {
			x = True;
			return(x);
		}
		if (((x)->csub == 22 || (x)->csub == 26) || ((x)->csub == 21) || ((x)->csub == 25))
			return(x);
		if (((x)->csub == 4)) tfree(x); else;
	}
}

Cell *dostat(Node **a, int n)
{
	Cell *x;

	for (;;) {
		x = execute(a[0]);
		if (((x)->csub == 23))
			return True;
		if (((x)->csub == 22 || (x)->csub == 26) || ((x)->csub == 21) || ((x)->csub == 25))
			return(x);
		if (((x)->csub == 4)) tfree(x); else;
		x = execute(a[1]);
		if (!((x)->csub == 11))
			return(x);
		if (((x)->csub == 4)) tfree(x); else;
	}
}

Cell *forstat(Node **a, int n)
{
	Cell *x;

	x = execute(a[0]);
	if (((x)->csub == 4)) tfree(x); else;
	for (;;) {
		if (a[1]!=0) {
			x = execute(a[1]);
			if (!((x)->csub == 11)) return(x);
			else if (((x)->csub == 4)) tfree(x); else;
		}
		x = execute(a[3]);
		if (((x)->csub == 23))
			return True;
		if (((x)->csub == 22 || (x)->csub == 26) || ((x)->csub == 21) || ((x)->csub == 25))
			return(x);
		if (((x)->csub == 4)) tfree(x); else;
		x = execute(a[2]);
		if (((x)->csub == 4)) tfree(x); else;
	}
}

Cell *instat(Node **a, int n)
{
	Cell *x, *vp, *arrayp, *cp, *ncp;
	Array *tp;
	int i;

	vp = execute(a[0]);
	arrayp = execute(a[1]);
	if (!((arrayp)->tval & 020)) {
		return True;
	}
	tp = (Array *) arrayp->sval;
	if (((arrayp)->csub == 4)) tfree(arrayp); else;
	for (i = 0; i < tp->size; i++) {
		for (cp = tp->tab[i]; cp != ((void *) 0); cp = ncp) {
			setsval(vp, cp->nval);
			ncp = cp->cnext;
			x = execute(a[2]);
			if (((x)->csub == 23)) {
				if (((vp)->csub == 4)) tfree(vp); else;
				return True;
			}
			if (((x)->csub == 22 || (x)->csub == 26) || ((x)->csub == 21) || ((x)->csub == 25)) {
				if (((vp)->csub == 4)) tfree(vp); else;
				return(x);
			}
			if (((x)->csub == 4)) tfree(x); else;
		}
	}
	return True;
}

Cell *bltin(Node **a, int n)
{
	Cell *x, *y;
	Awkfloat u;
	int t;
	Awkfloat tmp;
	char *p, *buf;
	Node *nextarg;
	FILE *fp;
	void flush_all(void);

	t = ptoi(a[0]);
	x = execute(a[1]);
	nextarg = a[1]->nnext;
	switch (t) {
	case 1:
		if (((x)->tval & 020))
			u = ((Array *) x->sval)->nelem;
		else
			u = strlen(getsval(x));
		break;
	case 4:
		u = errcheck(log(getfval(x)), "log"); break;
	case 5:
		modf(getfval(x), &u); break;
	case 3:
		u = errcheck(exp(getfval(x)), "exp"); break;
	case 2:
		u = errcheck(sqrt(getfval(x)), "sqrt"); break;
	case 9:
		u = sin(getfval(x)); break;
	case 10:
		u = cos(getfval(x)); break;
	case 11:
		if (nextarg == 0) {
			WARNING("atan2 requires two arguments; returning 1.0");
			u = 1.0;
		} else {
			y = execute(a[1]->nnext);
			u = atan2(getfval(x), getfval(y));
			if (((y)->csub == 4)) tfree(y); else;
			nextarg = nextarg->nnext;
		}
		break;
	case 6:
		fflush((&__stdout));
		u = (Awkfloat) system(getsval(x)) / 256;
		break;
	case 7:

		u = (Awkfloat) (rand() % 32767) / 32767;
		break;
	case 8:
		if (((x)->tval & 0200))
			u = time((time_t *)0);
		else
			u = getfval(x);
		tmp = u;
		srand((unsigned int) u);
		u = srand_seed;
		srand_seed = tmp;
		break;
	case 12:
	case 13:
		buf = tostring(getsval(x));
		if (t == 12) {
			for (p = buf; *p; p++)
				if (((__ctype+1)[(uschar) *p]&0x02))
					*p = toupper((uschar)*p);
		} else {
			for (p = buf; *p; p++)
				if (((__ctype+1)[(uschar) *p]&0x01))
					*p = tolower((uschar)*p);
		}
		if (((x)->csub == 4)) tfree(x); else;
		x = gettemp();
		setsval(x, buf);
		free(buf);
		return x;
	case 14:
		if (((x)->tval & 0200) || strlen(getsval(x)) == 0) {
			flush_all();
			u = 0;
		} else if ((fp = openfile(14, getsval(x))) == ((void *) 0))
			u = (-1);
		else
			u = fflush(fp);
		break;
	default:
		FATAL("illegal function type %d", t);
		break;
	}
	if (((x)->csub == 4)) tfree(x); else;
	x = gettemp();
	setfval(x, u);
	if (nextarg != 0) {
		WARNING("warning: function has too many arguments");
		for ( ; nextarg; nextarg = nextarg->nnext)
			execute(nextarg);
	}
	return(x);
}

Cell *printstat(Node **a, int n)
{
	Node *x;
	Cell *y;
	FILE *fp;

	if (a[1] == 0)
		fp = (&__stdout);
	else
		fp = redirect(ptoi(a[1]), a[2]);
	for (x = a[0]; x != ((void *) 0); x = x->nnext) {
		y = execute(x);
		fputs(getpssval(y), fp);
		if (((y)->csub == 4)) tfree(y); else;
		if (x->nnext == ((void *) 0))
			fputs(*ORS, fp);
		else
			fputs(*OFS, fp);
	}
	if (a[1] != 0)
		fflush(fp);
	if ((((fp)->_flags & 0x020) != 0))
		FATAL("write error on %s", filename(fp));
	return(True);
}

Cell *nullproc(Node **a, int n)
{
	n = n;
	a = a;
	return 0;
}


FILE *redirect(int a, Node *b)
{
	FILE *fp;
	Cell *x;
	char *fname;

	x = execute(b);
	fname = getsval(x);
	fp = openfile(a, fname);
	if (fp == ((void *) 0))
		FATAL("can't open file %s", fname);
	if (((x)->csub == 4)) tfree(x); else;
	return fp;
}

struct files {
	FILE	*fp;
	const char	*fname;
	int	mode;
} *files;

int nfiles;

void stdinit(void)
{
	nfiles = 16;
	files = calloc(nfiles, sizeof(*files));
	if (files == ((void *) 0))
		FATAL("can't allocate file memory for %u files", nfiles);
        files[0].fp = (&__stdin);
	files[0].fname = "/dev/stdin";
	files[0].mode = 286;
        files[1].fp = (&__stdout);
	files[1].fname = "/dev/stdout";
	files[1].mode = 284;
        files[2].fp = (&__stderr);
	files[2].fname = "/dev/stderr";
	files[2].mode = 284;
}

FILE *openfile(int a, const char *us)
{
	const char *s = us;
	int i, m;
	FILE *fp = 0;

	if (*s == '\0')
		FATAL("null file name in print or getline");
	for (i=0; i < nfiles; i++)
		if (files[i].fname && strcmp(s, files[i].fname) == 0) {
			if (a == files[i].mode || (a==281 && files[i].mode==284))
				return files[i].fp;
			if (a == 14)
				return files[i].fp;
		}
	if (a == 14)
		return ((void *) 0);

	for (i=0; i < nfiles; i++)
		if (files[i].fp == 0)
			break;
	if (i >= nfiles) {
		struct files *nf;
		int nnf = nfiles + 16;
		nf = realloc(files, nnf * sizeof(*nf));
		if (nf == ((void *) 0))
			FATAL("cannot grow files for %s and %d files", s, nnf);
		memset(&nf[nfiles], 0, 16 * sizeof(*nf));
		nfiles = nnf;
		files = nf;
	}
	fflush((&__stdout));
	m = a;
	if (a == 284) {
		fp = fopen(s, "w");
	} else if (a == 281) {
		fp = fopen(s, "a");
		m = 284;
	} else if (a == '|') {
		fp = popen(s, "w");
	} else if (a == 285) {
		fp = popen(s, "r");
	} else if (a == 286) {
		fp = strcmp(s, "-") == 0 ? (&__stdin) : fopen(s, "r");
	} else
		FATAL("illegal redirection %d", a);
	if (fp != ((void *) 0)) {
		files[i].fname = tostring(s);
		files[i].fp = fp;
		files[i].mode = m;
	}
	return fp;
}

const char *filename(FILE *fp)
{
	int i;

	for (i = 0; i < nfiles; i++)
		if (fp == files[i].fp)
			return files[i].fname;
	return "???";
}

Cell *closefile(Node **a, int n)
{
	Cell *x;
	int i, stat;

	n = n;
	x = execute(a[0]);
	getsval(x);
	stat = -1;
	for (i = 0; i < nfiles; i++) {
		if (files[i].fname && strcmp(x->sval, files[i].fname) == 0) {
			if ((((files[i].fp)->_flags & 0x020) != 0))
				WARNING( "i/o error occurred on %s", files[i].fname );
			if (files[i].mode == '|' || files[i].mode == 285)
				stat = pclose(files[i].fp);
			else
				stat = fclose(files[i].fp);
			if (stat == (-1))
				WARNING( "i/o error occurred closing %s", files[i].fname );
			if (i > 2)
				{ if ((files[i].fname) != ((void *) 0)) { free((void *) (files[i].fname)); (files[i].fname) = ((void *) 0); } };
			files[i].fname = ((void *) 0);
			files[i].fp = ((void *) 0);
		}
	}
	if (((x)->csub == 4)) tfree(x); else;
	x = gettemp();
	setfval(x, (Awkfloat) stat);
	return(x);
}

void closeall(void)
{
	int i, stat;

	for (i = 0; i < 16; i++) {
		if (files[i].fp) {
			if ((((files[i].fp)->_flags & 0x020) != 0))
				WARNING( "i/o error occurred on %s", files[i].fname );
			if (files[i].mode == '|' || files[i].mode == 285)
				stat = pclose(files[i].fp);
			else
				stat = fclose(files[i].fp);
			if (stat == (-1))
				WARNING( "i/o error occurred while closing %s", files[i].fname );
		}
	}
}

void flush_all(void)
{
	int i;

	for (i = 0; i < nfiles; i++)
		if (files[i].fp)
			fflush(files[i].fp);
}

void backsub(char **pb_ptr, char **sptr_ptr);

Cell *sub(Node **a, int nnn)
{
	char *sptr, *pb, *q;
	Cell *x, *y, *result;
	char *t, *buf;
	fa *pfa;
	int bufsz = recsize;

	if ((buf = (char *) malloc(bufsz)) == ((void *) 0))
		FATAL("out of memory in sub");
	x = execute(a[3]);
	t = getsval(x);
	if (a[0] == 0)
		pfa = (fa *) a[1];
	else {
		y = execute(a[1]);
		pfa = makedfa(getsval(y), 1);
		if (((y)->csub == 4)) tfree(y); else;
	}
	y = execute(a[2]);
	result = False;
	if (pmatch(pfa, t)) {
		sptr = t;
		adjbuf(&buf, &bufsz, 1+patbeg-sptr, recsize, 0, "sub");
		pb = buf;
		while (sptr < patbeg)
			*pb++ = *sptr++;
		sptr = getsval(y);
		while (*sptr != 0) {
			adjbuf(&buf, &bufsz, 5+pb-buf, recsize, &pb, "sub");
			if (*sptr == '\\') {
				backsub(&pb, &sptr);
			} else if (*sptr == '&') {
				sptr++;
				adjbuf(&buf, &bufsz, 1+patlen+pb-buf, recsize, &pb, "sub");
				for (q = patbeg; q < patbeg+patlen; )
					*pb++ = *q++;
			} else
				*pb++ = *sptr++;
		}
		*pb = '\0';
		if (pb > buf + bufsz)
			FATAL("sub result1 %.30s too big; can't happen", buf);
		sptr = patbeg + patlen;
		if ((patlen == 0 && *patbeg) || (patlen && *(sptr-1))) {
			adjbuf(&buf, &bufsz, 1+strlen(sptr)+pb-buf, 0, &pb, "sub");
			while ((*pb++ = *sptr++) != 0)
				;
		}
		if (pb > buf + bufsz)
			FATAL("sub result2 %.30s too big; can't happen", buf);
		setsval(x, buf);
		result = True;;
	}
	if (((x)->csub == 4)) tfree(x); else;
	if (((y)->csub == 4)) tfree(y); else;
	free(buf);
	return result;
}

Cell *gsub(Node **a, int nnn)
{
	Cell *x, *y;
	char *rptr, *sptr, *t, *pb, *q;
	char *buf;
	fa *pfa;
	int mflag, tempstat, num;
	int bufsz = recsize;

	if ((buf = (char *) malloc(bufsz)) == ((void *) 0))
		FATAL("out of memory in gsub");
	mflag = 0;
	num = 0;
	x = execute(a[3]);
	t = getsval(x);
	if (a[0] == 0)
		pfa = (fa *) a[1];
	else {
		y = execute(a[1]);
		pfa = makedfa(getsval(y), 1);
		if (((y)->csub == 4)) tfree(y); else;
	}
	y = execute(a[2]);
	if (pmatch(pfa, t)) {
		tempstat = pfa->initstat;
		pfa->initstat = 2;
		pb = buf;
		rptr = getsval(y);
		do {
			if (patlen == 0 && *patbeg != 0) {
				if (mflag == 0) {
					num++;
					sptr = rptr;
					while (*sptr != 0) {
						adjbuf(&buf, &bufsz, 5+pb-buf, recsize, &pb, "gsub");
						if (*sptr == '\\') {
							backsub(&pb, &sptr);
						} else if (*sptr == '&') {
							sptr++;
							adjbuf(&buf, &bufsz, 1+patlen+pb-buf, recsize, &pb, "gsub");
							for (q = patbeg; q < patbeg+patlen; )
								*pb++ = *q++;
						} else
							*pb++ = *sptr++;
					}
				}
				if (*t == 0)
					goto done;
				adjbuf(&buf, &bufsz, 2+pb-buf, recsize, &pb, "gsub");
				*pb++ = *t++;
				if (pb > buf + bufsz)
					FATAL("gsub result0 %.30s too big; can't happen", buf);
				mflag = 0;
			}
			else {
				num++;
				sptr = t;
				adjbuf(&buf, &bufsz, 1+(patbeg-sptr)+pb-buf, recsize, &pb, "gsub");
				while (sptr < patbeg)
					*pb++ = *sptr++;
				sptr = rptr;
				while (*sptr != 0) {
					adjbuf(&buf, &bufsz, 5+pb-buf, recsize, &pb, "gsub");
					if (*sptr == '\\') {
						backsub(&pb, &sptr);
					} else if (*sptr == '&') {
						sptr++;
						adjbuf(&buf, &bufsz, 1+patlen+pb-buf, recsize, &pb, "gsub");
						for (q = patbeg; q < patbeg+patlen; )
							*pb++ = *q++;
					} else
						*pb++ = *sptr++;
				}
				t = patbeg + patlen;
				if (patlen == 0 || *t == 0 || *(t-1) == 0)
					goto done;
				if (pb > buf + bufsz)
					FATAL("gsub result1 %.30s too big; can't happen", buf);
				mflag = 1;
			}
		} while (pmatch(pfa,t));
		sptr = t;
		adjbuf(&buf, &bufsz, 1+strlen(sptr)+pb-buf, 0, &pb, "gsub");
		while ((*pb++ = *sptr++) != 0)
			;
	done:	if (pb < buf + bufsz)
			*pb = '\0';
		else if (*(pb-1) != '\0')
			FATAL("gsub result2 %.30s truncated; can't happen", buf);
		setsval(x, buf);
		pfa->initstat = tempstat;
	}
	if (((x)->csub == 4)) tfree(x); else;
	if (((y)->csub == 4)) tfree(y); else;
	x = gettemp();
	x->tval = 01;
	x->fval = num;
	free(buf);
	return(x);
}

void backsub(char **pb_ptr, char **sptr_ptr)
{
	char *pb = *pb_ptr, *sptr = *sptr_ptr;

	if (sptr[1] == '\\') {
		if (sptr[2] == '\\' && sptr[3] == '&') {
			*pb++ = '\\';
			*pb++ = '&';
			sptr += 4;
		} else if (sptr[2] == '&') {
			*pb++ = '\\';
			sptr += 2;
		} else {
			*pb++ = *sptr++;
			*pb++ = *sptr++;
		}
	} else if (sptr[1] == '&') {
		sptr++;
		*pb++ = *sptr++;
	} else
		*pb++ = *sptr++;

	*pb_ptr = pb;
	*sptr_ptr = sptr;
}
