# 1 "macro.c"

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
# 9 "macro.c"
void
dodefine(Tokenrow *trp)
{
	Token *tp;
	Nlist *np;
	Tokenrow *def, *args;

	tp = trp->tp+1;
	if (tp>=trp->lp || tp->type!=NAME) {
		error(ERROR, "#defined token is not a name");
		return;
	}
	np = lookup(tp, 1);
	if (np->flag&04) {
		error(ERROR, "#defined token %t can't be redefined", tp);
		return;
	}
	
	tp += 1;
	args = ((void *) 0);
	if (tp<trp->lp && tp->type==LP && tp->wslen==0) {
		
		int narg = 0;
		tp += 1;
		args = (Tokenrow *)domalloc(sizeof(Tokenrow));
		maketokenrow(2, args);
		if (tp->type!=RP) {
			int err = 0;
			for (;;) {
				Token *atp;
				if (tp->type!=NAME) {
					err++;
					break;
				}
				if (narg>=args->max)
					growtokenrow(args);
				for (atp=args->bp; atp<args->lp; atp++)
					if (atp->len==tp->len
					 && strncmp((char*)atp->t, (char*)tp->t, tp->len)==0)
						error(ERROR, "Duplicate macro argument");
				*args->lp++ = *tp;
				narg++;
				tp += 1;
				if (tp->type==RP)
					break;
				if (tp->type!=COMMA) {
					err++;
					break;
				}
				tp += 1;
			}
			if (err) {
				error(ERROR, "Syntax error in macro parameters");
				return;
			}
		}
		tp += 1;
	}
	trp->tp = tp;
	if (((trp->lp)-1)->type==NL)
		trp->lp -= 1;
	def = normtokenrow(trp);
	if (np->flag&01) {
		if (comparetokens(def, np->vp)
		 || (np->ap==((void *) 0)) != (args==((void *) 0))
		 || np->ap && comparetokens(args, np->ap))
			error(ERROR, "Macro redefinition of %t", trp->bp+2);
	}
	if (args) {
		Tokenrow *tap;
		tap = normtokenrow(args);
		dofree(args->bp);
		args = tap;
	}
	np->ap = args;
	np->vp = def;
	np->flag |= 01;
}




void
doadefine(Tokenrow *trp, int type)
{
	Nlist *np;
	static unsigned char one[] = "1";
	static Token onetoken[1] = {{ NUMBER, 0, 0, 0, 1, one }};
	static Tokenrow onetr = { onetoken, onetoken, onetoken+1, 1 };

	trp->tp = trp->bp;
	if (type=='U') {
		if (trp->lp-trp->tp != 2 || trp->tp->type!=NAME)
			goto syntax;
		if ((np = lookup(trp->tp, 0)) == ((void *) 0))
			return;
		np->flag &= ~01;
		return;
	}
	if (trp->tp >= trp->lp || trp->tp->type!=NAME)
		goto syntax;
	np = lookup(trp->tp, 1);
	np->flag |= 01;
	trp->tp += 1;
	if (trp->tp >= trp->lp || trp->tp->type==END) {
		np->vp = &onetr;
		return;
	}
	if (trp->tp->type!=ASGN)
		goto syntax;
	trp->tp += 1;
	if ((trp->lp-1)->type == END)
		trp->lp -= 1;
	np->vp = normtokenrow(trp);
	return;
syntax:
	error(FATAL, "Illegal -D or -U argument %r", trp);
}
			




void
expandrow(Tokenrow *trp, char *flag)
{
	Token *tp;
	Nlist *np;

	if (flag)
		setsource(flag, ((void *) 0), "");
	for (tp = trp->tp; tp<trp->lp; ) {
		if (tp->type!=NAME
		 || (namebit[(tp->t[0])&077] & (1<<((tp->len>1?tp->t[1]:0)&037)))==0
		 || (np = lookup(tp, 0))==((void *) 0)
		 || (np->flag&(01|010))==0
		 || tp->hideset && checkhideset(tp->hideset, np)) {
			tp++;
			continue;
		}
		trp->tp = tp;
		if (np->val==KDEFINED) {
			tp->type = DEFINED;
			if ((tp+1)<trp->lp && (tp+1)->type==NAME)
				(tp+1)->type = NAME1;
			else if ((tp+3)<trp->lp && (tp+1)->type==LP
			 && (tp+2)->type==NAME && (tp+3)->type==RP)
				(tp+2)->type = NAME1;
			else
				error(ERROR, "Incorrect syntax for `defined'");
			tp++;
			continue;
		}
		if (np->flag&010)
			builtin(trp, np->val);
		else {
			expand(trp, np);
		}
		tp = trp->tp;
	}
	if (flag)
		unsetsource();
}






