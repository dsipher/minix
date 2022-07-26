.text

_strrchr:
L1:
L2:
	xorl %eax,%eax
	movsbl %sil,%esi
L4:
	movzbl (%rdi),%edx
	movsbl %dl,%ecx
	cmpl %ecx,%esi
	cmovzq %rdi,%rax
	incq %rdi
	testb %dl,%dl
	jnz L4
L3:
	ret 


.globl _strrchr
