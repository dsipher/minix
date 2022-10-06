.text

_promote:
L1:
	pushq %rbx
L2:
	movq %rdi,%rbx
	movq 8(%rbx),%rdi
	movq (%rdi),%rax
	testq $32768,%rax
	jz L5
L4:
	movq %rdi,%rdx
	jmp L36
L5:
	testq $16384,%rax
	jz L8
L7:
	movq 24(%rdi),%rdx
L36:
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	jmp L35
L8:
	testq $14,%rax
	jnz L14
L13:
	testq $48,%rax
	jz L15
L14:
	movq %rbx,%rdx
	movl $_int_type,%esi
	jmp L37
L15:
	testl %esi,%esi
	jz L22
L20:
	testq $1024,%rax
	jz L22
L21:
	movq %rbx,%rdx
	movl $_double_type,%esi
L37:
	movl $1073741830,%edi
L35:
	call _unary_tree
	movq %rax,%rbx
	jmp L6
L22:
	testq $393216,%rax
	jz L6
L30:
	testq $8192,%rax
	jnz L6
L31:
	call _unqualify
	movq %rax,8(%rbx)
L6:
	movq %rbx,%rax
L3:
	popq %rbx
	ret 


_scale:
L38:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L39:
	movq %rdi,%r13
	movq 16(%r13),%r12
	movq 24(%r13),%rbx
	movq 8(%r12),%rax
	testq $65536,(%rax)
	jz L48
L41:
	xorl %esi,%esi
	movq 24(%rax),%rdi
	call _size_of
	movslq %eax,%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_long_type,%edi
	call _con_tree
	movq %rax,%r14
	movq 8(%rbx),%rax
	testq $65536,(%rax)
	jnz L45
L44:
	movq %rbx,%rdx
	movl $_long_type,%esi
	movl $1073741830,%edi
	call _unary_tree
	movq %r14,%rcx
	movq %rax,%rdx
	movl $_long_type,%esi
	movl $536870937,%edi
	call _binary_tree
	movq %rax,24(%r13)
	movq 8(%r12),%rax
L48:
	movq %rax,8(%r13)
	jmp L43
L45:
	movq $_long_type,8(%r13)
	movq %r14,%rcx
	movq %r13,%rdx
	movl $_long_type,%esi
	movl $23,%edi
	call _binary_tree
	movq %rax,%r13
L43:
	movq %r13,%rax
L40:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_null0:
L49:
	pushq %rbx
L50:
	movq %rdi,%rax
	movq %rsi,%rbx
	movq 8(%rbx),%rcx
	testq $65536,(%rcx)
	jz L51
L55:
	movq 8(%rax),%rcx
	testq $1022,(%rcx)
	jz L51
L52:
	movq %rax,%rdi
	call _fold
	movq %rax,%rdx
	movq %rdx,%rax
	cmpl $2147483650,(%rdx)
	jnz L51
L70:
	cmpq $0,24(%rdx)
	jnz L51
L66:
	movq 8(%rdx),%rcx
	testq $1022,(%rcx)
	jz L51
L62:
	cmpq $0,16(%rdx)
	jnz L51
L59:
	movq 8(%rbx),%rsi
	movl $1073741830,%edi
	call _unary_tree
L51:
	popq %rbx
	ret 

.data
.align 4
_map:
	.int 11
	.int 2
	.int 3
	.int 1300
	.int 134217740
	.int 2
	.int 1
	.int 64
	.int 134217741
	.int 2
	.int 1
	.int 64
	.int 134217742
	.int 0
	.int 1
	.int 64
	.int 134217743
	.int 1
	.int 2
	.int 4160
	.int 134217744
	.int 1
	.int 2
	.int 4160
	.int 17
	.int 0
	.int 1
	.int 2048
	.int 18
	.int 0
	.int 1
	.int 2048
	.int 19
	.int 0
	.int 1
	.int 16
	.int 20
	.int 0
	.int 1
	.int 16
	.int 21
	.int 0
	.int 1
	.int 16
	.int 536870942
	.int 0
	.int 1
	.int 33
	.int 23
	.int 2
	.int 1
	.int 33
	.int 536870937
	.int 2
	.int 1
	.int 33
	.int 536870938
	.int 1
	.int 2
	.int 4129
	.int 27
	.int 1
	.int 3
	.int 4129
	.int 35
	.int 2
	.int 2
	.int 8225
	.int 28
	.int 0
	.int 1
	.int 2049
	.int 36
	.int 2
	.int 2
	.int 8225
	.int 38
	.int 2
	.int 2
	.int 8225
	.int 29
	.int 0
	.int 1
	.int 2049
	.int 37
	.int 2
	.int 2
	.int 8225
	.int 536870943
	.int 0
	.int 1
	.int 33
	.int 40
	.int 0
	.int 1
	.int 8201
	.int 536870945
	.int 2
	.int 2
	.int 8615
	.int 536870946
	.int 2
	.int 2
	.int 8615
	.int 536870944
	.int 0
	.int 1
	.int 33
	.int 39
	.int 0
	.int 1
	.int 8201
	.int 24
	.int 0
	.int 1
	.int 33
	.int 42
	.int 2
	.int 4
	.int 1575
.align 8
_operands:
	.quad 1022
	.quad 1022
	.quad 65536
	.quad 1022
	.quad 8190
	.quad 8190
	.quad 65536
	.quad 65536
	.quad 8192
	.quad 8192
	.quad 1
	.quad 1
.text

_usuals:
L75:
	pushq %rbx
	pushq %r12
