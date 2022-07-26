# 1 "tokens.c"

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
# 6 "tokens.c"
static char wbuf[2*4096];
static char *wbp = wbuf;





static const char wstab[] = {
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	1,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	1,	
	1,	
	1,	
	1,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	0,	
	1,	
	0,	
	1,	
	1,	
	1,	
	0,	
 	0,	
 	0,	
 	0,	
 	0,	
 	0,	
 	0,	
	0,	
 	0,	
 	0,	
	0,	
	0,	
	0,	
	0,	
	0 	
};

void
maketokenrow(int size, Tokenrow *trp)
{
	trp->max = size;
	if (size>0)
		trp->bp = (Token *)domalloc(size*sizeof(Token));
	else
		trp->bp = ((void *) 0);
	trp->tp = trp->bp;
	trp->lp = trp->bp;
}

Token *
growtokenrow(Tokenrow *trp)
{
	int ncur = trp->tp - trp->bp;
	int nlast = trp->lp - trp->bp;

	trp->max = 3*trp->max/2 + 1;
	trp->bp = (Token *)realloc(trp->bp, trp->max*sizeof(Token));
	if (trp->bp == ((void *) 0))
		error(FATAL, "Out of memory from realloc");
	trp->lp = &trp->bp[nlast];
	trp->tp = &trp->bp[ncur];
	return trp->lp;
}




int
comparetokens(Tokenrow *tr1, Tokenrow *tr2)
{
	Token *tp1, *tp2;

	tp1 = tr1->tp;
	tp2 = tr2->tp;
	if (tr1->lp-tp1 != tr2->lp-tp2)
		return 1;
	for (; tp1<tr1->lp ; tp1++, tp2++) {
		if (tp1->type != tp2->type
		 || (tp1->wslen==0) != (tp2->wslen==0)
		 || tp1->len != tp2->len
		 || strncmp((char*)tp1->t, (char*)tp2->t, tp1->len)!=0)
			return 1;
	}
	return 0;
}






void
insertrow(Tokenrow *dtr, int ntok, Tokenrow *str)
{
	int nrtok = ((str)->lp - (str)->bp);

	dtr->tp += ntok;
	adjustrow(dtr, nrtok-ntok);
	dtr->tp -= ntok;
	movetokenrow(dtr, str);
	makespace(dtr);
	dtr->tp += nrtok;
	makespace(dtr);
}




void
makespace(Tokenrow *trp)
{
	uchar *tt;
	Token *tp = trp->tp;

	if (tp >= trp->lp)
		return;
	if (tp->wslen) {
		if (tp->flag&1
		 && (wstab[tp->type] || trp->tp>trp->bp && wstab[(tp-1)->type])) {
			tp->wslen = 0;
			return;
		}
		tp->t[-1] = ' ';
		return;
	}
	if (wstab[tp->type] || trp->tp>trp->bp && wstab[(tp-1)->type])
		return;
	tt = newstring(tp->t, tp->len, 1);
	*tt++ = ' ';
	tp->t = tt;
	tp->wslen = 1;
	tp->flag |= 1;
}






void
movetokenrow(Tokenrow *dtr, Tokenrow *str)
{
	int nby;

	
	nby = (char *)str->lp - (char *)str->bp;
	memmove(dtr->tp, str->bp, nby);
}







void
adjustrow(Tokenrow *trp, int nt)
{
	int nby, size;

	if (nt==0)
		return;
	size = (trp->lp - trp->bp) + nt;
	while (size > trp->max)
		growtokenrow(trp);
	
	nby = (char *)trp->lp - (char *)trp->tp;
	if (nby)
		memmove(trp->tp+nt, trp->tp, nby);
	trp->lp += nt;
}





Tokenrow *
copytokenrow(Tokenrow *dtr, Tokenrow *str)
{
	int len = ((str)->lp - (str)->bp);

	maketokenrow(len, dtr);
	movetokenrow(dtr, str);
	dtr->lp += len;
	return dtr;
}






