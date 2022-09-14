# 1 "tblcmp.c"

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
# 36 "tblcmp.c"
void mkentry (register int*, int, int, int, int);
void mkprot (int[], int, int);
void mktemplate (int[], int, int);
void mv2front (int);
int tbldiff (int[], int, int[]);
# 78 "tblcmp.c"
void bldtbl( state, statenum, totaltrans, comstate, comfreq )
int state[], statenum, totaltrans, comstate, comfreq;

    {
    int extptr, extrct[2][256 + 1];
    int mindiff, minprot, i, d;
    int checkcom;











    extptr = 0;





    if ( (totaltrans * 100) < (numecs * 15) )
	mkentry( state, numecs, statenum, -32766, totaltrans );

    else
	{




	checkcom = comfreq * 100 > totaltrans * 50;

	minprot = firstprot;
	mindiff = totaltrans;

	if ( checkcom )
	    {

	    for ( i = firstprot; i != 0; i = protnext[i] )
		if ( protcomst[i] == comstate )
		    {
		    minprot = i;
		    mindiff = tbldiff( state, minprot, extrct[extptr] );
		    break;
		    }
	    }

	else
	    {






	    comstate = 0;

	    if ( firstprot != 0 )
		{
		minprot = firstprot;
		mindiff = tbldiff( state, minprot, extrct[extptr] );
		}
	    }







	if ( mindiff * 100 > totaltrans * 10 )
	    {
	    for ( i = minprot; i != 0; i = protnext[i] )
		{
		d = tbldiff( state, i, extrct[1 - extptr] );
		if ( d < mindiff )
		    {
		    extptr = 1 - extptr;
		    mindiff = d;
		    minprot = i;
		    }
		}
	    }





	if ( mindiff * 100 > totaltrans * 50 )
	    {




	    if ( comfreq * 100 >= totaltrans * 60 )
		mktemplate( state, statenum, comstate );

	    else
		{
		mkprot( state, statenum, comstate );
		mkentry( state, numecs, statenum, -32766, totaltrans );
		}
	    }

	else
	    {
	    mkentry( extrct[extptr], numecs, statenum,
		     prottbl[minprot], mindiff );





	    if ( mindiff * 100 >= totaltrans * 20 )
		mkprot( state, statenum, comstate );









	    mv2front( minprot );
	    }
	}
    }















void cmptmps()

    {
    int tmpstorage[256 + 1];
    register int *tmp = tmpstorage, i, j;
    int totaltrans, trans;

    peakpairs = numtemps * numecs + tblend;

    if ( usemecs )
	{




	nummecs = cre8ecs( tecfwd, tecbck, numecs );
	}

    else
	nummecs = numecs;

    if ( lastdfa + numtemps + 1 >= current_max_dfas )
	increase_max_dfas();



    for ( i = 1; i <= numtemps; ++i )
	{
	totaltrans = 0;

	for ( j = 1; j <= numecs; ++j )
	    {
	    trans = tnxt[numecs * i + j];

	    if ( usemecs )
		{



		if ( tecbck[j] > 0 )
		    {
		    tmp[tecbck[j]] = trans;

		    if ( trans > 0 )
			++totaltrans;
		    }
		}

	    else
		{
		tmp[j] = trans;

		if ( trans > 0 )
		    ++totaltrans;
		}
	    }








	mkentry( tmp, nummecs, lastdfa + i + 1, -32766, totaltrans );
	}
    }





void expand_nxt_chk()

    {
    register int old_max = current_max_xpairs;

    current_max_xpairs += 2000;

    ++num_reallocs;

    nxt = (int *) reallocate_array( (void *) nxt, current_max_xpairs, sizeof( int ) );
    chk = (int *) reallocate_array( (void *) chk, current_max_xpairs, sizeof( int ) );

    
(void) memset((char *)((char *) (chk + old_max)), '\0', 2000 * sizeof( int ) / sizeof( char ));
    }
