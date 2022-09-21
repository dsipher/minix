.text

_bsearch:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,-8(%rbp)
	movq %rsi,%r15
	movq %rdx,%rbx
	movq %rcx,%r14
	movq %r8,-16(%rbp)
L4:
	testq %rbx,%rbx
	jz L6
L5:
	movq %rbx,%r13
	shrq $1,%r13
	movq %r13,%rsi
	imulq %r14,%rsi
	leaq (%rsi,%r15),%r12
	addq %r15,%rsi
	movq -8(%rbp),%rdi
	movq -16(%rbp),%rax
	call *%rax
	cmpl $0,%eax
	jl L12
	jz L7
L11:
	leaq (%r14,%r12),%r15
	decq %rbx
	shrq $1,%rbx
	jmp L4
L12:
	movq %r13,%rbx
	jmp L4
L7:
	movq %r12,%rax
	jmp L3
L6:
	xorl %eax,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _bsearch