L76:
	movq %rdi,%r12
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	movq (%rax),%rax
	andl $131071,%eax
	movq 24(%r12),%rcx
	movq 8(%rcx),%rcx
	movq (%rcx),%rcx
	andl $131071,%ecx
	cmpq %rcx,%rax
	movq %rax,%rbx
	cmovleq %rcx,%rbx
	testl $32,%esi
	jz L90
L84:
	testq %rbx,%rax
	jnz L90
L87:
	xorl %edx,%edx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _get_tnode
	movq 16(%r12),%rdx
	movq %rax,%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,16(%r12)
L90:
	movq 16(%r12),%rax
	movq 8(%rax),%rdi
	movq (%rdi),%rax
	testq $393216,%rax
	jz L95
L96:
	testq $8192,%rax
	jnz L95
L97:
	call _unqualify
	movq 16(%r12),%rcx
	movq %rax,8(%rcx)
L95:
	movq 24(%r12),%rax
	movq 8(%rax),%rax
	movq (%rax),%rax
	andl $131071,%eax
	testq %rbx,%rax
	jnz L105
L103:
	xorl %edx,%edx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _get_tnode
	movq 24(%r12),%rdx
	movq %rax,%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%r12)
L105:
	movq 24(%r12),%rax
	movq 8(%rax),%rdi
	movq (%rdi),%rax
	testq $393216,%rax
	jz L77
L112:
	testq $8192,%rax
	jnz L77
L113:
	call _unqualify
	movq 24(%r12),%rcx
	movq %rax,8(%rcx)
L77:
	popq %r12
	popq %rbx
	ret 


_build_tree:
L116:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L117:
	movl %edi,-12(%rbp)
	movq %rsi,%r14
	movl -12(%rbp),%ebx
	andl $520093696,%ebx
	sarl $24,%ebx
	shlq $4,%rbx
	movl _map+12(%rbx),%r13d
	xorl %esi,%esi
	movq %rdx,%rdi
	call _promote
	movq %rax,%r12
	testl $1,%r13d
	jz L121
L119:
	xorl %esi,%esi
	movq %r14,%rdi
	call _promote
	movq %rax,%r14
L121:
	testl $2,%r13d
	jz L124
L122:
	movq %r12,%rsi
	movq %r14,%rdi
	call _null0
	movq %rax,%r14
L124:
	testl $4,%r13d
	jz L127
L125:
	movq %r14,%rsi
	movq %r12,%rdi
	call _null0
	movq %rax,%r12
L127:
	movq %r12,%rcx
	movq %r14,%rdx
	xorl %esi,%esi
	movl _map(%rbx),%edi
	call _binary_tree
	movq %rax,%r12
	cmpl $536870938,(%r12)
	jnz L133
L134:
	movq 24(%r12),%rcx
	movq 8(%rcx),%rax
	testq $65536,(%rax)
	jz L133
L135:
	movq 16(%r12),%rax
	movq %rcx,16(%r12)
	movq %rax,24(%r12)
L133:
	testl $8,%r13d
	jz L142
L141:
	movl -12(%rbp),%edx
	movl $426770485,%esi
	movq 24(%r12),%rdi
	call _test
	movq %rax,24(%r12)
	movl -12(%rbp),%edx
	movl $426770485,%esi
	movq 16(%r12),%rdi
	call _test
	movq %rax,16(%r12)
	jmp L143
L142:
	movl _map+8(%rbx),%edi
	movl _map+4(%rbx),%esi
	xorl %edx,%edx
	jmp L144
L145:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	movq (%rax),%rax
	andl $131071,%eax
	leal (%rdx,%rsi),%ecx
	movslq %ecx,%rcx
	shlq $4,%rcx
	testq %rax,_operands(%rcx)
	jz L153
L151:
	movq 24(%r12),%rax
	movq 8(%rax),%rax
	movq (%rax),%rax
	andl $131071,%eax
	testq %rax,_operands+8(%rcx)
	jnz L147
L153:
	incl %edx
L144:
	cmpl %edx,%edi
	jg L145
L147:
	cmpl %edx,%edi
	jz L159
L143:
	movq 16(%r12),%rax
	movq 8(%rax),%rdx
	testq $65536,(%rdx)
	jz L163
L164:
	movq 24(%r12),%rax
	movq 8(%rax),%rcx
	testq $65536,(%rcx)
	jz L163
L165:
	movq 24(%rdx),%rax
	movq (%rax),%rbx
	andl $393216,%ebx
	movq 24(%rcx),%rax
	movq (%rax),%r14
	andl $393216,%r14d
	cmpl $11,(%r12)
	jnz L176
L171:
	movq %rbx,%rax
	andq %r14,%rax
	cmpq %rax,%r14
	jz L176
L172:
	xorq %r14,%rax
	pushq %rax
	movl -12(%rbp),%eax
	pushq %rax
	pushq $L175
	pushq $0
	pushq $4
	call _error
	addq $40,%rsp
L176:
	movq 16(%r12),%rcx
	movq 8(%rcx),%rax
	testq $65536,(%rax)
	jz L181
L182:
	movq 24(%rax),%rax
	testq $1,(%rax)
	jz L181
L183:
	testl $128,%r13d
	jz L187
L186:
	movq 24(%r12),%rax
	movq 8(%rax),%rax
	jmp L252
L187:
	testl $1024,%r13d
	jz L181
L189:
	movq %r14,%rsi
	movl $_void_type,%edi
	call _qualify
	movq %rax,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq 24(%r12),%rcx
L252:
	movq %rax,8(%rcx)
