.text

_strcat:
L1:
L2:
	movq %rdi,%rax
	movq %rax,%rdx
L4:
	movb (%rdx),%cl
	incq %rdx
	testb %cl,%cl
	jnz L4
L6:
	decq %rdx
L7:
	movb (%rsi),%cl
	incq %rsi
	movb %cl,(%rdx)
	incq %rdx
	testb %cl,%cl
	jnz L7
L3:
	ret 


.globl _strcat
