# 1 "b.c"

# 44 "/home/charles/xcc/minix/include/ctype.h"
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
# 39 "/home/charles/xcc/minix/include/sys/defs.h"
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
# 48 "/home/charles/xcc/minix/include/stdio.h"
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
# 44 "/home/charles/xcc/minix/include/string.h"
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
# 53 "/home/charles/xcc/minix/include/stdlib.h"
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
# 44 "/home/charles/xcc/minix/include/assert.h"
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
# 65 "b.c"
int	*setvec;
int	*tmpset;
int	maxsetvec = 0;

int	rtok;
int	rlxval;
static uschar	*rlxstr;
static uschar	*prestr;
static uschar	*lastre;

static	int setcnt;
static	int poscnt;

char	*patbeg;
int	patlen;


fa	*fatab[20];
int	nfatab	= 0;

fa *makedfa(const char *s, int anchor)
{
	int i, use, nuse;
	fa *pfa;
	static int now = 1;

	if (setvec == 0) {
		maxsetvec = 22;
		setvec = (int *) malloc(maxsetvec * sizeof(int));
		tmpset = (int *) malloc(maxsetvec * sizeof(int));
		if (setvec == 0 || tmpset == 0)
			overflo("out of space initializing makedfa");
	}

	if (compile_time)
		return mkdfa(s, anchor);
	for (i = 0; i < nfatab; i++)
		if (fatab[i]->anchor == anchor
		  && strcmp((const char *) fatab[i]->restr, s) == 0) {
			fatab[i]->use = now++;
			return fatab[i];
		}
	pfa = mkdfa(s, anchor);
	if (nfatab < 20) {
		fatab[nfatab] = pfa;
		fatab[nfatab]->use = now++;
		nfatab++;
		return pfa;
	}
	use = fatab[0]->use;
	nuse = 0;
	for (i = 1; i < nfatab; i++)
		if (fatab[i]->use < use) {
			use = fatab[i]->use;
			nuse = i;
		}
	freefa(fatab[nuse]);
	fatab[nuse] = pfa;
	pfa->use = now++;
	return pfa;
}

fa *mkdfa(const char *s, int anchor)

{
	Node *p, *p1;
	fa *f;

	p = reparse(s);
	p1 = op2(342, op2(275, op2(270, ((Node *) 0), ((Node *) 0)), ((Node *) 0)), p);

	p1 = op2(342, p1, op2(268, ((Node *) 0), ((Node *) 0)));


	poscnt = 0;
	penter(p1);
	if ((f = (fa *) calloc(1, sizeof(fa) + poscnt*sizeof(rrow))) == ((void *) 0))
		overflo("out of space for fa");
	f->accept = poscnt-1;
	cfoll(f, p1);
	freetr(p1);
	if ((f->posns[0] = (int *) calloc(1, *(f->re[0].lfollow)*sizeof(int))) == ((void *) 0))
			overflo("out of space in makedfa");
	if ((f->posns[1] = (int *) calloc(1, sizeof(int))) == ((void *) 0))
		overflo("out of space in makedfa");
	*f->posns[1] = 0;
	f->initstat = makeinit(f, anchor);
	f->anchor = anchor;
	f->restr = (uschar *) tostring(s);
	return f;
}

int makeinit(fa *f, int anchor)
{
	int i, k;

	f->curstat = 2;
	f->out[2] = 0;
	f->reset = 0;
	k = *(f->re[0].lfollow);
	{ if ((f->posns[2]) != ((void *) 0)) { free((void *) (f->posns[2])); (f->posns[2]) = ((void *) 0); } };
	if ((f->posns[2] = (int *) calloc(1, (k+1)*sizeof(int))) == ((void *) 0))
		overflo("out of space in makeinit");
	for (i=0; i <= k; i++) {
		(f->posns[2])[i] = (f->re[0].lfollow)[i];
	}
	if ((f->posns[2])[1] == f->accept)
		f->out[2] = 1;
	for (i=0; i < (256+3); i++)
		f->gototab[2][i] = 0;
	f->curstat = cgoto(f, 2, ((256+3)+2));
	if (anchor) {
		*f->posns[2] = k-1;
		for (i=0; i < k; i++) {
			(f->posns[0])[i] = (f->posns[2])[i];
		}

		f->out[0] = f->out[2];
		if (f->curstat != 2)
			--(*f->posns[f->curstat]);
	}
	return f->curstat;
}