L181:
	movq 24(%r12),%rcx
	movq 8(%rcx),%rax
	testq $65536,(%rax)
	jz L197
L198:
	movq 24(%rax),%rax
	testq $1,(%rax)
	jz L197
L199:
	testl $256,%r13d
	jz L203
L202:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	jmp L251
L203:
	testl $512,%r13d
	jz L197
L205:
	movq %rbx,%rsi
	movl $_void_type,%edi
	call _qualify
	movq %rax,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq 16(%r12),%rcx
L251:
	movq %rax,8(%rcx)
L197:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rdi
	call _unqualify
	movq %rax,%r15
	movq 24(%r12),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rdi
	call _unqualify
	movq %rax,%rsi
	movq %r15,%rdi
	call _compat
	testl %eax,%eax
	jz L159
L210:
	cmpl $42,(%r12)
	jnz L163
L212:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rdi
	call _unqualify
	movq %rax,%r15
	movq 24(%r12),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rdi
	call _unqualify
	xorl %edx,%edx
	movq %rax,%rsi
	movq %r15,%rdi
	call _compose
	orq %rbx,%r14
	movq %r14,%rsi
	movq %rax,%rdi
	call _qualify
	movq %rax,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq 16(%r12),%rcx
	movq %rax,8(%rcx)
	movq 24(%r12),%rcx
	movq %rax,8(%rcx)
L163:
	movq 16(%r12),%rax
	movq 8(%rax),%rsi
	movq (%rsi),%rdx
	testq $8192,%rdx
	jz L220
L222:
	movq 24(%r12),%rax
	movq 8(%rax),%rcx
	testq $8192,(%rcx)
	jz L220
L223:
	movq 16(%rsi),%rax
	cmpq 16(%rcx),%rax
	jz L220
L159:
	movl -12(%rbp),%eax
	pushq %rax
	pushq $L250
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
	jmp L118
L220:
	testq $8190,%rdx
	jz L229
L230:
	movq 24(%r12),%rax
	movq 8(%rax),%rax
	testq $8190,(%rax)
	jz L229
L231:
	testl $96,%r13d
	jz L236
L234:
	movl %r13d,%esi
	movq %r12,%rdi
	call _usuals
L236:
	testl $16,%r13d
	jz L229
L237:
	movq 16(%r12),%rax
	movq 8(%rax),%rsi
	movq 24(%r12),%rdx
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%r12)
L229:
	testl $2048,%r13d
	jz L242
L240:
	movq 24(%r12),%rdx
	movl $_char_type,%esi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%r12)
L242:
	testl $8192,%r13d
	jz L244
L243:
	movq $_int_type,8(%r12)
	jmp L245
L244:
	testl $4096,%r13d
	jz L247
L246:
	movq %r12,%rdi
	call _scale
	movq %rax,%r12
	jmp L245
L247:
	movq 16(%r12),%rax
	movq 8(%rax),%rax
	movq %rax,8(%r12)
L245:
	movq %r12,-8(%rbp)
L118:
	movq -8(%rbp),%rax
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_test:
L253:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L254:
	movq %rdi,%r14
	movl %esi,%r13d
	movl %edx,%r12d
	movq $0,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	movq %rax,%rbx
	movq 8(%r14),%rax
	testq $73726,(%rax)
	jnz L258
L256:
	xorl %esi,%esi
	movq %r14,%rdi
	call _promote
	movq %rax,%r14
	movq 8(%rax),%rax
	testq $73726,(%rax)
	jnz L258
L259:
	pushq %r12
	pushq $L262
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L258:
	movq %rbx,%rdx
	movq 8(%r14),%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,%rcx
	cmpl $409993268,%r13d
	movl $536870946,%eax
	movl $536870945,%edi
	cmovnzl %eax,%edi
	movq %r14,%rdx
	movl $_int_type,%esi
	call _binary_tree
L255:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lvalue:
L267:
	pushq %rbx
	pushq %r12
	pushq %r13
L268:
	movq %rdi,%r13
	movl %esi,%r12d
	movl %edx,%ebx
	testl $268435456,(%r13)
	jnz L272
L270:
	pushq %r12
	pushq $L273
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L272:
	testl $2,%ebx
	jz L276
L281:
	cmpl $2415919105,(%r13)
	jnz L276
L282:
	movq 24(%r13),%rax
	testl $128,12(%rax)
	jz L276
L278:
	pushq %r12
	pushq $L285
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L276:
	testl $1,%ebx
	jz L288
L289:
	movq 8(%r13),%rcx
	movq (%rcx),%rax
	testq $131072,%rax
	jnz L294
L293:
	testq $8192,%rax
	jz L288
L297:
	movq 16(%rcx),%rax
	testl $4194304,12(%rax)
	jz L288
L294:
	pushq %r12
	pushq $L301
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L288:
	testl $4,%ebx
	jz L269
L305:
	movq 8(%r13),%rdi
	movq (%rdi),%rax
	testq $393216,%rax
	jz L269
L311:
	testq $8192,%rax
	jnz L269
L312:
	call _unqualify
	movq %rax,8(%r13)
L269:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_crement:
L315:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L316:
	movq %rdi,%r15
	movl %esi,%r14d
	movl %edx,%r13d
	cmpl $27,%r13d
	movl $-1,%eax
	movl $1,%ebx
	cmovnzl %eax,%ebx
	movl $5,%edx
	movl %r13d,%esi
	movq %r15,%rdi
	call _lvalue
	movq 8(%r15),%rax
	movq (%rax),%rax
	testq $65536,%rax
	jz L322
