# 1 "lalr.c"

# 44 "/home/charles/xcc/include/assert.h"
extern void __assert(const char *e, const char *file, int line);
# 44 "/home/charles/xcc/include/ctype.h"
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
# 39 "/home/charles/xcc/include/sys/jewel.h"
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
# 48 "/home/charles/xcc/include/stdio.h"
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
# 44 "/home/charles/xcc/include/string.h"
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
# 53 "/home/charles/xcc/include/stdlib.h"
extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void abort(void);
extern void _exit(int);
extern void exit(int);

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
# 48 "/home/charles/xcc/include/unistd.h"
typedef __ssize_t ssize_t;




typedef __pid_t pid_t;











extern int access(const char *, int);





extern void *__brk(void *);

extern int brk(void *);
extern void *sbrk(__ssize_t);

extern int close(int);
extern int execve(const char *, char *const [], char *const []);
extern int execvp(const char *, char *const []);
extern int execvpe(const char *, char *const [], char *const []);
extern pid_t fork(void);
extern pid_t getpid(void);
extern int isatty(int);





extern __off_t lseek(int, __off_t, int);

extern __ssize_t read(int, void *, __size_t);
extern int unlink(const char *);
extern __ssize_t write(int, const void *, __size_t);

extern char *optarg;
extern int optind;
extern int opterr;
extern int optopt;

extern int getopt(int, char *const[], const char *);
# 129 "defs.h"
typedef struct bucket bucket;
struct bucket
{
    struct bucket *link;
    struct bucket *next;
    char *name;
    char *tag;
    short value;
    short index;
    short prec;
    char class;
    char assoc;
};




typedef struct core core;
struct core
{
    struct core *next;
    struct core *link;
    short number;
    short accessing_symbol;
    short nitems;
    short items[1];
};




typedef struct shifts shifts;
struct shifts
{
    struct shifts *next;
    short number;
    short nshifts;
    short shift[1];
};




typedef struct reductions reductions;
struct reductions
{
    struct reductions *next;
    short number;
    short nreds;
    short rules[1];
};




typedef struct action action;
struct action
{
    struct action *next;
    short symbol;
    short number;
    short prec;
    char action_code;
    char assoc;
    char suppressed;
};




extern char dflag;
extern char lflag;
extern char rflag;
extern char tflag;
extern char vflag;
extern char *symbol_prefix;

extern char *myname;
extern char *cptr;
extern char *line;
extern int lineno;
extern int outline;

extern char *banner[];
extern char *tables[];
extern char *header[];
extern char *body[];
extern char *trailer[];

extern char *action_file_name;
extern char *code_file_name;
extern char *defines_file_name;
extern char *input_file_name;
extern char *output_file_name;
extern char *text_file_name;
extern char *union_file_name;
extern char *verbose_file_name;

extern FILE *action_file;
extern FILE *code_file;
extern FILE *defines_file;
extern FILE *input_file;
extern FILE *output_file;
extern FILE *text_file;
extern FILE *union_file;
extern FILE *verbose_file;

extern int nitems;
extern int nrules;
extern int nsyms;
extern int ntokens;
extern int nvars;
extern int ntags;

extern char unionized;
extern char line_format[];

extern int   start_symbol;
extern char  **symbol_name;
extern short *symbol_value;
extern short *symbol_prec;
extern char  *symbol_assoc;

extern short *ritem;
extern short *rlhs;
extern short *rrhs;
extern short *rprec;
extern char  *rassoc;

extern short **derives;
extern char *nullable;

extern bucket *first_symbol;
extern bucket *last_symbol;

extern int nstates;
extern core *first_state;
extern shifts *first_shift;
extern reductions *first_reduction;
extern short *accessing_symbol;
extern core **state_table;
extern shifts **shift_table;
extern reductions **reduction_table;
extern unsigned *LA;
extern short *LAruleno;
extern short *lookaheads;
extern short *goto_map;
extern short *from_state;
extern short *to_state;

extern action **parser;
extern int SRtotal;
extern int RRtotal;
extern short *SRconflicts;
extern short *RRconflicts;
extern short *defred;
extern short *rules_used;
extern short nunused;
extern short final_state;




