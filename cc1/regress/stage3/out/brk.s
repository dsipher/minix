.text

_sbrk:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	xorl %edi,%edi
	call ___brk
	movq %rax,%rbx
	testq %r12,%r12
	jz L6
L4:
	leaq (%rbx,%r12),%rdi
	call ___brk
	cmpq %rax,%rbx
	jz L7
L6:
	movq %rbx,%rax
	jmp L3
L7:
	movl $12,_errno(%rip)
	movq $-1,%rax
L3:
	popq %r12
	popq %rbx
	ret 


_brk:
L12:
	pushq %rbx
L13:
	movq %rdi,%rbx
	movq %rbx,%rdi
	call ___brk
	cmpq %rax,%rbx
	ja L15
L17:
	xorl %eax,%eax
	jmp L14
L15:
	movl $12,_errno(%rip)
	movl $-1,%eax
L14:
	popq %rbx
	ret 


.globl _errno
.globl _brk
.globl ___brk
.globl _sbrk
