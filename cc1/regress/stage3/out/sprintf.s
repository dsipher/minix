.text

_sprintf:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movq 16(%rbp),%rdi
	movq 24(%rbp),%rsi
	movq %rsi,24(%rbp)
	leaq 32(%rbp),%rdx
	call _vsprintf
L3:
	popq %rbp
	ret 


.globl _sprintf
.globl _vsprintf
