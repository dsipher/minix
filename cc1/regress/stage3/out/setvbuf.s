.text

_setvbuf:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%r15
	movq %rsi,%r14
	movl %edx,%ebx
	movq %rcx,%r13
	xorl %r12d,%r12d
	movq $___stdio_cleanup,___exit_cleanup(%rip)
	testl %ebx,%ebx
	jz L9
L11:
	cmpl $64,%ebx
	jz L9
L12:
	cmpl $4,%ebx
	jz L9
L8:
	movl $-1,%eax
	jmp L3
L9:
	movq 16(%r15),%rdi
	testq %rdi,%rdi
	jz L18
L19:
	testl $8,8(%r15)
	jz L18
L20:
	call _free
L18:
	andl $-77,8(%r15)
	testq %r14,%r14
	jz L25
L26:
	testq %r13,%r13
	movl $-1,%eax
	cmovzl %eax,%r12d
L25:
	testq %r14,%r14
	jnz L32
L33:
	cmpl $4,%ebx
	jz L32
L34:
	testq %r13,%r13
	jz L41
L40:
	movq %r13,%rdi
	call _malloc
	movq %rax,%r14
	testq %rax,%rax
	jnz L42
L41:
	movl $-1,%r12d
	jmp L32
L42:
	orl $8,8(%r15)
L32:
	movq %r14,16(%r15)
	movl $0,(%r15)
	orl 8(%r15),%ebx
	movl %ebx,8(%r15)
	movq %r14,24(%r15)
	testq %r14,%r14
	jnz L45
L44:
	movl $1,12(%r15)
	jmp L46
L45:
	movl %r13d,12(%r15)
L46:
	movl %r12d,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


.globl _free
.globl _setvbuf
.globl ___exit_cleanup
.globl _malloc
.globl ___stdio_cleanup
