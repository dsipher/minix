.text

_ispunct:
L1:
L2:
	movslq %edi,%rdi
	movzbl ___ctype+1(%rdi),%eax
	andl $16,%eax
	movsbl %al,%eax
L3:
	ret 


.globl _ispunct
.globl ___ctype
