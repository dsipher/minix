# 1 "lib.c"

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
# 39 "/home/charles/xcc/ux64/include/errno.h"
extern int errno;
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
# 45 "/home/charles/xcc/ux64/include/stdarg.h"
typedef __va_list va_list;
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
# 41 "lib.c"
FILE	*infile	= ((void *) 0);
char	*file	= "";
char	*record;
int	recsize	= (8 * 1024);
char	*fields;
int	fieldssize = (8 * 1024);

Cell	**fldtab;
char	inputFS[100] = " ";


int	nfields	= 2;

int	donefld;
int	donerec;

int	lastfld	= 0;
int	argno	= 1;
extern	Awkfloat *ARGC;

static Cell dollar0 = { 1, 1, ((void *) 0), "", 0.0, 0200|02|04 };
static Cell dollar1 = { 1, 1, ((void *) 0), "", 0.0, 0100|02|04 };

void recinit(unsigned int n)
{
	if ( (record = (char *) malloc(n)) == ((void *) 0)
	  || (fields = (char *) malloc(n+1)) == ((void *) 0)
	  || (fldtab = (Cell **) malloc((nfields+1) * sizeof(Cell *))) == ((void *) 0)
	  || (fldtab[0] = (Cell *) malloc(sizeof(Cell))) == ((void *) 0) )
		FATAL("out of space for $0 and fields");
	*fldtab[0] = dollar0;
	fldtab[0]->sval = record;
	fldtab[0]->nval = tostring("0");
	makefields(1, nfields);
}

void makefields(int n1, int n2)
{
	char temp[50];
	int i;

	for (i = n1; i <= n2; i++) {
		fldtab[i] = (Cell *) malloc(sizeof (struct Cell));
		if (fldtab[i] == ((void *) 0))
			FATAL("out of space in makefields %d", i);
		*fldtab[i] = dollar1;
		sprintf(temp, "%d", i);
		fldtab[i]->nval = tostring(temp);
	}
}

void initgetrec(void)
{
	int i;
	char *p;

	for (i = 1; i < *ARGC; i++) {
		p = getargv(i);
		if (p == ((void *) 0) || *p == '\0') {
			argno++;
			continue;
		}
		if (!isclvar(p)) {
			setsval(lookup("FILENAME", symtab), p);
			return;
		}
		setclvar(p);
		argno++;
	}
	infile = (&__stdin);
}

static int firsttime = 1;

int getrec(char **pbuf, int *pbufsize, int isrecord)
{
	int c;
	char *buf = *pbuf;
	uschar saveb0;
	int bufsize = *pbufsize, savebufsize = bufsize;

	if (firsttime) {
		firsttime = 0;
		initgetrec();
	}
	   
if (dbg) printf ("RS=<%s>, FS=<%s>, ARGC=%g, FILENAME=%s\n", *RS, *FS, *ARGC, *FILENAME);
	if (isrecord) {
		donefld = 0;
		donerec = 1;
	}
	saveb0 = buf[0];
	buf[0] = 0;
	while (argno < *ARGC || infile == (&__stdin)) {
		   if (dbg) printf ("argno=%d, file=|%s|\n", argno, file);
		if (infile == ((void *) 0)) {
			file = getargv(argno);
			if (file == ((void *) 0) || *file == '\0') {
				argno++;
				continue;
			}
			if (isclvar(file)) {
				setclvar(file);
				argno++;
				continue;
			}
			*FILENAME = file;
			   if (dbg) printf ("opening file %s\n", file);
			if (*file == '-' && *(file+1) == '\0')
				infile = (&__stdin);
			else if ((infile = fopen(file, "r")) == ((void *) 0))
				FATAL("can't open file %s", file);
			setfval(fnrloc, 0.0);
		}
		c = readrec(&buf, &bufsize, infile);
		if (c != 0 || buf[0] != '\0') {
			if (isrecord) {
				if (( ((fldtab[0])->tval & (02|04)) == 02 ))
					{ if ((fldtab[0]->sval) != ((void *) 0)) { free((void *) (fldtab[0]->sval)); (fldtab[0]->sval) = ((void *) 0); } };
				fldtab[0]->sval = buf;
				fldtab[0]->tval = 0200 | 02 | 04;
				if (is_number(fldtab[0]->sval)) {
					fldtab[0]->fval = atof(fldtab[0]->sval);
					fldtab[0]->tval |= 01;
				}
			}
			setfval(nrloc, nrloc->fval+1);
			setfval(fnrloc, fnrloc->fval+1);
			*pbuf = buf;
			*pbufsize = bufsize;
			return 1;
		}

		if (infile != (&__stdin))
			fclose(infile);
		infile = ((void *) 0);
		argno++;
	}
	buf[0] = saveb0;
	*pbuf = buf;
	*pbufsize = savebufsize;
	return 0;
}

