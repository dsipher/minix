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
L60:
	incq %rax
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
	jmp L60
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
	jmp L60
L3:
	ret 

L127:
	.quad 0x4014000000000000
L128:
	.quad 0x4024000000000000
L129:
	.quad 0x0
L130:
	.quad 0x3fb999999999999a
L131:
	.quad 0x3ff0000000000000
L132:
	.quad 0x400a934f0979a371

_dtoa:
L61:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	movsd %xmm8,-32(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L62:
	movl %edi,%r15d
	movsd (%rsi),%xmm8
	movl %edx,%ebx
	movq %rcx,-24(%rbp)
	movq %r8,%r14
	movq %r14,%r13
	ucomisd L129(%rip),%xmm8
	jz L67
L66:
	leaq -4(%rbp),%rdi
	movsd %xmm8,%xmm0
	call _frexp
	movl -4(%rbp),%eax
	decl %eax
	movl %eax,-4(%rbp)
	cvtsi2sdl %eax,%xmm0
	divsd L132(%rip),%xmm0
	leaq -16(%rbp),%rdi
	call _modf
	ucomisd L129(%rip),%xmm0
	jae L71
L69:
	movsd -16(%rbp),%xmm0
	subsd L131(%rip),%xmm0
	movsd %xmm0,-16(%rbp)
L71:
	cvttsd2sil -16(%rbp),%r12d
	movl %r12d,%edi
	negl %edi
	call ___pow10
	mulsd %xmm8,%xmm0
	movsd %xmm0,%xmm1
	ucomisd L128(%rip),%xmm0
	jb L74
L72:
	incl %r12d
	movsd L130(%rip),%xmm1
	mulsd %xmm0,%xmm1
L74:
	movq -24(%rbp),%rax
	movl %r12d,(%rax)
	cmpl $101,%r15d
	jz L75
L78:
	cmpl $69,%r15d
	jnz L76
L75:
	incl %ebx
	jmp L77
L76:
	cmpl $102,%r15d
	jnz L77
L82:
	leal 1(%r12,%rbx),%ebx
L77:
	cmpl $0,%ebx
	jg L86
	jl L67
L91:
	ucomisd L127(%rip),%xmm1
	ja L95
L67:
	movq -24(%rbp),%rax
	movl $0,(%rax)
	movb $48,(%r14)
	movb $0,1(%r14)
	jmp L63
L86:
	cmpl $15,%ebx
	movl $15,%eax
	cmovgl %eax,%ebx
	jmp L101
L105:
	ucomisd L129(%rip),%xmm1
	jz L104
L102:
	cvttsd2sil %xmm1,%ecx
	leal 48(%rcx),%eax
	movb %al,(%r13)
	incq %r13
	cvtsi2sdl %ecx,%xmm0
	subsd %xmm0,%xmm1
	movsd L128(%rip),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,%xmm1
L101:
	movslq %ebx,%rax
	addq %r14,%rax
	cmpq %rax,%r13
	jb L105
L104:
	movb $0,(%r13)
	ucomisd L127(%rip),%xmm1
	ja L120
L112:
	decq %r13
	cmpq %r13,%r14
	jz L63
L115:
	cmpb $48,(%r13)
	jnz L63
L113:
	movb $0,(%r13)
	jmp L112
L121:
	movb (%r13),%al
	incb %al
	movb %al,(%r13)
	cmpb $57,%al
	jle L63
L125:
	movb $0,(%r13)
L120:
	movq %r13,%rax
	decq %r13
	cmpq %rax,%r14
	jnz L121
L122:
	incq %r13
L95:
	movq -24(%rbp),%rax
	movl (%rax),%ecx
	incl %ecx
	movq -24(%rbp),%rax
	movl %ecx,(%rax)
	movb $49,(%r13)
	movb $0,1(%r13)
L63:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movsd -32(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 

L188:
	.quad 0xbff0000000000000

___dtefg:
L133:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L134:
	movq %rdi,%r15
	movsd (%rsi),%xmm1
	movl %edx,%r14d
	movl %ecx,%r13d
	movl %r8d,%ebx
	movsd %xmm1,-8(%rbp)
	testl %r13d,%r13d
	jnz L137
L139:
	cmpl $103,%r14d
	jz L136
L143:
	cmpl $71,%r14d
	jnz L137
L136:
	movl $1,%r13d
	jmp L138
L137:
	cmpl $-1,%r13d
	movl $6,%eax
	cmovzl %eax,%r13d
L138:
	ucomisd L129(%rip),%xmm1
	jae L151
L150:
	movsd L188(%rip),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,-8(%rbp)
	movl $-1,(%r9)
	jmp L152
L151:
	movl $1,(%r9)
L152:
	leaq -28(%rbp),%r8
	leaq -12(%rbp),%rcx
	movl %r13d,%edx
	leaq -8(%rbp),%rsi
	movl %r14d,%edi
	call _dtoa
	cmpl $101,%r14d
	jz L154
L157:
	cmpl $69,%r14d
	jz L154
L153:
	cmpl $103,%r14d
	jz L161
L165:
	cmpl $71,%r14d
	jnz L155
L161:
	movl -12(%rbp),%eax
	cmpl $-4,%eax
	jl L154
L169:
	cmpl %eax,%r13d
	jg L155
L154:
	movl $1,%r12d
	jmp L156
L155:
	xorl %r12d,%r12d
L156:
	testl %r12d,%r12d
	jz L174
L173:
	xorl %ecx,%ecx
	jmp L175
L174:
	movl -12(%rbp),%ecx
L175:
	movl %ebx,%r9d
	movl %r14d,%r8d
	movl %r13d,%edx
	leaq -28(%rbp),%rsi
	movq %r15,%rdi
	call _dtof
	movq %rax,%rbx
	movq %rbx,%rax
	testl %r12d,%r12d
	jz L135
L176:
	cmpl $69,%r14d
	jz L179
L182:
	cmpl $71,%r14d
	jnz L180
L179:
	movl $69,%eax
	jmp L181
L180:
	movl $101,%eax
L181:
	movb %al,(%rbx)
	leaq 1(%rbx),%rax
	movl -12(%rbp),%ecx
	pushq %rcx
	pushq $L186
	pushq %rax
	call _sprintf
	addq $24,%rsp
	movslq %eax,%rax
	leaq 1(%rbx,%rax),%rax
L135:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L186:
	.byte 37,43,48,51,100,0

.globl _sprintf
.globl ___pow10
.globl _frexp
.globl ___dtefg
.globl _modf
