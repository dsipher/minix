# 1 "proctab.c"

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
# 5 "proctab.c"
static char *printname[93] = {
	(char *) "FIRSTTOKEN",
	(char *) "PROGRAM",
	(char *) "PASTAT",
	(char *) "PASTAT2",
	(char *) "XBEGIN",
	(char *) "XEND",
	(char *) "NL",
	(char *) "ARRAY",
	(char *) "MATCH",
	(char *) "NOTMATCH",
	(char *) "MATCHOP",
	(char *) "FINAL",
	(char *) "DOT",
	(char *) "ALL",
	(char *) "CCL",
	(char *) "NCCL",
	(char *) "CHAR",
	(char *) "OR",
	(char *) "STAR",
	(char *) "QUEST",
	(char *) "PLUS",
	(char *) "EMPTYRE",
	(char *) "AND",
	(char *) "BOR",
	(char *) "APPEND",
	(char *) "EQ",
	(char *) "GE",
	(char *) "GT",
	(char *) "LE",
	(char *) "LT",
	(char *) "NE",
	(char *) "IN",
	(char *) "ARG",
	(char *) "BLTIN",
	(char *) "BREAK",
	(char *) "CLOSE",
	(char *) "CONTINUE",
	(char *) "DELETE",
	(char *) "DO",
	(char *) "EXIT",
	(char *) "FOR",
	(char *) "FUNC",
	(char *) "SUB",
	(char *) "GSUB",
	(char *) "IF",
	(char *) "INDEX",
	(char *) "LSUBSTR",
	(char *) "MATCHFCN",
	(char *) "NEXT",
	(char *) "NEXTFILE",
	(char *) "ADD",
	(char *) "MINUS",
	(char *) "MULT",
	(char *) "DIVIDE",
	(char *) "MOD",
	(char *) "ASSIGN",
	(char *) "ASGNOP",
	(char *) "ADDEQ",
	(char *) "SUBEQ",
	(char *) "MULTEQ",
	(char *) "DIVEQ",
	(char *) "MODEQ",
	(char *) "POWEQ",
	(char *) "PRINT",
	(char *) "PRINTF",
	(char *) "SPRINTF",
	(char *) "ELSE",
	(char *) "INTEST",
	(char *) "CONDEXPR",
	(char *) "POSTINCR",
	(char *) "PREINCR",
	(char *) "POSTDECR",
	(char *) "PREDECR",
	(char *) "VAR",
	(char *) "IVAR",
	(char *) "VARNF",
	(char *) "CALL",
	(char *) "NUMBER",
	(char *) "STRING",
	(char *) "REGEXPR",
	(char *) "GETLINE",
	(char *) "RETURN",
	(char *) "SPLIT",
	(char *) "SUBSTR",
	(char *) "WHILE",
	(char *) "CAT",
	(char *) "NOT",
	(char *) "UMINUS",
	(char *) "POWER",
	(char *) "DECR",
	(char *) "INCR",
	(char *) "INDIRECT",
	(char *) "LASTTOKEN",
};


Cell *(*proctab[93])(Node **, int) = {
	nullproc,
	program,
	pastat,
	dopa2,
	nullproc,
	nullproc,
	nullproc,
	array,
	matchop,
	matchop,
	nullproc,
	nullproc,
	nullproc,
	nullproc,
	nullproc,
	nullproc,
	nullproc,
	nullproc,
	nullproc,
	nullproc,
	nullproc,
	nullproc,
	boolop,
	boolop,
	nullproc,
	relop,
	relop,
	relop,
	relop,
	relop,
	relop,
	instat,
	arg,
	bltin,
	jump,
	closefile,
	jump,
	awkdelete,
	dostat,
	jump,
	forstat,
	nullproc,
	sub,
	gsub,
	ifstat,
	sindex,
	nullproc,
	matchop,
	jump,
	jump,
	arith,
	arith,
	arith,
	arith,
	arith,
	assign,
	nullproc,
	assign,
	assign,
	assign,
	assign,
	assign,
	assign,
	printstat,
	awkprintf,
	awksprintf,
	nullproc,
	intest,
	condexpr,
	incrdecr,
	incrdecr,
	incrdecr,
	incrdecr,
	nullproc,
	nullproc,
	getnf,
	call,
	nullproc,
	nullproc,
	nullproc,
	awkgetline,
	jump,
	split,
	substr,
	whilestat,
	cat,
	boolop,
	arith,
	arith,
	nullproc,
	nullproc,
	indirect,
	nullproc,
};

char *tokname(int n)
{
	static char buf[100];

	if (n < 257 || n > 349) {
		sprintf(buf, "token %d", n);
		return buf;
	}
	return printname[n-257];
}
