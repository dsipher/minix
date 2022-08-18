.text

_ftell:
L1:
	pushq %rbx
L2:
	movl 8(%rdi),%ecx
	testl $128,%ecx
	jz L5
L4:
	movl (%rdi),%ebx
	negl %ebx
	jmp L6
L5:
	testl $256,%ecx
	jz L8
L14:
	movq 16(%rdi),%rax
	testq %rax,%rax
	jz L8
L10:
	testl $4,%ecx
	jnz L8
L7:
	movq 24(%rdi),%rbx
	subq %rax,%rbx
	jmp L6
L8:
	xorl %ebx,%ebx
L6:
	movl $1,%edx
	xorl %esi,%esi
	movl 4(%rdi),%edi
	call _lseek
	cmpq $-1,%rax
	jz L3
L20:
	movslq %ebx,%rcx
	addq %rcx,%rax
L3:
	popq %rbx
	ret 


.globl _lseek
.globl _ftell
