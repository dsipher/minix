.text

___strtoul:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movl %edx,%r14d
	movq %rdi,%r13
	movl $0,-8(%rbp)
	xorl %r12d,%r12d
	xorl %eax,%eax
	xorl %ebx,%ebx
L4:
	movsbl (%r13),%r8d
	leaq 1(%r13),%r9
	movq %r9,%r13
	movl %r8d,%r11d
	movslq %r8d,%rdx
	testb $8,___ctype+1(%rdx)
	jnz L4
L6:
	cmpl $45,%r8d
	jz L10
L131:
	cmpl $43,%r8d
	jz L11
	jnz L8
L10:
	movl $1,-8(%rbp)
L11:
	movsbl (%r9),%edx
	incq %r9
	movq %r9,%r13
	movl %edx,%r11d
L8:
	testl %r14d,%r14d
	jnz L14
L12:
	cmpl $48,%r11d
	jnz L16
L15:
	movzbl (%r13),%edx
	cmpb $120,%dl
	jz L22
L21:
	cmpb $88,%dl
	jnz L23
L22:
	movl $16,%edx
	jmp L20
L23:
	movl $8,%edx
L20:
	movl %edx,%r14d
L14:
	cmpl $16,%r14d
	jnz L32
L37:
	cmpl $48,%r11d
	jnz L32
L38:
	movzbl (%r13),%edx
	cmpb $120,%dl
	jz L42
L41:
	cmpb $88,%dl
	jnz L32
L42:
	movl $1,%eax
	movsbl 1(%r13),%edx
	leaq 2(%r13),%r8
	movq %r8,%r13
	movl %edx,%r11d
	jmp L32
L16:
	movl %r11d,%edx
	subl $48,%edx
	cmpl $10,%edx
	jae L28
L25:
	movl $10,%r14d
L32:
	leal 48(%r14),%r10d
	leal 55(%r14),%r9d
	leal 87(%r14),%r8d
	movl %r11d,%edx
	subl $48,%edx
	cmpl $10,%edx
	jae L58
L56:
	cmpl %r10d,%r11d
	jl L49
L58:
	movl %r11d,%edx
	subl $65,%edx
	cmpl $26,%edx
	jae L62
L60:
	cmpl %r9d,%r11d
	jl L49
L62:
	movl %r11d,%edx
	subl $97,%edx
	cmpl $26,%edx
	jae L66
L64:
	cmpl %r8d,%r11d
	jge L66
L49:
	testl %ecx,%ecx
	jz L73
L72:
	movslq %r14d,%rdi
	movq $-1,%rax
	xorl %edx,%edx
	divq %rdi
	movq %rax,%r15
	movq $-1,%rax
	xorl %edx,%edx
	divq %rdi
	movq %rdx,%rax
	jmp L75
L73:
	movslq %r14d,%rdi
	movq $9223372036854775807,%rax
	cqto 
	idivq %rdi
	movq %rax,%r15
	movq $9223372036854775807,%rax
	cqto 
	idivq %rdi
	movq %rdx,%rax
L75:
	movl %r11d,%edx
	subl $48,%edx
	cmpl $10,%edx
	jae L84
L82:
	cmpl %r10d,%r11d
	jl L81
L84:
	movl %r11d,%edx
	subl $65,%edx
	cmpl $26,%edx
	jae L91
L89:
	cmpl %r9d,%r11d
	jge L91
L90:
	movl %r11d,%edx
	subl $55,%edx
	jmp L81
L91:
	movl %r11d,%edx
	subl $97,%edx
	cmpl $26,%edx
	jae L98
L96:
	cmpl %r8d,%r11d
	jge L98
L97:
	movl %r11d,%edx
	subl $87,%edx
L81:
	cmpq %r15,%rbx
	jb L105
	ja L110
L108:
	movslq %edx,%rdi
	cmpq %rdi,%rax
	jae L105
L110:
	leal 1(%r12),%edx
	movl %edx,%r12d
	jmp L103
L105:
	movslq %r14d,%rdi
	movq %rbx,%r11
	imulq %rdi,%r11
	movslq %edx,%rdx
	addq %rdx,%r11
	movq %r11,%rbx
L103:
	movsbl (%r13),%edx
	leaq 1(%r13),%rdi
	movq %rdi,%r13
	movl %edx,%r11d
	jmp L75
L98:
	leaq -1(%r13),%rdi
	jmp L28
L66:
	testl %eax,%eax
	jz L28
L68:
	movq %r13,%rdi
	subq $2,%rdi
L28:
	testq %rsi,%rsi
	jz L114
L112:
	movq %rdi,(%rsi)
L114:
	testl %r12d,%r12d
	jnz L115
L117:
	cmpl $0,-8(%rbp)
	jz L127
L126:
	movq %rbx,%rax
	negq %rax
	jmp L3
L127:
	movq %rbx,%rax
	jmp L3
L115:
	movl $34,_errno(%rip)
	testl %ecx,%ecx
	jnz L118
L120:
	cmpl $0,-8(%rbp)
	jz L123
L122:
	movq $-9223372036854775808,%rax
	jmp L3
L123:
	movq $9223372036854775807,%rax
	jmp L3
L118:
	movq $-1,%rax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_strtol:
L134:
L135:
	xorl %ecx,%ecx
	call ___strtoul
L136:
	ret 


_strtoul:
L138:
L139:
	movl $1,%ecx
	call ___strtoul
L140:
	ret 


.globl _errno
.globl _strtoul
.globl _strtol
.globl ___ctype
