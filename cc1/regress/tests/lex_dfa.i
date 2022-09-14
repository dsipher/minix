# 1 "dfa.c"

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
# 36 "dfa.c"
void dump_associated_rules (FILE*, int);
void dump_transitions (FILE*, int[]);
void sympartition (int[], int, int[], int[]);
int symfollowset (int[], int, int, int[]);













void check_for_backtracking( ds, state )
int ds;
int state[];

    {
    if ( (reject && ! dfaacc[ds].dfaacc_set) || ! dfaacc[ds].dfaacc_state )
	{
	++num_backtracking;

	if ( backtrack_report )
	    {
	    fprintf( backtrack_file, "State #%d is non-accepting -\n", ds );


	    dump_associated_rules( backtrack_file, ds );


	    dump_transitions( backtrack_file, state );

	    (--(backtrack_file)->_count >= 0 ? (int) (*(backtrack_file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(backtrack_file)));
	    }
	}
    }
# 100 "dfa.c"
void check_trailing_context( nfa_states, num_states, accset, nacc )
int *nfa_states, num_states;
int *accset;
register int nacc;

    {
    register int i, j;

    for ( i = 1; i <= num_states; ++i )
	{
	int ns = nfa_states[i];
	register int type = state_type[ns];
	register int ar = assoc_rule[ns];

	if ( type == 0x1 || rule_type[ar] != 1 )
	    {
	    }

	else if ( type == 0x2 )
	    {





	    for ( j = 1; j <= nacc; ++j )
		if ( accset[j] & 0x4000 )
		    {
		    fprintf( (&__stderr),
		     "%s: Dangerous trailing context in rule at line %d\n",
			     program_name, rule_linenum[ar] );
		    return;
		    }
	    }
	}
    }














void dump_associated_rules( file, ds )
FILE *file;
int ds;

    {
    register int i, j;
    register int num_associated_rules = 0;
    int rule_set[100 + 1];
    int *dset = dss[ds];
    int size = dfasiz[ds];

    for ( i = 1; i <= size; ++i )
	{
	register rule_num = rule_linenum[assoc_rule[dset[i]]];

	for ( j = 1; j <= num_associated_rules; ++j )
	    if ( rule_num == rule_set[j] )
		break;

	if ( j > num_associated_rules )
	    {
	    if ( num_associated_rules < 100 )
		rule_set[++num_associated_rules] = rule_num;
	    }
	}

    bubble( rule_set, num_associated_rules );

    fprintf( file, " associated rule line numbers:" );

    for ( i = 1; i <= num_associated_rules; ++i )
	{
	if ( i % 8 == 1 )
	    (--(file)->_count >= 0 ? (int) (*(file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(file)));

	fprintf( file, "\t%d", rule_set[i] );
	}

    (--(file)->_count >= 0 ? (int) (*(file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(file)));
    }















void dump_transitions( file, state )
FILE *file;
int state[];

    {
    register int i, ec;
    int out_char_set[256];

    for ( i = 0; i < csize; ++i )
	{
	ec = abs( ecgroup[i] );
	out_char_set[i] = state[ec];
	}

    fprintf( file, " out-transitions: " );

    list_character_set( file, out_char_set );


    for ( i = 0; i < csize; ++i )
	out_char_set[i] = ! out_char_set[i];

    fprintf( file, "\n jam-transitions: EOF " );

    list_character_set( file, out_char_set );

    (--(file)->_count >= 0 ? (int) (*(file)->_ptr++ = ('\n')) : __flushbuf(('\n'),(file)));
    }
# 256 "dfa.c"
int *epsclosure( t, ns_addr, accset, nacc_addr, hv_addr )
int *t, *ns_addr, accset[], *nacc_addr, *hv_addr;

    {
    register int stkpos, ns, tsp;
    int numstates = *ns_addr, nacc, hashval, transsym, nfaccnum;
    int stkend, nstate;
    static int did_stk_init = 0, *stk;
# 312 "dfa.c"
    if ( ! did_stk_init )
	{
	stk = (int *) allocate_array( current_max_dfa_size, sizeof( int ) );
	did_stk_init = 1;
	}

    nacc = stkend = hashval = 0;

    for ( nstate = 1; nstate <= numstates; ++nstate )
	{
	ns = t[nstate];




	if ( ! (trans1[ns] < 0) )
	    { if ( ++stkend >= current_max_dfa_size ) { current_max_dfa_size += 750; ++num_reallocs; t = (int *) reallocate_array( (void *) t, current_max_dfa_size, sizeof( int ) ); stk = (int *) reallocate_array( (void *) stk, current_max_dfa_size, sizeof( int ) ); } stk[stkend] = ns; trans1[ns] = trans1[ns] - 32000; }

	{ nfaccnum = accptnum[ns]; if ( nfaccnum != 0 ) accset[++nacc] = nfaccnum; }
	hashval = hashval + ns;
	}

    for ( stkpos = 1; stkpos <= stkend; ++stkpos )
	{
	ns = stk[stkpos];
	transsym = transchar[ns];

	if ( transsym == (256 + 1) )
	    {
	    tsp = trans1[ns] + 32000;

	    if ( tsp != 0 )
		{
		if ( ! (trans1[tsp] < 0) )
		    { { if ( ++stkend >= current_max_dfa_size ) { current_max_dfa_size += 750; ++num_reallocs; t = (int *) reallocate_array( (void *) t, current_max_dfa_size, sizeof( int ) ); stk = (int *) reallocate_array( (void *) stk, current_max_dfa_size, sizeof( int ) ); } stk[stkend] = tsp; trans1[tsp] = trans1[tsp] - 32000; } { nfaccnum = accptnum[tsp]; if ( nfaccnum != 0 ) accset[++nacc] = nfaccnum; } if ( nfaccnum != 0 || transchar[tsp] != (256 + 1) ) { if ( ++numstates >= current_max_dfa_size ) { current_max_dfa_size += 750; ++num_reallocs; t = (int *) reallocate_array( (void *) t, current_max_dfa_size, sizeof( int ) ); stk = (int *) reallocate_array( (void *) stk, current_max_dfa_size, sizeof( int ) ); } t[numstates] = tsp; hashval = hashval + tsp; } }

		tsp = trans2[ns];

		if ( tsp != 0 )
		    if ( ! (trans1[tsp] < 0) )
			{ { if ( ++stkend >= current_max_dfa_size ) { current_max_dfa_size += 750; ++num_reallocs; t = (int *) reallocate_array( (void *) t, current_max_dfa_size, sizeof( int ) ); stk = (int *) reallocate_array( (void *) stk, current_max_dfa_size, sizeof( int ) ); } stk[stkend] = tsp; trans1[tsp] = trans1[tsp] - 32000; } { nfaccnum = accptnum[tsp]; if ( nfaccnum != 0 ) accset[++nacc] = nfaccnum; } if ( nfaccnum != 0 || transchar[tsp] != (256 + 1) ) { if ( ++numstates >= current_max_dfa_size ) { current_max_dfa_size += 750; ++num_reallocs; t = (int *) reallocate_array( (void *) t, current_max_dfa_size, sizeof( int ) ); stk = (int *) reallocate_array( (void *) stk, current_max_dfa_size, sizeof( int ) ); } t[numstates] = tsp; hashval = hashval + tsp; } }
		}
	    }
	}



    for ( stkpos = 1; stkpos <= stkend; ++stkpos )
	{
	if ( (trans1[stk[stkpos]] < 0) )
	    {
	    trans1[stk[stkpos]] = trans1[stk[stkpos]] + 32000;
	    }
	else
	    flexfatal( "consistency check failed in epsclosure()" );
	}

    *ns_addr = numstates;
    *hv_addr = hashval;
    *nacc_addr = nacc;

    return ( t );
    }




void increase_max_dfas()

    {
    current_max_dfas += 1000;

    ++num_reallocs;

    base = (int *) reallocate_array( (void *) base, current_max_dfas, sizeof( int ) );
    def = (int *) reallocate_array( (void *) def, current_max_dfas, sizeof( int ) );
    dfasiz = (int *) reallocate_array( (void *) dfasiz, current_max_dfas, sizeof( int ) );
    accsiz = (int *) reallocate_array( (void *) accsiz, current_max_dfas, sizeof( int ) );
    dhash = (int *) reallocate_array( (void *) dhash, current_max_dfas, sizeof( int ) );
    dss = (int **) reallocate_array( (void *) dss, current_max_dfas, sizeof( int * ) );
    dfaacc = (union dfaacc_union *) reallocate_array( (void *) dfaacc, current_max_dfas, sizeof( union dfaacc_union ) );

    if ( nultrans )
	nultrans = (int *) reallocate_array( (void *) nultrans, current_max_dfas, sizeof( int ) );
    }











void ntod()

    {
    int *accset, ds, nacc, newds;
    int sym, hashval, numstates, dsize;
    int num_full_table_rows;
    int *nset, *dset;
    int targptr, totaltrans, i, comstate, comfreq, targ;
    int *epsclosure(), snstods(), symlist[256 + 1];
    int num_start_states;
    int todo_head, todo_next;








    int duplist[256 + 1], state[256 + 1];
    int targfreq[256 + 1], targstate[256 + 1];




    if ( fullspd )
	firstfree = 0;

    accset = (int *) allocate_array( num_rules + 1, sizeof( int ) );
    nset = (int *) allocate_array( current_max_dfa_size, sizeof( int ) );







    todo_head = todo_next = 0;

    for ( i = 0; i <= csize; ++i )
	{
	duplist[i] = 0;
	symlist[i] = 0;
	}

    for ( i = 0; i <= num_rules; ++i )
	accset[i] = 0;

    if ( trace )
	{
	dumpnfa( scset[1] );
	fputs( "\n\nDFA Dump:\n\n", (&__stderr) );
	}

    inittbl();
# 493 "dfa.c"
    if ( ! fullspd && ecgroup[0] == numecs )
	{
	int use_NUL_table = (numecs == csize);

	if ( fulltbl && ! use_NUL_table )
	    {
	    int power_of_two;

	    for ( power_of_two = 1; power_of_two <= csize; power_of_two *= 2 )
		if ( numecs == power_of_two )
		    {
		    use_NUL_table = 1;
		    break;
		    }
	    }

	if ( use_NUL_table )
	    nultrans = (int *) allocate_array( current_max_dfas, sizeof( int ) );



	}


    if ( fullspd )
	{
	for ( i = 0; i <= numecs; ++i )
	    state[i] = 0;
	place_state( state, 0, 0 );
	}

    else if ( fulltbl )
	{
	if ( nultrans )



	    num_full_table_rows = numecs;

	else




	    num_full_table_rows = numecs + 1;




	printf( "static short int yy_nxt[][%d] =\n    {\n",

		num_full_table_rows );


	for ( i = 0; i < num_full_table_rows; ++i )
	    mk2data( 0 );


	datapos = 10;


	dataline = 10;
	}



    num_start_states = lastsc * 2;

    for ( i = 1; i <= num_start_states; ++i )
	{
	numstates = 1;





	if ( i % 2 == 1 )
	    nset[numstates] = scset[(i / 2) + 1];
	else
	    nset[numstates] = mkbranch( scbol[i / 2], scset[i / 2] );

	nset = epsclosure( nset, &numstates, accset, &nacc, &hashval );

	if ( snstods( nset, numstates, accset, nacc, hashval, &ds ) )
	    {
	    numas += nacc;
	    totnst += numstates;
	    ++todo_next;

	    if ( variable_trailing_context_rules && nacc > 0 )
		check_trailing_context( nset, numstates, accset, nacc );
	    }
	}

    if ( ! fullspd )
	{
	if ( ! snstods( nset, 0, accset, 0, 0, &end_of_buffer_state ) )
	    flexfatal( "could not create unique end-of-buffer state" );

	++numas;
	++num_start_states;
	++todo_next;
	}

    while ( todo_head < todo_next )
	{
	targptr = 0;
	totaltrans = 0;

	for ( i = 1; i <= numecs; ++i )
	    state[i] = 0;

	ds = ++todo_head;

	dset = dss[ds];
	dsize = dfasiz[ds];

	if ( trace )
	    fprintf( (&__stderr), "state # %d:\n", ds );

	sympartition( dset, dsize, symlist, duplist );

	for ( sym = 1; sym <= numecs; ++sym )
	    {
	    if ( symlist[sym] )
		{
		symlist[sym] = 0;

		if ( duplist[sym] == 0 )
		    {
		    numstates = symfollowset( dset, dsize, sym, nset );
		    nset = epsclosure( nset, &numstates, accset,
				       &nacc, &hashval );

		    if ( snstods( nset, numstates, accset,
				  nacc, hashval, &newds ) )
			{
			totnst = totnst + numstates;
			++todo_next;
			numas += nacc;

			if ( variable_trailing_context_rules && nacc > 0 )
			    check_trailing_context( nset, numstates,
				accset, nacc );
			}

		    state[sym] = newds;

		    if ( trace )
			fprintf( (&__stderr), "\t%d\t%d\n", sym, newds );

		    targfreq[++targptr] = 1;
		    targstate[targptr] = newds;
		    ++numuniq;
		    }

		else
		    {



		    targ = state[duplist[sym]];
		    state[sym] = targ;

		    if ( trace )
			fprintf( (&__stderr), "\t%d\t%d\n", sym, targ );



		    i = 0;
		    while ( targstate[++i] != targ )
			;

		    ++targfreq[i];
		    ++numdup;
		    }

		++totaltrans;
		duplist[sym] = 0;
		}
	    }

	numsnpairs = numsnpairs + totaltrans;

	if ( caseins && ! useecs )
	    {
	    register int j;

	    for ( i = 'A', j = 'a'; i <= 'Z'; ++i, ++j )
		state[i] = state[j];
	    }

	if ( ds > num_start_states )
	    check_for_backtracking( ds, state );

	if ( nultrans )
	    {
	    nultrans[ds] = state[NUL_ec];
	    state[NUL_ec] = 0;
	    }

	if ( fulltbl )
	    {

	    if ( ds == end_of_buffer_state )
		mk2data( -end_of_buffer_state );
	    else
		mk2data( end_of_buffer_state );

	    for ( i = 1; i < num_full_table_rows; ++i )

		mk2data( state[i] ? state[i] : -ds );


	    datapos = 10;


	    dataline = 10;
	    }

        else if ( fullspd )
	    place_state( state, ds, totaltrans );

	else if ( ds == end_of_buffer_state )



	    stack1( ds, 0, 0, -32766 );

	else
	    {




	    comfreq = 0;
	    comstate = 0;

	    for ( i = 1; i <= targptr; ++i )
		if ( targfreq[i] > comfreq )
		    {
		    comfreq = targfreq[i];
		    comstate = targstate[i];
		    }

	    bldtbl( state, ds, totaltrans, comstate, comfreq );
	    }
	}

    if ( fulltbl )
	dataend();

    else if ( ! fullspd )
	{
	cmptmps();


	while ( onesp > 0 )
	    {
	    mk1tbl( onestate[onesp], onesym[onesp], onenext[onesp],
		    onedef[onesp] );
	    --onesp;
	    }

	mkdeftbl();
	}
    }












int snstods( sns, numstates, accset, nacc, hashval, newds_addr )
int sns[], numstates, accset[], nacc, hashval, *newds_addr;

    {
    int didsort = 0;
    register int i, j;
    int newds, *oldsns;

    for ( i = 1; i <= lastdfa; ++i )
	if ( hashval == dhash[i] )
	    {
	    if ( numstates == dfasiz[i] )
		{
		oldsns = dss[i];

		if ( ! didsort )
		    {




		    bubble( sns, numstates );
		    didsort = 1;
		    }

		for ( j = 1; j <= numstates; ++j )
		    if ( sns[j] != oldsns[j] )
			break;

		if ( j > numstates )
		    {
		    ++dfaeql;
		    *newds_addr = i;
		    return ( 0 );
		    }

		++hshcol;
		}

	    else
		++hshsave;
	    }



    if ( ++lastdfa >= current_max_dfas )
	increase_max_dfas();

    newds = lastdfa;

    dss[newds] = (int *) malloc( (unsigned) ((numstates + 1) * sizeof( int )) );

    if ( ! dss[newds] )
	flexfatal( "dynamic memory failure in snstods()" );





    if ( ! didsort )
	bubble( sns, numstates );

    for ( i = 1; i <= numstates; ++i )
	dss[newds][i] = sns[i];

    dfasiz[newds] = numstates;
    dhash[newds] = hashval;

    if ( nacc == 0 )
	{
	if ( reject )
	    dfaacc[newds].dfaacc_set = (int *) 0;
	else
	    dfaacc[newds].dfaacc_state = 0;

	accsiz[newds] = 0;
	}

    else if ( reject )
	{






	bubble( accset, nacc );

	dfaacc[newds].dfaacc_set =
	    (int *) malloc( (unsigned) ((nacc + 1) * sizeof( int )) );

	if ( ! dfaacc[newds].dfaacc_set )
	    flexfatal( "dynamic memory failure in snstods()" );


	for ( i = 1; i <= nacc; ++i )
	    dfaacc[newds].dfaacc_set[i] = accset[i];

	accsiz[newds] = nacc;
	}

    else
	{
	j = num_rules + 1;

	for ( i = 1; i <= nacc; ++i )
	    if ( accset[i] < j )
		j = accset[i];

	dfaacc[newds].dfaacc_state = j;
	}

    *newds_addr = newds;

    return ( 1 );
    }










int symfollowset( ds, dsize, transsym, nset )
int ds[], dsize, transsym, nset[];

    {
    int ns, tsp, sym, i, j, lenccl, ch, numstates;
    int ccllist;

    numstates = 0;

    for ( i = 1; i <= dsize; ++i )
	{
	ns = ds[i];
	sym = transchar[ns];
	tsp = trans1[ns];

	if ( sym < 0 )
	    {
	    sym = -sym;
	    ccllist = cclmap[sym];
	    lenccl = ccllen[sym];

	    if ( cclng[sym] )
		{
		for ( j = 0; j < lenccl; ++j )
		    {
		    ch = ccltbl[ccllist + j];

		    if ( ch == 0 )
			ch = NUL_ec;

		    if ( ch > transsym )
			break;

		    else if ( ch == transsym )
			             goto bottom;
		    }


		nset[++numstates] = tsp;
		}

	    else
		for ( j = 0; j < lenccl; ++j )
		    {
		    ch = ccltbl[ccllist + j];

		    if ( ch == 0 )
			ch = NUL_ec;

		    if ( ch > transsym )
			break;

		    else if ( ch == transsym )
			{
			nset[++numstates] = tsp;
			break;
			}
		    }
	    }

	else if ( sym >= 'A' && sym <= 'Z' && caseins )
	    flexfatal( "consistency check failed in symfollowset" );

	else if ( sym == (256 + 1) )
	    {
	    }

	else if ( abs( ecgroup[sym] ) == transsym )
	    nset[++numstates] = tsp;

bottom:
	;
	}

    return ( numstates );
    }










void sympartition( ds, numstates, symlist, duplist )
int ds[], numstates, duplist[];
int symlist[];

    {
    int tch, i, j, k, ns, dupfwd[256 + 1], lenccl, cclp, ich;






    for ( i = 1; i <= numecs; ++i )
	{
	duplist[i] = i - 1;
	dupfwd[i] = i + 1;
	}

    duplist[1] = 0;
    dupfwd[numecs] = 0;

    for ( i = 1; i <= numstates; ++i )
	{
	ns = ds[i];
	tch = transchar[ns];

	if ( tch != (256 + 1) )
	    {
	    if ( tch < -lastccl || tch > csize )
		{
		if ( tch > csize && tch <= 256 )
		    flexerror( "scanner requires -8 flag" );

		else
		    flexfatal(
			"bad transition character detected in sympartition()" );
		}

	    if ( tch >= 0 )
		{

		int ec = abs( ecgroup[tch] );

		mkechar( ec, dupfwd, duplist );
		symlist[ec] = 1;
		}

	    else
		{
		tch = -tch;

		lenccl = ccllen[tch];
		cclp = cclmap[tch];
		mkeccl( ccltbl + cclp, lenccl, dupfwd, duplist, numecs,
			NUL_ec );

		if ( cclng[tch] )
		    {
		    j = 0;

		    for ( k = 0; k < lenccl; ++k )
			{
			ich = ccltbl[cclp + k];

			if ( ich == 0 )
			    ich = NUL_ec;

			for ( ++j; j < ich; ++j )
			    symlist[j] = 1;
			}

		    for ( ++j; j <= numecs; ++j )
			symlist[j] = 1;
		    }

		else
		    for ( k = 0; k < lenccl; ++k )
			{
			ich = ccltbl[cclp + k];

			if ( ich == 0 )
			    ich = NUL_ec;

			symlist[ich] = 1;
			}
		}
	    }
	}
    }
