.text

_wait:
L1:
L2:
	xorl %edx,%edx
	movq %rdi,%rsi
	movl $-1,%edi
	call _waitpid
L3:
	ret 


.globl _waitpid
.globl _wait
