.text

_esc:
L1:
L2:
	movq (%rdi),%rcx
	movb (%rcx),%al
	cmpb $92,%al
	jnz L39
L5:
	leaq 1(%rcx),%rax
	movq %rax,(%rdi)
	movb 1(%rcx),%al
	cmpb $97,%al
	jl L8
L10:
	cmpb $122,%al
	jg L8
L7:
	movsbl %al,%ecx
	subl $32,%ecx
	jmp L9
L8:
	movsbl %al,%ecx
L9:
	cmpl $0,%ecx
	jz L17
	jl L39
L32:
	cmpl $84,%ecx
	jz L23
	jg L39
L33:
	cmpb $66,%cl
	jz L25
L34:
	cmpb $78,%cl
	jz L21
L35:
	cmpb $82,%cl
	jz L27
L36:
	cmpb $83,%cl
	jz L19
L39:
	movsbl %al,%eax
	ret
L19:
	movl $32,%eax
	ret
L27:
	movl $13,%eax
	ret
L21:
	movl $10,%eax
	ret
L25:
	movl $8,%eax
	ret
L23:
	movl $9,%eax
	ret
L17:
	movl $92,%eax
L3:
	ret 


.globl _esc
