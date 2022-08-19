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
	movq _all_blocks(%rip),%r12
L7:
	testq %r12,%r12
	jz L99
L8:
	xorl %ebx,%ebx
L11:
	cmpl 12(%r12),%ebx
	jge L17
L15:
	movq 16(%r12),%rax
	movslq %ebx,%rbx
	movq (%rax,%rbx,8),%r14
	testq %r14,%r14
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
	movq %r14,%rdi
	call _insn_uses
	xorl %r13d,%r13d
L28:
	movl -20(%rbp),%esi
	cmpl %esi,%r13d
	jge L34
L32:
	movq -16(%rbp),%rax
	movslq %r13d,%r13
	movl (%rax,%r13,4),%eax
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
	movl %ebx,%ecx
	movq %r12,%rdx
	movl $-1577058300,%edi
	call _loadstore
	addl %eax,%ebx
L41:
	incl %r13d
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
	movq %r14,%rdi
	call _insn_defs
	xorl %r13d,%r13d
L58:
	cmpl -20(%rbp),%r13d
	jge L64
L62:
	movq -16(%rbp),%rax
	movslq %r13d,%r13
	movl (%rax,%r13,4),%eax
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
	leal 1(%rbx),%ecx
	movq %r12,%rdx
	movl $553648133,%edi
	call _loadstore
	addl %eax,%ebx
L71:
	incl %r13d
	jmp L58
L64:
	incl %ebx
	jmp L11
L17:
	testl $1,4(%r12)
	jz L81
L82:
	movl 80(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L81
L83:
	movq _reg_to_symbol+8(%rip),%rcx
	movl 88(%r12),%eax
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
	movl %ebx,%ecx
	movq %r12,%rdx
	movl $-1577058300,%edi
	call _loadstore
L81:
	movq 112(%r12),%r12
	jmp L7
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
	movl $0,-20(%rbp)
	movq _all_blocks(%rip),%rax
L203:
	movq %rax,-16(%rbp)
	cmpq $0,-16(%rbp)
	jz L111
L109:
	xorl %r15d,%r15d
L112:
	movq -16(%rbp),%rax
	cmpl 12(%rax),%r15d
	jge L118
L116:
	movq -16(%rbp),%rax
	movq 16(%rax),%rax
	movslq %r15d,%r15
	movq (%rax,%r15,8),%r14
	testq %r14,%r14
	jz L118
L117:
	cmpl $2684354572,(%r14)
	jnz L122
L123:
	testl $229376,8(%r14)
	jz L122
L124:
	xorl %esi,%esi
	movl $-1342177264,%edi
	call _new_insn
	movl $32,%ecx
	leaq 8(%r14),%rsi
	leaq 8(%rax),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq 40(%r14),%rsi
	leaq 40(%rax),%rdi
	rep 
	movsb 
	movsd L202(%rip),%xmm0
	movsd %xmm0,-8(%rbp)
	movl 72(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,72(%rax)
	movq -8(%rbp),%rcx
	movq %rcx,88(%rax)
	movq $0,96(%rax)
	movl 8(%r14),%edx
	testl $4194272,%edx
	jz L144
L142:
	shll $10,%edx
	shrl $15,%edx
	andl $131071,%edx
	shll $5,%edx
	movl 72(%rax),%ecx
	andl $4290773023,%ecx
	orl %edx,%ecx
	movl %ecx,72(%rax)
L144:
	movq %rax,%r14
	movq -16(%rbp),%rcx
	movq 16(%rcx),%rcx
	movq %rax,(%rcx,%r15,8)
L122:
	xorl %r13d,%r13d
L145:
	movl (%r14),%ecx
	andl $805306368,%ecx
	sarl $28,%ecx
	movl 4(%r14),%eax
	shll $21,%eax
	shrl $26,%eax
	addl %eax,%ecx
	cmpl %ecx,%r13d
	jae L148
L146:
	movslq %r13d,%r12
	shlq $5,%r12
	movl 8(%r14,%r12),%edi
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
	movsd 24(%r14,%r12),%xmm0
	call _floateral
	movq %rax,%rbx
	movl %r15d,%ecx
	movq -16(%rbp),%rdx
	movq %rbx,%rsi
	movl $-1577058300,%edi
	call _loadstore
	movl 8(%r14,%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r14,%r12)
	movq %rbx,%rdi
	call _symbol_to_reg
	movl %eax,16(%r14,%r12)
	jmp L204
L154:
	cmpl $2,%eax
	jnz L151
L163:
	testl $2121728,%edi
	jz L151
L164:
	movq 24(%r14,%r12),%rax
	cmpq $-2147483648,%rax
	jl L168
L167:
	cmpq $2147483647,%rax
	jle L151
L168:
	movl $256,%edi
	call _temp_reg
	movl %eax,%ebx
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movl 8(%rax),%edx
	andl $4294967288,%edx
	orl $1,%edx
	movl %edx,8(%rax)
	movl %ebx,16(%rax)
	movl $_long_type,%ecx
	testq %rcx,%rcx
	jz L185
L177:
	movq _long_type(%rip),%rcx
	andl $131071,%ecx
	shll $5,%ecx
	andl $4290773023,%edx
	orl %ecx,%edx
	movl %edx,8(%rax)
L185:
	movl 40(%rax),%ecx
	andl $4294967288,%ecx
	orl $2,%ecx
	movl %ecx,40(%rax)
	movq 24(%r14,%r12),%rcx
	movq %rcx,56(%rax)
	movq $0,64(%rax)
	movl $_long_type,%ecx
	testq %rcx,%rcx
	jz L200
L192:
	movq _long_type(%rip),%rdx
	andl $131071,%edx
	shll $5,%edx
	movl 40(%rax),%ecx
	andl $4290773023,%ecx
	orl %edx,%ecx
	movl %ecx,40(%rax)
L200:
	movl %r15d,%edx
	movq -16(%rbp),%rsi
	movq %rax,%rdi
	call _insert_insn
	movl 8(%r14,%r12),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,8(%r14,%r12)
	movl %ebx,16(%r14,%r12)
L204:
	incl -20(%rbp)
L151:
	incl %r13d
	jmp L145
L148:
	incl %r15d
	jmp L112
L118:
	movq -16(%rbp),%rax
	movq 112(%rax),%rax
	jmp L203
L111:
	movl -20(%rbp),%eax
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
