.text

_addsym:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%r15
	movq %rsi,-8(%rbp)
	movl %edx,%r14d
	movq %rcx,%r13
	movl %r8d,%esi
	movq %r15,%rdi
	call _hashfunct
	movl %eax,%ebx
	movslq %ebx,%rax
	movq (%r13,%rax,8),%r12
L4:
	testq %r12,%r12
	jz L6
L5:
	movq 16(%r12),%rsi
	movq %r15,%rdi
	call _strcmp
	testl %eax,%eax
	jz L7
L9:
	movq 8(%r12),%r12
	jmp L4
L7:
	movl $-1,%eax
	jmp L3
L6:
	movl $40,%edi
	call _malloc
	movq %rax,%r12
	testq %r12,%r12
	jnz L13
L11:
	movl $L14,%edi
	call _flexfatal
L13:
	movslq %ebx,%rbx
	movq (%r13,%rbx,8),%rax
	testq %rax,%rax
	jz L16
L15:
	movq %rax,8(%r12)
	movq %r12,(%rax)
	jmp L17
L16:
	movq $0,8(%r12)
L17:
	movq $0,(%r12)
	movq %r15,16(%r12)
	movq -8(%rbp),%rax
	movq %rax,24(%r12)
	movl %r14d,32(%r12)
	movq %r12,(%r13,%rbx,8)
	xorl %eax,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cclinstal:
L19:
	pushq %rbx
L20:
	movl %esi,%ebx
	call _copy_unsigned_string
	movl $101,%r8d
	movl $_ccltab,%ecx
	movl %ebx,%edx
	xorl %esi,%esi
	movq %rax,%rdi
	call _addsym
L21:
	popq %rbx
	ret 


_ccllookup:
L22:
L23:
	movl $101,%edx
	movl $_ccltab,%esi
	call _findsym
	movl 32(%rax),%eax
L24:
	ret 

.data
.align 8
L29:
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.int 0
	.fill 4, 1, 0
.text

_findsym:
L26:
	pushq %rbx
	pushq %r12
L27:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl %edx,%esi
	movq %r12,%rdi
	call _hashfunct
	movslq %eax,%rax
	movq (%rbx,%rax,8),%rbx
L30:
	testq %rbx,%rbx
	jz L32
L31:
	movq 16(%rbx),%rsi
	movq %r12,%rdi
	call _strcmp
	testl %eax,%eax
	jz L33
L35:
	movq 8(%rbx),%rbx
	jmp L30
L33:
	movq %rbx,%rax
	jmp L28
L32:
	movl $L29,%eax
L28:
	popq %r12
	popq %rbx
	ret 


_hashfunct:
L38:
L39:
	xorl %edx,%edx
	xorl %ecx,%ecx
	jmp L41
L42:
	incl %ecx
	movsbl %al,%eax
	leal (%rax,%rdx,2),%eax
	cltd 
	idivl %esi
L41:
	movslq %ecx,%rcx
	movb (%rcx,%rdi),%al
	testb %al,%al
	jnz L42
L43:
	movl %edx,%eax
L40:
	ret 


_ndinstal:
L45:
	pushq %rbx
	pushq %r12
L46:
	movq %rsi,%r12
	call _copy_string
	movq %rax,%rbx
	movq %r12,%rdi
	call _copy_unsigned_string
	movl $101,%r8d
	movl $_ndtbl,%ecx
	xorl %edx,%edx
	movq %rax,%rsi
	movq %rbx,%rdi
	call _addsym
	testl %eax,%eax
	jz L47
L48:
	movl $L51,%edi
	call _synerr
L47:
	popq %r12
	popq %rbx
	ret 


_ndlookup:
L52:
L53:
	movl $101,%edx
	movl $_ndtbl,%esi
	call _findsym
	movq 24(%rax),%rax
L54:
	ret 


_scinstal:
L56:
	pushq %rbx
	pushq %r12
L57:
	movq %rdi,%r12
	movl %esi,%ebx
	movl $L62,%esi
	movq %r12,%rdi
	call _strcmp
	testl %eax,%eax
	jz L61
L59:
	movl _lastsc(%rip),%eax
	pushq %rax
	pushq %r12
	pushq $L63
	call _printf
	addq $24,%rsp
L61:
	movl _lastsc(%rip),%eax
	incl %eax
	movl %eax,_lastsc(%rip)
	movl _current_max_scs(%rip),%esi
	cmpl %esi,%eax
	jl L66