void penter(Node *p)
{
	switch ((p)->nobj) {
	case 278:
	case 271: case 272: case 273: case 269: case 268: case 270:
		(p)->ntype = poscnt;
		poscnt++;
		break;
	case 275: case 277: case 276:
		penter((p)->narg[0]);
		((p)->narg[0])->nnext = p;
		break;
	case 342:
	case 274:
		penter((p)->narg[0]);
		penter((p)->narg[1]);
		((p)->narg[0])->nnext = p;
		((p)->narg[1])->nnext = p;
		break;
	default:
		FATAL("can't happen: unknown type %d in penter", (p)->nobj);
		break;
	}
}

void freetr(Node *p)
{
	switch ((p)->nobj) {
	case 278:
	case 271: case 272: case 273: case 269: case 268: case 270:
		{ if ((p) != ((void *) 0)) { free((void *) (p)); (p) = ((void *) 0); } };
		break;
	case 275: case 277: case 276:
		freetr((p)->narg[0]);
		{ if ((p) != ((void *) 0)) { free((void *) (p)); (p) = ((void *) 0); } };
		break;
	case 342:
	case 274:
		freetr((p)->narg[0]);
		freetr((p)->narg[1]);
		{ if ((p) != ((void *) 0)) { free((void *) (p)); (p) = ((void *) 0); } };
		break;
	default:
		FATAL("can't happen: unknown type %d in freetr", (p)->nobj);
		break;
	}
}




int hexstr(uschar **pp)
{
	uschar *p;
	int n = 0;
	int i;

	for (i = 0, p = (uschar *) *pp; i < 2 && ((__ctype+1)[*p]&(0x04|0x40)); i++, p++) {
		if (((__ctype+1)[*p]&0x04))
			n = 16 * n + *p - '0';
		else if (*p >= 'a' && *p <= 'f')
			n = 16 * n + *p - 'a' + 10;
		else if (*p >= 'A' && *p <= 'F')
			n = 16 * n + *p - 'A' + 10;
	}
	*pp = (uschar *) p;
	return n;
}



int quoted(uschar **pp)

{
	uschar *p = *pp;
	int c;

	if ((c = *p++) == 't')
		c = '\t';
	else if (c == 'n')
		c = '\n';
	else if (c == 'f')
		c = '\f';
	else if (c == 'r')
		c = '\r';
	else if (c == 'b')
		c = '\b';
	else if (c == '\\')
		c = '\\';
	else if (c == 'x') {
		c = hexstr(&p);
	} else if (((c) >= '0' && (c) <= '7')) {
		int n = c - '0';
		if (((*p) >= '0' && (*p) <= '7')) {
			n = 8 * n + *p++ - '0';
			if (((*p) >= '0' && (*p) <= '7'))
				n = 8 * n + *p++ - '0';
		}
		c = n;
	}

	*pp = p;
	return c;
}

char *cclenter(const char *argp)
{
	int i, c, c2;
	uschar *p = (uschar *) argp;
	uschar *op, *bp;
	static uschar *buf = 0;
	static int bufsz = 100;

	op = p;
	if (buf == 0 && (buf = (uschar *) malloc(bufsz)) == ((void *) 0))
		FATAL("out of space for character class [%.10s...] 1", p);
	bp = buf;
	for (i = 0; (c = *p++) != 0; ) {
		if (c == '\\') {
			c = quoted(&p);
		} else if (c == '-' && i > 0 && bp[-1] != 0) {
			if (*p != 0) {
				c = bp[-1];
				c2 = *p++;
				if (c2 == '\\')
					c2 = quoted(&p);
				if (c > c2) {
					bp--;
					i--;
					continue;
				}
				while (c < c2) {
					if (!adjbuf((char **) &buf, &bufsz, bp-buf+2, 100, (char **) &bp, "cclenter1"))
						FATAL("out of space for character class [%.10s...] 2", p);
					*bp++ = ++c;
					i++;
				}
				continue;
			}
		}
		if (!adjbuf((char **) &buf, &bufsz, bp-buf+2, 100, (char **) &bp, "cclenter2"))
			FATAL("out of space for character class [%.10s...] 3", p);
		*bp++ = c;
		i++;
	}
	*bp = 0;
	if (dbg) printf ("cclenter: in = |%s|, out = |%s|\n", op, buf);
	{ if ((op) != ((void *) 0)) { free((void *) (op)); (op) = ((void *) 0); } };
	return (char *) tostring((char *) buf);
}

void overflo(const char *s)
{
	FATAL("regular expression too big: %.30s...", s);
}

