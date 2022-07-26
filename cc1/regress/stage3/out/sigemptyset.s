.text

_sigemptyset:
L1:
L2:
	movq $0,(%rdi)
	xorl %eax,%eax
L3:
	ret 


.globl _sigemptyset
