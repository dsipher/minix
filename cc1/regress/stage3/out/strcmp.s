.text

_strcmp:
L1:
L4:
	movb (%rdi),%al
	movb (%rsi),%cl
	incq %rsi
	cmpb %cl,%al
	jnz L6
L5:
	incq %rdi
	testb %al,%al
	jnz L4
L7:
	xorl %eax,%eax
	ret
L6:
	testb %al,%al
	jz L11
L13:
	testb %cl,%cl
	jz L15
L17:
	movzbl %al,%eax
	movzbl %cl,%ecx
	subl %ecx,%eax
	ret
L15:
	movl $1,%eax
	ret
L11:
	movl $-1,%eax
L3:
	ret 


.globl _strcmp
