.text

_dealias:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L4:
	movl $0,-24(%rbp)
	movl $0,-20(%rbp)
	movq $0,-16(%rbp)
	movq $_local_arena,-8(%rbp)
	movq _all_blocks(%rip),%r14
	jmp L7
L8:
	xorl %r13d,%r13d
L11:
	cmpl 12(%r14),%r13d
	jge L17
L15:
	movq 16(%r14),%rax
	movslq %r13d,%r13
	movq (%rax,%r13,8),%r12
	testq %r12,%r12
	jz L17
L16:
	cmpl $0,-24(%rbp)
	jl L26
L25:
	movl $0,-20(%rbp)
	jmp L27
L26:
	movl -20(%rbp),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq -24(%rbp),%rdi
	call _vector_insert
L27:
	xorl %edx,%edx
	leaq -24(%rbp),%rsi
	movq %r12,%rdi
	call _insn_uses
	xorl %ebx,%ebx
L28:
	movl -20(%rbp),%esi
	cmpl %esi,%ebx
	jge L34
L32:
	movq -16(%rbp),%rax
	movl (%rax,%rbx,4),%eax
	testl %eax,%eax
	jz L34
L33:
	movq _reg_to_symbol+8(%rip),%rcx
	andl $1073725440,%eax
	sarl $14,%eax
	subl $34,%eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rsi
	movb _g_flag(%rip),%cl
	movl 12(%rsi),%eax
	testb %cl,%cl
	jz L47
L46:
	testl $2097152,%eax
	jmp L103
L47:
	testl $128,%eax
L103:
	setz %al
	movzbl %al,%eax
	testl %eax,%eax
	jz L41
L42:
	movq 32(%rsi),%rax
	testq $262144,(%rax)
	jnz L41
L43:
	movl %r13d,%ecx
	movq %r14,%rdx
	movl $-1577058300,%edi
	call _loadstore
	addl %eax,%r13d
L41:
	incl %ebx
	jmp L28
L34:
	cmpl $0,-24(%rbp)
	jl L56
L55:
	movl $0,-20(%rbp)
	jmp L57
L56:
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq -24(%rbp),%rdi
	call _vector_insert
L57:
	xorl %edx,%edx
	leaq -24(%rbp),%rsi
	movq %r12,%rdi
	call _insn_defs
	xorl %ebx,%ebx
L58:
	cmpl -20(%rbp),%ebx
	jge L64
L62:
	movq -16(%rbp),%rax
	movl (%rax,%rbx,4),%eax
	testl %eax,%eax
	jz L64
L63:
	movq _reg_to_symbol+8(%rip),%rcx
	andl $1073725440,%eax
	sarl $14,%eax
	subl $34,%eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rsi
	movb _g_flag(%rip),%cl
	movl 12(%rsi),%eax
	testb %cl,%cl
	jz L77
L76:
	testl $2097152,%eax
	jmp L104
L77:
	testl $128,%eax
L104:
	setz %al
	movzbl %al,%eax
	testl %eax,%eax
	jz L71
L72:
	movq 32(%rsi),%rax
	testq $262144,(%rax)
	jnz L71
L73:
	leal 1(%r13),%ecx
	movq %r14,%rdx
	movl $553648133,%edi
	call _loadstore
	addl %eax,%r13d
L71:
	incl %ebx
	jmp L58
L64:
	incl %r13d
	jmp L11
L17:
	testl $1,4(%r14)
	jz L81
L82:
	movl 80(%r14),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L81
L83:
	movq _reg_to_symbol+8(%rip),%rcx
	movl 88(%r14),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	subl $34,%eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rsi
	movb _g_flag(%rip),%cl
	movl 12(%rsi),%eax
	testb %cl,%cl
	jz L97
L96:
	testl $2097152,%eax
	jmp L102
L97:
	testl $128,%eax
L102:
	setz %al
	movzbl %al,%eax
	testl %eax,%eax
	jz L81
L92:
	movq 32(%rsi),%rax
	testq $262144,(%rax)
	jnz L81
L93:
	movl %r13d,%ecx
	movq %r14,%rdx
	movl $-1577058300,%edi
	call _loadstore
L81:
	movq 112(%r14),%r14
L7:
	testq %r14,%r14
	jnz L8
L99:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L3:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L202:
	.quad 0xbff0000000000000

_deconst:
L105:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L106:
	movl $0,-12(%rbp) # spill
	movq _all_blocks(%rip),%rax
	jmp L204
L109:
	xorl %r14d,%r14d
L112:
	movq -24(%rbp),%rax # spill
	cmpl 12(%rax),%r14d
	jge L118
