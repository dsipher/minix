.text

_isgraph:
L1:
L2:
	movslq %edi,%rdi
	movzbl ___ctype+1(%rdi),%eax
	andl $23,%eax
	movsbl %al,%eax
L3:
	ret 


.globl _isgraph
.globl ___ctype
