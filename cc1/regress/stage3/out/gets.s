.text

_gets:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	movq %r12,%rbx
L4:
	decl ___stdin(%rip)
	js L12
L11:
	movq ___stdin+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdin+24(%rip)
	movzbl (%rcx),%eax
	jmp L13
L12:
	movl $___stdin,%edi
	call ___fillbuf
L13:
	cmpl $-1,%eax
	jz L9
L7:
	cmpl $10,%eax
	jz L9
L8:
	movb %al,(%rbx)
	incq %rbx
	jmp L4
L9:
	cmpl $-1,%eax
	jnz L16
L14:
	testl $16,___stdin+8(%rip)
	jz L26
L17:
	cmpq %rbx,%r12
	jnz L16
L26:
	xorl %eax,%eax
	jmp L3
L16:
	movb $0,(%rbx)
	movq %r12,%rax
L3:
	popq %r12
	popq %rbx
	ret 


.globl ___fillbuf
.globl _gets
.globl ___stdin
