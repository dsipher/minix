.text

_fsetpos:
L1:
L2:
	xorl %edx,%edx
	movq (%rsi),%rsi
	call _fseek
L3:
	ret 


.globl _fseek
.globl _fsetpos
