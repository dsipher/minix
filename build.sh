# build.sh - basic build script to create a fresh
# installation of jewel on $DEVICE of $BLOCKS blocks.

# relies on tools built in $TOOLS by cross.sh.

# this, like cross.sh, is a throwaway which will be
# discarded once jewel/os is minimally self-hosting.

TOOLS=~/xcc/jewel
DEVICE=/dev/sdb
BLOCKS=25600

export AS=$TOOLS/bin/as
export CC=$TOOLS/bin/cc
export LD=$TOOLS/bin/ld
export MKBOOT=$TOOLS/bin/mkboot
export MKFS=$TOOLS/bin/mkfs

set -e
make clean

make boot
(cd kernel; make)

dd if=/dev/zero of=$DEVICE bs=4k count=$BLOCKS
$MKFS -p proto $DEVICE $BLOCKS
$MKBOOT -b boot $DEVICE
