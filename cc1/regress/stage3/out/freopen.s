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
	movq %rdi,-8(%rbp) # spill
	movq %rsi,%r14
	movq %rdx,%r13
	xorl %r15d,%r15d
	movl 8(%r13),%ebx
	andl $76,%ebx
	movq %r13,%rdi
	call _fflush
	movl 4(%r13),%edi
	call _close
	movb (%r14),%al
	incq %r14
	cmpb $114,%al
	jz L7
L70:
	cmpb $119,%al
	jz L9
L71:
	cmpb $97,%al
	jnz L68
L11:
	orl $514,%ebx
	movl $1,%r12d
	movl $1088,%r15d
	jmp L14
L9:
	orl $2,%ebx
	movl $1,%r12d
	movl $576,%r15d
	jmp L14
L7:
	orl $1,%ebx
	xorl %r12d,%r12d
L14:
	movb (%r14),%al
	testb %al,%al
	jz L16
L15:
	incq %r14
	cmpb $98,%al
	jz L14
L75:
	cmpb $43,%al
	jnz L16
L22:
	movl $2,%r12d
	orl $3,%ebx
	jmp L14
L16:
	testl $512,%r15d
	jnz L30
L29:
	pushq %r12
	pushq -8(%rbp) # spill
	call _open
	addq $16,%rsp
	cmpl $0,%eax
	jge L28
L33:
	testl $64,%r15d
	jz L28
L30:
	movl $438,%esi
	movq -8(%rbp),%rdi # spill
	call _creat
	movl %eax,%edi
	movl %edi,%eax
	cmpl $0,%edi
	jge L28
L40:
	movl %ebx,%ecx
	orl $1,%ecx
	jz L28
L41:
	call _close
	pushq %r12
	pushq -8(%rbp) # spill
	call _open
	addq $16,%rsp
L28:
	cmpl $0,%eax
	jl L44
L46:
	movl $0,(%r13)
	movl %eax,4(%r13)
	movl %ebx,8(%r13)
	movq %r13,%rax
	jmp L3
L44:
	xorl %eax,%eax
L48:
	cmpq ___iotab(,%rax,8),%r13
	jz L51
L53:
	incl %eax
	cmpl $20,%eax
	jl L48
	jge L50
L51:
	movq $0,___iotab(,%rax,8)
L50:
	cmpq $___stdin,%r13
	jz L68
L62:
	cmpq $___stdout,%r13
	jz L68
L63:
	cmpq $___stderr,%r13
	jz L68
L59:
	movq %r13,%rdi
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
