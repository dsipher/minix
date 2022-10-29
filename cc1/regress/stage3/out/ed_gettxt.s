.local L4
.comm L4, 8192, 1
.text

_gettxt:
L1:
L2:
	call _getptr
	leaq 24(%rax),%rsi
	movl $L4,%edi
	call _strcpy
	movl $L5,%esi
	movl $L4,%edi
	call _strcat
	movl $L4,%eax
L3:
	ret 

L5:
	.byte 10,0

.globl _strcat
.globl _getptr
.globl _gettxt
.globl _strcpy
