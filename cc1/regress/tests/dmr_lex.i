# 1 "lex.c"

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
# 37 "lex.c"
enum state {
	START=0, NUM1, NUM2, NUM3, ID1, ST1, ST2, ST3, COM1, COM2, COM3, COM4,
	CC1, CC2, WS1, PLUS1, MINUS1, STAR1, SLASH1, PCT1, SHARP1,
	CIRC1, GT1, GT2, LT1, LT2, OR1, AND1, ASG1, NOT1, DOTS1,
	S_SELF=32, S_SELFB, S_EOF, S_NL, S_EOFSTR,
	S_STNL, S_COMNL, S_EOFCOM, S_COMMENT, S_EOB, S_WS, S_NAME
};

int	tottok;
int	tokkind[256];
struct	fsm {
	int	state;		
	uchar	ch[4];		
	int	nextstate;	
};

          struct fsm fsm[] = {
	
	START,	{ 5 },	((UNCLASS<<7)+S_SELF),
	START,	{ ' ', '\t', '\v' },	WS1,
	START,	{ 3 },	NUM1,
	START,	{ '.' },	NUM3,
	START,	{ 2 },	ID1,
	START,	{ 'L' },	ST1,
	START,	{ '"' },	ST2,
	START,	{ '\'' },	CC1,
	START,	{ '/' },	COM1,
	START,	{ 0xFD },	S_EOF,
	START,	{ '\n' },	S_NL,
	START,	{ '-' },	MINUS1,
	START,	{ '+' },	PLUS1,
	START,	{ '<' },	LT1,
	START,	{ '>' },	GT1,
	START,	{ '=' },	ASG1,
	START,	{ '!' },	NOT1,
	START,	{ '&' },	AND1,
	START,	{ '|' },	OR1,
	START,	{ '#' },	SHARP1,
	START,	{ '%' },	PCT1,
	START,	{ '[' },	((SBRA<<7)+S_SELF),
	START,	{ ']' },	((SKET<<7)+S_SELF),
	START,	{ '(' },	((LP<<7)+S_SELF),
	START,	{ ')' },	((RP<<7)+S_SELF),
	START,	{ '*' },	STAR1,
	START,	{ ',' },	((COMMA<<7)+S_SELF),
	START,	{ '?' },	((QUEST<<7)+S_SELF),
	START,	{ ':' },	((COLON<<7)+S_SELF),
	START,	{ ';' },	((SEMIC<<7)+S_SELF),
	START,	{ '{' },	((CBRA<<7)+S_SELF),
	START,	{ '}' },	((CKET<<7)+S_SELF),
	START,	{ '~' },	((TILDE<<7)+S_SELF),
	START,	{ '^' },	CIRC1,

	
	NUM1,	{ 5 },	((NUMBER<<7)+S_SELFB),
	NUM1,	{ 3, 2, '.' },	NUM1,
	NUM1,	{ 'E', 'e' },	NUM2,
	NUM1,	{ '_' },	((NUMBER<<7)+S_SELFB),

	
	NUM2,	{ 5 },	((NUMBER<<7)+S_SELFB),
	NUM2,	{ '+', '-' },	NUM1,
	NUM2,	{ 3, 2 },	NUM1,
	NUM2,	{ '_' },	((NUMBER<<7)+S_SELFB),

	
	NUM3,	{ 5 },	((DOT<<7)+S_SELFB),
	NUM3,	{ '.' },	DOTS1,
	NUM3,	{ 3 },	NUM1,

	DOTS1,	{ 5 },	((UNCLASS<<7)+S_SELFB),
	DOTS1,	{ 3 },	NUM1,
	DOTS1,	{ '.' },	((ELLIPS<<7)+S_SELF),

	
	ID1,	{ 5 },	((NAME<<7)+S_NAME),
	ID1,	{ 2, 3 },	ID1,

	
	ST1,	{ 5 },	((NAME<<7)+S_NAME),
	ST1,	{ 2, 3 },	ID1,
	ST1,	{ '"' },	ST2,
	ST1,	{ '\'' },	CC1,

	
	ST2,	{ 5 },	ST2,
	ST2,	{ '"' },	((STRING<<7)+S_SELF),
	ST2,	{ '\\' },	ST3,
	ST2,	{ '\n' },	S_STNL,
	ST2,	{ 0xFD },	S_EOFSTR,

	
	ST3,	{ 5 },	ST2,
	ST3,	{ '\n' },	S_STNL,
	ST3,	{ 0xFD },	S_EOFSTR,

	
	CC1,	{ 5 },	CC1,
	CC1,	{ '\'' },	((CCON<<7)+S_SELF),
	CC1,	{ '\\' },	CC2,
	CC1,	{ '\n' },	S_STNL,
	CC1,	{ 0xFD },	S_EOFSTR,

	
	CC2,	{ 5 },	CC1,
	CC2,	{ '\n' },	S_STNL,
	CC2,	{ 0xFD },	S_EOFSTR,

	
	COM1,	{ 5 },	((SLASH<<7)+S_SELFB),
	COM1,	{ '=' },	((ASSLASH<<7)+S_SELF),
	COM1,	{ '*' },	COM2,
	COM1,	{ '/' },	COM4,

	
	COM2,	{ 5 },	COM2,
	COM2,	{ '\n' },	S_COMNL,
	COM2,	{ '*' },	COM3,
	COM2,	{ 0xFD },	S_EOFCOM,

	
	COM3,	{ 5 },	COM2,
	COM3,	{ '\n' },	S_COMNL,
	COM3,	{ '*' },	COM3,
	COM3,	{ '/' },	S_COMMENT,

	
	COM4,	{ 5 },	COM4,
	COM4,	{ '\n' },	S_NL,
	COM4,	{ 0xFD },	S_EOFCOM,

	
	WS1,	{ 5 },	S_WS,
	WS1,	{ ' ', '\t', '\v' },	WS1,

	
	MINUS1,	{ 5 },	((MINUS<<7)+S_SELFB),
	MINUS1,	{ '-' },	((MMINUS<<7)+S_SELF),
	MINUS1,	{ '=' },	((ASMINUS<<7)+S_SELF),
	MINUS1,	{ '>' },	((ARROW<<7)+S_SELF),

	
	PLUS1,	{ 5 },	((PLUS<<7)+S_SELFB),
	PLUS1,	{ '+' },	((PPLUS<<7)+S_SELF),
	PLUS1,	{ '=' },	((ASPLUS<<7)+S_SELF),

	
	LT1,	{ 5 },	((LT<<7)+S_SELFB),
	LT1,	{ '<' },	LT2,
	LT1,	{ '=' },	((LEQ<<7)+S_SELF),
	LT2,	{ 5 },	((LSH<<7)+S_SELFB),
	LT2,	{ '=' },	((ASLSH<<7)+S_SELF),

	
	GT1,	{ 5 },	((GT<<7)+S_SELFB),
	GT1,	{ '>' },	GT2,
	GT1,	{ '=' },	((GEQ<<7)+S_SELF),
	GT2,	{ 5 },	((RSH<<7)+S_SELFB),
	GT2,	{ '=' },	((ASRSH<<7)+S_SELF),

	
	ASG1,	{ 5 },	((ASGN<<7)+S_SELFB),
	ASG1,	{ '=' },	((EQ<<7)+S_SELF),

	
	NOT1,	{ 5 },	((NOT<<7)+S_SELFB),
	NOT1,	{ '=' },	((NEQ<<7)+S_SELF),

	
	AND1,	{ 5 },	((AND<<7)+S_SELFB),
	AND1,	{ '&' },	((LAND<<7)+S_SELF),
	AND1,	{ '=' },	((ASAND<<7)+S_SELF),

	
	OR1,	{ 5 },	((OR<<7)+S_SELFB),
	OR1,	{ '|' },	((LOR<<7)+S_SELF),
	OR1,	{ '=' },	((ASOR<<7)+S_SELF),

	
	SHARP1,	{ 5 },	((SHARP<<7)+S_SELFB),
	SHARP1,	{ '#' },	((DSHARP<<7)+S_SELF),

	
	PCT1,	{ 5 },	((PCT<<7)+S_SELFB),
	PCT1,	{ '=' },	((ASPCT<<7)+S_SELF),

	
	STAR1,	{ 5 },	((STAR<<7)+S_SELFB),
	STAR1,	{ '=' },	((ASSTAR<<7)+S_SELF),

	
	CIRC1,	{ 5 },	((CIRC<<7)+S_SELFB),
	CIRC1,	{ '=' },	((ASCIRC<<7)+S_SELF),

	-1
};



