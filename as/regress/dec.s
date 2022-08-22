	decb %al
	decl %eax
	decl %ebx
	decl %ecx
	decl %edi
	decl %edx
	decl %esi
	decl %r12d
	decl %r13d
	decl %r14d
	decl %r8d
	decl (%r12)
	decl (%r13)
	decl (%r14)
	decl (%r15)
	decl (%rax)
	decl (%rbx)
	decl (%rcx)
	decl (%rdi)
	decl (%rsi)
	decl -24(%rbp)
	decl -28(%rbp)
	decl 48(%rcx)
	decq %r12
	decq %r13
	decq %r15
	decq %rax
	decq %rbx
	decq %rcx
	decq %rdi
	decq %rdx
	decq %rsi
	decq 8(%rbx)
	decq 88(%rdi)

.code16

        decb %al
        decl %eax
        decl %ebx
        decl %ecx
        decl %edi
        decl %edx
        decl %esi
        decl (%bx)
        decl (%si)
        decw (%bx,%si)
        decl (%bp,%si)
        decl 10(%bx,%di)
        decw -24(%bp)
        decl -28(%bp)
        decl 48(%di)

.code32

        decb %al
        decl %eax
        decl %ebx
        decl %ecx
        decl %edi
        decl %edx
        decl %esi
        decl (%eax)
        decw (%ebx)
        decl (%ecx)
        decw (%edi)
        decl (%esi)
        decl -24(%ebp)
        decl -28(%ebp)
        decl 48(%ecx)

