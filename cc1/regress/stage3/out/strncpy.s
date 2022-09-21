.text

_strncpy:
L1:
L2:
	movq %rdi,%rax
	movq %rax,%rdi
	testq %rdx,%rdx
	jz L3
L7:
	movb (%rsi),%cl
	incq %rsi
	movb %cl,(%rdi)
	incq %rdi
	testb %cl,%cl
	jz L9
L10:
	decq %rdx
	jnz L7
L9:
	cmpb $0,-1(%rsi)
	jnz L3
L17:
	decq %rdx
	jz L3
L21:
	movb $0,(%rdi)
	incq %rdi
	decq %rdx
	jnz L21
L3:
	ret 


.globl _strncpy
