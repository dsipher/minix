.text

_iscntrl:
L1:
L2:
	movslq %edi,%rdi
	movzbl ___ctype+1(%rdi),%eax
	andl $32,%eax
	movsbl %al,%eax
L3:
	ret 


.globl _iscntrl
.globl ___ctype
