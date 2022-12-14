# 1 "cpp.c"

# 15 "/home/charles/xcc/include/sys/jewel.h"
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
# 15 "/home/charles/xcc/include/time.h"
typedef long time_t;

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

extern char *asctime(const struct tm *);
extern char *ctime(const time_t *);
extern struct tm *localtime(const time_t *);
extern struct tm *gmtime(const time_t *);
extern __size_t strftime(char *, __size_t, const char *, const struct tm *);
extern time_t time(time_t *);

extern char *tzname[];
extern long timezone;

extern void tzset(void);
# 21 "/home/charles/xcc/include/stdarg.h"
typedef __va_list va_list;
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
# 9 "cpp.c"
char	outbuf[16384];
char	*outp = outbuf;
Source	*cursource;
int	nerrs;
struct	token nltoken = { NL, 0, 0, 0, 1, (uchar*)"\n" };
char	*curtime;
int	incdepth;
int	ifdepth;
int	ifsatisfied[32];
int	skipping;

char rcsid[] = "$Revision$ $Date$";

int
main(int argc, char **argv)
{
	Tokenrow tr;
	time_t t;
	char ebuf[1024];

	setbuf((&__stderr), ebuf);
	t = time(((void *) 0));
	curtime = ctime(&t);
	maketokenrow(3, &tr);
	expandlex();
	setup(argc, argv);
	fixlex();
	iniths();
	genline();
	process(&tr);
	flushout();
	fflush((&__stderr));
	exit(nerrs > 0);
	return 0;
}

void
process(Tokenrow *trp)
{
	int anymacros = 0;

	for (;;) {
		if (trp->tp >= trp->lp) {
			trp->tp = trp->lp = trp->bp;
			outp = outbuf;
			anymacros |= gettokens(trp, 1);
			trp->tp = trp->bp;
		}
		if (trp->tp->type == END) {
			if (--incdepth>=0) {
				if (cursource->ifdepth)
					error(ERROR,
					 "Unterminated conditional in #include");
				unsetsource();
				cursource->line += cursource->lineinc;
				trp->tp = trp->lp;
				genline();
				continue;
			}
			if (ifdepth)
				error(ERROR, "Unterminated #if/#ifdef/#ifndef");
			break;
		}
		if (trp->tp->type==SHARP) {
			trp->tp += 1;
			control(trp);
		} else if (!skipping && anymacros)
			expandrow(trp, ((void *) 0));
		if (skipping)
			setempty(trp);
		puttokens(trp);
		anymacros = 0;
		cursource->line += cursource->lineinc;
		if (cursource->lineinc>1) {
			genline();
		}
	}
}
	
