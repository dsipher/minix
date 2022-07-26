.text

_vsprintf:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
L2:
	movl $-1,-28(%rbp)
	movl $262,-24(%rbp)
	movq %rdi,-16(%rbp)
	movq %rdi,-8(%rbp)
	movl $2147483647,-32(%rbp)
	leaq -32(%rbp),%rdi
	call _vfprintf
	movl $0,-32(%rbp)
	movq -8(%rbp),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,-8(%rbp)
	movb $0,(%rdx)
L3:
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _vsprintf
.globl ___flushbuf
.globl _vfprintf
