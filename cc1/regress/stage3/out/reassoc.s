.text

_interior:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%r14
	movq %rcx,%r13
	movq 16(%r14),%rcx
	movslq %esi,%rax
	movq (%rcx,%rax,8),%rdi
	movslq %edx,%rcx
	shlq $5,%rcx
	movl 8(%rdi,%rcx),%r15d
	movl %r15d,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L36
L6:
	cmpl $3019898899,(%rdi)
	jnz L9
L8:
	shll $10,%r15d
	shrl $15,%r15d
	andl $131071,%r15d
	jmp L10
L9:
	movl $131071,%r15d
L10:
	movl %esi,%edx
	movl 16(%rcx,%rdi),%esi
	movq %r14,%rdi
	call _range_by_use
	movl %eax,%esi
	movq 296(%r14),%rcx
	movslq %esi,%rax
	leaq (%rax,%rax,2),%rax
	shlq $2,%rax
	movl (%rcx,%rax),%r12d
	cmpl $0,%r12d
	jl L36
L13:
	movq 16(%r14),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	xorl %ecx,%ecx
L18:
	movslq %ecx,%rax
	movl (%r13,%rax,4),%eax
	testl %eax,%eax
	jz L36
L19:
	cmpl (%rbx),%eax
	jz L22
L24:
	incl %ecx
	jmp L18
L22:
	movq %r14,%rdi
	call _range_use_count
	cmpl $1,%eax
	jnz L36
L29:
	movl 40(%rbx),%eax
	shll $10,%eax
	shrl $15,%eax
	testq %rax,%r15
	jz L36
L33:
	movl %r12d,%eax
	jmp L3
L36:
	movl $-3,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L116:
	.quad 0xbff0000000000000

_rollup:
L37:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L38:
	movl %edi,%r13d
	movl _terms+4(%rip),%r12d
	decl %r12d
L40:
	cmpl $1,%r12d
	jl L43
L41:
	movq _terms+8(%rip),%rcx
	movl %r12d,%eax
	decl %eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rbx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rsi
	cmpl $-1342177266,%r13d
	jz L48
L110:
	cmpl $-1342177264,%r13d
	jz L59
L111:
	cmpl $-1275068395,%r13d
	jz L86
L112:
	cmpl $-1275068394,%r13d
	jz L70
L113:
	cmpl $-1275068393,%r13d
	jnz L45
L78:
	movq 16(%rbx),%rcx
	movq 16(%rsi),%rax
	xorq %rcx,%rax
	jmp L117
L70:
	movq 16(%rbx),%rcx
	movq 16(%rsi),%rax
	orq %rcx,%rax
L117:
	movq %rax,16(%rbx)
	jmp L108
L86:
	movq 16(%rbx),%rcx
	movq 16(%rsi),%rax
	andq %rcx,%rax
	movq %rax,16(%rbx)
	movl $-1,%r14d
	jmp L45
L59:
	testl $229376,(%rbx)
	jz L63
L62:
	movsd 16(%rbx),%xmm1
	movsd 16(%rsi),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,16(%rbx)
	jmp L64
L63:
	movq 16(%rbx),%rcx
	movq 16(%rsi),%rax
	imulq %rcx,%rax
	movq %rax,16(%rbx)
L64:
	movl $1,%r14d
	jmp L45
L48:
	testl $229376,(%rbx)
	jz L52
L51:
	movsd 16(%rbx),%xmm1
	movsd 16(%rsi),%xmm0
	addsd %xmm1,%xmm0
	movsd %xmm0,16(%rbx)
	jmp L108
L52:
	movq 16(%rbx),%rcx
	addq 16(%rsi),%rcx
	movq %rcx,16(%rbx)
L108:
	xorl %r14d,%r14d
L45:
	movslq %r14d,%rax
	movq %rax,16(%rsi)
	movl (%rsi),%edi
	testl $229376,%edi
	jz L94
L93:
	cvtsi2sdq %rax,%xmm0
	movsd %xmm0,16(%rsi)
	jmp L95
L94:
	shll $10,%edi
	shrl $15,%edi
	addq $16,%rsi
	call _normalize_con
L95:
	movl (%rbx),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq 16(%rbx),%rsi
	call _normalize_con
	orl $2,_opt_request(%rip)
	decl %r12d
	jmp L40
