.text

_refill:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movl %edi,%r13d
	leal 5(%r13),%ecx
	movl $1,%ebx
	shlq %cl,%rbx
	xorl %edi,%edi
	call _sbrk
	leaq 4095(%rax),%rdi
	shrq $12,%rdi
	shll $12,%edi
	subl %eax,%edi
	cmpq $4096,%rbx
	jae L5
L4:
	movl $4096,%eax
	xorl %edx,%edx
	divq %rbx
	movl %eax,%r12d
	jmp L6
L5:
	movl $1,%r12d
L6:
	movl %ebx,%eax
	imull %r12d,%eax
	addl %eax,%edi
	movslq %edi,%rdi
	call _sbrk
	movq %rax,%rsi
	xorl %eax,%eax
	cmpq $-1,%rsi
	jz L3
L11:
	cmpl %eax,%r12d
	jle L14
L12:
	movslq %r13d,%rdx
	movq _buckets(,%rdx,8),%rcx
	movq %rcx,(%rsi)
	movq %rsi,_buckets(,%rdx,8)
	addq %rbx,%rsi
	incl %eax
	jmp L11
L14:
	movl %r12d,%eax
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_malloc:
L16:
	pushq %rbx
	pushq %r12
L17:
	addq $8,%rdi
	xorl %r12d,%r12d
L20:
	leal 5(%r12),%ecx
	movl $1,%eax
	shlq %cl,%rax
	cmpq %rax,%rdi
	jbe L22
L25:
	incl %r12d
	cmpl $26,%r12d
	jl L20
L22:
	cmpl $26,%r12d
	jz L39
L29:
	movslq %r12d,%rbx
	cmpq $0,_buckets(,%rbx,8)
	jnz L33
L31:
	movl %r12d,%edi
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
	movl %r12d,4(%rax)
	movl $1265200743,(%rax)
	addq $8,%rax
L18:
	popq %r12
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
