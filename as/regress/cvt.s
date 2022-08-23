	cvtss2sd %xmm0,%xmm8
	cvtss2sd %xmm0,%xmm0
	cvtss2sd -144(%rbp),%xmm0
	cvtss2sd 16(%rbp),%xmm0
	cvtss2sd 16(%rbp),%xmm15

	cvtsd2ss %xmm8,%xmm0
	cvtsd2ss -144(%rbp),%xmm0
	cvtsd2ss 16(%rbp),%xmm0
	cvtsd2ss 16(%rbp),%xmm15

        cvtsi2ssl %eax,%xmm0
        cvtsi2ssl %ebx,%xmm0
        cvtsi2ssl %ecx,%xmm0
        cvtsi2ssq %r13,%xmm8
        cvtsi2ssq %r14,%xmm0
        cvtsi2ssq %rax,%xmm0
        cvtsi2ssq %rax,%xmm1
        cvtsi2ssq %rax,%xmm8
        cvtsi2ssq %rcx,%xmm0
        cvtsi2ssq (%rdx),%xmm0
        cvtsi2ssl 32(%rdi),%xmm0
        cvtsi2ssq 56(%rax),%xmm10
        cvtsi2ssl 8(%rbx,%r10),%xmm2
        cvtsi2ssq 8(%rbx,%r8),%xmm0
        cvtsi2ssq 8(%rdi,%rsi),%xmm2

	cvtsi2sdl %eax,%xmm0
	cvtsi2sdl %ebx,%xmm0
	cvtsi2sdl %ecx,%xmm0
	cvtsi2sdq %r13,%xmm8
	cvtsi2sdq %r14,%xmm0
	cvtsi2sdq %rax,%xmm10
	cvtsi2sdq %rax,%xmm1
	cvtsi2sdq %rax,%xmm8
	cvtsi2sdq %rcx,%xmm0
	cvtsi2sdq (%rdx),%xmm0
	cvtsi2sdq 32(%rdi),%xmm0
	cvtsi2sdl 56(%rax),%xmm0
	cvtsi2sdq 8(%rbx,%r10),%xmm15
	cvtsi2sdl 8(%rbx,%r8),%xmm0
	cvtsi2sdl 8(%rdi,%rsi),%xmm2

        cvttss2sil -16(%rbp),%r12d
        cvttss2sil %xmm1,%ecx
        cvttss2siq %xmm10,%rax
        cvttss2siq %xmm1,%rcx

        cvttsd2sil -16(%rbp),%r12d
        cvttsd2sil %xmm15,%ecx
        cvttsd2siq %xmm1,%rax
        cvttsd2siq %xmm1,%rcx

