# cross.sh - make cross-building environment
#
# the end result is a set of tools in $ROOT/tahoe/bin which
# can then be used by build.sh to cross-build a tahoe image.

ROOT=~/xcc
LINUX=$ROOT/linux
TAHOE=$ROOT/tahoe

set -e
rm -rf $ROOT
mkdir $ROOT

# 1. build a version of the toolchain which uses
# gnu binutils and generates binaries for linux.

make clean

mkdir $LINUX
mkdir $LINUX/bin
mkdir $LINUX/lib
mkdir $LINUX/include

cp -rv include/* $LINUX/include

cc -DAS=\"/usr/bin/as\" -DLD=\"/usr/bin/ld\" -DROOT=\"$LINUX\" \
	-o $LINUX/bin/cc cc.c

(cd cpp; make clean; make; mv cpp $LINUX/lib)
(cd cc1; make clean; make; mv cc1 $LINUX/lib)

(cd libc; make clean; make CC=$LINUX/bin/cc AR=/usr/bin/ar; \
	mv crt0.o libc.a $LINUX/lib)

# 2. using the host toolchain built in the previous step,
# build the toolchain which generates binaries for tahoe.

make clean

mkdir $TAHOE
mkdir $TAHOE/bin
mkdir $TAHOE/lib
mkdir $TAHOE/include

cp -rv include/* $TAHOE/include

$LINUX/bin/cc -o $TAHOE/bin/cc -DROOT=\"$TAHOE\" cc.c

(cd yacc; make clean; make CC=$LINUX/bin/cc; mv yacc $TAHOE/bin)

(cd lex; make clean; make CC=$LINUX/bin/cc \
			YACC=$TAHOE/bin/yacc \
			ROOT=$TAHOE; \
	mv lex $TAHOE/bin; cp flex.skel $TAHOE/lib)

(cd as; make clean; make CC=$LINUX/bin/cc \
			 YACC=$TAHOE/bin/yacc \
			 LEX=$TAHOE/bin/lex; mv as $TAHOE/bin)

(cd cpp; make clean; make CC=$LINUX/bin/cc; mv cpp $TAHOE/lib)
(cd cc1; make clean; make CC=$LINUX/bin/cc; mv cc1 $TAHOE/lib)

make CC=$LINUX/bin/cc ar; mv ar $TAHOE/bin
make CC=$LINUX/bin/cc ld; mv ld $TAHOE/bin
make CC=$LINUX/bin/cc nm; mv nm $TAHOE/bin

(cd libc; make clean; make CC=$TAHOE/bin/cc AR=$TAHOE/bin/ar; \
	mv crt0.o libc.a $TAHOE/lib)
