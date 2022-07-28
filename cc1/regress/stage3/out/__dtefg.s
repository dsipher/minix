.text

_dtof:
L1:
L2:
	movq %rdi,%rax
	cmpl $0,%ecx
	jl L4
L7:
	movb (%rsi),%dil
	testb %dil,%dil
	jz L11
L10:
	movsbl %dil,%edi
	incq %rsi
	jmp L12
L11:
	movl $48,%edi
L12:
	movb %dil,(%rax)
	incq %rax
	movl %ecx,%edi
	decl %ecx
	testl %edi,%edi
	jnz L7
	jz L6
L4:
	movb $48,(%rax)
	incq %rax
L6:
	testl %r9d,%r9d
	jnz L15
L16:
	testl %edx,%edx
	jz L3
L20:
	cmpl $103,%r8d
	jz L24
L28:
	cmpl $71,%r8d
	jnz L15
L24:
	cmpb $0,(%rsi)
	jz L3
L15:
	movb $46,(%rax)
	incq %rax
L33:
	movl %edx,%edi
	decl %edx
	cmpl $0,%edi
	jle L3
L34:
	cmpl $103,%r8d
	jz L43
L47:
	cmpl $71,%r8d
	jnz L38
L43:
	cmpb $0,(%rsi)
	jnz L38
L39:
	testl %r9d,%r9d
	jz L3
L38:
	incl %ecx
	jns L53
L52:
	movb $48,(%rax)
	incq %rax
	jmp L33
L53:
	movb (%rsi),%dil
	testb %dil,%dil
	jz L56
L55:
	movsbl %dil,%edi
	incq %rsi
	jmp L57
L56:
	movl $48,%edi
L57:
	movb %dil,(%rax)
	incq %rax
	jmp L33
L3:
	ret 

L126:
	.quad 0x4014000000000000
L127:
	.quad 0x4024000000000000
L128:
	.quad 0x0
L129:
	.quad 0x3fb999999999999a
L130:
	.quad 0x3ff0000000000000
L131:
	.quad 0x400a934f0979a371

