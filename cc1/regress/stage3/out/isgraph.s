.text

_isgraph:
L1:
L2:
	movslq %edi,%rax
	movb ___ctype+1(%rax),%al
	andb $23,%al
	movzbl %al,%eax
L3:
	ret 


.globl _isgraph
.globl ___ctype