short	bigfsm[256][32];

void
expandlex(void)
{
	          struct fsm *fp;
	int i, j, nstate;

	for (fp = fsm; fp->state>=0; fp++) {
		for (i=0; fp->ch[i]; i++) {
			nstate = fp->nextstate;
			if (nstate >= S_SELF)
				nstate = ~nstate;
			switch (fp->ch[i]) {

			case 5:		
				for (j=0; j<256; j++)
					bigfsm[j][fp->state] = nstate;
				continue;
			case 2:
				for (j=0; j<=256; j++)
					if ('a'<=j&&j<='z' || 'A'<=j&&j<='Z'
					  || j=='_')
						bigfsm[j][fp->state] = nstate;
				continue;
			case 3:
				for (j='0'; j<='9'; j++)
					bigfsm[j][fp->state] = nstate;
				continue;
			default:
				bigfsm[fp->ch[i]][fp->state] = nstate;
			}
		}
	}
	
	for (i=0; i<32; i++) {
		for (j=0; j<0xFF; j++)
			if (j=='?' || j=='\\') {
				if (bigfsm[j][i]>0)
					bigfsm[j][i] = ~bigfsm[j][i];
				bigfsm[j][i] &= ~0100;
			}
		bigfsm[0xFE][i] = ~S_EOB;
		if (bigfsm[0xFD][i]>=0)
			bigfsm[0xFD][i] = ~S_EOF;
	}
}

