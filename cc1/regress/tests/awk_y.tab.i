# 1 "y.tab.c"

static char yysccsid[] = "@(#)yaccpar	1.9 (Berkeley) 02/21/93";
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
# 36 "awkgram.y"
void checkdup(Node *list, Cell *item);
int yywrap(void) { return(1); }

Node	*beginloc = 0;
Node	*endloc = 0;
int	infunc	= 0;
int	inloop	= 0;
char	*curfname = 0;
Node	*arglist = 0;
# 47 "awkgram.y"
typedef union {
	Node	*p;
	Cell	*cp;
	int	i;
	char	*s;
} YYSTYPE;
# 127 "y.tab.c"
short yylhs[] = {                                        -1,
    0,    0,   36,   36,   37,   37,   33,   33,   26,   26,
   24,   24,   40,   22,   41,   22,   42,   22,   20,   20,
   23,   30,   30,   34,   34,   35,   35,   29,   29,   15,
   15,    1,    1,   10,   11,   11,   11,   11,   11,   11,
   11,   43,   11,   12,   12,    6,    6,    3,    3,    3,
    3,    3,    3,    3,    3,    3,    3,    3,    2,    2,
    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
    2,    2,    2,    2,    2,    2,    2,    4,    4,    5,
    5,    7,    7,    7,   39,   39,   28,   28,   28,   28,
   31,   31,    9,    9,   44,   13,   32,   32,   14,   14,
   14,   14,   14,   14,   14,   14,   27,   27,   16,   16,
   45,   46,   16,   16,   16,   16,   16,   16,   16,   16,
   16,   16,   16,   16,   47,   16,   16,   17,   17,   38,
   38,    8,    8,    8,    8,    8,    8,    8,    8,    8,
    8,    8,    8,    8,    8,    8,    8,    8,    8,    8,
    8,    8,    8,    8,    8,    8,    8,    8,    8,    8,
    8,    8,    8,    8,    8,    8,    8,    8,    8,    8,
    8,    8,    8,   18,   18,   18,   18,   21,   21,   21,
   19,   19,   19,   25,
};
short yylen[] = {                                         2,
    1,    1,    1,    2,    1,    2,    1,    2,    1,    2,
    1,    2,    0,   12,    0,   10,    0,    8,    1,    1,
    4,    1,    2,    1,    2,    0,    1,    0,    1,    0,
    1,    1,    3,    1,    1,    4,    4,    7,    3,    4,
    4,    0,    9,    1,    3,    1,    3,    3,    5,    3,
    3,    3,    3,    3,    5,    2,    1,    1,    3,    5,
    3,    3,    3,    3,    3,    3,    3,    3,    3,    3,
    3,    5,    4,    3,    2,    1,    1,    3,    3,    1,
    3,    0,    1,    3,    1,    1,    1,    1,    2,    2,
    1,    2,    1,    2,    0,    4,    1,    2,    4,    4,
    4,    2,    5,    2,    1,    1,    1,    2,    2,    2,
    0,    0,    9,    3,    2,    1,    4,    2,    3,    2,
    2,    3,    2,    2,    0,    3,    2,    1,    2,    1,
    1,    4,    3,    3,    3,    3,    3,    3,    2,    2,
    2,    3,    4,    1,    3,    4,    2,    2,    2,    2,
    2,    4,    3,    2,    1,    6,    6,    3,    6,    6,
    1,    8,    8,    6,    4,    1,    6,    6,    8,    8,
    8,    6,    1,    1,    4,    1,    2,    0,    1,    3,
    1,    1,    1,    4,
};
short yydefred[] = {                                      0,
    2,   87,   88,    0,    1,    0,    0,   89,   90,    0,
    0,   22,    0,   95,  182,    0,    0,    0,  130,  131,
    0,    0,    0,  181,  176,  183,    0,  161,  166,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   76,    0,   44,    0,   93,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   19,
   20,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   94,  148,  149,  177,    0,    0,    3,
    5,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  150,  151,    0,  106,   23,    0,    0,    0,
    0,    9,    0,    0,    0,    0,    0,   85,   86,    0,
    0,    0,    0,  128,    0,  116,    0,  125,    0,    0,
    0,    0,    0,    0,    7,  158,    0,    0,    0,    0,
  142,    0,    0,    0,    0,    0,    0,    0,  145,    0,
    0,    0,    0,    0,    0,    0,   69,    0,    0,    0,
    0,    0,    0,   71,    0,    4,    0,    6,    0,    0,
    0,    0,    0,    0,    0,    0,   24,    0,    0,    0,
   45,    0,    0,  127,    0,  109,    0,  110,    0,    0,
  115,    0,    0,  120,  121,    0,  123,    0,  124,   39,
  129,    0,    0,   10,    0,    0,    0,    0,    0,    0,
    0,   57,    0,    0,    0,   40,   41,    8,    0,    0,
    0,   96,  143,    0,  179,    0,    0,    0,  165,  146,
    0,    0,    0,   73,    0,    0,   25,    0,   36,  175,
  108,    0,  114,   31,    0,    0,    0,  122,    0,   11,
    0,  126,  112,   91,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   72,
    0,   97,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   12,  117,    0,
   92,    0,    0,    0,   52,   54,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   98,    0,  180,  156,
  157,  160,  159,  164,    0,  172,    0,    0,  103,    0,
    0,    0,    0,    0,    0,    0,  168,    0,  167,    0,
    0,    0,    0,    0,   38,    0,    0,    0,    0,   55,
    0,    0,    0,    0,    0,  162,  163,  171,    0,    0,
    0,    0,  170,  169,   43,    0,    0,   18,    0,    0,
    0,  113,   16,    0,    0,   14,
};
short yydgoto[] = {                                       4,
    5,  122,  208,   53,  209,  143,  210,   40,   41,   42,
   43,   44,   45,  123,  245,  124,  125,   46,   47,   62,
  226,  126,  127,  251,  128,  129,  186,    6,    7,  130,
  255,  273,  224,  187,  179,   91,   92,   49,  131,  365,
  360,  351,  308,   54,  205,  290,  203,
};
short yysindex[] = {                                    -55,
    0,    0,    0,    0,    0,  -56, 8066,    0,    0,  -69,
  -69,    0, 8879,    0,    0,   26, 9209, -216,    0,    0,
   32,   37,   39,    0,    0,    0,   41,    0,    0, -203,
   47,   51, 9209, 9209, 8898,  108,  108, 9209, 7629,  -37,
    0,   -4,    0,  -48,    0, -178,   11, 4734,   73, 4734,
 4734, 6232,  115, -218, 8298, 8879, 9209,  -37, -276,    0,
    0,   98, 8879, 8879, 8879, 8377, 9209, -121, 8879, 8879,
 -199, -199, -199,    0,    0,    0,    0, -171, 8879,    0,
    0, 8879, 8879, 8879, 8879, 8879, 8879, -252, 8879,  -37,
 8465, 8568, 8958, 9209, 9209, 9209, 9209, 9209,  -89, 4734,
 8066, 8879,    0,    0, 8879,    0,    0,  -89,  -29,  -29,
 -252,    0, 8246,  141,  159,  -29,  -29,    0,    0, 8246,
  171, 7629,  -29,    0, 4797,    0, 5655,    0,  -70, 4734,
 9038, 8879, 4857, 5001,    0,    0, 8628,  -72, 8628,  175,
    0, 7629,  120, 6735,  -82, 6841, 6841,  132,    0,  146,
  -37, 9209, 6841, 6841,  108, 2208,    0, 2208, 2208, 2208,
 2208, 2208, 2208,    0, 6916,    0, 7976,    0, 1353, 9209,
 -199,  -35,  -35, -199, -199, -199,    0,   -9, 8879, 5124,
    0, 7629,   18,    0,  -89,    0,   -9,    0,  186, 6425,
    0, 8152, 8879,    0,    0, 6425,    0, 8879,    0,    0,
    0,  -73, 5655,    0, 5655, 5185, 8879, 8227,  222, -109,
  -37,    0,  -34, 6841,  222,    0,    0,    0, 7629, -252,
 7629,    0,    0, 8628,    0,  153, 8628, 8628,    0,    0,
  -37,   54, 8628,    0, 8879,  -37,    0,  -69,    0,    0,
    0, 8879,    0,    0,  235,  -71, 7008,    0, 7008,    0,
 5271,    0,    0,    0,   33,  177, 9108, -252, 9108,  -37,
 8647, 8728, 8780, 9209, 9209, 9209, 9108, 8628, 8628,    0,
 7629,    0,   35, -242, 7106,  261, 7181,  268,  192, 6507,
 7629, 4734,   65,    2, -252,   35,   35,    0,    0,  -30,
    0,   34, 8879, 2208,    0,    0, 3456, 8799, 8317, 8227,
  -37,  -37,  -37, 8227, 6578, 6653,    0,  -69,    0,    0,
    0,    0,    0,    0, 8628,    0, 8628, 5343,    0,  -89,
 8879,  287,  289, -252,  251, 9108,    0,  317,    0,  317,
 4734, 7273,  301, 7371,    0, 8152, 7446,   35, 8879,    0,
   34, 8227,  312,  313, 5455,    0,    0,    0,  287,  -89,
 5655, 7538,    0,    0,    0,   35, 8152,    0,  -29, 5655,
  287,    0,    0,   35, 5655,    0,
};
short yyrindex[] = {                                   2901,
    0,    0,    0,    0,    0, 2995,  330,    0,    0,    0,
    0,    0,    0,    0,    0,   89,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0, 3261,
    0,    0,    0,    0,    0,    0,    0,    0,   63, 2636,
    0, 2782,    0, 2901,    0, 1665,    1,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0, 2018, 1571,    0,
    0,    0,    0,    0,    0,    0,    0,  183,    0,    0,
  495,  583,  677,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0, 2730,
    0,    0,    0,    0,    0,    0,    0,    0, 9127,    0,
  360,    0,    0,    0,    0,    0,    0, 4406,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,  -32,    0,    0,    0,    0,    0,    0, 5722,    0,
  -25,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   49,    0,    0,  321,    0,    0,    0,    0,    0,
 2283,    0,    0,    0, 3348,  151,    0,  645, 1139, 2345,
 3323, 3410, 3439,    0,    0,    0, 3806,    0,   57,    0,
  989, 1836, 1930, 1077, 1171, 1483,    0, 4346,    0,    0,
    0,   96,    0,    0, 4406,    0, 4530,    0,  -28,    0,
    0,  326,    0,    0,    0,    0,    0,    0,    0,    0,
    0, 5582,    0,    0,    0,    0,    0,  374,   82,    6,
 7803,    0, 4221,    0, 7711,    0,    0,    0,  323,    0,
  339,    0,    0,    0,    0,    0,    0,    0,    0,    0,
 2371,    0,    0,    0,    0, 2465,    0, 2834,    0,    0,
    0,    0,    0,    0,    0, 4037,    0,    0,    0,    0,
    0,    0,    0,    0, 4673,    0,    0,    0,    0, 7894,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   56,    0,  267,    0,    0, 7711,    0, 7711,    0,    0,
  144,    0,    0, 9127,    0, 5782, 5849,    0,    0,    0,
    0,  280,    0,  449,    0,    0,    0,  535,  795,  410,
    9,   10,   15,  119,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0, 5989,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0, 7711,    0,    0,  351,    0, 5922,    0,    0,
    0,  508,    0,    0,    0,    0,    0,    0,    0, 5989,
    0,    0,    0,    0,    0, 6049,  351,    0,    0,    0,
    0,    0,    0, 6116,    0,    0,
};
short yygindex[] = {                                      0,
    0, 4168,  340, -140,    0,  -13,    0, 3893,  -10,  216,
  295,    0,  -57,  -97, -281,  859,  -27, 3676,  -53,    0,
    0,    0,    0,    0,    0,    0,  -84,    0,  354,    7,
    0, -165,  356,  -80,  -23,  247,  311,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,
};

