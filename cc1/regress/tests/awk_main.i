# 1 "main.c"

# 31 "main.c"
const char	*version = "version 20121220";
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
# 41 "/home/charles/xcc/minix/include/signal.h"
typedef __pid_t pid_t;
















extern int kill(pid_t, int);
extern int raise(int sig);

typedef void(*__sighandler_t)(int);





typedef unsigned long sigset_t;

struct sigaction
{
    __sighandler_t sa_handler;
    unsigned long sa_flags;
    void (*sa_restorer)(void);
    sigset_t sa_mask;
};





extern __sighandler_t signal(int, __sighandler_t);
extern void __sigreturn(void);
extern int __sigaction(int, const struct sigaction *, struct sigaction *);
extern int sigaction(int, const struct sigaction *, struct sigaction *);
extern int sigemptyset(sigset_t *);
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
# 42 "main.c"
extern	char	**environ;
extern	int	nfields;

int	dbg	= 0;
Awkfloat	srand_seed = 1;
char	*cmdname;
extern	FILE	*yyin;
char	*lexprog;
extern	int errorflag;
int	compile_time = 2;




char	*pfile[20];
int	npfile = 0;
int	curpfile = 0;

int	safe	= 0;

int main(int argc, char *argv[])
{
	const char *fs = ((void *) 0);

	cmdname = argv[0];
	if (argc == 1) {
		fprintf((&__stderr),
		  "usage: %s [-F fs] [-v var=value] [-f progfile | 'prog'] [file ...]\n",
		  cmdname);
		exit(1);
	}
	signal(8, fpecatch);

	srand_seed = 1;
	srand(srand_seed);

	yyin = ((void *) 0);
	symtab = makesymtab(50/50);
	while (argc > 1 && argv[1][0] == '-' && argv[1][1] != '\0') {
		if (strcmp(argv[1],"-version") == 0 || strcmp(argv[1],"--version") == 0) {
			printf("awk %s\n", version);
			exit(0);
			break;
		}
		if (strncmp(argv[1], "--", 2) == 0) {
			argc--;
			argv++;
			break;
		}
		switch (argv[1][1]) {
		case 's':
			if (strcmp(argv[1], "-safe") == 0)
				safe = 1;
			break;
		case 'f':
			if (argv[1][2] != 0) {
				if (npfile >= 20 - 1)
					FATAL("too many -f options");
				pfile[npfile++] = &argv[1][2];
			} else {
				argc--; argv++;
				if (argc <= 1)
					FATAL("no program filename");
				if (npfile >= 20 - 1)
					FATAL("too many -f options");
				pfile[npfile++] = argv[1];
			}
			break;
		case 'F':
			if (argv[1][2] != 0) {
				if (argv[1][2] == 't' && argv[1][3] == 0)
					fs = "\t";
				else if (argv[1][2] != 0)
					fs = &argv[1][2];
			} else {
				argc--; argv++;
				if (argc > 1 && argv[1][0] == 't' && argv[1][1] == 0)
					fs = "\t";
				else if (argc > 1 && argv[1][0] != 0)
					fs = &argv[1][0];
			}
			if (fs == ((void *) 0) || *fs == '\0')
				WARNING("field separator FS is empty");
			break;
		case 'v':
			if (argv[1][2] != 0) {
				if (isclvar(&argv[1][2]))
					setclvar(&argv[1][2]);
				else
					FATAL("invalid -v option argument: %s", &argv[1][2]);
			} else {
				argc--; argv++;
				if (argc <= 1)
					FATAL("no variable name");
				if (isclvar(argv[1]))
					setclvar(argv[1]);
				else
					FATAL("invalid -v option argument: %s", argv[1]);
			}
			break;
		case 'd':
			dbg = atoi(&argv[1][2]);
			if (dbg == 0)
				dbg = 1;
			printf("awk %s\n", version);
			break;
		default:
			WARNING("unknown option %s ignored", argv[1]);
			break;
		}
		argc--;
		argv++;
	}

	if (npfile == 0) {
		if (argc <= 1) {
			if (dbg)
				exit(0);
			FATAL("no program given");
		}
		   if (dbg) printf ("program = |%s|\n", argv[1]);
		lexprog = argv[1];
		argc--;
		argv++;
	}
	recinit(recsize);
	syminit();
	compile_time = 1;
	argv[0] = cmdname;
	   if (dbg) printf ("argc=%d, argv[0]=%s\n", argc, argv[0]);
	arginit(argc, argv);
	if (!safe)
		envinit(environ);
	yyparse();
	if (fs)
		*FS = qstring(fs, '\0');
	   if (dbg) printf ("errorflag=%d\n", errorflag);
	if (errorflag == 0) {
		compile_time = 0;
		run(winner);
	} else
		bracecheck();
	return(errorflag);
}

int pgetc(void)
{
	int c;

	for (;;) {
		if (yyin == ((void *) 0)) {
			if (curpfile >= npfile)
				return (-1);
			if (strcmp(pfile[curpfile], "-") == 0)
				yyin = (&__stdin);
			else if ((yyin = fopen(pfile[curpfile], "r")) == ((void *) 0))
				FATAL("can't open file %s", pfile[curpfile]);
			lineno = 1;
		}
		if ((c = (--(yyin)->_count >= 0 ? (int) (*(yyin)->_ptr++) : __fillbuf(yyin))) != (-1))
			return c;
		if (yyin != (&__stdin))
			fclose(yyin);
		yyin = ((void *) 0);
		curpfile++;
	}
}

char *cursource(void)
{
	if (npfile > 0)
		return pfile[curpfile];
	else
		return ((void *) 0);
}
