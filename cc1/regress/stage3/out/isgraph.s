.text

_isgraph:
L1:
L2:
	movslq %edi,%rdi
	movb ___ctype+1(%rdi),%al
	andb $23,%al
	movsbl %al,%eax
L3:
	ret 


.globl _isgraph
.globl ___ctype
