.data
.align 4
_eightbit:
	.int 1
.text

_egets:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%r15
	movl %esi,%r14d
	movq %rdx,%r13
	xorl %r12d,%r12d
	movq %r15,%rbx
L4:
	cmpl %r12d,%r14d
	jle L7
L5:
	decl (%r13)
	js L9
L8:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movzbl (%rcx),%eax
	jmp L10
L9:
	movq %r13,%rdi
	call ___fillbuf
L10:
	cmpl $-1,%eax
	jz L11
L13:
	cmpl $10,%eax
	jz L19
L21:
	cmpl $127,%eax
	jle L25
L23:
	cmpl $0,_eightbit(%rip)
	jnz L28
L26:
	andl $127,%eax
L28:
	incl _nonascii(%rip)
L25:
	testl %eax,%eax
	jz L30
L29:
	movb %al,(%rbx)
	incq %rbx
	incl %r12d
	jmp L4
L30:
	incl _nullchar(%rip)
	jmp L4
L19:
	movb %al,(%rbx)
	movb $0,1(%rbx)
	leal 1(%r12),%eax
	jmp L3
L11:
	movb $10,(%rbx)
	movb $0,1(%rbx)
	testl %r12d,%r12d
	jz L47
L14:
	pushq $L17
	call _printf
	addq $8,%rsp
	jmp L47
L7:
	movl %r12d,%ecx
	decl %ecx
	movslq %ecx,%rcx
	movb $0,(%rcx,%r15)
	cmpl $10,%eax
	jz L47
L32:
	pushq $L35
	call _printf
	addq $8,%rsp
	incl _truncated(%rip)
L36:
	decl (%r13)
	js L40
L39:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movzbl (%rcx),%eax
	jmp L41
L40:
	movq %r13,%rdi
	call ___fillbuf
L41:
	cmpl $-1,%eax
	jz L47
L37:
	cmpl $10,%eax
	jnz L36
L47:
	movl %r12d,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L35:
	.byte 116,114,117,110,99,97,116,105
	.byte 110,103,32,108,105,110,101,10
	.byte 0
L17:
	.byte 91,73,110,99,111,109,112,108
	.byte 101,116,101,32,108,97,115,116
	.byte 32,108,105,110,101,93,10,0
.globl _nonascii
.comm _nonascii, 4, 4
.globl _nullchar
.comm _nullchar, 4, 4
.globl _truncated
.comm _truncated, 4, 4

.globl ___fillbuf
.globl _truncated
.globl _printf
.globl _nullchar
.globl _nonascii
.globl _eightbit
.globl _egets
