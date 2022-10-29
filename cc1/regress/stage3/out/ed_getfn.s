.local L4
.comm L4, 256, 1
.text

_getfn:
L1:
L2:
	movq _inptr(%rip),%rax
	cmpb $10,(%rax)
	jnz L6
L5:
	movl $1,_nofname(%rip)
	movl $_fname,%esi
	movl $L4,%edi
	call _strcpy
	jmp L7
L6:
	movl $0,_nofname(%rip)
L8:
	movq _inptr(%rip),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L12
L11:
	cmpb $9,%al
	jnz L13
L12:
	incq %rcx
	movq %rcx,_inptr(%rip)
	jmp L8
L13:
	movl $L4,%ecx
	jmp L15
L26:
	cmpb $10,%al
	jz L20
L27:
	cmpb $32,%al
	jz L20
L23:
	cmpb $9,%al
	jz L20
L19:
	leaq 1(%rdx),%rax
	movq %rax,_inptr(%rip)
	movb (%rdx),%al
	movb %al,(%rcx)
	incq %rcx
L15:
	movq _inptr(%rip),%rdx
	movb (%rdx),%al
	testb %al,%al
	jnz L26
L20:
	movb $0,(%rcx)
	movl $L4,%edi
	call _strlen
	testq %rax,%rax
	jz L30
L7:
	movl $L4,%edi
	call _strlen
	testq %rax,%rax
	jz L35
L37:
	movl $L4,%eax
	ret
L35:
	pushq $L38
	jmp L42
L30:
	pushq $L33
L42:
	call _printf
	addq $8,%rsp
	xorl %eax,%eax
L3:
	ret 

L33:
	.byte 98,97,100,32,102,105,108,101
	.byte 32,110,97,109,101,10,0
L38:
	.byte 110,111,32,102,105,108,101,32
	.byte 110,97,109,101,10,0
.globl _nofname
.comm _nofname, 4, 4

.globl _getfn
.globl _fname
.globl _printf
.globl _nofname
.globl _inptr
.globl _strlen
.globl _strcpy
