.text

_puts:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	xorl %ebx,%ebx
	jmp L4
L5:
	movl %eax,___stdout(%rip)
	leaq 1(%r12),%rcx
	cmpl $0,%eax
	jl L11
L10:
	movb (%r12),%al
	movq ___stdout+24(%rip),%rdx
	movq %rcx,%r12
	leaq 1(%rdx),%rcx
	movq %rcx,___stdout+24(%rip)
	movb %al,(%rdx)
	movzbl %al,%eax
	jmp L12
L11:
	movsbl (%r12),%edi
	movq %rcx,%r12
	movl $___stdout,%esi
	call ___flushbuf
L12:
	cmpl $-1,%eax
	jz L22
L8:
	incl %ebx
L4:
	movb (%r12),%cl
	movl ___stdout(%rip),%eax
	decl %eax
	testb %cl,%cl
	jnz L5
L6:
	movl %eax,___stdout(%rip)
	cmpl $0,%eax
	jl L18
L17:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $10,(%rcx)
	jmp L16
L18:
	movl $___stdout,%esi
	movl $10,%edi
	call ___flushbuf
	cmpl $-1,%eax
	jnz L16
L22:
	movl $-1,%eax
	jmp L3
L16:
	leal 1(%rbx),%eax
L3:
	popq %r12
	popq %rbx
	ret 


.globl ___stdout
.globl _puts
.globl ___flushbuf
