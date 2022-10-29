.text

_getrhs:
L1:
L2:
	movq _inptr(%rip),%rax
	cmpb $10,(%rax)
	jz L28
L7:
	cmpb $10,1(%rax)
	jz L28
L6:
	movl $256,%esi
	call _maksub
	testq %rax,%rax
	jnz L14
L28:
	movl $-2,%eax
	ret
L14:
	incq _inptr(%rip)
L16:
	movq _inptr(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L17
L19:
	cmpb $9,%al
	jnz L18
L17:
	incq %rcx
	movq %rcx,_inptr(%rip)
	jmp L16
L18:
	cmpb $103,%al
	jz L23
L25:
	xorl %eax,%eax
	ret
L23:
	incq %rcx
	movq %rcx,_inptr(%rip)
	movl $1,%eax
L3:
	ret 


.globl _getrhs
.globl _inptr
.globl _maksub
