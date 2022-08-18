.text

_iscntrl:
L1:
L2:
	movslq %edi,%rax
	movb ___ctype+1(%rax),%al
	andb $32,%al
	movsbl %al,%eax
L3:
	ret 


.globl _iscntrl
.globl ___ctype
