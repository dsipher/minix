# cross.sh - make cross-building environment
#
# the end result is a set of tools in $ROOT/jewel/bin which
# can then be used by build.sh to cross-build a jewel image.

ROOT=~/xcc
LINUX=$ROOT/linux
JEWEL=$ROOT/jewel

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
# build the toolchain which generates binaries for jewel.

make clean

mkdir $JEWEL
mkdir $JEWEL/bin
mkdir $JEWEL/lib
mkdir $JEWEL/include

cp -rv include/* $JEWEL/include

$LINUX/bin/cc -o $JEWEL/bin/cc -DROOT=\"$JEWEL\" cc.c

(cd yacc; make clean; make CC=$LINUX/bin/cc; mv yacc $JEWEL/bin)

(cd lex; make clean; make CC=$LINUX/bin/cc \
			YACC=$JEWEL/bin/yacc \
			ROOT=$JEWEL; \
	mv lex $JEWEL/bin; cp flex.skel $JEWEL/lib)

(cd as; make clean; make CC=$LINUX/bin/cc \
			 YACC=$JEWEL/bin/yacc \
			 LEX=$JEWEL/bin/lex; mv as $JEWEL/bin)

(cd cpp; make clean; make CC=$LINUX/bin/cc; mv cpp $JEWEL/lib)
(cd cc1; make clean; make CC=$LINUX/bin/cc; mv cc1 $JEWEL/lib)

make CC=$LINUX/bin/cc ar; mv ar $JEWEL/bin
make CC=$LINUX/bin/cc ld; mv ld $JEWEL/bin
make CC=$LINUX/bin/cc nm; mv nm $JEWEL/bin

(cd libc; make clean; make CC=$JEWEL/bin/cc AR=$JEWEL/bin/ar; \
	mv crt0.o libc.a $JEWEL/lib)
