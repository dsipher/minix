# 1 "lex.c"

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
# 38 "lex.c"
extern YYSTYPE	yylval;
extern int	infunc;

int	lineno	= 1;
int	bracecnt = 0;
int	brackcnt  = 0;
int	parencnt = 0;

typedef struct Keyword {
	const char *word;
	int	sub;
	int	type;
} Keyword;

Keyword keywords[] ={
	{ "BEGIN",	261,		261 },
	{ "END",	262,		262 },
	{ "NF",		332,		332 },
	{ "atan2",	11,		290 },
	{ "break",	291,		291 },
	{ "close",	292,		292 },
	{ "continue",	293,	293 },
	{ "cos",	10,		290 },
	{ "delete",	294,		294 },
	{ "do",		295,		295 },
	{ "else",	323,		323 },
	{ "exit",	296,		296 },
	{ "exp",	3,		290 },
	{ "fflush",	14,		290 },
	{ "for",	297,		297 },
	{ "func",	298,		298 },
	{ "function",	298,		298 },
	{ "getline",	337,	337 },
	{ "gsub",	300,		300 },
	{ "if",		301,		301 },
	{ "in",		288,		288 },
	{ "index",	302,		302 },
	{ "int",	5,		290 },
	{ "length",	1,	290 },
	{ "log",	4,		290 },
	{ "match",	304,	304 },
	{ "next",	305,		305 },
	{ "nextfile",	306,	306 },
	{ "print",	320,		320 },
	{ "printf",	321,		321 },
	{ "rand",	7,		290 },
	{ "return",	338,		338 },
	{ "sin",	9,		290 },
	{ "split",	339,		339 },
	{ "sprintf",	322,	322 },
	{ "sqrt",	2,		290 },
	{ "srand",	8,		290 },
	{ "sub",	299,		299 },
	{ "substr",	340,		340 },
	{ "system",	6,	290 },
	{ "tolower",	13,	290 },
	{ "toupper",	12,	290 },
	{ "while",	341,		341 },
};



int peek(void)
{
	int c = input();
	unput(c);
	return c;
}

int gettok(char **pbuf, int *psz)
{
	int c, retc;
	char *buf = *pbuf;
	int sz = *psz;
	char *bp = buf;

	c = input();
	if (c == 0)
		return 0;
	buf[0] = c;
	buf[1] = 0;
	if (!((__ctype+1)[c]&(0x01|0x02|0x04)) && c != '.' && c != '_')
		return c;

	*bp++ = c;
	if (((__ctype+1)[c]&(0x01|0x02)) || c == '_') {
		for ( ; (c = input()) != 0; ) {
			if (bp-buf >= sz)
				if (!adjbuf(&buf, &sz, bp-buf+2, 100, &bp, "gettok"))
					FATAL( "out of space for name %.10s...", buf );
			if (((__ctype+1)[c]&(0x01|0x02|0x04)) || c == '_')
				*bp++ = c;
			else {
				*bp = 0;
				unput(c);
				break;
			}
		}
		*bp = 0;
		retc = 'a';
	} else {
		char *rem;

		for ( ; (c = input()) != 0; ) {
			if (bp-buf >= sz)
				if (!adjbuf(&buf, &sz, bp-buf+2, 100, &bp, "gettok"))
					FATAL( "out of space for number %.10s...", buf );
			if (((__ctype+1)[c]&0x04) || c == 'e' || c == 'E'
			  || c == '.' || c == '+' || c == '-')
				*bp++ = c;
			else {
				unput(c);
				break;
			}
		}
		*bp = 0;
		strtod(buf, &rem);
		if (rem == buf) {
			buf[1] = 0;
			retc = buf[0];
			unputstr(rem+1);
		} else {
			unputstr(rem);
			rem[0] = 0;
			retc = '0';
		}
	}
	*pbuf = buf;
	*psz = sz;
	return retc;
}

int	word(char *);
int	string(void);
int	regexpr(void);
int	sc	= 0;
int	reg	= 0;

