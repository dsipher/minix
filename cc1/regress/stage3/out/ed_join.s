.text

_join:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8192,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movl %edi,%r14d
	movl %esi,%r13d
	leaq -8192(%rbp),%r12
	cmpl $0,%r14d
	jle L38
L11:
	cmpl %r13d,%r14d
	jg L38
L13:
	cmpl _lastln(%rip),%r13d
	jg L38
L9:
	cmpl %r13d,%r14d
	jz L16
L18:
	movl %r14d,%ebx
L20:
	cmpl %ebx,%r13d
	jl L23
L21:
	movl %ebx,%edi
	call _gettxt
	jmp L24
L27:
	leaq -1(%rbp),%rcx
	cmpq %rcx,%r12
	jae L29
L28:
	incq %rax
	movb %dl,(%r12)
	incq %r12
L24:
	movb (%rax),%dl
	cmpb $10,%dl
	jnz L27
L29:
	leaq -1(%rbp),%rax
	cmpq %rax,%r12
	jz L31
L33:
	incl %ebx
	jmp L20
L31:
	pushq $L34
	call _printf
	addq $8,%rsp
L38:
	movl $-2,%eax
	jmp L3
L23:
	movb $10,(%r12)
	movb $0,1(%r12)
	movl %r13d,%esi
	movl %r14d,%edi
	call _del
	decl %r14d
	movl %r14d,_curln(%rip)
	leaq -8192(%rbp),%rdi
	call _ins
	movl $1,_fchanged(%rip)
	jmp L37
L16:
	movl %r14d,_curln(%rip)
L37:
	xorl %eax,%eax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L34:
	.byte 108,105,110,101,32,116,111,111
	.byte 32,108,111,110,103,10,0

.globl _lastln
.globl _curln
.globl _printf
.globl _join
.globl _del
.globl _gettxt
.globl _ins
.globl _fchanged