extern char *allocate(size_t n);



extern void closure(short *nucleus, int n);
extern void set_first_derives(void);
extern void finalize_closure(void);



extern void fatal(char *msg);
extern void no_space(void);
extern void open_error(char *filename);
extern void unexpected_EOF(void);
extern void print_pos(char *st_line, char *st_cptr);
extern void syntax_error(int st_lineno, char *st_line, char *st_cptr);
extern void unterminated_comment(int c_lineno, char *c_line, char *c_cptr);
extern void unterminated_string(int s_lineno, char *s_line, char *s_cptr);
extern void unterminated_text(int t_lineno, char *t_line, char *t_cptr);
extern void unterminated_union(int u_lineno, char *u_line, char *u_cptr);
extern void over_unionized(char *u_cptr);
extern void illegal_tag(int t_lineno, char *t_line, char *t_cptr);
extern void illegal_character(char *c_cptr);
extern void used_reserved(char *s);
extern void tokenized_start(char *s);
extern void retyped_warning(char *s);
extern void reprec_warning(char *s);
extern void revalued_warning(char *s);
extern void terminal_start(char *s);
extern void restarted_warning(void);
extern void no_grammar(void);
extern void terminal_lhs(int s_lineno);
extern void prec_redeclared(void);
extern void unterminated_action(int a_lineno, char *a_line, char *a_cptr);
extern void dollar_warning(int a_lineno, int i);
extern void dollar_error(int a_lineno, char *a_line, char *a_cptr);
extern void untyped_lhs(void);
extern void untyped_rhs(int i, char *s);
extern void unknown_rhs(int i);
extern void default_action_warning(void);
extern void undefined_goal(char *s);
extern void undefined_symbol_warning(char *s);



extern void lalr(void);



extern void lr0(void);



extern void done(int k);



extern action *parse_actions(int stateno);
extern action *get_shifts(int stateno);
extern action *add_reductions(int stateno, action *actions);
extern action *add_reduce(action *actions, int ruleno, int symbol);
extern void make_parser(void);
extern void free_parser(void);



extern void output(void);



extern void reader(void);



extern void write_section(char *name[]);



extern void create_symbol_table(void);
extern void free_symbol_table(void);
extern void free_symbols(void);
extern bucket *lookup(char *name);
extern bucket *make_bucket(char *name);



extern void verbose(void);



extern void reflexive_transitive_closure(unsigned *R, int n);
# 18 "lalr.c"
typedef
  struct shorts
    {
      struct shorts *next;
      short value;
    }
  shorts;

int tokensetsize;
short *lookaheads;
short *LAruleno;
unsigned *LA;
short *accessing_symbol;
core **state_table;
shifts **shift_table;
reductions **reduction_table;
short *goto_map;
short *from_state;
short *to_state;

static short **transpose();

static int infinity;
static int maxrhs;
static int ngotos;
static unsigned *F;
static short **includes;
static shorts **lookback;
static short **R;
static short *INDEX;
static short *VERTICES;
static int top;


static void
set_state_table()
{
    core *sp;

    state_table = ((core **)allocate((unsigned)((nstates)*sizeof(core *))));
    for (sp = first_state; sp; sp = sp->next)
	state_table[sp->number] = sp;
}


static void
set_accessing_symbol(void)
{
    core *sp;

    accessing_symbol = ((short*)allocate((unsigned)((nstates)*sizeof(short))));
    for (sp = first_state; sp; sp = sp->next)
	accessing_symbol[sp->number] = sp->accessing_symbol;
}


static void
set_shift_table(void)
{
    shifts *sp;

    shift_table = ((shifts **)allocate((unsigned)((nstates)*sizeof(shifts *))));
    for (sp = first_shift; sp; sp = sp->next)
	shift_table[sp->number] = sp;
}


static void
set_reduction_table(void)
{
    reductions *rp;

    reduction_table = ((reductions **)allocate((unsigned)((nstates)*sizeof(reductions *))));
    for (rp = first_reduction; rp; rp = rp->next)
	reduction_table[rp->number] = rp;
}


