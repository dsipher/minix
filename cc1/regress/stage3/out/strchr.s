.text

_strchr:
L1:
L2:
	movq %rdi,%rax
	movsbl %sil,%edx
L4:
	movsbl (%rax),%ecx
	cmpl %ecx,%edx
	jz L3
L5:
	incq %rax
	testb %cl,%cl
	jnz L4
L7:
	xorl %eax,%eax
L3:
	ret 


.globl _strchr
