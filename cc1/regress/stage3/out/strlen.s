.text

_strlen:
L1:
L2:
	movq %rdi,%rax
L4:
	movzbl (%rax),%ecx
	incq %rax
	testb %cl,%cl
	jnz L4
L6:
	decq %rax
	subq %rdi,%rax
L3:
	ret 


.globl _strlen
