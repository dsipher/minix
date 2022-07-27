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
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%rbx
	jmp L6
L5:
	testq $16384,%rax
	jz L8
L7:
	movq 24(%rdi),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%rbx
	jmp L6
L8:
	testq $14,%rax
	jnz L14
L13:
	testq $48,%rax
	jz L15
L14:
	movq %rbx,%rdx
	movl $_int_type,%esi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,%rbx
	jmp L6
L15:
	testl %esi,%esi
	jz L22
L20:
	testq $1024,%rax
	jz L22
L21:
	movq %rbx,%rdx
	movl $_double_type,%esi
	movl $1073741830,%edi
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
L35:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L36:
	movq %rdi,%r13
	movq 16(%r13),%r12
	movq 24(%r13),%rbx
	movq 8(%r12),%rax
	testq $65536,(%rax)
	jz L39
L38:
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
	jnz L42
L41:
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
	movq %rax,8(%r13)
	jmp L40
L42:
	movq $_long_type,8(%r13)
	movq %r14,%rcx
	movq %r13,%rdx
	movl $_long_type,%esi
	movl $23,%edi
	call _binary_tree
	movq %rax,%r13
	jmp L40
L39:
	movq %rax,8(%r13)
L40:
	movq %r13,%rax
L37:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_null0:
L45:
	pushq %rbx
L46:
	movq %rdi,%rax
	movq %rsi,%rbx
	movq 8(%rbx),%rcx
	testq $65536,(%rcx)
	jz L47
L51:
	movq 8(%rax),%rcx
	testq $1022,(%rcx)
	jz L47
L48:
	movq %rax,%rdi
	call _fold
	movq %rax,%rdx
	movq %rdx,%rax
	cmpl $2147483650,(%rdx)
	jnz L47
L66:
	cmpq $0,24(%rdx)
	jnz L47
L62:
	movq 8(%rdx),%rcx
	testq $1022,(%rcx)
	jz L47
L58:
	cmpq $0,16(%rdx)
	jnz L47
L55:
	movq 8(%rbx),%rsi
	movl $1073741830,%edi
	call _unary_tree
L47:
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
L71:
	pushq %rbx
	pushq %r12
L72:
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
	jz L86
L80:
	testq %rbx,%rax
	jnz L86
L83:
	xorl %edx,%edx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _get_tnode
	movq 16(%r12),%rdx
	movq %rax,%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,16(%r12)
L86:
	movq 16(%r12),%rax
	movq 8(%rax),%rdi
	movq (%rdi),%rax
	testq $393216,%rax
	jz L91
L92:
	testq $8192,%rax
	jnz L91
L93:
	call _unqualify
	movq 16(%r12),%rcx
	movq %rax,8(%rcx)
L91:
	movq 24(%r12),%rax
	movq 8(%rax),%rax
	movq (%rax),%rax
	andl $131071,%eax
	testq %rbx,%rax
	jnz L101
L99:
	xorl %edx,%edx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _get_tnode
	movq 24(%r12),%rdx
	movq %rax,%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%r12)
L101:
	movq 24(%r12),%rax
	movq 8(%rax),%rdi
	movq (%rdi),%rax
	testq $393216,%rax
	jz L73
L108:
	testq $8192,%rax
	jnz L73
L109:
	call _unqualify
	movq 24(%r12),%rcx
	movq %rax,8(%rcx)
L73:
	popq %r12
	popq %rbx
	ret 


_build_tree:
L112:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L113:
	movl %edi,-12(%rbp)
	movq %rsi,%r13
	movl -12(%rbp),%ebx
	andl $520093696,%ebx
	sarl $24,%ebx
	movslq %ebx,%rbx
	shlq $4,%rbx
	movl _map+12(%rbx),%r15d
	xorl %esi,%esi
	movq %rdx,%rdi
	call _promote
	movq %rax,%r12
	testl $1,%r15d
	jz L117
L115:
	xorl %esi,%esi
	movq %r13,%rdi
	call _promote
	movq %rax,%r13
L117:
	testl $2,%r15d
	jz L120
L118:
	movq %r12,%rsi
	movq %r13,%rdi
	call _null0
	movq %rax,%r13
L120:
	testl $4,%r15d
	jz L123
L121:
	movq %r13,%rsi
	movq %r12,%rdi
	call _null0
	movq %rax,%r12
L123:
	movq %r12,%rcx
	movq %r13,%rdx
	xorl %esi,%esi
	movl _map(%rbx),%edi
	call _binary_tree
	movq %rax,%r14
	cmpl $536870938,(%r14)
	jnz L129
