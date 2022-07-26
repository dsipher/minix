.text

_printf:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movq 16(%rbp),%rsi
	movq %rsi,16(%rbp)
	leaq 24(%rbp),%rdx
	movl $___stdout,%edi
	call _vfprintf
L3:
	popq %rbp
	ret 


.globl ___stdout
.globl _printf
.globl _vfprintf
