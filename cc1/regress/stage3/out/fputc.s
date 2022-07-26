.text

_fputc:
L1:
L2:
	decl (%rsi)
	js L5
L4:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %dil,(%rcx)
	movzbl %dil,%eax
	ret
L5:
	call ___flushbuf
L3:
	ret 


.globl _fputc
.globl ___flushbuf
