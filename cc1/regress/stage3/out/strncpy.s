.text

_strncpy:
L1:
L2:
	movq %rdi,%rax
	movq %rax,%rdi
	cmpq $0,%rdx
	jbe L3
L7:
	movzbl (%rsi),%ecx
	incq %rsi
	movb %cl,(%rdi)
	incq %rdi
	testb %cl,%cl
	jz L9
L10:
	decq %rdx
	cmpq $0,%rdx
	ja L7
L9:
	cmpb $0,-1(%rsi)
	jnz L3
L17:
	decq %rdx
	cmpq $0,%rdx
	jbe L3
L21:
	movb $0,(%rdi)
	incq %rdi
	decq %rdx
	cmpq $0,%rdx
	ja L21
L3:
	ret 


.globl _strncpy
