.code16
        bsrl %eax,%eax
        bsfl %eax,%eax
        bsrl %eax,%ecx
        call *%ax
        jmp *%ax
        jmp *%cx
        jmp *%si
        call *%eax
        jmp *%eax
        jmp *%ecx
        jmp *%esi

	cbtw
	cwtd
	cltd

	clc
	cld
	cli
	cmc
	hlt
	iret

	stosb
	stosw
	stosl

	movsb
	movsw
	movsl

	scasb
	scasw
	scasl

	lodsb
	lodsw
	lodsl

	cmpsb
	cmpsw
	cmpsl

	int $0x10

	outb %al, $0x20
	outb %al, %dx

	outw %ax, $0x20
	outw %ax, %dx

	outl %eax, $0x20
	outl %eax, %dx

	inb $0x20, %al
	inb %dx, %al

	inw $0x20, %ax
	inw %dx, %ax

	inl $0x20, %eax
	inl %dx, %eax

	lidt 0x1000
	lidt (%bx)
	lgdt 0x1000
	lgdt (%bx)
	lldt 0x1000
	lldt (%bx)
	lmsw %ax

	rdmsr
	wrmsr

.code32

	aaa
	aad
	aad $0x12
	aam
	aam $0x1F
	aas
        bsrl %eax,%eax
        bsfl %eax,%eax
        bsrl %eax,%ecx
        call *%eax
        jmp *%eax
        jmp *%ecx
        jmp *%esi

	cbtw
	cwtd
	cltd
	iret
	syscall
	sysret

	stosb
	stosw
	stosl

	movsb
	movsw
	movsl

	scasb
	scasw
	scasl

	lodsb
	lodsw
	lodsl

	cmpsb
	cmpsw
	cmpsl

	int $0x10

	outb %al, $0x20
	outb %al, %dx

	outw %ax, $0x20
	outw %ax, %dx

	outl %eax, $0x20
	outl %eax, %dx

	inb $0x20, %al
	inb %dx, %al

	inw $0x20, %ax
	inw %dx, %ax

	inl $0x20, %eax
	inl %dx, %eax

	lidt 0x1000
	lidt (%ebx)
	lgdt 0x1000
	lgdt (%esi)
	lldt 0x1000
	lldt (%ebp)
	lmsw %ax

	rdmsr
	wrmsr

.code64

        bsrw %r15w, %si
        bsrw %dx, %r12w
        bsrq %rax,%rax
        bsrl %eax,%eax
        bsfq %rax,%rax
        bsfl %eax,%eax
        bsrl -4(%rbp),%eax
        bsrq 88(%rax),%rdx
        bsrl %eax,%ecx
        bsfl %eax,%eax

        call *%r12
        call *%r13
        call *%rax
        jmp *%rax
        jmp *%rcx
        jmp *%r13
        jmp *%rsi

	cbtw
	cwtd
	cltd
	cqto

	stosb
	stosw
	stosl
	stosq

	movsb
	movsw
	movsl
	movsq

	scasb
	scasw
	scasl
	scasq

	lodsb
	lodsw
	lodsl
	lodsq

	cmpsb
	cmpsw
	cmpsl
	cmpsq

	int $0x10

	outb %al, $0x20
	outb %al, %dx

	outw %ax, $0x20
	outw %ax, %dx

	outl %eax, $0x20
	outl %eax, %dx

	inb $0x20, %al
	inb %dx, %al

	inw $0x20, %ax
	inw %dx, %ax

	inl $0x20, %eax
	inl %dx, %eax

	lidt 0x1000
	lidt (%ebx)
	lgdt 0x1000
	lgdt (%rbx)
	lldt 0x1000(%rip)
	lldt (%r15)
	lmsw %ax

	rdmsr
	wrmsr
