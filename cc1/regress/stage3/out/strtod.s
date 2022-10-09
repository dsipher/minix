.text
L158:
	.quad 0xbff0000000000000
L159:
	.quad 0x0

_strtod:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	movsd %xmm8,-32(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,-16(%rbp) # spill
	movq %rsi,-8(%rbp) # spill
	movq -16(%rbp),%r15 # spill
	xorl %edi,%edi
	movl $0,-20(%rbp) # spill
	movl $0,-24(%rbp) # spill
	xorl %ebx,%ebx
	xorl %r13d,%r13d
	movsd L159(%rip),%xmm8
L4:
	movsbl (%r15),%r14d
	incq %r15
	movslq %r14d,%r14
	testb $8,___ctype+1(%r14)
	jnz L4
L6:
	cmpl $45,%r14d
	jz L10
L155:
	cmpl $43,%r14d
	jz L11
	jnz L8
L10:
	movl $1,%ebx
L11:
	movsbl (%r15),%r14d
	incq %r15
L8:
	movl %r14d,%eax
	subl $48,%eax
	cmpl $10,%eax
	jb L29
L15:
	cmpl $46,%r14d
	jnz L27
L23:
	movsbl (%r15),%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L27
L29:
	movl %r14d,%r12d
	subl $48,%r12d
	cmpl $10,%r12d
	jae L34
L33:
	testl %r12d,%r12d
	jnz L38
L39:
	testl $2,%ebx
	jz L38
L40:
	movq %r15,%rcx
L43:
	movsbl (%rcx),%r14d
	incq %rcx
	cmpl $48,%r14d
	jz L43
L46:
	movl %r14d,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L47
L38:
	cmpl $0,-20(%rbp) # spill
	jnz L55
L54:
	testl %r12d,%r12d
	jz L53
L55:
	incl -20(%rbp) # spill
L53:
	movq $1844674407370955160,%rax
	cmpq %rax,%r13
	jbe L59
L58:
	testl $8,%ebx
	jz L62
L61:
	call ___pow10
	mulsd %xmm8,%xmm0
	cmpq $0,%r13
	jg L64
L65:
	movq %r13,%rax
	andl $1,%eax
	orq %r13,%rax
	cvtsi2sdq %rax,%xmm8
	addsd %xmm8,%xmm8
	jmp L66
L64:
	cvtsi2sdq %r13,%xmm8
L66:
	addsd %xmm0,%xmm8
	jmp L63
L62:
	cmpq $0,%r13
	jg L67
L68:
	movq %r13,%rax
	andl $1,%eax
	orq %r13,%rax
	cvtsi2sdq %rax,%xmm8
	addsd %xmm8,%xmm8
	jmp L69
L67:
	cvtsi2sdq %r13,%xmm8
L69:
	orl $8,%ebx
L63:
	movl $1,%edi
	movslq %r12d,%r13
	jmp L60
L59:
	incl %edi
	leaq (%r13,%r13,4),%r13
	addq %r13,%r13
	movslq %r12d,%r12
	addq %r12,%r13
L60:
	testl $2,%ebx
	jz L35
L70:
	decl -24(%rbp) # spill
	jmp L35
L47:
	movq %rcx,%r15
	jmp L32
L34:
	cmpl $46,%r14d
	jnz L32
L76:
	testl $2,%ebx
	jnz L32
L77:
	orl $2,%ebx
L35:
	movsbl (%r15),%r14d
	incq %r15
	jmp L29
L32:
	testl $8,%ebx
	jz L82
L81:
	call ___pow10
	mulsd %xmm8,%xmm0
	cmpq $0,%r13
	jg L84
L85:
	movq %r13,%rax
	andl $1,%eax
	orq %r13,%rax
	cvtsi2sdq %rax,%xmm8
	addsd %xmm8,%xmm8
	jmp L86
L84:
	cvtsi2sdq %r13,%xmm8
L86:
	addsd %xmm0,%xmm8
	jmp L83
L82:
	cmpq $0,%r13
	jg L87
L88:
	movq %r13,%rax
	andl $1,%eax
	orq %r13,%rax
	cvtsi2sdq %rax,%xmm8
	addsd %xmm8,%xmm8
	jmp L83
L87:
	cvtsi2sdq %r13,%xmm8
L83:
	cmpl $101,%r14d
	jz L94
L93:
	cmpl $69,%r14d
	jnz L92
L94:
	movq %r15,%rax
	decq %rax
	movq %rax,-16(%rbp) # spill
	movsbl (%r15),%esi
	incq %r15
	cmpl $45,%esi
	jz L100
L151:
	cmpl $43,%esi
	jz L101
	jnz L98
L100:
	orl $4,%ebx
L101:
	movsbl (%r15),%esi
	incq %r15
L98:
	movl %esi,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L27
L104:
	xorl %edx,%edx
	xorl %ecx,%ecx
	jmp L106
L107:
	testl %edx,%edx
	jnz L114
L113:
	cmpl $48,%esi
	jz L112
L114:
	incl %edx
L112:
	leal (%rcx,%rcx,4),%ecx
	addl %ecx,%ecx
	addl %esi,%ecx
	subl $48,%ecx
	movsbl (%r15),%esi
	incq %r15
L106:
	movl %esi,%eax
	subl $48,%eax
	cmpl $10,%eax
	jb L107
L109:
	movl %ebx,%eax
	andl $4,%eax
	cmpl $3,%edx
	jg L117
L119:
	testl %eax,%eax
	jz L125
L124:
	subl %ecx,-24(%rbp) # spill
	jmp L92
L125:
	addl %ecx,-24(%rbp) # spill
L92:
	decq %r15
	movq %r15,-16(%rbp) # spill
	cmpl $-307,-24(%rbp) # spill
	jg L128
L127:
	orl $32,%ebx
	jmp L27
L128:
	movl -20(%rbp),%eax # spill
	addl -24(%rbp),%eax # spill
	decl %eax
	cmpl $308,%eax
	movl %eax,-20(%rbp) # spill
	jl L131
L130:
	orl $16,%ebx
	jmp L27
L131:
	cmpl $0,-24(%rbp) # spill
	jz L27
L133:
	movl -24(%rbp),%edi # spill
	call ___pow10
	mulsd %xmm8,%xmm0
	movsd %xmm0,%xmm8
	jmp L27
L117:
	testl %eax,%eax
	movl $16,%eax
	movl $32,%ecx
	cmovzl %eax,%ecx
	orl %ebx,%ecx
	movl %ecx,%ebx
	decq %r15
	movq %r15,-16(%rbp) # spill
L27:
	cmpq $0,-8(%rbp) # spill
	jz L138
L136:
	movq -8(%rbp),%rcx # spill
	movq -16(%rbp),%rax # spill
	movq %rax,(%rcx)
L138:
	testl $32,%ebx
	jnz L139
L141:
	testl $16,%ebx
	jz L145
L143:
	movl $34,_errno(%rip)
	movsd ___huge_val(%rip),%xmm8
L145:
	testl $1,%ebx
	jz L160
L146:
	mulsd L158(%rip),%xmm8
L160:
	movsd %xmm8,%xmm0
	jmp L3
L139:
	movl $34,_errno(%rip)
	movsd L159(%rip),%xmm0
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movsd -32(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _errno
.globl ___pow10
.globl _strtod
.globl ___ctype
.globl ___huge_val