void
control(Tokenrow *trp)
{
	Nlist *np;
	Token *tp;

	tp = trp->tp;
	if (tp->type!=NAME) {
		if (tp->type==NUMBER)
			goto kline;
		if (tp->type != NL)
			error(ERROR, "Unidentifiable control line");
		return;			
	}
	if ((np = lookup(tp, 0))==((void *) 0) || (np->flag&02)==0 && !skipping) {
		error(WARNING, "Unknown preprocessor control %t", tp);
		return;
	}
	if (skipping) {
		if ((np->flag&02)==0)
			return;
		switch (np->val) {
		case KENDIF:
			if (--ifdepth<skipping)
				skipping = 0;
			--cursource->ifdepth;
			setempty(trp);
			return;

		case KIFDEF:
		case KIFNDEF:
		case KIF:
			if (++ifdepth >= 32)
				error(FATAL, "#if too deeply nested");
			++cursource->ifdepth;
			return;

		case KELIF:
		case KELSE:
			if (ifdepth<=skipping)
				break;
			return;

		default:
			return;
		}
	}
	switch (np->val) {
	case KDEFINE:
		dodefine(trp);
		break;

	case KUNDEF:
		tp += 1;
		if (tp->type!=NAME || trp->lp - trp->bp != 4) {
			error(ERROR, "Syntax error in #undef");
			break;
		}
		if ((np = lookup(tp, 0)) != ((void *) 0))
			np->flag &= ~01;
		break;

	case KPRAGMA:
		return;

	case KIFDEF:
	case KIFNDEF:
	case KIF:
		if (++ifdepth >= 32)
			error(FATAL, "#if too deeply nested");
		++cursource->ifdepth;
		ifsatisfied[ifdepth] = 0;
		if (eval(trp, np->val))
			ifsatisfied[ifdepth] = 1;
		else
			skipping = ifdepth;
		break;

	case KELIF:
		if (ifdepth==0) {
			error(ERROR, "#elif with no #if");
			return;
		}
		if (ifsatisfied[ifdepth]==2)
			error(ERROR, "#elif after #else");
		if (eval(trp, np->val)) {
			if (ifsatisfied[ifdepth])
				skipping = ifdepth;
			else {
				skipping = 0;
				ifsatisfied[ifdepth] = 1;
			}
		} else
			skipping = ifdepth;
		break;

	case KELSE:
		if (ifdepth==0 || cursource->ifdepth==0) {
			error(ERROR, "#else with no #if");
			return;
		}
		if (ifsatisfied[ifdepth]==2)
			error(ERROR, "#else after #else");
		if (trp->lp - trp->bp != 3)
			error(ERROR, "Syntax error in #else");
		skipping = ifsatisfied[ifdepth]? ifdepth: 0;
		ifsatisfied[ifdepth] = 2;
		break;

	case KENDIF:
		if (ifdepth==0 || cursource->ifdepth==0) {
			error(ERROR, "#endif with no #if");
			return;
		}
		--ifdepth;
		--cursource->ifdepth;
		if (trp->lp - trp->bp != 3)
			error(WARNING, "Syntax error in #endif");
		break;

	case KERROR:
		trp->tp = tp+1;
		error(WARNING, "#error directive: %r", trp);
		break;

	case KLINE:
		trp->tp = tp+1;
		expandrow(trp, "<line>");
		tp = trp->bp+2;
	kline:
		if (tp+1>=trp->lp || tp->type!=NUMBER || tp+3<trp->lp
		 || (tp+3==trp->lp && ((tp+1)->type!=STRING)||*(tp+1)->t=='L')){
			error(ERROR, "Syntax error in #line");
			return;
		}
		cursource->line = atol((char*)tp->t)-1;
		if (cursource->line<0 || cursource->line>=32768)
			error(WARNING, "#line specifies number out of range");
		tp = tp+1;
		if (tp+1<trp->lp)
			cursource->filename=(char*)newstring(tp->t+1,tp->len-2,0);
		return;

	case KDEFINED:
		error(ERROR, "Bad syntax for control line");
		break;

	case KINCLUDE:
		doinclude(trp);
		trp->lp = trp->bp;
		return;

	case KEVAL:
		eval(trp, np->val);
		break;

	default:
		error(ERROR, "Preprocessor control `%t' not yet implemented", tp);
		break;
	}
	setempty(trp);
	return;
}

void *
domalloc(int size)
{
	void *p = malloc(size);

	if (p==((void *) 0))
		error(FATAL, "Out of memory from malloc");
	return p;
}

void
dofree(void *p)
{
	free(p);
}

void
error(enum errtype type, char *string, ...)
{
	va_list ap;
	char *cp, *ep;
	Token *tp;
	Tokenrow *trp;
	Source *s;
	int i;

	fprintf((&__stderr), "cpp: ");
	for (s=cursource; s; s=s->next)
		if (*s->filename)
			fprintf((&__stderr), "%s:%d ", s->filename, s->line);
	(ap = (((char *) &(string)) + (((sizeof(string)) + (8 - 1)) & ~(8 - 1))));
	for (ep=string; *ep; ep++) {
		if (*ep=='%') {
			switch (*++ep) {

			case 's':
				cp = ((ap += (((sizeof(char *)) + (8 - 1)) & ~(8 - 1))), *((char * *) (ap - (((sizeof(char *)) + (8 - 1)) & ~(8 - 1)))));
				fprintf((&__stderr), "%s", cp);
				break;
			case 'd':
				i = ((ap += (((sizeof(int)) + (8 - 1)) & ~(8 - 1))), *((int *) (ap - (((sizeof(int)) + (8 - 1)) & ~(8 - 1)))));
				fprintf((&__stderr), "%d", i);
				break;
			case 't':
				tp = ((ap += (((sizeof(Token *)) + (8 - 1)) & ~(8 - 1))), *((Token * *) (ap - (((sizeof(Token *)) + (8 - 1)) & ~(8 - 1)))));
				fprintf((&__stderr), "%.*s", tp->len, tp->t);
				break;

			case 'r':
				trp = ((ap += (((sizeof(Tokenrow *)) + (8 - 1)) & ~(8 - 1))), *((Tokenrow * *) (ap - (((sizeof(Tokenrow *)) + (8 - 1)) & ~(8 - 1)))));
				for (tp=trp->tp; tp<trp->lp&&tp->type!=NL; tp++) {
					if (tp>trp->tp && tp->wslen)
						fputc(' ', (&__stderr));
					fprintf((&__stderr), "%.*s", tp->len, tp->t);
				}
				break;

			default:
				fputc(*ep, (&__stderr));
				break;
			}
		} else
			fputc(*ep, (&__stderr));
	}
	;
	fputc('\n', (&__stderr));
	if (type==FATAL)
		exit(1);
	if (type!=WARNING)
		nerrs = 1;
	fflush((&__stderr));
}
