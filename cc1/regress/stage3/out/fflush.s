.text

_fflush:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%rbx
	xorl %r12d,%r12d
	testq %rbx,%rbx
	jz L4
L6:
	movq 16(%rbx),%rdx
	testq %rdx,%rdx
	jz L72
L22:
	movl 8(%rbx),%eax
	movl %eax,%ecx
	andl $128,%ecx
	jnz L21
L26:
	testl $256,%eax
	jz L72
L21:
	testl %ecx,%ecx
	jz L32
L31:
	xorl %esi,%esi
	testq %rdx,%rdx
	jz L36
L37:
	testl $4,%eax
	jnz L36
L34:
	movl (%rbx),%esi
	negl %esi
L36:
	movl $0,(%rbx)
	movslq %esi,%rsi
	movl $1,%edx
	movl 4(%rbx),%edi
	call _lseek
	movl 8(%rbx),%ecx
	cmpq $-1,%rax
	jz L41
L43:
	testl $2,%ecx
	jz L47
L45:
	andl $-385,%ecx
	movl %ecx,8(%rbx)
L47:
	movq 16(%rbx),%rax
	movq %rax,24(%rbx)
	jmp L72
L41:
	orl $32,%ecx
	movl %ecx,8(%rbx)
	jmp L73
L32:
	testl $4,%eax
	jnz L72
L33:
	testl $1,%eax
	jz L55
L53:
	andl $-257,%eax
	movl %eax,8(%rbx)
L55:
	movq 24(%rbx),%r12
	subq %rdx,%r12
	movq %rdx,24(%rbx)
	cmpl $0,%r12d
	jle L72
L58:
	testl $512,8(%rbx)
	jz L62
L60:
	movl $2,%edx
	xorl %esi,%esi
	movl 4(%rbx),%edi
	call _lseek
	cmpq $-1,%rax
	jz L74
L62:
	movl 4(%rbx),%edi
	movslq %r12d,%rdx
	movq 16(%rbx),%rsi
	call _write
	movl $0,(%rbx)
	cmpl %eax,%r12d
	jz L72
L74:
	orl $32,8(%rbx)
L73:
	movl $-1,%eax
	jmp L3
L72:
	xorl %eax,%eax
	jmp L3
L4:
	xorl %ebx,%ebx
L8:
	movq ___iotab(,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L13
L14:
	call _fflush
	testl %eax,%eax
	movl $-1,%eax
	cmovnzl %eax,%r12d
L13:
	incl %ebx
	cmpl $20,%ebx
	jl L8
L10:
	movl %r12d,%eax
L3:
	popq %r12
	popq %rbx
	ret 


___stdio_cleanup:
L75:
	pushq %rbx
L76:
	xorl %ebx,%ebx
L79:
	movq ___iotab(,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L84
L85:
	testl $256,8(%rdi)
	jz L84
L82:
	call _fflush
L84:
	incl %ebx
	cmpl $20,%ebx
	jl L79
L77:
	popq %rbx
	ret 


.globl ___stdio_cleanup
.globl _write
.globl _lseek
.globl _fflush
.globl ___iotab
