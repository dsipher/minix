.text

_setbuf:
L1:
L2:
	testq %rsi,%rsi
	movl $4,%eax
	movl $0,%edx
	cmovzl %eax,%edx
	movl $1024,%ecx
	call _setvbuf
L3:
	ret 


.globl _setvbuf
.globl _setbuf
