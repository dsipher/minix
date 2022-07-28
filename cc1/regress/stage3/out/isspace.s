.text

_isspace:
L1:
L2:
	movslq %edi,%rdi
	movb ___ctype+1(%rdi),%al
	andb $8,%al
	movsbl %al,%eax
L3:
	ret 


.globl ___ctype
.globl _isspace