# 332 "tblcmp.c"
int find_table_space( state, numtrans )
int *state, numtrans;

    {



    register int i;
    register int *state_ptr, *chk_ptr;
    register int *ptr_to_last_entry_in_state;




    if ( numtrans > 4 )
	{



	if ( tblend < 2 )
	    return ( 1 );

	i = tblend - numecs;


	}

    else
	i = firstfree;





    while ( 1 )
	{
	if ( i + numecs > current_max_xpairs )
	    expand_nxt_chk();


	while ( 1 )
	    {
	    if ( chk[i - 1] == 0 )
		{
		if ( chk[i] == 0 )
		    break;

		else
		    i += 2;



		}

	    else
		++i;

	    if ( i + numecs > current_max_xpairs )
		expand_nxt_chk();
	    }




	if ( numtrans <= 4 )
	    firstfree = i + 1;





	state_ptr = &state[1];
	ptr_to_last_entry_in_state = &chk[i + numecs + 1];

	for ( chk_ptr = &chk[i + 1]; chk_ptr != ptr_to_last_entry_in_state;
	      ++chk_ptr )
	    if ( *(state_ptr++) != 0 && *chk_ptr != 0 )
		break;

	if ( chk_ptr == ptr_to_last_entry_in_state )
	    return ( i );

	else
	    ++i;
	}
    }












void inittbl()

    {
    register int i;

    (void) memset((char *)((char *) chk), '\0', current_max_xpairs * sizeof( int ) / sizeof( char ));

    tblend = 0;
    firstfree = tblend + 1;
    numtemps = 0;

    if ( usemecs )
	{





	tecbck[1] = 0;

	for ( i = 2; i <= numecs; ++i )
	    {
	    tecbck[i] = i - 1;
	    tecfwd[i - 1] = i;
	    }

	tecfwd[numecs] = 0;
	}
    }








void mkdeftbl()

    {
    int i;

    jamstate = lastdfa + 1;

    ++tblend;

    if ( tblend + numecs > current_max_xpairs )
	expand_nxt_chk();


    nxt[tblend] = end_of_buffer_state;
    chk[tblend] = jamstate;

    for ( i = 1; i <= numecs; ++i )
	{
	nxt[tblend + i] = 0;
	chk[tblend + i] = jamstate;
	}

    jambase = tblend;

    base[jamstate] = jambase;
    def[jamstate] = 0;

    tblend += numecs;
    ++numtemps;
    }
# 518 "tblcmp.c"
void mkentry( state, numchars, statenum, deflink, totaltrans )
register int *state;
int numchars, statenum, deflink, totaltrans;

    {
    register int minec, maxec, i, baseaddr;
    int tblbase, tbllast;

    if ( totaltrans == 0 )
	{
	if ( deflink == -32766 )
	    base[statenum] = -32766;
	else
	    base[statenum] = 0;

	def[statenum] = deflink;
	return;
	}

    for ( minec = 1; minec <= numchars; ++minec )
	{
	if ( state[minec] != -1 )
	    if ( state[minec] != 0 || deflink != -32766 )
		break;
	}

    if ( totaltrans == 1 )
	{



	stack1( statenum, minec, state[minec], deflink );
	return;
	}

    for ( maxec = numchars; maxec > 0; --maxec )
	{
	if ( state[maxec] != -1 )
	    if ( state[maxec] != 0 || deflink != -32766 )
		break;
	}












    if ( totaltrans * 100 <= numchars * 15 )
	{
	baseaddr = firstfree;

	while ( baseaddr < minec )
	    {



	    for ( ++baseaddr; chk[baseaddr] != 0; ++baseaddr )
		;
	    }

	if ( baseaddr + maxec - minec >= current_max_xpairs )
	    expand_nxt_chk();

	for ( i = minec; i <= maxec; ++i )
	    if ( state[i] != -1 )
		if ( state[i] != 0 || deflink != -32766 )
		    if ( chk[baseaddr + i - minec] != 0 )
			{
			for ( ++baseaddr;
			      baseaddr < current_max_xpairs &&
			      chk[baseaddr] != 0;
			      ++baseaddr )
			    ;

			if ( baseaddr + maxec - minec >= current_max_xpairs )
			    expand_nxt_chk();





			i = minec - 1;
			}
	}

    else
	{



	baseaddr = ((tblend + 1) > (minec) ? (tblend + 1) : (minec));
	}

    tblbase = baseaddr - minec;
    tbllast = tblbase + maxec;

    if ( tbllast >= current_max_xpairs )
	expand_nxt_chk();

    base[statenum] = tblbase;
    def[statenum] = deflink;

    for ( i = minec; i <= maxec; ++i )
	if ( state[i] != -1 )
	    if ( state[i] != 0 || deflink != -32766 )
		{
		nxt[tblbase + i] = state[i];
		chk[tblbase + i] = statenum;
		}

    if ( baseaddr == firstfree )

	for ( ++firstfree; chk[firstfree] != 0; ++firstfree )
	    ;

    tblend = ((tblend) > (tbllast) ? (tblend) : (tbllast));
    }










