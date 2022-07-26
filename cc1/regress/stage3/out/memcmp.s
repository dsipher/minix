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
	cmpq $0,%rdx
	jbe L6
L8:
	movzbl (%rdi),%eax
	incq %rdi
	movzbl (%rsi),%ecx
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
