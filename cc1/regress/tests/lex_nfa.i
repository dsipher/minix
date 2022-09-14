# 1 "nfa.c"

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
# 36 "nfa.c"
int dupmachine (int);
void mkxtion (int, int);











void add_accept( mach, accepting_number )
int mach, accepting_number;

    {






    if ( transchar[finalst[mach]] == (256 + 1) )
	accptnum[finalst[mach]] = accepting_number;

    else
	{
	int astate = mkstate( (256 + 1) );
	accptnum[astate] = accepting_number;
	mach = link_machines( mach, astate );
	}
    }













int copysingl( singl, num )
int singl, num;

    {
    int copy, i;

    copy = mkstate( (256 + 1) );

    for ( i = 1; i <= num; ++i )
	copy = link_machines( copy, dupmachine( singl ) );

    return ( copy );
    }









void dumpnfa( state1 )
int state1;

    {
    int sym, tsp1, tsp2, anum, ns;

    fprintf( (&__stderr), "\n\n********** beginning dump of nfa with start state %d\n",
	     state1 );








    for ( ns = 1; ns <= lastnfa; ++ns )
	{
	fprintf( (&__stderr), "state # %4d\t", ns );

	sym = transchar[ns];
	tsp1 = trans1[ns];
	tsp2 = trans2[ns];
	anum = accptnum[ns];

	fprintf( (&__stderr), "%3d:  %4d, %4d", sym, tsp1, tsp2 );

	if ( anum != 0 )
	    fprintf( (&__stderr), "  [%d]", anum );

	fprintf( (&__stderr), "\n" );
	}

    fprintf( (&__stderr), "********** end of dump\n" );
    }



















int dupmachine( mach )
int mach;

    {
    int i, init, state_offset;
    int state = 0;
    int last = lastst[mach];

    for ( i = firstst[mach]; i <= last; ++i )
	{
	state = mkstate( transchar[i] );

	if ( trans1[i] != 0 )
	    {
	    mkxtion( finalst[state], trans1[i] + state - i );

	    if ( transchar[i] == (256 + 1) && trans2[i] != 0 )
		mkxtion( finalst[state], trans2[i] + state - i );
	    }

	accptnum[state] = accptnum[i];
	}

    if ( state == 0 )
	flexfatal( "empty machine in dupmachine()" );

    state_offset = state - i + 1;

    init = mach + state_offset;
    firstst[init] = firstst[mach] + state_offset;
    finalst[init] = finalst[mach] + state_offset;
    lastst[init] = lastst[mach] + state_offset;

    return ( init );
    }


















void finish_rule( mach, variable_trail_rule, headcnt, trailcnt )
int mach, variable_trail_rule, headcnt, trailcnt;

    {
    add_accept( mach, num_rules );




    rule_linenum[num_rules] = linenum;




    if ( continued_action )
	--rule_linenum[num_rules];

    fprintf( temp_action_file, "case %d:\n", num_rules );

    if ( variable_trail_rule )
	{
	rule_type[num_rules] = 1;

	if ( performance_report )
	    fprintf( (&__stderr), "Variable trailing context rule at line %d\n",
		     rule_linenum[num_rules] );

	variable_trailing_context_rules = 1;
	}

    else
	{
	rule_type[num_rules] = 0;

	if ( headcnt > 0 || trailcnt > 0 )
	    {

	    char *scanner_cp = "yy_c_buf_p = yy_cp";
	    char *scanner_bp = "yy_bp";

	    fprintf( temp_action_file,
	"*yy_cp = yy_hold_char; /* undo effects of setting up yytext */\n" );

	    if ( headcnt > 0 )
		fprintf( temp_action_file, "%s = %s + %d;\n",
			 scanner_cp, scanner_bp, headcnt );

	    else
		fprintf( temp_action_file,
			 "%s -= %d;\n", scanner_cp, trailcnt );

	    fprintf( temp_action_file,
		     "YY_DO_BEFORE_ACTION; /* set up yytext again */\n" );
	    }
	}

    line_directive_out( temp_action_file );
    }


















int link_machines( first, last )
int first, last;

    {
    if ( first == 0 )
	return ( last );

    else if ( last == 0 )
	return ( first );

    else
	{
	mkxtion( finalst[first], last );
	finalst[first] = finalst[last];
	lastst[first] = ((lastst[first]) > (lastst[last]) ? (lastst[first]) : (lastst[last]));
	firstst[first] = ((firstst[first]) < (firstst[last]) ? (firstst[first]) : (firstst[last]));

	return ( first );
	}
    }















void mark_beginning_as_normal( mach )
register int mach;

    {
    switch ( state_type[mach] )
	{
	case 0x1:

	    return;

	case 0x2:
	    state_type[mach] = 0x1;

	    if ( transchar[mach] == (256 + 1) )
		{
		if ( trans1[mach] != 0 )
		    mark_beginning_as_normal( trans1[mach] );

		if ( trans2[mach] != 0 )
		    mark_beginning_as_normal( trans2[mach] );
		}
	    break;

	default:
	    flexerror( "bad state type in mark_beginning_as_normal()" );
	    break;
	}
    }
















int mkbranch( first, second )
int first, second;

    {
    int eps;

    if ( first == 0 )
	return ( second );

    else if ( second == 0 )
	return ( first );

    eps = mkstate( (256 + 1) );

    mkxtion( eps, first );
    mkxtion( eps, second );

    return ( eps );
    }