L43:
	cmpl $0,_terms+4(%rip)
	jz L39
L96:
	movq _terms+8(%rip),%rax
	movq (%rax),%rax
	cmpl $0,_minuend(%rip)
	jz L39
L102:
	testl $229376,(%rax)
	jz L106
L105:
	movsd 16(%rax),%xmm1
	movsd L116(%rip),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,16(%rax)
	jmp L39
L106:
	negq 16(%rax)
L39:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 4
L126:
	.int -1342177266
	.int -1342177265
	.int 0
.text

_additive0:
L123:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L124:
	movq %rdi,-24(%rbp)
	movl %esi,%r15d
	movl %edx,%r14d
	movq -24(%rbp),%rax
	movq 16(%rax),%rcx
	movslq %r15d,%rax
	movq (%rcx,%rax,8),%r13
	cmpl $2952790031,(%r13)
	jnz L128
L127:
	movl %r14d,%r12d
	xorl $1,%r12d
	jmp L130
L128:
	movl %r14d,%r12d
L130:
	movb %r15b,%cl
	andb $63,%cl
	movl $1,%edx
	shlq %cl,%rdx
	movq _ineligible+8(%rip),%rcx
	movl %r15d,%eax
	sarl $6,%eax
	movslq %eax,%rax
	orq %rdx,(%rcx,%rax,8)
	leaq 40(%r13),%rax
	movq %rax,-16(%rbp)
	movl 40(%r13),%eax
	movl %eax,%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L141
L139:
	cmpq $0,64(%r13)
	jnz L141
L140:
	testl %r14d,%r14d
	jz L145
L146:
	testl $229376,%eax
	jz L150
L149:
	movsd 56(%r13),%xmm1
	movsd L116(%rip),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,56(%r13)
	jmp L145
L150:
	negq 56(%r13)
L145:
	cmpl $2952790031,(%r13)
	jnz L153
L152:
	movl $8,%ecx
	movl $1,%edx
	xorl %esi,%esi
	movl $_terms,%edi
	call _vector_insert
	movq _terms+8(%rip),%rcx
	movq -16(%rbp),%rax
	movq %rax,(%rcx)
	jmp L161
L153:
	movl _terms+4(%rip),%esi
	testl %esi,%esi
	setz %bl
	movzbl %bl,%ebx
	leal 1(%rsi),%eax
	cmpl _terms(%rip),%eax
	jge L159
L158:
	movl %eax,_terms+4(%rip)
	jmp L160
L159:
	movl $8,%ecx
	movl $1,%edx
	movl $_terms,%edi
	call _vector_insert
L160:
	movq _terms+8(%rip),%rdx
	movl _terms+4(%rip),%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq -16(%rbp),%rax
	movq %rax,(%rdx,%rcx,8)
	testl %ebx,%ebx
	jz L138
L161:
	movl %r14d,_minuend(%rip)
	jmp L138
L141:
	movl $L126,%ecx
	movl $1,%edx
	movl %r15d,%esi
	movq -24(%rbp),%rdi
	call _interior
	movl %eax,%esi
	cmpl $-3,%esi
	jz L138
L164:
	movl %r14d,%edx
	movq -24(%rbp),%rdi
	call _additive0
L138:
	leaq 72(%r13),%rax
	movq %rax,-8(%rbp)
	movl 72(%r13),%eax
	movl %eax,%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L175
L173:
	cmpq $0,96(%r13)
	jnz L175
L174:
	testl %r12d,%r12d
	jz L179
L180:
	testl $229376,%eax
	jz L184
L183:
	movsd 88(%r13),%xmm1
	movsd L116(%rip),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,88(%r13)
	jmp L179
L184:
	negq 88(%r13)
L179:
	movl _terms+4(%rip),%esi
	testl %esi,%esi
	setz %bl
	movzbl %bl,%ebx
	leal 1(%rsi),%eax
	cmpl _terms(%rip),%eax
	jge L193
L192:
	movl %eax,_terms+4(%rip)
	jmp L194
L193:
	movl $8,%ecx
	movl $1,%edx
	movl $_terms,%edi
	call _vector_insert
