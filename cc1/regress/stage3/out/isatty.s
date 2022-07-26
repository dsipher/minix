.text

_isatty:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
L2:
	leaq -36(%rbp),%rsi
	call _tcgetattr
	cmpl $-1,%eax
	setnz %al
	movzbl %al,%eax
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _tcgetattr
.globl _isatty
