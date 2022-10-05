.text

_isalnum:
L1:
L2:
	movslq %edi,%rax
	movb ___ctype+1(%rax),%al
	andb $7,%al
	movzbl %al,%eax
L3:
	ret 


.globl _isalnum
.globl ___ctype
