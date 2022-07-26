# 1 "eval.c"

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
# 13 "eval.c"
struct value {
	long	val;
	int	type;
};










struct pri {
	char	pri;
	char	arity;
	char	ctype;
} priority[] = {
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 11, 2, 1 },	
	{ 11, 2, 1 },	
	{ 12, 2, 1 },	
	{ 12, 2, 1 },	
	{ 13, 2, 5 },	
	{ 13, 2, 5 },	
	{ 7, 2, 3 },	
	{ 6, 2, 3 },	
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 3, 0, 0 },		
	{ 3, 0, 0 },		
	{ 0, 0, 0 },		
	{ 10, 2, 2 },	
	{ 15, 2, 2 },	
	{ 14, 2, 2 },	
	{ 14, 2, 2 },	
	{ 16, 1, 6 },	
	{ 16, 1, 6 },	
	{ 15, 2, 2 },	
	{ 15, 2, 2 },	
	{ 12, 2, 1 },	
	{ 12, 2, 1 },	
	{ 9, 2, 2 },	
	{ 8, 2, 2 },	
	{ 5, 2, 4 },		
	{ 5, 2, 4 },		
	{ 0, 0, 0 },		
	{ 4, 2, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
 	{ 0, 0, 0 },		
 	{ 0, 0, 0 },		
 	{ 0, 0, 0 },		
 	{ 0, 0, 0 },		
 	{ 0, 0, 0 },		
 	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
 	{ 0, 0, 0 },		
 	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 0, 0, 0 },		
	{ 16, 1, 6 },	
	{ 16, 0, 6 } 	
};

int	evalop(struct pri);
struct	value tokval(Token *);
struct value vals[32], *vp;
enum toktype ops[32], *op;




long
eval(Tokenrow *trp, int kw)
{
	Token *tp;
	Nlist *np;
	int ntok, rand;

	trp->tp++;
	if (kw==KIFDEF || kw==KIFNDEF) {
		if (trp->lp - trp->bp != 4 || trp->tp->type!=NAME) {
			error(ERROR, "Syntax error in #ifdef/#ifndef");
			return 0;
		}
		np = lookup(trp->tp, 0);
		return (kw==KIFDEF) == (np && np->flag&(01|010));
	}
	ntok = trp->tp - trp->bp;
	kwdefined->val = KDEFINED;	
	expandrow(trp, "<if>");
	kwdefined->val = NAME;
	vp = vals;
	op = ops;
	*op++ = END;
	for (rand=0, tp = trp->bp+ntok; tp < trp->lp; tp++) {
		switch(tp->type) {
		case WS:
		case NL:
			continue;

		
		case NAME:
		case NAME1:
		case NUMBER:
		case CCON:
		case STRING:
			if (rand)
				goto syntax;
			if (vp == &vals[32]) {
				error(ERROR, "Eval botch (stack overflow)");
				return 0;
			}
			*vp++ = tokval(tp);
			rand = 1;
			continue;

		
		case DEFINED:
		case TILDE:
		case NOT:
			if (rand)
				goto syntax;
			*op++ = tp->type;
			continue;

		
		case PLUS: case MINUS: case STAR: case AND:
			if (rand==0) {
				if (tp->type==MINUS)
					*op++ = UMINUS;
				if (tp->type==STAR || tp->type==AND) {
					error(ERROR, "Illegal operator * or & in #if/#elsif");
					return 0;
				}
				continue;
			}
			

		
		case EQ: case NEQ: case LEQ: case GEQ: case LSH: case RSH:
		case LAND: case LOR: case SLASH: case PCT:
		case LT: case GT: case CIRC: case OR: case QUEST:
		case COLON: case COMMA:
			if (rand==0)
				goto syntax;
			if (evalop(priority[tp->type])!=0)
				return 0;
			*op++ = tp->type;
			rand = 0;
			continue;

		case LP:
			if (rand)
				goto syntax;
			*op++ = LP;
			continue;

		case RP:
			if (!rand)
				goto syntax;
			if (evalop(priority[RP])!=0)
				return 0;
			if (op<=ops || op[-1]!=LP) {
				goto syntax;
			}
			op--;
			continue;

		default:
			error(ERROR,"Bad operator (%t) in #if/#elsif", tp);
			return 0;
		}
	}
	if (rand==0)
		goto syntax;
	if (evalop(priority[END])!=0)
		return 0;
	if (op!=&ops[1] || vp!=&vals[1]) {
		error(ERROR, "Botch in #if/#elsif");
		return 0;
	}
	if (vals[0].type==2)
		error(ERROR, "Undefined expression value");
	return vals[0].val;
syntax:
	error(ERROR, "Syntax error in #if/#elsif");
	return 0;
}

