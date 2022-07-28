.text

_vstring_clear:
L1:
L2:
	movl (%rdi),%eax
	testl $1,%eax
	jz L5
L4:
	andl $-255,%eax
	movl %eax,(%rdi)
	movb $0,1(%rdi)
	ret
L5:
	movq $0,8(%rdi)
	movq 16(%rdi),%rax
	movb $0,(%rax)
L3:
	ret 


_vstring_init:
L7:
L8:
	movl (%rdi),%eax
	andl $-2,%eax
	orl $1,%eax
	andl $-255,%eax
	movl %eax,(%rdi)
	movb $0,1(%rdi)
L9:
	ret 


_vstring_free:
L10:
L11:
	testl $1,(%rdi)
	jnz L12
L13:
	movq 16(%rdi),%rdi
	call _free
L12:
	ret 


_vstring_rubout:
L16:
	pushq %rbx
L17:
	movq %rdi,%rbx
	movl (%rbx),%eax
	testl $1,%eax
	jz L23
L22:
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	jmp L24
L23:
	movq 8(%rbx),%rax
L24:
	testq %rax,%rax
	jnz L21
L19:
	pushq $L25
	call _error
	addq $8,%rsp
L21:
	movl (%rbx),%ecx
	testl $1,%ecx
	jz L27
L26:
	movl %ecx,%eax
	shll $24,%eax
	sarl $25,%eax
	decl %eax
	andl $127,%eax
	shll $1,%eax
	andl $-255,%ecx
	orl %eax,%ecx
	movl %ecx,(%rbx)
	jmp L18
L27:
	decq 8(%rbx)
L18:
	popq %rbx
	ret 


_vstring_last:
L29:
L30:
	movl (%rdi),%eax
	movl %eax,%edx
	andl $1,%edx
	jz L36
L35:
	movl %eax,%ecx
	shll $24,%ecx
	sarl $25,%ecx
	movslq %ecx,%rcx
	jmp L37
L36:
	movq 8(%rdi),%rcx
L37:
	testq %rcx,%rcx
	jz L32
L34:
	testl %edx,%edx
	jz L40
L39:
	shll $24,%eax
	sarl $25,%eax
	decl %eax
	movslq %eax,%rax
	movb 1(%rdi,%rax),%al
	ret
L40:
	movq 16(%rdi),%rcx
	movq 8(%rdi),%rax
	movb -1(%rcx,%rax),%al
	ret
L32:
	xorl %eax,%eax
L31:
	ret 


_vstring_put:
L44:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L45:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %rdx,%r13
	movl (%r15),%eax
	testl $1,%eax
	jz L48
L47:
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	jmp L49
L48:
	movq 8(%r15),%rax
L49:
	leaq 1(%r13,%rax),%r12
	cmpq %r12,%r13
	jbe L52
L50:
	pushq $L53
	call _error
	addq $8,%rsp
L52:
	testl $1,(%r15)
	jz L58
L57:
	movl $23,%eax
	jmp L59
L58:
	movq (%r15),%rax
L59:
	cmpq %rax,%r12
	jbe L56
L54:
	movl $32,%ebx
L63:
	cmpq %rbx,%r12
	jbe L62
L61:
	shlq $1,%rbx
	jnz L63
L62:
	testq %rbx,%rbx
	jnz L69
L67:
	pushq $L53
	call _error
	addq $8,%rsp
L69:
	movq %rbx,%rdi
	call _safe_malloc
	movq %rax,%r12
	movl (%r15),%edx
	testl $1,%edx
	jz L71
L70:
	shll $24,%edx
	sarl $25,%edx
	movslq %edx,%rdx
	leaq 1(%r15),%rsi
	movq %r12,%rdi
	call _memcpy
	movl (%r15),%eax
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	movq %rax,8(%r15)
	jmp L72
L71:
	movq 16(%r15),%rsi
	movq 8(%r15),%rdx
	movq %r12,%rdi
	call _memcpy
	movq 16(%r15),%rdi
	call _free
L72:
	movq %rbx,(%r15)
	movq %r12,16(%r15)
L56:
	movl (%r15),%eax
	testl $1,%eax
	jz L74
L73:
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	movq %r13,%rdx
	movq %r14,%rsi
	leaq 1(%r15,%rax),%rdi
	call _memcpy
	movl (%r15),%eax
	movl %eax,%ecx
	shll $24,%ecx
	sarl $25,%ecx
	addl %ecx,%r13d
	andl $127,%r13d
	shll $1,%r13d
	andl $-255,%eax
	orl %r13d,%eax
	movl %eax,(%r15)
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	movb $0,1(%r15,%rax)
	jmp L46