int yylex(void)
{
	int c;
	static char *buf = 0;
	static int bufsize = 5;

	if (buf == 0 && (buf = (char *) malloc(bufsize)) == ((void *) 0))
		FATAL( "out of space in yylex" );
	if (sc) {
		sc = 0;
		{ if(dbg)printf("lex %s\n", tokname('}')); return('}'); };
	}
	if (reg) {
		reg = 0;
		return regexpr();
	}
	for (;;) {
		c = gettok(&buf, &bufsize);
		if (c == 0)
			return 0;
		if (((__ctype+1)[c]&(0x01|0x02)) || c == '_')
			return word(buf);
		if (((__ctype+1)[c]&0x04)) {
			yylval.cp = setsymtab(buf, tostring(buf), atof(buf), 010|01, symtab);

			{ if(dbg)printf("lex %s\n", tokname(334)); return(334); };
		}

		yylval.i = c;
		switch (c) {
		case '\n':
			{ if(dbg)printf("lex %s\n", tokname(263)); return(263); };
		case '\r':
		case ' ':
		case '\t':
			break;
		case '#':
			while ((c = input()) != '\n' && c != 0)
				;
			unput(c);
			break;
		case ';':
			{ if(dbg)printf("lex %s\n", tokname(';')); return(';'); };
		case '\\':
			if (peek() == '\n') {
				input();
			} else if (peek() == '\r') {
				input(); input();
				lineno++;
			} else {
				{ if(dbg)printf("lex %s\n", tokname(c)); return(c); };
			}
			break;
		case '&':
			if (peek() == '&') {
				input(); { if(dbg)printf("lex %s\n", tokname(279)); return(279); };
			} else
				{ if(dbg)printf("lex %s\n", tokname('&')); return('&'); };
		case '|':
			if (peek() == '|') {
				input(); { if(dbg)printf("lex %s\n", tokname(280)); return(280); };
			} else
				{ if(dbg)printf("lex %s\n", tokname('|')); return('|'); };
		case '!':
			if (peek() == '=') {
				input(); yylval.i = 287; { if(dbg)printf("lex %s\n", tokname(287)); return(287); };
			} else if (peek() == '~') {
				input(); yylval.i = 266; { if(dbg)printf("lex %s\n", tokname(267)); return(267); };
			} else
				{ if(dbg)printf("lex %s\n", tokname(343)); return(343); };
		case '~':
			yylval.i = 265;
			{ if(dbg)printf("lex %s\n", tokname(267)); return(267); };
		case '<':
			if (peek() == '=') {
				input(); yylval.i = 285; { if(dbg)printf("lex %s\n", tokname(285)); return(285); };
			} else {
				yylval.i = 286; { if(dbg)printf("lex %s\n", tokname(286)); return(286); };
			}
		case '=':
			if (peek() == '=') {
				input(); yylval.i = 282; { if(dbg)printf("lex %s\n", tokname(282)); return(282); };
			} else {
				yylval.i = 312; { if(dbg)printf("lex %s\n", tokname(313)); return(313); };
			}
		case '>':
			if (peek() == '=') {
				input(); yylval.i = 283; { if(dbg)printf("lex %s\n", tokname(283)); return(283); };
			} else if (peek() == '>') {
				input(); yylval.i = 281; { if(dbg)printf("lex %s\n", tokname(281)); return(281); };
			} else {
				yylval.i = 284; { if(dbg)printf("lex %s\n", tokname(284)); return(284); };
			}
		case '+':
			if (peek() == '+') {
				input(); yylval.i = 347; { if(dbg)printf("lex %s\n", tokname(347)); return(347); };
			} else if (peek() == '=') {
				input(); yylval.i = 314; { if(dbg)printf("lex %s\n", tokname(313)); return(313); };
			} else
				{ if(dbg)printf("lex %s\n", tokname('+')); return('+'); };
		case '-':
			if (peek() == '-') {
				input(); yylval.i = 346; { if(dbg)printf("lex %s\n", tokname(346)); return(346); };
			} else if (peek() == '=') {
				input(); yylval.i = 315; { if(dbg)printf("lex %s\n", tokname(313)); return(313); };
			} else
				{ if(dbg)printf("lex %s\n", tokname('-')); return('-'); };
		case '*':
			if (peek() == '=') {
				input(); yylval.i = 316; { if(dbg)printf("lex %s\n", tokname(313)); return(313); };
			} else if (peek() == '*') {
				input();
				if (peek() == '=') {
					input(); yylval.i = 319; { if(dbg)printf("lex %s\n", tokname(313)); return(313); };
				} else {
					{ if(dbg)printf("lex %s\n", tokname(345)); return(345); };
				}
			} else
				{ if(dbg)printf("lex %s\n", tokname('*')); return('*'); };
		case '/':
			{ if(dbg)printf("lex %s\n", tokname('/')); return('/'); };
		case '%':
			if (peek() == '=') {
				input(); yylval.i = 318; { if(dbg)printf("lex %s\n", tokname(313)); return(313); };
			} else
				{ if(dbg)printf("lex %s\n", tokname('%')); return('%'); };
		case '^':
			if (peek() == '=') {
				input(); yylval.i = 319; { if(dbg)printf("lex %s\n", tokname(313)); return(313); };
			} else
				{ if(dbg)printf("lex %s\n", tokname(345)); return(345); };

		case '$':

			c = gettok(&buf, &bufsize);
			if (((__ctype+1)[c]&(0x01|0x02))) {
				if (strcmp(buf, "NF") == 0) {
					unputstr("(NF)");
					{ if(dbg)printf("lex %s\n", tokname(348)); return(348); };
				}
				c = peek();
				if (c == '(' || c == '[' || (infunc && isarg(buf) >= 0)) {
					unputstr(buf);
					{ if(dbg)printf("lex %s\n", tokname(348)); return(348); };
				}
				yylval.cp = setsymtab(buf, "", 0.0, 02|01, symtab);
				{ if(dbg)printf("lex %s\n", tokname(331)); return(331); };
			} else if (c == 0) {
				SYNTAX( "unexpected end of input after $" );
				{ if(dbg)printf("lex %s\n", tokname(';')); return(';'); };
			} else {
				unputstr(buf);
				{ if(dbg)printf("lex %s\n", tokname(348)); return(348); };
			}

		case '}':
			if (--bracecnt < 0)
				SYNTAX( "extra }" );
			sc = 1;
			{ if(dbg)printf("lex %s\n", tokname(';')); return(';'); };
		case ']':
			if (--brackcnt < 0)
				SYNTAX( "extra ]" );
			{ if(dbg)printf("lex %s\n", tokname(']')); return(']'); };
		case ')':
			if (--parencnt < 0)
				SYNTAX( "extra )" );
			{ if(dbg)printf("lex %s\n", tokname(')')); return(')'); };
		case '{':
			bracecnt++;
			{ if(dbg)printf("lex %s\n", tokname('{')); return('{'); };
		case '[':
			brackcnt++;
			{ if(dbg)printf("lex %s\n", tokname('[')); return('['); };
		case '(':
			parencnt++;
			{ if(dbg)printf("lex %s\n", tokname('(')); return('('); };

		case '"':
			return string();

		default:
			{ if(dbg)printf("lex %s\n", tokname(c)); return(c); };
		}
	}
}

