.text

_fseek:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movq %rdi,%rbx
	movq %rsi,%r12
	movl %edx,%r14d
	xorl %r13d,%r13d
	movl 8(%rbx),%eax
	andl $-49,%eax
	movl %eax,8(%rbx)
	testl $128,%eax
	jz L5
L4:
	cmpl $1,%r14d
	jnz L9
L14:
	cmpq $0,16(%rbx)
	jz L9
L10:
	testl $4,%eax
	jnz L9
L7:
	movl (%rbx),%r13d
L9:
	movl $0,(%rbx)
	jmp L6
L5:
	testl $256,%eax
	jz L6
L18:
	movq %rbx,%rdi
	call _fflush
L6:
	movslq %r13d,%r13
	subq %r13,%r12
	movl %r14d,%edx
	movq %r12,%rsi
	movl 4(%rbx),%edi
	call _lseek
	movl 8(%rbx),%ecx
	testl $1,%ecx
	jz L23
L24:
	testl $2,%ecx
	jz L23
L21:
	andl $-385,%ecx
	movl %ecx,8(%rbx)
L23:
	movq 16(%rbx),%rcx
	movq %rcx,24(%rbx)
	cmpq $-1,%rax
	movl $0,%ecx
	movl $-1,%eax
	cmovnzl %ecx,%eax
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


.globl _fseek
.globl _lseek
.globl _fflush
