.text

_fgets:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movq %rdi,%r14
	movl %esi,%r13d
	movq %rdx,%r12
	movq %r14,%rbx
L4:
	decl %r13d
	cmpl $0,%r13d
	jle L6
L7:
	decl (%r12)
	js L12
L11:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movzbl (%rcx),%eax
	jmp L13
L12:
	movq %r12,%rdi
	call ___fillbuf
L13:
	cmpl $-1,%eax
	jz L6
L5:
	movb %al,(%rbx)
	incq %rbx
	cmpl $10,%eax
	jnz L4
L6:
	cmpl $-1,%eax
	jnz L20
L18:
	testl $16,8(%r12)
	jz L30
L21:
	cmpq %rbx,%r14
	jnz L20
L30:
	xorl %eax,%eax
	jmp L3
L20:
	movb $0,(%rbx)
	movq %r14,%rax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


.globl ___fillbuf
.globl _fgets
