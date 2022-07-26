.text

_strtof:
L1:
L2:
	call _strtod
	cvtsd2ss %xmm0,%xmm0
L3:
	ret 


.globl _strtod
.globl _strtof
