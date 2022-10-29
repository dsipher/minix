.text

_getnum:
L1:
	pushq %rbx
L4:
	movq _inptr(%rip),%rax
	movb (%rax),%bl
	cmpb $32,%bl
	jz L5
L7:
	cmpb $9,%bl
	jnz L6
L5:
	incq %rax
	movq %rax,_inptr(%rip)
	jmp L4
L6:
	cmpb $48,%bl
	jl L13
L14:
	cmpb $57,%bl
	jg L13
L11:
	xorl %eax,%eax
L18:
	movq _inptr(%rip),%rdx
	movb (%rdx),%cl
	cmpb $48,%cl
	jl L3
L22:
	cmpb $57,%cl
	jg L3
L19:
	movsbl %cl,%ecx
	leal (%rax,%rax,4),%eax
	addl %eax,%eax
	addl %ecx,%eax
	subl $48,%eax
	incq %rdx
	movq %rdx,_inptr(%rip)
	jmp L18
L13:
	cmpb $36,%bl
	jz L32
L64:
	cmpb $39,%bl
	jz L49
L65:
	cmpb $43,%bl
	jz L44
L66:
	cmpb $45,%bl
	jz L44
L67:
	cmpb $46,%bl
	jz L30
L68:
	cmpb $47,%bl
	jz L35
L69:
	cmpb $63,%bl
	jz L35
L70:
	testl %edi,%edi
	movl $1,%ecx
	movl $-1,%eax
	cmovzl %ecx,%eax
	jmp L3
L35:
	call _optpat
	movq %rax,%rdi
	movq _inptr(%rip),%rax
	cmpb (%rax),%bl
	jnz L38
L36:
	incq %rax
	movq %rax,_inptr(%rip)
L38:
	cmpb $47,%bl
	movl $0,%eax
	movl $1,%esi
	cmovnzl %eax,%esi
	call _find
	jmp L3
L30:
	incq %rax
	movq %rax,_inptr(%rip)
	jmp L72
L44:
	testl %edi,%edi
	jz L46
L72:
	movl _curln(%rip),%eax
	jmp L3
L46:
	movl $1,%eax
	jmp L3
L49:
	leaq 1(%rax),%rcx
	movq %rcx,_inptr(%rip)
	movb 1(%rax),%al
	cmpb $97,%al
	jl L50
L53:
	cmpb $122,%al
	jle L52
L50:
	movl $-1,%eax
	jmp L3
L52:
	leaq 1(%rcx),%rax
	movq %rax,_inptr(%rip)
	movsbl (%rcx),%eax
	subl $97,%eax
	movslq %eax,%rax
	movl _mark(,%rax,4),%eax
	jmp L3
L32:
	incq %rax
	movq %rax,_inptr(%rip)
	movl _lastln(%rip),%eax
L3:
	popq %rbx
	ret 

.globl _mark
.comm _mark, 104, 4

.globl _lastln
.globl _getnum
.globl _mark
.globl _curln
.globl _find
.globl _inptr
.globl _optpat
