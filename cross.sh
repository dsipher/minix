# cross.sh - make cross-building environment
#
# the end result is a set of tools in $ROOT/ux64/bin which
# can then be used by build.sh to cross-build a ux/64 image.

ROOT=~/xcc
LINUX=$ROOT/linux
UX64=$ROOT/ux64

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
# build the toolchain which generates binaries for ux/64.

make clean

mkdir $UX64
mkdir $UX64/bin
mkdir $UX64/lib
mkdir $UX64/include

cp -rv include/* $UX64/include

$LINUX/bin/cc -o $UX64/bin/cc -DROOT=\"$UX64\" cc.c

(cd yacc; make clean; make CC=$LINUX/bin/cc; mv yacc $UX64/bin)

(cd lex; make clean; make CC=$LINUX/bin/cc \
			YACC=$UX64/bin/yacc \
			ROOT=$UX64; \
	mv lex $UX64/bin; cp lex.skel $UX64/lib)

(cd as; make clean; make CC=$LINUX/bin/cc \
			 YACC=$UX64/bin/yacc \
			 LEX=$UX64/bin/lex; mv as $UX64/bin)

(cd cpp; make clean; make CC=$LINUX/bin/cc; mv cpp $UX64/lib)
(cd cc1; make clean; make CC=$LINUX/bin/cc; mv cc1 $UX64/lib)

make CC=$LINUX/bin/cc ar; mv ar $UX64/bin
make CC=$LINUX/bin/cc ld; mv ld $UX64/bin
make CC=$LINUX/bin/cc nm; mv nm $UX64/bin

(cd libc; make clean; make CC=$UX64/bin/cc AR=$UX64/bin/ar; \
	mv crt0.o libc.a $UX64/lib)

make CC=$LINUX/bin/cc mkboot; mv mkboot $UX64/bin
make CC=$LINUX/bin/cc mkfs;   mv mkfs   $UX64/bin
