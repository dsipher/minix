.text

_memcmp:
L1:
L2:
	testq %rdx,%rdx
	jz L6
L4:
	incq %rdx
L7:
	decq %rdx
	jz L6
L8:
	movb (%rdi),%al
	incq %rdi
	movb (%rsi),%cl
	incq %rsi
	cmpb %cl,%al
	jz L7
L12:
	movzbl %al,%eax
	movzbl %cl,%ecx
	subl %ecx,%eax
	ret
L6:
	xorl %eax,%eax
L3:
	ret 


.globl _memcmp