int
evalop(struct pri pri)
{
	struct value v1, v2;
	long rv1, rv2;
	int rtype, oper;

	rv2=0;
	rtype=0;
	while (pri.pri < priority[op[-1]].pri) {
		oper = *--op;
		if (priority[oper].arity==2) {
			v2 = *--vp;
			rv2 = v2.val;
		}
		v1 = *--vp;
		rv1 = v1.val;

		switch (priority[oper].ctype) {
		case 0:
		default:
			error(WARNING, "Syntax error in #if/#endif");
			return 1;
		case 2:
		case 1:
			if (v1.type==1 || v2.type==1)
				rtype = 1;
			else
				rtype = 0;
			if (v1.type==2 || v2.type==2)
				rtype = 2;
			if (priority[oper].ctype==1 && rtype==1) {
				oper |= 0x1000;
				rtype = 0;
			}
			break;
		case 5:
			if (v1.type==2 || v2.type==2)
				rtype = 2;
			else
				rtype = v1.type;
			if (rtype==1)
				oper |= 0x1000;
			break;
		case 6:
			rtype = v1.type;
			break;
		case 3:
		case 4:
			break;
		}
		switch (oper) {
		case EQ: case EQ|0x1000:
			rv1 = rv1==rv2; break;
		case NEQ: case NEQ|0x1000:
			rv1 = rv1!=rv2; break;
		case LEQ:
			rv1 = rv1<=rv2; break;
		case GEQ:
			rv1 = rv1>=rv2; break;
		case LT:
			rv1 = rv1<rv2; break;
		case GT:
			rv1 = rv1>rv2; break;
		case LEQ|0x1000:
			rv1 = (unsigned long)rv1<=rv2; break;
		case GEQ|0x1000:
			rv1 = (unsigned long)rv1>=rv2; break;
		case LT|0x1000:
			rv1 = (unsigned long)rv1<rv2; break;
		case GT|0x1000:
			rv1 = (unsigned long)rv1>rv2; break;
		case LSH:
			rv1 <<= rv2; break;
		case LSH|0x1000:
			rv1 = (unsigned long)rv1<<rv2; break;
		case RSH:
			rv1 >>= rv2; break;
		case RSH|0x1000:
			rv1 = (unsigned long)rv1>>rv2; break;
		case LAND:
			rtype = 2;
			if (v1.type==2)
				break;
			if (rv1!=0) {
				if (v2.type==2)
					break;
				rv1 = rv2!=0;
			} else
				rv1 = 0;
			rtype = 0;
			break;
		case LOR:
			rtype = 2;
			if (v1.type==2)
				break;
			if (rv1==0) {
				if (v2.type==2)
					break;
				rv1 = rv2!=0;
			} else
				rv1 = 1;
			rtype = 0;
			break;
		case AND:
			rv1 &= rv2; break;
		case STAR:
			rv1 *= rv2; break;
		case PLUS:
			rv1 += rv2; break;
		case MINUS:
			rv1 -= rv2; break;
		case UMINUS:
			if (v1.type==2)
				rtype = 2;
			rv1 = -rv1; break;
		case OR:
			rv1 |= rv2; break;
		case CIRC:
			rv1 ^= rv2; break;
		case TILDE:
			rv1 = ~rv1; break;
		case NOT:
			rv1 = !rv1; if (rtype!=2) rtype = 0; break;
		case SLASH:
			if (rv2==0) {
				rtype = 2;
				break;
			}
			if (rtype==1)
				rv1 /= (unsigned long)rv2;
			else
				rv1 /= rv2;
			break;
		case PCT:
			if (rv2==0) {
				rtype = 2;
				break;
			}
			if (rtype==1)
				rv1 %= (unsigned long)rv2;
			else
				rv1 %= rv2;
			break;
		case COLON:
			if (op[-1] != QUEST)
				error(ERROR, "Bad ?: in #if/endif");
			else {
				op--;
				if ((--vp)->val==0)
					v1 = v2;
				rtype = v1.type;
				rv1 = v1.val;
			}
			break;
		case DEFINED:
			break;
		default:
			error(ERROR, "Eval botch (unknown operator)");
			return 1;
		}

		v1.val = rv1;
		v1.type = rtype;
		if (vp == &vals[32]) {
			error(ERROR, "Eval botch (stack overflow)");
			return 0;
		}
		*vp++ = v1;
	}
	return 0;
}

