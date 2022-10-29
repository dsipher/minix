.text

_relink:
L1:
L2:
	movq %rdi,8(%rsi)
	movq %rcx,16(%rdx)
L3:
	ret 


_clrbuf:
L4:
L5:
	movl _lastln(%rip),%esi
	movl $1,%edi
	call _del
L6:
	ret 


_set_buf:
L7:
L8:
	movl $_line0,%ecx
	movl $_line0,%edx
	movl $_line0,%esi
	movl $_line0,%edi
	call _relink
	movl $0,_lastln(%rip)
	movl $0,_curln(%rip)
L9:
	ret 


.globl _lastln
.globl _curln
.globl _set_buf
.globl _clrbuf
.globl _line0
.globl _relink
.globl _del
