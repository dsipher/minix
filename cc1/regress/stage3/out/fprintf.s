.text

_fprintf:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movq 16(%rbp),%rdi
	movq 24(%rbp),%rsi
	movq %rsi,24(%rbp)
	leaq 32(%rbp),%rdx
	call _vfprintf
L3:
	popq %rbp
	ret 


.globl _vfprintf
.globl _fprintf