L321:
	movslq %ebx,%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_long_type,%edi
	jmp L332
L322:
	testq $1022,%rax
	jz L325
L324:
	movslq %ebx,%rbx
	movq %rbx,-16(%rbp)
	leaq -16(%rbp),%rsi
	jmp L333
L325:
	testq $7168,%rax
	jz L328
L327:
	cvtsi2sdl %ebx,%xmm0
	movsd %xmm0,-24(%rbp)
	leaq -24(%rbp),%rsi
L333:
	movq 8(%r15),%rdi
L332:
	call _con_tree
	movq %rax,%r12
	jmp L323
L328:
	pushq %r13
	pushq $L330
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L323:
	movq %r12,%rcx
	movq %r15,%rdx
	xorl %esi,%esi
	movl %r14d,%edi
	call _binary_tree
	movq %rax,%rdi
	call _scale
L317:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L397:
	.short L340-_primary
	.short L342-_primary
	.short L344-_primary
	.short L346-_primary
	.short L348-_primary
	.short L350-_primary
	.short L352-_primary

_primary:
L334:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
L335:
	movl _token(%rip),%ecx
	cmpl $1073741827,%ecx
	jl L389
L391:
	cmpl $1073741833,%ecx
	jg L389
L388:
	leal -1073741827(%rcx),%eax
	movzwl L397(,%rax,2),%eax
	addl $_primary,%eax
	jmp *%rax
L352:
	movsd _token+24(%rip),%xmm0
	movsd %xmm0,-56(%rbp)
	leaq -56(%rbp),%rsi
	movl $_ldouble_type,%edi
	jmp L400
L350:
	movsd _token+24(%rip),%xmm0
	movsd %xmm0,-48(%rbp)
	leaq -48(%rbp),%rsi
	movl $_double_type,%edi
	jmp L400
L348:
	movsd _token+24(%rip),%xmm0
	movsd %xmm0,-40(%rbp)
	leaq -40(%rbp),%rsi
	movl $_float_type,%edi
	jmp L400
L346:
	movq _token+24(%rip),%rax
	movq %rax,-32(%rbp)
	leaq -32(%rbp),%rsi
	movl $_ulong_type,%edi
	jmp L400
L344:
	movq _token+24(%rip),%rax
	movq %rax,-24(%rbp)
	leaq -24(%rbp),%rsi
	movl $_long_type,%edi
	jmp L400
L342:
	movq _token+24(%rip),%rax
	movq %rax,-16(%rbp)
	leaq -16(%rbp),%rsi
	movl $_uint_type,%edi
	jmp L400
L340:
	movq _token+24(%rip),%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_int_type,%edi
L400:
	call _con_tree
	jmp L399
L389:
	cmpl $1,%ecx
	jz L368
L393:
	cmpl $2,%ecx
	jz L354
L394:
	cmpl $12,%ecx
	jz L356
L337:
	pushq %rcx
	pushq $L385
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
	jmp L338
L356:
	call _lex
	cmpl $16,_token(%rip)
	jnz L358
L357:
	cmpl $0,_no_stmt_expr(%rip)
	jz L362
L360:
	pushq $L363
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L362:
	xorl %edi,%edi
	call _enter_scope
	xorl %edi,%edi
	call _compound
	movl $_func_chain,%edi
	call _exit_scope
	movq _stmt_tree(%rip),%rbx
	jmp L364
L358:
	call _expression
	movq %rax,%rbx
L364:
	movl $13,%edi
	call _expect
	jmp L387
L354:
	movq _token+24(%rip),%rdi
	call _literal
	movq %rax,%rdi
	call _sym_tree
L399:
	movq %rax,%rbx
L387:
	call _lex
	jmp L338
L368:
	movq _token+24(%rip),%rbx
	call _lex
	movl $1,%ecx
	movl _outer_scope(%rip),%edx
	movl $2040,%esi
	movq %rbx,%rdi
	call _lookup
	movq %rax,%r12
	testq %rax,%rax
	jz L370
L369:
	testl $512,12(%rax)
	jz L371
