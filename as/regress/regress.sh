#!/bin/sh

# regression testing for the tahoe/64 assembler.
#
# for each of the TESTS, we build with `as', then with $AS.
# extract the binary text portion of each and compare. they
# must be identical. we specifically encode insns in the way
# `gas' does (when there is a choice) to make this test work
# (obviously once we're self-hosted we'll have to rewrite this
# to compare results with the installed assembler /usr/bin/as.)
#
# as a secondary regression test, we save the listings of all
# the files assembled above in the repo to catch any changes.
# to TESTS we add OTHER, which are assembly files which can't
# be assembled with `gas' (different syntax/mnemonics) or which
# would have different results if we did (relocatable symbols).
#
# `as' must already be built in the parent directory.

set -e
ROOT=`pwd`
AS=/usr/bin/as

# the contents of TESTS is restrictive. we're limited to pure
# insns (no symbol references allowed) and only text, no data
# or bss. this greatly simplifies the resulting a.out so our
# transformations below can be easy. also, `gas' and `as' deal
# with relocated symbols differently in text, so there would
# be false mismatches in the regression output. for now TESTS
# is mostly a collection of insns extracted from cc1/regress
# and filtered to meet the above criteria.

# again, once we're self-hosted much of this will change and
# we can be more expansive. for now we're mostly [trying] to
# make sure no one (read: me) has goofed the encoding tables,
# because typing them makes anyone (read: me) go cross-eyed.

TESTS="		adc	add	and 	cmov	\
		cmp	dec	inc 	lea	\
		misc	mov	movsx	movzx	\
		neg	not	or	pop	\
		push    sbb	set	sub	\
		test	xor			"

for TEST in $TESTS
do
	# assemble with new `as', generate .lst and .bin

	../as -l $TEST.lst $TEST.s
	dd if=a.out of=$TEST.bin bs=1 skip=32 status=none

	# assemble with `gas' and generate .gas. we
	# need to use objcopy for the ELF output and
	# then dd to pad the text to the length of .bin

	$AS $TEST.s
	objcopy -O binary -j .text a.out $TEST.gas
	SIZE=`ls -l $TEST.bin | cut -d ' ' -f 5`
	dd if=/dev/null of=$TEST.gas bs=1 count=1 seek=$SIZE status=none

	cmp $TEST.bin $TEST.gas
done

OTHERS="	seg	jmps			"

for OTHER in $OTHERS
do
	../as -l $OTHER.lst $OTHER.s
done