short yytable[] = {                                      97,
  174,   97,    9,    3,   96,   94,   96,   95,  105,   93,
    3,   93,  104,   48,  264,   82,   50,   51,  178,  105,
  218,  157,  133,  134,   74,  188,  105,  178,  191,  185,
  104,  194,  195,   82,  164,  197,   15,  174,  199,   99,
  174,  174,  174,  174,  174,  174,  102,  174,  100,   99,
  100,  148,  150,   12,  349,  101,   61,  189,  174,  174,
  320,  135,   34,  174,  102,   55,  256,   99,  100,  103,
  104,   63,  180,  101,  215,  361,   64,   24,   65,   26,
   66,  286,   67,  287,  184,   15,   69,  309,  144,   46,
   70,  183,   46,  174,  244,   59,   47,   61,   82,   47,
   61,  105,  206,   61,  178,  243,   34,   48,  135,   34,
  240,  248,  132,   60,   61,   61,   61,  140,   12,   61,
  212,   34,   83,  174,  174,  144,   24,   25,   26,  144,
  144,  144,  144,  144,  102,  144,   59,  145,  246,   59,
   83,   46,   59,   60,   38,   98,  144,  144,   47,   61,
   70,  144,  325,   59,   59,  138,  338,  319,  135,   48,
  223,  241,   48,  135,  152,  155,  270,  103,  104,  276,
  278,  265,  229,  177,  266,  135,   48,   48,  279,   61,
  192,  144,  154,  356,   60,   34,  230,   60,   59,  135,
   60,   70,  204,  272,   70,  364,  135,   70,  193,  295,
    1,   60,   60,  178,  296,   83,    8,    2,   70,   70,
  198,  144,  144,   70,    2,  220,  285,  292,   59,  154,
  135,  222,  154,  154,  154,  154,  154,  154,  283,  154,
  105,  322,  314,  177,  104,  135,   60,   82,  244,  178,
  154,  154,   48,   70,  282,  154,  212,  225,  212,  250,
  212,  212,  212,  237,  318,   82,  212,  333,   82,  244,
  321,  174,  174,  174,  177,  135,   60,  174,  102,  178,
  340,   99,  100,   70,  362,  154,  242,  101,  267,  174,
  174,  174,  174,  174,  174,  174,  174,  174,  174,  174,
  174,  341,  174,  284,  135,  291,  336,  307,  174,  174,
  174,  311,  174,  345,  174,  154,  154,   98,  313,   98,
  323,  103,  104,  174,  331,  212,  218,   61,   61,   61,
   84,  324,  174,   34,   34,   34,  357,  272,  339,   32,
  174,  174,  174,  174,  174,  174,   61,  174,   84,  174,
  174,  347,   15,  174,   83,  174,  174,  174,  174,  144,
  144,  144,  353,  354,   61,  144,   59,   59,   59,   33,
   34,  178,   83,   78,  178,   83,   78,  144,  144,  144,
  144,  144,  144,  144,  144,  144,  144,  144,  144,   79,
  144,   48,   79,   24,   30,   26,  144,  144,  144,   42,
  144,   30,  144,   59,  238,  181,   15,  101,    0,   48,
    0,  144,   48,   84,   60,   60,   60,  137,  139,    0,
  144,   70,   70,   70,   80,    0,    0,   80,  144,  144,
  144,  144,  144,  144,    0,  144,    0,  144,  144,   70,
   70,  144,   80,  144,  144,  144,  144,   24,   25,   26,
    0,   60,    0,  154,  154,  154,    0,    0,   70,  154,
   81,    0,    0,   81,  261,   38,    0,    0,    0,    0,
    0,  154,  154,  154,  154,  154,  154,  154,   81,  154,
  154,  154,  154,    0,  154,    0,    0,    0,    0,    0,
  154,  154,  154,    0,  154,    0,  154,   70,    0,   53,
    0,    0,   53,    0,  140,  154,    0,   80,    0,    0,
    0,  227,  228,    0,  154,    0,   53,   53,  232,  233,
    0,   53,  154,  154,  154,  154,  154,  154,  262,  154,
    0,  154,  154,    0,    0,  154,    0,  154,  154,  154,
  154,  140,    0,   81,  140,  140,  140,  140,  140,  140,
  261,  140,   84,  261,  261,  261,  261,    0,   49,    0,
  261,   49,  140,  140,    0,    0,    0,  140,    0,    0,
   84,    0,    0,   84,  263,   49,   49,    0,    0,  268,
  269,    0,   53,    0,    0,   51,    0,    0,   51,  218,
    0,  274,  139,    0,    0,    0,    0,  140,  261,    0,
    0,    0,   51,   51,    0,    0,  294,   51,  297,    0,
  298,  299,  300,    0,  262,   15,  304,  262,  262,  262,
  262,  139,    0,    0,  262,    0,    0,  140,  140,  139,
    0,    0,  139,  139,  139,  139,  139,  139,    0,  139,
    0,   49,    0,    0,  315,  317,   80,    0,    0,    0,
  139,  139,    0,    0,   63,  139,   24,   25,   26,    0,
    0,    0,  262,    0,   80,    0,    0,   80,   51,    0,
  328,  330,    0,    0,   38,  342,    0,    0,    0,    0,
    0,    0,   81,    0,    0,  139,  141,    0,    0,    0,
  139,    0,    0,    0,    0,   63,    0,    0,   63,    0,
   81,   63,    0,   81,    0,    0,    0,    0,    0,    0,
    0,    0,   63,   63,    0,  139,  139,   63,    0,    0,
    0,   53,    0,  141,    0,    0,  141,  141,  141,  141,
  141,  141,    0,  141,    0,    0,    0,   53,   53,   53,
    0,    0,   53,    0,  141,  141,    0,   63,    0,  141,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  140,  140,  140,    0,    0,
    0,  140,    0,    0,    0,    0,    0,   63,    0,  141,
   49,    0,    0,  140,  140,  140,  140,  140,  140,  140,
  140,  140,  140,  140,  140,   53,  140,    0,   49,    0,
    0,   49,  140,  140,  140,    0,  140,   51,  140,  141,
  141,    0,    0,    0,    0,    0,    0,  140,    0,    0,
    0,    0,    0,   51,   51,   51,  140,    0,   51,    0,
    0,    0,    0,    0,  140,  140,  140,  140,  140,  140,
    0,  140,    0,  140,  140,   50,    0,  140,   50,    0,
  140,  140,  140,  139,  139,  139,    0,    0,    0,  139,
    0,    0,   50,   50,    0,    0,    0,   50,    0,    0,
    0,  139,  139,  139,  139,  139,  139,  139,  139,  139,
  139,  139,  139,    0,  139,    0,    0,    0,    0,    0,
  139,  139,  139,    0,  139,    0,  139,    0,    0,    0,
    0,    0,    0,    0,    0,  139,    0,    0,    0,    0,
    0,    0,    0,    0,  139,   63,   63,   63,    0,    0,
    0,    0,  139,  139,  139,  139,  139,  139,   50,  139,
    0,  139,  139,   63,   63,  139,    0,    0,  139,  139,
  139,    0,    0,    0,    0,    0,    0,  141,  141,  141,
    0,    0,   63,  141,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  141,  141,  141,  141,  141,
  141,  141,  141,  141,  141,  141,  141,    0,  141,    0,
    0,    0,    0,    0,  141,  141,  141,    0,  141,    0,
  141,   63,    0,  201,    0,  202,    0,    0,  136,  141,
    0,  201,  201,    0,    0,    0,    0,    0,  141,    0,
    0,    0,    0,    0,    0,    0,  141,  141,  141,  141,
  141,  141,    0,  141,    0,  141,  141,    0,    0,  141,
    0,    0,  141,  141,  141,  136,    0,    0,  136,  136,
  136,  136,  136,  136,    0,  136,    0,    0,  201,    0,
    0,    0,    0,    0,    0,    0,  136,  136,    0,    0,
    0,  136,    0,    0,    0,    0,    0,   50,    0,    0,
    0,  252,    0,  253,  201,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   50,   50,  135,    0,   50,    0,
    0,  136,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  289,
    0,  136,  136,  135,    0,    0,  135,  135,  135,  135,
  135,  135,    0,  135,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  135,  135,    0,    0,   64,  135,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  135,
  137,    0,    0,    0,    0,    0,  201,    0,    0,   64,
    0,    0,   64,    0,    0,   64,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   64,   64,    0,  135,
  135,   64,    0,  201,    0,    0,    0,  137,    0,  358,
  137,  137,  137,  137,  137,  137,    0,  137,  363,    0,
    0,    0,    0,  366,    0,    0,    0,    0,  137,  137,
    0,   64,    0,  137,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  136,
  136,  136,    0,    0,    0,  136,    0,    0,    0,    0,
    0,   64,    0,  137,    0,    0,    0,  136,  136,  136,
  136,  136,  136,  136,  136,  136,  136,  136,  136,    0,
  136,    0,    0,    0,    0,    0,  136,  136,  136,    0,
  136,    0,  136,  137,  137,    0,    0,    0,    0,    0,
    0,  136,    0,    0,    0,    0,    0,    0,    0,    0,
  136,    0,    0,    0,    0,    0,    0,    0,  136,  136,
  136,  136,  136,  136,    0,  136,    0,  136,  136,    0,
    0,  136,    0,    0,  136,  136,  136,  135,  135,  135,
    0,    0,    0,  135,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  135,  135,  135,  135,  135,
  135,  135,  135,  135,  135,  135,  135,    0,  135,    0,
    0,    0,    0,    0,  135,  135,  135,    0,  135,    0,
  135,    0,    0,    0,    0,    0,    0,    0,    0,  135,
    0,    0,   56,    0,    0,   33,    0,   34,  135,   64,
   64,   64,    0,    0,    0,    0,  135,  135,  135,  135,
  135,  135,    0,  135,    0,  135,  135,   64,   64,  135,
    0,    0,  135,  135,  135,    0,    0,    0,    0,    0,
    0,  137,  137,  137,    0,    0,   64,  137,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  137,
  137,  137,  137,  137,  137,  137,  137,  137,  137,  137,
  137,    0,  137,    0,    0,    0,    0,    0,  137,  137,
  137,    0,  137,    0,  137,   64,   78,    0,    0,    0,
    0,    0,  138,  137,    0,    0,    0,    0,    0,    0,
    0,    0,  137,    0,    0,    0,    0,    0,    0,    0,
  137,  137,  137,  137,  137,  137,    0,  137,    0,  137,
  137,    0,    0,  137,    0,    0,  137,  137,  137,  138,
    0,    0,  138,  138,  138,  138,  138,  138,    0,  138,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
  138,  138,    0,    0,    0,  138,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
  173,    0,    0,    0,    0,  138,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  138,  138,  173,    0,    0,
  173,  173,  173,  173,  173,  173,    0,  173,    0,   79,
    0,    0,    0,    0,    0,    0,    0,    0,  173,  173,
    0,   80,    0,  173,   82,   83,   84,   85,   86,   87,
   88,   15,   16,    0,   17,    0,    0,    0,    0,    0,
    0,   19,   20,    0,   21,    0,   22,    0,    0,    0,
    0,    0,    0,  173,  173,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   23,    0,    0,    0,    0,    0,
    0,    0,   24,   25,   26,   27,   28,   29,    0,   30,
    0,   31,   32,  173,  173,   57,    0,    0,   36,   37,
   38,  173,    0,    0,  173,  173,  173,  173,  173,  173,
    0,  173,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  173,  173,    0,    0,    0,  173,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  138,  138,  138,    0,    0,    0,  138,
    0,    0,    0,    0,    0,    0,    0,  173,    0,    0,
    0,  138,  138,  138,  138,  138,  138,  138,  138,  138,
  138,  138,  138,    0,  138,    0,    0,    0,    0,    0,
  138,  138,  138,    0,  138,    0,  138,  173,  173,    0,
    0,    0,    0,    0,    0,  138,    0,    0,    0,    0,
    0,    0,    0,    0,  138,    0,    0,    0,    0,    0,
    0,    0,  138,  138,  138,  138,  138,  138,    0,  138,
    0,  138,  138,    0,    0,  138,    0,    0,  138,  138,
  138,  173,  173,  173,    0,  133,    0,  173,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  173,
  173,  173,  173,  173,  173,  173,  173,  173,  173,  173,
  173,    0,  173,    0,    0,    0,    0,    0,  173,  173,
  173,    0,  173,    0,  173,  133,  133,    0,  133,  133,
  133,    0,    0,  173,    0,    0,    0,    0,    0,    0,
    0,    0,  173,  133,  133,    0,    0,    0,  133,    0,
  173,  173,  173,  173,  173,  173,    0,  173,    0,  173,
  173,    0,    0,  173,    0,  173,    0,    0,  173,    0,
    0,    0,    0,    0,    0,  173,  173,  173,  133,  134,
    0,  173,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  173,  173,    0,  173,  173,  173,  173,
  173,  173,  173,  173,  173,    0,  173,    0,  133,  133,
    0,    0,  173,  173,  173,    0,  173,    0,  173,  134,
  134,    0,  134,  134,  134,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,  173,  134,  134,    0,
    0,    0,  134,    0,  173,  173,  173,  173,  173,  173,
    0,  173,    0,  173,  173,    0,    0,  173,    0,  173,
    0,    0,  173,    0,    0,    0,    0,  147,    0,    0,
    0,    0,  134,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  134,  134,    0,    0,    0,  147,  147,    0,
    0,  147,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  147,  147,    0,    0,    0,
  147,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,  133,  133,  133,    0,
    0,    0,  133,    0,    0,    0,    0,    0,    0,    0,
  147,    0,    0,    0,  133,  133,  133,  133,  133,  133,
  133,  133,  133,  133,  133,  133,    0,  133,    0,    0,
    0,    0,    0,  133,  133,  133,    0,  133,    0,  133,
  147,  147,    0,    0,    0,    0,    0,    0,  133,    0,
    0,    0,    0,    0,    0,    0,    0,  133,    0,    0,
    0,    0,    0,    0,    0,  133,  133,  133,  133,  133,
  133,    0,  133,    0,  133,  133,    0,    0,  133,    0,
    0,  133,  133,  133,    0,    0,    0,    0,    0,    0,
  134,  134,  134,    0,    0,    0,  134,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  134,  134,
  134,  134,  134,  134,  134,  134,  134,  134,  134,  134,
    0,  134,    0,    0,    0,    0,    0,  134,  134,  134,
    0,  134,    0,  134,    0,    0,    0,    0,    0,    0,
    0,    0,  134,    0,    0,    0,    0,   56,    0,    0,
   33,  134,   34,    0,    0,    0,    0,    0,    0,  134,
  134,  134,  134,  134,  134,    0,  134,    0,  134,  134,
    0,    0,  134,    0,    0,  134,  134,  134,  147,  147,
  147,    0,  153,    0,  147,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,  147,  147,  147,  147,
  147,  147,  147,  147,  147,  147,  147,  147,    0,  147,
    0,    0,    0,    0,    0,  147,  147,  147,    0,  147,
    0,  147,  153,  153,    0,    0,  153,    0,    0,    0,
  147,    0,    0,    0,    0,    0,    0,    0,    0,  147,
  153,  153,    0,    0,   65,  153,    0,  147,  147,  147,
  147,  147,  147,    0,  147,    0,  147,  147,    0,    0,
  147,    0,    0,  147,  147,  147,    0,    0,    0,    0,
  152,    0,    0,    0,    0,  153,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   65,    0,    0,   65,    0,
    0,   65,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   65,   65,    0,  153,  153,   65,    0,    0,
  152,  152,    0,    0,  152,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  152,  152,
    0,    0,    0,  152,    0,    0,    0,   65,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  152,  132,    0,    0,   65,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  152,  152,    0,   15,   16,    0,   17,
    0,    0,    0,    0,  132,  132,   19,   20,  132,   21,
    0,   22,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  132,  132,    0,    0,    0,  132,    0,   23,
    0,    0,    0,    0,    0,    0,    0,   24,   25,   26,
   27,   28,   29,  153,  153,  153,   31,   32,    0,  153,
   57,    0,    0,   36,   37,   38,    0,  132,    0,    0,
    0,  153,  153,  153,  153,  153,  153,  153,  153,  153,
  153,  153,  153,    0,  153,    0,    0,    0,    0,    0,
  153,  153,  153,    0,  153,    0,  153,  132,  132,    0,
    0,    0,    0,    0,    0,  153,    0,    0,    0,    0,
    0,    0,    0,    0,  153,   65,   65,   65,    0,    0,
    0,    0,  153,  153,  153,  153,  153,  153,    0,  153,
    0,  153,  153,   65,   65,  153,    0,    0,  153,  153,
  153,  152,  152,  152,    0,   77,    0,  152,    0,    0,
    0,    0,   65,    0,    0,    0,    0,    0,    0,  152,
  152,  152,  152,  152,  152,  152,  152,  152,  152,  152,
  152,    0,  152,    0,    0,    0,    0,    0,  152,  152,
  152,    0,  152,    0,  152,   77,   77,    0,    0,   77,
    0,   65,    0,  152,    0,    0,    0,    0,    0,    0,
    0,    0,  152,   77,   77,    0,    0,    0,   77,    0,
  152,  152,  152,  152,  152,  152,    0,  152,    0,  152,
  152,    0,    0,  152,    0,    0,  152,  152,  152,    0,
    0,    0,    0,    0,    0,  132,  132,  132,   77,   75,
    0,  132,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  132,  132,  132,  132,  132,  132,  132,
  132,  132,  132,  132,  132,    0,  132,    0,   77,   77,
    0,    0,  132,  132,  132,    0,  132,    0,  132,   75,
   75,    0,    0,   75,    0,    0,    0,  132,    0,    0,
    0,   35,    0,    0,    0,    0,  132,   75,   75,    0,
    0,    0,   75,    0,  132,  132,  132,  132,  132,  132,
    0,  132,    0,  132,  132,    0,    0,  132,    0,    0,
  132,  132,  132,    0,    0,    0,    0,    0,    0,    0,
    0,   35,   75,    0,   35,    0,   35,    0,   35,    0,
    0,    0,    0,   37,    0,    0,    0,    0,    0,    0,
   35,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   75,   75,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   37,    0,    0,   37,    0,   37,    0,
   37,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   37,    0,    0,    0,   77,   77,   77,    0,
   28,    0,   77,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   77,   77,    0,   77,   77,   77,
   77,   77,   77,   77,   77,   77,    0,   77,    0,    0,
    0,    0,    0,   77,   77,   77,    0,   77,    0,   77,
   28,    0,    0,   28,    0,   28,    0,   28,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   77,    0,    0,
    0,    0,    0,    0,    0,   77,   77,   77,   77,   77,
   77,    0,   77,    0,   77,   77,    0,    0,   77,    0,
    0,   77,   77,   77,    0,    0,    0,    0,    0,    0,
   75,   75,   75,    0,   29,    0,   75,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   75,   75,
    0,   75,   75,   75,   75,   75,   75,   75,   75,   75,
    0,   75,    0,   28,    0,    0,    0,   75,   75,   75,
    0,   75,    0,   75,   29,    0,    0,   29,    0,   29,
    0,   29,   35,   35,   35,    0,    0,    0,    0,    0,
    0,   75,    0,    0,    0,    0,    0,    0,    0,   75,
   75,   75,   75,   75,   75,    0,   75,    0,   75,   75,
   35,   35,   75,   35,    0,   75,   75,   75,    0,   35,
   35,   35,    0,   35,    0,   35,    0,    0,    0,    0,
    0,    0,    0,    0,   37,   37,   37,    0,    0,    0,
    0,    0,    0,   35,    0,    0,    0,    0,    0,    0,
    0,   35,   35,   35,   35,   35,   35,   29,   35,    0,
   35,   35,   37,   37,   35,   37,    0,   35,   35,   35,
    0,   37,   37,   37,    0,   37,    0,   37,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   37,    0,    0,    0,    0,
    0,   28,   28,   37,   37,   37,   37,   37,   37,    0,
   37,    0,   37,   37,    0,    0,   37,    0,    0,   37,
   37,   37,    0,    0,    0,    0,    0,    0,    0,   28,
   28,    0,   28,    0,    0,    0,    0,    0,   28,   28,
   28,    0,   28,    0,   28,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   28,    0,    0,    0,    0,    0,    0,    0,
   28,   28,   28,   28,   28,   28,    0,   28,    0,   28,
   28,    0,    0,   28,    0,    0,   28,   28,   28,    0,
    0,    0,    0,    0,    0,   29,   29,    0,    0,    0,
  155,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   29,   29,    0,   29,    0,    0,    0,
    0,    0,   29,   29,   29,    0,   29,  155,   29,    0,
  155,  155,  155,  155,  155,  155,    0,  155,    0,    0,
    0,    0,    0,    0,    0,    0,   29,    0,  155,  155,
    0,    0,   66,  155,   29,   29,   29,   29,   29,   29,
    0,   29,    0,   29,   29,    0,    0,   29,    0,    0,
   29,   29,   29,    0,    0,    0,    0,   74,    0,    0,
    0,    0,    0,  155,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   66,    0,    0,   66,    0,    0,   66,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   66,   66,    0,  155,  155,   66,    0,   74,   74,    0,
   74,   74,   74,    0,   74,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   74,   74,    0,    0,   67,
   74,    0,    0,    0,    0,   66,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   68,    0,
   74,    0,    0,    0,    0,   66,    0,    0,    0,    0,
   67,    0,    0,   67,    0,    0,   67,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   67,   67,    0,
   74,   74,   67,    0,    0,    0,    0,    0,    0,   68,
    0,    0,   68,    0,    0,   68,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   56,   68,   68,   33,    0,
   34,   68,   67,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  326,    0,    0,    0,    0,  259,    0,
    0,  155,  155,  155,    0,    0,    0,  155,    0,    0,
    0,   68,   67,    0,    0,    0,    0,    0,    0,  155,
  155,  155,  155,  155,  155,  155,    0,  155,  155,    0,
  155,    0,  155,    0,    0,    0,    0,    0,  155,  155,
  155,   68,  155,    0,  155,    0,    0,    0,    0,    0,
    0,    0,    0,  155,    0,    0,    0,    0,    0,    0,
    0,    0,  155,   66,   66,   66,    0,    0,    0,    0,
    0,    0,    0,  155,  155,  155,    0,  155,    0,  155,
  155,   66,   66,  155,    0,  155,  155,  155,   74,   74,
   74,    0,    0,    0,   74,    0,    0,    0,    0,    0,
   66,    0,    0,    0,    0,    0,   74,   74,    0,   74,
   74,   74,   74,   74,   74,   74,    0,   74,    0,   74,
    0,    0,    0,    0,    0,   74,   74,   74,    0,   74,
    0,   74,    0,    0,    0,    0,    0,    0,    0,   66,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   74,
   67,   67,   67,    0,    0,    0,    0,    0,    0,    0,
   74,   74,   74,    0,   74,    0,   74,   74,   67,   67,
   74,    0,   59,   74,   74,    0,    0,    0,    0,   68,
   68,   68,    0,    0,    0,   68,    0,   67,   59,   59,
   59,   75,   76,   59,   59,    0,    0,   68,   68,    0,
    0,    0,  257,    0,    0,    0,    0,   59,    0,    0,
    0,    0,   59,    0,   80,   81,   68,    0,    0,    0,
    0,    0,   59,  258,   15,   16,   67,   17,    0,    0,
    0,    0,    0,    0,   19,   20,    0,   21,    0,   22,
    0,    0,    0,    0,    0,    0,    0,    0,   59,   59,
   59,   59,   59,   59,    0,   68,    0,   23,    0,    0,
    0,    0,    0,    0,    0,   24,   25,   26,   27,   28,
   29,    0,   30,    0,   31,   32,    0,   59,   57,    0,
    0,   36,   37,   38,    0,   62,  213,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   59,    0,   59,
    0,   59,   59,    0,    0,    0,    0,   59,   59,   59,
  234,   59,    0,   59,   59,   59,   59,   59,   59,    0,
   59,    0,   59,    0,   59,   59,   62,    0,    0,   62,
    0,    0,   62,    0,    0,    0,    0,   59,    0,    0,
    0,    0,    0,   62,   62,   59,    0,    0,   62,    0,
    0,   59,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   59,    0,    0,    0,    0,    0,   59,
    0,    0,    0,    0,   59,    0,   59,    0,   62,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   58,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   59,    0,   59,   71,   72,   73,   62,    0,
   77,   90,  213,    0,  213,    0,  213,  213,  213,   59,
   59,   59,  213,    0,   90,    0,   59,    0,    0,   73,
   59,    0,   59,    0,    0,   59,   59,    0,    0,  151,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   59,
    0,    0,   59,   59,   59,   59,    0,    0,    0,   59,
   59,   59,    0,    0,    0,  171,  172,  173,  174,  175,
  176,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,  213,    0,  343,    0,  344,    0,   59,    0,   59,
    0,    0,   59,    0,   90,    0,    0,   59,    0,    0,
    0,    0,    0,  211,    0,    0,    0,   59,    0,    0,
    0,    0,    0,    0,   90,    0,   90,    0,   90,   90,
    0,    0,    0,    0,  231,   90,   90,    0,   90,    0,
   90,   90,   90,   90,   90,   90,    0,   90,    0,   90,
    0,   90,  236,    0,    0,    0,   62,   62,   62,    0,
    0,    0,    0,  174,   90,    0,  174,    0,  174,  174,
    0,  174,   90,  174,   62,   62,    0,    0,   90,    0,
    0,    0,    0,    0,    0,  174,    0,    0,    0,  174,
  260,    0,    0,   62,    0,    0,   90,    0,    0,    0,
    0,   90,    0,   90,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   90,
    0,   90,    0,    0,    0,    0,    0,    0,    0,  211,
    0,  211,    0,  211,  211,  211,  301,  302,  303,  211,
  174,    0,    0,   90,    0,    0,    0,   90,    0,   90,
    0,    0,   90,   90,   39,    0,    0,    0,    0,    0,
   52,    0,    0,    0,    0,    0,  260,    0,    0,  260,
  260,  260,  260,    0,    0,    0,  260,   90,   90,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  211,    0,
    0,    0,  142,  144,   90,    0,   90,    0,    0,   90,
  146,  147,  142,  142,  260,    0,  153,  154,    0,    0,
    0,    0,    0,    0,   90,    0,  156,    0,    0,  158,
  159,  160,  161,  162,  163,    0,  165,  173,  167,  169,
  173,  173,  173,  173,  173,  173,    0,  173,   39,  182,
    0,    0,  142,    0,    0,    0,    0,    0,  173,  173,
  190,    0,    0,  173,    0,    0,    0,  196,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  214,
    0,    0,    0,  174,  219,    0,  221,    0,    0,    0,
    0,    0,    0,    0,    0,  174,  174,    0,  174,  174,
  174,  174,  174,  174,    0,  174,  174,    0,  174,    0,
    0,    0,    0,    0,    0,  174,  174,    0,  174,    0,
  174,    0,    0,    0,  173,    0,   39,    0,    0,  174,
    0,    0,    0,    0,    0,    0,    0,    0,  174,    0,
  247,    0,    0,    0,    0,  249,  174,  174,  174,  174,
  174,  174,    0,  174,   52,  174,  174,    0,    0,  174,
    0,  174,  174,  174,  174,   27,   27,    0,   27,    0,
   27,  271,   27,    0,  275,  277,    0,    0,    0,    0,
  280,    0,  281,    0,   27,    0,    0,    0,    0,  142,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  305,  306,    0,    0,    0,
    0,    0,    0,    0,    0,   26,    0,    0,   26,    0,
   26,    0,   26,    0,    0,    0,    0,    0,    0,    0,
   52,    0,    0,    0,   26,    0,    0,    0,   27,    0,
   27,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  332,  173,  334,    0,    0,  173,  337,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  173,
  173,  173,    0,    0,  173,    0,  352,    0,  173,  173,
  173,    0,  173,    0,    0,    0,    0,    0,    0,  173,
  173,    0,  173,    0,  173,    0,    0,    0,   26,    0,
   26,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  173,    0,    0,    0,    0,    0,    0,    0,
  173,  173,  173,  173,  173,  173,    0,  173,    0,  173,
  173,    0,    0,  173,    0,  173,    0,    0,  173,  107,
    0,    0,  107,    0,  107,    0,  107,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  107,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   27,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   27,   27,   27,   27,   27,   27,
   27,   27,   27,    0,   27,   27,   27,   27,    0,   27,
   27,   27,  107,    0,  107,    0,    0,    0,    0,    0,
    0,   26,    0,    0,    0,   27,   27,   27,   27,    0,
    0,    0,    0,    0,    0,   27,   27,   27,   27,   27,
   27,    0,   27,   27,   27,   27,   27,    0,   27,    0,
    0,   27,   27,   27,   26,   26,   26,   26,   26,   26,
   26,   26,   26,    0,   26,   26,   26,   26,    0,   26,
   26,   26,  119,    0,    0,  119,    0,  119,    0,  119,
    0,    0,    0,    0,    0,   26,   26,   26,   26,    0,
    0,  119,    0,    0,    0,   26,   26,   26,   26,   26,
   26,    0,   26,   26,   26,   26,   26,    0,   26,    0,
    0,   26,   26,   26,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   13,    0,    0,   33,    0,   34,    0,
   14,    0,    0,    0,    0,  107,    0,    0,    0,    0,
    0,    0,  108,    0,    0,  119,    0,  119,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  107,  107,
  107,  107,  107,  107,  107,  107,  107,    0,  107,  107,
  107,  107,    0,  107,  107,  107,   13,    0,    0,   33,
    0,   34,    0,   14,    0,    0,    0,    0,    0,  107,
  107,  107,  107,    0,    0,  108,   12,    0,    0,  107,
  107,  107,  107,  107,  107,    0,  107,  107,  107,  107,
  107,    0,  107,    0,    0,  107,  107,  107,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   13,    0,    0,   33,
    0,   34,    0,   14,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  108,    0,    0,    0,   12,
    0,  200,    0,    0,    0,    0,    0,    0,  119,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,  119,  119,  119,  119,  119,  119,  119,  119,  119,
    0,  119,  119,  119,  119,    0,  119,  119,  119,   12,
    0,  216,    0,    0,    0,    0,    0,    0,    0,  106,
    0,    0,  119,  119,  119,  119,  107,    0,    0,    0,
    0,    0,  119,  119,  119,  119,  119,  119,    0,  119,
  119,  119,  119,  119,    0,  119,    0,    0,  119,  119,
  119,    0,   15,   16,  109,   17,  110,  111,  112,  113,
  114,    0,   19,   20,  115,   21,    0,   22,  116,  117,
   13,    0,    0,   33,    0,   34,    0,   14,    0,    0,
    0,    0,  106,  118,  119,   23,    0,    0,    0,  108,
    0,    0,    0,   24,   25,   26,   27,   28,   29,    0,
   30,  120,   31,   32,  121,    0,   35,    0,    0,   36,
   37,   38,    0,    0,    0,   15,   16,  109,   17,  110,
  111,  112,  113,  114,    0,   19,   20,  115,   21,    0,
   22,  116,  117,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  106,    0,    0,    0,  118,  119,   23,    0,
    0,    0,    0,   12,    0,  217,   24,   25,   26,   27,
   28,   29,    0,   30,  120,   31,   32,  121,    0,   35,
    0,    0,   36,   37,   38,   15,   16,  109,   17,  110,
  111,  112,  113,  114,    0,   19,   20,  115,   21,    0,
   22,  116,  117,   13,    0,    0,   33,    0,   34,    0,
   14,    0,    0,    0,    0,    0,  118,  119,   23,    0,
    0,    0,  108,    0,    0,    0,   24,   25,   26,   27,
   28,   29,    0,   30,  120,   31,   32,  121,    0,   35,
    0,    0,   36,   37,   38,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   13,    0,    0,   33,    0,   34,
    0,   14,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  108,    0,    0,   12,    0,  239,    0,
    0,    0,    0,    0,    0,    0,  106,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   15,
   16,  109,   17,  110,  111,  112,  113,  114,    0,   19,
   20,  115,   21,    0,   22,  116,  117,   12,    0,  254,
   13,    0,    0,   33,    0,   34,    0,   14,    0,    0,
  118,  119,   23,    0,    0,    0,    0,    0,    0,  108,
   24,   25,   26,   27,   28,   29,    0,   30,  120,   31,
   32,  121,    0,   35,    0,    0,   36,   37,   38,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  106,
    0,    0,   13,    0,    0,   33,    0,   34,    0,   14,
    0,    0,    0,   12,    0,    0,    0,    0,    0,    0,
    0,  108,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   15,   16,  109,   17,  110,  111,  112,  113,
  114,    0,   19,   20,  115,   21,    0,   22,  116,  117,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
  106,    0,    0,  118,  119,   23,    0,    0,    0,    0,
    0,    0,    0,   24,   25,   26,   27,   28,   29,    0,
   30,  120,   31,   32,  121,   12,   35,  335,    0,   36,
   37,   38,    0,   15,   16,  109,   17,  110,  111,  112,
  113,  114,    0,   19,   20,  115,   21,    0,   22,  116,
  117,    0,    0,    0,   13,    0,    0,   33,    0,   34,
    0,   14,    0,    0,  118,  119,   23,    0,    0,    0,
    0,    0,    0,  108,   24,   25,   26,   27,   28,   29,
    0,   30,  120,   31,   32,  121,  106,   35,    0,    0,
   36,   37,   38,  288,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   15,
   16,  109,   17,  110,  111,  112,  113,  114,    0,   19,
   20,  115,   21,    0,   22,  116,  117,   12,    0,  355,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
  118,  119,   23,    0,    0,    0,    0,    0,  106,    0,
   24,   25,   26,   27,   28,   29,    0,   30,  120,   31,
   32,  121,    0,   35,    0,    0,   36,   37,   38,    0,
    0,  118,    0,    0,  118,    0,  118,    0,  118,    0,
    0,   15,   16,  109,   17,  110,  111,  112,  113,  114,
  118,   19,   20,  115,   21,    0,   22,  116,  117,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  118,  119,   23,    0,    0,    0,    0,    0,
    0,    0,   24,   25,   26,   27,   28,   29,    0,   30,
  120,   31,   32,  121,    0,   35,    0,    0,   36,   37,
   38,    0,    0,    0,   13,    0,    0,   33,    0,   34,
    0,   14,    0,    0,  118,    0,  118,    0,    0,    0,
  106,    0,    0,  108,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   15,   16,  109,   17,  110,  111,  112,
  113,  114,    0,   19,   20,  115,   21,    0,   22,  116,
  117,  111,    0,    0,  111,    0,  111,    0,  111,    0,
    0,    0,    0,    0,  118,  119,   23,   12,    0,    0,
  111,    0,    0,    0,   24,   25,   26,   27,   28,   29,
    0,   30,  120,   31,   32,  121,    0,   35,    0,    0,
   36,   37,   38,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   21,    0,    0,   21,    0,   21,    0,   21,    0,
    0,    0,    0,    0,    0,    0,    0,  118,    0,    0,
   21,    0,    0,    0,  111,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
  118,  118,  118,  118,  118,  118,  118,  118,  118,    0,
  118,  118,  118,  118,    0,  118,  118,  118,  184,    0,
    0,  184,    0,  184,    0,  184,    0,    0,    0,    0,
    0,  118,  118,  118,   21,    0,    0,  184,    0,    0,
  106,  118,  118,  118,  118,  118,  118,    0,  118,  118,
  118,  118,  118,    0,  118,    0,    0,  118,  118,  118,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   15,   16,  109,   17,  110,  111,  112,
  113,  114,    0,   19,   20,  115,   21,    0,   22,  116,
  117,   17,    0,    0,   17,    0,   17,    0,   17,    0,
    0,  184,    0,    0,  118,  119,   23,  111,    0,    0,
   17,    0,    0,    0,   24,   25,   26,   27,   28,   29,
    0,   30,  120,   31,   32,  121,    0,   35,    0,    0,
   36,   37,   38,    0,    0,    0,    0,    0,    0,    0,
  111,  111,  111,  111,  111,  111,  111,  111,  111,    0,
  111,  111,  111,  111,    0,  111,  111,  111,   26,   26,
    0,   26,    0,   26,    0,   26,    0,   21,    0,    0,
    0,  111,  111,  111,   17,    0,    0,    0,    0,    0,
    0,  111,  111,  111,  111,  111,  111,    0,  111,  111,
  111,  111,  111,    0,  111,    0,    0,  111,  111,  111,
   21,   21,   21,   21,   21,   21,   21,   21,   21,    0,
   21,   21,   21,   21,    0,   21,   21,   21,   15,    0,
    0,   15,    0,   15,    0,   15,    0,    0,    0,    0,
    0,   21,   21,   21,  184,    0,    0,   15,    0,    0,
    0,   21,   21,   21,   21,   21,   21,    0,   21,   21,
   21,   21,   21,    0,   21,    0,    0,   21,   21,   21,
    0,    0,    0,    0,    0,    0,    0,  184,  184,  184,
  184,  184,  184,  184,  184,  184,    0,  184,  184,  184,
  184,    0,  184,  184,  184,   13,    0,    0,   13,    0,
   13,    0,   13,    0,    0,    0,    0,    0,  184,  184,
  184,   15,    0,    0,   13,    0,    0,   17,  184,  184,
  184,  184,  184,  184,    0,  184,  184,  184,  184,  184,
    0,  184,    0,    0,  184,  184,  184,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   17,   17,   17,   17,   17,   17,   17,   17,   17,    0,
   17,   17,   17,   17,    0,   17,   17,   17,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   13,    0,
    0,   17,   17,   17,   26,    0,    0,    0,    0,    0,
    0,   17,   17,   17,   17,   17,   17,    0,   17,   17,
   17,   17,   17,    0,   17,    0,    0,   17,   17,   17,
    0,   56,  136,    0,   33,  135,   34,   26,   26,    0,
   26,    0,   26,    0,    0,    0,    0,   26,   26,    0,
   26,    0,   26,    0,   89,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   15,    0,    0,    0,   26,   26,
   26,    0,    0,    0,    0,    0,    0,    0,   26,   26,
   26,   26,   26,   26,    0,   26,    0,   26,   26,    0,
    0,   26,    0,    0,   26,   26,   26,   15,   15,   15,
   15,   15,   15,   15,   15,   15,    0,   15,   15,   15,
   15,    0,   15,   15,   15,   78,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   15,   15,
   15,   13,    0,    0,    0,    0,    0,    0,   15,   15,
   15,   15,   15,   15,    0,   15,   15,   15,   15,   15,
    0,   15,    0,    0,   15,   15,   15,    0,    0,    0,
    0,    0,    0,    0,   13,   13,   13,   13,   13,   13,
   13,   13,   13,    0,   13,   13,   13,   13,    0,   13,
   13,   13,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   13,   13,   13,    0,    0,
    0,    0,    0,    0,    0,   13,   13,   13,   13,   13,
   13,    0,   13,   13,   13,   13,   13,    0,   13,    0,
    0,   13,   13,   13,   56,    0,    0,   33,    0,   34,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,  185,    0,    0,    0,   89,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   79,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   80,   81,    0,   82,   83,   84,   85,   86,   87,   88,
   15,   16,    0,   17,    0,    0,    0,    0,    0,    0,
   19,   20,    0,   21,    0,   22,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   56,  316,   78,   33,
  135,   34,    0,   23,    0,    0,    0,    0,    0,    0,
    0,   24,   25,   26,   27,   28,   29,    0,   30,   89,
   31,   32,    0,    0,   57,    0,    0,   36,   37,   38,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   56,  327,    0,
   33,  135,   34,    0,    0,    0,    0,    0,    0,    0,
   78,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   89,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,  177,    0,    0,
    0,   79,   56,  329,    0,   33,  135,   34,    0,    0,
    0,   78,    0,   80,   81,    0,   82,   83,   84,   85,
   86,   87,   88,   15,   16,   89,   17,    0,    0,    0,
    0,    0,    0,   19,   20,    0,   21,    0,   22,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   23,    0,    0,    0,
    0,    0,    0,    0,   24,   25,   26,   27,   28,   29,
    0,   30,    0,   31,   32,    0,    0,   57,    0,    0,
   36,   37,   38,   79,   56,  136,   78,   33,    0,   34,
    0,    0,    0,    0,    0,   80,   81,    0,   82,   83,
   84,   85,   86,   87,   88,   15,   16,   89,   17,    0,
    0,    0,    0,    0,    0,   19,   20,    0,   21,    0,
   22,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   23,    0,
    0,    0,    0,    0,    0,    0,   24,   25,   26,   27,
   28,   29,    0,   30,   79,   31,   32,    0,    0,   57,
    0,    0,   36,   37,   38,    0,   80,   81,   78,   82,
   83,   84,   85,   86,   87,   88,   15,   16,    0,   17,
    0,    0,    0,    0,    0,    0,   19,   20,    0,   21,
   56,   22,    0,   33,  135,   34,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   23,
    0,    0,    0,   89,    0,    0,    0,   24,   25,   26,
   27,   28,   29,    0,   30,    0,   31,   32,    0,   79,
   57,    0,    0,   36,   37,   38,    0,    0,    0,    0,
    0,   80,   81,    0,   82,   83,   84,   85,   86,   87,
   88,   15,   16,    0,   17,    0,    0,    0,    0,    0,
    0,   19,   20,    0,   21,   56,   22,    0,   33,    0,
   34,    0,    0,    0,   78,    0,    0,    0,    0,    0,
    0,    0,    0,  235,   23,    0,    0,    0,   89,    0,
    0,    0,   24,   25,   26,   27,   28,   29,    0,   30,
    0,   31,   32,    0,    0,   57,    0,    0,   36,   37,
   38,   79,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   80,   81,    0,   82,   83,   84,   85,
   86,   87,   88,   15,   16,    0,   17,    0,    0,    0,
    0,    0,    0,   19,   20,    0,   21,    0,   22,   78,
    0,    0,    0,    0,    0,    0,    0,   56,  272,    0,
   33,    0,   34,    0,    0,    0,   23,    0,    0,    0,
    0,    0,    0,    0,   24,   25,   26,   27,   28,   29,
   89,   30,    0,   31,   32,    0,    0,   57,    0,    0,
   36,   37,   38,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   79,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   80,
   81,    0,   82,   83,   84,   85,   86,   87,   88,   15,
   16,   78,   17,    0,    0,    0,    0,    0,    0,   19,
   20,    0,   21,    0,   22,   56,  310,    0,   33,    0,
   34,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   23,    0,    0,    0,    0,    0,   89,    0,
   24,   25,   26,   27,   28,   29,    0,   30,    0,   31,
   32,    0,   79,   57,    0,    0,   36,   37,   38,    0,
    0,    0,    0,    0,   80,   81,    0,   82,   83,   84,
   85,   86,   87,   88,   15,   16,    0,   17,    0,    0,
    0,    0,    0,    0,   19,   20,    0,   21,    0,   22,
   56,  312,    0,   33,    0,   34,    0,    0,    0,   78,
    0,    0,    0,    0,    0,    0,    0,   23,    0,    0,
    0,    0,    0,   89,    0,   24,   25,   26,   27,   28,
   29,    0,   30,    0,   31,   32,    0,    0,   57,    0,
    0,   36,   37,   38,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   79,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   80,   81,    0,   82,
   83,   84,   85,   86,   87,   88,   15,   16,    0,   17,
    0,    0,    0,    0,   78,    0,   19,   20,    0,   21,
    0,   22,   56,  346,    0,   33,    0,   34,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   23,
    0,    0,    0,    0,    0,   89,    0,   24,   25,   26,
   27,   28,   29,    0,   30,    0,   31,   32,    0,    0,
   57,    0,    0,   36,   37,   38,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   79,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   80,   81,    0,   82,   83,   84,
   85,   86,   87,   88,   15,   16,   78,   17,    0,    0,
    0,    0,    0,    0,   19,   20,    0,   21,    0,   22,
   56,  348,    0,   33,    0,   34,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   23,    0,    0,
    0,    0,    0,   89,    0,   24,   25,   26,   27,   28,
   29,    0,   30,    0,   31,   32,    0,   79,   57,    0,
    0,   36,   37,   38,    0,    0,    0,    0,    0,   80,
   81,    0,   82,   83,   84,   85,   86,   87,   88,   15,
   16,    0,   17,    0,    0,    0,    0,    0,    0,   19,
   20,    0,   21,    0,   22,   56,    0,    0,   33,    0,
   34,    0,    0,    0,   78,    0,    0,    0,    0,    0,
    0,    0,   23,    0,  350,    0,    0,    0,   89,    0,
   24,   25,   26,   27,   28,   29,    0,   30,    0,   31,
   32,    0,    0,   57,    0,    0,   36,   37,   38,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   79,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   80,   81,    0,   82,   83,   84,   85,   86,   87,
   88,   15,   16,    0,   17,    0,    0,    0,    0,   78,
    0,   19,   20,    0,   21,    0,   22,   56,  359,    0,
   33,    0,   34,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   23,    0,    0,    0,    0,    0,
   89,    0,   24,   25,   26,   27,   28,   29,    0,   30,
    0,   31,   32,    0,    0,   57,    0,    0,   36,   37,
   38,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   79,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   80,
   81,    0,   82,   83,   84,   85,   86,   87,   88,   15,
   16,   78,   17,    0,    0,    0,    0,    0,   56,   19,
   20,   33,   21,   34,   22,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   89,   23,    0,    0,    0,    0,    0,    0,    0,
   24,   25,   26,   27,   28,   29,    0,   30,    0,   31,
   32,    0,   79,   57,    0,    0,   36,   37,   38,    0,
    0,    0,    0,    0,   80,   81,    0,   82,   83,   84,
   85,   86,   87,   88,   15,   16,    0,   17,    0,    0,
    0,    0,    0,    0,   19,   20,    0,   21,    0,   22,
   93,    0,   78,   93,    0,   93,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   23,    0,    0,
    0,    0,    0,   93,    0,   24,   25,   26,   27,   28,
   29,    0,   30,    0,   31,   32,    0,    0,   57,    0,
    0,   36,   37,   38,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   79,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   80,   81,    0,   82,
   83,   84,   85,   86,   87,   88,   15,   16,    0,   17,
    0,    0,    0,    0,   93,    0,   19,   20,    0,   21,
    0,   22,   58,   58,    0,    0,   58,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   23,
   58,   58,    0,    0,    0,   58,    0,   24,   25,   26,
   27,   28,   29,    0,   30,    0,   31,   32,    0,    0,
   57,    0,    0,   36,   37,   38,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   79,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   80,   81,    0,
   82,   83,   84,   85,   86,   87,   88,   15,   16,    0,
   17,    0,    0,    0,    0,    0,   58,   19,   20,    0,
   21,    0,   22,   56,   56,    0,    0,   56,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   23,   56,   56,    0,    0,    0,   56,    0,   24,   25,
   26,   27,   28,   29,    0,   30,    0,   31,   32,    0,
    0,   57,    0,    0,   36,   37,   38,   93,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   93,
   93,    0,   93,   93,   93,   93,   93,   93,   93,   93,
   93,    0,   93,    0,    0,    0,    0,    0,    0,   93,
   93,    0,   93,    0,   93,   56,    0,   56,   33,    0,
   34,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   93,    0,    0,    0,    0,    0,    0,    0,
   93,   93,   93,   93,   93,   93,    0,   93,    0,   93,
   93,    0,    0,   93,    0,    0,   93,   93,   93,    0,
    0,    0,    0,    0,    0,   58,    0,    0,    0,   58,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   58,   58,   58,    0,    0,   58,    0,    0,    0,
   58,   58,   58,    0,   58,    0,    0,    0,    0,   78,
    0,   58,   58,    0,   58,   13,   58,    0,   33,    0,
   34,    0,   14,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   58,    0,    0,    0,    0,    0,
    0,    0,   58,   58,   58,   58,   58,   58,    0,   58,
    0,   58,   58,    0,    0,   58,    0,    0,   58,   58,
   58,    0,    0,    0,    0,    0,   56,    0,    0,    0,
   56,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   56,   56,   56,    0,    0,   56,    0,    0,
    0,   56,   56,   56,    0,   56,    0,    0,   12,    0,
    0,   13,   56,   56,   33,   56,   34,   56,   14,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   56,    0,    0,    0,    0,
    0,    0,    0,   56,   56,   56,   56,   56,   56,    0,
   56,    0,   56,   56,    0,    0,   56,    0,    0,   56,
   56,   56,   79,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   82,   83,   84,
   85,   86,   87,   88,   15,   16,   56,   17,    0,   33,
    0,   34,    0,    0,   19,   20,    0,   21,    0,   22,
    0,    0,    0,    0,    0,   13,    0,    0,   33,  259,
   34,    0,   14,    0,    0,    0,    0,   23,    0,    0,
    0,    0,    0,    0,  185,   24,   25,   26,   27,   28,
   29,    0,   30,    0,   31,   32,    0,    0,   57,    0,
    0,   36,   37,   38,    0,    0,   10,   11,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   13,  141,    0,
   33,    0,   34,    0,   14,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   15,   16,   56,   17,    0,   33,
    0,   34,    0,   18,   19,   20,    0,   21,    0,   22,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   23,    0,    0,
    0,    0,    0,    0,    0,   24,   25,   26,   27,   28,
   29,    0,   30,    0,   31,   32,    0,  106,   35,    0,
    0,   36,   37,   38,    0,    0,   13,  149,    0,   33,
    0,   34,    0,   14,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   15,   16,    0,   17,    0,  111,    0,    0,    0,    0,
   19,   20,    0,   21,    0,   22,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,  118,  119,   23,    0,    0,    0,    0,    0,    0,
    0,   24,   25,   26,   27,   28,   29,    0,   30,    0,
   31,   32,    0,  257,   35,    0,    0,   36,   37,   38,
    0,    0,    0,    0,   13,   80,   81,   33,  177,   34,
    0,   14,    0,    0,  258,   15,   16,    0,   17,    0,
    0,    0,    0,    0,    0,   19,   20,    0,   21,    0,
   22,    0,    0,    0,   15,   16,    0,   17,    0,    0,
    0,    0,    0,    0,   19,   20,    0,   21,   23,   22,
    0,    0,    0,    0,    0,    0,   24,   25,   26,   27,
   28,   29,    0,   30,    0,   31,   32,   23,    0,   57,
    0,    0,   36,   37,   38,   24,   25,   26,   27,   28,
   29,    0,   30,  257,   31,   32,   15,   16,   35,   17,
    0,   36,   37,   38,    0,   80,   19,   20,    0,   21,
    0,   22,    0,    0,  258,   15,   16,   13,   17,    0,
   33,    0,   34,    0,   14,   19,   20,    0,   21,   23,
   22,    0,    0,    0,    0,    0,    0,   24,   25,   26,
   27,   28,   29,    0,   30,    0,   31,   32,   23,    0,
   35,    0,    0,   36,   37,   38,   24,   25,   26,   27,
   28,   29,    0,   30,    0,   31,   32,    0,    0,   57,
    0,    0,   36,   37,   38,   15,   16,   13,   17,    0,
   33,    0,   34,    0,   14,   19,   20,    0,   21,    0,
   22,    0,    0,    0,    0,    0,  293,    0,    0,   33,
    0,   34,    0,   14,    0,    0,    0,    0,   23,    0,
    0,    0,    0,    0,    0,    0,   24,   25,   26,   27,
   28,   29,    0,   30,    0,   31,   32,    0,    0,   35,
    0,    0,   36,   37,   38,    0,    0,  166,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   15,   16,    0,   17,    0,    0,    0,
    0,    0,    0,   19,   20,    0,   21,  293,   22,    0,
   33,    0,   34,    0,   14,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   23,    0,    0,    0,
    0,    0,    0,    0,   24,   25,   26,   27,   28,   29,
    0,   30,    0,   31,   32,    0,    0,   35,    0,    0,
   36,   37,   38,    0,    0,    0,    0,    0,    0,  293,
    0,    0,   33,    0,   34,    0,   14,    0,    0,    0,
  168,    0,    0,    0,    0,    0,    0,    0,   56,    0,
    0,   33,    0,   34,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   15,   16,    0,   17,
    0,    0,    0,    0,    0,    0,   19,   20,    0,   21,
    0,   22,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   23,
  218,    0,    0,    0,    0,    0,    0,   24,   25,   26,
   27,   28,   29,    0,   30,    0,   31,   32,    0,  166,
   35,    0,    0,   36,   37,   38,   15,   16,   13,   17,
    0,   33,    0,   34,    0,   14,   19,   20,    0,   21,
    0,   22,    0,    0,    0,   15,   16,   56,   17,    0,
   33,    0,   34,    0,   14,   19,   20,    0,   21,   23,
   22,    0,    0,    0,    0,    0,    0,   24,   25,   26,
   27,   28,   29,    0,   30,    0,   31,   32,   23,    0,
   35,    0,    0,   36,   37,   38,   24,   25,   26,   27,
   28,   29,    0,   30,    0,   31,   32,    0,    0,   35,
  168,    0,   36,   37,   38,    0,    0,   56,    0,    0,
   33,    0,   34,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   15,   16,    0,   17,
    0,    0,    0,    0,    0,    0,   19,   20,    0,   21,
    0,   22,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  218,    0,    0,    0,    0,    0,    0,   23,
    0,    0,    0,    0,    0,    0,    0,   24,   25,   26,
   27,   28,   29,    0,   30,  257,   31,   32,   15,   16,
   35,   17,    0,   36,   37,   38,    0,  207,   19,   20,
   33,   21,   34,   22,   14,    0,  258,   15,   16,    0,
   17,    0,    0,    0,    0,    0,    0,   19,   20,    0,
   21,   23,   22,    0,    0,    0,    0,    0,    0,   24,
   25,   26,   27,   28,   29,    0,   30,    0,   31,   32,
   23,    0,   35,    0,    0,   36,   37,   38,   24,   25,
   26,   27,   28,   29,    0,   30,    0,   31,   32,    0,
    0,   57,    0,    0,   36,   37,   38,  293,    0,    0,
   33,    0,   34,    0,   14,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   26,   15,   16,   26,
   17,   26,    0,   26,    0,    0,    0,   19,   20,    0,
   21,    0,   22,    0,    0,    0,   15,   16,    0,   17,
    0,    0,    0,    0,    0,    0,   19,   20,    0,   21,
   23,   22,    0,    0,    0,    0,    0,    0,   24,   25,
   26,   27,   28,   29,    0,   30,    0,   31,   32,   23,
    0,   35,    0,    0,   36,   37,   38,   24,   25,   26,
   27,   28,   29,    0,   30,    0,   31,   32,    0,    0,
   35,    0,    0,   36,   37,   38,   15,   16,   56,   17,
    0,   33,    0,   34,    0,    0,   19,   20,    0,   21,
    0,   22,    0,    0,    0,    0,    0,    0,    0,    0,
  170,    0,    0,    0,    0,    0,    0,    0,    0,   23,
    0,    0,    0,    0,    0,    0,    0,   24,   25,   26,
   27,   28,   29,    0,   30,    0,   31,   32,    0,    0,
   57,    0,    0,   36,   37,   38,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   15,   16,    0,   17,
    0,    0,    0,    0,    0,    0,   19,   20,    0,   21,
    0,   22,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   23,
    0,    0,    0,    0,    0,    0,    0,   24,   25,   26,
   27,   28,   29,    0,   30,    0,   31,   32,    0,    0,
   35,    0,    0,   36,   37,   38,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   15,   16,    0,   17,
    0,    0,    0,    0,    0,    0,   19,   20,    0,   21,
    0,   22,    0,    0,    0,   26,   26,    0,   26,    0,
    0,    0,    0,    0,    0,   26,   26,    0,   26,   23,
   26,    0,    0,    0,    0,    0,    0,   24,   25,   26,
   27,   28,   29,    0,   30,    0,   31,   32,   26,    0,
   35,    0,    0,   36,   37,   38,   26,   26,   26,   26,
   26,   26,    0,   26,    0,   26,   26,    0,    0,   26,
    0,    0,   26,   26,   26,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   15,   16,    0,
   17,    0,    0,    0,    0,    0,    0,   19,   20,    0,
   21,    0,   22,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   23,    0,    0,    0,    0,    0,    0,    0,   24,   25,
   26,   27,   28,   29,    0,   30,    0,   31,   32,    0,
    0,   57,    0,    0,   36,   37,   38,
};
short yycheck[] = {                                      37,
    0,   37,   59,   59,   42,   43,   42,   45,   41,   47,
   59,   47,   41,    7,  124,   41,   10,   11,   99,   91,
  263,   79,   50,   51,   35,  110,   59,  108,  113,   59,
   59,  116,  117,   59,   88,  120,  289,   37,  123,   44,
   40,   41,   42,   43,   44,   45,   41,   47,   42,   41,
   41,   65,   66,  123,  336,   41,    0,  111,   58,   59,
   59,   44,    0,   63,   59,   40,  207,   59,   59,  346,
  347,   40,  100,   59,  132,  357,   40,  330,   40,  332,
   40,  247,  286,  249,  108,  289,   40,  330,    0,   41,
   40,  105,   44,   93,  192,    0,   41,   41,  124,   44,
   44,   91,  130,   47,  185,  190,   44,  101,   44,   47,
   93,  196,   40,  330,   58,   59,  333,  336,  123,   63,
  131,   59,   41,  123,  124,   37,  330,  331,  332,   41,
   42,   43,   44,   45,  313,   47,   41,   40,  192,   44,
   59,   93,   47,    0,  348,  345,   58,   59,   93,   93,
    0,   63,  293,   58,   59,   41,  322,   93,   44,   41,
   41,  185,   44,   44,  286,  337,  220,  346,  347,  227,
  228,  281,   41,  263,  284,   44,   58,   59,  232,  123,
   40,   93,    0,  349,   41,  123,   41,   44,   93,   44,
   47,   41,  263,   41,   44,  361,   44,   47,   40,  257,
  256,   58,   59,  284,  258,  124,  263,  263,   58,   59,
   40,  123,  124,   63,  263,  288,  288,   41,  123,   37,
   44,   47,   40,   41,   42,   43,   44,   45,  242,   47,
  263,  285,   41,  263,  263,   44,   93,  263,  336,  320,
   58,   59,  124,   93,  238,   63,  257,  330,  259,  323,
  261,  262,  263,  263,  282,  281,  267,  315,  284,  357,
  284,  261,  262,  263,  263,   44,  123,  267,  263,  350,
  324,  263,  263,  123,  359,   93,   91,  263,  313,  279,
  280,  281,  282,  283,  284,  285,  286,  287,  288,  289,
  290,   41,  292,   59,   44,  263,  320,  263,  298,  299,
  300,   41,  302,  331,  304,  123,  124,  345,   41,  345,
  341,  346,  347,  313,  308,  326,  263,  261,  262,  263,
   41,  288,  322,  261,  262,  263,  350,   41,   40,    0,
  330,  331,  332,  333,  334,  335,  280,  337,   59,  339,
  340,   41,  289,  343,  263,  345,  346,  347,  348,  261,
  262,  263,   41,   41,  298,  267,  261,  262,  263,    0,
  298,   41,  281,   41,   44,  284,   44,  279,  280,  281,
  282,  283,  284,  285,  286,  287,  288,  289,  290,   41,
  292,  263,   44,  330,   59,  332,  298,  299,  300,  123,
  302,   41,  304,  298,  179,  101,  289,   44,   -1,  281,
   -1,  313,  284,  124,  261,  262,  263,   52,   53,   -1,
  322,  261,  262,  263,   41,   -1,   -1,   44,  330,  331,
  332,  333,  334,  335,   -1,  337,   -1,  339,  340,  279,
  280,  343,   59,  345,  346,  347,  348,  330,  331,  332,
   -1,  298,   -1,  261,  262,  263,   -1,   -1,  298,  267,
   41,   -1,   -1,   44,  208,  348,   -1,   -1,   -1,   -1,
   -1,  279,  280,  281,  282,  283,  284,  285,   59,  287,
  288,  289,  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,
  298,  299,  300,   -1,  302,   -1,  304,  337,   -1,   41,
   -1,   -1,   44,   -1,    0,  313,   -1,  124,   -1,   -1,
   -1,  146,  147,   -1,  322,   -1,   58,   59,  153,  154,
   -1,   63,  330,  331,  332,  333,  334,  335,  208,  337,
   -1,  339,  340,   -1,   -1,  343,   -1,  345,  346,  347,
  348,   37,   -1,  124,   40,   41,   42,   43,   44,   45,
  294,   47,  263,  297,  298,  299,  300,   -1,   41,   -1,
  304,   44,   58,   59,   -1,   -1,   -1,   63,   -1,   -1,
  281,   -1,   -1,  284,  209,   58,   59,   -1,   -1,  214,
  215,   -1,  124,   -1,   -1,   41,   -1,   -1,   44,  263,
   -1,  226,    0,   -1,   -1,   -1,   -1,   93,  342,   -1,
   -1,   -1,   58,   59,   -1,   -1,  257,   63,  259,   -1,
  261,  262,  263,   -1,  294,  289,  267,  297,  298,  299,
  300,  256,   -1,   -1,  304,   -1,   -1,  123,  124,   37,
   -1,   -1,   40,   41,   42,   43,   44,   45,   -1,   47,
   -1,  124,   -1,   -1,  279,  280,  263,   -1,   -1,   -1,
   58,   59,   -1,   -1,    0,   63,  330,  331,  332,   -1,
   -1,   -1,  342,   -1,  281,   -1,   -1,  284,  124,   -1,
  305,  306,   -1,   -1,  348,  326,   -1,   -1,   -1,   -1,
   -1,   -1,  263,   -1,   -1,   93,    0,   -1,   -1,   -1,
  325,   -1,   -1,   -1,   -1,   41,   -1,   -1,   44,   -1,
  281,   47,   -1,  284,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   58,   59,   -1,  123,  124,   63,   -1,   -1,
   -1,  263,   -1,   37,   -1,   -1,   40,   41,   42,   43,
   44,   45,   -1,   47,   -1,   -1,   -1,  279,  280,  281,
   -1,   -1,  284,   -1,   58,   59,   -1,   93,   -1,   63,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  261,  262,  263,   -1,   -1,
   -1,  267,   -1,   -1,   -1,   -1,   -1,  123,   -1,   93,
  263,   -1,   -1,  279,  280,  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,  337,  292,   -1,  281,   -1,
   -1,  284,  298,  299,  300,   -1,  302,  263,  304,  123,
  124,   -1,   -1,   -1,   -1,   -1,   -1,  313,   -1,   -1,
   -1,   -1,   -1,  279,  280,  281,  322,   -1,  284,   -1,
   -1,   -1,   -1,   -1,  330,  331,  332,  333,  334,  335,
   -1,  337,   -1,  339,  340,   41,   -1,  343,   44,   -1,
  346,  347,  348,  261,  262,  263,   -1,   -1,   -1,  267,
   -1,   -1,   58,   59,   -1,   -1,   -1,   63,   -1,   -1,
   -1,  279,  280,  281,  282,  283,  284,  285,  286,  287,
  288,  289,  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,
  298,  299,  300,   -1,  302,   -1,  304,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  313,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  322,  261,  262,  263,   -1,   -1,
   -1,   -1,  330,  331,  332,  333,  334,  335,  124,  337,
   -1,  339,  340,  279,  280,  343,   -1,   -1,  346,  347,
  348,   -1,   -1,   -1,   -1,   -1,   -1,  261,  262,  263,
   -1,   -1,  298,  267,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  279,  280,  281,  282,  283,
  284,  285,  286,  287,  288,  289,  290,   -1,  292,   -1,
   -1,   -1,   -1,   -1,  298,  299,  300,   -1,  302,   -1,
  304,  337,   -1,  125,   -1,  127,   -1,   -1,    0,  313,
   -1,  133,  134,   -1,   -1,   -1,   -1,   -1,  322,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,  333,
  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,  343,
   -1,   -1,  346,  347,  348,   37,   -1,   -1,   40,   41,
   42,   43,   44,   45,   -1,   47,   -1,   -1,  180,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   58,   59,   -1,   -1,
   -1,   63,   -1,   -1,   -1,   -1,   -1,  263,   -1,   -1,
   -1,  203,   -1,  205,  206,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  280,  281,    0,   -1,  284,   -1,
   -1,   93,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  251,
   -1,  123,  124,   37,   -1,   -1,   40,   41,   42,   43,
   44,   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   58,   59,   -1,   -1,    0,   63,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   93,
    0,   -1,   -1,   -1,   -1,   -1,  318,   -1,   -1,   41,
   -1,   -1,   44,   -1,   -1,   47,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   58,   59,   -1,  123,
  124,   63,   -1,  345,   -1,   -1,   -1,   37,   -1,  351,
   40,   41,   42,   43,   44,   45,   -1,   47,  360,   -1,
   -1,   -1,   -1,  365,   -1,   -1,   -1,   -1,   58,   59,
   -1,   93,   -1,   63,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  261,
  262,  263,   -1,   -1,   -1,  267,   -1,   -1,   -1,   -1,
   -1,  123,   -1,   93,   -1,   -1,   -1,  279,  280,  281,
  282,  283,  284,  285,  286,  287,  288,  289,  290,   -1,
  292,   -1,   -1,   -1,   -1,   -1,  298,  299,  300,   -1,
  302,   -1,  304,  123,  124,   -1,   -1,   -1,   -1,   -1,
   -1,  313,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  322,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,
  332,  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,
   -1,  343,   -1,   -1,  346,  347,  348,  261,  262,  263,
   -1,   -1,   -1,  267,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  279,  280,  281,  282,  283,
  284,  285,  286,  287,  288,  289,  290,   -1,  292,   -1,
   -1,   -1,   -1,   -1,  298,  299,  300,   -1,  302,   -1,
  304,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  313,
   -1,   -1,   40,   -1,   -1,   43,   -1,   45,  322,  261,
  262,  263,   -1,   -1,   -1,   -1,  330,  331,  332,  333,
  334,  335,   -1,  337,   -1,  339,  340,  279,  280,  343,
   -1,   -1,  346,  347,  348,   -1,   -1,   -1,   -1,   -1,
   -1,  261,  262,  263,   -1,   -1,  298,  267,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  279,
  280,  281,  282,  283,  284,  285,  286,  287,  288,  289,
  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,  298,  299,
  300,   -1,  302,   -1,  304,  337,  124,   -1,   -1,   -1,
   -1,   -1,    0,  313,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  322,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  330,  331,  332,  333,  334,  335,   -1,  337,   -1,  339,
  340,   -1,   -1,  343,   -1,   -1,  346,  347,  348,   37,
   -1,   -1,   40,   41,   42,   43,   44,   45,   -1,   47,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   58,   59,   -1,   -1,   -1,   63,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
    0,   -1,   -1,   -1,   -1,   93,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  123,  124,   37,   -1,   -1,
   40,   41,   42,   43,   44,   45,   -1,   47,   -1,  267,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   58,   59,
   -1,  279,   -1,   63,  282,  283,  284,  285,  286,  287,
  288,  289,  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,
   -1,  299,  300,   -1,  302,   -1,  304,   -1,   -1,   -1,
   -1,   -1,   -1,   93,    0,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  322,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  330,  331,  332,  333,  334,  335,   -1,  337,
   -1,  339,  340,  123,  124,  343,   -1,   -1,  346,  347,
  348,   37,   -1,   -1,   40,   41,   42,   43,   44,   45,
   -1,   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   58,   59,   -1,   -1,   -1,   63,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  261,  262,  263,   -1,   -1,   -1,  267,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   93,   -1,   -1,
   -1,  279,  280,  281,  282,  283,  284,  285,  286,  287,
  288,  289,  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,
  298,  299,  300,   -1,  302,   -1,  304,  123,  124,   -1,
   -1,   -1,   -1,   -1,   -1,  313,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  322,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  330,  331,  332,  333,  334,  335,   -1,  337,
   -1,  339,  340,   -1,   -1,  343,   -1,   -1,  346,  347,
  348,  261,  262,  263,   -1,    0,   -1,  267,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  279,
  280,  281,  282,  283,  284,  285,  286,  287,  288,  289,
  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,  298,  299,
  300,   -1,  302,   -1,  304,   40,   41,   -1,   43,   44,
   45,   -1,   -1,  313,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  322,   58,   59,   -1,   -1,   -1,   63,   -1,
  330,  331,  332,  333,  334,  335,   -1,  337,   -1,  339,
  340,   -1,   -1,  343,   -1,  345,   -1,   -1,  348,   -1,
   -1,   -1,   -1,   -1,   -1,  261,  262,  263,   93,    0,
   -1,  267,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  279,  280,   -1,  282,  283,  284,  285,
  286,  287,  288,  289,  290,   -1,  292,   -1,  123,  124,
   -1,   -1,  298,  299,  300,   -1,  302,   -1,  304,   40,
   41,   -1,   43,   44,   45,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  322,   58,   59,   -1,
   -1,   -1,   63,   -1,  330,  331,  332,  333,  334,  335,
   -1,  337,   -1,  339,  340,   -1,   -1,  343,   -1,  345,
   -1,   -1,  348,   -1,   -1,   -1,   -1,    0,   -1,   -1,
   -1,   -1,   93,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  123,  124,   -1,   -1,   -1,   40,   41,   -1,
   -1,   44,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   58,   59,   -1,   -1,   -1,
   63,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  261,  262,  263,   -1,
   -1,   -1,  267,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   93,   -1,   -1,   -1,  279,  280,  281,  282,  283,  284,
  285,  286,  287,  288,  289,  290,   -1,  292,   -1,   -1,
   -1,   -1,   -1,  298,  299,  300,   -1,  302,   -1,  304,
  123,  124,   -1,   -1,   -1,   -1,   -1,   -1,  313,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  330,  331,  332,  333,  334,
  335,   -1,  337,   -1,  339,  340,   -1,   -1,  343,   -1,
   -1,  346,  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,
  261,  262,  263,   -1,   -1,   -1,  267,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  279,  280,
  281,  282,  283,  284,  285,  286,  287,  288,  289,  290,
   -1,  292,   -1,   -1,   -1,   -1,   -1,  298,  299,  300,
   -1,  302,   -1,  304,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  313,   -1,   -1,   -1,   -1,   40,   -1,   -1,
   43,  322,   45,   -1,   -1,   -1,   -1,   -1,   -1,  330,
  331,  332,  333,  334,  335,   -1,  337,   -1,  339,  340,
   -1,   -1,  343,   -1,   -1,  346,  347,  348,  261,  262,
  263,   -1,    0,   -1,  267,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  279,  280,  281,  282,
  283,  284,  285,  286,  287,  288,  289,  290,   -1,  292,
   -1,   -1,   -1,   -1,   -1,  298,  299,  300,   -1,  302,
   -1,  304,   40,   41,   -1,   -1,   44,   -1,   -1,   -1,
  313,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,
   58,   59,   -1,   -1,    0,   63,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,
  343,   -1,   -1,  346,  347,  348,   -1,   -1,   -1,   -1,
    0,   -1,   -1,   -1,   -1,   93,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   41,   -1,   -1,   44,   -1,
   -1,   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   58,   59,   -1,  123,  124,   63,   -1,   -1,
   40,   41,   -1,   -1,   44,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   58,   59,
   -1,   -1,   -1,   63,   -1,   -1,   -1,   93,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   93,    0,   -1,   -1,  123,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  123,  124,   -1,  289,  290,   -1,  292,
   -1,   -1,   -1,   -1,   40,   41,  299,  300,   44,  302,
   -1,  304,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   58,   59,   -1,   -1,   -1,   63,   -1,  322,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,
  333,  334,  335,  261,  262,  263,  339,  340,   -1,  267,
  343,   -1,   -1,  346,  347,  348,   -1,   93,   -1,   -1,
   -1,  279,  280,  281,  282,  283,  284,  285,  286,  287,
  288,  289,  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,
  298,  299,  300,   -1,  302,   -1,  304,  123,  124,   -1,
   -1,   -1,   -1,   -1,   -1,  313,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  322,  261,  262,  263,   -1,   -1,
   -1,   -1,  330,  331,  332,  333,  334,  335,   -1,  337,
   -1,  339,  340,  279,  280,  343,   -1,   -1,  346,  347,
  348,  261,  262,  263,   -1,    0,   -1,  267,   -1,   -1,
   -1,   -1,  298,   -1,   -1,   -1,   -1,   -1,   -1,  279,
  280,  281,  282,  283,  284,  285,  286,  287,  288,  289,
  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,  298,  299,
  300,   -1,  302,   -1,  304,   40,   41,   -1,   -1,   44,
   -1,  337,   -1,  313,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  322,   58,   59,   -1,   -1,   -1,   63,   -1,
  330,  331,  332,  333,  334,  335,   -1,  337,   -1,  339,
  340,   -1,   -1,  343,   -1,   -1,  346,  347,  348,   -1,
   -1,   -1,   -1,   -1,   -1,  261,  262,  263,   93,    0,
   -1,  267,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  279,  280,  281,  282,  283,  284,  285,
  286,  287,  288,  289,  290,   -1,  292,   -1,  123,  124,
   -1,   -1,  298,  299,  300,   -1,  302,   -1,  304,   40,
   41,   -1,   -1,   44,   -1,   -1,   -1,  313,   -1,   -1,
   -1,    0,   -1,   -1,   -1,   -1,  322,   58,   59,   -1,
   -1,   -1,   63,   -1,  330,  331,  332,  333,  334,  335,
   -1,  337,   -1,  339,  340,   -1,   -1,  343,   -1,   -1,
  346,  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   40,   93,   -1,   43,   -1,   45,   -1,   47,   -1,
   -1,   -1,   -1,    0,   -1,   -1,   -1,   -1,   -1,   -1,
   59,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  123,  124,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   40,   -1,   -1,   43,   -1,   45,   -1,
   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   59,   -1,   -1,   -1,  261,  262,  263,   -1,
    0,   -1,  267,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  279,  280,   -1,  282,  283,  284,
  285,  286,  287,  288,  289,  290,   -1,  292,   -1,   -1,
   -1,   -1,   -1,  298,  299,  300,   -1,  302,   -1,  304,
   40,   -1,   -1,   43,   -1,   45,   -1,   47,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  330,  331,  332,  333,  334,
  335,   -1,  337,   -1,  339,  340,   -1,   -1,  343,   -1,
   -1,  346,  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,
  261,  262,  263,   -1,    0,   -1,  267,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  279,  280,
   -1,  282,  283,  284,  285,  286,  287,  288,  289,  290,
   -1,  292,   -1,  123,   -1,   -1,   -1,  298,  299,  300,
   -1,  302,   -1,  304,   40,   -1,   -1,   43,   -1,   45,
   -1,   47,  261,  262,  263,   -1,   -1,   -1,   -1,   -1,
   -1,  322,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  330,
  331,  332,  333,  334,  335,   -1,  337,   -1,  339,  340,
  289,  290,  343,  292,   -1,  346,  347,  348,   -1,  298,
  299,  300,   -1,  302,   -1,  304,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  261,  262,  263,   -1,   -1,   -1,
   -1,   -1,   -1,  322,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  330,  331,  332,  333,  334,  335,  123,  337,   -1,
  339,  340,  289,  290,  343,  292,   -1,  346,  347,  348,
   -1,  298,  299,  300,   -1,  302,   -1,  304,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  322,   -1,   -1,   -1,   -1,
   -1,  261,  262,  330,  331,  332,  333,  334,  335,   -1,
  337,   -1,  339,  340,   -1,   -1,  343,   -1,   -1,  346,
  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  289,
  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,  298,  299,
  300,   -1,  302,   -1,  304,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  322,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  330,  331,  332,  333,  334,  335,   -1,  337,   -1,  339,
  340,   -1,   -1,  343,   -1,   -1,  346,  347,  348,   -1,
   -1,   -1,   -1,   -1,   -1,  261,  262,   -1,   -1,   -1,
    0,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  289,  290,   -1,  292,   -1,   -1,   -1,
   -1,   -1,  298,  299,  300,   -1,  302,   37,  304,   -1,
   40,   41,   42,   43,   44,   45,   -1,   47,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,   58,   59,
   -1,   -1,    0,   63,  330,  331,  332,  333,  334,  335,
   -1,  337,   -1,  339,  340,   -1,   -1,  343,   -1,   -1,
  346,  347,  348,   -1,   -1,   -1,   -1,    0,   -1,   -1,
   -1,   -1,   -1,   93,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   41,   -1,   -1,   44,   -1,   -1,   47,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   58,   59,   -1,  123,  124,   63,   -1,   40,   41,   -1,
   43,   44,   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   58,   59,   -1,   -1,    0,
   63,   -1,   -1,   -1,   -1,   93,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,    0,   -1,
   93,   -1,   -1,   -1,   -1,  123,   -1,   -1,   -1,   -1,
   41,   -1,   -1,   44,   -1,   -1,   47,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   58,   59,   -1,
  123,  124,   63,   -1,   -1,   -1,   -1,   -1,   -1,   41,
   -1,   -1,   44,   -1,   -1,   47,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   40,   58,   59,   43,   -1,
   45,   63,   93,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   58,   -1,   -1,   -1,   -1,   63,   -1,
   -1,  261,  262,  263,   -1,   -1,   -1,  267,   -1,   -1,
   -1,   93,  123,   -1,   -1,   -1,   -1,   -1,   -1,  279,
  280,  281,  282,  283,  284,  285,   -1,  287,  288,   -1,
  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,  298,  299,
  300,  123,  302,   -1,  304,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  313,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  322,  261,  262,  263,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  333,  334,  335,   -1,  337,   -1,  339,
  340,  279,  280,  343,   -1,  345,  346,  347,  261,  262,
  263,   -1,   -1,   -1,  267,   -1,   -1,   -1,   -1,   -1,
  298,   -1,   -1,   -1,   -1,   -1,  279,  280,   -1,  282,
  283,  284,  285,  286,  287,  288,   -1,  290,   -1,  292,
   -1,   -1,   -1,   -1,   -1,  298,  299,  300,   -1,  302,
   -1,  304,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  337,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,
  261,  262,  263,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  333,  334,  335,   -1,  337,   -1,  339,  340,  279,  280,
  343,   -1,   17,  346,  347,   -1,   -1,   -1,   -1,  261,
  262,  263,   -1,   -1,   -1,   30,   -1,  298,   33,   34,
   35,   36,   37,   38,   39,   -1,   -1,  279,  280,   -1,
   -1,   -1,  267,   -1,   -1,   -1,   -1,   52,   -1,   -1,
   -1,   -1,   57,   -1,  279,  280,  298,   -1,   -1,   -1,
   -1,   -1,   67,  288,  289,  290,  337,  292,   -1,   -1,
   -1,   -1,   -1,   -1,  299,  300,   -1,  302,   -1,  304,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   93,   94,
   95,   96,   97,   98,   -1,  337,   -1,  322,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  330,  331,  332,  333,  334,
  335,   -1,  337,   -1,  339,  340,   -1,  122,  343,   -1,
   -1,  346,  347,  348,   -1,    0,  131,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  142,   -1,  144,
   -1,  146,  147,   -1,   -1,   -1,   -1,  152,  153,  154,
  155,  156,   -1,  158,  159,  160,  161,  162,  163,   -1,
  165,   -1,  167,   -1,  169,  170,   41,   -1,   -1,   44,
   -1,   -1,   47,   -1,   -1,   -1,   -1,  182,   -1,   -1,
   -1,   -1,   -1,   58,   59,  190,   -1,   -1,   63,   -1,
   -1,  196,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  208,   -1,   -1,   -1,   -1,   -1,  214,
   -1,   -1,   -1,   -1,  219,   -1,  221,   -1,   93,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   17,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  247,   -1,  249,   33,   34,   35,  123,   -1,
   38,   39,  257,   -1,  259,   -1,  261,  262,  263,  264,
  265,  266,  267,   -1,   52,   -1,  271,   -1,   -1,   57,
  275,   -1,  277,   -1,   -1,  280,  281,   -1,   -1,   67,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  294,
   -1,   -1,  297,  298,  299,  300,   -1,   -1,   -1,  304,
  305,  306,   -1,   -1,   -1,   93,   94,   95,   96,   97,
   98,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  326,   -1,  328,   -1,  330,   -1,  332,   -1,  334,
   -1,   -1,  337,   -1,  122,   -1,   -1,  342,   -1,   -1,
   -1,   -1,   -1,  131,   -1,   -1,   -1,  352,   -1,   -1,
   -1,   -1,   -1,   -1,  142,   -1,  144,   -1,  146,  147,
   -1,   -1,   -1,   -1,  152,  153,  154,   -1,  156,   -1,
  158,  159,  160,  161,  162,  163,   -1,  165,   -1,  167,
   -1,  169,  170,   -1,   -1,   -1,  261,  262,  263,   -1,
   -1,   -1,   -1,   37,  182,   -1,   40,   -1,   42,   43,
   -1,   45,  190,   47,  279,  280,   -1,   -1,  196,   -1,
   -1,   -1,   -1,   -1,   -1,   59,   -1,   -1,   -1,   63,
  208,   -1,   -1,  298,   -1,   -1,  214,   -1,   -1,   -1,
   -1,  219,   -1,  221,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  247,
   -1,  249,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  257,
   -1,  259,   -1,  261,  262,  263,  264,  265,  266,  267,
  124,   -1,   -1,  271,   -1,   -1,   -1,  275,   -1,  277,
   -1,   -1,  280,  281,    7,   -1,   -1,   -1,   -1,   -1,
   13,   -1,   -1,   -1,   -1,   -1,  294,   -1,   -1,  297,
  298,  299,  300,   -1,   -1,   -1,  304,  305,  306,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  326,   -1,
   -1,   -1,   55,   56,  332,   -1,  334,   -1,   -1,  337,
   63,   64,   65,   66,  342,   -1,   69,   70,   -1,   -1,
   -1,   -1,   -1,   -1,  352,   -1,   79,   -1,   -1,   82,
   83,   84,   85,   86,   87,   -1,   89,   37,   91,   92,
   40,   41,   42,   43,   44,   45,   -1,   47,  101,  102,
   -1,   -1,  105,   -1,   -1,   -1,   -1,   -1,   58,   59,
  113,   -1,   -1,   63,   -1,   -1,   -1,  120,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  132,
   -1,   -1,   -1,  267,  137,   -1,  139,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  279,  280,   -1,  282,  283,
  284,  285,  286,  287,   -1,  289,  290,   -1,  292,   -1,
   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,  302,   -1,
  304,   -1,   -1,   -1,  124,   -1,  179,   -1,   -1,  313,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,
  193,   -1,   -1,   -1,   -1,  198,  330,  331,  332,  333,
  334,  335,   -1,  337,  207,  339,  340,   -1,   -1,  343,
   -1,  345,  346,  347,  348,   40,   41,   -1,   43,   -1,
   45,  224,   47,   -1,  227,  228,   -1,   -1,   -1,   -1,
  233,   -1,  235,   -1,   59,   -1,   -1,   -1,   -1,  242,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  268,  269,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   40,   -1,   -1,   43,   -1,
   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  293,   -1,   -1,   -1,   59,   -1,   -1,   -1,  123,   -1,
  125,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  315,  263,  317,   -1,   -1,  267,  321,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  279,
  280,  281,   -1,   -1,  284,   -1,  339,   -1,  288,  289,
  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,   -1,  299,
  300,   -1,  302,   -1,  304,   -1,   -1,   -1,  123,   -1,
  125,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  322,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  330,  331,  332,  333,  334,  335,   -1,  337,   -1,  339,
  340,   -1,   -1,  343,   -1,  345,   -1,   -1,  348,   40,
   -1,   -1,   43,   -1,   45,   -1,   47,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   59,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  256,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  289,  290,  291,  292,  293,  294,
  295,  296,  297,   -1,  299,  300,  301,  302,   -1,  304,
  305,  306,  123,   -1,  125,   -1,   -1,   -1,   -1,   -1,
   -1,  256,   -1,   -1,   -1,  320,  321,  322,  323,   -1,
   -1,   -1,   -1,   -1,   -1,  330,  331,  332,  333,  334,
  335,   -1,  337,  338,  339,  340,  341,   -1,  343,   -1,
   -1,  346,  347,  348,  289,  290,  291,  292,  293,  294,
  295,  296,  297,   -1,  299,  300,  301,  302,   -1,  304,
  305,  306,   40,   -1,   -1,   43,   -1,   45,   -1,   47,
   -1,   -1,   -1,   -1,   -1,  320,  321,  322,  323,   -1,
   -1,   59,   -1,   -1,   -1,  330,  331,  332,  333,  334,
  335,   -1,  337,  338,  339,  340,  341,   -1,  343,   -1,
   -1,  346,  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   40,   -1,   -1,   43,   -1,   45,   -1,
   47,   -1,   -1,   -1,   -1,  256,   -1,   -1,   -1,   -1,
   -1,   -1,   59,   -1,   -1,  123,   -1,  125,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  289,  290,
  291,  292,  293,  294,  295,  296,  297,   -1,  299,  300,
  301,  302,   -1,  304,  305,  306,   40,   -1,   -1,   43,
   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,  320,
  321,  322,  323,   -1,   -1,   59,  123,   -1,   -1,  330,
  331,  332,  333,  334,  335,   -1,  337,  338,  339,  340,
  341,   -1,  343,   -1,   -1,  346,  347,  348,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   40,   -1,   -1,   43,
   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   59,   -1,   -1,   -1,  123,
   -1,  125,   -1,   -1,   -1,   -1,   -1,   -1,  256,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  289,  290,  291,  292,  293,  294,  295,  296,  297,
   -1,  299,  300,  301,  302,   -1,  304,  305,  306,  123,
   -1,  125,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  256,
   -1,   -1,  320,  321,  322,  323,  263,   -1,   -1,   -1,
   -1,   -1,  330,  331,  332,  333,  334,  335,   -1,  337,
  338,  339,  340,  341,   -1,  343,   -1,   -1,  346,  347,
  348,   -1,  289,  290,  291,  292,  293,  294,  295,  296,
  297,   -1,  299,  300,  301,  302,   -1,  304,  305,  306,
   40,   -1,   -1,   43,   -1,   45,   -1,   47,   -1,   -1,
   -1,   -1,  256,  320,  321,  322,   -1,   -1,   -1,   59,
   -1,   -1,   -1,  330,  331,  332,  333,  334,  335,   -1,
  337,  338,  339,  340,  341,   -1,  343,   -1,   -1,  346,
  347,  348,   -1,   -1,   -1,  289,  290,  291,  292,  293,
  294,  295,  296,  297,   -1,  299,  300,  301,  302,   -1,
  304,  305,  306,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  256,   -1,   -1,   -1,  320,  321,  322,   -1,
   -1,   -1,   -1,  123,   -1,  125,  330,  331,  332,  333,
  334,  335,   -1,  337,  338,  339,  340,  341,   -1,  343,
   -1,   -1,  346,  347,  348,  289,  290,  291,  292,  293,
  294,  295,  296,  297,   -1,  299,  300,  301,  302,   -1,
  304,  305,  306,   40,   -1,   -1,   43,   -1,   45,   -1,
   47,   -1,   -1,   -1,   -1,   -1,  320,  321,  322,   -1,
   -1,   -1,   59,   -1,   -1,   -1,  330,  331,  332,  333,
  334,  335,   -1,  337,  338,  339,  340,  341,   -1,  343,
   -1,   -1,  346,  347,  348,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   40,   -1,   -1,   43,   -1,   45,
   -1,   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   59,   -1,   -1,  123,   -1,  125,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  256,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  289,
  290,  291,  292,  293,  294,  295,  296,  297,   -1,  299,
  300,  301,  302,   -1,  304,  305,  306,  123,   -1,  125,
   40,   -1,   -1,   43,   -1,   45,   -1,   47,   -1,   -1,
  320,  321,  322,   -1,   -1,   -1,   -1,   -1,   -1,   59,
  330,  331,  332,  333,  334,  335,   -1,  337,  338,  339,
  340,  341,   -1,  343,   -1,   -1,  346,  347,  348,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  256,
   -1,   -1,   40,   -1,   -1,   43,   -1,   45,   -1,   47,
   -1,   -1,   -1,  123,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   59,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  289,  290,  291,  292,  293,  294,  295,  296,
  297,   -1,  299,  300,  301,  302,   -1,  304,  305,  306,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  256,   -1,   -1,  320,  321,  322,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  330,  331,  332,  333,  334,  335,   -1,
  337,  338,  339,  340,  341,  123,  343,  125,   -1,  346,
  347,  348,   -1,  289,  290,  291,  292,  293,  294,  295,
  296,  297,   -1,  299,  300,  301,  302,   -1,  304,  305,
  306,   -1,   -1,   -1,   40,   -1,   -1,   43,   -1,   45,
   -1,   47,   -1,   -1,  320,  321,  322,   -1,   -1,   -1,
   -1,   -1,   -1,   59,  330,  331,  332,  333,  334,  335,
   -1,  337,  338,  339,  340,  341,  256,  343,   -1,   -1,
  346,  347,  348,  263,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  289,
  290,  291,  292,  293,  294,  295,  296,  297,   -1,  299,
  300,  301,  302,   -1,  304,  305,  306,  123,   -1,  125,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  320,  321,  322,   -1,   -1,   -1,   -1,   -1,  256,   -1,
  330,  331,  332,  333,  334,  335,   -1,  337,  338,  339,
  340,  341,   -1,  343,   -1,   -1,  346,  347,  348,   -1,
   -1,   40,   -1,   -1,   43,   -1,   45,   -1,   47,   -1,
   -1,  289,  290,  291,  292,  293,  294,  295,  296,  297,
   59,  299,  300,  301,  302,   -1,  304,  305,  306,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  320,  321,  322,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  330,  331,  332,  333,  334,  335,   -1,  337,
  338,  339,  340,  341,   -1,  343,   -1,   -1,  346,  347,
  348,   -1,   -1,   -1,   40,   -1,   -1,   43,   -1,   45,
   -1,   47,   -1,   -1,  123,   -1,  125,   -1,   -1,   -1,
  256,   -1,   -1,   59,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  289,  290,  291,  292,  293,  294,  295,
  296,  297,   -1,  299,  300,  301,  302,   -1,  304,  305,
  306,   40,   -1,   -1,   43,   -1,   45,   -1,   47,   -1,
   -1,   -1,   -1,   -1,  320,  321,  322,  123,   -1,   -1,
   59,   -1,   -1,   -1,  330,  331,  332,  333,  334,  335,
   -1,  337,  338,  339,  340,  341,   -1,  343,   -1,   -1,
  346,  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   40,   -1,   -1,   43,   -1,   45,   -1,   47,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  256,   -1,   -1,
   59,   -1,   -1,   -1,  123,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  289,  290,  291,  292,  293,  294,  295,  296,  297,   -1,
  299,  300,  301,  302,   -1,  304,  305,  306,   40,   -1,
   -1,   43,   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,
   -1,  320,  321,  322,  123,   -1,   -1,   59,   -1,   -1,
  256,  330,  331,  332,  333,  334,  335,   -1,  337,  338,
  339,  340,  341,   -1,  343,   -1,   -1,  346,  347,  348,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  289,  290,  291,  292,  293,  294,  295,
  296,  297,   -1,  299,  300,  301,  302,   -1,  304,  305,
  306,   40,   -1,   -1,   43,   -1,   45,   -1,   47,   -1,
   -1,  123,   -1,   -1,  320,  321,  322,  256,   -1,   -1,
   59,   -1,   -1,   -1,  330,  331,  332,  333,  334,  335,
   -1,  337,  338,  339,  340,  341,   -1,  343,   -1,   -1,
  346,  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  289,  290,  291,  292,  293,  294,  295,  296,  297,   -1,
  299,  300,  301,  302,   -1,  304,  305,  306,   40,   41,
   -1,   43,   -1,   45,   -1,   47,   -1,  256,   -1,   -1,
   -1,  320,  321,  322,  123,   -1,   -1,   -1,   -1,   -1,
   -1,  330,  331,  332,  333,  334,  335,   -1,  337,  338,
  339,  340,  341,   -1,  343,   -1,   -1,  346,  347,  348,
  289,  290,  291,  292,  293,  294,  295,  296,  297,   -1,
  299,  300,  301,  302,   -1,  304,  305,  306,   40,   -1,
   -1,   43,   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,
   -1,  320,  321,  322,  256,   -1,   -1,   59,   -1,   -1,
   -1,  330,  331,  332,  333,  334,  335,   -1,  337,  338,
  339,  340,  341,   -1,  343,   -1,   -1,  346,  347,  348,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  289,  290,  291,
  292,  293,  294,  295,  296,  297,   -1,  299,  300,  301,
  302,   -1,  304,  305,  306,   40,   -1,   -1,   43,   -1,
   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,  320,  321,
  322,  123,   -1,   -1,   59,   -1,   -1,  256,  330,  331,
  332,  333,  334,  335,   -1,  337,  338,  339,  340,  341,
   -1,  343,   -1,   -1,  346,  347,  348,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  289,  290,  291,  292,  293,  294,  295,  296,  297,   -1,
  299,  300,  301,  302,   -1,  304,  305,  306,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  123,   -1,
   -1,  320,  321,  322,  256,   -1,   -1,   -1,   -1,   -1,
   -1,  330,  331,  332,  333,  334,  335,   -1,  337,  338,
  339,  340,  341,   -1,  343,   -1,   -1,  346,  347,  348,
   -1,   40,   41,   -1,   43,   44,   45,  289,  290,   -1,
  292,   -1,  294,   -1,   -1,   -1,   -1,  299,  300,   -1,
  302,   -1,  304,   -1,   63,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  256,   -1,   -1,   -1,  320,  321,
  322,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,
  332,  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,
   -1,  343,   -1,   -1,  346,  347,  348,  289,  290,  291,
  292,  293,  294,  295,  296,  297,   -1,  299,  300,  301,
  302,   -1,  304,  305,  306,  124,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  320,  321,
  322,  256,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,
  332,  333,  334,  335,   -1,  337,  338,  339,  340,  341,
   -1,  343,   -1,   -1,  346,  347,  348,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  289,  290,  291,  292,  293,  294,
  295,  296,  297,   -1,  299,  300,  301,  302,   -1,  304,
  305,  306,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  320,  321,  322,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  330,  331,  332,  333,  334,
  335,   -1,  337,  338,  339,  340,  341,   -1,  343,   -1,
   -1,  346,  347,  348,   40,   -1,   -1,   43,   -1,   45,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   59,   -1,   -1,   -1,   63,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  267,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  279,  280,   -1,  282,  283,  284,  285,  286,  287,  288,
  289,  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,   -1,
  299,  300,   -1,  302,   -1,  304,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   40,   41,  124,   43,
   44,   45,   -1,  322,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  330,  331,  332,  333,  334,  335,   -1,  337,   63,
  339,  340,   -1,   -1,  343,   -1,   -1,  346,  347,  348,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   40,   41,   -1,
   43,   44,   45,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  124,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   63,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  263,   -1,   -1,
   -1,  267,   40,   41,   -1,   43,   44,   45,   -1,   -1,
   -1,  124,   -1,  279,  280,   -1,  282,  283,  284,  285,
  286,  287,  288,  289,  290,   63,  292,   -1,   -1,   -1,
   -1,   -1,   -1,  299,  300,   -1,  302,   -1,  304,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  330,  331,  332,  333,  334,  335,
   -1,  337,   -1,  339,  340,   -1,   -1,  343,   -1,   -1,
  346,  347,  348,  267,   40,   41,  124,   43,   -1,   45,
   -1,   -1,   -1,   -1,   -1,  279,  280,   -1,  282,  283,
  284,  285,  286,  287,  288,  289,  290,   63,  292,   -1,
   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,  302,   -1,
  304,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,  333,
  334,  335,   -1,  337,  267,  339,  340,   -1,   -1,  343,
   -1,   -1,  346,  347,  348,   -1,  279,  280,  124,  282,
  283,  284,  285,  286,  287,  288,  289,  290,   -1,  292,
   -1,   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,  302,
   40,  304,   -1,   43,   44,   45,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,
   -1,   -1,   -1,   63,   -1,   -1,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,  267,
  343,   -1,   -1,  346,  347,  348,   -1,   -1,   -1,   -1,
   -1,  279,  280,   -1,  282,  283,  284,  285,  286,  287,
  288,  289,  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,
   -1,  299,  300,   -1,  302,   40,  304,   -1,   43,   -1,
   45,   -1,   -1,   -1,  124,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   58,  322,   -1,   -1,   -1,   63,   -1,
   -1,   -1,  330,  331,  332,  333,  334,  335,   -1,  337,
   -1,  339,  340,   -1,   -1,  343,   -1,   -1,  346,  347,
  348,  267,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  279,  280,   -1,  282,  283,  284,  285,
  286,  287,  288,  289,  290,   -1,  292,   -1,   -1,   -1,
   -1,   -1,   -1,  299,  300,   -1,  302,   -1,  304,  124,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   40,   41,   -1,
   43,   -1,   45,   -1,   -1,   -1,  322,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  330,  331,  332,  333,  334,  335,
   63,  337,   -1,  339,  340,   -1,   -1,  343,   -1,   -1,
  346,  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  267,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  279,
  280,   -1,  282,  283,  284,  285,  286,  287,  288,  289,
  290,  124,  292,   -1,   -1,   -1,   -1,   -1,   -1,  299,
  300,   -1,  302,   -1,  304,   40,   41,   -1,   43,   -1,
   45,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  322,   -1,   -1,   -1,   -1,   -1,   63,   -1,
  330,  331,  332,  333,  334,  335,   -1,  337,   -1,  339,
  340,   -1,  267,  343,   -1,   -1,  346,  347,  348,   -1,
   -1,   -1,   -1,   -1,  279,  280,   -1,  282,  283,  284,
  285,  286,  287,  288,  289,  290,   -1,  292,   -1,   -1,
   -1,   -1,   -1,   -1,  299,  300,   -1,  302,   -1,  304,
   40,   41,   -1,   43,   -1,   45,   -1,   -1,   -1,  124,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,   -1,
   -1,   -1,   -1,   63,   -1,  330,  331,  332,  333,  334,
  335,   -1,  337,   -1,  339,  340,   -1,   -1,  343,   -1,
   -1,  346,  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  267,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  279,  280,   -1,  282,
  283,  284,  285,  286,  287,  288,  289,  290,   -1,  292,
   -1,   -1,   -1,   -1,  124,   -1,  299,  300,   -1,  302,
   -1,  304,   40,   41,   -1,   43,   -1,   45,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,
   -1,   -1,   -1,   -1,   -1,   63,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,
  343,   -1,   -1,  346,  347,  348,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  267,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  279,  280,   -1,  282,  283,  284,
  285,  286,  287,  288,  289,  290,  124,  292,   -1,   -1,
   -1,   -1,   -1,   -1,  299,  300,   -1,  302,   -1,  304,
   40,   41,   -1,   43,   -1,   45,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,   -1,
   -1,   -1,   -1,   63,   -1,  330,  331,  332,  333,  334,
  335,   -1,  337,   -1,  339,  340,   -1,  267,  343,   -1,
   -1,  346,  347,  348,   -1,   -1,   -1,   -1,   -1,  279,
  280,   -1,  282,  283,  284,  285,  286,  287,  288,  289,
  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,   -1,  299,
  300,   -1,  302,   -1,  304,   40,   -1,   -1,   43,   -1,
   45,   -1,   -1,   -1,  124,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  322,   -1,   59,   -1,   -1,   -1,   63,   -1,
  330,  331,  332,  333,  334,  335,   -1,  337,   -1,  339,
  340,   -1,   -1,  343,   -1,   -1,  346,  347,  348,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  267,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  279,  280,   -1,  282,  283,  284,  285,  286,  287,
  288,  289,  290,   -1,  292,   -1,   -1,   -1,   -1,  124,
   -1,  299,  300,   -1,  302,   -1,  304,   40,   41,   -1,
   43,   -1,   45,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  322,   -1,   -1,   -1,   -1,   -1,
   63,   -1,  330,  331,  332,  333,  334,  335,   -1,  337,
   -1,  339,  340,   -1,   -1,  343,   -1,   -1,  346,  347,
  348,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  267,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  279,
  280,   -1,  282,  283,  284,  285,  286,  287,  288,  289,
  290,  124,  292,   -1,   -1,   -1,   -1,   -1,   40,  299,
  300,   43,  302,   45,  304,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   63,  322,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  330,  331,  332,  333,  334,  335,   -1,  337,   -1,  339,
  340,   -1,  267,  343,   -1,   -1,  346,  347,  348,   -1,
   -1,   -1,   -1,   -1,  279,  280,   -1,  282,  283,  284,
  285,  286,  287,  288,  289,  290,   -1,  292,   -1,   -1,
   -1,   -1,   -1,   -1,  299,  300,   -1,  302,   -1,  304,
   40,   -1,  124,   43,   -1,   45,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,   -1,
   -1,   -1,   -1,   63,   -1,  330,  331,  332,  333,  334,
  335,   -1,  337,   -1,  339,  340,   -1,   -1,  343,   -1,
   -1,  346,  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  267,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  279,  280,   -1,  282,
  283,  284,  285,  286,  287,  288,  289,  290,   -1,  292,
   -1,   -1,   -1,   -1,  124,   -1,  299,  300,   -1,  302,
   -1,  304,   40,   41,   -1,   -1,   44,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,
   58,   59,   -1,   -1,   -1,   63,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,
  343,   -1,   -1,  346,  347,  348,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  267,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  279,  280,   -1,
  282,  283,  284,  285,  286,  287,  288,  289,  290,   -1,
  292,   -1,   -1,   -1,   -1,   -1,  124,  299,  300,   -1,
  302,   -1,  304,   40,   41,   -1,   -1,   44,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  322,   58,   59,   -1,   -1,   -1,   63,   -1,  330,  331,
  332,  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,
   -1,  343,   -1,   -1,  346,  347,  348,  267,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  279,
  280,   -1,  282,  283,  284,  285,  286,  287,  288,  289,
  290,   -1,  292,   -1,   -1,   -1,   -1,   -1,   -1,  299,
  300,   -1,  302,   -1,  304,   40,   -1,  124,   43,   -1,
   45,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  322,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  330,  331,  332,  333,  334,  335,   -1,  337,   -1,  339,
  340,   -1,   -1,  343,   -1,   -1,  346,  347,  348,   -1,
   -1,   -1,   -1,   -1,   -1,  263,   -1,   -1,   -1,  267,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  279,  280,  281,   -1,   -1,  284,   -1,   -1,   -1,
  288,  289,  290,   -1,  292,   -1,   -1,   -1,   -1,  124,
   -1,  299,  300,   -1,  302,   40,  304,   -1,   43,   -1,
   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  322,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  330,  331,  332,  333,  334,  335,   -1,  337,
   -1,  339,  340,   -1,   -1,  343,   -1,   -1,  346,  347,
  348,   -1,   -1,   -1,   -1,   -1,  263,   -1,   -1,   -1,
  267,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  279,  280,  281,   -1,   -1,  284,   -1,   -1,
   -1,  288,  289,  290,   -1,  292,   -1,   -1,  123,   -1,
   -1,   40,  299,  300,   43,  302,   45,  304,   47,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  322,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  330,  331,  332,  333,  334,  335,   -1,
  337,   -1,  339,  340,   -1,   -1,  343,   -1,   -1,  346,
  347,  348,  267,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  282,  283,  284,
  285,  286,  287,  288,  289,  290,   40,  292,   -1,   43,
   -1,   45,   -1,   -1,  299,  300,   -1,  302,   -1,  304,
   -1,   -1,   -1,   -1,   -1,   40,   -1,   -1,   43,   63,
   45,   -1,   47,   -1,   -1,   -1,   -1,  322,   -1,   -1,
   -1,   -1,   -1,   -1,   59,  330,  331,  332,  333,  334,
  335,   -1,  337,   -1,  339,  340,   -1,   -1,  343,   -1,
   -1,  346,  347,  348,   -1,   -1,  261,  262,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   40,   41,   -1,
   43,   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  289,  290,   40,  292,   -1,   43,
   -1,   45,   -1,  298,  299,  300,   -1,  302,   -1,  304,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,  330,  331,  332,  333,  334,
  335,   -1,  337,   -1,  339,  340,   -1,  256,  343,   -1,
   -1,  346,  347,  348,   -1,   -1,   40,   41,   -1,   43,
   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  289,  290,   -1,  292,   -1,  294,   -1,   -1,   -1,   -1,
  299,  300,   -1,  302,   -1,  304,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  320,  321,  322,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  330,  331,  332,  333,  334,  335,   -1,  337,   -1,
  339,  340,   -1,  267,  343,   -1,   -1,  346,  347,  348,
   -1,   -1,   -1,   -1,   40,  279,  280,   43,  263,   45,
   -1,   47,   -1,   -1,  288,  289,  290,   -1,  292,   -1,
   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,  302,   -1,
  304,   -1,   -1,   -1,  289,  290,   -1,  292,   -1,   -1,
   -1,   -1,   -1,   -1,  299,  300,   -1,  302,  322,  304,
   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,  333,
  334,  335,   -1,  337,   -1,  339,  340,  322,   -1,  343,
   -1,   -1,  346,  347,  348,  330,  331,  332,  333,  334,
  335,   -1,  337,  267,  339,  340,  289,  290,  343,  292,
   -1,  346,  347,  348,   -1,  279,  299,  300,   -1,  302,
   -1,  304,   -1,   -1,  288,  289,  290,   40,  292,   -1,
   43,   -1,   45,   -1,   47,  299,  300,   -1,  302,  322,
  304,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,  322,   -1,
  343,   -1,   -1,  346,  347,  348,  330,  331,  332,  333,
  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,  343,
   -1,   -1,  346,  347,  348,  289,  290,   40,  292,   -1,
   43,   -1,   45,   -1,   47,  299,  300,   -1,  302,   -1,
  304,   -1,   -1,   -1,   -1,   -1,   40,   -1,   -1,   43,
   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,  322,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,  333,
  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,  343,
   -1,   -1,  346,  347,  348,   -1,   -1,  263,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  289,  290,   -1,  292,   -1,   -1,   -1,
   -1,   -1,   -1,  299,  300,   -1,  302,   40,  304,   -1,
   43,   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  322,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  330,  331,  332,  333,  334,  335,
   -1,  337,   -1,  339,  340,   -1,   -1,  343,   -1,   -1,
  346,  347,  348,   -1,   -1,   -1,   -1,   -1,   -1,   40,
   -1,   -1,   43,   -1,   45,   -1,   47,   -1,   -1,   -1,
  263,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   40,   -1,
   -1,   43,   -1,   45,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  289,  290,   -1,  292,
   -1,   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,  302,
   -1,  304,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,
  263,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,  263,
  343,   -1,   -1,  346,  347,  348,  289,  290,   40,  292,
   -1,   43,   -1,   45,   -1,   47,  299,  300,   -1,  302,
   -1,  304,   -1,   -1,   -1,  289,  290,   40,  292,   -1,
   43,   -1,   45,   -1,   47,  299,  300,   -1,  302,  322,
  304,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,  322,   -1,
  343,   -1,   -1,  346,  347,  348,  330,  331,  332,  333,
  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,  343,
  263,   -1,  346,  347,  348,   -1,   -1,   40,   -1,   -1,
   43,   -1,   45,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  289,  290,   -1,  292,
   -1,   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,  302,
   -1,  304,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  263,   -1,   -1,   -1,   -1,   -1,   -1,  322,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,  267,  339,  340,  289,  290,
  343,  292,   -1,  346,  347,  348,   -1,   40,  299,  300,
   43,  302,   45,  304,   47,   -1,  288,  289,  290,   -1,
  292,   -1,   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,
  302,  322,  304,   -1,   -1,   -1,   -1,   -1,   -1,  330,
  331,  332,  333,  334,  335,   -1,  337,   -1,  339,  340,
  322,   -1,  343,   -1,   -1,  346,  347,  348,  330,  331,
  332,  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,
   -1,  343,   -1,   -1,  346,  347,  348,   40,   -1,   -1,
   43,   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   40,  289,  290,   43,
  292,   45,   -1,   47,   -1,   -1,   -1,  299,  300,   -1,
  302,   -1,  304,   -1,   -1,   -1,  289,  290,   -1,  292,
   -1,   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,  302,
  322,  304,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,
  332,  333,  334,  335,   -1,  337,   -1,  339,  340,  322,
   -1,  343,   -1,   -1,  346,  347,  348,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,
  343,   -1,   -1,  346,  347,  348,  289,  290,   40,  292,
   -1,   43,   -1,   45,   -1,   -1,  299,  300,   -1,  302,
   -1,  304,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  313,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,
  343,   -1,   -1,  346,  347,  348,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  289,  290,   -1,  292,
   -1,   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,  302,
   -1,  304,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  322,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,
  343,   -1,   -1,  346,  347,  348,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  289,  290,   -1,  292,
   -1,   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,  302,
   -1,  304,   -1,   -1,   -1,  289,  290,   -1,  292,   -1,
   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,  302,  322,
  304,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,  332,
  333,  334,  335,   -1,  337,   -1,  339,  340,  322,   -1,
  343,   -1,   -1,  346,  347,  348,  330,  331,  332,  333,
  334,  335,   -1,  337,   -1,  339,  340,   -1,   -1,  343,
   -1,   -1,  346,  347,  348,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  289,  290,   -1,
  292,   -1,   -1,   -1,   -1,   -1,   -1,  299,  300,   -1,
  302,   -1,  304,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  322,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  330,  331,
  332,  333,  334,  335,   -1,  337,   -1,  339,  340,   -1,
   -1,  343,   -1,   -1,  346,  347,  348,
};
# 2442 "y.tab.c"
int yydebug;
int yynerrs;
int yyerrflag;
int yychar;
short *yyssp;
YYSTYPE *yyvsp;
YYSTYPE yyval;
YYSTYPE yylval;
short yyss[500];
YYSTYPE yyvs[500];
# 453 "awkgram.y"
void setfname(Cell *p)
{
	if (((p)->tval & 020))
		SYNTAX("%s is an array, not a function", p->nval);
	else if (((p)->tval & 040))
		SYNTAX("you can't define function %s more than once", p->nval);
	curfname = p->nval;
}

