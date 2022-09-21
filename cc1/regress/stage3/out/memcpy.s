.text

_memcpy:
L1:
L2:
	movq %rdi,%rax
	movq %rax,%rdi
	testq %rdx,%rdx
	jz L3
L4:
	incq %rdx
L7:
	decq %rdx
	jz L3
L8:
	movb (%rsi),%cl
	incq %rsi
	movb %cl,(%rdi)
	incq %rdi
	jmp L7
L3:
	ret 


.globl _memcpy