static void
set_maxrhs(void)
{
    short *itemp;
    short *item_end;
    int length;
    int max;

    length = 0;
    max = 0;
    item_end = ritem + nitems;
    for (itemp = ritem; itemp < item_end; itemp++)
    {
        if (*itemp >= 0)
	{
	    length++;
	}
        else
	{
	    if (length > max) max = length;
	    length = 0;
	}
    }

    maxrhs = max;
}


static void
initialize_LA(void)
{
    int i, j, k;
    reductions *rp;

    lookaheads = ((short*)allocate((unsigned)((nstates + 1)*sizeof(short))));

    k = 0;
    for (i = 0; i < nstates; i++)
    {
        lookaheads[i] = k;
        rp = reduction_table[i];
        if (rp)
	  k += rp->nreds;
    }
    lookaheads[nstates] = k;

    LA = ((unsigned*)allocate((unsigned)((k * tokensetsize)*sizeof(unsigned))));
    LAruleno = ((short*)allocate((unsigned)((k)*sizeof(short))));
    lookback = ((shorts **)allocate((unsigned)((k)*sizeof(shorts *))));

    k = 0;
    for (i = 0; i < nstates; i++)
    {
        rp = reduction_table[i];
        if (rp)
	{
	    for (j = 0; j < rp->nreds; j++)
	    {
	        LAruleno[k] = rp->rules[j];
	        k++;
	    }
	}
    }
}


static void
set_goto_map(void)
{
  shifts *sp;
  int i;
  int symbol;
  int k;
  short *temp_map;
  int state2;
  int state1;

  goto_map = ((short*)allocate((unsigned)((nvars + 1)*sizeof(short)))) - ntokens;
  temp_map = ((short*)allocate((unsigned)((nvars + 1)*sizeof(short)))) - ntokens;

  ngotos = 0;
  for (sp = first_shift; sp; sp = sp->next)
    {
      for (i = sp->nshifts - 1; i >= 0; i--)
	{
	  symbol = accessing_symbol[sp->shift[i]];

	  if (((symbol) < start_symbol)) break;

	  if (ngotos == 32767)
	    fatal("too many gotos");

	  ngotos++;
	  goto_map[symbol]++;
        }
    }

  k = 0;
  for (i = ntokens; i < nsyms; i++)
    {
      temp_map[i] = k;
      k += goto_map[i];
    }

  for (i = ntokens; i < nsyms; i++)
    goto_map[i] = temp_map[i];

  goto_map[nsyms] = ngotos;
  temp_map[nsyms] = ngotos;

  from_state = ((short*)allocate((unsigned)((ngotos)*sizeof(short))));
  to_state = ((short*)allocate((unsigned)((ngotos)*sizeof(short))));

  for (sp = first_shift; sp; sp = sp->next)
    {
      state1 = sp->number;
      for (i = sp->nshifts - 1; i >= 0; i--)
	{
	  state2 = sp->shift[i];
	  symbol = accessing_symbol[state2];

	  if (((symbol) < start_symbol)) break;

	  k = temp_map[symbol]++;
	  from_state[k] = state1;
	  to_state[k] = state2;
	}
    }

  (free((char*)(temp_map + ntokens)));
}





static int
map_goto(int state, int symbol)
{
    int high;
    int low;
    int middle;
    int s;

    low = goto_map[symbol];
    high = goto_map[symbol + 1];

    for (;;)
    {
	if (!(low <= high)) __assert("low <= high", "lalr.c", 245);;
	middle = (low + high) >> 1;
	s = from_state[middle];
	if (s == state)
	    return (middle);
	else if (s < state)
	    low = middle + 1;
	else
	    high = middle - 1;
    }
}


static void
traverse(int i)
{
    unsigned *fp1;
    unsigned *fp2;
    unsigned *fp3;
    int j;
    short *rp;

    int height;
    unsigned *base;

    VERTICES[++top] = i;
    INDEX[i] = height = top;

    base = F + i * tokensetsize;
    fp3 = base + tokensetsize;

    rp = R[i];
    if (rp)
    {
        while ((j = *rp++) >= 0)
	{
	    if (INDEX[j] == 0)
	        traverse(j);

	    if (INDEX[i] > INDEX[j])
	        INDEX[i] = INDEX[j];

	    fp1 = base;
	    fp2 = F + j * tokensetsize;

	    while (fp1 < fp3)
	        *fp1++ |= *fp2++;
	}
    }

    if (INDEX[i] == height)
    {
        for (;;)
	{
	    j = VERTICES[top--];
	    INDEX[j] = infinity;

	    if (i == j)
	        break;

	    fp1 = base;
	    fp2 = F + j * tokensetsize;

	    while (fp1 < fp3)
	        *fp2++ = *fp1++;
	}
    }
}