L194:
	movq _terms+8(%rip),%rdx
	movl _terms+4(%rip),%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq -8(%rbp),%rax
	movq %rax,(%rdx,%rcx,8)
	testl %ebx,%ebx
	jz L125
L195:
	movl %r12d,_minuend(%rip)
	jmp L125
L175:
	movl $L126,%ecx
	movl $2,%edx
	movl %r15d,%esi
	movq -24(%rbp),%rdi
	call _interior
	movl %eax,%esi
	cmpl $-3,%esi
	jz L125
L198:
	movl %r12d,%edx
	movq -24(%rbp),%rdi
	call _additive0
L125:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 4
L204:
	.int 0
	.int 0
.text

_commutative0:
L201:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L202:
	movq %rdi,%r14
	movl %esi,%r13d
	movl %edx,%r12d
	movq 16(%r14),%rcx
	movslq %r13d,%rax
	movq (%rcx,%rax,8),%rbx
	movl %r12d,L204(%rip)
	movb %r13b,%cl
	andb $63,%cl
	movl $1,%edx
	shlq %cl,%rdx
	movq _ineligible+8(%rip),%rcx
	movl %r13d,%eax
	sarl $6,%eax
	movslq %eax,%rax
	orq %rdx,(%rcx,%rax,8)
	leaq 40(%rbx),%r15
	movl 40(%rbx),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L216
L214:
	cmpq $0,64(%rbx)
	jnz L216
L215:
	movl _terms+4(%rip),%esi
	leal 1(%rsi),%eax
	cmpl _terms(%rip),%eax
	jge L222
L221:
	movl %eax,_terms+4(%rip)
	jmp L223
L222:
	movl $8,%ecx
	movl $1,%edx
	movl $_terms,%edi
	call _vector_insert
L223:
	movq _terms+8(%rip),%rcx
	movl _terms+4(%rip),%eax
	decl %eax
	movslq %eax,%rax
	movq %r15,(%rcx,%rax,8)
	jmp L213
L216:
	movl $L204,%ecx
	movl $1,%edx
	movl %r13d,%esi
	movq %r14,%rdi
	call _interior
	movl %eax,%esi
	cmpl $-3,%esi
	jz L213
L224:
	movl %r12d,%edx
	movq %r14,%rdi
	call _commutative0
L213:
	leaq 72(%rbx),%r15
	movl 72(%rbx),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L235
L233:
	cmpq $0,96(%rbx)
	jnz L235
L234:
	movl _terms+4(%rip),%esi
	leal 1(%rsi),%eax
	cmpl _terms(%rip),%eax
	jge L241
L240:
	movl %eax,_terms+4(%rip)
	jmp L242
L241:
	movl $8,%ecx
	movl $1,%edx
	movl $_terms,%edi
	call _vector_insert
L242:
	movq _terms+8(%rip),%rcx
	movl _terms+4(%rip),%eax
	decl %eax
	movslq %eax,%rax
	movq %r15,(%rcx,%rax,8)
	jmp L203
L235:
	movl $L204,%ecx
	movl $2,%edx
	movl %r13d,%esi
	movq %r14,%rdi
	call _interior
	movl %eax,%esi
	cmpl $-3,%esi
	jz L203
L243:
	movl %r12d,%edx
	movq %r14,%rdi
	call _commutative0
L203:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 4
L249:
	.int 0
	.int 0
.text

_shift0:
L246:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L247:
	movq %rdi,%r15
	movl %edx,%r14d
	movq 16(%r15),%rcx
	movslq %esi,%rax
	movq (%rcx,%rax,8),%r13
	movl %r14d,L249(%rip)
	movb %sil,%cl
	andb $63,%cl
	movl $1,%edx
	shlq %cl,%rdx
	movq _ineligible+8(%rip),%rcx
	movl %esi,%eax
	sarl $6,%eax
	movslq %eax,%rax
	orq %rdx,(%rcx,%rax,8)
	movl $L249,%ecx
	movl $1,%edx
	movq %r15,%rdi
	call _interior
	movl %eax,%r12d
	leaq 72(%r13),%rbx
	movl 72(%r13),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L255
L256:
	cmpq $0,96(%r13)
	jnz L255
L257:
	movl _terms+4(%rip),%esi
	leal 1(%rsi),%eax
	cmpl _terms(%rip),%eax
	jge L264
