.text

_memchr:
L1:
L2:
	movzbl %sil,%ecx
	testq %rdx,%rdx
	jz L6
L4:
	incq %rdx
L7:
	decq %rdx
	jz L6
L8:
	movzbl (%rdi),%eax
	incq %rdi
	cmpl %eax,%ecx
	jnz L7
L12:
	leaq -1(%rdi),%rax
	ret
L6:
	xorl %eax,%eax
L3:
	ret 


.globl _memchr
