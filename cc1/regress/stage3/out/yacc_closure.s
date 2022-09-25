.text

_set_EFF:
L1:
	pushq %rbx
L2:
	movl _nvars(%rip),%edi
	movl $32,%ecx
	leal 31(%rdi),%eax
	cltd 
	idivl %ecx
	movl %eax,%ebx
	imull %ebx,%edi
	shll $2,%edi
	call _allocate
	movq %rax,_EFF(%rip)
	movl _start_symbol(%rip),%r8d
	jmp L4
L5:
	movslq %r8d,%r8
	movq _derives(%rip),%rcx
	movq (%rcx,%r8,8),%rdi
	movswl (%rdi),%edx
L8:
	cmpl $0,%edx
	jle L11
L9:
	movslq %edx,%rdx
	movq _rrhs(%rip),%rcx
	movswq (%rcx,%rdx,2),%rdx
	movq _ritem(%rip),%rcx
	movswl (%rcx,%rdx,2),%edx
	movl _start_symbol(%rip),%ecx
	cmpl %edx,%ecx
	jg L14
L12:
	subl %ecx,%edx
	movb %dl,%cl
	movl $1,%esi
	shll %cl,%esi
	sarl $5,%edx
	movslq %edx,%rdx
	orl %esi,(%rax,%rdx,4)
L14:
	leaq 2(%rdi),%rcx
	movswl 2(%rdi),%edx
	movq %rcx,%rdi
	jmp L8
L11:
	movslq %ebx,%rbx
	leaq (%rax,%rbx,4),%rax
	incl %r8d
L4:
	cmpl _nsyms(%rip),%r8d
	jl L5
L7:
	movl _nvars(%rip),%esi
	movq _EFF(%rip),%rdi
	call _reflexive_transitive_closure
L3:
	popq %rbx
	ret 


_set_first_derives:
L15:
	pushq %rbx
	pushq %r12
	pushq %r13
L16:
	movl _nrules(%rip),%eax
	movl _nvars(%rip),%edi
	movl $32,%ecx
	addl $31,%eax
	cltd 
	idivl %ecx
	movl %eax,%ebx
	movl $32,%ecx
	leal 31(%rdi),%eax
	cltd 
	idivl %ecx
	movl %eax,%r13d
	imull %ebx,%edi
	shll $2,%edi
	call _allocate
	movl _ntokens(%rip),%ecx
	imull %ebx,%ecx
	movslq %ecx,%rcx
	shlq $2,%rcx
	subq %rcx,%rax
	movq %rax,_first_derives(%rip)
	call _set_EFF
	movl _ntokens(%rip),%eax
	imull %ebx,%eax
	movslq %eax,%rax
	movq _first_derives(%rip),%rcx
	leaq (%rcx,%rax,4),%rdx
	movl _start_symbol(%rip),%eax
	jmp L18
L19:
	movl %eax,%ecx
	subl _ntokens(%rip),%ecx
	imull %r13d,%ecx
	movslq %ecx,%rcx
	leaq (%rdi,%rcx,4),%r11
	movl $32,%r10d
	movl _start_symbol(%rip),%r9d
L22:
	cmpl %r9d,_nsyms(%rip)
	jle L25
L23:
	cmpl $32,%r10d
	jb L28
L26:
	movl (%r11),%r12d
	addq $4,%r11
	xorl %r10d,%r10d
L28:
	movb %r10b,%cl
	movl $1,%esi
	shll %cl,%esi
	testl %r12d,%esi
	jz L31
L29:
	movslq %r9d,%r9
	movq _derives(%rip),%rcx
	movq (%rcx,%r9,8),%r8
L32:
	movswl (%r8),%esi
	addq $2,%r8
	cmpl $0,%esi
	jl L31
L33:
	movb %sil,%cl
	movl $1,%edi
	shll %cl,%edi
	sarl $5,%esi
	movslq %esi,%rsi
	orl %edi,(%rdx,%rsi,4)
	jmp L32
L31:
	incl %r10d
	incl %r9d
	jmp L22
L25:
	movslq %ebx,%rbx
	leaq (%rdx,%rbx,4),%rdx
	incl %eax
L18:
	movl _nsyms(%rip),%ecx
	movq _EFF(%rip),%rdi
	cmpl %ecx,%eax
	jl L19
L21:
	call _free
L17:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_closure:
L35:
	pushq %rbx
	pushq %r12
