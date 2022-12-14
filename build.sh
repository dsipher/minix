# build.sh - basic build script to create a fresh
# installation of minix on $DEVICE of $BLOCKS blocks.

# relies on tools built in $TOOLS by cross.sh.

# this, like cross.sh, is a throwaway which will be
# discarded once minix is minimally self-hosting.

HOST=~/xcc/linux
TOOLS=~/xcc/minix
DEVICE=$1
BLOCKS=25600

export AR=$TOOLS/bin/ar
export AS=$TOOLS/bin/as
export CC=$TOOLS/bin/cc
export LD=$TOOLS/bin/ld
export LEX=$TOOLS/bin/lex
export YACC=$TOOLS/bin/yacc
export MKBOOT=$TOOLS/bin/mkboot
export MKFS=$TOOLS/bin/mkfs

export HOSTCC=$HOST/bin/cc

set -e
make clean

make boot

rm -rf build
mkdir build

for i in asrock fx160 vbox
do
	(cd kernel; make clean; make CONFIG=$i)
	mv kernel/kernel build/$i
done

(cd as; make HOSTCC=$HOSTCC)
(cd awk; make HOSTCC=$HOSTCC)
(cd cc1; make)
(cd cpp; make)
(cd ed; make)
(cd lex; make)
(cd libc; make)
(cd make; make)
(cd sed; make)
(cd sh; make)
(cd tar; make)
(cd yacc; make)

make ar
make compress
make ld
make ls
make mkboot
make mkfs
make nm

dd if=/dev/zero of=$DEVICE bs=4k count=$BLOCKS
$MKFS -p proto $DEVICE $BLOCKS
$MKBOOT -b boot $DEVICE
