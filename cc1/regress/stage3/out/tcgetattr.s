.text

_tcgetattr:
L1:
L2:
	movq %rsi,%rdx
	movl $21505,%esi
	call _ioctl
L3:
	ret 


.globl _tcgetattr
.globl _ioctl
