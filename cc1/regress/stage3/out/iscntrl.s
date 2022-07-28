.text

_iscntrl:
L1:
L2:
	movslq %edi,%rdi
	movb ___ctype+1(%rdi),%al
	andb $32,%al
	movsbl %al,%eax
L3:
	ret 


.globl _iscntrl
.globl ___ctype
