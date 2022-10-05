.local L4
.comm L4, 20, 1
.text

___fillbuf:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%rbx
	movl $0,(%rbx)
	cmpl $0,4(%rbx)
	jl L59
L7:
	movl 8(%rbx),%eax
	testl $48,%eax
	jnz L59
L11:
	testl $1,%eax
	jz L60
L15:
	testl $256,%eax
	jz L19
L60:
	orl $32,%eax
	movl %eax,8(%rbx)
	jmp L59
L19:
	testl $128,%eax
	jnz L23
L21:
	orl $128,%eax
	movl %eax,8(%rbx)
L23:
	testl $4,8(%rbx)
	jnz L26
L27:
	cmpq $0,16(%rbx)
	jnz L26
L24:
	movl $1024,%edi
	call _malloc
	movq %rax,16(%rbx)
	movl 8(%rbx),%ecx
	testq %rax,%rax
	jnz L32
L31:
	orl $4,%ecx
	movl %ecx,8(%rbx)
	jmp L26
L32:
	orl $8,%ecx
	movl %ecx,8(%rbx)
	movl $1024,12(%rbx)
L26:
	xorl %r12d,%r12d
L35:
	movq ___iotab(,%r12,8),%rdi
	testq %rdi,%rdi
	jz L40
L41:
	movl 8(%rdi),%eax
	testl $64,%eax
	jz L40
L38:
	testl $256,%eax
	jz L40
L45:
	call _fflush
L40:
	incl %r12d
	cmpl $20,%r12d
	jl L35
L37:
	cmpq $0,16(%rbx)
	jnz L50
L48:
	movslq 4(%rbx),%rax
	addq $L4,%rax
	movq %rax,16(%rbx)
	movl $1,12(%rbx)
L50:
	movq 16(%rbx),%rsi
	movq %rsi,24(%rbx)
	movslq 12(%rbx),%rdx
	movl 4(%rbx),%edi
	call _read
	movl %eax,(%rbx)
	cmpl $0,%eax
	jle L51
L53:
	decl %eax
	movl %eax,(%rbx)
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movzbl (%rcx),%eax
	jmp L3
L51:
	movl 8(%rbx),%ecx
	testl %eax,%eax
	jnz L55
L54:
	orl $16,%ecx
	jmp L61
L55:
	orl $32,%ecx
L61:
	movl %ecx,8(%rbx)
L59:
	movl $-1,%eax
L3:
	popq %r12
	popq %rbx
	ret 


.globl ___fillbuf
.globl _malloc
.globl _fflush
.globl ___iotab
.globl _read
