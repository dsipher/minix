#!/bin/sh

# simple regression testing for the tahoe/64 c compiler.
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

TESTS="		cpp directive evaluate input macro token vstring	\
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
		dmr_lex dmr_macro dmr_nlist dmr_tokens dmr_unix		"

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
		mv cpp $ROOT/$3/bin/cpp					)

	(	cd ..; 							\
		make clean;						\
		make CC=$1 CFLAGS=$2;					\
		mv cc1 $ROOT/$3/bin/cc1					)

	cp -r ../../include/* $ROOT/$3/include
	ln -s /usr/bin/as $ROOT/$3/bin
	ln -s /usr/bin/ld $ROOT/$3/bin

	(	cd ../../libc;						\
		make clean;						\
		make CC=$ROOT/$3/bin/cc CFLAGS=;			\
		mv crt0.o libc.a $ROOT/$3/lib				)
	echo
	echo ................................................... running $3
	echo

	for i in $TESTS
	do
		echo $i
		$ROOT/$3/bin/cc1 $ROOT/tests/$i.i $ROOT/$3/out/$i.s
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
do_stage $ROOT/stage1/bin/cc "" stage2
do_stage $ROOT/stage2/bin/cc "" stage3

diff_stages stage1 stage2
diff_stages stage2 stage3
