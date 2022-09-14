# 1 "ccl.c"

# 39 "/home/charles/xcc/jewel/include/sys/jewel.h"
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
# 48 "/home/charles/xcc/jewel/include/stdio.h"
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
# 44 "/home/charles/xcc/jewel/include/string.h"
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
# 53 "/home/charles/xcc/jewel/include/stdlib.h"
extern void (*__exit_cleanup)(void);
extern void __stdio_cleanup(void);

extern int atoi(const char *);
extern long atol(const char *);

extern void *bsearch(const void *, const void *, size_t, size_t,
                     int (*)(const void *, const void *));







extern void abort(void);
extern void _exit(int);
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
# 333 "flexdef.h"
struct hash_entry
    {
    struct hash_entry *prev, *next;
    char *name;
    char *str_val;
    int int_val;
    } ;

typedef struct hash_entry *hash_table[];





extern struct hash_entry *ndtbl[101];
extern struct hash_entry *sctbl[101];
extern struct hash_entry *ccltab[101];
# 383 "flexdef.h"
extern int printstats, syntaxerror, eofseen, ddebug, trace, spprdflt;
extern int interactive, caseins, useecs, fulltbl, usemecs;
extern int fullspd, gen_line_dirs, performance_report, backtrack_report, csize;
extern int yymore_used, reject, real_reject, continued_action;




extern int yymore_really_used, reject_really_used;


















extern int datapos, dataline, linenum;
extern FILE *skelfile, *yyin, *temp_action_file, *backtrack_file;
extern char *infilename;
extern char *action_file_name;
extern char **input_files;
extern int num_input_files;
extern char *program_name;










extern int onestate[500], onesym[500];
extern int onenext[500], onedef[500], onesp;
# 457 "flexdef.h"
extern int current_mns, num_rules, current_max_rules, lastnfa;
extern int *firstst, *lastst, *finalst, *transchar, *trans1, *trans2;
extern int *accptnum, *assoc_rule, *state_type, *rule_type, *rule_linenum;









extern int current_state_type;








extern int variable_trailing_context_rules;














extern int numtemps, numprots, protprev[50], protnext[50], prottbl[50];
extern int protcomst[50], firstprot, lastprot, protsave[2000];



















extern int numecs, nextecm[256 + 1], ecgroup[256 + 1], nummecs;






extern int tecfwd[256 + 1], tecbck[256 + 1];

extern int *xlation;
extern int num_xlations;













extern int lastsc, current_max_scs, *scset, *scbol, *scxclu, *sceof, *actvsc;
extern char **scname;
# 572 "flexdef.h"
extern int current_max_dfa_size, current_max_xpairs;
extern int current_max_template_xpairs, current_max_dfas;
extern int lastdfa, lasttemp, *nxt, *chk, *tnxt;
extern int *base, *def, *nultrans, NUL_ec, tblend, firstfree, **dss, *dfasiz;
extern union dfaacc_union
    {
    int *dfaacc_set;
    int dfaacc_state;
    } *dfaacc;
extern int *accsiz, *dhash, numas;
extern int numsnpairs, jambase, jamstate;
extern int end_of_buffer_state;













extern int lastccl, current_maxccls, *cclmap, *ccllen, *cclng, cclreuse;
extern int current_max_ccl_tbl_size;
extern unsigned char *ccltbl;
# 624 "flexdef.h"
extern char *starttime, *endtime, nmstr[1024];
extern int sectnum, nummt, hshcol, dfaeql, numeps, eps2, num_reallocs;
extern int tmpuses, totnst, peakpairs, numuniq, numdup, hshsave;
extern int num_backtracking, bol_needed;

void *allocate_array(), *reallocate_array();
# 667 "flexdef.h"
extern int yylval;







extern void ccladd (int, int);
extern int cclinit ();
extern void cclnegate (int);


extern void list_character_set (FILE*, int[]);





extern void increase_max_dfas ();

extern void ntod ();





extern void ccl2ecl ();


extern int cre8ecs (int[], int[], int);


extern int ecs_from_xlation (int[]);


extern void mkeccl (unsigned char[], int, int[], int[], int, int);


extern void mkechar (int, int[], int[]);




extern void make_tables ();




extern void flexend (int);





extern void action_out ();


extern int all_lower (register unsigned char *);


extern int all_upper (register unsigned char *);