L130:
	movq 24(%r14),%rcx
	movq 8(%rcx),%rax
	testq $65536,(%rax)
	jz L129
L131:
	movq 16(%r14),%rax
	movq %rcx,16(%r14)
	movq %rax,24(%r14)
L129:
	testl $8,%r15d
	jz L138
L137:
	movl -12(%rbp),%edx
	movl $426770485,%esi
	movq 24(%r14),%rdi
	call _test
	movq %rax,24(%r14)
	movl -12(%rbp),%edx
	movl $426770485,%esi
	movq 16(%r14),%rdi
	call _test
	movq %rax,16(%r14)
	jmp L139
L138:
	movl _map+8(%rbx),%eax
	movl _map+4(%rbx),%edi
	xorl %esi,%esi
L140:
	cmpl %esi,%eax
	jle L143
L141:
	movq 16(%r14),%rcx
	movq 8(%rcx),%rcx
	movq (%rcx),%rcx
	andl $131071,%ecx
	leal (%rsi,%rdi),%edx
	movslq %edx,%rdx
	shlq $4,%rdx
	testq %rcx,_operands(%rdx)
	jz L149
L147:
	movq 24(%r14),%rcx
	movq 8(%rcx),%rcx
	movq (%rcx),%rcx
	andl $131071,%ecx
	testq %rcx,_operands+8(%rdx)
	jnz L143
L149:
	incl %esi
	jmp L140
L143:
	cmpl %esi,%eax
	jz L155
L139:
	movq 16(%r14),%rax
	movq 8(%rax),%rdx
	testq $65536,(%rdx)
	jz L159
L160:
	movq 24(%r14),%rax
	movq 8(%rax),%rcx
	testq $65536,(%rcx)
	jz L159
L161:
	movq 24(%rdx),%rax
	movq (%rax),%r13
	andl $393216,%r13d
	movq 24(%rcx),%rax
	movq (%rax),%rbx
	andl $393216,%ebx
	cmpl $11,(%r14)
	jnz L172
L167:
	movq %r13,%rax
	andq %rbx,%rax
	cmpq %rax,%rbx
	jz L172
L168:
	xorq %rbx,%rax
	pushq %rax
	movl -12(%rbp),%eax
	pushq %rax
	pushq $L171
	pushq $0
	pushq $4
	call _error
	addq $40,%rsp
L172:
	movq 16(%r14),%rcx
	movq 8(%rcx),%rax
	testq $65536,(%rax)
	jz L177
L178:
	movq 24(%rax),%rax
	testq $1,(%rax)
	jz L177
L179:
	testl $128,%r15d
	jz L183
L182:
	movq 24(%r14),%rax
	movq 8(%rax),%rax
	movq %rax,8(%rcx)
	jmp L177
L183:
	testl $1024,%r15d
	jz L177
L185:
	movq %rbx,%rsi
	movl $_void_type,%edi
	call _qualify
	movq %rax,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq 24(%r14),%rcx
	movq %rax,8(%rcx)
L177:
	movq 24(%r14),%rcx
	movq 8(%rcx),%rax
	testq $65536,(%rax)
	jz L193
L194:
	movq 24(%rax),%rax
	testq $1,(%rax)
	jz L193
L195:
	testl $256,%r15d
	jz L199
L198:
	movq 16(%r14),%rax
	movq 8(%rax),%rax
	movq %rax,8(%rcx)
	jmp L193
L199:
	testl $512,%r15d
	jz L193
L201:
	movq %r13,%rsi
	movl $_void_type,%edi
	call _qualify
	movq %rax,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq 16(%r14),%rcx
	movq %rax,8(%rcx)
L193:
	movq 16(%r14),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rdi
	call _unqualify
	movq %rax,%r12
	movq 24(%r14),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rdi
	call _unqualify
	movq %rax,%rsi
	movq %r12,%rdi
	call _compat
	testl %eax,%eax
	jz L155
L206:
	cmpl $42,(%r14)
	jnz L159
L208:
	movq 16(%r14),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rdi
	call _unqualify
	movq %rax,%r12
	movq 24(%r14),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rdi
	call _unqualify
	xorl %edx,%edx
	movq %rax,%rsi
	movq %r12,%rdi
	call _compose
	orq %r13,%rbx
	movq %rbx,%rsi
	movq %rax,%rdi
	call _qualify
	movq %rax,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq 16(%r14),%rcx
	movq %rax,8(%rcx)
	movq 24(%r14),%rcx
	movq %rax,8(%rcx)
L159:
	movq 16(%r14),%rax
	movq 8(%rax),%rsi
	movq (%rsi),%rdx
	testq $8192,%rdx
	jz L216
