# 1 "tran.c"

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
# 42 "/home/charles/xcc/minix/include/math.h"
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
# 43 "tran.c"
Array	*symtab;

char	**FS;
char	**RS;
char	**OFS;
char	**ORS;
char	**OFMT;
char	**CONVFMT;
Awkfloat *NF;
Awkfloat *NR;
Awkfloat *FNR;
char	**FILENAME;
Awkfloat *ARGC;
char	**SUBSEP;
Awkfloat *RSTART;
Awkfloat *RLENGTH;

Cell	*fsloc;
Cell	*nrloc;
Cell	*nfloc;
Cell	*fnrloc;
Array	*ARGVtab;
Array	*ENVtab;
Cell	*rstartloc;
Cell	*rlengthloc;
Cell	*symtabloc;

Cell	*nullloc;
Node	*nullnode;
Cell	*literal0;

extern Cell **fldtab;

void syminit(void)
{
	literal0 = setsymtab("0", "0", 0.0, 01|02|010|04, symtab);

	nullloc = setsymtab("$zero&null", "", 0.0, 01|02|010|04, symtab);
	nullnode = celltonode(nullloc, 5);

	fsloc = setsymtab("FS", " ", 0.0, 02|04, symtab);
	FS = &fsloc->sval;
	RS = &setsymtab("RS", "\n", 0.0, 02|04, symtab)->sval;
	OFS = &setsymtab("OFS", " ", 0.0, 02|04, symtab)->sval;
	ORS = &setsymtab("ORS", "\n", 0.0, 02|04, symtab)->sval;
	OFMT = &setsymtab("OFMT", "%.6g", 0.0, 02|04, symtab)->sval;
	CONVFMT = &setsymtab("CONVFMT", "%.6g", 0.0, 02|04, symtab)->sval;
	FILENAME = &setsymtab("FILENAME", "", 0.0, 02|04, symtab)->sval;
	nfloc = setsymtab("NF", "", 0.0, 01, symtab);
	NF = &nfloc->fval;
	nrloc = setsymtab("NR", "", 0.0, 01, symtab);
	NR = &nrloc->fval;
	fnrloc = setsymtab("FNR", "", 0.0, 01, symtab);
	FNR = &fnrloc->fval;
	SUBSEP = &setsymtab("SUBSEP", "\034", 0.0, 02|04, symtab)->sval;
	rstartloc = setsymtab("RSTART", "", 0.0, 01, symtab);
	RSTART = &rstartloc->fval;
	rlengthloc = setsymtab("RLENGTH", "", 0.0, 01, symtab);
	RLENGTH = &rlengthloc->fval;
	symtabloc = setsymtab("SYMTAB", "", 0.0, 020, symtab);
	symtabloc->sval = (char *) symtab;
}

void arginit(int ac, char **av)
{
	Cell *cp;
	int i;
	char temp[50];

	ARGC = &setsymtab("ARGC", "", (Awkfloat) ac, 01, symtab)->fval;
	cp = setsymtab("ARGV", "", 0.0, 020, symtab);
	ARGVtab = makesymtab(50);
	cp->sval = (char *) ARGVtab;
	for (i = 0; i < ac; i++) {
		sprintf(temp, "%d", i);
		if (is_number(*av))
			setsymtab(temp, *av, atof(*av), 02|01, ARGVtab);
		else
			setsymtab(temp, *av, 0.0, 02, ARGVtab);
		av++;
	}
}

void envinit(char **envp)
{
	Cell *cp;
	char *p;

	cp = setsymtab("ENVIRON", "", 0.0, 020, symtab);
	ENVtab = makesymtab(50);
	cp->sval = (char *) ENVtab;
	for ( ; *envp; envp++) {
		if ((p = strchr(*envp, '=')) == ((void *) 0))
			continue;
		if( p == *envp )
			continue;
		*p++ = 0;
		if (is_number(p))
			setsymtab(*envp, p, atof(p), 02|01, ENVtab);
		else
			setsymtab(*envp, p, 0.0, 02, ENVtab);
		p[-1] = '=';
	}
}

Array *makesymtab(int n)
{
	Array *ap;
	Cell **tp;

	ap = (Array *) malloc(sizeof(Array));
	tp = (Cell **) calloc(n, sizeof(Cell *));
	if (ap == ((void *) 0) || tp == ((void *) 0))
		FATAL("out of space in makesymtab");
	ap->nelem = 0;
	ap->size = n;
	ap->tab = tp;
	return(ap);
}

void freesymtab(Cell *ap)
{
	Cell *cp, *temp;
	Array *tp;
	int i;

	if (!((ap)->tval & 020))
		return;
	tp = (Array *) ap->sval;
	if (tp == ((void *) 0))
		return;
	for (i = 0; i < tp->size; i++) {
		for (cp = tp->tab[i]; cp != ((void *) 0); cp = temp) {
			{ if ((cp->nval) != ((void *) 0)) { free((void *) (cp->nval)); (cp->nval) = ((void *) 0); } };
			if (( ((cp)->tval & (02|04)) == 02 ))
				{ if ((cp->sval) != ((void *) 0)) { free((void *) (cp->sval)); (cp->sval) = ((void *) 0); } };
			temp = cp->cnext;
			free(cp);
			tp->nelem--;
		}
		tp->tab[i] = 0;
	}
	if (tp->nelem != 0)
		WARNING("can't happen: inconsistent element count freeing %s", ap->nval);
	free(tp->tab);
	free(tp);
}

