.text

_execvp:
L1:
L2:
	movq _environ(%rip),%rdx
	call _execvpe
L3:
	ret 


.globl _execvp
.globl _execvpe
.globl _environ