static void
digraph(short **relation)
{
    int i;

    infinity = ngotos + 2;
    INDEX = ((short*)allocate((unsigned)((ngotos + 1)*sizeof(short))));
    VERTICES = ((short*)allocate((unsigned)((ngotos + 1)*sizeof(short))));
    top = 0;

    R = relation;

    for (i = 0; i < ngotos; i++)
        INDEX[i] = 0;

    for (i = 0; i < ngotos; i++)
    {
        if (INDEX[i] == 0 && R[i])
	    traverse(i);
    }

    (free((char*)(INDEX)));
    (free((char*)(VERTICES)));
}


static void
initialize_F(void)
{
    int i;
    int j;
    int k;
    shifts *sp;
    short *edge;
    unsigned *rowp;
    short *rp;
    short **reads;
    int nedges;
    int stateno;
    int symbol;
    int nwords;

    nwords = ngotos * tokensetsize;
    F = ((unsigned*)allocate((unsigned)((nwords)*sizeof(unsigned))));

    reads = ((short **)allocate((unsigned)((ngotos)*sizeof(short *))));
    edge = ((short*)allocate((unsigned)((ngotos + 1)*sizeof(short))));
    nedges = 0;

    rowp = F;
    for (i = 0; i < ngotos; i++)
    {
        stateno = to_state[i];
        sp = shift_table[stateno];

        if (sp)
	{
	    k = sp->nshifts;

	    for (j = 0; j < k; j++)
	    {
	        symbol = accessing_symbol[sp->shift[j]];
	        if (((symbol) >= start_symbol))
		  break;
	        ((rowp)[(symbol)>>5]|=((unsigned)1<<((symbol)&31)));
	    }

	    for (; j < k; j++)
	    {
	        symbol = accessing_symbol[sp->shift[j]];
	        if (nullable[symbol])
		    edge[nedges++] = map_goto(stateno, symbol);
	    }

	    if (nedges)
	    {
	        reads[i] = rp = ((short*)allocate((unsigned)((nedges + 1)*sizeof(short))));

	        for (j = 0; j < nedges; j++)
		    rp[j] = edge[j];

	        rp[nedges] = -1;
	        nedges = 0;
	    }
	}

        rowp += tokensetsize;
    }

    ((F)[(0)>>5]|=((unsigned)1<<((0)&31)));
    digraph(reads);

    for (i = 0; i < ngotos; i++)
    {
        if (reads[i])
	  (free((char*)(reads[i])));
    }

    (free((char*)(reads)));
    (free((char*)(edge)));
}


static void
add_lookback_edge(int stateno, int ruleno, int gotono)
{
    int i, k;
    int found;
    shorts *sp;

    i = lookaheads[stateno];
    k = lookaheads[stateno + 1];
    found = 0;
    while (!found && i < k)
    {
	if (LAruleno[i] == ruleno)
	    found = 1;
	else
	    ++i;
    }
    if (!(found)) __assert("found", "lalr.c", 435);;

    sp = ((shorts*)allocate(sizeof(shorts)));
    sp->next = lookback[i];
    sp->value = gotono;
    lookback[i] = sp;
}


