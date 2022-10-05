.text

_isxdigit:
L1:
L2:
	movslq %edi,%rax
	movb ___ctype+1(%rax),%al
	andb $68,%al
	movzbl %al,%eax
L3:
	ret 


.globl _isxdigit
.globl ___ctype
