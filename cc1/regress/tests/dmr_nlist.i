# 1 "nlist.c"

# 15 "/home/charles/xcc/include/sys/tahoe.h"
typedef long            __blkcnt_t;
typedef long            __blksize_t;
typedef unsigned long   __dev_t;
typedef unsigned        __gid_t;
typedef unsigned long   __ino_t;
typedef unsigned        __mode_t;
typedef unsigned long   __nlink_t;
typedef long            __off_t;
typedef int             __pid_t;
typedef unsigned long   __size_t;
typedef long            __ssize_t;
typedef unsigned        __uid_t;
typedef char            *__va_list;
# 18 "/home/charles/xcc/include/stdio.h"
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

















extern FILE *__iotab[20];
extern FILE __stdin, __stdout, __stderr;








extern int __fillbuf(FILE *);
extern int __flushbuf(int, FILE *);

extern void clearerr(FILE *);
extern int fclose(FILE *);
extern int fflush(FILE *);
extern int fileno(FILE *);
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
# 29 "/home/charles/xcc/include/stdlib.h"
extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void __exit(int);
extern void exit(int);

extern void free(void *);
extern char *getenv(const char *);
extern void *malloc(size_t);
extern float strtof(const char *, char **);
extern double strtod(const char *, char **);
extern long strtol(const char *, char **, int);
extern unsigned long strtoul(const char *, char **, int);

extern void qsort(void *, size_t, size_t,
                  int (*compar)(const void *, const void *));



extern int rand(void);
extern void srand(unsigned);
# 20 "/home/charles/xcc/include/string.h"
extern void *memchr(const void *, int, size_t);
extern int memcmp(const void *, const void *, size_t);
extern void *memcpy(void *, const void *, size_t);
extern void *memmove(void *, const void *, size_t);
extern void *memset(void *, int, size_t);
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
# 16 "cpp.h"
typedef unsigned char uchar;


enum toktype { END, UNCLASS, NAME, NUMBER, STRING, CCON, NL, WS, DSHARP,
		EQ, NEQ, LEQ, GEQ, LSH, RSH, LAND, LOR, PPLUS, MMINUS,
		ARROW, SBRA, SKET, LP, RP, DOT, AND, STAR, PLUS, MINUS,
		TILDE, NOT, SLASH, PCT, LT, GT, CIRC, OR, QUEST,
		COLON, ASGN, COMMA, SHARP, SEMIC, CBRA, CKET,
		ASPLUS, ASMINUS, ASSTAR, ASSLASH, ASPCT, ASCIRC, ASLSH,
		ASRSH, ASOR, ASAND, ELLIPS,
		DSHARP1, NAME1, DEFINED, UMINUS };

enum kwtype { KIF, KIFDEF, KIFNDEF, KELIF, KELSE, KENDIF, KINCLUDE, KDEFINE,
		KUNDEF, KLINE, KERROR, KPRAGMA, KDEFINED,
		KLINENO, KFILE, KDATE, KTIME, KSTDC, KEVAL };










typedef struct token {
	unsigned char	type;
	unsigned char 	flag;
	unsigned short	hideset;
	unsigned int	wslen;
	unsigned int	len;
	uchar	*t;
} Token;

typedef struct tokenrow {
	Token	*tp;		
	Token	*bp;		
	Token	*lp;		
	int	max;		
} Tokenrow;

typedef struct source {
	char	*filename;	
	int	line;		
	int	lineinc;	
	uchar	*inb;		
	uchar	*inp;		
	uchar	*inl;		
	FILE*	fd;		
	int	ifdepth;	
	struct	source *next;	
} Source;

typedef struct nlist {
	struct nlist *next;
	uchar	*name;
	int	len;
	Tokenrow *vp;		
	Tokenrow *ap;		
	char	val;		
	char	flag;		
} Nlist;

typedef	struct	includelist {
	char	deleted;
	char	always;
	char	*file;
} Includelist;




extern	unsigned long namebit[077+1];

enum errtype { WARNING, ERROR, FATAL };

