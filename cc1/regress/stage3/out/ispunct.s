.text

_ispunct:
L1:
L2:
	movslq %edi,%rdi
	movb ___ctype+1(%rdi),%al
	andb $16,%al
	movsbl %al,%eax
L3:
	ret 


.globl _ispunct
.globl ___ctype
