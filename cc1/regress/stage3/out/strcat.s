.text

_strcat:
L1:
L2:
	movq %rdi,%rax
	movq %rax,%rdx
L4:
	movzbl (%rdx),%ecx
	incq %rdx
	testb %cl,%cl
	jnz L4
L6:
	decq %rdx
L7:
	movzbl (%rsi),%ecx
	incq %rsi
	movb %cl,(%rdx)
	incq %rdx
	testb %cl,%cl
	jnz L7
L3:
	ret 


.globl _strcat