void nextfile(void)
{
	if (infile != ((void *) 0) && infile != (&__stdin))
		fclose(infile);
	infile = ((void *) 0);
	argno++;
}

int readrec(char **pbuf, int *pbufsize, FILE *inf)
{
	int sep, c;
	char *rr, *buf = *pbuf;
	int bufsize = *pbufsize;

	if (strlen(*FS) >= sizeof(inputFS))
		FATAL("field separator %.10s... is too long", *FS);

	strcpy(inputFS, *FS);
	if ((sep = **RS) == 0) {
		sep = '\n';
		while ((c=(--(inf)->_count >= 0 ? (int) (*(inf)->_ptr++) : __fillbuf(inf))) == '\n' && c != (-1))
			;
		if (c != (-1))
			ungetc(c, inf);
	}
	for (rr = buf; ; ) {
		for (; (c=(--(inf)->_count >= 0 ? (int) (*(inf)->_ptr++) : __fillbuf(inf))) != sep && c != (-1); ) {
			if (rr-buf+1 > bufsize)
				if (!adjbuf(&buf, &bufsize, 1+rr-buf, recsize, &rr, "readrec 1"))
					FATAL("input record `%.30s...' too long", buf);
			*rr++ = c;
		}
		if (**RS == sep || c == (-1))
			break;
		if ((c = (--(inf)->_count >= 0 ? (int) (*(inf)->_ptr++) : __fillbuf(inf))) == '\n' || c == (-1))
			break;
		if (!adjbuf(&buf, &bufsize, 2+rr-buf, recsize, &rr, "readrec 2"))
			FATAL("input record `%.30s...' too long", buf);
		*rr++ = '\n';
		*rr++ = c;
	}
	if (!adjbuf(&buf, &bufsize, 1+rr-buf, recsize, &rr, "readrec 3"))
		FATAL("input record `%.30s...' too long", buf);
	*rr = 0;
	   if (dbg) printf ("readrec saw <%s>, returns %d\n", buf, c == (-1) && rr == buf ? 0 : 1);
	*pbuf = buf;
	*pbufsize = bufsize;
	return c == (-1) && rr == buf ? 0 : 1;
}

char *getargv(int n)
{
	Cell *x;
	char *s, temp[50];
	extern Array *ARGVtab;

	sprintf(temp, "%d", n);
	if (lookup(temp, ARGVtab) == ((void *) 0))
		return ((void *) 0);
	x = setsymtab(temp, "", 0.0, 02, ARGVtab);
	s = getsval(x);
	   if (dbg) printf ("getargv(%d) returns |%s|\n", n, s);
	return s;
}

void setclvar(char *s)
{
	char *p;
	Cell *q;

	for (p=s; *p != '='; p++)
		;
	*p++ = 0;
	p = qstring(p, '\0');
	q = setsymtab(s, p, 0.0, 02, symtab);
	setsval(q, p);
	if (is_number(q->sval)) {
		q->fval = atof(q->sval);
		q->tval |= 01;
	}
	   if (dbg) printf ("command line set %s to |%s|\n", s, p);
}


