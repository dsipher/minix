.text

_isxdigit:
L1:
L2:
	movslq %edi,%rdi
	movzbl ___ctype+1(%rdi),%eax
	andl $68,%eax
	movsbl %al,%eax
L3:
	ret 


.globl _isxdigit
.globl ___ctype
