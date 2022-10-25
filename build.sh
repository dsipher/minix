# build.sh - basic build script to create a fresh
# installation of ux/64 on $DEVICE of $BLOCKS blocks.

# relies on tools built in $TOOLS by cross.sh.

# this, like cross.sh, is a throwaway which will be
# discarded once ux/64 is minimally self-hosting.

HOST=~/xcc/linux
TOOLS=~/xcc/ux64
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

for i in asrock vbox
do
	(cd kernel; make clean; make CONFIG=$i)
	mv kernel/kernel proto/$i
done

(cd as; make HOSTCC=$HOSTCC)
(cd cc1; make)
(cd cpp; make)
(cd lex; make)
(cd libc; make)
(cd make; make)
(cd yacc; make)

make ar
make ld
make ls
make mkboot
make mkfs
make nm

dd if=/dev/zero of=$DEVICE bs=4k count=$BLOCKS
$MKFS -p proto/proto $DEVICE $BLOCKS
$MKBOOT -b boot $DEVICE