L36:
	movl _nrules(%rip),%eax
	movl $32,%ecx
	addl $31,%eax
	cltd 
	idivl %ecx
	movslq %eax,%rax
	movq _ruleset(%rip),%rcx
	leaq (%rcx,%rax,4),%r9
	jmp L38
L39:
	movl $0,(%rcx)
	addq $4,%rcx
L38:
	cmpq %r9,%rcx
	jb L39
L41:
	movslq %esi,%rcx
	leaq (%rdi,%rcx,2),%r8
	movq %rdi,%r11
	jmp L42
L43:
	movswq (%r11),%rdx
	movq _ritem(%rip),%rcx
	movswl (%rcx,%rdx,2),%edx
	cmpl _start_symbol(%rip),%edx
	jl L48
L46:
	imull %eax,%edx
	movslq %edx,%rdx
	movq _first_derives(%rip),%rcx
	leaq (%rcx,%rdx,4),%r10
	movq _ruleset(%rip),%rbx
L49:
	cmpq %r9,%rbx
	jae L48
L50:
	movl (%r10),%esi
	addq $4,%r10
	movq %rbx,%rdx
	movl (%rbx),%ecx
	addq $4,%rbx
	orl %esi,%ecx
	movl %ecx,(%rdx)
	jmp L49
L48:
	addq $2,%r11
L42:
	cmpq %r11,%r8
	ja L43
L45:
	movq _itemset(%rip),%rax
	xorl %esi,%esi
	movq %rax,_itemsetend(%rip)
	movq _ruleset(%rip),%r10
L52:
	cmpq %r9,%r10
	jb L53
	jae L80
L81:
	movw (%rdi),%cx
	movq _itemsetend(%rip),%rdx
	addq $2,%rdi
	leaq 2(%rdx),%rax
	movq %rax,_itemsetend(%rip)
	movw %cx,(%rdx)
L80:
	cmpq %rdi,%r8
	ja L81
L37:
	popq %r12
	popq %rbx
	ret 
L53:
	movl (%r10),%edx
	testl %edx,%edx
	jz L58
L56:
	xorl %eax,%eax
L60:
	movb %al,%cl
	movl $1,%r11d
	shll %cl,%r11d
	testl %edx,%r11d
	jz L65
L63:
	leal (%rax,%rsi),%r11d
	movq _rrhs(%rip),%rcx
	movswl (%rcx,%r11,2),%ebx
	jmp L66
L69:
	movswl (%rdi),%r11d
	cmpl %r11d,%ebx
	jle L68
L67:
	movq _itemsetend(%rip),%r12
	addq $2,%rdi
	leaq 2(%r12),%rcx
	movq %rcx,_itemsetend(%rip)
	movw %r11w,(%r12)
L66:
	cmpq %rdi,%r8
	ja L69
L68:
	movq _itemsetend(%rip),%r11
	leaq 2(%r11),%rcx
	movq %rcx,_itemsetend(%rip)
	movw %bx,(%r11)
	jmp L73
L76:
	movswl (%rdi),%ecx
	cmpl %ecx,%ebx
	jnz L65
L74:
	addq $2,%rdi
L73:
	cmpq %rdi,%r8
	ja L76
L65:
	incl %eax
	cmpl $32,%eax
	jb L60
L58:
	addl $32,%esi
	addq $4,%r10
	jmp L52


_finalize_closure:
L83:
L84:
	movq _itemset(%rip),%rdi
	call _free
	movq _ruleset(%rip),%rdi
	call _free
	movl _nrules(%rip),%eax
	movl $32,%ecx
	addl $31,%eax
	cltd 
	idivl %ecx
	imull _ntokens(%rip),%eax
	movslq %eax,%rcx
	movq _first_derives(%rip),%rax
	leaq (%rax,%rcx,4),%rdi
	call _free
L85:
	ret 

.globl _itemset
.comm _itemset, 8, 8
.globl _itemsetend
.comm _itemsetend, 8, 8
.globl _ruleset
.comm _ruleset, 8, 8
.local _first_derives
.comm _first_derives, 8, 8
.local _EFF
.comm _EFF, 8, 8

.globl _free
.globl _reflexive_transitive_closure
.globl _set_first_derives
.globl _closure
.globl _nsyms
.globl _finalize_closure
.globl _ntokens
.globl _rrhs
.globl _ruleset
.globl _allocate
.globl _start_symbol
.globl _nrules
.globl _itemset
.globl _ritem
.globl _itemsetend
.globl _nvars
.globl _derives