void
expand(Tokenrow *trp, Nlist *np)
{
	Tokenrow ntr;
	int ntokc, narg, i;
	Token *tp;
	Tokenrow *atr[32+1];
	int hs;

	copytokenrow(&ntr, np->vp);		
	if (np->ap==((void *) 0))			
		ntokc = 1;
	else {
		ntokc = gatherargs(trp, atr, &narg);
		if (narg<0) {			
			
			return;
		}
		if (narg != ((np->ap)->lp - (np->ap)->bp)) {
			error(ERROR, "Disagreement in number of macro arguments");
			trp->tp->hideset = newhideset(trp->tp->hideset, np);
			trp->tp += ntokc;
			return;
		}
		substargs(np, &ntr, atr);	
		for (i=0; i<narg; i++) {
			dofree(atr[i]->bp);
			dofree(atr[i]);
		}
	}
	doconcat(&ntr);				
	hs = newhideset(trp->tp->hideset, np);
	for (tp=ntr.bp; tp<ntr.lp; tp++) {	
		if (tp->type==NAME) {
			if (tp->hideset==0)
				tp->hideset = hs;
			else
				tp->hideset = unionhideset(tp->hideset, hs);
		}
	}
	ntr.tp = ntr.bp;
	insertrow(trp, ntokc, &ntr);
	trp->tp -= ((&ntr)->lp - (&ntr)->bp);
	dofree(ntr.bp);
	return;
}	






int
gatherargs(Tokenrow *trp, Tokenrow **atr, int *narg)
{
	int parens = 1;
	int ntok = 0;
	Token *bp, *lp;
	Tokenrow ttr;
	int ntokp;
	int needspace;

	*narg = -1;			
	
	for (;;) {
		trp->tp++;
		ntok++;
		if (trp->tp >= trp->lp) {
			gettokens(trp, 0);
			if ((trp->lp-1)->type==END) {
				trp->lp -= 1;
				trp->tp -= ntok;
				return ntok;
			}
		}
		if (trp->tp->type==LP)
			break;
		if (trp->tp->type!=NL)
			return ntok;
	}
	*narg = 0;
	ntok++;
	ntokp = ntok;
	trp->tp++;
	
	needspace = 0;
	while (parens>0) {
		if (trp->tp >= trp->lp)
			gettokens(trp, 0);
		if (needspace) {
			needspace = 0;
			makespace(trp);
		}
		if (trp->tp->type==END) {
			trp->lp -= 1;
			trp->tp -= ntok;
			error(ERROR, "EOF in macro arglist");
			return ntok;
		}
		if (trp->tp->type==NL) {
			trp->tp += 1;
			adjustrow(trp, -1);
			trp->tp -= 1;
			makespace(trp);
			needspace = 1;
			continue;
		}
		if (trp->tp->type==LP)
			parens++;
		else if (trp->tp->type==RP)
			parens--;
		trp->tp++;
		ntok++;
	}
	trp->tp -= ntok;
	
	lp = bp = trp->tp+ntokp;
	for (; parens>=0; lp++) {
		if (lp->type == LP) {
			parens++;
			continue;
		}
		if (lp->type==RP)
			parens--;
		if (lp->type==DSHARP)
			lp->type = DSHARP1;	
		if (lp->type==COMMA && parens==0 || parens<0 && (lp-1)->type!=LP) {
			if (*narg>=32-1)
				error(FATAL, "Sorry, too many macro arguments");
			ttr.bp = ttr.tp = bp;
			ttr.lp = lp;
			atr[(*narg)++] = normtokenrow(&ttr);
			bp = lp+1;
		}
	}
	return ntok;
}





void
substargs(Nlist *np, Tokenrow *rtr, Tokenrow **atr)
{
	Tokenrow tatr;
	Token *tp;
	int ntok, argno;

	for (rtr->tp=rtr->bp; rtr->tp<rtr->lp; ) {
		if (rtr->tp->type==SHARP) {	
			tp = rtr->tp;
			rtr->tp += 1;
			if ((argno = lookuparg(np, rtr->tp))<0) {
				error(ERROR, "# not followed by macro parameter");
				continue;
			}
			ntok = 1 + (rtr->tp - tp);
			rtr->tp = tp;
			insertrow(rtr, ntok, stringify(atr[argno]));
			continue;
		}
		if (rtr->tp->type==NAME
		 && (argno = lookuparg(np, rtr->tp)) >= 0) {
			if ((rtr->tp+1)<rtr->lp && (rtr->tp+1)->type==DSHARP
			 || rtr->tp!=rtr->bp && (rtr->tp-1)->type==DSHARP)
				insertrow(rtr, 1, atr[argno]);
			else {
				copytokenrow(&tatr, atr[argno]);
				expandrow(&tatr, "<macro>");
				insertrow(rtr, 1, &tatr);
				dofree(tatr.bp);
			}
			continue;
		}
		rtr->tp++;
	}
}




