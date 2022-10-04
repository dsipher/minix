##############################################################################
#
#                                                          jewel/os kernel
#
##############################################################################

CFLAGS=-D_KERNEL -w

all:	kernel

clean:
	rm -f *.o *.lst kernel

OBJS= 	locore.o apic.o clock.o config.o cons.o	\
	log.o main.o page.o proc.o utsname.o

locore.o:	locore.s
	$(AS) -l locore.lst -o locore.o locore.s

apic.o:		apic.c 		config.h
clock.o:	clock.c 	config.h
config.o:	config.c 	config.h
cons.o:		cons.c 		config.h
log.o:		log.c 		config.h
main.o:		main.c 		config.h
page.o:		page.c 		config.h
proc.o:		proc.c 		config.h
utsname.o:	utsname.c 	config.h

kernel: $(OBJS)
	$(LD) -b 0x8000 -o kernel $(OBJS)