int mkclos( state )
int state;

    {
    return ( mkopt( mkposcl( state ) ) );
    }
















int mkopt( mach )
int mach;

    {
    int eps;

    if ( ! (transchar[finalst[mach]] == (256 + 1) && trans1[finalst[mach]] == 0) )
	{
	eps = mkstate( (256 + 1) );
	mach = link_machines( mach, eps );
	}





    eps = mkstate( (256 + 1) );
    mach = link_machines( eps, mach );

    mkxtion( mach, finalst[mach] );

    return ( mach );
    }
















int mkor( first, second )
int first, second;

    {
    int eps, orend;

    if ( first == 0 )
	return ( second );

    else if ( second == 0 )
	return ( first );

    else
	{



	eps = mkstate( (256 + 1) );

	first = link_machines( eps, first );

	mkxtion( first, second );

	if ( (transchar[finalst[first]] == (256 + 1) && trans1[finalst[first]] == 0) &&
	     accptnum[finalst[first]] == 0 )
	    {
	    orend = finalst[first];
	    mkxtion( finalst[second], orend );
	    }

	else if ( (transchar[finalst[second]] == (256 + 1) && trans1[finalst[second]] == 0) &&
		  accptnum[finalst[second]] == 0 )
	    {
	    orend = finalst[second];
	    mkxtion( finalst[first], orend );
	    }

	else
	    {
	    eps = mkstate( (256 + 1) );

	    first = link_machines( first, eps );
	    orend = finalst[first];

	    mkxtion( finalst[second], orend );
	    }
	}

    finalst[first] = orend;
    return ( first );
    }










int mkposcl( state )
int state;

    {
    int eps;

    if ( (transchar[finalst[state]] == (256 + 1) && trans1[finalst[state]] == 0) )
	{
	mkxtion( finalst[state], state );
	return ( state );
	}

    else
	{
	eps = mkstate( (256 + 1) );
	mkxtion( eps, state );
	return ( link_machines( state, eps ) );
	}
    }














int mkrep( mach, lb, ub )
int mach, lb, ub;

    {
    int base_mach, tail, copy, i;

    base_mach = copysingl( mach, lb - 1 );

    if ( ub == -1 )
	{
	copy = dupmachine( mach );
	mach = link_machines( mach,
			      link_machines( base_mach, mkclos( copy ) ) );
	}

    else
	{
	tail = mkstate( (256 + 1) );

	for ( i = lb; i < ub; ++i )
	    {
	    copy = dupmachine( mach );
	    tail = mkopt( link_machines( copy, tail ) );
	    }

	mach = link_machines( mach, link_machines( base_mach, tail ) );
	}

    return ( mach );
    }


















int mkstate( sym )
int sym;

    {
    if ( ++lastnfa >= current_mns )
	{
	if ( (current_mns += 1000) >= 31999 )
	    lerrif( "input rules are too complicated (>= %d NFA states)",
		    current_mns );

	++num_reallocs;

	firstst = (int *) reallocate_array( (void *) firstst, current_mns, sizeof( int ) );
	lastst = (int *) reallocate_array( (void *) lastst, current_mns, sizeof( int ) );
	finalst = (int *) reallocate_array( (void *) finalst, current_mns, sizeof( int ) );
	transchar = (int *) reallocate_array( (void *) transchar, current_mns, sizeof( int ) );
	trans1 = (int *) reallocate_array( (void *) trans1, current_mns, sizeof( int ) );
	trans2 = (int *) reallocate_array( (void *) trans2, current_mns, sizeof( int ) );
	accptnum = (int *) reallocate_array( (void *) accptnum, current_mns, sizeof( int ) );
	assoc_rule = (int *) reallocate_array( (void *) assoc_rule, current_mns, sizeof( int ) );
	state_type = (int *) reallocate_array( (void *) state_type, current_mns, sizeof( int ) );
	}

    firstst[lastnfa] = lastnfa;
    finalst[lastnfa] = lastnfa;
    lastst[lastnfa] = lastnfa;
    transchar[lastnfa] = sym;
    trans1[lastnfa] = 0;
    trans2[lastnfa] = 0;
    accptnum[lastnfa] = 0;
    assoc_rule[lastnfa] = num_rules;
    state_type[lastnfa] = current_state_type;









    if ( sym < 0 )
	{



	}

    else if ( sym == (256 + 1) )
	++numeps;

    else
	{
	if ( useecs )

	    mkechar( sym ? sym : csize, nextecm, ecgroup );
	}

    return ( lastnfa );
    }












void mkxtion( statefrom, stateto )
int statefrom, stateto;

    {
    if ( trans1[statefrom] == 0 )
	trans1[statefrom] = stateto;

    else if ( (transchar[statefrom] != (256 + 1)) ||
	      (trans2[statefrom] != 0) )
	flexfatal( "found too many transitions in mkxtion()" );

    else
	{
	++eps2;
	trans2[statefrom] = stateto;
	}
    }











void new_rule()

    {
    if ( ++num_rules >= current_max_rules )
	{
	++num_reallocs;
	current_max_rules += 100;
	rule_type = (int *) reallocate_array( (void *) rule_type, current_max_rules, sizeof( int ) );
	rule_linenum =
	    (int *) reallocate_array( (void *) rule_linenum, current_max_rules, sizeof( int ) );
	}

    if ( num_rules > (0x2000 - 1) )
	lerrif( "too many rules (> %d)!", (0x2000 - 1) );

    rule_linenum[num_rules] = linenum;
    }