void cfoll(fa *f, Node *v)
{
	int i;
	int *p;

	switch ((v)->nobj) {
	case 278:
	case 271: case 272: case 273: case 269: case 268: case 270:
		f->re[(v)->ntype].ltype = (v)->nobj;
		f->re[(v)->ntype].lval.np = (v)->narg[1];
		while (f->accept >= maxsetvec) {
			maxsetvec *= 4;
			setvec = (int *) realloc(setvec, maxsetvec * sizeof(int));
			tmpset = (int *) realloc(tmpset, maxsetvec * sizeof(int));
			if (setvec == 0 || tmpset == 0)
				overflo("out of space in cfoll()");
		}
		for (i = 0; i <= f->accept; i++)
			setvec[i] = 0;
		setcnt = 0;
		follow(v);
		if ((p = (int *) calloc(1, (setcnt+1)*sizeof(int))) == ((void *) 0))
			overflo("out of space building follow set");
		f->re[(v)->ntype].lfollow = p;
		*p = setcnt;
		for (i = f->accept; i >= 0; i--)
			if (setvec[i] == 1)
				*++p = i;
		break;
	case 275: case 277: case 276:
		cfoll(f,(v)->narg[0]);
		break;
	case 342:
	case 274:
		cfoll(f,(v)->narg[0]);
		cfoll(f,(v)->narg[1]);
		break;
	default:
		FATAL("can't happen: unknown type %d in cfoll", (v)->nobj);
	}
}

int first(Node *p)

{
	int b, lp;

	switch ((p)->nobj) {
	case 278:
	case 271: case 272: case 273: case 269: case 268: case 270:
		lp = (p)->ntype;
		while (setcnt >= maxsetvec || lp >= maxsetvec) {
			maxsetvec *= 4;
			setvec = (int *) realloc(setvec, maxsetvec * sizeof(int));
			tmpset = (int *) realloc(tmpset, maxsetvec * sizeof(int));
			if (setvec == 0 || tmpset == 0)
				overflo("out of space in first()");
		}
		if ((p)->nobj == 278) {
			setvec[lp] = 0;
			return(0);
		}
		if (setvec[lp] != 1) {
			setvec[lp] = 1;
			setcnt++;
		}
		if ((p)->nobj == 271 && (*(char *) (p)->narg[1]) == '\0')
			return(0);
		else return(1);
	case 277:
		if (first((p)->narg[0]) == 0) return(0);
		return(1);
	case 275:
	case 276:
		first((p)->narg[0]);
		return(0);
	case 342:
		if (first((p)->narg[0]) == 0 && first((p)->narg[1]) == 0) return(0);
		return(1);
	case 274:
		b = first((p)->narg[1]);
		if (first((p)->narg[0]) == 0 || b == 0) return(0);
		return(1);
	}
	FATAL("can't happen: unknown type %d in first", (p)->nobj);
	return(-1);
}

void follow(Node *v)
{
	Node *p;

	if ((v)->nobj == 268)
		return;
	p = (v)->nnext;
	switch ((p)->nobj) {
	case 275:
	case 277:
		first(v);
		follow(p);
		return;

	case 274:
	case 276:
		follow(p);
		return;

	case 342:
		if (v == (p)->narg[0]) {
			if (first((p)->narg[1]) == 0) {
				follow(p);
				return;
			}
		} else
			follow(p);
		return;
	}
}

int member(int c, const char *sarg)
{
	uschar *s = (uschar *) sarg;

	while (*s)
		if (c == *s++)
			return(1);
	return(0);
}

int match(fa *f, const char *p0)
{
	int s, ns;
	uschar *p = (uschar *) p0;

	s = f->reset ? makeinit(f,0) : f->initstat;
	if (f->out[s])
		return(1);
	do {

		if ((ns = f->gototab[s][*p]) != 0)
			s = ns;
		else
			s = cgoto(f, s, *p);
		if (f->out[s])
			return(1);
	} while (*p++ != 0);
	return(0);
}

