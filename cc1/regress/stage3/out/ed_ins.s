.text

_ins:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8192,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%r12
	leaq -8192(%rbp),%rbx
L4:
	movb (%r12),%al
	movb %al,(%rbx)
	incq %r12
	cmpb $10,%al
	jnz L9
L7:
	movb $0,(%rbx)
L9:
	cmpb $0,(%rbx)
	jnz L10
L12:
	leaq -8192(%rbp),%rbx
	leaq -8192(%rbp),%rdi
	call _strlen
	leaq 32(%rax),%rdi
	call _malloc
	movq %rax,%r15
	testq %r15,%r15
	jz L14
L16:
	movl $0,(%r15)
	leaq -8192(%rbp),%rsi
	leaq 24(%r15),%rdi
	call _strcpy
	movl _curln(%rip),%edi
	call _getptr
	movq %rax,%r14
	movq 16(%r14),%r13
	movq %r13,%rcx
	movq %r15,%rdx
	movq %r15,%rsi
	movq %r14,%rdi
	call _relink
	movq %r15,%rcx
	movq %r14,%rdx
	movq %r13,%rsi
	movq %r15,%rdi
	call _relink
	incl _lastln(%rip)
	incl _curln(%rip)
	cmpb $0,(%r12)
	jnz L4
L18:
	movl $1,%eax
	jmp L3
L14:
	movl $-2,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L10:
	incq %rbx
	jmp L4


.globl _lastln
.globl _malloc
.globl _curln
.globl _getptr
.globl _relink
.globl _strlen
.globl _ins
.globl _strcpy