void mk1tbl( state, sym, onenxt, onedef )
int state, sym, onenxt, onedef;

    {
    if ( firstfree < sym )
	firstfree = sym;

    while ( chk[firstfree] != 0 )
	if ( ++firstfree >= current_max_xpairs )
	    expand_nxt_chk();

    base[state] = firstfree - sym;
    def[state] = onedef;
    chk[firstfree] = state;
    nxt[firstfree] = onenxt;

    if ( firstfree > tblend )
	{
	tblend = firstfree++;

	if ( firstfree >= current_max_xpairs )
	    expand_nxt_chk();
	}
    }









void mkprot( state, statenum, comstate )
int state[], statenum, comstate;

    {
    int i, slot, tblbase;

    if ( ++numprots >= 50 || numecs * numprots >= 2000 )
	{



	slot = lastprot;
	lastprot = protprev[lastprot];
	protnext[lastprot] = 0;
	}

    else
	slot = numprots;

    protnext[slot] = firstprot;

    if ( firstprot != 0 )
	protprev[firstprot] = slot;

    firstprot = slot;
    prottbl[slot] = statenum;
    protcomst[slot] = comstate;


    tblbase = numecs * (slot - 1);

    for ( i = 1; i <= numecs; ++i )
	protsave[tblbase + i] = state[i];
    }










void mktemplate( state, statenum, comstate )
int state[], statenum, comstate;

    {
    int i, numdiff, tmpbase, tmp[256 + 1];
    unsigned char transset[256 + 1];
    int tsptr;

    ++numtemps;

    tsptr = 0;






    tmpbase = numtemps * numecs;

    if ( tmpbase + numecs >= current_max_template_xpairs )
	{
	current_max_template_xpairs += 2500;

	++num_reallocs;

	tnxt = (int *) reallocate_array( (void *) tnxt, current_max_template_xpairs, sizeof( int ) );
	}

    for ( i = 1; i <= numecs; ++i )
	if ( state[i] == 0 )
	    tnxt[tmpbase + i] = 0;
	else
	    {
	    transset[tsptr++] = i;
	    tnxt[tmpbase + i] = comstate;
	    }

    if ( usemecs )
	mkeccl( transset, tsptr, tecfwd, tecbck, numecs, 0 );

    mkprot( tnxt + tmpbase, -numtemps, comstate );





    numdiff = tbldiff( state, firstprot, tmp );
    mkentry( tmp, numecs, statenum, -numtemps, numdiff );
    }









void mv2front( qelm )
int qelm;

    {
    if ( firstprot != qelm )
	{
	if ( qelm == lastprot )
	    lastprot = protprev[lastprot];

	protnext[protprev[qelm]] = protnext[qelm];

	if ( protnext[qelm] != 0 )
	    protprev[protnext[qelm]] = protprev[qelm];

	protprev[qelm] = 0;
	protnext[qelm] = firstprot;
	protprev[firstprot] = qelm;
	firstprot = qelm;
	}
    }













void place_state( state, statenum, transnum )
int *state, statenum, transnum;

    {
    register int i;
    register int *state_ptr;
    int position = find_table_space( state, transnum );


    base[statenum] = position;





    chk[position - 1] = 1;


    chk[position] = 1;


    state_ptr = &state[1];

    for ( i = 1; i <= numecs; ++i, ++state_ptr )
	if ( *state_ptr != 0 )
	    {
	    chk[position + i] = i;
	    nxt[position + i] = *state_ptr;
	    }

    if ( position + numecs > tblend )
	tblend = position + numecs;
    }













void stack1( statenum, sym, nextstate, deflink )
int statenum, sym, nextstate, deflink;

    {
    if ( onesp >= 500 - 1 )
	mk1tbl( statenum, sym, nextstate, deflink );

    else
	{
	++onesp;
	onestate[onesp] = statenum;
	onesym[onesp] = sym;
	onenext[onesp] = nextstate;
	onedef[onesp] = deflink;
	}
    }
# 901 "tblcmp.c"
int tbldiff( state, pr, ext )
int state[], pr, ext[];

    {
    register int i, *sp = state, *ep = ext, *protp;
    register int numdiff = 0;

    protp = &protsave[numecs * (pr - 1)];

    for ( i = numecs; i > 0; --i )
	{
	if ( *++protp == *++sp )
	    *++ep = -1;
	else
	    {
	    *++ep = *sp;
	    ++numdiff;
	    }
	}

    return ( numdiff );
    }
