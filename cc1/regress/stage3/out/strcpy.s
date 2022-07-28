.text

_strcpy:
L1:
L2:
	movq %rdi,%rax
	movq %rax,%rdx
L4:
	movb (%rsi),%cl
	incq %rsi
	movb %cl,(%rdx)
	incq %rdx
	testb %cl,%cl
	jnz L4
L3:
	ret 


.globl _strcpy
