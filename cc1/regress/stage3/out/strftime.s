.data
.align 8
_weekdays:
	.quad L1
	.quad L2
	.quad L3
	.quad L4
	.quad L5
	.quad L6
	.quad L7
.align 8
_months:
	.quad L8
	.quad L9
	.quad L10
	.quad L11
	.quad L12
	.quad L13
	.quad L14
	.quad L15
	.quad L16
	.quad L17
	.quad L18
	.quad L19
.local L23
.comm L23, 6, 1
.text

_toasc:
L20:
L21:
	movl $L23+5,%r8d
	movb $0,L23+5(%rip)
L24:
	movl %esi,%eax
	decl %esi
	testl %eax,%eax
	jz L26
L25:
	movl $10,%ecx
	movl %edi,%eax
	cltd 
	idivl %ecx
	addb $48,%dl
	leaq -1(%r8),%rax
	movb %dl,-1(%r8)
	movq %rax,%r8
	movl $10,%ecx
	movl %edi,%eax
	cltd 
	idivl %ecx
	movl %eax,%edi
	jmp L24
L26:
	movq %r8,%rax
L22:
	ret 

.local L31
.comm L31, 8, 1

_convert:
L28:
L29:
	movl %edx,%r9d
	movl $10,%r8d
	movl %edi,%eax
	cltd 
	idivl %r8d
	addb $48,%al
	movb %al,L31(%rip)
	movl $10,%r8d
	movl %edi,%eax
	cltd 
	idivl %r8d
	addb $48,%dl
	movb %dl,L31+1(%rip)
	movb %cl,L31+2(%rip)
	movl $10,%edi
	movl %esi,%eax
	cltd 
	idivl %edi
	addb $48,%al
	movb %al,L31+3(%rip)
	movl $10,%edi
	movl %esi,%eax
	cltd 
	idivl %edi
	addb $48,%dl
	movb %dl,L31+4(%rip)
	movb %cl,L31+5(%rip)
	movl $10,%ecx
	movl %r9d,%eax
	cltd 
	idivl %ecx
	addb $48,%al
	movb %al,L31+6(%rip)
	movl $10,%ecx
	movl %r9d,%eax
	cltd 
	idivl %ecx
	addb $48,%dl
	movb %dl,L31+7(%rip)
	movl $L31,%eax
L30:
	ret 

.align 2
L135:
	.short L90-_strftime
	.short L51-_strftime
	.short L92-_strftime
	.short L51-_strftime
	.short L99-_strftime
	.short L103-_strftime
	.short L107-_strftime
.align 1
L139:
	.byte 37
	.byte 65
	.byte 66
	.byte 72
	.byte 73
	.byte 77
	.byte 109
	.byte 112
	.byte 119
	.byte 120
	.byte 121
	.byte 122
.align 2
L140:
	.short L51-_strftime
	.short L55-_strftime
	.short L61-_strftime
	.short L70-_strftime
	.short L72-_strftime
	.short L81-_strftime
	.short L79-_strftime
	.short L83-_strftime
	.short L94-_strftime
	.short L101-_strftime
	.short L105-_strftime
	.short L109-_strftime
.align 2
L141:
	.short L55-_strftime
	.short L61-_strftime
	.short L66-_strftime
	.short L68-_strftime
	.short L51-_strftime
	.short L51-_strftime
	.short L51-_strftime
	.short L51-_strftime
	.short L51-_strftime
	.short L77-_strftime

_strftime:
L33:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L34:
	movq %rdi,-32(%rbp)
	movq %rsi,-16(%rbp)
	movq %rdx,-40(%rbp)
	movq %rcx,%r15
	xorl %r14d,%r14d
L36:
	movq -40(%rbp),%rax
	movb (%rax),%dl
	incq %rax
	movq %rax,-40(%rbp)
	leaq -1(%rbp),%rax
	movq %rax,-24(%rbp)
	movb %dl,-1(%rbp)
	cmpb $37,%dl
	jz L41
L40:
	incq %r14
	cmpq %r14,-16(%rbp)
	jb L126
L45:
	movq -32(%rbp),%rax
	movq %rax,%rcx
	incq %rax
	movq %rax,-32(%rbp)
	movb %dl,(%rcx)
	cmpb $0,-1(%rbp)
	jnz L36
L47:
	leaq -1(%r14),%rax
	jmp L35
L41:
	xorl %r13d,%r13d
	movq -40(%rbp),%rax
	movb (%rax),%cl
	incq %rax
	movq %rax,-40(%rbp)
	movb %cl,-1(%rbp)
	cmpb $83,%cl
	jl L128
L130:
	cmpb $89,%cl
	jg L128
L127:
	addb $-83,%cl
	movzbl %cl,%eax
	movzwl L135(,%rax,2),%eax
	addl $_strftime,%eax
	jmp *%rax
L107:
	movl 20(%r15),%ebx
	addl $1900,%ebx
	movl $4,%r12d
	jmp L52
L103:
	movl 8(%r15),%edi
	movl 4(%r15),%esi
	movl $58,%ecx
	movl (%r15),%edx
	jmp L144
L99:
	movl 24(%r15),%ebx
	jmp L124
