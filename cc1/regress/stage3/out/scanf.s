.text

_scanf:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movq 16(%rbp),%rsi
	movq %rsi,16(%rbp)
	leaq 24(%rbp),%rdx
	movl $___stdin,%edi
	call _vfscanf
L3:
	popq %rbp
	ret 


.globl _scanf
.globl _vfscanf
.globl ___stdin
