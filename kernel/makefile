##############################################################################
#
#                                                                ux/64 kernel
#
##############################################################################

CFLAGS=-D_KERNEL -w

all:	kernel

clean:
	rm -f *.o *.lst config.[ch] kernel

OBJS= 	locore.o apic.o buf.o clock.o config.o cons.o ide.o	\
	inode.o log.o main.o page.o pci.o proc.o ps2.o utsname.o

config.h config.c:
	cp config/$(CONFIG).c config.c
	cp config/$(CONFIG).h config.h

locore.o:	locore.s
	$(AS) -l locore.lst -o locore.o locore.s

apic.o:		apic.c 		config.h
buf.o:		buf.c		config.h
clock.o:	clock.c 	config.h
config.o:	config.c 	config.h
cons.o:		cons.c 		config.h
ide.o:		ide.c		config.h
inode.o:	inode.c		config.h
log.o:		log.c 		config.h
main.o:		main.c 		config.h
page.o:		page.c 		config.h
pci.o:		pci.c		config.h
proc.o:		proc.c 		config.h
ps2.o:		ps2.c		config.h
utsname.o:	utsname.c 	config.h

kernel: $(OBJS)
	$(LD) -b 0x8000 -o kernel $(OBJS)