int pmatch(fa *f, const char *p0)
{
	int s, ns;
	uschar *p = (uschar *) p0;
	uschar *q;
	int i, k;


	if (f->reset) {
		f->initstat = s = makeinit(f,1);
	} else {
		s = f->initstat;
	}
	patbeg = (char *) p;
	patlen = -1;
	do {
		q = p;
		do {
			if (f->out[s])
				patlen = q-p;

			if ((ns = f->gototab[s][*q]) != 0)
				s = ns;
			else
				s = cgoto(f, s, *q);
			if (s == 1) {
				if (patlen >= 0) {
					patbeg = (char *) p;
					return(1);
				}
				else
					goto nextin;
			}
		} while (*q++ != 0);
		if (f->out[s])
			patlen = q-p-1;
		if (patlen >= 0) {
			patbeg = (char *) p;
			return(1);
		}
	nextin:
		s = 2;
		if (f->reset) {
			for (i = 2; i <= f->curstat; i++)
				{ if ((f->posns[i]) != ((void *) 0)) { free((void *) (f->posns[i])); (f->posns[i]) = ((void *) 0); } };
			k = *f->posns[0];
			if ((f->posns[2] = (int *) calloc(1, (k+1)*sizeof(int))) == ((void *) 0))
				overflo("out of space in pmatch");
			for (i = 0; i <= k; i++)
				(f->posns[2])[i] = (f->posns[0])[i];
			f->initstat = f->curstat = 2;
			f->out[2] = f->out[0];
			for (i = 0; i < (256+3); i++)
				f->gototab[2][i] = 0;
		}
	} while (*p++ != 0);
	return (0);
}

int nematch(fa *f, const char *p0)
{
	int s, ns;
	uschar *p = (uschar *) p0;
	uschar *q;
	int i, k;


	if (f->reset) {
		f->initstat = s = makeinit(f,1);
	} else {
		s = f->initstat;
	}
	patlen = -1;
	while (*p) {
		q = p;
		do {
			if (f->out[s])
				patlen = q-p;

			if ((ns = f->gototab[s][*q]) != 0)
				s = ns;
			else
				s = cgoto(f, s, *q);
			if (s == 1) {
				if (patlen > 0) {
					patbeg = (char *) p;
					return(1);
				} else
					goto nnextin;
			}
		} while (*q++ != 0);
		if (f->out[s])
			patlen = q-p-1;
		if (patlen > 0 ) {
			patbeg = (char *) p;
			return(1);
		}
	nnextin:
		s = 2;
		if (f->reset) {
			for (i = 2; i <= f->curstat; i++)
				{ if ((f->posns[i]) != ((void *) 0)) { free((void *) (f->posns[i])); (f->posns[i]) = ((void *) 0); } };
			k = *f->posns[0];
			if ((f->posns[2] = (int *) calloc(1, (k+1)*sizeof(int))) == ((void *) 0))
				overflo("out of state space");
			for (i = 0; i <= k; i++)
				(f->posns[2])[i] = (f->posns[0])[i];
			f->initstat = f->curstat = 2;
			f->out[2] = f->out[0];
			for (i = 0; i < (256+3); i++)
				f->gototab[2][i] = 0;
		}
		p++;
	}
	return (0);
}

Node *reparse(const char *p)
{
	Node *np;

	if (dbg) printf ("reparse <%s>\n", p);
	lastre = prestr = (uschar *) p;
	rtok = relex();

	if (rtok == '\0') {

		return(op2(278, ((Node *) 0), ((Node *) 0)));
	}
	np = regexp();
	if (rtok != '\0')
		FATAL("syntax error in regular expression %s at %s", lastre, prestr);
	return(np);
}

Node *regexp(void)
{
	return (alt(concat(primary())));
}

Node *primary(void)
{
	Node *np;

	switch (rtok) {
	case 273:
		np = op2(273, ((Node *) 0), itonp(rlxval));
		rtok = relex();
		return (unary(np));
	case 270:
		rtok = relex();
		return (unary(op2(270, ((Node *) 0), ((Node *) 0))));
	case 278:
		rtok = relex();
		return (unary(op2(270, ((Node *) 0), ((Node *) 0))));
	case 269:
		rtok = relex();
		return (unary(op2(269, ((Node *) 0), ((Node *) 0))));
	case 271:
		np = op2(271, ((Node *) 0), (Node*) cclenter((char *) rlxstr));
		rtok = relex();
		return (unary(np));
	case 272:
		np = op2(272, ((Node *) 0), (Node *) cclenter((char *) rlxstr));
		rtok = relex();
		return (unary(np));
	case '^':
		rtok = relex();
		return (unary(op2(273, ((Node *) 0), itonp(((256+3)+2)))));
	case '$':
		rtok = relex();
		return (unary(op2(273, ((Node *) 0), ((Node *) 0))));
	case '(':
		rtok = relex();
		if (rtok == ')') {
			rtok = relex();
			return unary(op2(271, ((Node *) 0), (Node *) tostring("")));
		}
		np = regexp();
		if (rtok == ')') {
			rtok = relex();
			return (unary(np));
		}
		else
			FATAL("syntax error in regular expression %s at %s", lastre, prestr);
	default:
		FATAL("illegal primary in regular expression %s at %s", lastre, prestr);
	}
	return 0;
}