void
doconcat(Tokenrow *trp)
{
	Token *ltp, *ntp;
	Tokenrow ntr;
	int len;

	for (trp->tp=trp->bp; trp->tp<trp->lp; trp->tp++) {
		if (trp->tp->type==DSHARP1)
			trp->tp->type = DSHARP;
		else if (trp->tp->type==DSHARP) {
			char tt[128];
			ltp = trp->tp-1;
			ntp = trp->tp+1;
			if (ltp<trp->bp || ntp>=trp->lp) {
				error(ERROR, "## occurs at border of replacement");
				continue;
			}
			len = ltp->len + ntp->len;
			strncpy((char*)tt, (char*)ltp->t, ltp->len);
			strncpy((char*)tt+ltp->len, (char*)ntp->t, ntp->len);
			tt[len] = '\0';
			setsource("<##>", ((void *) 0), tt);
			maketokenrow(3, &ntr);
			gettokens(&ntr, 1);
			unsetsource();
			if (ntr.lp-ntr.bp!=2 || ntr.bp->type==UNCLASS)
				error(WARNING, "Bad token %r produced by ##", &ntr);
			ntr.lp = ntr.bp+1;
			trp->tp = ltp;
			makespace(&ntr);
			insertrow(trp, (ntp-ltp)+1, &ntr);
			dofree(ntr.bp);
			trp->tp--;
		}
	}
}






int
lookuparg(Nlist *mac, Token *tp)
{
	Token *ap;

	if (tp->type!=NAME || mac->ap==((void *) 0))
		return -1;
	for (ap=mac->ap->bp; ap<mac->ap->lp; ap++) {
		if (ap->len==tp->len && strncmp((char*)ap->t,(char*)tp->t,ap->len)==0)
			return ap - mac->ap->bp;
	}
	return -1;
}





Tokenrow *
stringify(Tokenrow *vp)
{
	static Token t = { STRING };
	static Tokenrow tr = { &t, &t, &t+1, 1 };
	Token *tp;
	uchar s[512];
	uchar *sp = s, *cp;
	int i, instring;

	*sp++ = '"';
	for (tp = vp->bp; tp < vp->lp; tp++) {
		instring = tp->type==STRING || tp->type==CCON;
		if (sp+2*tp->len >= &s[512-10]) {
			error(ERROR, "Stringified macro arg is too long");
			break;
		}
		if (tp->wslen && (tp->flag&1)==0)
			*sp++ = ' ';
		for (i=0, cp=tp->t; i<tp->len; i++) {	
			if (instring && (*cp=='"' || *cp=='\\'))
				*sp++ = '\\';
			*sp++ = *cp++;
		}
	}
	*sp++ = '"';
	*sp = '\0';
	sp = s;
	t.len = strlen((char*)sp);
	t.t = newstring(sp, t.len, 0);
	return &tr;
}




void
builtin(Tokenrow *trp, int biname)
{
	char *op;
	Token *tp;
	Source *s;

	tp = trp->tp;
	trp->tp++;
	
	s = cursource;
	while (s && s->fd==((void *) 0))
		s = s->next;
	if (s==((void *) 0))
		s = cursource;
	
	tp->type = STRING;
	if (tp->wslen) {
		*outp++ = ' ';
		tp->wslen = 1;
	}
	op = outp;
	*op++ = '"';
	switch (biname) {

	case KLINENO:
		tp->type = NUMBER;
		op = outnum(op-1, s->line);
		break;

	case KFILE: {
		char *src = s->filename;
		while ((*op++ = *src++) != 0)
			if (src[-1] == '\\')
				*op++ = '\\';
		op--;
		break;
		}

	case KDATE:
		strncpy(op, curtime+4, 7);
		strncpy(op+7, curtime+20, 4);
		op += 11;
		break;

	case KTIME:
		strncpy(op, curtime+11, 8);
		op += 8;
		break;

	default:
		error(ERROR, "cpp botch: unknown internal macro");
		return;
	}
	if (tp->type==STRING)
		*op++ = '"';
	tp->t = (uchar*)outp;
	tp->len = op - outp;
	outp = op;
}
