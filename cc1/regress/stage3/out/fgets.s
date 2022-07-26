.text

_fgets:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movq %rdi,%r14
	movl %esi,%ebx
	movq %rdx,%r13
	movq %r14,%r12
L4:
	decl %ebx
	cmpl $0,%ebx
	jle L6
L7:
	decl (%r13)
	js L12
L11:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movzbl (%rcx),%eax
	jmp L13
L12:
	movq %r13,%rdi
	call ___fillbuf
L13:
	cmpl $-1,%eax
	jz L6
L5:
	movb %al,(%r12)
	incq %r12
	cmpl $10,%eax
	jnz L4
L6:
	cmpl $-1,%eax
	jnz L20
L18:
	testl $16,8(%r13)
	jz L30
L21:
	cmpq %r12,%r14
	jnz L20
L30:
	xorl %eax,%eax
	jmp L3
L20:
	movb $0,(%r12)
	movq %r14,%rax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


.globl ___fillbuf
.globl _fgets
