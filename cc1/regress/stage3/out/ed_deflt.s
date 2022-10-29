.text

_deflt:
L1:
L2:
	cmpl $0,_nlines(%rip)
	jnz L6
L4:
	movl %edi,_line1(%rip)
	movl %esi,_line2(%rip)
L6:
	movl _line1(%rip),%eax
	cmpl _line2(%rip),%eax
	jg L7
L10:
	cmpl $0,%eax
	jg L9
L7:
	movl $-2,%eax
	ret
L9:
	xorl %eax,%eax
L3:
	ret 


.globl _line1
.globl _nlines
.globl _line2
.globl _deflt
