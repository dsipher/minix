##############################################################################
#
#                                                          tahoe/64 kernel
#
##############################################################################

CC=~/xcc/tahoe/bin/cc
AS=~/xcc/tahoe/bin/as
LD=~/xcc/tahoe/bin/ld

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