int string(void)
{
	int c, n;
	char *s, *bp;
	static char *buf = 0;
	static int bufsz = 500;

	if (buf == 0 && (buf = (char *) malloc(bufsz)) == ((void *) 0))
		FATAL("out of space for strings");
	for (bp = buf; (c = input()) != '"'; ) {
		if (!adjbuf(&buf, &bufsz, bp-buf+2, 500, &bp, "string"))
			FATAL("out of space for string %.10s...", buf);
		switch (c) {
		case '\n':
		case '\r':
		case 0:
			SYNTAX( "non-terminated string %.10s...", buf );
			lineno++;
			if (c == 0)
				FATAL( "giving up" );
			break;
		case '\\':
			c = input();
			switch (c) {
			case '"': *bp++ = '"'; break;
			case 'n': *bp++ = '\n'; break;
			case 't': *bp++ = '\t'; break;
			case 'f': *bp++ = '\f'; break;
			case 'r': *bp++ = '\r'; break;
			case 'b': *bp++ = '\b'; break;
			case 'v': *bp++ = '\v'; break;
			case 'a': *bp++ = '\007'; break;
			case '\\': *bp++ = '\\'; break;

			case '0': case '1': case '2':
			case '3': case '4': case '5': case '6': case '7':
				n = c - '0';
				if ((c = peek()) >= '0' && c < '8') {
					n = 8 * n + input() - '0';
					if ((c = peek()) >= '0' && c < '8')
						n = 8 * n + input() - '0';
				}
				*bp++ = n;
				break;

			case 'x':
			    {	char xbuf[100], *px;
				for (px = xbuf; (c = input()) != 0 && px-xbuf < 100-2; ) {
					if (((__ctype+1)[c]&0x04)
					 || (c >= 'a' && c <= 'f')
					 || (c >= 'A' && c <= 'F'))
						*px++ = c;
					else
						break;
				}
				*px = 0;
				unput(c);
	  			sscanf(xbuf, "%x", (unsigned int *) &n);
				*bp++ = n;
				break;
			    }

			default:
				*bp++ = c;
				break;
			}
			break;
		default:
			*bp++ = c;
			break;
		}
	}
	*bp = 0;
	s = tostring(buf);
	*bp++ = ' '; *bp++ = 0;
	yylval.cp = setsymtab(buf, s, 0.0, 010|02|04, symtab);
	{ if(dbg)printf("lex %s\n", tokname(335)); return(335); };
}


