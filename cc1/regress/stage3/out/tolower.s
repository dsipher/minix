.text

_tolower:
L1:
L2:
	movl %edi,%eax
	movl %eax,%ecx
	subl $65,%ecx
	cmpl $26,%ecx
	jae L3
L4:
	subl $-32,%eax
L3:
	ret 


.globl _tolower
