CC=cc
ROOT=~/xcc

set -e

rm -rf $ROOT
mkdir $ROOT

mkdir $ROOT/bin

$CC -DAS=\"/usr/bin/as\" -DLD=\"/usr/bin/ld\" -DROOT=\"$ROOT\" \
	-o ~/xcc/bin/cc cc.c

(cd cpp; make clean; make; mv cpp $ROOT/bin)
(cd cc1; make clean; make; mv cc1 $ROOT/bin)

mkdir $ROOT/include
cp -rv include/* $ROOT/include

mkdir $ROOT/lib
(cd libc; make clean; make; mv crt0.o libc.a $ROOT/lib)
