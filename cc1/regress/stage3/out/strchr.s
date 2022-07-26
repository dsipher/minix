.text

_strchr:
L1:
L2:
	movq %rdi,%rax
	movsbl %sil,%esi
L4:
	movzbl (%rax),%edx
	movsbl %dl,%ecx
	cmpl %ecx,%esi
	jz L3
L5:
	incq %rax
	testb %dl,%dl
	jnz L4
L7:
	xorl %eax,%eax
L3:
	ret 


.globl _strchr