void
fixlex(void)
{
	
	if (Cplusplus==0)
		bigfsm['/'][COM1] = bigfsm['x'][COM1];
}








int
gettokens(Tokenrow *trp, int reset)
{
	register int c, state, oldstate;
	register uchar *ip;
	register Token *tp, *maxp;
	int runelen;
	Source *s = cursource;
	int nmac = 0;
	extern char outbuf[];

	tp = trp->lp;
	ip = s->inp;
	if (reset) {
		s->lineinc = 0;
		if (ip>=s->inl) {		
			s->inl = s->inb;
			fillbuf(s);
			ip = s->inp = s->inb;
		} else if (ip >= s->inb+(3*32768/4)) {
			memmove(s->inb, ip, 4+s->inl-ip);
			s->inl = s->inb+(s->inl-ip);
			ip = s->inp = s->inb;
		}
	}
	maxp = &trp->bp[trp->max];
	runelen = 1;
	for (;;) {
	   continue2:
		if (tp>=maxp) {
			trp->lp = tp;
			tp = growtokenrow(trp);
			maxp = &trp->bp[trp->max];
		}
		tp->type = UNCLASS;
		tp->hideset = 0;
		tp->t = ip;
		tp->wslen = 0;
		tp->flag = 0;
		state = START;
		for (;;) {
			oldstate = state;
			c = *ip;
			if ((state = bigfsm[c][state]) >= 0) {
				ip += runelen;
				runelen = 1;
				continue;
			}
			state = ~state;
		reswitch:
			switch (state&0177) {
			case S_SELF:
				ip += runelen;
				runelen = 1;
			case S_SELFB:
				tp->type = (state>>7)&0x1ff;
				tp->len = ip - tp->t;
				tp++;
				goto continue2;

			case S_NAME:	
				tp->type = NAME;
				tp->len = ip - tp->t;
				nmac |= (namebit[(tp->t[0])&077] & (1<<((tp->len>1?tp->t[1]:0)&037)));
				tp++;
				goto continue2;

			case S_WS:
				tp->wslen = ip - tp->t;
				tp->t = ip;
				state = START;
				continue;

			default:
				if ((state&0100)==0) {
					ip += runelen;
					runelen = 1;
					continue;
				}
				state &= ~0100;
				s->inp = ip;
				if (c=='?') { 	
					if (trigraph(s)) {
						state = oldstate;
						continue;
					}
					goto reswitch;
				}
				if (c=='\\') {
					if (foldline(s)) {
						s->lineinc++;
						state = oldstate;
						continue;
					}
					goto reswitch;
				}
				error(WARNING, "Lexical botch in cpp");
				ip += runelen;
				runelen = 1;
				continue;

			case S_EOB:
				s->inp = ip;
				fillbuf(cursource);
				state = oldstate;
				continue;

			case S_EOF:
				tp->type = END;
				tp->len = 0;
				s->inp = ip;
				if (tp!=trp->bp && (tp-1)->type!=NL && cursource->fd!=((void *) 0))
					error(WARNING,"No newline at end of file");
				trp->lp = tp+1;
				return nmac;

			case S_STNL:
				error(ERROR, "Unterminated string or char const");
			case S_NL:
				tp->t = ip;
				tp->type = NL;
				tp->len = 1;
				tp->wslen = 0;
				s->lineinc++;
				s->inp = ip+1;
				trp->lp = tp+1;
				return nmac;

			case S_EOFSTR:
				error(FATAL, "EOF in string or char constant");
				break;

			case S_COMNL:
				s->lineinc++;
				state = COM2;
				ip += runelen;
				runelen = 1;
				if (ip >= s->inb+(7*32768/8)) {
					memmove(tp->t, ip, 4+s->inl-ip);
					s->inl -= ip-tp->t;
					ip = tp->t+1;
				}
				continue;

			case S_EOFCOM:
				error(WARNING, "EOF inside comment");
				--ip;
			case S_COMMENT:
				++ip;
				tp->t = ip;
				tp->t[-1] = ' ';
				tp->wslen = 1;
				state = START;
				continue;
			}
			break;
		}
		ip += runelen;
		runelen = 1;
		tp->len = ip - tp->t;
		tp++;
	}
}


