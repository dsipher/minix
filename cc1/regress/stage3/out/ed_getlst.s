.text

_getlst:
L1:
L2:
	movl $0,_line2(%rip)
	movl $0,_nlines(%rip)
	jmp L4
L5:
	movl _line2(%rip),%ecx
	movl %ecx,_line1(%rip)
	movl %eax,_line2(%rip)
	incl _nlines(%rip)
	movq _inptr(%rip),%rdx
	movb (%rdx),%cl
	cmpb $44,%cl
	jz L13
L11:
	cmpb $59,%cl
	jnz L7
L13:
	cmpb $59,%cl
	jnz L18
L16:
	movl %eax,_curln(%rip)
L18:
	incq %rdx
	movq %rdx,_inptr(%rip)
L4:
	call _getone
	cmpl $0,%eax
	jge L5
L7:
	movl _nlines(%rip),%ecx
	cmpl $2,%ecx
	movl $2,%edx
	cmovll %ecx,%edx
	movl %edx,_nlines(%rip)
	testl %edx,%edx
	jnz L24
L22:
	movl _curln(%rip),%ecx
	movl %ecx,_line2(%rip)
L24:
	cmpl $1,%edx
	jg L27
L25:
	movl _line2(%rip),%ecx
	movl %ecx,_line1(%rip)
L27:
	cmpl $-2,%eax
	cmovnzl %edx,%eax
L3:
	ret 


.globl _curln
.globl _getone
.globl _getlst
.globl _line1
.globl _nlines
.globl _line2
.globl _inptr
