.text

___strtoul:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rsi,%r8
	movl %edx,%esi
	movl %ecx,%r15d
	movq %rdi,%r14
	xorl %r13d,%r13d
	xorl %r12d,%r12d
	xorl %eax,%eax
	xorl %ebx,%ebx
L4:
	movsbl (%r14),%ecx
	leaq 1(%r14),%rdx
	movq %rdx,%r14
	movl %ecx,%r11d
	movslq %ecx,%rcx
	testb $8,___ctype+1(%rcx)
	jnz L4
L6:
	cmpl $45,%ecx
	jz L10
L131:
	cmpl $43,%ecx
	jz L11
	jnz L8
L10:
	movl $1,%r13d
L11:
	movsbl (%rdx),%ecx
	incq %rdx
	movq %rdx,%r14
	movl %ecx,%r11d
L8:
	testl %esi,%esi
	jnz L14
L12:
	cmpl $48,%r11d
	jnz L16
L15:
	movb (%r14),%cl
	cmpb $120,%cl
	jz L22
L21:
	cmpb $88,%cl
	jnz L23
L22:
	movl $16,%ecx
	jmp L20
L23:
	movl $8,%ecx
L20:
	movl %ecx,%esi
L14:
	cmpl $16,%esi
	jnz L32
L37:
	cmpl $48,%r11d
	jnz L32
L38:
	movb (%r14),%cl
	cmpb $120,%cl
	jz L42
L41:
	cmpb $88,%cl
	jnz L32
L42:
	movl $1,%eax
	movsbl 1(%r14),%ecx
	leaq 2(%r14),%rdx
	movq %rdx,%r14
	movl %ecx,%r11d
	jmp L32
L16:
	movl %r11d,%ecx
	subl $48,%ecx
	cmpl $10,%ecx
	jae L28
L25:
	movl $10,%esi
L32:
	leal 48(%rsi),%r10d
	leal 55(%rsi),%r9d
	leal 87(%rsi),%ecx
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
	cmpl %ecx,%r11d
	jge L66
L49:
	testl %r15d,%r15d
	jz L73
L72:
	movslq %esi,%rsi
	movq $-1,%rax
	xorl %edx,%edx
	divq %rsi
	movq %rax,%rdi
	movq $-1,%rax
	xorl %edx,%edx
	divq %rsi
	jmp L134
L73:
	movslq %esi,%rsi
	movq $9223372036854775807,%rax
	cqto 
	idivq %rsi
	movq %rax,%rdi
	movq $9223372036854775807,%rax
	cqto 
	idivq %rsi
L134:
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
	cmpl %ecx,%r11d
	jge L98
L97:
	movl %r11d,%edx
	subl $87,%edx
L81:
	cmpq %rdi,%rbx
	jb L105
	ja L110
L108:
	movslq %edx,%rdx
	cmpq %rdx,%rax
	jae L105
L110:
	leal 1(%r12),%edx
	movl %edx,%r12d
	jmp L103
L105:
	movslq %esi,%rsi
	movq %rbx,%r11
	imulq %rsi,%r11
	movslq %edx,%rdx
	addq %rdx,%r11
	movq %r11,%rbx
L103:
	movsbl (%r14),%edx
	leaq 1(%r14),%r11
	movq %r11,%r14
	movl %edx,%r11d
	jmp L75
L98:
	leaq -1(%r14),%rdi
	jmp L28
L66:
	testl %eax,%eax
	jz L28
L68:
	movq %r14,%rdi
	subq $2,%rdi
L28:
	testq %r8,%r8
	jz L114
L112:
	movq %rdi,(%r8)
L114:
	testl %r12d,%r12d
	jnz L115
L117:
	testl %r13d,%r13d
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
	testl %r15d,%r15d
	jnz L118
L120:
	testl %r13d,%r13d
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
	ret 


_strtol:
L135:
L136:
	xorl %ecx,%ecx
	call ___strtoul
L137:
	ret 


_strtoul:
L139:
L140:
	movl $1,%ecx
	call ___strtoul
L141:
	ret 


.globl _errno
.globl _strtoul
.globl _strtol
.globl ___ctype