L116:
	movq -24(%rbp),%rax # spill
	movq 16(%rax),%rax
	movq (%rax,%r14,8),%rbx
	movq %rbx,%r13
	testq %rbx,%rbx
	jz L118
L117:
	cmpl $2684354572,(%rbx)
	jnz L122
L123:
	testl $229376,8(%rbx)
	jz L122
L124:
	xorl %esi,%esi
	movl $-1342177264,%edi
	call _new_insn
	movq %rax,%r13
	movl $32,%ecx
	leaq 8(%rbx),%rsi
	leaq 8(%r13),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq 40(%rbx),%rsi
	leaq 40(%r13),%rdi
	rep 
	movsb 
	movsd L202(%rip),%xmm0
	movsd %xmm0,-8(%rbp)
	movl 72(%r13),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,72(%r13)
	movq -8(%rbp),%rax
	movq %rax,88(%r13)
	movq $0,96(%r13)
	movl 8(%rbx),%ecx
	testl $4194272,%ecx
	jz L144
L142:
	shll $10,%ecx
	shrl $15,%ecx
	andl $131071,%ecx
	shll $5,%ecx
	movl 72(%r13),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,72(%r13)
L144:
	movq -24(%rbp),%rax # spill
	movq 16(%rax),%rax
	movq %r13,(%rax,%r14,8)
L122:
	xorl %r12d,%r12d
L145:
	movl (%r13),%ecx
	andl $805306368,%ecx
	sarl $28,%ecx
	movl 4(%r13),%eax
	shll $21,%eax
	shrl $26,%eax
	addl %eax,%ecx
	cmpl %ecx,%r12d
	jae L148
L146:
	movl %r12d,%ebx
	shlq $5,%rbx
	movl 8(%r13,%rbx),%edi
	movl %edi,%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L154
L152:
	testl $229376,%edi
	jz L154
L153:
	shll $10,%edi
	shrl $15,%edi
	movsd 24(%r13,%rbx),%xmm0
	call _floateral
	movq %rax,%r15
	movl %r14d,%ecx
	movq -24(%rbp),%rdx # spill
	movq %r15,%rsi
	movl $-1577058300,%edi
	call _loadstore
	movl 8(%r13,%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r13,%rbx)
	movq %r15,%rdi
	call _symbol_to_reg
	movl %eax,16(%r13,%rbx)
	jmp L203
L154:
	cmpl $2,%eax
	jnz L151
L163:
	testl $2121728,%edi
	jz L151
L164:
	movq 24(%r13,%rbx),%rax
	cmpq $-2147483648,%rax
	jl L168
L167:
	cmpq $2147483647,%rax
	jle L151
L168:
	movl $256,%edi
	call _temp_reg
	movl %eax,%r15d
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%rdi
	movl 8(%rdi),%ecx
	andl $4294967288,%ecx
	orl $1,%ecx
	movl %ecx,8(%rdi)
	movl %r15d,16(%rdi)
	movl $_long_type,%eax
	testq %rax,%rax
	jz L185
L177:
	movl _long_type(%rip),%eax
	andl $131071,%eax
	shll $5,%eax
	andl $4290773023,%ecx
	orl %eax,%ecx
	movl %ecx,8(%rdi)
L185:
	movl 40(%rdi),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,40(%rdi)
	movq 24(%r13,%rbx),%rax
	movq %rax,56(%rdi)
	movq $0,64(%rdi)
	movl $_long_type,%eax
	testq %rax,%rax
	jz L200
L192:
	movl _long_type(%rip),%ecx
	andl $131071,%ecx
	shll $5,%ecx
	movl 40(%rdi),%eax
	andl $4290773023,%eax
	orl %ecx,%eax
	movl %eax,40(%rdi)
L200:
	movl %r14d,%edx
	movq -24(%rbp),%rsi # spill
	call _insert_insn
	movl 8(%r13,%rbx),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r13,%rbx)
	movl %r15d,16(%r13,%rbx)
L203:
	incl -12(%rbp) # spill
L151:
	incl %r12d
	jmp L145
L148:
	incl %r14d
	jmp L112
L118:
	movq -24(%rbp),%rax # spill
	movq 112(%rax),%rax
L204:
	movq %rax,-24(%rbp) # spill
	cmpq $0,-24(%rbp) # spill
	jnz L109
L111:
	movl -12(%rbp),%eax # spill
L107:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl _temp_reg
.globl _all_blocks
.globl _reg_to_symbol
.globl _floateral
.globl _symbol_to_reg
.globl _long_type
.globl _loadstore
.globl _g_flag
.globl _dealias
.globl _local_arena
.globl _deconst
.globl _new_insn
.globl _vector_insert
.globl _insn_defs
.globl _insn_uses
.globl _insert_insn