L372:
	movslq 48(%rax),%rax
	movq %rax,-64(%rbp)
	leaq -64(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	jmp L398
L370:
	cmpl $12,_token(%rip)
	jnz L377
L376:
	movq %rbx,%rdi
	call _implicit
	movq %rax,%r12
	jmp L371
L377:
	pushq $L379
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L371:
	testl $8,12(%r12)
	jz L382
L380:
	pushq $L383
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L382:
	orl $536870912,12(%r12)
	movq %r12,%rdi
	call _sym_tree
L398:
	movq %rax,%rbx
L338:
	movq %rbx,%rax
L336:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_access:
L401:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L402:
	movq %rdi,%r14
	movl $1342177283,%r13d
	cmpl $18,_token(%rip)
	jnz L406
L404:
	testl $268435456,(%r14)
	movl $1073741828,%eax
	cmovzl %eax,%r13d
	movq 8(%r14),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %r14,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%r14
L406:
	movq 8(%r14),%rax
	testq $65536,(%rax)
	jz L410
L413:
	movq 24(%rax),%rax
	testq $8192,(%rax)
	jnz L412
L410:
	movl _token(%rip),%eax
	pushq %rax
	pushq $L417
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L412:
	movq 8(%r14),%rax
	movq 24(%rax),%rax
	movq 16(%rax),%rbx
	movq (%rax),%r12
	andl $393216,%r12d
	testl $1073741824,12(%rbx)
	jnz L420
L418:
	pushq %rbx
	pushq $L421
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L420:
	call _lex
	movl $1,%edi
	call _expect
	movq %rbx,%rsi
	movq _token+24(%rip),%rdi
	call _lookup_member
	movq %rax,%rbx
	call _lex
	movslq 48(%rbx),%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_long_type,%edi
	call _con_tree
	movq %rax,%r15
	movq %r12,%rsi
	movq 32(%rbx),%rdi
	call _qualify
	movq %rax,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %r15,%rcx
	movq %r14,%rdx
	movq %rax,%rsi
	movl $536870938,%edi
	call _binary_tree
	movq 8(%rax),%rcx
	movq %rax,%rdx
	movq 24(%rcx),%rsi
	movl %r13d,%edi
	call _unary_tree
	movq %rax,%rbx
	movq 8(%rbx),%rdi
	call _unfieldify
	movq %rax,8(%rbx)
	movq %rbx,%rax
L403:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_call:
L423:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L424:
	movq %rdi,%rbx
	call _lex
	cmpl $2415919105,(%rbx)
	jnz L427
L426:
	movq 24(%rbx),%rax
	movq (%rax),%r15
	jmp L428
L427:
	xorl %r15d,%r15d
L428:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _promote
	movq %rax,%r12
	movq 8(%r12),%rax
	movq 24(%rax),%r14
	testq %r14,%r14
	jz L433
L432:
	testq $32768,(%r14)
	jnz L431
L433:
	pushq $L436
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L431:
	movq 24(%r14),%rbx
	movq %r12,%rdx
	movq %rbx,%rsi
	movl $1073741829,%edi
	call _unary_tree
	movq %rax,%r13
	movq %r13,-16(%rbp)
	movq 16(%r14),%r12
	testq $8192,(%rbx)
	jz L439
L437:
	movq %rbx,%rdi
	call _temp
	movq %rax,%rdi
	call _sym_tree
	movq %rax,-8(%rbp)
	movq %rbx,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq -8(%rbp),%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%rsi
	movq %r13,%rdi
	call _actual
	movq %rbx,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,8(%r13)
	movq %r13,%rdx
	movq %rbx,%rsi
	movl $1073741828,%edi
	call _unary_tree
	movq %rax,-16(%rbp)
L439:
	cmpl $13,_token(%rip)
	jz L473
L443:
	call _assignment
	movq %rax,%rdi
	movq %rdi,%rbx
	testq %r12,%r12
	jnz L448
L447:
	movq (%r14),%rax
	movq %rax,%rcx
	andl $32768,%ecx
	jz L459
L457:
	testq $524288,%rax
	jnz L454
L459:
	testq %rcx,%rcx
	jz L463
L461:
	testq $1048576,%rax
	jz L463
L454:
	movl $1,%esi
	call _promote
	movq %rax,%rbx
	jmp L449
L463:
	pushq $L465
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
	jmp L449
L448:
	movl $1048635,%edx
	movq (%r12),%rsi
	call _fake
	movq %rax,%rbx
	movq 8(%r12),%r12
L449:
	xorl %esi,%esi
	movq 8(%rbx),%rdi
	call _size_of
	movq %rbx,%rsi
	movq %r13,%rdi
	call _actual
	cmpl $13,_token(%rip)
	jz L473
L470:
	movl $21,%edi
	call _expect
	call _lex
	jmp L443
L473:
	movl $13,%edi
	call _expect
	call _lex
	testq %r12,%r12
	jz L478
L476:
	pushq $L479
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
L478:
	movq -16(%rbp),%rdi
	call _rewrite_builtin
L425:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_postfix:
L481:
	pushq %rbx
L482:
	call _primary
L534:
	movq %rax,%rbx
	jmp L484
L527:
	cmpl $28,%edx
	jz L492
	jg L488
L528:
	cmpb $14,%dl
	jz L499
L529:
	cmpb $18,%dl
	jz L497
L530:
	cmpb $26,%dl
	jz L497
L531:
	cmpb $27,%dl
	jz L492
	jnz L488
L497:
	movq %rbx,%rdi
	call _access
	jmp L534
L499:
	call _lex
	xorl %esi,%esi
	movq %rbx,%rdi
	call _promote
	movq %rax,%rbx
	call _expression
	xorl %esi,%esi
	movq %rax,%rdi
	call _promote
	movq %rax,%rcx
	movq %rbx,%rdx
	xorl %esi,%esi
	movl $536870938,%edi
	call _binary_tree
	movq %rax,%rbx
	movl $15,%edi
	call _expect
	call _lex
	cmpl $536870938,(%rbx)
	jnz L508
L509:
	movq 24(%rbx),%rcx
	movq 8(%rcx),%rax
	testq $65536,(%rax)
	jz L508
L510:
	movq 16(%rbx),%rax
	movq %rcx,16(%rbx)
	movq %rax,24(%rbx)
L508:
	movq 16(%rbx),%rax
	movq 8(%rax),%rax
	testq $65536,(%rax)
	jz L520
L519:
	movq 24(%rbx),%rax
	movq 8(%rax),%rax
	testq $1022,(%rax)
	jnz L518
L520:
	pushq $L523
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L518:
	movq %rbx,%rdi
	call _scale
	movq 8(%rax),%rcx
	movq %rax,%rdx
	movq 24(%rcx),%rsi
	movl $1342177283,%edi
	call _unary_tree
	jmp L534
L492:
	movl $22,%esi
	movq %rbx,%rdi
	call _crement
	movq %rax,%rbx
	call _lex
L484:
	movl _token(%rip),%edx
	cmpl $12,%edx
	jg L527
	jl L488
L494:
	movq %rbx,%rdi
	call _call
	jmp L534
L488:
	movq %rbx,%rax
L483:
	popq %rbx
	ret 


_unary:
L535:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L536:
	movl _token(%rip),%r13d
	cmpl $-2147483564,%r13d
	jz L566
L600:
	cmpl $25,%r13d
	jz L591
L601:
	cmpl $27,%r13d
	jz L564
L602:
	cmpl $28,%r13d
	jz L564
L603:
	cmpl $29,%r13d
	jz L561
L604:
	cmpl $229638175,%r13d
	jz L541
L605:
	cmpl $245366816,%r13d
	jz L589
L606:
	cmpl $262144033,%r13d
	jz L587
L607:
	cmpl $375390250,%r13d
	jz L547
L608:
	call _postfix
	jmp L537
L547:
	call _lex
	call _cast
	movq %rax,%rbx
	movl $2,%edx
	movl $375390250,%esi
	movq %rbx,%rdi
	call _lvalue
	movl (%rbx),%eax
	cmpl $1342177283,%eax
	jz L556
L555:
	cmpl $1073741828,%eax
	jnz L550
L556:
	movq 16(%rbx),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rax
	movq (%rax),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L550
L552:
	pushq $375390250
	pushq $L559
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L550:
	movq 8(%rbx),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	jmp L610
L587:
	movl $1073741832,%r12d
	jmp L598
L589:
	movl $1073741834,%r12d
L598:
	movl $8190,%r14d
	jmp L539
L541:
	call _lex
	call _cast
	xorl %esi,%esi
	movq %rax,%rdi
	call _promote
	movq %rax,%rbx
	movq 8(%rbx),%rax
	testq $65536,(%rax)
	jnz L544
L542:
	pushq $L545
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L544:
	movq 8(%rbx),%rax
	movq %rbx,%rdx
	movq 24(%rax),%rsi
	movl $1342177283,%edi
	jmp L610
L561:
	call _lex
	call _cast
	movl $29,%edx
	movl $409993268,%esi
	movq %rax,%rdi
	call _test
	jmp L537
L564:
	call _lex
	call _unary
	movl %r13d,%edx
	movl $134217743,%esi
	movq %rax,%rdi
	call _crement
	jmp L537
L591:
	movl $1073741833,%r12d
	movl $1022,%r14d
L539:
	call _lex
	call _cast
	xorl %esi,%esi
	movq %rax,%rdi
	call _promote
	movq %rax,%rbx
	movq 8(%rbx),%rax
	movq (%rax),%rax
	andl $131071,%eax
	testq %rax,%r14
	jnz L595
L593:
	pushq %r13
	pushq $L596
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L595:
	movq %rbx,%rdx
	movq 8(%rbx),%rsi
	movl %r12d,%edi
L610:
	call _unary_tree
	jmp L537
L566:
	call _lex
	leaq -32(%rbp),%rdi
	call _lookahead
	cmpl $12,_token(%rip)
	jnz L572
L570:
	movl -32(%rbp),%eax
	testl $536870912,%eax
	jnz L575
L574:
	cmpl $1,%eax
	jnz L572
L578:
	movq -8(%rbp),%rdi
	call _named_type
	testq %rax,%rax
	jz L572
L575:
	call _lex
	call _abstract
	movq %rax,%rbx
	movl $13,%edi
	call _expect
	call _lex
	xorl %esi,%esi
	movq %rbx,%rdi
	call _size_of
	movslq %eax,%rax
	movq %rax,-40(%rbp)
	leaq -40(%rbp),%rsi
	jmp L611
L572:
	call _unary
	xorl %esi,%esi
	movq 8(%rax),%rdi
	call _size_of
	movslq %eax,%rax
	movq %rax,-48(%rbp)
	leaq -48(%rbp),%rsi
L611:
	movl $_ulong_type,%edi
	call _con_tree
L537:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cast:
L612:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
L613:
	cmpl $12,_token(%rip)
	jnz L617
L615:
	leaq -32(%rbp),%rdi
	call _lookahead
	movl -32(%rbp),%eax
	testl $536870912,%eax
	jnz L622
L621:
	cmpl $1,%eax
	jnz L617
L625:
	movq -8(%rbp),%rdi
	call _named_type
	testq %rax,%rax
	jz L617
L622:
	call _lex
	call _abstract
	movq %rax,%r12
	movl $13,%edi
	call _expect
	call _lex
	call _cast
	xorl %esi,%esi
	movq %rax,%rdi
	call _promote
	movq %rax,%rbx
	movq (%r12),%rcx
	testq $73726,%rcx
	jnz L649
L647:
	testq $1,%rcx
	jz L636
L649:
	testq $7168,%rcx
	jz L653
L651:
	movq 8(%rbx),%rax
	testq $65536,(%rax)
	jnz L636
L653:
	movq 8(%rbx),%rax
	movq (%rax),%rax
	testq $7168,%rax
	jz L657
L655:
	testq $65536,%rcx
	jnz L636
L657:
	testq $73726,%rax
	jnz L634
L636:
	pushq $L659
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L634:
	movq %rbx,%rdx
	movq %r12,%rsi
	movl $1073741830,%edi
	call _unary_tree
	jmp L614
L617:
	call _unary
L614:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_binary:
L662:
	pushq %rbx
	pushq %r12
	pushq %r13
L663:
	movq %rdi,%r13
	movl %esi,%r12d
	jmp L665
L666:
	call _lex
	call _cast
L672:
	movq %rax,%rdi
	movl _token(%rip),%eax
	andl $15728640,%eax
	movl %ebx,%esi
	andl $15728640,%esi
	cmpl %esi,%eax
	jle L670
L669:
	addl $1048576,%esi
	call _binary
	jmp L672
L670:
	movq %rdi,%rdx
	movq %r13,%rsi
	movl %ebx,%edi
	call _build_tree
	movq %rax,%r13
L665:
	movl _token(%rip),%ebx
	movl %ebx,%eax
	andl $15728640,%eax
	cmpl %eax,%r12d
	jle L666
L667:
	movq %r13,%rax
L664:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_ternary:
L673:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L674:
	xorl %r14d,%r14d
	call _cast
	movl $2097152,%esi
	movq %rax,%rdi
	call _binary
	movq %rax,%rdi
	movq %rdi,%rax
	cmpl $24,_token(%rip)
	jnz L675
L676:
	movl $24,%edx
	movl $426770485,%esi
	call _test
	movq %rax,%r13
	call _lex
	call _expression
	movq %rax,%r12
	movl $486539286,%edi
	call _expect
	call _lex
	call _ternary
	movq %rax,%rbx
	movq %rbx,%rdx
	movq 8(%r12),%rcx
	testq $8192,(%rcx)
	jz L684
L685:
	movq 8(%rbx),%rax
	testq $8192,(%rax)
	jz L684
L686:
	movl $1,%r14d
	movq %rcx,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %r12,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%r12
	movq 8(%rbx),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%rdx
L684:
	movq %r12,%rsi
	movl $486539286,%edi
	call _build_tree
	movq %rax,%rcx
	movq %r13,%rdx
	movq 8(%rax),%rsi
	movl $41,%edi
	call _binary_tree
	movq %rax,%rdx
	movq %rdx,%rax
	testl %r14d,%r14d
	jz L675
L689:
	movq 8(%rdx),%rax
	movq 24(%rax),%rsi
	movl $1073741828,%edi
	call _unary_tree
L675:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_assignment:
L693:
	pushq %rbx
	pushq %r12
	pushq %r13
L694:
	call _ternary
	movq %rax,%r13
	movl _token(%rip),%r12d
	movq %r13,%rax
	movl %r12d,%ecx
	andl $15728640,%ecx
	cmpl $1048576,%ecx
	jnz L695
L696:
	call _lex
	call _assignment
	movq %rax,%rbx
	movl $5,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _lvalue
	movq %rbx,%rdx
	movq %r13,%rsi
	movl %r12d,%edi
	call _build_tree
L695:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_expression:
L700:
	pushq %rbx
	pushq %r12
	pushq %r13
L701:
	call _assignment
	movq %rax,%r13
	movq %r13,%rax
	cmpl $21,_token(%rip)
	jnz L702
L703:
	call _lex
	call _expression
	movq %rax,%r12
	movq %r12,%rcx
	movq 8(%r12),%rdx
	testq $8192,(%rdx)
	setnz %al
	movzbl %al,%ebx
	jz L708
L706:
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %r12,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%rcx
L708:
	movq %r13,%rdx
	movq 8(%rcx),%rsi
	movl $43,%edi
	call _binary_tree
	movq %rax,%rdx
	movq %rdx,%rax
	testl %ebx,%ebx
	jz L702
L709:
	movq 8(%rdx),%rax
	movq 24(%rax),%rsi
	movl $1073741828,%edi
	call _unary_tree
L702:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 8
L716:
	.int -2147483648
	.fill 28, 1, 0
.text

_fake:
L713:
L714:
	movq %rsi,L716+8(%rip)
	movl %edx,%eax
	movq %rdi,%rdx
	movl $L716,%esi
	movl %eax,%edi
	call _build_tree
	movq %rax,%rdi
	call _chop_right
L715:
	ret 


_case_expr:
L718:
	pushq %rbx
L719:
	incl _no_stmt_expr(%rip)
	call _assignment
	movq %rax,%rdi
	call _fold
	movq %rax,%rbx
	decl _no_stmt_expr(%rip)
	cmpl $2147483650,(%rbx)
	jnz L721
L728:
	cmpq $0,24(%rbx)
	jnz L721
L724:
	movq 8(%rbx),%rax
	testq $1022,(%rax)
	jnz L723
L721:
	pushq $L732
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L723:
	movq %rbx,%rax
L720:
	popq %rbx
	ret 


_constant_expr:
L734:
	pushq %rbx
L735:
	call _case_expr
	movq %rax,%rbx
	leaq 16(%rbx),%rsi
	movl $64,%edi
	call _con_in_range
	testl %eax,%eax
	jnz L739
L737:
	pushq $L740
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L739:
	movq 16(%rbx),%rax
L736:
	popq %rbx
	ret 


_static_expr:
L742:
	pushq %rbx
L743:
	incl _no_stmt_expr(%rip)
	call _ternary
	xorl %esi,%esi
	movq %rax,%rdi
	call _promote
	movq %rax,%rdi
	call _fold
	movq %rax,%rbx
	decl _no_stmt_expr(%rip)
	cmpl $2147483650,(%rbx)
	jz L747
L745:
	pushq $L748
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L747:
	movq %rbx,%rax
L744:
	popq %rbx
	ret 

L273:
	.byte 37,107,32,114,101,113,117,105
	.byte 114,101,115,32,97,110,32,108
	.byte 118,97,108,117,101,0
L523:
	.byte 105,110,118,97,108,105,100,32
	.byte 111,112,101,114,97,110,100,115
	.byte 32,116,111,32,91,93,0
L465:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,102,117,110,99,116,105,111
	.byte 110,32,97,114,103,117,109,101
	.byte 110,116,115,0
L417:
	.byte 37,107,32,114,101,113,117,105
	.byte 114,101,115,32,115,116,114,117
	.byte 99,116,32,111,114,32,117,110
	.byte 105,111,110,32,116,121,112,101
	.byte 0
L545:
	.byte 105,108,108,101,103,97,108,32
	.byte 105,110,100,105,114,101,99,116
	.byte 105,111,110,0
L250:
	.byte 105,110,99,111,109,112,97,116
	.byte 105,98,108,101,32,116,121,112
	.byte 101,40,115,41,32,102,111,114
	.byte 32,37,107,0
L596:
	.byte 105,108,108,101,103,97,108,32
	.byte 111,112,101,114,97,110,100,32
	.byte 116,111,32,117,110,97,114,121
	.byte 32,37,107,0
L363:
	.byte 115,116,97,116,101,109,101,110
	.byte 116,32,101,120,112,114,101,115
	.byte 115,105,111,110,115,32,112,114
	.byte 111,104,105,98,105,116,101,100
	.byte 32,104,101,114,101,0
L659:
	.byte 105,110,118,97,108,105,100,32
	.byte 99,97,115,116,0
L436:
	.byte 40,41,32,114,101,113,117,105
	.byte 114,101,115,32,102,117,110,99
	.byte 116,105,111,110,32,111,114,32
	.byte 112,111,105,110,116,101,114,45
	.byte 116,111,45,102,117,110,99,116
	.byte 105,111,110,0
L748:
	.byte 99,111,110,115,116,97,110,116
	.byte 32,101,120,112,114,101,115,115
	.byte 105,111,110,32,114,101,113,117
	.byte 105,114,101,100,0
L383:
	.byte 109,105,115,112,108,97,99,101
	.byte 100,32,116,121,112,101,100,101
	.byte 102,32,110,97,109,101,0
L379:
	.byte 117,110,107,110,111,119,110,32
	.byte 105,100,101,110,116,105,102,105
	.byte 101,114,0
L385:
	.byte 101,120,112,101,99,116,101,100
	.byte 32,101,120,112,114,101,115,115
	.byte 105,111,110,32,40,103,111,116
	.byte 32,37,107,41,0
L330:
	.byte 37,107,32,114,101,113,117,105
	.byte 114,101,115,32,115,99,97,108
	.byte 97,114,32,111,112,101,114,97
	.byte 110,100,0
L732:
	.byte 105,110,116,101,103,114,97,108
	.byte 32,99,111,110,115,116,97,110
	.byte 116,32,101,120,112,114,101,115
	.byte 115,105,111,110,32,114,101,113
	.byte 117,105,114,101,100,0
L740:
	.byte 99,111,110,115,116,97,110,116
	.byte 32,101,120,112,114,101,115,115
	.byte 105,111,110,32,111,117,116,32
	.byte 111,102,32,114,97,110,103,101
	.byte 0
L421:
	.byte 37,107,32,99,97,110,110,111
	.byte 116,32,98,101,32,97,112,112
	.byte 108,105,101,100,32,116,111,32
	.byte 105,110,99,111,109,112,108,101
	.byte 116,101,32,37,84,0
L175:
	.byte 37,107,32,100,105,115,99,97
	.byte 114,100,115,32,37,113,0
L285:
	.byte 99,97,110,39,116,32,97,112
	.byte 112,108,121,32,37,107,32,116
	.byte 111,32,114,101,103,105,115,116
	.byte 101,114,32,118,97,114,105,97
	.byte 98,108,101,0
L301:
	.byte 37,107,32,114,101,113,117,105
	.byte 114,101,115,32,110,111,110,45
	.byte 96,99,111,110,115,116,39,32
	.byte 116,97,114,103,101,116,0
L262:
	.byte 37,107,32,114,101,113,117,105
	.byte 114,101,115,32,97,32,115,99
	.byte 97,108,97,114,32,101,120,112
	.byte 114,101,115,115,105,111,110,0
L479:
	.byte 116,111,111,32,102,101,119,32
	.byte 102,117,110,99,116,105,111,110
	.byte 32,97,114,103,117,109,101,110
	.byte 116,115,0
L559:
	.byte 99,97,110,39,116,32,97,112
	.byte 112,108,121,32,37,107,32,116
	.byte 111,32,98,105,116,102,105,101
	.byte 108,100,0
.local _no_stmt_expr
.comm _no_stmt_expr, 4, 4

.globl _test
.globl _float_type
.globl _named_type
.globl _sym_tree
.globl _compose
.globl _lookahead
.globl _implicit
.globl _assignment
.globl _lex
.globl _unary_tree
.globl _func_chain
.globl _enter_scope
.globl _con_tree
.globl _error
.globl _expect
.globl _build_tree
.globl _long_type
.globl _char_type
.globl _constant_expr
.globl _temp
.globl _lookup_member
.globl _unqualify
.globl _uint_type
.globl _get_tnode
.globl _ldouble_type
.globl _qualify
.globl _unfieldify
.globl _stmt_tree
.globl _double_type
.globl _abstract
.globl _fold
.globl _int_type
.globl _void_type
.globl _con_in_range
.globl _expression
.globl _chop_right
.globl _lookup
.globl _fake
.globl _case_expr
.globl _outer_scope
.globl _compound
.globl _actual
.globl _binary_tree
.globl _exit_scope
.globl _literal
.globl _token
.globl _static_expr
.globl _rewrite_builtin
.globl _ulong_type
.globl _size_of
.globl _compat
