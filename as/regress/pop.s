.code16

	popw %ax
	popw %dx
	popw %cx
	popw %ax
	popw %ds
	popw %ss
	popw %es
	popw %gs
	popw %fs
	popl %es

.code32
	popl %eax
	popl %ebp
	popl %ebx
	popl %ecx
	popl %edi
	popl %edx
	popl %esi
	popl (%eax)
	popw %fs
	popw %ds
	popw %gs
	popw %ss
	popw %es
	popl %es

.code64

	popq %r12
	popq %r13
	popq %r14
	popq %r15
	popq %r8
	popq %rax
	popq %rbp
	popq %rbx
	popq %rcx
	popq %rdi
	popq %rdx
	popq %rsi
	popq (%r12)
	popq (%r13)
	popq (%rax)
	popq (%rax,%rcx,8)
	popq (%rbx)
	popq (%rbx,%rax,8)
	popq (%rcx,%rax,8)
	popq (%rcx,%rdx,8)
	popq (%rdi)
	popq (%rdx,%rcx,8)
	popq -16(%rbp)
	popq -24(%rbp)
	popq -32(%rbp)
	popq -48(%rbp)
	popq -8(%rbp)
	popq -8(%rbx)
	popq 16(%r12)
	popq 16(%r14)
	popq 16(%rbp)
	popq 16(%rbx)
	popq 16(%rcx)
	popq 24(%rbx)
	popq 8(%r12)
	popq 8(%rbx)
	popq 8(%rcx)
	popq %gs
	popq %fs
