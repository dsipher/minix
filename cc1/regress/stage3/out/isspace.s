.text

_isspace:
L1:
L2:
	movslq %edi,%rdi
	movzbl ___ctype+1(%rdi),%eax
	andl $8,%eax
	movsbl %al,%eax
L3:
	ret 


.globl ___ctype
.globl _isspace