int
trigraph(Source *s)
{
	int c;

	while (s->inp+2 >= s->inl && fillbuf(s)!=(-1))
		;
	if (s->inp[1]!='?')
		return 0;
	c = 0;
	switch(s->inp[2]) {
	case '=':
		c = '#'; break;
	case '(':
		c = '['; break;
	case '/':
		c = '\\'; break;
	case ')':
		c = ']'; break;
	case '\'':
		c = '^'; break;
	case '<':
		c = '{'; break;
	case '!':
		c = '|'; break;
	case '>':
		c = '}'; break;
	case '-':
		c = '~'; break;
	}
	if (c) {
		*s->inp = c;
		memmove(s->inp+1, s->inp+3, s->inl-s->inp+2);
		s->inl -= 2;
	}
	return c;
}

int
foldline(Source *s)
{
	while (s->inp+1 >= s->inl && fillbuf(s)!=(-1))
		;
	if (s->inp[1] == '\n') {
		memmove(s->inp, s->inp+2, s->inl-s->inp+3);
		s->inl -= 2;
		return 1;
	}
	return 0;
}

int
fillbuf(Source *s)
{
	int n, nr;

	nr = 32768/8;
	if ((char *)s->inl+nr > (char *)s->inb+32768)
		error(FATAL, "Input buffer overflow");
	if (s->fd==((void *) 0) || (n=fread((char *)s->inl, 1, 32768/8, s->fd)) <= 0)
		n = 0;
	if ((*s->inp&0xff) == 0xFE)
		*s->inp = 0xFD;
	s->inl += n;
	s->inl[0] = s->inl[1]= s->inl[2]= s->inl[3] = 0xFE;
	if (n==0) {
		s->inl[0] = s->inl[1]= s->inl[2]= s->inl[3] = 0xFD;
		return (-1);
	}
	return 0;
}






Source *
setsource(char *name, FILE *fd, char *str)
{
	Source *s = (Source *)domalloc(sizeof(Source));
	int len;

	s->line = 1;
	s->lineinc = 0;
	s->fd = fd;
	s->filename = name;
	s->next = cursource;
	s->ifdepth = 0;
	cursource = s;
	
	if (str) {
		len = strlen(str);
		s->inb = domalloc(len+4);
		s->inp = s->inb;
		strncpy((char *)s->inp, str, len);
	} else {
		s->inb = domalloc(32768+4);
		s->inp = s->inb;
		len = 0;
	}
	s->inl = s->inp+len;
	s->inl[0] = s->inl[1] = 0xFE;
	return s;
}

void
unsetsource(void)
{
	Source *s = cursource;

	if (s->fd != ((void *) 0)) {
		fclose(s->fd);
		dofree(s->inb);
	}
	cursource = s->next;
	dofree(s);
}