void fldbld(void)
{



	char *r, *fr, sep;
	Cell *p;
	int i, j, n;

	if (donefld)
		return;
	if (!((fldtab[0])->tval & 02))
		getsval(fldtab[0]);
	r = fldtab[0]->sval;
	n = strlen(r);
	if (n > fieldssize) {
		{ if ((fields) != ((void *) 0)) { free((void *) (fields)); (fields) = ((void *) 0); } };
		if ((fields = (char *) malloc(n+2)) == ((void *) 0))
			FATAL("out of space for fields in fldbld %d", n);
		fieldssize = n;
	}
	fr = fields;
	i = 0;
	strcpy(inputFS, *FS);
	if (strlen(inputFS) > 1) {
		i = refldbld(r, inputFS);
	} else if ((sep = *inputFS) == ' ') {
		for (i = 0; ; ) {
			while (*r == ' ' || *r == '\t' || *r == '\n')
				r++;
			if (*r == 0)
				break;
			i++;
			if (i > nfields)
				growfldtab(i);
			if (( ((fldtab[i])->tval & (02|04)) == 02 ))
				{ if ((fldtab[i]->sval) != ((void *) 0)) { free((void *) (fldtab[i]->sval)); (fldtab[i]->sval) = ((void *) 0); } };
			fldtab[i]->sval = fr;
			fldtab[i]->tval = 0100 | 02 | 04;
			do
				*fr++ = *r++;
			while (*r != ' ' && *r != '\t' && *r != '\n' && *r != '\0');
			*fr++ = 0;
		}
		*fr = 0;
	} else if ((sep = *inputFS) == 0) {
		for (i = 0; *r != 0; r++) {
			char buf[2];
			i++;
			if (i > nfields)
				growfldtab(i);
			if (( ((fldtab[i])->tval & (02|04)) == 02 ))
				{ if ((fldtab[i]->sval) != ((void *) 0)) { free((void *) (fldtab[i]->sval)); (fldtab[i]->sval) = ((void *) 0); } };
			buf[0] = *r;
			buf[1] = 0;
			fldtab[i]->sval = tostring(buf);
			fldtab[i]->tval = 0100 | 02;
		}
		*fr = 0;
	} else if (*r != 0) {




		int rtest = '\n';
		if (strlen(*RS) > 0)
			rtest = '\0';
		for (;;) {
			i++;
			if (i > nfields)
				growfldtab(i);
			if (( ((fldtab[i])->tval & (02|04)) == 02 ))
				{ if ((fldtab[i]->sval) != ((void *) 0)) { free((void *) (fldtab[i]->sval)); (fldtab[i]->sval) = ((void *) 0); } };
			fldtab[i]->sval = fr;
			fldtab[i]->tval = 0100 | 02 | 04;
			while (*r != sep && *r != rtest && *r != '\0')
				*fr++ = *r++;
			*fr++ = 0;
			if (*r++ == 0)
				break;
		}
		*fr = 0;
	}
	if (i > nfields)
		FATAL("record `%.30s...' has too many fields; can't happen", r);
	cleanfld(i+1, lastfld);
	lastfld = i;
	donefld = 1;
	for (j = 1; j <= lastfld; j++) {
		p = fldtab[j];
		if(is_number(p->sval)) {
			p->fval = atof(p->sval);
			p->tval |= 01;
		}
	}
	setfval(nfloc, (Awkfloat) lastfld);
	if (dbg) {
		for (j = 0; j <= lastfld; j++) {
			p = fldtab[j];
			printf("field %d (%s): |%s|\n", j, p->nval, p->sval);
		}
	}
}

void cleanfld(int n1, int n2)
{
	Cell *p;
	int i;

	for (i = n1; i <= n2; i++) {
		p = fldtab[i];
		if (( ((p)->tval & (02|04)) == 02 ))
			{ if ((p->sval) != ((void *) 0)) { free((void *) (p->sval)); (p->sval) = ((void *) 0); } };
		p->sval = "";
		p->tval = 0100 | 02 | 04;
	}
}

void newfld(int n)
{
	if (n > nfields)
		growfldtab(n);
	cleanfld(lastfld+1, n);
	lastfld = n;
	setfval(nfloc, (Awkfloat) n);
}

Cell *fieldadr(int n)
{
	if (n < 0)
		FATAL("trying to access out of range field %d", n);
	if (n > nfields)
		growfldtab(n);
	return(fldtab[n]);
}

void growfldtab(int n)
{
	int nf = 2 * nfields;
	size_t s;

	if (n > nf)
		nf = n;
	s = (nf+1) * (sizeof (struct Cell *));
	if (s / sizeof(struct Cell *) - 1 == nf)
		fldtab = (Cell **) realloc(fldtab, s);
	else
		{ if ((fldtab) != ((void *) 0)) { free((void *) (fldtab)); (fldtab) = ((void *) 0); } };
	if (fldtab == ((void *) 0))
		FATAL("out of space creating %d fields", nf);
	makefields(nfields+1, nf);
	nfields = nf;
}

