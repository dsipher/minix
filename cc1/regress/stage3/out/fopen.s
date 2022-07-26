.text

_fopen:
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
	xorl %r13d,%r13d
	xorl %ebx,%ebx
L4:
	movslq %ebx,%rax
	cmpq $0,___iotab(,%rax,8)
	jz L7
L5:
	cmpl $19,%ebx
	jge L64
L10:
	incl %ebx
	jmp L4
L7:
	movzbl (%rsi),%eax
	incq %rsi
	cmpb $114,%al
	jz L15
L66:
	cmpb $119,%al
	jz L17
L67:
	cmpb $97,%al
	jnz L64
L19:
	movl $770,%r14d
	movl $1,%r15d
	movl $1088,%r13d
	jmp L22
L17:
	movl $258,%r14d
	movl $1,%r15d
	movl $576,%r13d
	jmp L22
L15:
	movl $129,%r14d
	xorl %r15d,%r15d
L22:
	movzbl (%rsi),%eax
	testb %al,%al
	jz L24
L23:
	incq %rsi
	cmpb $98,%al
	jz L22
L71:
	cmpb $43,%al
	jnz L24
L30:
	movl $2,%r15d
	orl $3,%r14d
	jmp L22
L24:
	testl $512,%r13d
	jnz L38
L37:
	pushq %r15
	pushq -8(%rbp)
	call _open
	addq $16,%rsp
	movl %eax,%r12d
	cmpl $0,%eax
	jge L36
L41:
	testl $64,%r13d
	jz L36
L38:
	movl $438,%esi
	movq -8(%rbp),%rdi
	call _creat
	movl %eax,%edi
	movl %edi,%r12d
	cmpl $0,%edi
	jle L36
L48:
	movl %r14d,%eax
	orl $1,%eax
	jz L36
L49:
	call _close
	pushq %r15
	pushq -8(%rbp)
	call _open
	addq $16,%rsp
	movl %eax,%r12d
L36:
	cmpl $0,%r12d
	jl L64
L54:
	movl $32,%edi
	call _malloc
	testq %rax,%rax
	jz L56
L58:
	movl %r14d,%ecx
	andl $3,%ecx
	cmpl $3,%ecx
	jnz L62
L60:
	andl $-385,%r14d
L62:
	movl $0,(%rax)
	movl %r12d,4(%rax)
	movl %r14d,8(%rax)
	movq $0,16(%rax)
	movslq %ebx,%rbx
	movq %rax,___iotab(,%rbx,8)
	jmp L3
L56:
	movl %r12d,%edi
	call _close
L64:
	xorl %eax,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _close
.globl _fopen
.globl _malloc
.globl _creat
.globl _open
.globl ___iotab