Node *concat(Node *np)
{
	switch (rtok) {
	case 273: case 269: case 270: case 278: case 271: case 272: case '$': case '(':
		return (concat(op2(342, np, primary())));
	}
	return (np);
}

Node *alt(Node *np)
{
	if (rtok == 274) {
		rtok = relex();
		return (alt(op2(274, np, concat(primary()))));
	}
	return (np);
}

Node *unary(Node *np)
{
	switch (rtok) {
	case 275:
		rtok = relex();
		return (unary(op2(275, np, ((Node *) 0))));
	case 277:
		rtok = relex();
		return (unary(op2(277, np, ((Node *) 0))));
	case 276:
		rtok = relex();
		return (unary(op2(276, np, ((Node *) 0))));
	default:
		return (np);
	}
}
# 743 "b.c"
int (xisblank)(int c)
{
	return c==' ' || c=='\t';
}



struct charclass {
	const char *cc_name;
	int cc_namelen;
	int (*cc_func)(int);
} charclasses[] = {
	{ "alnum",	5,	isalnum },
	{ "alpha",	5,	isalpha },

	{ "blank",	5,	isspace },



	{ "cntrl",	5,	iscntrl },
	{ "digit",	5,	isdigit },
	{ "graph",	5,	isgraph },
	{ "lower",	5,	islower },
	{ "print",	5,	isprint },
	{ "punct",	5,	ispunct },
	{ "space",	5,	isspace },
	{ "upper",	5,	isupper },
	{ "xdigit",	6,	isxdigit },
	{ ((void *) 0),		0,	((void *) 0) },
};


int relex(void)
{
	int c, n;
	int cflag;
	static uschar *buf = 0;
	static int bufsz = 100;
	uschar *bp;
	struct charclass *cc;
	int i;

	switch (c = *prestr++) {
	case '|': return 274;
	case '*': return 275;
	case '+': return 277;
	case '?': return 276;
	case '.': return 269;
	case '\0': prestr--; return '\0';
	case '^':
	case '$':
	case '(':
	case ')':
		return c;
	case '\\':
		rlxval = quoted(&prestr);
		return 273;
	default:
		rlxval = c;
		return 273;
	case '[':
		if (buf == 0 && (buf = (uschar *) malloc(bufsz)) == ((void *) 0))
			FATAL("out of space in reg expr %.10s..", lastre);
		bp = buf;
		if (*prestr == '^') {
			cflag = 1;
			prestr++;
		}
		else
			cflag = 0;
		n = 2 * strlen((const char *) prestr)+1;
		if (!adjbuf((char **) &buf, &bufsz, n, n, (char **) &bp, "relex1"))
			FATAL("out of space for reg expr %.10s...", lastre);
		for (; ; ) {
			if ((c = *prestr++) == '\\') {
				*bp++ = '\\';
				if ((c = *prestr++) == '\0')
					FATAL("nonterminated character class %.20s...", lastre);
				*bp++ = c;


			} else if (c == '[' && *prestr == ':') {

				for (cc = charclasses; cc->cc_name; cc++)
					if (strncmp((const char *) prestr + 1, (const char *) cc->cc_name, cc->cc_namelen) == 0)
						break;
				if (cc->cc_name != ((void *) 0) && prestr[1 + cc->cc_namelen] == ':' &&
				    prestr[2 + cc->cc_namelen] == ']') {
					prestr += cc->cc_namelen + 3;
					for (i = 0; i < (256+3); i++) {
						if (!adjbuf((char **) &buf, &bufsz, bp-buf+1, 100, (char **) &bp, "relex2"))
						    FATAL("out of space for reg expr %.10s...", lastre);
						if (cc->cc_func(i)) {
							*bp++ = i;
							n++;
						}
					}
				} else
					*bp++ = c;
			} else if (c == '\0') {
				FATAL("nonterminated character class %.20s", lastre);
			} else if (bp == buf) {
				*bp++ = c;
			} else if (c == ']') {
				*bp++ = 0;
				rlxstr = (uschar *) tostring((char *) buf);
				if (cflag == 0)
					return 271;
				else
					return 272;
			} else
				*bp++ = c;
		}
	}
}