_dtoa:
L60:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	movsd %xmm8,-32(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L61:
	movl %edi,%r15d
	movsd (%rsi),%xmm8
	movl %edx,%ebx
	movq %rcx,-24(%rbp)
	movq %r8,%r14
	movq %r14,%r13
	ucomisd L128(%rip),%xmm8
	jz L66
L65:
	leaq -4(%rbp),%rdi
	movsd %xmm8,%xmm0
	call _frexp
	movl -4(%rbp),%eax
	decl %eax
	movl %eax,-4(%rbp)
	cvtsi2sdl %eax,%xmm0
	divsd L131(%rip),%xmm0
	leaq -16(%rbp),%rdi
	call _modf
	ucomisd L128(%rip),%xmm0
	jae L70
L68:
	movsd -16(%rbp),%xmm0
	subsd L130(%rip),%xmm0
	movsd %xmm0,-16(%rbp)
L70:
	cvttsd2sil -16(%rbp),%r12d
	movl %r12d,%edi
	negl %edi
	call ___pow10
	mulsd %xmm8,%xmm0
	movsd %xmm0,%xmm1
	ucomisd L127(%rip),%xmm0
	jb L73
L71:
	incl %r12d
	movsd L129(%rip),%xmm1
	mulsd %xmm0,%xmm1
L73:
	movq -24(%rbp),%rax
	movl %r12d,(%rax)
	cmpl $101,%r15d
	jz L74
L77:
	cmpl $69,%r15d
	jnz L75
L74:
	incl %ebx
	jmp L76
L75:
	cmpl $102,%r15d
	jnz L76
L81:
	leal 1(%r12,%rbx),%ebx
L76:
	cmpl $0,%ebx
	jg L85
	jl L66
L90:
	ucomisd L126(%rip),%xmm1
	ja L94
L66:
	movq -24(%rbp),%rax
	movl $0,(%rax)
	movb $48,(%r14)
	movb $0,1(%r14)
	jmp L62
L85:
	cmpl $15,%ebx
	movl $15,%eax
	cmovgl %eax,%ebx
L100:
	movslq %ebx,%rax
	addq %r14,%rax
	cmpq %rax,%r13
	jae L103
L104:
	ucomisd L128(%rip),%xmm1
	jz L103
L101:
	cvttsd2sil %xmm1,%ecx
	leal 48(%rcx),%eax
	movb %al,(%r13)
	incq %r13
	cvtsi2sdl %ecx,%xmm0
	subsd %xmm0,%xmm1
	movsd L127(%rip),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,%xmm1
	jmp L100
L103:
	movb $0,(%r13)
	ucomisd L126(%rip),%xmm1
	ja L119
L111:
	decq %r13
	cmpq %r13,%r14
	jz L62
L114:
	cmpb $48,(%r13)
	jnz L62
L112:
	movb $0,(%r13)
	jmp L111
L119:
	movq %r13,%rax
	decq %r13
	cmpq %rax,%r14
	jz L121
L120:
	movb (%r13),%al
	incb %al
	movb %al,(%r13)
	cmpb $57,%al
	jle L62
L124:
	movb $0,(%r13)
	jmp L119
L121:
	incq %r13
L94:
	movq -24(%rbp),%rax
	movl (%rax),%ecx
	incl %ecx
	movq -24(%rbp),%rax
	movl %ecx,(%rax)
	movb $49,(%r13)
	movb $0,1(%r13)
L62:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movsd -32(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 

L187:
	.quad 0xbff0000000000000

___dtefg:
L132:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L133:
	movq %rdi,%r15
	movsd (%rsi),%xmm1
	movl %edx,%r14d
	movl %ecx,%r13d
	movl %r8d,%r12d
	movsd %xmm1,-8(%rbp)
	testl %r13d,%r13d
	jnz L136
L138:
	cmpl $103,%r14d
	jz L135
L142:
	cmpl $71,%r14d
	jnz L136
L135:
	movl $1,%r13d
	jmp L137
L136:
	cmpl $-1,%r13d
	movl $6,%eax
	cmovzl %eax,%r13d
L137:
	ucomisd L128(%rip),%xmm1
	jae L150
L149:
	movsd L187(%rip),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,-8(%rbp)
	movl $-1,(%r9)
	jmp L151
L150:
	movl $1,(%r9)
L151:
	leaq -28(%rbp),%r8
	leaq -12(%rbp),%rcx
	movl %r13d,%edx
	leaq -8(%rbp),%rsi
	movl %r14d,%edi
	call _dtoa
	cmpl $101,%r14d
	jz L153
L156:
	cmpl $69,%r14d
	jz L153
L152:
	cmpl $103,%r14d
	jz L160
L164:
	cmpl $71,%r14d
	jnz L154
L160:
	movl -12(%rbp),%eax
	cmpl $-4,%eax
	jl L153
L168:
	cmpl %eax,%r13d
	jg L154
L153:
	movl $1,%ebx
	jmp L155
L154:
	xorl %ebx,%ebx
L155:
	testl %ebx,%ebx
	jz L173
L172:
	xorl %ecx,%ecx
	jmp L174
L173:
	movl -12(%rbp),%ecx
L174:
	movl %r12d,%r9d
	movl %r14d,%r8d
	movl %r13d,%edx
	leaq -28(%rbp),%rsi
	movq %r15,%rdi
	call _dtof
	movq %rax,%r12
	movq %r12,%rax
	testl %ebx,%ebx
	jz L134
L175:
	cmpl $69,%r14d
	jz L178
L181:
	cmpl $71,%r14d
	jnz L179
L178:
	movl $69,%eax
	jmp L180
L179:
	movl $101,%eax
L180:
	movb %al,(%r12)
	leaq 1(%r12),%rax
	movl -12(%rbp),%ecx
	pushq %rcx
	pushq $L185
	pushq %rax
	call _sprintf
	addq $24,%rsp
	movslq %eax,%rax
	leaq 1(%r12,%rax),%rax
L134:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L185:
 .byte 37,43,48,51,100,0

.globl _sprintf
.globl ___pow10
.globl _frexp
.globl ___dtefg
.globl _modf