L263:
	movl %eax,_terms+4(%rip)
	jmp L265
L264:
	movl $8,%ecx
	movl $1,%edx
	movl $_terms,%edi
	call _vector_insert
L265:
	movq _terms+8(%rip),%rcx
	movl _terms+4(%rip),%eax
	decl %eax
	movslq %eax,%rax
	movq %rbx,(%rcx,%rax,8)
L255:
	cmpl $-3,%r12d
	jz L248
L266:
	movl %r14d,%edx
	movl %r12d,%esi
	movq %r15,%rdi
	call _shift0
L248:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L319:
	.short L307-_constant0
	.short L307-_constant0
	.short L304-_constant0
	.short L304-_constant0
	.short L304-_constant0

_constant0:
L269:
	pushq %rbx
	pushq %r12
	pushq %r13
L270:
	movq %rdi,%r12
	movl 12(%r12),%edx
	addl $63,%edx
	sarl $6,%edx
	cmpl _ineligible(%rip),%edx
	jg L279
L278:
	movl %edx,_ineligible+4(%rip)
	jmp L280
L279:
	movl _ineligible+4(%rip),%esi
	subl %esi,%edx
	movl $8,%ecx
	movl $_ineligible,%edi
	call _vector_insert
L280:
	movslq _ineligible+4(%rip),%rcx
	shlq $3,%rcx
	movq _ineligible+8(%rip),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	movl 12(%r12),%ebx
L281:
	movl %ebx,%eax
	decl %ebx
	testl %eax,%eax
	jz L271
L282:
	movq _ineligible+8(%rip),%rcx
	movl %ebx,%eax
	sarl $6,%eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rdx
	movb %bl,%cl
	andb $63,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L281
L287:
	movl $0,_minuend(%rip)
	cmpl $0,_terms(%rip)
	jl L293
L292:
	movl $0,_terms+4(%rip)
	jmp L294
L293:
	movl _terms+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	movl $_terms,%edi
	call _vector_insert
L294:
	movq 16(%r12),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rax
	movl (%rax),%r13d
	cmpl $-1275068397,%r13d
	jl L311
L313:
	cmpl $-1275068393,%r13d
	jg L311
L310:
	leal 1275068397(%r13),%eax
	movzwl L319(,%rax,2),%eax
	addl $_constant0,%eax
	jmp *%rax
L307:
	movl %r13d,%edx
	movl %ebx,%esi
	movq %r12,%rdi
	call _shift0
	jmp L309
L311:
	cmpl $-1342177266,%r13d
	jz L299
L315:
	cmpl $-1342177265,%r13d
	jz L299
L316:
	cmpl $-1342177264,%r13d
	jnz L281
L304:
	movl %r13d,%edx
	movl %ebx,%esi
	movq %r12,%rdi
	call _commutative0
	movl %r13d,%edi
	jmp L320
L299:
	xorl %edx,%edx
	movl %ebx,%esi
	movq %r12,%rdi
	call _additive0
L309:
	movl $-1342177266,%edi
L320:
	call _rollup
	jmp L281
L271:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_opt_lir_reassoc:
L321:
	pushq %rbx
L322:
	movl $1,%edi
	call _live_analyze
	movl $0,_ineligible(%rip)
	movl $0,_ineligible+4(%rip)
	movq $0,_ineligible+8(%rip)
	movq $_local_arena,_ineligible+16(%rip)
	movl $0,_terms(%rip)
	movl $0,_terms+4(%rip)
	movq $0,_terms+8(%rip)
	movq $_local_arena,_terms+16(%rip)
	movq _all_blocks(%rip),%rbx
L333:
	testq %rbx,%rbx
	jz L337
L334:
	movq %rbx,%rdi
	call _constant0
	movq 112(%rbx),%rbx
	jmp L333
L337:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L323:
	popq %rbx
	ret 

.local _ineligible
.comm _ineligible, 24, 8
.local _terms
.comm _terms, 24, 8
.local _minuend
.comm _minuend, 4, 4

.globl _all_blocks
.globl _range_use_count
.globl _opt_lir_reassoc
.globl _live_analyze
.globl _range_by_use
.globl _normalize_con
.globl _opt_request
.globl _local_arena
.globl _vector_insert
