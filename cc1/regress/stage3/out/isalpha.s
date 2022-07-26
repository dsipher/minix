.text

_isalpha:
L1:
L2:
	movslq %edi,%rdi
	movzbl ___ctype+1(%rdi),%eax
	andl $3,%eax
	movsbl %al,%eax
L3:
	ret 


.globl _isalpha
.globl ___ctype