int cgoto(fa *f, int s, int c)
{
	int i, j, k;
	int *p, *q;

	if (!(c == ((256+3)+2) || c < (256+3))) __assert("c == HAT || c < NCHARS", "b.c", 864);;
	while (f->accept >= maxsetvec) {
		maxsetvec *= 4;
		setvec = (int *) realloc(setvec, maxsetvec * sizeof(int));
		tmpset = (int *) realloc(tmpset, maxsetvec * sizeof(int));
		if (setvec == 0 || tmpset == 0)
			overflo("out of space in cgoto()");
	}
	for (i = 0; i <= f->accept; i++)
		setvec[i] = 0;
	setcnt = 0;

	p = f->posns[s];
	for (i = 1; i <= *p; i++) {
		if ((k = f->re[p[i]].ltype) != 268) {
			if ((k == 273 && c == ptoi(f->re[p[i]].lval.np))
			 || (k == 269 && c != 0 && c != ((256+3)+2))
			 || (k == 270 && c != 0)
			 || (k == 278 && c != 0)
			 || (k == 271 && member(c, (char *) f->re[p[i]].lval.up))
			 || (k == 272 && !member(c, (char *) f->re[p[i]].lval.up) && c != 0 && c != ((256+3)+2))) {
				q = f->re[p[i]].lfollow;
				for (j = 1; j <= *q; j++) {
					if (q[j] >= maxsetvec) {
						maxsetvec *= 4;
						setvec = (int *) realloc(setvec, maxsetvec * sizeof(int));
						tmpset = (int *) realloc(tmpset, maxsetvec * sizeof(int));
						if (setvec == 0 || tmpset == 0)
							overflo("cgoto overflow");
					}
					if (setvec[q[j]] == 0) {
						setcnt++;
						setvec[q[j]] = 1;
					}
				}
			}
		}
	}

	tmpset[0] = setcnt;
	j = 1;
	for (i = f->accept; i >= 0; i--)
		if (setvec[i]) {
			tmpset[j++] = i;
		}

	for (i = 1; i <= f->curstat; i++) {
		p = f->posns[i];
		if ((k = tmpset[0]) != p[0])
			goto different;
		for (j = 1; j <= k; j++)
			if (tmpset[j] != p[j])
				goto different;

		f->gototab[s][c] = i;
		return i;
	  different:;
	}


	if (f->curstat >= 32-1) {
		f->curstat = 2;
		f->reset = 1;
		for (i = 2; i < 32; i++)
			{ if ((f->posns[i]) != ((void *) 0)) { free((void *) (f->posns[i])); (f->posns[i]) = ((void *) 0); } };
	} else
		++(f->curstat);
	for (i = 0; i < (256+3); i++)
		f->gototab[f->curstat][i] = 0;
	{ if ((f->posns[f->curstat]) != ((void *) 0)) { free((void *) (f->posns[f->curstat])); (f->posns[f->curstat]) = ((void *) 0); } };
	if ((p = (int *) calloc(1, (setcnt+1)*sizeof(int))) == ((void *) 0))
		overflo("out of space in cgoto");

	f->posns[f->curstat] = p;
	f->gototab[s][c] = f->curstat;
	for (i = 0; i <= setcnt; i++)
		p[i] = tmpset[i];
	if (setvec[f->accept])
		f->out[f->curstat] = 1;
	else
		f->out[f->curstat] = 0;
	return f->curstat;
}


void freefa(fa *f)
{
	int i;

	if (f == ((void *) 0))
		return;
	for (i = 0; i <= f->curstat; i++)
		{ if ((f->posns[i]) != ((void *) 0)) { free((void *) (f->posns[i])); (f->posns[i]) = ((void *) 0); } };
	for (i = 0; i <= f->accept; i++) {
		{ if ((f->re[i].lfollow) != ((void *) 0)) { free((void *) (f->re[i].lfollow)); (f->re[i].lfollow) = ((void *) 0); } };
		if (f->re[i].ltype == 271 || f->re[i].ltype == 272)
			{ if (((f->re[i].lval.np)) != ((void *) 0)) { free((void *) ((f->re[i].lval.np))); ((f->re[i].lval.np)) = ((void *) 0); } };
	}
	{ if ((f->restr) != ((void *) 0)) { free((void *) (f->restr)); (f->restr) = ((void *) 0); } };
	{ if ((f) != ((void *) 0)) { free((void *) (f)); (f) = ((void *) 0); } };
}
