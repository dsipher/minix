##############################################################################
#
#                                                          jewel/os kernel
#
##############################################################################

CFLAGS=-D_KERNEL -w

all:	kernel

clean:
	rm -f *.o *.lst kernel

OBJS= 	locore.o apic.o clock.o cons.o log.o		\
	main.o page.o proc.o utsname.o

locore.o:	locore.s
	$(AS) -l locore.lst -o locore.o locore.s

apic.o:		apic.c
clock.o:	clock.c
cons.o:		cons.c
log.o:		log.c
main.o:		main.c
page.o:		page.c
proc.o:		proc.c
utsname.o:	utsname.c

kernel: $(OBJS)
	$(LD) -b 0x8000 -o kernel $(OBJS)
