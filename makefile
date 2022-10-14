##############################################################################
#
#                                                                 jewel/os
#
##############################################################################

all::	# default target

clean::
	(cd as; make clean)
	(cd cc1; make clean)
	(cd cpp; make clean)
	(cd kernel; make clean)
	(cd lex; make clean)
	(cd libc; make clean)
	(cd make; make clean)
	(cd yacc; make clean)
	rm -f *.lst *.o

########################################################################### ar

all::	ar

clean::
	rm -f ar

ar:	ar.c
	$(CC) -o ar ar.c

######################################################################### boot

all::   boot

clean::
	rm -f boot

boot: boot.o
	$(LD) -b 0x1000 -o boot boot.o

boot.o: boot.s
	$(AS) -l boot.lst -o boot.o boot.s

########################################################################### cc

all::	cc

clean::
	rm -f cc

cc:	ld.c
	$(CC) -o cc cc.c

########################################################################### ld

all::	ld

clean::
	rm -f ld

ld:	ld.c libc/crc32c.c
	$(CC) -o ld ld.c libc/crc32c.c

####################################################################### mkboot

all::	mkboot

clean::
	rm -f mkboot

mkboot:	mkboot.c
	$(CC) -o mkboot mkboot.c

######################################################################### mkfs

all::	mkfs

clean::
	rm -f mkfs

mkfs:	mkfs.c
	$(CC) -o mkfs mkfs.c

########################################################################### nm

all::	nm

clean::
	rm -f nm

nm:	nm.c
	$(CC) -o nm nm.c