int refldbld(const char *rec, const char *fs)
{


	char *fr;
	int i, tempstat, n;
	fa *pfa;

	n = strlen(rec);
	if (n > fieldssize) {
		{ if ((fields) != ((void *) 0)) { free((void *) (fields)); (fields) = ((void *) 0); } };
		if ((fields = (char *) malloc(n+1)) == ((void *) 0))
			FATAL("out of space for fields in refldbld %d", n);
		fieldssize = n;
	}
	fr = fields;
	*fr = '\0';
	if (*rec == '\0')
		return 0;
	pfa = makedfa(fs, 1);
	   if (dbg) printf ("into refldbld, rec = <%s>, pat = <%s>\n", rec, fs);
	tempstat = pfa->initstat;
	for (i = 1; ; i++) {
		if (i > nfields)
			growfldtab(i);
		if (( ((fldtab[i])->tval & (02|04)) == 02 ))
			{ if ((fldtab[i]->sval) != ((void *) 0)) { free((void *) (fldtab[i]->sval)); (fldtab[i]->sval) = ((void *) 0); } };
		fldtab[i]->tval = 0100 | 02 | 04;
		fldtab[i]->sval = fr;
		   if (dbg) printf ("refldbld: i=%d\n", i);
		if (nematch(pfa, rec)) {
			pfa->initstat = 2;
			   if (dbg) printf ("match %s (%d chars)\n", patbeg, patlen);
			strncpy(fr, rec, patbeg-rec);
			fr += patbeg - rec + 1;
			*(fr-1) = '\0';
			rec = patbeg + patlen;
		} else {
			   if (dbg) printf ("no match %s\n", rec);
			strcpy(fr, rec);
			pfa->initstat = tempstat;
			break;
		}
	}
	return i;
}

void recbld(void)
{
	int i;
	char *r, *p;

	if (donerec == 1)
		return;
	r = record;
	for (i = 1; i <= *NF; i++) {
		p = getsval(fldtab[i]);
		if (!adjbuf(&record, &recsize, 1+strlen(p)+r-record, recsize, &r, "recbld 1"))
			FATAL("created $0 `%.30s...' too long", record);
		while ((*r = *p++) != 0)
			r++;
		if (i < *NF) {
			if (!adjbuf(&record, &recsize, 2+strlen(*OFS)+r-record, recsize, &r, "recbld 2"))
				FATAL("created $0 `%.30s...' too long", record);
			for (p = *OFS; (*r = *p++) != 0; )
				r++;
		}
	}
	if (!adjbuf(&record, &recsize, 2+r-record, recsize, &r, "recbld 3"))
		FATAL("built giant record `%.30s...'", record);
	*r = '\0';
	   if (dbg) printf ("in recbld inputFS=%s, fldtab[0]=%p\n", inputFS, (void*)fldtab[0]);

	if (( ((fldtab[0])->tval & (02|04)) == 02 ))
		{ if ((fldtab[0]->sval) != ((void *) 0)) { free((void *) (fldtab[0]->sval)); (fldtab[0]->sval) = ((void *) 0); } };
	fldtab[0]->tval = 0200 | 02 | 04;
	fldtab[0]->sval = record;

	   if (dbg) printf ("in recbld inputFS=%s, fldtab[0]=%p\n", inputFS, (void*)fldtab[0]);
	   if (dbg) printf ("recbld = |%s|\n", record);
	donerec = 1;
}

int	errorflag	= 0;

void yyerror(const char *s)
{
	SYNTAX("%s", s);
}

void SYNTAX(const char *fmt, ...)
{
	extern char *cmdname, *curfname;
	static int been_here = 0;
	va_list varg;

	if (been_here++ > 2)
		return;
	fprintf((&__stderr), "%s: ", cmdname);
	(varg = (((char *) &(fmt)) + (((sizeof(fmt)) + (8 - 1)) & ~(8 - 1))));
	vfprintf((&__stderr), fmt, varg);
	;
	fprintf((&__stderr), " at source line %d", lineno);
	if (curfname != ((void *) 0))
		fprintf((&__stderr), " in function %s", curfname);
	if (compile_time == 1 && cursource() != ((void *) 0))
		fprintf((&__stderr), " source file %s", cursource());
	fprintf((&__stderr), "\n");
	errorflag = 2;
	eprint();
}

void fpecatch(int n)
{
	FATAL("floating point exception %d", n);
}

extern int bracecnt, brackcnt, parencnt;

void bracecheck(void)
{
	int c;
	static int beenhere = 0;

	if (beenhere++)
		return;
	while ((c = input()) != (-1) && c != '\0')
		bclass(c);
	bcheck2(bracecnt, '{', '}');
	bcheck2(brackcnt, '[', ']');
	bcheck2(parencnt, '(', ')');
}

void bcheck2(int n, int c1, int c2)
{
	if (n == 1)
		fprintf((&__stderr), "\tmissing %c\n", c2);
	else if (n > 1)
		fprintf((&__stderr), "\t%d missing %c's\n", n, c2);
	else if (n == -1)
		fprintf((&__stderr), "\textra %c\n", c2);
	else if (n < -1)
		fprintf((&__stderr), "\t%d extra %c's\n", -n, c2);
}

