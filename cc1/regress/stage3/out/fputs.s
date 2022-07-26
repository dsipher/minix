.text

_fputs:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movq %rdi,%r13
	movq %rsi,%r12
	xorl %ebx,%ebx
L4:
	cmpb $0,(%r13)
	jz L6
L5:
	decl (%r12)
	leaq 1(%r13),%rcx
	js L11
L10:
	movzbl (%r13),%eax
	movq %rcx,%r13
	movq 24(%r12),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,24(%r12)
	movb %al,(%rdx)
	movzbl %al,%eax
	jmp L12
L11:
	movsbl (%r13),%edi
	movq %rcx,%r13
	movq %r12,%rsi
	call ___flushbuf
L12:
	cmpl $-1,%eax
	jz L7
L8:
	incl %ebx
	jmp L4
L7:
	movl $-1,%eax
	jmp L3
L6:
	movl %ebx,%eax
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


.globl ___flushbuf
.globl _fputs
