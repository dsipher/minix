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
	movl _start_symbol(%rip),%edx
L4:
	cmpl _nsyms(%rip),%edx
	jge L7
L5:
	movslq %edx,%rsi
	movq _derives(%rip),%rcx
	movq (%rcx,%rsi,8),%r8
	movswl (%r8),%esi
L8:
	cmpl $0,%esi
	jle L11
L9:
	movslq %esi,%rsi
	movq _rrhs(%rip),%rcx
	movswq (%rcx,%rsi,2),%rsi
	movq _ritem(%rip),%rcx
	movswl (%rcx,%rsi,2),%esi
	movl _start_symbol(%rip),%ecx
	cmpl %esi,%ecx
	jg L14
L12:
	subl %ecx,%esi
	movb %sil,%cl
	andb $31,%cl
	movl $1,%edi
	shll %cl,%edi
	sarl $5,%esi
	movslq %esi,%rsi
	orl %edi,(%rax,%rsi,4)
L14:
	leaq 2(%r8),%rcx
	movswl 2(%r8),%esi
	movq %rcx,%r8
	jmp L8
L11:
	movslq %ebx,%rcx
	leaq (%rax,%rcx,4),%rax
	incl %edx
	jmp L4
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
	movl %eax,%r12d
	movl $32,%ecx
	leal 31(%rdi),%eax
	cltd 
	idivl %ecx
	movl %eax,%ebx
	imull %r12d,%edi
	shll $2,%edi
	call _allocate
	movl _ntokens(%rip),%ecx
	imull %r12d,%ecx
	movslq %ecx,%rcx
	shlq $2,%rcx
	subq %rcx,%rax
	movq %rax,_first_derives(%rip)
	call _set_EFF
	movl _ntokens(%rip),%eax
	imull %r12d,%eax
	movslq %eax,%rax
	movq _first_derives(%rip),%rcx
	leaq (%rcx,%rax,4),%r9
	movl _start_symbol(%rip),%r8d
L18:
	movl _nsyms(%rip),%eax
	movq _EFF(%rip),%rdi
	cmpl %eax,%r8d
	jge L21
L19:
	movl %r8d,%eax
	subl _ntokens(%rip),%eax
	imull %ebx,%eax
	movslq %eax,%rax
	leaq (%rdi,%rax,4),%rsi
	movl $32,%edx
	movl _start_symbol(%rip),%eax
L22:
	cmpl %eax,_nsyms(%rip)
	jle L25
L23:
	cmpl $32,%edx
	jb L28
L26:
	movl (%rsi),%r13d
	addq $4,%rsi
	xorl %edx,%edx
L28:
	movb %dl,%cl
	movl $1,%edi
	shll %cl,%edi
	testl %r13d,%edi
	jz L31
L29:
	movslq %eax,%rdi
	movq _derives(%rip),%rcx
	movq (%rcx,%rdi,8),%r11
L32:
	movswl (%r11),%edi
	addq $2,%r11
	cmpl $0,%edi
	jl L31
L33:
	movb %dil,%cl
	andb $31,%cl
	movl $1,%r10d
	shll %cl,%r10d
	sarl $5,%edi
	movslq %edi,%rdi
	orl %r10d,(%r9,%rdi,4)
	jmp L32
L31:
	incl %edx
	incl %eax
	jmp L22
L25:
	movslq %r12d,%rax
	leaq (%r9,%rax,4),%r9
	incl %r8d
	jmp L18
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
	movslq %eax,%rcx
	movq _ruleset(%rip),%rdx
	leaq (%rdx,%rcx,4),%r9
L38:
	cmpq %r9,%rdx
	jae L41
L39:
	movl $0,(%rdx)
	addq $4,%rdx
	jmp L38
L41:
	movslq %esi,%rsi
	leaq (%rdi,%rsi,2),%r8
	movq %rdi,%r11
L42:
	cmpq %r11,%r8
	jbe L45
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
	jmp L42
L45:
	movq _itemset(%rip),%rax
	xorl %esi,%esi
	movq %rax,_itemsetend(%rip)
	movq _ruleset(%rip),%r10
L52:
	cmpq %r9,%r10
	jb L53
L80:
	cmpq %rdi,%r8
	jbe L37
L81:
	movw (%rdi),%cx
	movq _itemsetend(%rip),%rdx
	addq $2,%rdi
	leaq 2(%rdx),%rax
	movq %rax,_itemsetend(%rip)
	movw %cx,(%rdx)
	jmp L80
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
L66:
	cmpq %rdi,%r8
	jbe L68
L69:
	movw (%rdi),%r11w
	movswl %r11w,%ecx
	cmpl %ecx,%ebx
	jle L68
L67:
	movq _itemsetend(%rip),%r12
	addq $2,%rdi
	leaq 2(%r12),%rcx
	movq %rcx,_itemsetend(%rip)
	movw %r11w,(%r12)
	jmp L66
L68:
	movq _itemsetend(%rip),%r11
	leaq 2(%r11),%rcx
	movq %rcx,_itemsetend(%rip)
	movw %bx,(%r11)
L73:
	cmpq %rdi,%r8
	jbe L65
L76:
	movswl (%rdi),%ecx
	cmpl %ecx,%ebx
	jnz L65
L74:
	addq $2,%rdi
	jmp L73
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
	movslq %eax,%rax
	movq _first_derives(%rip),%rcx
	leaq (%rcx,%rax,4),%rdi
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
