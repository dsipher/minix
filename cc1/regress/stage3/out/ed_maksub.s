.text

_maksub:
L1:
L2:
	movq _inptr(%rip),%r8
	movq %rdi,%rax
	movq %rax,%rdx
	leaq 1(%r8),%rcx
	movq %rcx,_inptr(%rip)
	movb (%r8),%cl
	xorl %edi,%edi
	jmp L4
L12:
	cmpb $10,%r9b
	jz L7
L8:
	cmpl %edi,%esi
	jle L7
L5:
	leaq 1(%rdx),%r8
	cmpb $38,%r9b
	jnz L17
L16:
	movb $38,(%rdx)
	movq %r8,%rdx
	jmp L77
L17:
	leaq 1(%r10),%r9
	movq %r9,_inptr(%rip)
	movb (%r10),%r9b
	movb %r9b,(%rdx)
	movq %r8,%rdx
	cmpb $92,%r9b
	jnz L18
L19:
	cmpl %edi,%esi
	jle L67
L24:
	movq _inptr(%rip),%r9
	movb (%r9),%dl
	cmpb $97,%dl
	jl L27
L29:
	cmpb $122,%dl
	jg L27
L26:
	movsbl %dl,%edx
	subl $32,%edx
	jmp L28
L27:
	movsbl %dl,%edx
L28:
	cmpl $10,%edx
	jz L36
	jl L33
L69:
	cmpl $84,%edx
	jz L42
	jg L33
L70:
	cmpb $48,%dl
	jz L48
L71:
	cmpb $66,%dl
	jz L44
L72:
	cmpb $78,%dl
	jz L40
L73:
	cmpb $82,%dl
	jz L46
L74:
	cmpb $83,%dl
	jnz L33
L38:
	movb $32,(%r8)
	jmp L78
L46:
	movb $13,(%r8)
	jmp L78
L40:
	movb $10,(%r8)
	jmp L78
L44:
	movb $8,(%r8)
	jmp L78
L48:
	movb $0,(%r8)
	movl $3,%r10d
L49:
	movq _inptr(%rip),%r9
	leaq 1(%r9),%rdx
	movq %rdx,_inptr(%rip)
	movb 1(%r9),%dl
	cmpb $48,%dl
	jl L79
L55:
	cmpb $55,%dl
	jg L79
L54:
	movb (%r8),%r9b
	shlb $3,%r9b
	subb $48,%dl
	orb %r9b,%dl
	movb %dl,(%r8)
	decl %r10d
	jnz L49
	jz L79
L42:
	movb $9,(%r8)
L78:
	leaq 1(%r8),%rdx
L77:
	incq _inptr(%rip)
	jmp L18
L33:
	leaq 1(%r9),%rdx
	movq %rdx,_inptr(%rip)
	movb (%r9),%dl
	movb %dl,(%r8)
	jmp L79
L36:
	movb $92,(%r8)
L79:
	leaq 1(%r8),%rdx
L18:
	incl %edi
L4:
	movq _inptr(%rip),%r10
	movb (%r10),%r9b
	cmpb %r9b,%cl
	jnz L12
L7:
	cmpl %edi,%esi
	jg L64
L67:
	xorl %eax,%eax
	ret
L64:
	movb $0,(%rdx)
L3:
	ret 


.globl _inptr
.globl _maksub