L218:
	movq 24(%r14),%rax
	movq 8(%rax),%rcx
	testq $8192,(%rcx)
	jz L216
L219:
	movq 16(%rsi),%rax
	cmpq 16(%rcx),%rax
	jz L216
L155:
	movl -12(%rbp),%eax
	pushq %rax
	pushq $L246
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
	jmp L114
L216:
	testq $8190,%rdx
	jz L225
L226:
	movq 24(%r14),%rax
	movq 8(%rax),%rax
	testq $8190,(%rax)
	jz L225
L227:
	testl $96,%r15d
	jz L232
L230:
	movl %r15d,%esi
	movq %r14,%rdi
	call _usuals
L232:
	testl $16,%r15d
	jz L225
L233:
	movq 16(%r14),%rax
	movq 8(%rax),%rsi
	movq 24(%r14),%rdx
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%r14)
L225:
	testl $2048,%r15d
	jz L238
L236:
	movq 24(%r14),%rdx
	movl $_char_type,%esi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%r14)
L238:
	testl $8192,%r15d
	jz L240
L239:
	movq $_int_type,8(%r14)
	jmp L241
L240:
	testl $4096,%r15d
	jz L243
L242:
	movq %r14,%rdi
	call _scale
	movq %rax,%r14
	jmp L241
L243:
	movq 16(%r14),%rax
	movq 8(%rax),%rax
	movq %rax,8(%r14)
L241:
	movq %r14,-8(%rbp)
L114:
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
L247:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L248:
	movq %rdi,%r13
	movl %esi,%r12d
	movl %edx,%ebx
	movq $0,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	movq %rax,%r14
	movq 8(%r13),%rax
	testq $73726,(%rax)
	jnz L252
L250:
	xorl %esi,%esi
	movq %r13,%rdi
	call _promote
	movq %rax,%r13
	movq 8(%rax),%rax
	testq $73726,(%rax)
	jnz L252
L253:
	pushq %rbx
	pushq $L256
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L252:
	movq %r14,%rdx
	movq 8(%r13),%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,%rcx
	cmpl $409993268,%r12d
	movl $536870946,%eax
	movl $536870945,%edi
	cmovnzl %eax,%edi
	movq %r13,%rdx
	movl $_int_type,%esi
	call _binary_tree
L249:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lvalue:
L261:
	pushq %rbx
	pushq %r12
	pushq %r13
L262:
	movq %rdi,%r13
	movl %esi,%r12d
	movl %edx,%ebx
	testl $268435456,(%r13)
	jnz L266
L264:
	pushq %r12
	pushq $L267
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L266:
	testl $2,%ebx
	jz L270
L275:
	cmpl $2415919105,(%r13)
	jnz L270
L276:
	movq 24(%r13),%rax
	testl $128,12(%rax)
	jz L270
L272:
	pushq %r12
	pushq $L279
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L270:
	testl $1,%ebx
	jz L282
L283:
	movq 8(%r13),%rcx
	movq (%rcx),%rax
	testq $131072,%rax
	jnz L288
L287:
	testq $8192,%rax
	jz L282
L291:
	movq 16(%rcx),%rax
	testl $4194304,12(%rax)
	jz L282
L288:
	pushq %r12
	pushq $L295
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L282:
	testl $4,%ebx
	jz L263
L299:
	movq 8(%r13),%rdi
	movq (%rdi),%rax
	testq $393216,%rax
	jz L263
L305:
	testq $8192,%rax
	jnz L263
L306:
	call _unqualify
	movq %rax,8(%r13)
L263:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_crement:
L309:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L310:
	movq %rdi,%r14
	movl %esi,%r13d
	movl %edx,%r12d
	cmpl $27,%r12d
	movl $-1,%eax
	movl $1,%ebx
	cmovnzl %eax,%ebx
	movl $5,%edx
	movl %r12d,%esi
	movq %r14,%rdi
	call _lvalue
	movq 8(%r14),%rax
	movq (%rax),%rax
	testq $65536,%rax
	jz L316
L315:
	movslq %ebx,%rbx
	movq %rbx,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_long_type,%edi
	call _con_tree
	movq %rax,%r15
	jmp L317
L316:
	testq $1022,%rax
	jz L319
L318:
	movslq %ebx,%rbx
	movq %rbx,-16(%rbp)
	leaq -16(%rbp),%rsi
	movq 8(%r14),%rdi
	call _con_tree
	movq %rax,%r15
	jmp L317
L319:
	testq $7168,%rax
	jz L322
