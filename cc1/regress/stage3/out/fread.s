.text

_fread:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rsi,%r15
	movq %rdx,-8(%rbp)
	movq %rcx,%r14
	movq %rdi,%r13
	xorl %r12d,%r12d
	testq %r15,%r15
	jz L21
L7:
	cmpq %r12,-8(%rbp)
	jbe L21
L8:
	movq %r15,%rbx
L10:
	decl (%r14)
	js L17
L16:
	movq 24(%r14),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r14)
	movzbl (%rcx),%eax
	jmp L18
L17:
	movq %r14,%rdi
	call ___fillbuf
L18:
	cmpl $-1,%eax
	jz L21
L13:
	movb %al,(%r13)
	incq %r13
	decq %rbx
	jnz L10
L11:
	incq %r12
	jmp L7
L21:
	movq %r12,%rax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl ___fillbuf
.globl _fread