struct value
tokval(Token *tp)
{
	struct value v;
	Nlist *np;
	int i, base, c;
	unsigned long n;
	uchar *p;

	v.type = 0;
	v.val = 0;
	switch (tp->type) {

	case NAME:
		v.val = 0;
		break;

	case NAME1:
		if ((np = lookup(tp, 0)) != ((void *) 0) && np->flag&(01|010))
			v.val = 1;
		break;

	case NUMBER:
		n = 0;
		base = 10;
		p = tp->t;
		c = p[tp->len];
		p[tp->len] = '\0';
		if (*p=='0') {
			base = 8;
			if (p[1]=='x' || p[1]=='X') {
				base = 16;
				p++;
			}
			p++;
		}
		for (;; p++) {
			if ((i = digit(*p)) < 0)
				break;
			if (i>=base)
				error(WARNING,
				  "Bad digit in number %t", tp);
			n *= base;
			n += i;
		}
		if (n>=0x80000000 && base!=10)
			v.type = 1;
		for (; *p; p++) {
			if (*p=='u' || *p=='U')
				v.type = 1;
			else if (*p=='l' || *p=='L')
				;
			else {
				error(ERROR,
				  "Bad number %t in #if/#elsif", tp);
				break;
			}
		}
		v.val = n;
		tp->t[tp->len] = c;
		break;

	case CCON:
		n = 0;
		p = tp->t;
		if (*p=='L') {
			p += 1;
			error(WARNING, "Wide char constant value undefined");
		}
		p += 1;
		if (*p=='\\') {
			p += 1;
			if ((i = digit(*p))>=0 && i<=7) {
				n = i;
				p += 1;
				if ((i = digit(*p))>=0 && i<=7) {
					p += 1;
					n <<= 3;
					n += i;
					if ((i = digit(*p))>=0 && i<=7) {
						p += 1;
						n <<= 3;
						n += i;
					}
				}
			} else if (*p=='x') {
				p += 1;
				while ((i = digit(*p))>=0 && i<=15) {
					p += 1;
					n <<= 4;
					n += i;
				}
			} else {
				static char cvcon[]
				  = "b\bf\fn\nr\rt\tv\v''\"\"??\\\\";
				for (i=0; i<sizeof(cvcon); i+=2) {
					if (*p == cvcon[i]) {
						n = cvcon[i+1];
						break;
					}
				}
				p += 1;
				if (i>=sizeof(cvcon))
					error(WARNING,
					 "Undefined escape in character constant");
			}
		} else if (*p=='\'')
			error(ERROR, "Empty character constant");
		else
			n = *p++;
		if (*p!='\'')
			error(WARNING, "Multibyte character constant undefined");
		else if (n>127)
			error(WARNING, "Character constant taken as not signed");
		v.val = n;
		break;

	case STRING:
		error(ERROR, "String in #if/#elsif");
		break;
	}
	return v;
}

int
digit(int i)
{
	if ('0'<=i && i<='9')
		i -= '0';
	else if ('a'<=i && i<='f')
		i -= 'a'-10;
	else if ('A'<=i && i<='F')
		i -= 'A'-10;
	else
		i = -1;
	return i;
}
