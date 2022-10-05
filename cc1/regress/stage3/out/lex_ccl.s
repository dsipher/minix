.text

_ccladd:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L2:
	movl %edi,%r14d
	movl %esi,%r12d
	movslq %r14d,%rcx
	movq _ccllen(%rip),%rax
	movl (%rax,%rcx,4),%ebx
	movq _cclmap(%rip),%rax
	movl (%rax,%rcx,4),%r13d
	xorl %edx,%edx
	jmp L4
L5:
	leal (%r13,%rdx),%ecx
	movslq %ecx,%rcx
	movq _ccltbl(%rip),%rax
	movzbl (%rcx,%rax),%eax
	cmpl %eax,%r12d
	jz L3
L10:
	incl %edx
L4:
	cmpl %edx,%ebx
	jg L5
L7:
	movl _current_max_ccl_tbl_size(%rip),%esi
	addl %ebx,%r13d
	cmpl %esi,%r13d
	jl L14
L12:
	leal 250(%rsi),%eax
	movl %eax,_current_max_ccl_tbl_size(%rip)
	incl _num_reallocs(%rip)
	movl $1,%edx
	addl $250,%esi
	movq _ccltbl(%rip),%rdi
	call _reallocate_array
	movq %rax,_ccltbl(%rip)
L14:
	incl %ebx
	movslq %r14d,%r14
	movq _ccllen(%rip),%rax
	movl %ebx,(%rax,%r14,4)
	movslq %r13d,%r13
	movq _ccltbl(%rip),%rax
	movb %r12b,(%r13,%rax)
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_cclinit:
L15:
L16:
	movl _lastccl(%rip),%eax
	incl %eax
	movl %eax,_lastccl(%rip)
	movl _current_maxccls(%rip),%esi
	cmpl %esi,%eax
	jl L20
L18:
	leal 100(%rsi),%eax
	movl %eax,_current_maxccls(%rip)
	incl _num_reallocs(%rip)
	movl $4,%edx
	addl $100,%esi
	movq _cclmap(%rip),%rdi
	call _reallocate_array
	movq %rax,_cclmap(%rip)
	movl $4,%edx
	movl _current_maxccls(%rip),%esi
	movq _ccllen(%rip),%rdi
	call _reallocate_array
	movq %rax,_ccllen(%rip)
	movl $4,%edx
	movl _current_maxccls(%rip),%esi
	movq _cclng(%rip),%rdi
	call _reallocate_array
	movq %rax,_cclng(%rip)
L20:
	movl _lastccl(%rip),%ecx
	movq _cclmap(%rip),%rax
	cmpl $1,%ecx
	jnz L22
L21:
	movslq %ecx,%rcx
	movl $0,(%rax,%rcx,4)
	jmp L23
L22:
	movl %ecx,%edx
	decl %edx
	movslq %edx,%rdx
	movl (%rax,%rdx,4),%esi
	movq _ccllen(%rip),%rdi
	movl (%rdi,%rdx,4),%edx
	movslq %ecx,%rcx
	addl %edx,%esi
	movl %esi,(%rax,%rcx,4)
L23:
	movslq _lastccl(%rip),%rax
	movq _ccllen(%rip),%rcx
	movl $0,(%rcx,%rax,4)
	movslq _lastccl(%rip),%rax
	movq _cclng(%rip),%rcx
	movl $0,(%rcx,%rax,4)
	movl _lastccl(%rip),%eax
L17:
	ret 


_cclnegate:
L25:
L26:
	movslq %edi,%rcx
	movq _cclng(%rip),%rax
	movl $1,(%rax,%rcx,4)
L27:
	ret 


_list_character_set:
L28:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L29:
	movq %rdi,%r14
	movq %rsi,%r13
	decl (%r14)
	js L32
L31:
	movq 24(%r14),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r14)
	movb $91,(%rcx)
	jmp L33
L32:
	movq %r14,%rsi
	movl $91,%edi
	call ___flushbuf
L33:
	xorl %r12d,%r12d
	jmp L34
L35:
	cmpl $0,(%r13,%r12,4)
	jz L40
L38:
	movl %r12d,%ebx
	decl (%r14)
	js L42
L41:
	movq 24(%r14),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r14)
	movb $32,(%rcx)
	jmp L43
L42:
	movq %r14,%rsi
	movl $32,%edi
	call ___flushbuf
L43:
	movl %r12d,%edi
	call _readable_form
	movq %r14,%rsi
	movq %rax,%rdi
	call _fputs
L44:
	incl %r12d
	cmpl %r12d,_csize(%rip)
	jle L46
L47:
	movl %r12d,%eax
	cmpl $0,(%r13,%rax,4)
	jnz L44
L46:
	movl %r12d,%eax
	decl %eax
	cmpl %eax,%ebx
	jge L53
L51:
	leal -1(%r12),%edi
	call _readable_form
	pushq %rax
	pushq $L54
	pushq %r14
	call _fprintf
	addq $24,%rsp
L53:
	decl (%r14)
	js L56
L55:
	movq 24(%r14),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r14)
	movb $32,(%rcx)
	jmp L40
L56:
	movq %r14,%rsi
	movl $32,%edi
	call ___flushbuf
L40:
	incl %r12d
L34:
	cmpl _csize(%rip),%r12d
	jl L35
L37:
	decl (%r14)
	js L59
L58:
	movq 24(%r14),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r14)
	movb $93,(%rcx)
	jmp L30
L59:
	movq %r14,%rsi
	movl $93,%edi
	call ___flushbuf
L30:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L54:
	.byte 45,37,115,0

.globl _ccltbl
.globl _csize
.globl _current_maxccls
.globl _num_reallocs
.globl _cclmap
.globl _ccladd
.globl _cclinit
.globl ___flushbuf
.globl _cclnegate
.globl _list_character_set
.globl _reallocate_array
.globl _current_max_ccl_tbl_size
.globl _fputs
.globl _ccllen
.globl _lastccl
.globl _cclng
.globl _readable_form
.globl _fprintf