L321:
	cvtsi2sdl %ebx,%xmm0
	movsd %xmm0,-24(%rbp)
	leaq -24(%rbp),%rsi
	movq 8(%r14),%rdi
	call _con_tree
	movq %rax,%r15
	jmp L317
L322:
	pushq %r12
	pushq $L324
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L317:
	movq %r15,%rcx
	movq %r14,%rdx
	xorl %esi,%esi
	movl %r13d,%edi
	call _binary_tree
	movq %rax,%rdi
	call _scale
L311:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L389:
	.short L332-_primary
	.short L334-_primary
	.short L336-_primary
	.short L338-_primary
	.short L340-_primary
	.short L342-_primary
	.short L344-_primary

_primary:
L326:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
	pushq %r12
L327:
	movl _token(%rip),%ecx
	cmpl $1073741827,%ecx
	jl L381
L383:
	cmpl $1073741833,%ecx
	jg L381
L380:
	leal -1073741827(%rcx),%eax
	movzwl L389(,%rax,2),%eax
	addl $_primary,%eax
	jmp *%rax
L344:
	movsd _token+24(%rip),%xmm0
	movsd %xmm0,-56(%rbp)
	leaq -56(%rbp),%rsi
	movl $_ldouble_type,%edi
	call _con_tree
	movq %rax,%rbx
	jmp L379
L342:
	movsd _token+24(%rip),%xmm0
	movsd %xmm0,-48(%rbp)
	leaq -48(%rbp),%rsi
	movl $_double_type,%edi
	call _con_tree
	movq %rax,%rbx
	jmp L379
L340:
	movsd _token+24(%rip),%xmm0
	movsd %xmm0,-40(%rbp)
	leaq -40(%rbp),%rsi
	movl $_float_type,%edi
	call _con_tree
	movq %rax,%rbx
	jmp L379
L338:
	movq _token+24(%rip),%rax
	movq %rax,-32(%rbp)
	leaq -32(%rbp),%rsi
	movl $_ulong_type,%edi
	call _con_tree
	movq %rax,%rbx
	jmp L379
L336:
	movq _token+24(%rip),%rax
	movq %rax,-24(%rbp)
	leaq -24(%rbp),%rsi
	movl $_long_type,%edi
	call _con_tree
	movq %rax,%rbx
	jmp L379
L334:
	movq _token+24(%rip),%rax
	movq %rax,-16(%rbp)
	leaq -16(%rbp),%rsi
	movl $_uint_type,%edi
	call _con_tree
	movq %rax,%rbx
	jmp L379
L332:
	movq _token+24(%rip),%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	movq %rax,%rbx
	jmp L379
L381:
	cmpl $1,%ecx
	jz L360
L385:
	cmpl $2,%ecx
	jz L346
L386:
	cmpl $12,%ecx
	jz L348
L329:
	pushq %rcx
	pushq $L377
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
	jmp L330
L348:
	call _lex
	cmpl $16,_token(%rip)
	jnz L350
L349:
	cmpl $0,_no_stmt_expr(%rip)
	jz L354
L352:
	pushq $L355
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L354:
	xorl %edi,%edi
	call _enter_scope
	xorl %edi,%edi
	call _compound
	movl $_func_chain,%edi
	call _exit_scope
	movq _stmt_tree(%rip),%rbx
	jmp L356
L350:
	call _expression
	movq %rax,%rbx
L356:
	movl $13,%edi
	call _expect
	jmp L379
L346:
	movq _token+24(%rip),%rdi
	call _literal
	movq %rax,%rdi
	call _sym_tree
	movq %rax,%rbx
L379:
	call _lex
	jmp L330
L360:
	movq _token+24(%rip),%rbx
	call _lex
	movl $1,%ecx
	movl _outer_scope(%rip),%edx
	movl $2040,%esi
	movq %rbx,%rdi
	call _lookup
	movq %rax,%r12
	testq %rax,%rax
	jz L362
L361:
	testl $512,12(%rax)
	jz L363