void freeelem(Cell *ap, const char *s)
{
	Array *tp;
	Cell *p, *prev = ((void *) 0);
	int h;

	tp = (Array *) ap->sval;
	h = hash(s, tp->size);
	for (p = tp->tab[h]; p != ((void *) 0); prev = p, p = p->cnext)
		if (strcmp(s, p->nval) == 0) {
			if (prev == ((void *) 0))
				tp->tab[h] = p->cnext;
			else
				prev->cnext = p->cnext;
			if (( ((p)->tval & (02|04)) == 02 ))
				{ if ((p->sval) != ((void *) 0)) { free((void *) (p->sval)); (p->sval) = ((void *) 0); } };
			free(p->nval);
			free(p);
			tp->nelem--;
			return;
		}
}

Cell *setsymtab(const char *n, const char *s, Awkfloat f, unsigned t, Array *tp)
{
	int h;
	Cell *p;

	if (n != ((void *) 0) && (p = lookup(n, tp)) != ((void *) 0)) {
		   
if (dbg) printf ("setsymtab found %p: n=%s s=\"%s\" f=%g t=%o\n", (void*)p, ((p->nval) ? (p->nval) : "(null)"), ((p->sval) ? (p->sval) : "(null)"), p->fval, p->tval);
		return(p);
	}
	p = (Cell *) malloc(sizeof(Cell));
	if (p == ((void *) 0))
		FATAL("out of space for symbol table at %s", n);
	p->nval = tostring(n);
	p->sval = s ? tostring(s) : tostring("");
	p->fval = f;
	p->tval = t;
	p->csub = 0;
	p->ctype = 1;
	tp->nelem++;
	if (tp->nelem > 2 * tp->size)
		rehash(tp);
	h = hash(n, tp->size);
	p->cnext = tp->tab[h];
	tp->tab[h] = p;
	   
if (dbg) printf ("setsymtab set %p: n=%s s=\"%s\" f=%g t=%o\n", (void*)p, p->nval, p->sval, p->fval, p->tval);
	return(p);
}

int hash(const char *s, int n)
{
	unsigned hashval;

	for (hashval = 0; *s != '\0'; s++)
		hashval = (*s + 31 * hashval);
	return hashval % n;
}

void rehash(Array *tp)
{
	int i, nh, nsz;
	Cell *cp, *op, **np;

	nsz = 4 * tp->size;
	np = (Cell **) calloc(nsz, sizeof(Cell *));
	if (np == ((void *) 0))
		return;
	for (i = 0; i < tp->size; i++) {
		for (cp = tp->tab[i]; cp; cp = op) {
			op = cp->cnext;
			nh = hash(cp->nval, nsz);
			cp->cnext = np[nh];
			np[nh] = cp;
		}
	}
	free(tp->tab);
	tp->tab = np;
	tp->size = nsz;
}

Cell *lookup(const char *s, Array *tp)
{
	Cell *p;
	int h;

	h = hash(s, tp->size);
	for (p = tp->tab[h]; p != ((void *) 0); p = p->cnext)
		if (strcmp(s, p->nval) == 0)
			return(p);
	return(((void *) 0));
}

Awkfloat setfval(Cell *vp, Awkfloat f)
{
	int fldno;

	if ((vp->tval & (01 | 02)) == 0)
		funnyvar(vp, "assign to");
	if (((vp)->tval & 0100)) {
		donerec = 0;
		fldno = atoi(vp->nval);
		if (fldno > *NF)
			newfld(fldno);
		   if (dbg) printf ("setting field %d to %g\n", fldno, f);
	} else if (((vp)->tval & 0200)) {
		donefld = 0;
		donerec = 1;
	}
	if (( ((vp)->tval & (02|04)) == 02 ))
		{ if ((vp->sval) != ((void *) 0)) { free((void *) (vp->sval)); (vp->sval) = ((void *) 0); } };
	vp->tval &= ~02;
	vp->tval |= 01;
	if (f == -0)
		f = 0;
	   if (dbg) printf ("setfval %p: %s = %g, t=%o\n", (void*)vp, ((vp->nval) ? (vp->nval) : "(null)"), f, vp->tval);
	return vp->fval = f;
}

void funnyvar(Cell *vp, const char *rw)
{
	if (((vp)->tval & 020))
		FATAL("can't %s %s; it's an array name.", rw, vp->nval);
	if (vp->tval & 040)
		FATAL("can't %s %s; it's a function.", rw, vp->nval);
	WARNING("funny variable %p: n=%s s=\"%s\" f=%g t=%o",
		vp, vp->nval, vp->sval, vp->fval, vp->tval);
}