L92:
	movl 28(%r15),%eax
	addl $7,%eax
	subl 24(%r15),%eax
	movl $7,%ecx
	cltd 
	idivl %ecx
	movl %eax,%ebx
	jmp L123
L90:
	movl (%r15),%ebx
	jmp L123
L128:
	cmpb $97,%cl
	jl L132
L134:
	cmpb $106,%cl
	jg L132
L131:
	leal -97(%rcx),%eax
	movzbl %al,%eax
	movzwl L141(,%rax,2),%eax
	addl $_strftime,%eax
	jmp *%rax
L77:
	movl 28(%r15),%ebx
	incl %ebx
	jmp L142
L68:
	movl 12(%r15),%ebx
	jmp L123
L66:
	movq %r15,%rdi
	call _asctime
	movq %rax,%r13
	movl $24,%r12d
	jmp L52
L132:
	xorl %eax,%eax
L136:
	cmpb L139(,%rax),%cl
	jz L137
L138:
	incl %eax
	cmpl $12,%eax
	jb L136
	jae L51
L137:
	movzwl L140(,%rax,2),%eax
	addl $_strftime,%eax
	jmp *%rax
L109:
	cmpl $1,32(%r15)
	movl $0,%eax
	movl $1,%ecx
	cmovnzl %eax,%ecx
	movslq %ecx,%rcx
	movq _tzname(,%rcx,8),%r13
	movq %r13,%rdi
	jmp L143
L105:
	movl 20(%r15),%ebx
	jmp L123
L101:
	movl 16(%r15),%edi
	movl 12(%r15),%esi
	movl $47,%ecx
	movl 20(%r15),%edx
	incl %edi
L144:
	call _convert
	movq %rax,%r13
	movl $8,%r12d
	jmp L52
L94:
	movl 28(%r15),%eax
	addl $8,%eax
	movl 24(%r15),%esi
	subl %esi,%eax
	movl $7,%ecx
	cltd 
	idivl %ecx
	movl %eax,%ebx
	testl %esi,%esi
	jnz L123
L95:
	leal -1(%rax),%ebx
	jmp L123
L83:
	cmpl $12,8(%r15)
	movl $L85,%eax
	movl $L84,%r13d
	cmovgeq %rax,%r13
	jmp L123
L79:
	movl 16(%r15),%ebx
	incl %ebx
	jmp L123
L81:
	movl 4(%r15),%ebx
	jmp L123
L72:
	movl $12,%ecx
	movl 8(%r15),%eax
	cltd 
	idivl %ecx
	movl %edx,%ebx
	testl %edx,%edx
	movl $12,%eax
	cmovzl %eax,%ebx
	jmp L123
L70:
	movl 8(%r15),%ebx
L123:
	movl $2,%r12d
	jmp L52
L61:
	movslq 16(%r15),%rax
	movq _months(,%rax,8),%rdi
	movq %rdi,%r13
	cmpb $98,%cl
	jnz L143
	jz L142
L55:
	movslq 24(%r15),%rax
	movq _weekdays(,%rax,8),%rdi
	movq %rdi,%r13
	cmpb $97,%cl
	jnz L143
L142:
	movl $3,%r12d
	jmp L52
L143:
	call _strlen
	movq %rax,%r12
	jmp L52
L51:
	movq -24(%rbp),%r13
L124:
	movl $1,%r12d
L52:
	testq %r13,%r13
	jnz L118
L116:
	movl %r12d,%esi
	movl %ebx,%edi
	call _toasc
	movq %rax,%r13
L118:
	addq %r12,%r14
	cmpq %r14,-16(%rbp)
	jbe L126
L121:
	movq %r12,%rdx
	movq %r13,%rsi
	movq -32(%rbp),%rdi
	call _strncpy
	addq %r12,-32(%rbp)
	jmp L36
L126:
	xorl %eax,%eax
L35:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L18:
	.byte 78,111,118,101,109,98,101,114
	.byte 0
L19:
	.byte 68,101,99,101,109,98,101,114
	.byte 0
L8:
	.byte 74,97,110,117,97,114,121,0
L1:
	.byte 83,117,110,100,97,121,0
L85:
	.byte 80,77,0
L4:
	.byte 87,101,100,110,101,115,100,97
	.byte 121,0
L17:
	.byte 79,99,116,111,98,101,114,0
L11:
	.byte 65,112,114,105,108,0
L9:
	.byte 70,101,98,114,117,97,114,121
	.byte 0
L13:
	.byte 74,117,110,101,0
L2:
	.byte 77,111,110,100,97,121,0
L12:
	.byte 77,97,121,0
L10:
	.byte 77,97,114,99,104,0
L3:
	.byte 84,117,101,115,100,97,121,0
L5:
	.byte 84,104,117,114,115,100,97,121
	.byte 0
L16:
	.byte 83,101,112,116,101,109,98,101
	.byte 114,0
L7:
	.byte 83,97,116,117,114,100,97,121
	.byte 0
L15:
	.byte 65,117,103,117,115,116,0
L14:
	.byte 74,117,108,121,0
L84:
	.byte 65,77,0
L6:
	.byte 70,114,105,100,97,121,0

.globl _strncpy
.globl _asctime
.globl _tzname
.globl _strlen
.globl _strftime
