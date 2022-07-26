.text

_isalnum:
L1:
L2:
	movslq %edi,%rdi
	movzbl ___ctype+1(%rdi),%eax
	andl $7,%eax
	movsbl %al,%eax
L3:
	ret 


.globl _isalnum
.globl ___ctype
