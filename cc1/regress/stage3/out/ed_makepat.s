.text

_makepat:
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
	movq %rdi,-8(%rbp)
	movl %esi,%r15d
	movb (%rdi),%al
	testb %al,%al
	jz L112
L15:
	movsbl %al,%eax
	cmpl %eax,%r15d
	jz L112
L11:
	cmpb $10,%al
	jz L112
L7:
	cmpb $42,%al
	jz L112
L6:
	xorl %r14d,%r14d
	xorl %r13d,%r13d
	xorl %r12d,%r12d
L20:
	movq -8(%rbp),%rax
	movb (%rax),%al
	testb %al,%al
	jz L22
L31:
	movsbl %al,%eax
	cmpl %eax,%r15d
	jz L22
L27:
	cmpb $10,%al
	jz L22
L23:
	testl %r14d,%r14d
	jnz L22
L21:
	movl $24,%edi
	call _malloc
	movq %rax,%rbx
	movb $0,1(%rbx)
	movq $0,16(%rbx)
	movq -8(%rbp),%rcx
	movb (%rcx),%al
	cmpb $36,%al
	jz L45
L119:
	cmpb $42,%al
	jz L58
L120:
	cmpb $46,%al
	jz L38
L121:
	cmpb $91,%al
	jz L70
L122:
	cmpb $94,%al
	jz L40
L123:
	cmpb $92,%al
	jnz L80
L82:
	cmpb $40,1(%rcx)
	jnz L80
L79:
	movb $40,(%rbx)
	jmp L126
L80:
	cmpb $92,%al
	jnz L87
L89:
	cmpb $41,1(%rcx)
	jnz L87
L86:
	movb $41,(%rbx)
L126:
	movq -8(%rbp),%rax
	incq %rax
	jmp L125
L87:
	movb $76,(%rbx)
	leaq -8(%rbp),%rdi
	call _esc
	movb %al,1(%rbx)
	jmp L36
L40:
	testq %r13,%r13
	jnz L42
L41:
	movb $94,(%rbx)
	jmp L43
L42:
	movb $76,(%rbx)
L43:
	movb $94,1(%rbx)
	jmp L36
L70:
	cmpb $94,1(%rcx)
	jnz L72
L71:
	movb $33,(%rbx)
	movq -8(%rbp),%rax
	addq $2,%rax
	jmp L127
L72:
	movb $91,(%rbx)
	movq -8(%rbp),%rax
	incq %rax
L127:
	movq %rax,-8(%rbp)
	movl $128,%edi
	call _makebitmap
	movq %rax,%rdx
	movq %rdx,8(%rbx)
	testq %rdx,%rdx
	jz L75
L74:
	movq -8(%rbp),%rsi
	movl $93,%edi
	call _dodash
L125:
	movq %rax,-8(%rbp)
	jmp L36
L75:
	pushq $L77
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L93
L38:
	movb $46,(%rbx)
	jmp L36
L58:
	testq %r13,%r13
	jz L36
L59:
	movb (%r12),%al
	cmpb $94,%al
	jz L112
L114:
	cmpb $36,%al
	jz L112
L115:
	cmpb $42,%al
	jz L112
L116:
	movb $42,(%rbx)
	jmp L36
L45:
	movsbl 1(%rcx),%eax
	cmpl %eax,%r15d
	jz L46
L53:
	testb %al,%al
	jz L46
L49:
	cmpb $10,%al
	jnz L47
L46:
	movb $36,(%rbx)
	jmp L36
L47:
	movb $76,(%rbx)
	movb $36,1(%rbx)
L36:
	testl %r14d,%r14d
	jnz L93
L96:
	testq %rbx,%rbx
	jz L93
L94:
	testq %r13,%r13
	jnz L102
L101:
	movq $0,16(%rbx)
	movq %rbx,%r12
	jmp L111
L102:
	cmpb $42,(%rbx)
	jz L105
L104:
	movq %rbx,16(%r12)
	movq %r12,16(%rbx)
	movq %rbx,%r12
	jmp L95
L105:
	cmpq %r12,%r13
	jz L108
L107:
	movq 16(%r12),%rax
	movq %rbx,16(%rax)
	movq %r12,16(%rbx)
	jmp L95
L108:
	movq %r13,16(%rbx)
	movq %rbx,16(%r12)
L111:
	movq %rbx,%r13
L95:
	incq -8(%rbp)
	jmp L20
L93:
	movq %r13,%rdi
	call _unmakepat
L112:
	xorl %eax,%eax
	jmp L3
L22:
	movq $0,16(%r12)
	movq %r13,%rax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L77:
	.byte 78,111,116,32,101,110,111,117
	.byte 103,104,32,109,101,109,111,114
	.byte 121,32,102,111,114,32,112,97
	.byte 116,10,0

.globl _makepat
.globl _unmakepat
.globl _malloc
.globl _esc
.globl _dodash
.globl ___stderr
.globl _makebitmap
.globl _fprintf