void	expandlex(void);
void	fixlex(void);
void	setup(int, char **);
int	gettokens(Tokenrow *, int);
int	comparetokens(Tokenrow *, Tokenrow *);
Source	*setsource(char *, FILE *, char *);
void	unsetsource(void);
void	puttokens(Tokenrow *);
void	process(Tokenrow *);
void	*domalloc(int);
void	dofree(void *);
void	error(enum errtype, char *, ...);
void	flushout(void);
int	fillbuf(Source *);
int	trigraph(Source *);
int	foldline(Source *);
Nlist	*lookup(Token *, int);
void	control(Tokenrow *);
void	dodefine(Tokenrow *);
void	doadefine(Tokenrow *, int);
void	doinclude(Tokenrow *);
void	doif(Tokenrow *, enum kwtype);
void	expand(Tokenrow *, Nlist *);
void	builtin(Tokenrow *, int);
int	gatherargs(Tokenrow *, Tokenrow **, int *);
void	substargs(Nlist *, Tokenrow *, Tokenrow **);
void	expandrow(Tokenrow *, char *);
void	maketokenrow(int, Tokenrow *);
Tokenrow *copytokenrow(Tokenrow *, Tokenrow *);
Token	*growtokenrow(Tokenrow *);
Tokenrow *normtokenrow(Tokenrow *);
void	adjustrow(Tokenrow *, int);
void	movetokenrow(Tokenrow *, Tokenrow *);
void	insertrow(Tokenrow *, int, Tokenrow *);
void	peektokens(Tokenrow *, char *);
void	doconcat(Tokenrow *);
Tokenrow *stringify(Tokenrow *);
int	lookuparg(Nlist *, Token *);
long	eval(Tokenrow *, int);
void	genline(void);
void	setempty(Tokenrow *);
void	makespace(Tokenrow *);
char	*outnum(char *, int);
int	digit(int);
uchar	*newstring(uchar *, int, int);
int	checkhideset(int, Nlist *);
void	prhideset(int);
int	newhideset(int, Nlist *);
int	unionhideset(int, int);
void	iniths(void);
void	setobjname(char *);


extern	char *outp;
extern	Token	nltoken;
extern	Source *cursource;
extern	char *curtime;
extern	int incdepth;
extern	int ifdepth;
extern	int ifsatisfied[32];
extern	int Mflag;
extern	int skipping;
extern	int verbose;
extern	int Cplusplus;
extern	Nlist *kwdefined;
extern	Includelist includelist[32];
extern	char wd[];
# 6 "nlist.c"
extern	int getopt(int, char *const *, const char *);
extern	char	*optarg;
extern	int	optind;
extern	int	verbose;
extern	int	Cplusplus;
Nlist	*kwdefined;



static Nlist	*nlist[128];

struct	kwtab {
	char	*kw;
	int	val;
	int	flag;
} kwtab[] = {
	"if",		KIF,		02,
	"ifdef",	KIFDEF,		02,
	"ifndef",	KIFNDEF,	02,
	"elif",		KELIF,		02,
	"else",		KELSE,		02,
	"endif",	KENDIF,		02,
	"include",	KINCLUDE,	02,
	"define",	KDEFINE,	02,
	"undef",	KUNDEF,		02,
	"line",		KLINE,		02,
	"error",	KERROR,		02,
	"pragma",	KPRAGMA,	02,
	"eval",		KEVAL,		02,
	"defined",	KDEFINED,	01+04,
	"ident",	KPRAGMA,	02,	
	"__LINE__",	KLINENO,	010+04,
	"__FILE__",	KFILE,		010+04,
	"__DATE__",	KDATE,		010+04,
	"__TIME__",	KTIME,		010+04,
	"__STDC__",	KSTDC,		04,
	((void *) 0)
};

unsigned long	namebit[077+1];
Nlist 	*np;

void
setup_kwtab(void)
{
	struct kwtab *kp;
	Nlist *np;
	Token t;
	static Token deftoken[1] = {{ NAME, 0, 0, 0, 7, (uchar*)"defined" }};
	static Tokenrow deftr = { deftoken, deftoken, deftoken+1, 1 };

	for (kp=kwtab; kp->kw; kp++) {
		t.t = (uchar*)kp->kw;
		t.len = strlen(kp->kw);
		np = lookup(&t, 1);
		np->flag = kp->flag;
		np->val = kp->val;
		if (np->val == KDEFINED) {
			kwdefined = np;
			np->val = NAME;
			np->vp = &deftr;
			np->ap = 0;
		}
	}
}

Nlist *
lookup(Token *tp, int install)
{
	unsigned int h;
	Nlist *np;
	uchar *cp, *cpe;

	h = 0;
	for (cp=tp->t, cpe=cp+tp->len; cp<cpe; )
		h += *cp++;
	h %= 128;
	np = nlist[h];
	while (np) {
		if (*tp->t==*np->name && tp->len==np->len
		 && strncmp((char*)tp->t, (char*)np->name, tp->len)==0)
			return np;
		np = np->next;
	}
	if (install) {
		np = (Nlist *)domalloc(sizeof(Nlist));
		np->vp = ((void *) 0);
		np->ap = ((void *) 0);
		np->flag = 0;
		np->val = 0;
		np->len = tp->len;
		np->name = newstring(tp->t, tp->len, 0);
		np->next = nlist[h];
		nlist[h] = np;
		namebit[(tp->t[0])&077] |= (1<<((tp->len>1? tp->t[1]:0)&037));
		return np;
	}
	return ((void *) 0);
}
