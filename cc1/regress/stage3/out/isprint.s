.text

_isprint:
L1:
L2:
	subl $32,%edi
	cmpl $95,%edi
	setb %al
	movzbl %al,%eax
L3:
	ret 


.globl _isprint
