.text

_doprnt:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	cmpl $1,%edi
	movl $1,%ebx
	cmovgel %edi,%ebx
	movl _lastln(%rip),%r13d
	cmpl %r13d,%esi
	cmovlel %esi,%r13d
	testl %r13d,%r13d
	jz L12
L10:
	movl %ebx,%edi
	call _getptr
	movq %rax,%r12
	jmp L13
L14:
	cmpl $0,_nflg(%rip)
	movl $0,%edx
	cmovnzl %ebx,%edx
	movl _lflg(%rip),%esi
	leaq 24(%r12),%rdi
	call _prntln
	movq 16(%r12),%r12
	incl %ebx
L13:
	cmpl %ebx,%r13d
	jge L14
L16:
	movl %r13d,_curln(%rip)
L12:
	xorl %eax,%eax
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_prntln:
L21:
	pushq %rbx
	pushq %r12
L22:
	movq %rdi,%r12
	movl %esi,%ebx
	testl %edx,%edx
	jz L28
L24:
	pushq %rdx
	pushq $L27
	call _printf
	addq $16,%rsp
	jmp L28
L31:
	cmpb $10,%dil
	jz L30
L29:
	cmpb $32,%dil
	jl L35
L38:
	cmpb $127,%dil
	jl L36
L35:
	cmpb $9,%dil
	jz L45
L75:
	cmpb $127,%dil
	jnz L81
L53:
	decl ___stdout(%rip)
	js L55
L54:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $94,(%rcx)
	jmp L56
L55:
	movl $___stdout,%esi
	movl $94,%edi
	call ___flushbuf
L56:
	decl ___stdout(%rip)
	js L58
L57:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $63,(%rcx)
	jmp L37
L58:
	movl $___stdout,%esi
	movl $63,%edi
	jmp L78
L45:
	testl %ebx,%ebx
	jz L47
L81:
	movsbl %dil,%edi
	movl $___stdout,%esi
	call _putcntl
	jmp L37
L47:
	decl ___stdout(%rip)
	js L82
	jns L80
L36:
	decl ___stdout(%rip)
	js L82
L80:
	movb (%r12),%dl
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb %dl,(%rcx)
	jmp L37
L82:
	movsbl (%r12),%edi
	movl $___stdout,%esi
L78:
	call ___flushbuf
L37:
	incq %r12
L28:
	movb (%r12),%dil
	testb %dil,%dil
	jnz L31
L30:
	testl %ebx,%ebx
	jz L67
L65:
	decl ___stdout(%rip)
	js L69
L68:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $36,(%rcx)
	jmp L67
L69:
	movl $___stdout,%esi
	movl $36,%edi
	call ___flushbuf
L67:
	decl ___stdout(%rip)
	js L72
L71:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $10,(%rcx)
	jmp L23
L72:
	movl $___stdout,%esi
	movl $10,%edi
	call ___flushbuf
L23:
	popq %r12
	popq %rbx
	ret 


_putcntl:
L83:
	pushq %rbx
	pushq %r12
L84:
	movl %edi,%r12d
	movq %rsi,%rbx
	decl (%rbx)
	js L87
L86:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $94,(%rcx)
	jmp L88
L87:
	movq %rbx,%rsi
	movl $94,%edi
	call ___flushbuf
L88:
	decl (%rbx)
	js L90
L89:
	andb $31,%r12b
	orb $64,%r12b
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb %r12b,(%rcx)
	jmp L85
L90:
	andl $31,%r12d
	orl $64,%r12d
	movq %rbx,%rsi
	movl %r12d,%edi
	call ___flushbuf
L85:
	popq %r12
	popq %rbx
	ret 

L27:
	.byte 37,55,100,32,0

.globl _putcntl
.globl _lastln
.globl ___stdout
.globl _nflg
.globl _lflg
.globl _curln
.globl _printf
.globl _getptr
.globl _prntln
.globl ___flushbuf
.globl _doprnt
