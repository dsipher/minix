#!/bin/sh

# simple regression testing for the minix c compiler.
# we build the compiler, tools, and library three times.
#
# 1. the stage1 compiler is built with the system compiler, then
# 2. the stage2 compiler is built with the stage1 compiler, then
# 3. the stage3 compiler is built with the stage2 compiler.
#
# we use each stageX compiler to build the test sources in
# tests/ to stageX/out/. diffs are generated between the
# stage1/stage2 and stage2/stage3 outputs. any differences
# usually indicate some kind of problem in the compiler.
#
# the test files themselves are nothing especially important,
# they are simply a collection [mostly] non-trivial c sources,
# pre-preprocessed so they have no external depedencies. many
# of them come from the compiler itself, though this is merely
# a convenience; they are not synced with the sources proper.
#
# stage1/out and stage2/out are disposable. we keep stage3/out
# in the repository so we can track changes in compiler output
# across versions of the compiler, as it (hopefully) improves.
#
# the system compiler used to build stage1 should be known good,
# or even a third-party compiler for best results. in the latter
# case, beware valid and otherwise harmless differences in the
# interpretation of the compiler sources (e.g., the order of the
# evaluation of function arguments) may cause spurious differences
# between stage1 and stage2 out.
#
# this script must be invoked inside the regress/ directory.

set -e
ROOT=`pwd`

TESTS="		ar cpp directive evaluate input macro token vstring	\
		block builtin cc1 dealias decl dom dvn expr fold 	\
		func fuse gen graph heap hoist init insn lex live	\
		lower norm opt prop reach reassoc reg stmt string	\
		switch symbol tree type __ctype __dtefg __fillbuf	\
		__flushbuf __pow10 atoi atol brk bsearch clearerr	\
		ctime execvp execvpe exit fclose fflush fgetpos		\
		fgets fileno fopen fprintf fputc fputs fread frexp	\
		fscanf fseek fsetpos ftell fwrite getenv getopt		\
		gets isalnum isalpha isatty iscntrl isdigit isgraph	\
		islower isprint ispunct isspace isupper isxdigit	\
		malloc memchr memcmp memcpy memmove modf printf		\
		puts qsort rand remove rewind scanf setbuf setvbuf	\
		sigaction sigemptyset signal sprintf sscanf stdio	\
		strcat strchr strcmp strcpy strerror strftime		\
		strlen strncat strncmp strncpy strrchr strtod		\
		strtof strtol tcgetattr tolower toupper ungetc		\
		vfprintf vfscanf vsprintf wait freopen dmr_cpp		\
		dmr_eval dmr_getopt dmr_hideset dmr_include 		\
		dmr_lex dmr_macro dmr_nlist dmr_tokens dmr_unix		\
		lex_ccl lex_dfa lex_ecs lex_gen 			\
		lex_main lex_misc lex_nfa lex_scan 			\
		lex_sym lex_tblcmp lex_y.tab lex_yylex			\
		yacc_closure yacc_lr0 yacc_output yacc_symtab		\
		yacc_error yacc_main yacc_reader yacc_verbose		\
		yacc_lalr yacc_mkpar yacc_skeleton yacc_warshall	\
		compress tar_buffer tar_create tar_extract tar_list	\
		tar_getoldopt tar_list tar_names tar_tar tar_wildmat	\
		awk_b awk_lex awk_lib awk_main awk_maketab awk_parse	\
		awk_proctab awk_run awk_tran awk_y.tab			\
		sed_comp sed_exec ed_amatch ed_append ed_bitmap		\
		ed_catsub ed_ckglob ed_deflt ed_del ed_docmd 		\
		ed_dodash ed_doglob ed_doprnt ed_doread ed_dowrite	\
        	ed_ed ed_egets ed_esc ed_find ed_getfn ed_getlst	\
		ed_getnum ed_getone ed_getpat ed_getptr ed_getrhs 	\
		ed_gettxt ed_ins ed_join ed_makepat ed_maksub 		\
		ed_matchs ed_move ed_omatch ed_optpat ed_set		\
        	ed_setbuf ed_subst ed_sys ed_unmkpat ld ls		"

do_stage()	# ( $compiler, $cflags, $stage )
{
	echo
	echo ................................................... building $3
	echo

	rm -rf $ROOT/$3
	mkdir $ROOT/$3

	for dir in bin lib include out
	do
		rm -rf $ROOT/$3/$dir
		mkdir $ROOT/$3/$dir
	done

	$1 -DROOT=\"$ROOT/$3\" -o $ROOT/$3/bin/cc ../../cc.c

	(	cd ../../cpp; 						\
		make clean;						\
		make CC=$1 CFLAGS=$2;					\
		mv cpp $ROOT/$3/lib/cpp					)

	(	cd ..; 							\
		rm -f *.o cc1;						\
		make CC=$1 CFLAGS=$2;					\
		mv cc1 $ROOT/$3/lib/cc1					)

	cp -r ../../include/* $ROOT/$3/include
	ln -s /usr/bin/as $ROOT/$3/bin
	ln -s /usr/bin/ld $ROOT/$3/bin

	(	cd ../../libc;						\
		make clean;						\
		make CC=$ROOT/$3/bin/cc;				\
		mv crt0.o libc.a $ROOT/$3/lib				)
	echo
	echo ................................................... running $3
	echo

	for i in $TESTS
	do
		echo $i
		$ROOT/$3/lib/cc1 -O $ROOT/tests/$i.i $ROOT/$3/out/$i.s
	done
}

diff_stages()	# ( $stage1, $stage2)
{
	rm -f $ROOT/$1.$2.diff
	for i in $ROOT/$1/out/*.s
	do
		diff -U 5 $i $ROOT/$2/out/`basename $i` >> $1.$2.diff
	done
}

do_stage gcc "-O2" stage1
do_stage $ROOT/stage1/bin/cc "-O" stage2
do_stage $ROOT/stage2/bin/cc "-O" stage3

diff_stages stage1 stage2
diff_stages stage2 stage3
