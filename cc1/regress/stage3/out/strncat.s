.text

_strncat:
L1:
L2:
	movq %rdi,%rax
	movq %rax,%rdi
	testq %rdx,%rdx
	jz L3
L7:
	movb (%rdi),%cl
	incq %rdi
	testb %cl,%cl
	jnz L7
L9:
	decq %rdi
L10:
	movb (%rsi),%cl
	incq %rsi
	movb %cl,(%rdi)
	incq %rdi
	testb %cl,%cl
	jz L3
L11:
	decq %rdx
	jnz L10
L15:
	movb $0,(%rdi)
L3:
	ret 


.globl _strncat
