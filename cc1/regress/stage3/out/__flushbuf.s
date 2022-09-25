.text

_do_write:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movl %edi,%r13d
	movq %rsi,%r12
	movl %edx,%ebx
	jmp L4
L7:
	cmpl %eax,%ebx
	jle L6
L5:
	subl %eax,%ebx
	movslq %eax,%rax
	addq %rax,%r12
L4:
	movslq %ebx,%rdx
	movq %r12,%rsi
	movl %r13d,%edi
	call _write
	cmpl $0,%eax
	jg L7
L6:
	cmpl $0,%eax
	setg %al
	movzbl %al,%eax
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


___flushbuf:
L12:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L13:
	movl %edi,%r12d
	movq %rsi,%rbx
	movq $___stdio_cleanup,___exit_cleanup(%rip)
	cmpl $0,4(%rbx)
	jl L106
L17:
	movl 8(%rbx),%eax
	testl $2,%eax
	jz L105
L21:
	testl $128,%eax
	jz L28
L26:
	testl $16,%eax
	jz L105
L28:
	andl $-129,%eax
	orl $256,%eax
	movl %eax,8(%rbx)
	testl $4,%eax
	jnz L33
L31:
	cmpq $0,16(%rbx)
	jnz L33
L34:
	cmpq $___stdout,%rbx
	jnz L42
L40:
	movl ___stdout+4(%rip),%edi
	call _isatty
	testl %eax,%eax
	jz L42
L41:
	movl $1024,%edi
	call _malloc
	movq %rax,16(%rbx)
	movl 8(%rbx),%ecx
	testq %rax,%rax
	jz L108
L45:
	orl $72,%ecx
	movl %ecx,8(%rbx)
	movl $1024,12(%rbx)
	jmp L104
L42:
	movl $1024,%edi
	call _malloc
	movq %rax,16(%rbx)
	movl 8(%rbx),%ecx
	testq %rax,%rax
	jnz L48
L108:
	orl $4,%ecx
	movl %ecx,8(%rbx)
	jmp L39
L48:
	orl $8,%ecx
	movl %ecx,8(%rbx)
	movl $1024,12(%rbx)
	testl $64,%ecx
	jz L50
L104:
	movl $-1,(%rbx)
	jmp L39
L50:
	movl $1023,(%rbx)
L39:
	movq 16(%rbx),%rax
	movq %rax,24(%rbx)
L33:
	movl 8(%rbx),%edx
	testl $4,%edx
	jz L54
L53:
	movb %r12b,-1(%rbp)
	movl $0,(%rbx)
	testl $512,8(%rbx)
	jz L58
L56:
	movl $2,%edx
	xorl %esi,%esi
	movl 4(%rbx),%edi
	call _lseek
	cmpq $-1,%rax
	jz L107
L58:
	movl $1,%edx
	leaq -1(%rbp),%rsi
	movl 4(%rbx),%edi
	call _write
	cmpq $1,%rax
	jnz L107
	jz L106
L54:
	testl $64,%edx
	movq 24(%rbx),%r13
	jz L69
L68:
	leaq 1(%r13),%rax
	movq %rax,24(%rbx)
	movb %r12b,(%r13)
	cmpl $10,%r12d
	jz L75
L74:
	movl (%rbx),%ecx
	movl 12(%rbx),%eax
	negl %eax
	cmpl %eax,%ecx
	jnz L106
L75:
	movl (%rbx),%r13d
	negl %r13d
	movq 16(%rbx),%rax
	movq %rax,24(%rbx)
	movl $0,(%rbx)
	testl $512,8(%rbx)
	jz L80
L78:
	movl $2,%edx
	xorl %esi,%esi
	movl 4(%rbx),%edi
	call _lseek
	cmpq $-1,%rax
	jz L107
L80:
	movl 4(%rbx),%edi
	movl %r13d,%edx
	movq 16(%rbx),%rsi
	call _do_write
	testl %eax,%eax
	jz L107
	jnz L106
L69:
	movq 16(%rbx),%rcx
	subq %rcx,%r13
	movl 12(%rbx),%eax
	decl %eax
	movl %eax,(%rbx)
	incq %rcx
	movq %rcx,24(%rbx)
	cmpl $0,%r13d
	jle L91
L89:
	testl $512,%edx
	jz L94
L92:
	movl $2,%edx
	xorl %esi,%esi
	movl 4(%rbx),%edi
	call _lseek
	cmpq $-1,%rax
	jz L107
L94:
	movl 4(%rbx),%edi
	movl %r13d,%edx
	movq 16(%rbx),%rsi
	call _do_write
	testl %eax,%eax
	jz L99
L91:
	movq 16(%rbx),%rax
	movb %r12b,(%rax)
L106:
	movzbl %r12b,%eax
	jmp L14
L99:
	movq 16(%rbx),%rax
	movb %r12b,(%rax)
L107:
	orl $32,8(%rbx)
L105:
	movl $-1,%eax
L14:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl ___exit_cleanup
.globl ___stdout
.globl _malloc
.globl ___stdio_cleanup
.globl _write
.globl _lseek
.globl ___flushbuf
.globl _isatty
