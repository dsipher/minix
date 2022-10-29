.text

_omatch:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	movq (%r12),%rcx
	movb (%rcx),%dil
	movl $-1,%ebx
	testb %dil,%dil
	jz L42
L4:
	movb (%rsi),%al
	cmpb $33,%al
	jz L35
L47:
	cmpb $36,%al
	jz L25
L48:
	cmpb $46,%al
	jz L20
L49:
	cmpb $76,%al
	jz L10
L50:
	cmpb $91,%al
	jz L30
L51:
	cmpb $94,%al
	jnz L42
L15:
	cmpq %rcx,%rdx
	jnz L42
	jz L45
L30:
	movsbl %dil,%edi
	movq 8(%rsi),%rsi
	call _testbit
	testl %eax,%eax
	jz L42
	jnz L44
L10:
	cmpb 1(%rsi),%dil
	jnz L42
	jz L44
L20:
	cmpb $10,%dil
	jz L42
	jnz L44
L25:
	cmpb $10,%dil
	jnz L42
L45:
	xorl %ebx,%ebx
	jmp L40
L35:
	movsbl %dil,%edi
	movq 8(%rsi),%rsi
	call _testbit
	testl %eax,%eax
	jnz L42
L44:
	movl $1,%ebx
L40:
	movl %ebx,%ecx
	addq (%r12),%rcx
	movq %rcx,(%r12)
L42:
	leal 1(%rbx),%eax
L3:
	popq %r12
	popq %rbx
	ret 


.globl _omatch
.globl _testbit
