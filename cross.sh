ROOT=~/xcc
HOST=$ROOT/host
TARGET=$ROOT/target

set -e
rm -rf $ROOT
mkdir $ROOT

# 1. build a version of the toolchain which uses
# gnu binutils and generates binaries for linux.

mkdir $HOST
mkdir $HOST/bin
mkdir $HOST/lib
mkdir $HOST/include

cp -rv include/* $HOST/include

cc -DAS=\"/usr/bin/as\" -DLD=\"/usr/bin/ld\" -DROOT=\"$HOST\" \
	-o $HOST/bin/cc cc.c

(cd cpp; make clean; make; mv cpp $HOST/lib)
(cd cc1; make clean; make; mv cc1 $HOST/lib)

(cd libc; make clean; make CC=$HOST/bin/cc AR=/usr/bin/ar; \
	mv crt0.o libc.a $HOST/lib)

# 2. using the host toolchain built in the previous step,
# build the toolchain which generates binaries for tahoe.

mkdir $TARGET
mkdir $TARGET/bin
mkdir $TARGET/lib
mkdir $TARGET/include

cp -rv include/* $TARGET/include

$HOST/bin/cc -o $TARGET/bin/cc -DROOT=\"$TARGET\" cc.c

(cd yacc; make clean; make CC=$HOST/bin/cc; mv yacc $TARGET/bin)

(cd lex; make clean; make CC=$HOST/bin/cc \
			YACC=$TARGET/bin/yacc \
			ROOT=$TARGET; \
	mv lex $TARGET/bin; cp flex.skel $TARGET/lib)

(cd as; make clean; make CC=$HOST/bin/cc \
			 YACC=$TARGET/bin/yacc \
			 LEX=$TARGET/bin/lex; mv as $TARGET/bin)

(cd cpp; make clean; make CC=$HOST/bin/cc; mv cpp $TARGET/lib)
(cd cc1; make clean; make CC=$HOST/bin/cc; mv cc1 $TARGET/lib)

make CC=$HOST/bin/cc ar; mv ar $TARGET/bin
make CC=$HOST/bin/cc ld; mv ld $TARGET/bin
make CC=$HOST/bin/cc nm; mv nm $TARGET/bin

(cd libc; make clean; make CC=$TARGET/bin/cc AR=$TARGET/bin/ar; \
	mv crt0.o libc.a $TARGET/lib)