char *setsval(Cell *vp, const char *s)
{
	char *t;
	int fldno;

	   
if (dbg) printf ("starting setsval %p: %s = \"%s\", t=%o, r,f=%d,%d\n", (void*)vp, ((vp->nval) ? (vp->nval) : "(null)"), s, vp->tval, donerec, donefld);
	if ((vp->tval & (01 | 02)) == 0)
		funnyvar(vp, "assign to");
	if (((vp)->tval & 0100)) {
		donerec = 0;
		fldno = atoi(vp->nval);
		if (fldno > *NF)
			newfld(fldno);
		   if (dbg) printf ("setting field %d to %s (%p)\n", fldno, s, s);
	} else if (((vp)->tval & 0200)) {
		donefld = 0;
		donerec = 1;
	}
	t = tostring(s);
	if (( ((vp)->tval & (02|04)) == 02 ))
		{ if ((vp->sval) != ((void *) 0)) { free((void *) (vp->sval)); (vp->sval) = ((void *) 0); } };
	vp->tval &= ~01;
	vp->tval |= 02;
	vp->tval &= ~04;
	   
if (dbg) printf ("setsval %p: %s = \"%s (%p) \", t=%o r,f=%d,%d\n", (void*)vp, ((vp->nval) ? (vp->nval) : "(null)"), t,t, vp->tval, donerec, donefld);
	return(vp->sval = t);
}

Awkfloat getfval(Cell *vp)
{
	if ((vp->tval & (01 | 02)) == 0)
		funnyvar(vp, "read value of");
	if (((vp)->tval & 0100) && donefld == 0)
		fldbld();
	else if (((vp)->tval & 0200) && donerec == 0)
		recbld();
	if (!((vp)->tval & 01)) {
		vp->fval = atof(vp->sval);
		if (is_number(vp->sval) && !(vp->tval&010))
			vp->tval |= 01;
	}
	   
if (dbg) printf ("getfval %p: %s = %g, t=%o\n", (void*)vp, ((vp->nval) ? (vp->nval) : "(null)"), vp->fval, vp->tval);
	return(vp->fval);
}

static char *get_str_val(Cell *vp, char **fmt)
{
	char s[100];
	double dtemp;

	if ((vp->tval & (01 | 02)) == 0)
		funnyvar(vp, "read value of");
	if (((vp)->tval & 0100) && donefld == 0)
		fldbld();
	else if (((vp)->tval & 0200) && donerec == 0)
		recbld();
	if (((vp)->tval & 02) == 0) {
		if (( ((vp)->tval & (02|04)) == 02 ))
			{ if ((vp->sval) != ((void *) 0)) { free((void *) (vp->sval)); (vp->sval) = ((void *) 0); } };
		if (modf(vp->fval, &dtemp) == 0)
			sprintf(s, "%.30g", vp->fval);
		else
			sprintf(s, *fmt, vp->fval);
		vp->sval = tostring(s);
		vp->tval &= ~04;
		vp->tval |= 02;
	}
	   
if (dbg) printf ("getsval %p: %s = \"%s (%p)\", t=%o\n", (void*)vp, ((vp->nval) ? (vp->nval) : "(null)"), vp->sval, vp->sval, vp->tval);
	return(vp->sval);
}

char *getsval(Cell *vp)
{
      return get_str_val(vp, CONVFMT);
}

char *getpssval(Cell *vp)
{
      return get_str_val(vp, OFMT);
}


char *tostring(const char *s)
{
	char *p;

	p = (char *) malloc(strlen(s)+1);
	if (p == ((void *) 0))
		FATAL("out of space in tostring on %s", s);
	strcpy(p, s);
	return(p);
}

char *qstring(const char *is, int delim)
{
	const char *os = is;
	int c, n;
	uschar *s = (uschar *) is;
	uschar *buf, *bp;

	if ((buf = (uschar *) malloc(strlen(is)+3)) == ((void *) 0))
		FATAL( "out of space in qstring(%s)", s);
	for (bp = buf; (c = *s) != delim; s++) {
		if (c == '\n')
			SYNTAX( "newline in string %.20s...", os );
		else if (c != '\\')
			*bp++ = c;
		else {
			c = *++s;
			if (c == 0) {
				*bp++ = '\\';
				break;
			}
			switch (c) {
			case '\\':	*bp++ = '\\'; break;
			case 'n':	*bp++ = '\n'; break;
			case 't':	*bp++ = '\t'; break;
			case 'b':	*bp++ = '\b'; break;
			case 'f':	*bp++ = '\f'; break;
			case 'r':	*bp++ = '\r'; break;
			default:
				if (!((__ctype+1)[c]&0x04)) {
					*bp++ = c;
					break;
				}
				n = c - '0';
				if (((__ctype+1)[s[1]]&0x04)) {
					n = 8 * n + *++s - '0';
					if (((__ctype+1)[s[1]]&0x04))
						n = 8 * n + *++s - '0';
				}
				*bp++ = n;
				break;
			}
		}
	}
	*bp++ = 0;
	return (char *) buf;
}
