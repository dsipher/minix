##############################################################################
#
#                                                          jewel/os kernel
#
##############################################################################

CC=~/xcc/jewel/bin/cc
AS=~/xcc/jewel/bin/as
LD=~/xcc/jewel/bin/ld

all:	kernel

clean:
	rm -f *.o *.lst kernel

HDRS=

OBJS= 	locore.o main.o

locore.o:	locore.s
	$(AS) -l locore.lst -o locore.o locore.s

main.o:		main.c $(HDRS)

kernel: $(OBJS)
	$(LD) -b 0x8000 -o kernel $(OBJS)
