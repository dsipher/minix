.text

_islower:
L1:
L2:
	subl $97,%edi
	cmpl $26,%edi
	setb %al
	movzbl %al,%eax
L3:
	ret 


.globl _islower
