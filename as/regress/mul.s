	mulb %sil
	mulw (,%rbx,2)
	mull (%rsi,%r15,8)
	mulq %rdx
	mulq %r15

	imulb %cl
	imulw $100, %ax, %cx
	imulw $200, %ax, %cx
	imull $10,-564(%rbp),%eax
	imull $3,24(%rbx),%eax
	imull $31,%eax,%eax
	imull $60,%eax,%eax
	imull %eax,%edi
	imull %eax,%edx
	imull %eax,%esi
	imull %eax,%r12d
	imull %ebx,%eax
	imull %ebx,%ecx
	imull %ebx,%edi
	imull %ecx,%eax
	imull %ecx,%edx
	imull %esi,%eax
	imull %esi,%r8d
	imull $100, %eax, %ecx
	imull $200, %r8d, %r15d
	imull %r12d,%eax
	imull %r13d,%ecx
	imull %r13d,%edi
	imull %r13d,%edx
	imull %r13d,%r12d
	imull %r14d,%eax
	imull %r14d,%ebx
	imull %r14d,%ecx
	imull %r14d,%edx
	imull %r14d,%esi
	imull %r8d,%edx
	imull -4(%rbp),%ecx
	imull -8(%rbp),%r12d
	imull 4(%r12),%ebx
	imulq $60,%rax,%rax
	imulq $600,%rax,%rax
	imulq %r12,%rax
	imulq %r13,%r12
	imulq %r14,%rsi
	imulq %r15,%rax
	imulq %rax,%r13
	imulq %rcx,%rax
	imulq %rdi,%rax
	imulq %rdi,%rcx
	imulq %rdx,%rcx
	imulq %rdx,%rsi
	imulq %rsi,%r11
	imulq 16(%rsi),%rcx
