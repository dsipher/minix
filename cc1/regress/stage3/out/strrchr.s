.text

_strrchr:
L1:
L2:
	xorl %eax,%eax
	movsbl %sil,%edx
L4:
	movsbl (%rdi),%ecx
	cmpl %ecx,%edx
	cmovzq %rdi,%rax
	incq %rdi
	testb %cl,%cl
	jnz L4
L3:
	ret 


.globl _strrchr
