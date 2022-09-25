.text

_getenv:
L1:
L2:
	movq _environ(%rip),%r8
	testq %r8,%r8
	jz L32
L7:
	testq %rdi,%rdi
	jz L32
L12:
	movq (%r8),%rax
	addq $8,%r8
	testq %rax,%rax
	jz L32
L13:
	movq %rdi,%rsi
	jmp L15
L18:
	movb (%rax),%cl
	incq %rax
	cmpb %cl,%dl
	jnz L17
L16:
	incq %rsi
L15:
	movb (%rsi),%dl
	testb %dl,%dl
	jnz L18
L17:
	testb %dl,%dl
	jnz L12
L25:
	cmpb $61,(%rax)
	jnz L12
L24:
	incq %rax
	ret
L32:
	xorl %eax,%eax
L3:
	ret 


.globl _getenv
.globl _environ