L364:
	movslq 48(%rax),%rax
	movq %rax,-64(%rbp)
	leaq -64(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	movq %rax,%rbx
	jmp L330
L362:
	cmpl $12,_token(%rip)
	jnz L369
L368:
	movq %rbx,%rdi
	call _implicit
	movq %rax,%r12
	jmp L363
L369:
	pushq $L371
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L363:
	testl $8,12(%r12)
	jz L374
L372:
	pushq $L375
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L374:
	orl $536870912,12(%r12)
	movq %r12,%rdi
	call _sym_tree
	movq %rax,%rbx
L330:
	movq %rbx,%rax
L328:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_access:
L390:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L391:
	movq %rdi,%r14
	movl $1342177283,%r13d
	cmpl $18,_token(%rip)
	jnz L395
L393:
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
L395:
	movq 8(%r14),%rax
	testq $65536,(%rax)
	jz L399
L402:
	movq 24(%rax),%rax
	testq $8192,(%rax)
	jnz L401
L399:
	movl _token(%rip),%eax
	pushq %rax
	pushq $L406
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L401:
	movq 8(%r14),%rax
	movq 24(%rax),%rax
	movq 16(%rax),%r12
	movq (%rax),%rbx
	andl $393216,%ebx
	testl $1073741824,12(%r12)
	jnz L409
L407:
	pushq %r12
	pushq $L410
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L409:
	call _lex
	movl $1,%edi
	call _expect
	movq %r12,%rsi
	movq _token+24(%rip),%rdi
	call _lookup_member
	movq %rax,%r12
	call _lex
	movslq 48(%r12),%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_long_type,%edi
	call _con_tree
	movq %rax,%r15
	movq %rbx,%rsi
	movq 32(%r12),%rdi
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
L392:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_call:
L412:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L413:
	movq %rdi,%rbx
	call _lex
	cmpl $2415919105,(%rbx)
	jnz L416
L415:
	movq 24(%rbx),%rax
	movq (%rax),%r15
	jmp L417
L416:
	xorl %r15d,%r15d
L417:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _promote
	movq %rax,%r12
	movq 8(%r12),%rax
	movq 24(%rax),%r14
	testq %r14,%r14
	jz L422
L421:
	testq $32768,(%r14)
	jnz L420
L422:
	pushq $L425
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L420:
	movq 24(%r14),%rbx
	movq %r12,%rdx
	movq %rbx,%rsi
	movl $1073741829,%edi
	call _unary_tree
	movq %rax,%r13
	movq %r13,-16(%rbp)
	movq 16(%r14),%r12
	testq $8192,(%rbx)
	jz L428
L426:
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
L428:
	cmpl $13,_token(%rip)
	jz L462
L432:
	call _assignment
	movq %rax,%rdi
	movq %rdi,%rbx
	testq %r12,%r12
	jnz L437
L436:
	movq (%r14),%rax
	movq %rax,%rcx
	andl $32768,%ecx
	jz L448
L446:
	testq $524288,%rax
	jnz L443
L448:
	testq %rcx,%rcx
	jz L452
L450:
	testq $1048576,%rax
	jz L452
L443:
	movl $1,%esi
	call _promote
	movq %rax,%rbx
	jmp L438
L452:
	pushq $L454
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
	jmp L438
L437:
	movl $1048635,%edx
	movq (%r12),%rsi
	call _fake
	movq %rax,%rbx
	movq 8(%r12),%r12
L438:
	xorl %esi,%esi
	movq 8(%rbx),%rdi
	call _size_of
	movq %rbx,%rsi
	movq %r13,%rdi
	call _actual
	cmpl $13,_token(%rip)
	jz L462
L459:
	movl $21,%edi
	call _expect
	call _lex
	jmp L432
L462:
	movl $13,%edi
	call _expect
	call _lex
	testq %r12,%r12
	jz L467
L465:
	pushq $L468
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
L467:
	movq -16(%rbp),%rdi
	call _rewrite_builtin
L414:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_postfix:
L470:
	pushq %rbx
L471:
	call _primary
	movq %rax,%rbx
L473:
	movl _token(%rip),%edx
	cmpl $12,%edx
	jz L483
	jl L477
L516:
	cmpl $28,%edx
	jz L481
	jg L477
L517:
	cmpb $14,%dl
	jz L488
L518:
	cmpb $18,%dl
	jz L486
L519:
	cmpb $26,%dl
	jz L486
L520:
	cmpb $27,%dl
	jz L481
	jnz L477
L486:
	movq %rbx,%rdi
	call _access
	movq %rax,%rbx
	jmp L473
L488:
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
	jnz L497
L498:
	movq 24(%rbx),%rcx
	movq 8(%rcx),%rax
	testq $65536,(%rax)
	jz L497
L499:
	movq 16(%rbx),%rax
	movq %rcx,16(%rbx)
	movq %rax,24(%rbx)
L497:
	movq 16(%rbx),%rax
	movq 8(%rax),%rax
	testq $65536,(%rax)
	jz L509
L508:
	movq 24(%rbx),%rax
	movq 8(%rax),%rax
	testq $1022,(%rax)
	jnz L507
L509:
	pushq $L512
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L507:
	movq %rbx,%rdi
	call _scale
	movq 8(%rax),%rcx
	movq %rax,%rdx
	movq 24(%rcx),%rsi
	movl $1342177283,%edi
	call _unary_tree
	movq %rax,%rbx
	jmp L473
L481:
	movl $22,%esi
	movq %rbx,%rdi
	call _crement
	movq %rax,%rbx
	call _lex
	jmp L473
L483:
	movq %rbx,%rdi
	call _call
	movq %rax,%rbx
	jmp L473
L477:
	movq %rbx,%rax
L472:
	popq %rbx
	ret 


_unary:
L523:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L524:
	movl _token(%rip),%r13d
	cmpl $-2147483564,%r13d
	jz L554
L588:
	cmpl $25,%r13d
	jz L579
L589:
	cmpl $27,%r13d
	jz L552
L590:
	cmpl $28,%r13d
	jz L552
L591:
	cmpl $29,%r13d
	jz L549
L592:
	cmpl $229638175,%r13d
	jz L529
L593:
	cmpl $245366816,%r13d
	jz L577
L594:
	cmpl $262144033,%r13d
	jz L575
L595:
	cmpl $375390250,%r13d
	jz L535
L596:
	call _postfix
	jmp L525
L535:
	call _lex
	call _cast
	movq %rax,%rbx
	movl $2,%edx
	movl $375390250,%esi
	movq %rbx,%rdi
	call _lvalue
	movl (%rbx),%eax
	cmpl $1342177283,%eax
	jz L544
L543:
	cmpl $1073741828,%eax
	jnz L538
L544:
	movq 16(%rbx),%rax
	movq 8(%rax),%rax
	movq 24(%rax),%rax
	movq (%rax),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L538
L540:
	pushq $375390250
	pushq $L547
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L538:
	movq 8(%rbx),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rbx,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	jmp L525
L575:
	movl $1073741832,%r12d
	jmp L586
L577:
	movl $1073741834,%r12d
L586:
	movl $8190,%r14d
	jmp L527
L529:
	call _lex
	call _cast
	xorl %esi,%esi
	movq %rax,%rdi
	call _promote
	movq %rax,%rbx
	movq 8(%rbx),%rax
	testq $65536,(%rax)
	jnz L532
L530:
	pushq $L533
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L532:
	movq 8(%rbx),%rax
	movq %rbx,%rdx
	movq 24(%rax),%rsi
	movl $1342177283,%edi
	call _unary_tree
	jmp L525
L549:
	call _lex
	call _cast
	movl $29,%edx
	movl $409993268,%esi
	movq %rax,%rdi
	call _test
	jmp L525
L552:
	call _lex
	call _unary
	movl %r13d,%edx
	movl $134217743,%esi
	movq %rax,%rdi
	call _crement
	jmp L525
L579:
	movl $1073741833,%r12d
	movl $1022,%r14d
L527:
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
	jnz L583
L581:
	pushq %r13
	pushq $L584
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L583:
	movq %rbx,%rdx
	movq 8(%rbx),%rsi
	movl %r12d,%edi
	call _unary_tree
	jmp L525
L554:
	call _lex
	leaq -32(%rbp),%rdi
	call _lookahead
	cmpl $12,_token(%rip)
	jnz L560
L558:
	movl -32(%rbp),%eax
	testl $536870912,%eax
	jnz L563
L562:
	cmpl $1,%eax
	jnz L560
L566:
	movq -8(%rbp),%rdi
	call _named_type
	testq %rax,%rax
	jz L560
L563:
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
	movl $_ulong_type,%edi
	call _con_tree
	jmp L525
L560:
	call _unary
	xorl %esi,%esi
	movq 8(%rax),%rdi
	call _size_of
	movslq %eax,%rax
	movq %rax,-48(%rbp)
	leaq -48(%rbp),%rsi
	movl $_ulong_type,%edi
	call _con_tree
L525:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cast:
L598:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
L599:
	cmpl $12,_token(%rip)
	jnz L603
L601:
	leaq -32(%rbp),%rdi
	call _lookahead
	movl -32(%rbp),%eax
	testl $536870912,%eax
	jnz L608
L607:
	cmpl $1,%eax
	jnz L603
L611:
	movq -8(%rbp),%rdi
	call _named_type
	testq %rax,%rax
	jz L603
L608:
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
	jnz L635
L633:
	testq $1,%rcx
	jz L622
L635:
	testq $7168,%rcx
	jz L639
L637:
	movq 8(%rbx),%rax
	testq $65536,(%rax)
	jnz L622
L639:
	movq 8(%rbx),%rax
	movq (%rax),%rax
	testq $7168,%rax
	jz L643
L641:
	testq $65536,%rcx
	jnz L622
L643:
	testq $73726,%rax
	jnz L620
L622:
	pushq $L645
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L620:
	movq %rbx,%rdx
	movq %r12,%rsi
	movl $1073741830,%edi
	call _unary_tree
	jmp L600
L603:
	call _unary
L600:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_binary:
L648:
	pushq %rbx
	pushq %r12
	pushq %r13
L649:
	movq %rdi,%r13
	movl %esi,%r12d
L651:
	movl _token(%rip),%ebx
	movl %ebx,%eax
	andl $15728640,%eax
	cmpl %eax,%r12d
	jg L653
L652:
	call _lex
	call _cast
	movq %rax,%rdi
L654:
	movl _token(%rip),%eax
	andl $15728640,%eax
	movl %ebx,%esi
	andl $15728640,%esi
	cmpl %esi,%eax
	jle L656
L655:
	addl $1048576,%esi
	call _binary
	movq %rax,%rdi
	jmp L654
L656:
	movq %rdi,%rdx
	movq %r13,%rsi
	movl %ebx,%edi
	call _build_tree
	movq %rax,%r13
	jmp L651
L653:
	movq %r13,%rax
L650:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_ternary:
L658:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L659:
	xorl %r14d,%r14d
	call _cast
	movl $2097152,%esi
	movq %rax,%rdi
	call _binary
	movq %rax,%rdi
	movq %rdi,%rax
	cmpl $24,_token(%rip)
	jnz L660
L661:
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
	jz L669
L670:
	movq 8(%rbx),%rax
	testq $8192,(%rax)
	jz L669
L671:
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
L669:
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
	jz L660
L674:
	movq 8(%rdx),%rax
	movq 24(%rax),%rsi
	movl $1073741828,%edi
	call _unary_tree
L660:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_assignment:
L678:
	pushq %rbx
	pushq %r12
	pushq %r13
L679:
	call _ternary
	movq %rax,%r13
	movl _token(%rip),%r12d
	movq %r13,%rax
	movl %r12d,%ecx
	andl $15728640,%ecx
	cmpl $1048576,%ecx
	jnz L680
L681:
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
L680:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_expression:
L685:
	pushq %rbx
	pushq %r12
	pushq %r13
L686:
	call _assignment
	movq %rax,%r13
	movq %r13,%rax
	cmpl $21,_token(%rip)
	jnz L687
L688:
	call _lex
	call _expression
	movq %rax,%r12
	movq %r12,%rcx
	movq 8(%r12),%rdx
	testq $8192,(%rdx)
	setnz %bl
	movzbl %bl,%ebx
	jz L693
L691:
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %r12,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%rcx
L693:
	movq %r13,%rdx
	movq 8(%rcx),%rsi
	movl $43,%edi
	call _binary_tree
	movq %rax,%rdx
	movq %rdx,%rax
	testl %ebx,%ebx
	jz L687
L694:
	movq 8(%rdx),%rax
	movq 24(%rax),%rsi
	movl $1073741828,%edi
	call _unary_tree
L687:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 8
L701:
	.int -2147483648
	.fill 28, 1, 0
.text

_fake:
L698:
L699:
	movq %rsi,L701+8(%rip)
	movl %edx,%eax
	movq %rdi,%rdx
	movl $L701,%esi
	movl %eax,%edi
	call _build_tree
	movq %rax,%rdi
	call _chop_right
L700:
	ret 


_case_expr:
L703:
	pushq %rbx
L704:
	incl _no_stmt_expr(%rip)
	call _assignment
	movq %rax,%rdi
	call _fold
	movq %rax,%rbx
	decl _no_stmt_expr(%rip)
	cmpl $2147483650,(%rbx)
	jnz L706
L713:
	cmpq $0,24(%rbx)
	jnz L706
L709:
	movq 8(%rbx),%rax
	testq $1022,(%rax)
	jnz L708
L706:
	pushq $L717
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L708:
	movq %rbx,%rax
L705:
	popq %rbx
	ret 


_constant_expr:
L719:
	pushq %rbx
L720:
	call _case_expr
	movq %rax,%rbx
	leaq 16(%rbx),%rsi
	movl $64,%edi
	call _con_in_range
	testl %eax,%eax
	jnz L724
L722:
	pushq $L725
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L724:
	movq 16(%rbx),%rax
L721:
	popq %rbx
	ret 


_static_expr:
L727:
	pushq %rbx
L728:
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
	jz L732
L730:
	pushq $L733
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L732:
	movq %rbx,%rax
L729:
	popq %rbx
	ret 

L267:
 .byte 37,107,32,114,101,113,117,105
 .byte 114,101,115,32,97,110,32,108
 .byte 118,97,108,117,101,0
L512:
 .byte 105,110,118,97,108,105,100,32
 .byte 111,112,101,114,97,110,100,115
 .byte 32,116,111,32,91,93,0
L454:
 .byte 116,111,111,32,109,97,110,121
 .byte 32,102,117,110,99,116,105,111
 .byte 110,32,97,114,103,117,109,101
 .byte 110,116,115,0
L406:
 .byte 37,107,32,114,101,113,117,105
 .byte 114,101,115,32,115,116,114,117
 .byte 99,116,32,111,114,32,117,110
 .byte 105,111,110,32,116,121,112,101
 .byte 0
L533:
 .byte 105,108,108,101,103,97,108,32
 .byte 105,110,100,105,114,101,99,116
 .byte 105,111,110,0
L246:
 .byte 105,110,99,111,109,112,97,116
 .byte 105,98,108,101,32,116,121,112
 .byte 101,40,115,41,32,102,111,114
 .byte 32,37,107,0
L584:
 .byte 105,108,108,101,103,97,108,32
 .byte 111,112,101,114,97,110,100,32
 .byte 116,111,32,117,110,97,114,121
 .byte 32,37,107,0
L355:
 .byte 115,116,97,116,101,109,101,110
 .byte 116,32,101,120,112,114,101,115
 .byte 115,105,111,110,115,32,112,114
 .byte 111,104,105,98,105,116,101,100
 .byte 32,104,101,114,101,0
L645:
 .byte 105,110,118,97,108,105,100,32
 .byte 99,97,115,116,0
L425:
 .byte 40,41,32,114,101,113,117,105
 .byte 114,101,115,32,102,117,110,99
 .byte 116,105,111,110,32,111,114,32
 .byte 112,111,105,110,116,101,114,45
 .byte 116,111,45,102,117,110,99,116
 .byte 105,111,110,0
L733:
 .byte 99,111,110,115,116,97,110,116
 .byte 32,101,120,112,114,101,115,115
 .byte 105,111,110,32,114,101,113,117
 .byte 105,114,101,100,0
L375:
 .byte 109,105,115,112,108,97,99,101
 .byte 100,32,116,121,112,101,100,101
 .byte 102,32,110,97,109,101,0
L371:
 .byte 117,110,107,110,111,119,110,32
 .byte 105,100,101,110,116,105,102,105
 .byte 101,114,0
L377:
 .byte 101,120,112,101,99,116,101,100
 .byte 32,101,120,112,114,101,115,115
 .byte 105,111,110,32,40,103,111,116
 .byte 32,37,107,41,0
L324:
 .byte 37,107,32,114,101,113,117,105
 .byte 114,101,115,32,115,99,97,108
 .byte 97,114,32,111,112,101,114,97
 .byte 110,100,0
L717:
 .byte 105,110,116,101,103,114,97,108
 .byte 32,99,111,110,115,116,97,110
 .byte 116,32,101,120,112,114,101,115
 .byte 115,105,111,110,32,114,101,113
 .byte 117,105,114,101,100,0
L725:
 .byte 99,111,110,115,116,97,110,116
 .byte 32,101,120,112,114,101,115,115
 .byte 105,111,110,32,111,117,116,32
 .byte 111,102,32,114,97,110,103,101
 .byte 0
L410:
 .byte 37,107,32,99,97,110,110,111
 .byte 116,32,98,101,32,97,112,112
 .byte 108,105,101,100,32,116,111,32
 .byte 105,110,99,111,109,112,108,101
 .byte 116,101,32,37,84,0
L171:
 .byte 37,107,32,100,105,115,99,97
 .byte 114,100,115,32,37,113,0
L279:
 .byte 99,97,110,39,116,32,97,112
 .byte 112,108,121,32,37,107,32,116
 .byte 111,32,114,101,103,105,115,116
 .byte 101,114,32,118,97,114,105,97
 .byte 98,108,101,0
L295:
 .byte 37,107,32,114,101,113,117,105
 .byte 114,101,115,32,110,111,110,45
 .byte 96,99,111,110,115,116,39,32
 .byte 116,97,114,103,101,116,0
L256:
 .byte 37,107,32,114,101,113,117,105
 .byte 114,101,115,32,97,32,115,99
 .byte 97,108,97,114,32,101,120,112
 .byte 114,101,115,115,105,111,110,0
L468:
 .byte 116,111,111,32,102,101,119,32
 .byte 102,117,110,99,116,105,111,110
 .byte 32,97,114,103,117,109,101,110
 .byte 116,115,0
L547:
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
