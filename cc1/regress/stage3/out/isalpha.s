.text

_isalpha:
L1:
L2:
	movslq %edi,%rax
	movb ___ctype+1(%rax),%al
	andb $3,%al
	movsbl %al,%eax
L3:
	ret 


.globl _isalpha
.globl ___ctype