int constnode(Node *p)
{
	return ((p)->ntype == 1) && ((Cell *) (p->narg[0]))->csub == 5;
}

char *strnode(Node *p)
{
	return ((Cell *)(p->narg[0]))->sval;
}

Node *notnull(Node *n)
{
	switch (n->nobj) {
	case 285: case 286: case 282: case 287: case 284: case 283:
	case 280: case 279: case 343:
		return n;
	default:
		return op2(287, n, nullnode);
	}
}

void checkdup(Node *vl, Cell *cp)
{
	char *s = cp->nval;
	for ( ; vl; vl = vl->nnext) {
		if (strcmp(s, ((Cell *)(vl->narg[0]))->nval) == 0) {
			SYNTAX("duplicate argument %s", s);
			break;
		}
	}
}
# 2500 "y.tab.c"
int
yyparse()
{
    register int yym, yyn, yystate;












    yynerrs = 0;
    yyerrflag = 0;
    yychar = (-1);

    yyssp = yyss;
    yyvsp = yyvs;
    *yyssp = yystate = 0;

yyloop:
    if (yyn = yydefred[yystate]) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = yylex()) < 0) yychar = 0;










    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= 9557 && yycheck[yyn] == yychar)
    {





        if (yyssp >= yyss + 500 - 1)
        {
            goto yyoverflow;
        }
        *++yyssp = yystate = yytable[yyn];
        *++yyvsp = yylval;
        yychar = (-1);
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= 9557 && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;



yynewerror:
    yyerror("syntax error");



yyerrlab:
    ++yynerrs;
yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yyssp]) && (yyn += 256) >= 0 &&
                    yyn <= 9557 && yycheck[yyn] == 256)
            {





                if (yyssp >= yyss + 500 - 1)
                {
                    goto yyoverflow;
                }
                *++yyssp = yystate = yytable[yyn];
                *++yyvsp = yylval;
                goto yyloop;
            }
            else
            {





                if (yyssp <= yyss) goto yyabort;
                --yyssp;
                --yyvsp;
            }
        }
    }
    else
    {
        if (yychar == 0) goto yyabort;










        yychar = (-1);
        goto yyloop;
    }
