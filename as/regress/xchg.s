	xchgb %r15b,%al
	xchgl %eax,%ecx
	xchgl %ebx,%ebx
	xchgl %ecx,%ecx
	xchgl %edi,%edi
	xchgl %edx,%edx
	xchgl %esi,%esi
	xchgl %r10d,%r10d
	xchgl %r12d,%r12d
	xchgl %r13d,%r13d
	xchgl %r14d,%r14d
	xchgl %r15d,%r15d
	xchgl %r8d,%r8d
	xchgl %r9d,%r9d
	xchgq %r12,%rax
	xchgq %rax,%rcx
	xchgq %rax,%rsi
	xchgq %rbx,%rax
	xchgq %rcx,%rax
	xchgq %rdx,%rax
	xchgq %rdx,%rcx
	xchgq %rsi,%rax
	xchgq 8(%rcx),%rax
	xchgw %ax,%cx
	xchgw %bx,%bx
	xchgw %cx,%cx
	xchgw %di,%di
	xchgw %dx,%dx
	xchgw %si,%si
	xchgw 8(%rcx),%ax

.code32
	xchgl %eax,%ecx
	xchgl %ebx,%ebx
	xchgl %ecx,%ecx
	xchgl %edi,%edi
	xchgl %edx,%edx
	xchgl %esi,%esi
	xchgw %bx,%bx
	xchgw %cx,%cx
	xchgw %di,%di
	xchgw %dx,%dx
	xchgw %si,%si
	xchgw 8(%ecx),%ax

.code16
	xchgl %eax,%ecx
	xchgl %ebx,%ebx
	xchgl %ecx,%ecx
	xchgl %edi,%edi
	xchgl %edx,%edx
	xchgl %esi,%esi
	xchgw %bx,%bx
	xchgw %cx,%cx
	xchgw %di,%di
	xchgw %dx,%dx
	xchgw %si,%si
	xchgw 8(%si),%ax
