.text

_isupper:
L1:
L2:
	subl $65,%edi
	cmpl $26,%edi
	setb %al
	movzbl %al,%eax
L3:
	ret 


.globl _isupper
