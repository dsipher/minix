	divb %sil
	divw (,%rbx,2)
	divl (%rsi,%r15,8)
	divq %rdx
	divq %r15

	idivb %sil
	idivw (,%rbx,2)
	idivl (%rsi,%r15,8)
	idivq %rdx
	idivq %r15

        divl %ecx
        divq %r12
        divq %r8
        divq %rcx
        divq %rsi
        divq 16(%rcx)
        divq 8(%r14)
        divq 8(%rcx)
        idivl %ecx
        idivl %edi
        idivl %esi
        idivl %r8d
        idivq %r12
        idivq %r13
        idivq %rcx
        idivq %rdi
        idivq %rsi
        idivq 16(%rcx)
        idivq 8(%r14)
        idivq 8(%rcx)

        divss %xmm1, %xmm8
        divss %xmm0, %xmm5
        divsd %xmm1, %xmm15
        divsd 16(%rbp, %rcx), %xmm2
