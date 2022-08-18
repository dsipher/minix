.text

_freopen:
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
	movq %rsi,%r15
	movq %rdx,%r14
	xorl %ebx,%ebx
	movl 8(%r14),%r12d
	andl $76,%r12d
	movq %r14,%rdi
	call _fflush
	movl 4(%r14),%edi
	call _close
	movb (%r15),%al
	incq %r15
	cmpb $114,%al
	jz L7
L70:
	cmpb $119,%al
	jz L9
L71:
	cmpb $97,%al
	jnz L68
L11:
	orl $514,%r12d
	movl $1,%r13d
	movl $1088,%ebx
	jmp L14
L9:
	orl $2,%r12d
	movl $1,%r13d
	movl $576,%ebx
	jmp L14
L7:
	orl $1,%r12d
	xorl %r13d,%r13d
L14:
	movb (%r15),%al
	testb %al,%al
	jz L16
L15:
	incq %r15
	cmpb $98,%al
	jz L14
L75:
	cmpb $43,%al
	jnz L16
L22:
	movl $2,%r13d
	orl $3,%r12d
	jmp L14
L16:
	testl $512,%ebx
	jnz L30
L29:
	pushq %r13
	pushq -8(%rbp)
	call _open
	addq $16,%rsp
	cmpl $0,%eax
	jge L28
L33:
	testl $64,%ebx
	jz L28
L30:
	movl $438,%esi
	movq -8(%rbp),%rdi
	call _creat
	movl %eax,%edi
	movl %edi,%eax
	cmpl $0,%edi
	jge L28
L40:
	movl %r12d,%ecx
	orl $1,%ecx
	jz L28
L41:
	call _close
	pushq %r13
	pushq -8(%rbp)
	call _open
	addq $16,%rsp
L28:
	cmpl $0,%eax
	jl L44
L46:
	movl $0,(%r14)
	movl %eax,4(%r14)
	movl %r12d,8(%r14)
	movq %r14,%rax
	jmp L3
L44:
	xorl %eax,%eax
L48:
	movslq %eax,%rax
	cmpq ___iotab(,%rax,8),%r14
	jz L51
L53:
	incl %eax
	cmpl $20,%eax
	jl L48
	jge L50
L51:
	movq $0,___iotab(,%rax,8)
L50:
	cmpq $___stdin,%r14
	jz L68
L62:
	cmpq $___stdout,%r14
	jz L68
L63:
	cmpq $___stderr,%r14
	jz L68
L59:
	movq %r14,%rdi
	call _free
L68:
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
.globl _free
.globl ___stdout
.globl _fflush
.globl _creat
.globl _open
.globl ___stderr
.globl ___stdin
.globl ___iotab
.globl _freopen