Tokenrow *
normtokenrow(Tokenrow *trp)
{
	Token *tp;
	Tokenrow *ntrp = (Tokenrow *)domalloc(sizeof(Tokenrow));
	int len;

	len = trp->lp - trp->tp;
	if (len<=0)
		len = 1;
	maketokenrow(len, ntrp);
	for (tp=trp->tp; tp < trp->lp; tp++) {
		*ntrp->lp = *tp;
		if (tp->len) {
			ntrp->lp->t = newstring(tp->t, tp->len, 1);
			*ntrp->lp->t++ = ' ';
			if (tp->wslen)
				ntrp->lp->wslen = 1;
		}
		ntrp->lp++;
	}
	if (ntrp->lp > ntrp->bp)
		ntrp->bp->wslen = 0;
	return ntrp;
}




void
peektokens(Tokenrow *trp, char *str)
{
	Token *tp;

	tp = trp->tp;
	flushout();
	if (str)
		fprintf((&__stderr), "%s ", str);
	if (tp<trp->bp || tp>trp->lp)
		fprintf((&__stderr), "(tp offset %d) ", tp-trp->bp);
	for (tp=trp->bp; tp<trp->lp && tp<trp->bp+32; tp++) {
		if (tp->type!=NL) {
			int c = tp->t[tp->len];
			tp->t[tp->len] = 0;
			fprintf((&__stderr), "%s", tp->t);
			tp->t[tp->len] = c;
		}
		if (tp->type==NAME) {
			fprintf((&__stderr), tp==trp->tp?"{*":"{");
			prhideset(tp->hideset);
			fprintf((&__stderr), "} ");
		} else
			fprintf((&__stderr), tp==trp->tp?"{%x*} ":"{%x} ", tp->type);
	}
	fprintf((&__stderr), "\n");
	fflush((&__stderr));
}

void
puttokens(Tokenrow *trp)
{
	Token *tp;
	int len;
	uchar *p;

	if (verbose)
		peektokens(trp, "");
	tp = trp->bp;
	for (; tp<trp->lp; tp++) {
		len = tp->len+tp->wslen;
		p = tp->t-tp->wslen;
		while (tp<trp->lp-1 && p+len == (tp+1)->t - (tp+1)->wslen) {
			tp++;
			len += tp->wslen+tp->len;
		}
		if (len>4096/2) {		
			if (wbp > wbuf)
				fwrite(wbuf, 1, wbp-wbuf, (&__stdout));
			fwrite((char *)p, 1, len, (&__stdout));
			wbp = wbuf;
		} else {
			memcpy(wbp, p, len);
			wbp += len;
		}
		if (wbp >= &wbuf[4096]) {
			fwrite(wbuf, 1, 4096, (&__stdout));
			if (wbp > &wbuf[4096])
				memcpy(wbuf, wbuf+4096, wbp - &wbuf[4096]);
			wbp -= 4096;
		}
	}
	trp->tp = tp;
	if (cursource->fd==(&__stdin))
		flushout();
}

void
flushout(void)
{
	if (wbp>wbuf) {
		fwrite(wbuf, 1, wbp-wbuf, (&__stdout));
		fflush((&__stdout));
		wbp = wbuf;
	}
}




void
setempty(Tokenrow *trp)
{
	trp->tp = trp->bp;
	trp->lp = trp->bp+1;
	*trp->bp = nltoken;
}




char *
outnum(char *p, int n)
{
	if (n>=10)
		p = outnum(p, n/10);
	*p++ = n%10 + '0';
	return p;
}





uchar *
newstring(uchar *s, int l, int o)
{
	uchar *ns = (uchar *)domalloc(l+o+1);

	ns[l+o] = '\0';
	return (uchar*)strncpy((char*)ns+o, (char*)s, l) - o;
}