void FATAL(const char *fmt, ...)
{
	extern char *cmdname;
	va_list varg;

	fflush((&__stdout));
	fprintf((&__stderr), "%s: ", cmdname);
	(varg = (((char *) &(fmt)) + (((sizeof(fmt)) + (8 - 1)) & ~(8 - 1))));
	vfprintf((&__stderr), fmt, varg);
	;
	error();
	if (dbg > 1)
		abort();
	exit(2);
}

void WARNING(const char *fmt, ...)
{
	extern char *cmdname;
	va_list varg;

	fflush((&__stdout));
	fprintf((&__stderr), "%s: ", cmdname);
	(varg = (((char *) &(fmt)) + (((sizeof(fmt)) + (8 - 1)) & ~(8 - 1))));
	vfprintf((&__stderr), fmt, varg);
	;
	error();
}

void error()
{
	extern Node *curnode;

	fprintf((&__stderr), "\n");
	if (compile_time != 2 && NR && *NR > 0) {
		fprintf((&__stderr), " input record number %d", (int) (*FNR));
		if (strcmp(*FILENAME, "-") != 0)
			fprintf((&__stderr), ", file %s", *FILENAME);
		fprintf((&__stderr), "\n");
	}
	if (compile_time != 2 && curnode)
		fprintf((&__stderr), " source line number %d", curnode->lineno);
	else if (compile_time != 2 && lineno)
		fprintf((&__stderr), " source line number %d", lineno);
	if (compile_time == 1 && cursource() != ((void *) 0))
		fprintf((&__stderr), " source file %s", cursource());
	fprintf((&__stderr), "\n");
	eprint();
}

void eprint(void)
{
	char *p, *q;
	int c;
	static int been_here = 0;
	extern char ebuf[], *ep;

	if (compile_time == 2 || compile_time == 0 || been_here++ > 0)
		return;
	p = ep - 1;
	if (p > ebuf && *p == '\n')
		p--;
	for ( ; p > ebuf && *p != '\n' && *p != '\0'; p--)
		;
	while (*p == '\n')
		p++;
	fprintf((&__stderr), " context is\n\t");
	for (q=ep-1; q>=p && *q!=' ' && *q!='\t' && *q!='\n'; q--)
		;
	for ( ; p < q; p++)
		if (*p)
			(--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = (*p)) : __flushbuf((*p),((&__stderr))));
	fprintf((&__stderr), " >>> ");
	for ( ; p < ep; p++)
		if (*p)
			(--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = (*p)) : __flushbuf((*p),((&__stderr))));
	fprintf((&__stderr), " <<< ");
	if (*ep)
		while ((c = input()) != '\n' && c != '\0' && c != (-1)) {
			(--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = (c)) : __flushbuf((c),((&__stderr))));
			bclass(c);
		}
	(--((&__stderr))->_count >= 0 ? (int) (*((&__stderr))->_ptr++ = ('\n')) : __flushbuf(('\n'),((&__stderr))));
	ep = ebuf;
}

void bclass(int c)
{
	switch (c) {
	case '{': bracecnt++; break;
	case '}': bracecnt--; break;
	case '[': brackcnt++; break;
	case ']': brackcnt--; break;
	case '(': parencnt++; break;
	case ')': parencnt--; break;
	}
}

double errcheck(double x, const char *s)
{

	if (errno == 33) {
		errno = 0;
		WARNING("%s argument out of domain", s);
		x = 1;
	} else if (errno == 34) {
		errno = 0;
		WARNING("%s result out of range", s);
		x = 1;
	}
	return x;
}

int isclvar(const char *s)
{
	const char *os = s;

	if (!((__ctype+1)[(uschar) *s]&(0x01|0x02)) && *s != '_')
		return 0;
	for ( ; *s; s++)
		if (!(((__ctype+1)[(uschar) *s]&(0x01|0x02|0x04)) || *s == '_'))
			break;
	return *s == '=' && s > os && *(s+1) != '=';
}
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
# 698 "lib.c"
int is_number(const char *s)
{
	double r;
	char *ep;
	errno = 0;
	r = strtod(s, &ep);
	if (ep == s || r == (__huge_val) || errno == 34)
		return 0;
	while (*ep == ' ' || *ep == '\t' || *ep == '\n')
		ep++;
	if (*ep == '\0')
		return 1;
	else
		return 0;
}
