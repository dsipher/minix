.text

_isdigit:
L1:
L2:
	subl $48,%edi
	cmpl $10,%edi
	setb %al
	movzbl %al,%eax
L3:
	ret 


.globl _isdigit
