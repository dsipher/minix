.text

_ungetc:
L1:
L2:
	movl %edi,%eax
	cmpl $-1,%eax
	jz L20
L7:
	testl $128,8(%rsi)
	jz L20
L6:
	movq 24(%rsi),%rcx
	cmpq 16(%rsi),%rcx
	jnz L14
L12:
	cmpl $0,(%rsi)
	jz L17
L20:
	movl $-1,%eax
	ret
L17:
	incq %rcx
	movq %rcx,24(%rsi)
L14:
	incl (%rsi)
	movq 24(%rsi),%rdx
	leaq -1(%rdx),%rcx
	movq %rcx,24(%rsi)
	movb %al,-1(%rdx)
L3:
	ret 


.globl _ungetc
