.text

_getpat:
L1:
L2:
	xorl %esi,%esi
	call _makepat
L3:
	ret 


.globl _makepat
.globl _getpat