static void
build_relations(void)
{
  int i;
  int j;
  int k;
  short *rulep;
  short *rp;
  shifts *sp;
  int length;
  int nedges;
  int done;
  int state1;
  int stateno;
  int symbol1;
  int symbol2;
  short *shortp;
  short *edge;
  short *states;
  short **new_includes;

  includes = ((short **)allocate((unsigned)((ngotos)*sizeof(short *))));
  edge = ((short*)allocate((unsigned)((ngotos + 1)*sizeof(short))));
  states = ((short*)allocate((unsigned)((maxrhs + 1)*sizeof(short))));

  for (i = 0; i < ngotos; i++)
    {
      nedges = 0;
      state1 = from_state[i];
      symbol1 = accessing_symbol[to_state[i]];

      for (rulep = derives[symbol1]; *rulep >= 0; rulep++)
	{
	  length = 1;
	  states[0] = state1;
	  stateno = state1;

	  for (rp = ritem + rrhs[*rulep]; *rp >= 0; rp++)
	    {
	      symbol2 = *rp;
	      sp = shift_table[stateno];
	      k = sp->nshifts;

	      for (j = 0; j < k; j++)
		{
		  stateno = sp->shift[j];
		  if (accessing_symbol[stateno] == symbol2) break;
		}

	      states[length++] = stateno;
	    }

	  add_lookback_edge(stateno, *rulep, i);

	  length--;
	  done = 0;
	  while (!done)
	    {
	      done = 1;
	      rp--;
	      if (((*rp) >= start_symbol))
		{
		  stateno = states[--length];
		  edge[nedges++] = map_goto(stateno, *rp);
		  if (nullable[*rp] && length > 0) done = 0;
		}
	    }
	}

      if (nedges)
	{
	  includes[i] = shortp = ((short*)allocate((unsigned)((nedges + 1)*sizeof(short))));
	  for (j = 0; j < nedges; j++)
	    shortp[j] = edge[j];
	  shortp[nedges] = -1;
	}
    }

  new_includes = transpose(includes, ngotos);

  for (i = 0; i < ngotos; i++)
    if (includes[i])
      (free((char*)(includes[i])));

  (free((char*)(includes)));

  includes = new_includes;

  (free((char*)(edge)));
  (free((char*)(states)));
}


static short **
transpose(short **R, int n)
{
  short **new_R;
  short **temp_R;
  short *nedges;
  short *sp;
  int i;
  int k;

  nedges = ((short*)allocate((unsigned)((n)*sizeof(short))));

  for (i = 0; i < n; i++)
    {
      sp = R[i];
      if (sp)
	{
	  while (*sp >= 0)
	    nedges[*sp++]++;
	}
    }

  new_R = ((short **)allocate((unsigned)((n)*sizeof(short *))));
  temp_R = ((short **)allocate((unsigned)((n)*sizeof(short *))));

  for (i = 0; i < n; i++)
    {
      k = nedges[i];
      if (k > 0)
	{
	  sp = ((short*)allocate((unsigned)((k + 1)*sizeof(short))));
	  new_R[i] = sp;
	  temp_R[i] = sp;
	  sp[k] = -1;
	}
    }

  (free((char*)(nedges)));

  for (i = 0; i < n; i++)
    {
      sp = R[i];
      if (sp)
	{
	  while (*sp >= 0)
	    *temp_R[*sp++]++ = i;
	}
    }

  (free((char*)(temp_R)));

  return (new_R);
}


static void
compute_FOLLOWS(void)
{
    digraph(includes);
}


static void
compute_lookaheads(void)
{
  int i, n;
  unsigned *fp1, *fp2, *fp3;
  shorts *sp, *next;
  unsigned *rowp;

  rowp = LA;
  n = lookaheads[nstates];
  for (i = 0; i < n; i++)
    {
      fp3 = rowp + tokensetsize;
      for (sp = lookback[i]; sp; sp = sp->next)
	{
	  fp1 = rowp;
	  fp2 = F + tokensetsize * sp->value;
	  while (fp1 < fp3)
	    *fp1++ |= *fp2++;
	}
      rowp = fp3;
    }

  for (i = 0; i < n; i++)
    for (sp = lookback[i]; sp; sp = next)
      {
        next = sp->next;
        (free((char*)(sp)));
      }

  (free((char*)(lookback)));
  (free((char*)(F)));
}


void
lalr(void)
{
    tokensetsize = (((ntokens)+(32-1))/32);

    set_state_table();
    set_accessing_symbol();
    set_shift_table();
    set_reduction_table();
    set_maxrhs();
    initialize_LA();
    set_goto_map();
    initialize_F();
    build_relations();
    compute_FOLLOWS();
    compute_lookaheads();
}