yyreduce:





    yym = yylen[yyn];
    yyval = yyvsp[1-yym];
    switch (yyn)
    {
case 1:
# 104 "awkgram.y"
{ if (errorflag==0)
			winner = (Node *)stat3(258, beginloc, yyvsp[0].p, endloc); }
break;
case 2:
# 106 "awkgram.y"
{ (yychar=(-1)); bracecheck(); SYNTAX("bailing out"); }
break;
case 13:
# 130 "awkgram.y"
{inloop++;}
break;
case 14:
# 131 "awkgram.y"
{ --inloop; yyval.p = stat4(297, yyvsp[-9].p, notnull(yyvsp[-6].p), yyvsp[-3].p, yyvsp[0].p); }
break;
case 15:
# 132 "awkgram.y"
{inloop++;}
break;
case 16:
# 133 "awkgram.y"
{ --inloop; yyval.p = stat4(297, yyvsp[-7].p, ((Node *) 0), yyvsp[-3].p, yyvsp[0].p); }
break;
case 17:
# 134 "awkgram.y"
{inloop++;}
break;
case 18:
# 135 "awkgram.y"
{ --inloop; yyval.p = stat3(288, yyvsp[-5].p, makearr(yyvsp[-3].p), yyvsp[0].p); }
break;
case 19:
# 139 "awkgram.y"
{ setfname(yyvsp[0].cp); }
break;
case 20:
# 140 "awkgram.y"
{ setfname(yyvsp[0].cp); }
break;
case 21:
# 144 "awkgram.y"
{ yyval.p = notnull(yyvsp[-1].p); }
break;
case 26:
# 156 "awkgram.y"
{ yyval.i = 0; }
break;
case 28:
# 161 "awkgram.y"
{ yyval.i = 0; }
break;
case 30:
# 167 "awkgram.y"
{ yyval.p = 0; }
break;
case 32:
# 172 "awkgram.y"
{ yyval.p = 0; }
break;
case 33:
# 173 "awkgram.y"
{ yyval.p = yyvsp[-1].p; }
break;
case 34:
# 177 "awkgram.y"
{ yyval.p = notnull(yyvsp[0].p); }
break;
case 35:
# 181 "awkgram.y"
{ yyval.p = stat2(259, yyvsp[0].p, stat2(320, rectonode(), ((Node *) 0))); }
break;
case 36:
# 182 "awkgram.y"
{ yyval.p = stat2(259, yyvsp[-3].p, yyvsp[-1].p); }
break;
case 37:
# 183 "awkgram.y"
{ yyval.p = pa2stat(yyvsp[-3].p, yyvsp[0].p, stat2(320, rectonode(), ((Node *) 0))); }
break;
case 38:
# 184 "awkgram.y"
{ yyval.p = pa2stat(yyvsp[-6].p, yyvsp[-3].p, yyvsp[-1].p); }
break;
case 39:
# 185 "awkgram.y"
{ yyval.p = stat2(259, ((Node *) 0), yyvsp[-1].p); }
break;
case 40:
# 187 "awkgram.y"
{ beginloc = linkum(beginloc, yyvsp[-1].p); yyval.p = 0; }
break;
case 41:
# 189 "awkgram.y"
{ endloc = linkum(endloc, yyvsp[-1].p); yyval.p = 0; }
break;
case 42:
# 190 "awkgram.y"
{infunc++;}
break;
case 43:
# 191 "awkgram.y"
{ infunc--; curfname=0; defn((Cell *)yyvsp[-7].p, yyvsp[-5].p, yyvsp[-1].p); yyval.p = 0; }
break;
case 45:
# 196 "awkgram.y"
{ yyval.p = linkum(yyvsp[-2].p, yyvsp[0].p); }
break;
case 47:
# 201 "awkgram.y"
{ yyval.p = linkum(yyvsp[-2].p, yyvsp[0].p); }
break;
case 48:
# 205 "awkgram.y"
{ yyval.p = op2(yyvsp[-1].i, yyvsp[-2].p, yyvsp[0].p); }
break;
case 49:
# 207 "awkgram.y"
{ yyval.p = op3(325, notnull(yyvsp[-4].p), yyvsp[-2].p, yyvsp[0].p); }
break;
case 50:
# 209 "awkgram.y"
{ yyval.p = op2(280, notnull(yyvsp[-2].p), notnull(yyvsp[0].p)); }
break;
case 51:
# 211 "awkgram.y"
{ yyval.p = op2(279, notnull(yyvsp[-2].p), notnull(yyvsp[0].p)); }
break;
case 52:
# 212 "awkgram.y"
{ yyval.p = op3(yyvsp[-1].i, ((Node *) 0), yyvsp[-2].p, (Node*)makedfa(yyvsp[0].s, 0)); }
break;
case 53:
# 214 "awkgram.y"
{ if (constnode(yyvsp[0].p))
			yyval.p = op3(yyvsp[-1].i, ((Node *) 0), yyvsp[-2].p, (Node*)makedfa(strnode(yyvsp[0].p), 0));
		  else
			yyval.p = op3(yyvsp[-1].i, (Node *)1, yyvsp[-2].p, yyvsp[0].p); }
break;
case 54:
# 218 "awkgram.y"
{ yyval.p = op2(324, yyvsp[-2].p, makearr(yyvsp[0].p)); }
break;
case 55:
# 219 "awkgram.y"
{ yyval.p = op2(324, yyvsp[-3].p, makearr(yyvsp[0].p)); }
break;
case 56:
# 220 "awkgram.y"
{ yyval.p = op2(342, yyvsp[-1].p, yyvsp[0].p); }
break;
case 59:
# 226 "awkgram.y"
{ yyval.p = op2(yyvsp[-1].i, yyvsp[-2].p, yyvsp[0].p); }
break;
case 60:
# 228 "awkgram.y"
{ yyval.p = op3(325, notnull(yyvsp[-4].p), yyvsp[-2].p, yyvsp[0].p); }
break;
case 61:
# 230 "awkgram.y"
{ yyval.p = op2(280, notnull(yyvsp[-2].p), notnull(yyvsp[0].p)); }
break;
case 62:
# 232 "awkgram.y"
{ yyval.p = op2(279, notnull(yyvsp[-2].p), notnull(yyvsp[0].p)); }
break;
case 63:
# 233 "awkgram.y"
{ yyval.p = op2(yyvsp[-1].i, yyvsp[-2].p, yyvsp[0].p); }
break;
case 64:
# 234 "awkgram.y"
{ yyval.p = op2(yyvsp[-1].i, yyvsp[-2].p, yyvsp[0].p); }
break;
case 65:
# 235 "awkgram.y"
{ yyval.p = op2(yyvsp[-1].i, yyvsp[-2].p, yyvsp[0].p); }
break;
case 66:
# 236 "awkgram.y"
{ yyval.p = op2(yyvsp[-1].i, yyvsp[-2].p, yyvsp[0].p); }
break;
case 67:
# 237 "awkgram.y"
{ yyval.p = op2(yyvsp[-1].i, yyvsp[-2].p, yyvsp[0].p); }
break;
case 68:
# 238 "awkgram.y"
{ yyval.p = op2(yyvsp[-1].i, yyvsp[-2].p, yyvsp[0].p); }
break;
case 69:
# 239 "awkgram.y"
{ yyval.p = op3(yyvsp[-1].i, ((Node *) 0), yyvsp[-2].p, (Node*)makedfa(yyvsp[0].s, 0)); }
break;
case 70:
# 241 "awkgram.y"
{ if (constnode(yyvsp[0].p))
			yyval.p = op3(yyvsp[-1].i, ((Node *) 0), yyvsp[-2].p, (Node*)makedfa(strnode(yyvsp[0].p), 0));
		  else
			yyval.p = op3(yyvsp[-1].i, (Node *)1, yyvsp[-2].p, yyvsp[0].p); }
break;
case 71:
# 245 "awkgram.y"
{ yyval.p = op2(324, yyvsp[-2].p, makearr(yyvsp[0].p)); }
break;
case 72:
# 246 "awkgram.y"
{ yyval.p = op2(324, yyvsp[-3].p, makearr(yyvsp[0].p)); }
break;
case 73:
# 247 "awkgram.y"
{
			if (safe) SYNTAX("cmd | getline is unsafe");
			else yyval.p = op3(337, yyvsp[0].p, itonp(yyvsp[-2].i), yyvsp[-3].p); }
break;
case 74:
# 250 "awkgram.y"
{
			if (safe) SYNTAX("cmd | getline is unsafe");
			else yyval.p = op3(337, (Node*)0, itonp(yyvsp[-1].i), yyvsp[-2].p); }
break;
case 75:
# 253 "awkgram.y"
{ yyval.p = op2(342, yyvsp[-1].p, yyvsp[0].p); }
break;
case 78:
# 259 "awkgram.y"
{ yyval.p = linkum(yyvsp[-2].p, yyvsp[0].p); }
break;
case 79:
# 260 "awkgram.y"
{ yyval.p = linkum(yyvsp[-2].p, yyvsp[0].p); }
break;
case 81:
# 265 "awkgram.y"
{ yyval.p = linkum(yyvsp[-2].p, yyvsp[0].p); }
break;
case 82:
# 269 "awkgram.y"
{ yyval.p = rectonode(); }
break;
case 84:
# 271 "awkgram.y"
{ yyval.p = yyvsp[-1].p; }
break;
case 93:
# 288 "awkgram.y"
{ yyval.p = op3(265, ((Node *) 0), rectonode(), (Node*)makedfa(yyvsp[0].s, 0)); }
break;
case 94:
# 289 "awkgram.y"
{ yyval.p = op1(343, notnull(yyvsp[0].p)); }
break;
case 95:
# 293 "awkgram.y"
{startreg();}
break;
case 96:
# 293 "awkgram.y"
{ yyval.s = yyvsp[-1].s; }
break;
case 99:
# 301 "awkgram.y"
{
			if (safe) SYNTAX("print | is unsafe");
			else yyval.p = stat3(yyvsp[-3].i, yyvsp[-2].p, itonp(yyvsp[-1].i), yyvsp[0].p); }
break;
case 100:
# 304 "awkgram.y"
{
			if (safe) SYNTAX("print >> is unsafe");
			else yyval.p = stat3(yyvsp[-3].i, yyvsp[-2].p, itonp(yyvsp[-1].i), yyvsp[0].p); }
break;
case 101:
# 307 "awkgram.y"
{
			if (safe) SYNTAX("print > is unsafe");
			else yyval.p = stat3(yyvsp[-3].i, yyvsp[-2].p, itonp(yyvsp[-1].i), yyvsp[0].p); }
break;
case 102:
# 310 "awkgram.y"
{ yyval.p = stat3(yyvsp[-1].i, yyvsp[0].p, ((Node *) 0), ((Node *) 0)); }
break;
case 103:
# 311 "awkgram.y"
{ yyval.p = stat2(294, makearr(yyvsp[-3].p), yyvsp[-1].p); }
break;
case 104:
# 312 "awkgram.y"
{ yyval.p = stat2(294, makearr(yyvsp[0].p), 0); }
break;
case 105:
# 313 "awkgram.y"
{ yyval.p = exptostat(yyvsp[0].p); }
break;
case 106:
# 314 "awkgram.y"
{ (yychar=(-1)); SYNTAX("illegal statement"); }
break;
case 109:
# 323 "awkgram.y"
{ if (!inloop) SYNTAX("break illegal outside of loops");
				  yyval.p = stat1(291, ((Node *) 0)); }
break;
case 110:
# 325 "awkgram.y"
{  if (!inloop) SYNTAX("continue illegal outside of loops");
				  yyval.p = stat1(293, ((Node *) 0)); }
break;
case 111:
# 327 "awkgram.y"
{inloop++;}
break;
case 112:
# 327 "awkgram.y"
{--inloop;}
break;
case 113:
# 328 "awkgram.y"
{ yyval.p = stat2(295, yyvsp[-6].p, notnull(yyvsp[-2].p)); }
break;
case 114:
# 329 "awkgram.y"
{ yyval.p = stat1(296, yyvsp[-1].p); }
break;
case 115:
# 330 "awkgram.y"
{ yyval.p = stat1(296, ((Node *) 0)); }
break;
case 117:
# 332 "awkgram.y"
{ yyval.p = stat3(301, yyvsp[-3].p, yyvsp[-2].p, yyvsp[0].p); }
break;
case 118:
# 333 "awkgram.y"
{ yyval.p = stat3(301, yyvsp[-1].p, yyvsp[0].p, ((Node *) 0)); }
break;
case 119:
# 334 "awkgram.y"
{ yyval.p = yyvsp[-1].p; }
break;
case 120:
# 335 "awkgram.y"
{ if (infunc)
				SYNTAX("next is illegal inside a function");
			  yyval.p = stat1(305, ((Node *) 0)); }
break;
case 121:
# 338 "awkgram.y"
{ if (infunc)
				SYNTAX("nextfile is illegal inside a function");
			  yyval.p = stat1(306, ((Node *) 0)); }
break;
case 122:
# 341 "awkgram.y"
{ yyval.p = stat1(338, yyvsp[-1].p); }
break;
case 123:
# 342 "awkgram.y"
{ yyval.p = stat1(338, ((Node *) 0)); }
break;
case 125:
# 344 "awkgram.y"
{inloop++;}
break;
case 126:
# 344 "awkgram.y"
{ --inloop; yyval.p = stat2(341, yyvsp[-2].p, yyvsp[0].p); }
break;
case 127:
# 345 "awkgram.y"
{ yyval.p = 0; }
break;
case 129:
# 350 "awkgram.y"
{ yyval.p = linkum(yyvsp[-1].p, yyvsp[0].p); }
break;
case 132:
# 358 "awkgram.y"
{ yyval.p = op2(317, yyvsp[-3].p, yyvsp[0].p); }
break;
case 133:
# 359 "awkgram.y"
{ yyval.p = op2(307, yyvsp[-2].p, yyvsp[0].p); }
break;
case 134:
# 360 "awkgram.y"
{ yyval.p = op2(308, yyvsp[-2].p, yyvsp[0].p); }
break;
case 135:
# 361 "awkgram.y"
{ yyval.p = op2(309, yyvsp[-2].p, yyvsp[0].p); }
break;
case 136:
# 362 "awkgram.y"
{ yyval.p = op2(310, yyvsp[-2].p, yyvsp[0].p); }
break;
case 137:
# 363 "awkgram.y"
{ yyval.p = op2(311, yyvsp[-2].p, yyvsp[0].p); }
break;
case 138:
# 364 "awkgram.y"
{ yyval.p = op2(345, yyvsp[-2].p, yyvsp[0].p); }
break;
case 139:
# 365 "awkgram.y"
{ yyval.p = op1(344, yyvsp[0].p); }
break;
case 140:
# 366 "awkgram.y"
{ yyval.p = yyvsp[0].p; }
break;
case 141:
# 367 "awkgram.y"
{ yyval.p = op1(343, notnull(yyvsp[0].p)); }
break;
case 142:
# 368 "awkgram.y"
{ yyval.p = op2(290, itonp(yyvsp[-2].i), rectonode()); }
break;
case 143:
# 369 "awkgram.y"
{ yyval.p = op2(290, itonp(yyvsp[-3].i), yyvsp[-1].p); }
break;
case 144:
# 370 "awkgram.y"
{ yyval.p = op2(290, itonp(yyvsp[0].i), rectonode()); }
break;
case 145:
# 371 "awkgram.y"
{ yyval.p = op2(333, celltonode(yyvsp[-2].cp,2), ((Node *) 0)); }
break;
case 146:
# 372 "awkgram.y"
{ yyval.p = op2(333, celltonode(yyvsp[-3].cp,2), yyvsp[-1].p); }
break;
case 147:
# 373 "awkgram.y"
{ yyval.p = op1(292, yyvsp[0].p); }
break;
case 148:
# 374 "awkgram.y"
{ yyval.p = op1(329, yyvsp[0].p); }
break;
case 149:
# 375 "awkgram.y"
{ yyval.p = op1(327, yyvsp[0].p); }
break;
case 150:
# 376 "awkgram.y"
{ yyval.p = op1(328, yyvsp[-1].p); }
break;
case 151:
# 377 "awkgram.y"
{ yyval.p = op1(326, yyvsp[-1].p); }
break;
case 152:
# 378 "awkgram.y"
{ yyval.p = op3(337, yyvsp[-2].p, itonp(yyvsp[-1].i), yyvsp[0].p); }
break;
case 153:
# 379 "awkgram.y"
{ yyval.p = op3(337, ((Node *) 0), itonp(yyvsp[-1].i), yyvsp[0].p); }
break;
case 154:
# 380 "awkgram.y"
{ yyval.p = op3(337, yyvsp[0].p, ((Node *) 0), ((Node *) 0)); }
break;
case 155:
# 381 "awkgram.y"
{ yyval.p = op3(337, ((Node *) 0), ((Node *) 0), ((Node *) 0)); }
break;
case 156:
# 383 "awkgram.y"
{ yyval.p = op2(302, yyvsp[-3].p, yyvsp[-1].p); }
break;
case 157:
# 385 "awkgram.y"
{ SYNTAX("index() doesn't permit regular expressions");
		  yyval.p = op2(302, yyvsp[-3].p, (Node*)yyvsp[-1].s); }
break;
case 158:
# 387 "awkgram.y"
{ yyval.p = yyvsp[-1].p; }
break;
case 159:
# 389 "awkgram.y"
{ yyval.p = op3(304, ((Node *) 0), yyvsp[-3].p, (Node*)makedfa(yyvsp[-1].s, 1)); }
break;
case 160:
# 391 "awkgram.y"
{ if (constnode(yyvsp[-1].p))
			yyval.p = op3(304, ((Node *) 0), yyvsp[-3].p, (Node*)makedfa(strnode(yyvsp[-1].p), 1));
		  else
			yyval.p = op3(304, (Node *)1, yyvsp[-3].p, yyvsp[-1].p); }
break;
case 161:
# 395 "awkgram.y"
{ yyval.p = celltonode(yyvsp[0].cp, 5); }
break;
case 162:
# 397 "awkgram.y"
{ yyval.p = op4(339, yyvsp[-5].p, makearr(yyvsp[-3].p), yyvsp[-1].p, (Node*)335); }
break;
case 163:
# 399 "awkgram.y"
{ yyval.p = op4(339, yyvsp[-5].p, makearr(yyvsp[-3].p), (Node*)makedfa(yyvsp[-1].s, 1), (Node *)336); }
break;
case 164:
# 401 "awkgram.y"
{ yyval.p = op4(339, yyvsp[-3].p, makearr(yyvsp[-1].p), ((Node *) 0), (Node*)335); }
break;
case 165:
# 402 "awkgram.y"
{ yyval.p = op1(yyvsp[-3].i, yyvsp[-1].p); }
break;
case 166:
# 403 "awkgram.y"
{ yyval.p = celltonode(yyvsp[0].cp, 5); }
break;
case 167:
# 405 "awkgram.y"
{ yyval.p = op4(yyvsp[-5].i, ((Node *) 0), (Node*)makedfa(yyvsp[-3].s, 1), yyvsp[-1].p, rectonode()); }
break;
case 168:
# 407 "awkgram.y"
{ if (constnode(yyvsp[-3].p))
			yyval.p = op4(yyvsp[-5].i, ((Node *) 0), (Node*)makedfa(strnode(yyvsp[-3].p), 1), yyvsp[-1].p, rectonode());
		  else
			yyval.p = op4(yyvsp[-5].i, (Node *)1, yyvsp[-3].p, yyvsp[-1].p, rectonode()); }
break;
case 169:
# 412 "awkgram.y"
{ yyval.p = op4(yyvsp[-7].i, ((Node *) 0), (Node*)makedfa(yyvsp[-5].s, 1), yyvsp[-3].p, yyvsp[-1].p); }
break;
case 170:
# 414 "awkgram.y"
{ if (constnode(yyvsp[-5].p))
			yyval.p = op4(yyvsp[-7].i, ((Node *) 0), (Node*)makedfa(strnode(yyvsp[-5].p), 1), yyvsp[-3].p, yyvsp[-1].p);
		  else
			yyval.p = op4(yyvsp[-7].i, (Node *)1, yyvsp[-5].p, yyvsp[-3].p, yyvsp[-1].p); }
break;
case 171:
# 419 "awkgram.y"
{ yyval.p = op3(340, yyvsp[-5].p, yyvsp[-3].p, yyvsp[-1].p); }
break;
case 172:
# 421 "awkgram.y"
{ yyval.p = op3(340, yyvsp[-3].p, yyvsp[-1].p, ((Node *) 0)); }
break;
case 175:
# 427 "awkgram.y"
{ yyval.p = op2(264, makearr(yyvsp[-3].p), yyvsp[-1].p); }
break;
case 176:
# 428 "awkgram.y"
{ yyval.p = op1(348, celltonode(yyvsp[0].cp, 2)); }
break;
case 177:
# 429 "awkgram.y"
{ yyval.p = op1(348, yyvsp[0].p); }
break;
case 178:
# 433 "awkgram.y"
{ arglist = yyval.p = 0; }
break;
case 179:
# 434 "awkgram.y"
{ arglist = yyval.p = celltonode(yyvsp[0].cp,2); }
break;
case 180:
# 435 "awkgram.y"
{
			checkdup(yyvsp[-2].p, yyvsp[0].cp);
			arglist = yyval.p = linkum(yyvsp[-2].p,celltonode(yyvsp[0].cp,2)); }
break;
case 181:
# 441 "awkgram.y"
{ yyval.p = celltonode(yyvsp[0].cp, 2); }
break;
case 182:
# 442 "awkgram.y"
{ yyval.p = op1(289, itonp(yyvsp[0].i)); }
break;
case 183:
# 443 "awkgram.y"
{ yyval.p = op1(332, (Node *) yyvsp[0].cp); }
break;
case 184:
# 448 "awkgram.y"
{ yyval.p = notnull(yyvsp[-1].p); }
break;
# 3232 "y.tab.c"
    }
    yyssp -= yym;
    yystate = *yyssp;
    yyvsp -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {





        yystate = 4;
        *++yyssp = 4;
        *++yyvsp = yyval;
        if (yychar < 0)
        {
            if ((yychar = yylex()) < 0) yychar = 0;










        }
        if (yychar == 0) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= 9557 && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];





    if (yyssp >= yyss + 500 - 1)
    {
        goto yyoverflow;
    }
    *++yyssp = yystate;
    *++yyvsp = yyval;
    goto yyloop;
yyoverflow:
    yyerror("yacc stack overflow");
yyabort:
    return (1);
yyaccept:
    return (0);
}