int binsearch(char *w, Keyword *kp, int n)
{
	int cond, low, mid, high;

	low = 0;
	high = n - 1;
	while (low <= high) {
		mid = (low + high) / 2;
		if ((cond = strcmp(w, kp[mid].word)) < 0)
			high = mid - 1;
		else if (cond > 0)
			low = mid + 1;
		else
			return mid;
	}
	return -1;
}

int word(char *w)
{
	Keyword *kp;
	int c, n;

	n = binsearch(w, keywords, sizeof(keywords)/sizeof(keywords[0]));

	kp = keywords + n;
	if (n != -1) {
		yylval.i = kp->sub;
		switch (kp->type) {
		case 290:
			if (kp->sub == 6 && safe)
				SYNTAX( "system is unsafe" );
			{ if(dbg)printf("lex %s\n", tokname(kp->type)); return(kp->type); };
		case 298:
			if (infunc)
				SYNTAX( "illegal nested function" );
			{ if(dbg)printf("lex %s\n", tokname(kp->type)); return(kp->type); };
		case 338:
			if (!infunc)
				SYNTAX( "return not in function" );
			{ if(dbg)printf("lex %s\n", tokname(kp->type)); return(kp->type); };
		case 332:
			yylval.cp = setsymtab("NF", "", 0.0, 01, symtab);
			{ if(dbg)printf("lex %s\n", tokname(332)); return(332); };
		default:
			{ if(dbg)printf("lex %s\n", tokname(kp->type)); return(kp->type); };
		}
	}
	c = peek();
	if (c != '(' && infunc && (n=isarg(w)) >= 0) {
		yylval.i = n;
		{ if(dbg)printf("lex %s\n", tokname(289)); return(289); };
	} else {
		yylval.cp = setsymtab(w, "", 0.0, 02|01|04, symtab);
		if (c == '(') {
			{ if(dbg)printf("lex %s\n", tokname(333)); return(333); };
		} else {
			{ if(dbg)printf("lex %s\n", tokname(330)); return(330); };
		}
	}
}

void startreg(void)
{
	reg = 1;
}

int regexpr(void)
{
	int c;
	static char *buf = 0;
	static int bufsz = 500;
	char *bp;

	if (buf == 0 && (buf = (char *) malloc(bufsz)) == ((void *) 0))
		FATAL("out of space for rex expr");
	bp = buf;
	for ( ; (c = input()) != '/' && c != 0; ) {
		if (!adjbuf(&buf, &bufsz, bp-buf+3, 500, &bp, "regexpr"))
			FATAL("out of space for reg expr %.10s...", buf);
		if (c == '\n') {
			SYNTAX( "newline in regular expression %.10s...", buf );
			unput('\n');
			break;
		} else if (c == '\\') {
			*bp++ = '\\';
			*bp++ = input();
		} else {
			*bp++ = c;
		}
	}
	*bp = 0;
	if (c == 0)
		SYNTAX("non-terminated regular expression %.10s...", buf);
	yylval.s = tostring(buf);
	unput('/');
	{ if(dbg)printf("lex %s\n", tokname(336)); return(336); };
}



char	ebuf[300];
char	*ep = ebuf;
char	yysbuf[100];
char	*yysptr = yysbuf;
FILE	*yyin = 0;

int input(void)
{
	int c;
	extern char *lexprog;

	if (yysptr > yysbuf)
		c = (uschar)*--yysptr;
	else if (lexprog != ((void *) 0)) {
		if ((c = (uschar)*lexprog) != 0)
			lexprog++;
	} else
		c = pgetc();
	if (c == '\n')
		lineno++;
	else if (c == (-1))
		c = 0;
	if (ep >= ebuf + sizeof ebuf)
		ep = ebuf;
	return *ep++ = c;
}

void unput(int c)
{
	if (c == '\n')
		lineno--;
	if (yysptr >= yysbuf + sizeof(yysbuf))
		FATAL("pushed back too much: %.20s...", yysbuf);
	*yysptr++ = c;
	if (--ep < ebuf)
		ep = ebuf + sizeof(ebuf) - 1;
}

void unputstr(const char *s)
{
	int i;

	for (i = strlen(s)-1; i >= 0; i--)
		unput(s[i]);
}
