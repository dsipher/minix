.text

_isxdigit:
L1:
L2:
	movslq %edi,%rdi
	movb ___ctype+1(%rdi),%al
	andb $68,%al
	movsbl %al,%eax
L3:
	ret 


.globl _isxdigit
.globl ___ctype
