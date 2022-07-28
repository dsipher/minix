.text

_strncmp:
L1:
L2:
	testq %rdx,%rdx
	jz L31
L7:
	movb (%rdi),%al
	movb (%rsi),%cl
	incq %rsi
	cmpb %cl,%al
	jnz L8
L12:
	incq %rdi
	testb %al,%al
	jz L31
L16:
	decq %rdx
	cmpq $0,%rdx
	ja L7
L8:
	cmpq $0,%rdx
	jbe L31
L18:
	movb (%rdi),%al
	testb %al,%al
	jz L21
L23:
	testb %cl,%cl
	jz L25
L27:
	movzbl %al,%eax
	movzbl %cl,%ecx
	subl %ecx,%eax
	ret
L25:
	movl $1,%eax
	ret
L21:
	movl $-1,%eax
	ret
L31:
	xorl %eax,%eax
L3:
	ret 


.globl _strncmp