L64:
	leal 40(%rsi),%eax
	movl %eax,_current_max_scs(%rip)
	incl _num_reallocs(%rip)
	movl $4,%edx
	addl $40,%esi
	movq _scset(%rip),%rdi
	call _reallocate_array
	movq %rax,_scset(%rip)
	movl $4,%edx
	movl _current_max_scs(%rip),%esi
	movq _scbol(%rip),%rdi
	call _reallocate_array
	movq %rax,_scbol(%rip)
	movl $4,%edx
	movl _current_max_scs(%rip),%esi
	movq _scxclu(%rip),%rdi
	call _reallocate_array
	movq %rax,_scxclu(%rip)
	movl $4,%edx
	movl _current_max_scs(%rip),%esi
	movq _sceof(%rip),%rdi
	call _reallocate_array
	movq %rax,_sceof(%rip)
	movl $8,%edx
	movl _current_max_scs(%rip),%esi
	movq _scname(%rip),%rdi
	call _reallocate_array
	movq %rax,_scname(%rip)
	movl $4,%edx
	movl _current_max_scs(%rip),%esi
	movq _actvsc(%rip),%rdi
	call _reallocate_array
	movq %rax,_actvsc(%rip)
L66:
	movq %r12,%rdi
	call _copy_string
	movslq _lastsc(%rip),%rcx
	movq _scname(%rip),%rdx
	movq %rax,(%rdx,%rcx,8)
	movl _lastsc(%rip),%edx
	movslq %edx,%rax
	movq _scname(%rip),%rdi
	movl $101,%r8d
	movl $_sctbl,%ecx
	xorl %esi,%esi
	movq (%rdi,%rax,8),%rdi
	call _addsym
	testl %eax,%eax
	jz L69
L67:
	movq %r12,%rsi
	movl $L70,%edi
	call _format_pinpoint_message
L69:
	movl $257,%edi
	call _mkstate
	movslq _lastsc(%rip),%rcx
	movq _scset(%rip),%rdx
	movl %eax,(%rdx,%rcx,4)
	movl $257,%edi
	call _mkstate
	movslq _lastsc(%rip),%rcx
	movq _scbol(%rip),%rdx
	movl %eax,(%rdx,%rcx,4)
	movslq _lastsc(%rip),%rax
	movq _scxclu(%rip),%rcx
	movl %ebx,(%rcx,%rax,4)
	movslq _lastsc(%rip),%rax
	movq _sceof(%rip),%rcx
	movl $0,(%rcx,%rax,4)
L58:
	popq %r12
	popq %rbx
	ret 


_sclookup:
L71:
L72:
	movl $101,%edx
	movl $_sctbl,%esi
	call _findsym
	movl 32(%rax),%eax
L73:
	ret 

L51:
	.byte 110,97,109,101,32,100,101,102
	.byte 105,110,101,100,32,116,119,105
	.byte 99,101,0
L63:
	.byte 35,100,101,102,105,110,101,32
	.byte 37,115,32,37,100,10,0
L14:
	.byte 115,121,109,98,111,108,32,116
	.byte 97,98,108,101,32,109,101,109
	.byte 111,114,121,32,97,108,108,111
	.byte 99,97,116,105,111,110,32,102
	.byte 97,105,108,101,100,0
L70:
	.byte 115,116,97,114,116,32,99,111
	.byte 110,100,105,116,105,111,110,32
	.byte 37,115,32,100,101,99,108,97
	.byte 114,101,100,32,116,119,105,99
	.byte 101,0
L62:
	.byte 48,0
.globl _ndtbl
.comm _ndtbl, 808, 8
.globl _sctbl
.comm _sctbl, 808, 8
.globl _ccltab
.comm _ccltab, 808, 8

.globl _actvsc
.globl _ccllookup
.globl _copy_unsigned_string
.globl _malloc
.globl _num_reallocs
.globl _hashfunct
.globl _ndinstal
.globl _findsym
.globl _current_max_scs
.globl _sclookup
.globl _flexfatal
.globl _printf
.globl _synerr
.globl _format_pinpoint_message
.globl _strcmp
.globl _scname
.globl _sceof
.globl _cclinstal
.globl _mkstate
.globl _reallocate_array
.globl _lastsc
.globl _ndtbl
.globl _addsym
.globl _copy_string
.globl _scinstal
.globl _scset
.globl _ndlookup
.globl _scbol
.globl _sctbl
.globl _ccltab
.globl _scxclu