L74:
	movq 16(%r15),%rdi
	movq %r13,%rdx
	movq %r14,%rsi
	addq 8(%r15),%rdi
	call _memcpy
	movq 8(%r15),%rcx
	addq %r13,%rcx
	movq %rcx,8(%r15)
	movq 16(%r15),%rax
	movb $0,(%rcx,%rax)
L46:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_vstring_putc:
L76:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L77:
	movb %sil,-1(%rbp)
	movl (%rdi),%ecx
	movl %ecx,%esi
	andl $1,%esi
	jz L83
L82:
	movl %ecx,%edx
	shll $24,%edx
	sarl $25,%edx
	movslq %edx,%rdx
	jmp L84
L83:
	movq 8(%rdi),%rdx
L84:
	testl %esi,%esi
	jz L86
L85:
	movl $23,%eax
	jmp L87
L86:
	movq (%rdi),%rax
L87:
	subq $2,%rax
	cmpq %rax,%rdx
	ja L80
L79:
	testl %esi,%esi
	jz L89
L88:
	movl %ecx,%eax
	shll $24,%eax
	sarl $25,%eax
	leal 1(%rax),%edx
	andl $127,%edx
	shll $1,%edx
	andl $-255,%ecx
	orl %edx,%ecx
	movl %ecx,(%rdi)
	movslq %eax,%rax
	movb -1(%rbp),%cl
	movb %cl,1(%rdi,%rax)
	movl (%rdi),%eax
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	movb $0,1(%rdi,%rax)
	jmp L78
L89:
	movq 16(%rdi),%rdx
	movq 8(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,8(%rdi)
	movb -1(%rbp),%al
	movb %al,(%rdx,%rcx)
	movq 16(%rdi),%rcx
	movq 8(%rdi),%rax
	movb $0,(%rcx,%rax)
	jmp L78
L80:
	movl $1,%edx
	leaq -1(%rbp),%rsi
	call _vstring_put
L78:
	movq %rbp,%rsp
	popq %rbp
	ret 


_vstring_concat:
L91:
L92:
	movq %rsi,%rcx
	movl (%rcx),%edx
	movl %edx,%eax
	andl $1,%eax
	jz L95
L94:
	leaq 1(%rcx),%rsi
	jmp L96
L95:
	movq 16(%rcx),%rsi
L96:
	testl %eax,%eax
	jz L98
L97:
	shll $24,%edx
	sarl $25,%edx
	movslq %edx,%rdx
	jmp L99
L98:
	movq 8(%rcx),%rdx
L99:
	call _vstring_put
L93:
	ret 


_vstring_puts:
L100:
	pushq %rbx
	pushq %r12
L101:
	movq %rdi,%r12
	movq %rsi,%rbx
	movq %rbx,%rdi
	call _strlen
	movq %rax,%rdx
	movq %rbx,%rsi
	movq %r12,%rdi
	call _vstring_put
L102:
	popq %r12
	popq %rbx
	ret 


_vstring_same:
L103:
L104:
	movq %rdi,%r9
	movl (%r9),%edx
	movl %edx,%r8d
	andl $1,%r8d
	jz L114
L113:
	movl %edx,%edi
	shll $24,%edi
	sarl $25,%edi
	movslq %edi,%rdi
	jmp L115
L114:
	movq 8(%r9),%rdi
L115:
	movl (%rsi),%eax
	movl %eax,%ecx
	andl $1,%ecx
	jz L117
L116:
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	jmp L118
L117:
	movq 8(%rsi),%rax
L118:
	cmpq %rax,%rdi
	jnz L107
L109:
	testl %r8d,%r8d
	jz L120
L119:
	leaq 1(%r9),%rdi
	jmp L121
L120:
	movq 16(%r9),%rdi
L121:
	testl %ecx,%ecx
	jz L123
L122:
	incq %rsi
	jmp L124
L123:
	movq 16(%rsi),%rsi
L124:
	testl %r8d,%r8d
	jz L126
L125:
	shll $24,%edx
	sarl $25,%edx
	movslq %edx,%rdx
	jmp L127
L126:
	movq 8(%r9),%rdx
L127:
	call _memcmp
	testl %eax,%eax
	jnz L107
L106:
	movl $1,%eax
	ret
L107:
	xorl %eax,%eax
L105:
	ret 

L53:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,118,115
 .byte 116,114,105,110,103,32,111,118
 .byte 101,114,102,108,111,119,0
L25:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,118,115
 .byte 116,114,105,110,103,32,117,110
 .byte 100,101,114,102,108,111,119,0

.globl _free
.globl _memcpy
.globl _vstring_init
.globl _vstring_same
.globl _vstring_putc
.globl _error
.globl _vstring_concat
.globl _safe_malloc
.globl _memcmp
.globl _vstring_puts
.globl _vstring_clear
.globl _vstring_free
.globl _vstring_last
.globl _vstring_put
.globl _strlen
.globl _vstring_rubout
