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
L4:
	movslq %ebx,%rdx
	movq %r12,%rsi
	movl %r13d,%edi
	call _write
	cmpl $0,%eax
	jle L6
L7:
	cmpl %eax,%ebx
	jle L6
L5:
	subl %eax,%ebx
	movslq %eax,%rax
	addq %rax,%r12
	jmp L4
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
	movl %edi,%ebx
	movq %rsi,%r12
	movq $___stdio_cleanup,___exit_cleanup(%rip)
	cmpl $0,4(%r12)
	jl L15
L17:
	movl 8(%r12),%eax
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
	movl %eax,8(%r12)
	testl $4,%eax
	jnz L33
L31:
	cmpq $0,16(%r12)
	jnz L33
L34:
	cmpq $___stdout,%r12
	jnz L42
L40:
	movl ___stdout+4(%rip),%edi
	call _isatty
	testl %eax,%eax
	jz L42
L41:
	movl $1024,%edi
	call _malloc
	movq %rax,16(%r12)
	movl 8(%r12),%ecx
	testq %rax,%rax
	jnz L45
L44:
	orl $4,%ecx
	movl %ecx,8(%r12)
	jmp L39
L45:
	orl $72,%ecx
	movl %ecx,8(%r12)
	movl $1024,12(%r12)
	jmp L104
L42:
	movl $1024,%edi
	call _malloc
	movq %rax,16(%r12)
	movl 8(%r12),%ecx
	testq %rax,%rax
	jnz L48
L47:
	orl $4,%ecx
	movl %ecx,8(%r12)
	jmp L39
L48:
	orl $8,%ecx
	movl %ecx,8(%r12)
	movl $1024,12(%r12)
	testl $64,%ecx
	jz L50
L104:
	movl $-1,(%r12)
	jmp L39
L50:
	movl $1023,(%r12)
L39:
	movq 16(%r12),%rax
	movq %rax,24(%r12)
L33:
	movl 8(%r12),%edx
	testl $4,%edx
	jz L54
L53:
	movb %bl,-1(%rbp)
	movl $0,(%r12)
	testl $512,8(%r12)
	jz L58
L56:
	movl $2,%edx
	xorl %esi,%esi
	movl 4(%r12),%edi
	call _lseek
	cmpq $-1,%rax
	jz L59
L58:
	movl $1,%edx
	leaq -1(%rbp),%rsi
	movl 4(%r12),%edi
	call _write
	cmpq $1,%rax
	jnz L63
L65:
	movzbl %bl,%eax
	jmp L14
L63:
	orl $32,8(%r12)
	jmp L105
L59:
	orl $32,8(%r12)
	jmp L105
L54:
	testl $64,%edx
	movq 24(%r12),%r13
	jz L69
L68:
	leaq 1(%r13),%rax
	movq %rax,24(%r12)
	movb %bl,(%r13)
	cmpl $10,%ebx
	jz L75
L74:
	movl (%r12),%ecx
	movl 12(%r12),%eax
	negl %eax
	cmpl %eax,%ecx
	jnz L55
L75:
	movl (%r12),%r13d
	negl %r13d
	movq 16(%r12),%rax
	movq %rax,24(%r12)
	movl $0,(%r12)
	testl $512,8(%r12)
	jz L80
L78:
	movl $2,%edx
	xorl %esi,%esi
	movl 4(%r12),%edi
	call _lseek
	cmpq $-1,%rax
	jz L81
L80:
	movl 4(%r12),%edi
	movl %r13d,%edx
	movq 16(%r12),%rsi
	call _do_write
	testl %eax,%eax
	jnz L55
L85:
	orl $32,8(%r12)
	jmp L105
L81:
	orl $32,8(%r12)
	jmp L105
L69:
	movq 16(%r12),%rcx
	subq %rcx,%r13
	movl 12(%r12),%eax
	decl %eax
	movl %eax,(%r12)
	incq %rcx
	movq %rcx,24(%r12)
	cmpl $0,%r13d
	jle L91
L89:
	testl $512,%edx
	jz L94
L92:
	movl $2,%edx
	xorl %esi,%esi
	movl 4(%r12),%edi
	call _lseek
	cmpq $-1,%rax
	jz L95
L94:
	movl 4(%r12),%edi
	movl %r13d,%edx
	movq 16(%r12),%rsi
	call _do_write
	testl %eax,%eax
	jz L99
L91:
	movq 16(%r12),%rax
	movb %bl,(%rax)
L55:
	movzbl %bl,%eax
	jmp L14
L99:
	movq 16(%r12),%rax
	movb %bl,(%rax)
	orl $32,8(%r12)
	jmp L105
L95:
	orl $32,8(%r12)
L105:
	movl $-1,%eax
	jmp L14
L15:
	movzbl %bl,%eax
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
