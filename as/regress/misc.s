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