extern void bubble (int [], int);


extern void cshell (unsigned char [], int, int);

extern void dataend ();


extern void flexerror (char[]);


extern void flexfatal (char[]);


extern void lerrif (char[], int);


extern void lerrsf (char[], char[]);


extern void line_directive_out (FILE*);


extern void mk2data (int);

extern void mkdata (int);


extern int myctoi (unsigned char []);


extern void skelout ();


extern void transition_struct_out (int, int);





extern void add_accept (int, int);


extern int copysingl (int, int);


extern void dumpnfa (int);


extern void finish_rule (int, int, int, int);


extern int link_machines (int, int);




extern void mark_beginning_as_normal (register int);


extern int mkbranch (int, int);

extern int mkclos (int);
extern int mkopt (int);


extern int mkor (int, int);


extern int mkposcl (int);

extern int mkrep (int, int, int);


extern int mkstate (int);

extern void new_rule ();





extern void format_pinpoint_message (char[], char[]);


extern void pinpoint_message (char[]);

extern void synerr (char []);
extern int yyparse ();




extern int flexscan ();


extern void set_input_file (char*);

extern int yywrap ();





extern void cclinstal (unsigned char [], int);


extern int ccllookup (unsigned char []);

extern void ndinstal (char[], unsigned char[]);
extern void scinstal (char[], int);


extern int sclookup (char[]);





extern void bldtbl (int[], int, int, int, int);

extern void cmptmps ();
extern void inittbl ();
extern void mkdeftbl ();



extern void mk1tbl (int, int, int, int);


extern void place_state (int*, int, int);


extern void stack1 (int, int, int, int);




extern int yylex ();




extern int read (int, char*, int);
extern int unlink (char*);
extern int write (int, char*, int);
# 41 "ccl.c"
void ccladd( cclp, ch )
int cclp;
int ch;

    {
    int ind, len, newpos, i;

    len = ccllen[cclp];
    ind = cclmap[cclp];



    for ( i = 0; i < len; ++i )
	if ( ccltbl[ind + i] == ch )
	    return;

    newpos = ind + len;

    if ( newpos >= current_max_ccl_tbl_size )
	{
	current_max_ccl_tbl_size += 250;

	++num_reallocs;

	ccltbl = (unsigned char *) reallocate_array( (void *) ccltbl, current_max_ccl_tbl_size, sizeof( unsigned char ) );
	}

    ccllen[cclp] = len + 1;
    ccltbl[newpos] = ch;
    }









int cclinit()

    {
    if ( ++lastccl >= current_maxccls )
	{
	current_maxccls += 100;

	++num_reallocs;

	cclmap = (int *) reallocate_array( (void *) cclmap, current_maxccls, sizeof( int ) );
	ccllen = (int *) reallocate_array( (void *) ccllen, current_maxccls, sizeof( int ) );
	cclng = (int *) reallocate_array( (void *) cclng, current_maxccls, sizeof( int ) );
	}

    if ( lastccl == 1 )

	cclmap[lastccl] = 0;

    else





	cclmap[lastccl] = cclmap[lastccl - 1] + ccllen[lastccl - 1];

    ccllen[lastccl] = 0;
    cclng[lastccl] = 0;

    return ( lastccl );
    }









void cclnegate( cclp )
int cclp;

    {
    cclng[cclp] = 1;
    }














void list_character_set( file, cset )
FILE *file;
int cset[];

    {
    register int i;
    char *readable_form();

    (--(file)->_count >= 0 ? (int) (*(file)->_ptr++ = ('[')) : __flushbuf(('['),(file)));

    for ( i = 0; i < csize; ++i )
	{
	if ( cset[i] )
	    {
	    register int start_char = i;

	    (--(file)->_count >= 0 ? (int) (*(file)->_ptr++ = (' ')) : __flushbuf((' '),(file)));

	    fputs( readable_form( i ), file );

	    while ( ++i < csize && cset[i] )
		;

	    if ( i - 1 > start_char )

		fprintf( file, "-%s", readable_form( i - 1 ) );

	    (--(file)->_count >= 0 ? (int) (*(file)->_ptr++ = (' ')) : __flushbuf((' '),(file)));
	    }
	}

    (--(file)->_count >= 0 ? (int) (*(file)->_ptr++ = (']')) : __flushbuf((']'),(file)));
    }
