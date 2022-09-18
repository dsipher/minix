##############################################################################
#
#                                                          jewel/os kernel
#
##############################################################################

CFLAGS=-D_KERNEL

all:	kernel

clean:
	rm -f *.o *.lst kernel

OBJS= 	locore.o cons.o log.o main.o page.o proc.o	\
	../libc/memmove.o ../libc/memset.o

locore.o:	locore.s
	$(AS) -l locore.lst -o locore.o locore.s

cons.o:		cons.c
log.o:		log.c
main.o:		main.c
page.o:		page.c
proc.o:		proc.c

memmove.o:	../libc/memmove.s
memset.o:	../libc/memset.s

kernel: $(OBJS)
	$(LD) -b 0x8000 -o kernel $(OBJS)
