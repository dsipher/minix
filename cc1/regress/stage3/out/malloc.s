.text

_refill:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movl %edi,%r13d
	leal 5(%r13),%ecx
	movl $1,%r12d
	shlq %cl,%r12
	xorl %edi,%edi
	call _sbrk
	leaq 4095(%rax),%rcx
	shrq $12,%rcx
	shll $12,%ecx
	subl %eax,%ecx
	cmpq $4096,%r12
	jae L5
L4:
	movl $4096,%eax
	xorl %edx,%edx
	divq %r12
	movl %eax,%ebx
	jmp L6
L5:
	movl $1,%ebx
L6:
	movl %r12d,%eax
	imull %ebx,%eax
	addl %eax,%ecx
	movslq %ecx,%rdi
	call _sbrk
	movq %rax,%rdx
	xorl %eax,%eax
	cmpq $-1,%rdx
	jnz L11
	jz L3
L12:
	movslq %r13d,%r13
	movq _buckets(,%r13,8),%rcx
	movq %rcx,(%rdx)
	movq %rdx,_buckets(,%r13,8)
	addq %r12,%rdx
	incl %eax
L11:
	cmpl %eax,%ebx
	jg L12
L14:
	movl %ebx,%eax
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_malloc:
L16:
	pushq %rbx
L17:
	addq $8,%rdi
	xorl %ebx,%ebx
L20:
	leal 5(%rbx),%ecx
	movl $1,%eax
	shlq %cl,%rax
	cmpq %rax,%rdi
	jbe L22
L25:
	incl %ebx
	cmpl $26,%ebx
	jl L20
L22:
	cmpl $26,%ebx
	jz L39
L29:
	cmpq $0,_buckets(,%rbx,8)
	jnz L33
L31:
	movl %ebx,%edi
	call _refill
	testl %eax,%eax
	jnz L33
L39:
	xorl %eax,%eax
	jmp L18
L33:
	movq _buckets(,%rbx,8),%rax
	movq (%rax),%rcx
	movq %rcx,_buckets(,%rbx,8)
	movl %ebx,4(%rax)
	movl $1265200743,(%rax)
	addq $8,%rax
L18:
	popq %rbx
	ret 


_free:
L40:
L41:
	movq %rdi,%rdx
	subq $8,%rdx
	cmpl $1265200743,-8(%rdi)
	jnz L42
L43:
	movslq -4(%rdi),%rcx
	movq _buckets(,%rcx,8),%rax
	movq %rax,-8(%rdi)
	movq %rdx,_buckets(,%rcx,8)
L42:
	ret 

.local _buckets
.comm _buckets, 208, 8

.globl _free
.globl _malloc
.globl _sbrk
