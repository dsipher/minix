.text

_qualifiers:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq %rdi,%r12
	movq %rsi,%rbx
L4:
	movl _token(%rip),%eax
	cmpl $-1610612670,%eax
	jz L11
L20:
	cmpl $-1610612644,%eax
	jnz L3
L13:
	orq $262144,(%r12)
	jmp L9
L3:
	popq %r12
	popq %rbx
	ret 
L11:
	orq $131072,(%r12)
L9:
	testq %rbx,%rbx
	jz L18
L16:
	orl $1,(%rbx)
L18:
	call _lex
	jmp L4

.data
.align 4
_s_k_map:
	.int 64
	.int -1610612674
	.int 128
	.int -1610612656
	.int 8
	.int -1610612648
	.int 32
	.int -1610612663
	.int 16
	.int -1610612651
.text

_s_to_k:
L23:
L24:
	xorl %ecx,%ecx
L27:
	movslq %ecx,%rdx
	cmpl _s_k_map(,%rdx,8),%edi
	jz L30
L32:
	incl %ecx
	cmpl $5,%ecx
	jl L27
	ret
L30:
	movl _s_k_map+4(,%rdx,8),%eax
L25:
	ret 


_k_to_s:
L34:
L35:
	xorl %ecx,%ecx
L38:
	movslq %ecx,%rdx
	cmpl _s_k_map+4(,%rdx,8),%edi
	jz L41
L43:
	incl %ecx
	cmpl $5,%ecx
	jl L38
	ret
L41:
	movl _s_k_map(,%rdx,8),%eax
L36:
	ret 


_member:
L45:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L46:
	movq %rdi,%r15
	movl %esi,%edi
	movq %rdx,%r14
	movq %rcx,%r13
	movq %r8,%r12
	testl %edi,%edi
	jz L53
L54:
	call _s_to_k
	pushq %rax
	pushq $L58
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L53:
	testq $32768,(%r14)
	jz L61
L59:
	pushq $L62
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
L61:
	cmpl $486539286,_token(%rip)
	jnz L65
L63:
	call _lex
	call _constant_expr
	movl %eax,%ebx
	testq $1022,(%r14)
	jnz L68
L66:
	pushq $L69
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
L68:
	cmpl $0,%ebx
	jl L74
L73:
	xorl %esi,%esi
	movq %r14,%rdi
	call _size_of
	shll $3,%eax
	cmpl %eax,%ebx
	jle L72
L74:
	pushq $L77
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
L72:
	xorl %edx,%edx
	movl %ebx,%esi
	movq %r14,%rdi
	call _fieldify
	movq %rax,%r14
L65:
	movq (%r14),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L80
L85:
	movq $545460846592,%rax
	andq %rcx,%rax
	sarq $32,%rax
	jnz L80
L86:
	testq %r15,%r15
	jz L80
L82:
	pushq $L89
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
L80:
	testq %r15,%r15
	jnz L92
L90:
	movq (%r14),%rax
	movq $549755813888,%rcx
	testq %rax,%rcx
	jnz L92
L94:
	testq $8192,%rax
	jz L101
L107:
	movq 16(%r14),%rax
	cmpq $0,(%rax)
	jnz L101
L108:
	movl (%r13),%eax
	andl $24,%eax
	cmpl $16,%eax
	jnz L101
L104:
	cmpl $23,_token(%rip)
	jz L92
L101:
	pushq $L111
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L92:
	testq $16384,(%r14)
	jz L117
L115:
	cmpl $0,16(%r14)
	jnz L117
L116:
	testl $2,12(%r12)
	jz L114
L119:
	pushq $L122
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
	jmp L114
L117:
	movq %r15,%rsi
	movq %r14,%rdi
	call _size_of
L114:
	movq %r14,%rdx
	movq %r15,%rsi
	movq %r12,%rdi
	call _insert_member
	xorl %eax,%eax
L47:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_strun_specifier:
L124:
	pushq %rbx
L125:
	movq %rdi,%rbx
	cmpl $16,_token(%rip)
	jnz L129
L127:
	movl $1,%edi
	call _enter_scope
	call _lex
L130:
	movl _token(%rip),%eax
	testl $536870912,%eax
	jnz L134
L133:
	cmpl $1,%eax
	jnz L139
L137:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L139
L134:
	movl $_member,%edx
	movq %rbx,%rsi
	xorl %edi,%edi
	call _declarations
	jmp L130
L139:
	movl $17,%edi
	call _expect
	call _lex
	movq %rbx,%rdi
	call _exit_strun
L129:
	xorl %edx,%edx
	movq %rbx,%rsi
	movl $8192,%edi
	call _get_tnode
L126:
	popq %rbx
	ret 


_enum_specifier:
L145:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L146:
	movq %rdi,%r14
	movq %rsi,%r13
	cmpl $16,_token(%rip)
	jnz L150
L148:
	call _lex
	xorl %r12d,%r12d
L151:
	movl $1,%edi
	call _expect
	movq _token+24(%rip),%rdi
	xorl %ecx,%ecx
	movl _outer_scope(%rip),%edx
	movl $2040,%esi
	call _unique
	movl $512,%esi
	movq _token+24(%rip),%rdi
	call _new_symbol
	movq %rax,%rbx
	call _lex
	cmpl $1048633,_token(%rip)
	jnz L157
L155:
	call _lex
	call _constant_expr
	movl %eax,%r12d
L157:
	movl %r12d,%eax
	incl %r12d
	movl %eax,48(%rbx)
	movl _outer_scope(%rip),%esi
	movq %rbx,%rdi
	call _insert
	cmpl $21,_token(%rip)
	jnz L162
L158:
	call _lex
	jmp L151
L162:
	movl $17,%edi
	call _expect
	call _lex
	movq _path(%rip),%rax
	movq %rax,24(%r14)
	movl _line_no(%rip),%eax
	movl %eax,20(%r14)
	orl $1073741824,12(%r14)
	orl $4,(%r13)
L150:
	testl $1073741824,12(%r14)
	jnz L170
L168:
	pushq %r14
	pushq $L171
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L170:
	movl $_int_type,%eax
L147:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_tag_specifier:
L173:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L174:
	movl _token(%rip),%eax
	movq %rdi,%r14
	xorl %r12d,%r12d
	cmpl $-1610612650,%eax
	jz L179
L222:
	cmpl $-1610612647,%eax
	jz L181
L223:
	cmpl $-1610612664,%eax
	movl $4,%eax
	cmovzl %eax,%ebx
	jmp L177
L181:
	movl $2,%ebx
	jmp L177
L179:
	movl $1,%ebx
L177:
	call _lex
	cmpl $1,_token(%rip)
	jnz L186
L185:
	movq _token+24(%rip),%r12
	call _lex
	movl _token(%rip),%eax
	cmpl $16,%eax
	jz L192
L191:
	cmpl $23,%eax
	jnz L197
L195:
	cmpl $4,%ebx
	jz L197
L192:
	orl $2,(%r14)
	movl _outer_scope(%rip),%ecx
	movl %ecx,%edx
	movl $7,%esi
	movq %r12,%rdi
	call _lookup
	movq %rax,%r13
	jmp L187
L197:
	movl $1,%ecx
	movl _outer_scope(%rip),%edx
	movl $7,%esi
	movq %r12,%rdi
	call _lookup
	movq %rax,%r13
L187:
	testq %r13,%r13
	jz L199
	jnz L201
L186:
	movl $16,%edi
	call _expect
L199:
	movl %ebx,%esi
	movq %r12,%rdi
	call _new_symbol
	movq %rax,%r13
	movl _outer_scope(%rip),%esi
	movq %rax,%rdi
	call _insert
L201:
	testl %ebx,12(%r13)
	jnz L204
L202:
	pushq %r13
	pushq %r13
	pushq $L205
	pushq $0
	pushq $4
	call _error
	addq $40,%rsp
L204:
	cmpl $16,_token(%rip)
	jnz L208
L206:
	testl $1073741824,12(%r13)
	jz L213
L209:
	pushq %r13
	pushq %r13
	pushq $L212
	pushq $0
	pushq $4
	call _error
	addq $40,%rsp
L213:
	movq _path(%rip),%rax
	movq %rax,24(%r13)
	movl _line_no(%rip),%eax
	movl %eax,20(%r13)
L208:
	orl $1,(%r14)
	cmpl $4,%ebx
	jnz L217
L216:
	movq %r14,%rsi
	movq %r13,%rdi
	call _enum_specifier
	jmp L175
L217:
	movq %r14,%rsi
	movq %r13,%rdi
	call _strun_specifier
L175:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 4
L316:
	.int -1610612674
	.int -1610612670
	.int -1610612664
	.int -1610612663
	.int -1610612656
	.int -1610612389
	.int -1610612159
	.int -1610611630
	.int -1610610610
	.int -1610608561
	.int -1610604470
	.int -1610596282
	.int -1610579878
	.int -1610547117
	.int 1
.align 2
L317:
	.short L243-_specifiers
	.short L254-_specifiers
	.short L277-_specifiers
	.short L243-_specifiers
	.short L243-_specifiers
	.short L264-_specifiers
	.short L264-_specifiers
	.short L264-_specifiers
	.short L264-_specifiers
	.short L264-_specifiers
	.short L264-_specifiers
	.short L264-_specifiers
	.short L264-_specifiers
	.short L264-_specifiers
	.short L287-_specifiers
.align 2
L318:
	.short L243-_specifiers
	.short L277-_specifiers
	.short L236-_specifiers
	.short L243-_specifiers
	.short L277-_specifiers
	.short L236-_specifiers
	.short L236-_specifiers
	.short L254-_specifiers

_specifiers:
L226:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L227:
	movq %rdi,%r14
	movq %rsi,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	movq $0,-8(%rbp)
	testq %r14,%r14
	jz L232
L229:
	movl $0,(%r14)
L232:
	movl _token(%rip),%ecx
	cmpl $-1610612651,%ecx
	jl L310
L312:
	cmpl $-1610612644,%ecx
	jg L310
L309:
	addl $1610612651,%ecx
	movzwl L318(,%rcx,2),%eax
	addl $_specifiers,%eax
	jmp *%rax
L310:
	xorl %eax,%eax
L313:
	cmpl L316(,%rax,4),%ecx
	jz L314
L315:
	incl %eax
	cmpl $15,%eax
	jb L313
	jae L236
L314:
	movzwl L317(,%rax,2),%eax
	addl $_specifiers,%eax
	jmp *%rax
L287:
	testq %r12,%r12
	jnz L236
L295:
	testl %ebx,%ebx
	jnz L236
L296:
	movq _token+24(%rip),%rdi
	call _named_type
	movq %rax,%r12
	testq %rax,%rax
	jz L236
L292:
	orl $9,(%r13)
	jmp L308
L264:
	testq %r12,%r12
	jnz L272
L268:
	andl $130816,%ecx
	testl %ebx,%ecx
	jnz L272
L270:
	orl %ecx,%ebx
	orl $1,(%r13)
	jmp L308
L277:
	testq %r12,%r12
	jnz L272
L281:
	testl %ebx,%ebx
	jnz L272
L283:
	movq %r13,%rdi
	call _tag_specifier
	movq %rax,%r12
	jmp L232
L272:
	pushq $L307
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
	jmp L228
L254:
	movq %r13,%rsi
	leaq -8(%rbp),%rdi
	call _qualifiers
	jmp L232
L243:
	testq %r14,%r14
	jnz L246
L244:
	pushq $L247
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L246:
	cmpl $0,(%r14)
	jz L250
L248:
	pushq $L251
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L250:
	movl _token(%rip),%edi
	call _k_to_s
	movl %eax,(%r14)
	orl $1,(%r13)
L308:
	call _lex
	jmp L232
L236:
	testl %ebx,%ebx
	jz L302
L300:
	movl %ebx,%edi
	call _map_type
	movq %rax,%r12
L302:
	testq %r12,%r12
	movl $_int_type,%eax
	cmovzq %rax,%r12
	movq -8(%rbp),%rsi
	movq %r12,%rdi
	call _qualify
	movq %rax,%r15
L228:
	movq %r15,%rax
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_prototype0:
L319:
L320:
	pushq %rdi
	pushq $L322
	pushq $0
	pushq $0
	call _error
	addq $32,%rsp
L321:
	ret 


_prototype:
L323:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L324:
	movq %rdi,%r13
	movq %rsi,%r12
	andq $-524289,(%r13)
	xorl %edi,%edi
	call _enter_scope
	cmpl $2684354907,_token(%rip)
	jnz L333
L329:
	leaq -32(%rbp),%rdi
	call _lookahead
	cmpl $13,(%rax)
	jz L330
L333:
	movl _token(%rip),%eax
	testl $536870912,%eax
	jnz L337
L336:
	cmpl $1,%eax
	jnz L328
L340:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L328
L337:
	movl $0,-40(%rbp)
	leaq -40(%rbp),%rsi
	leaq -36(%rbp),%rdi
	call _specifiers
	movq %rax,%rbx
	movl -36(%rbp),%edi
	testl %edi,%edi
	jz L349
L350:
	testl $128,%edi
	jnz L349
L351:
	call _s_to_k
	pushq %rax
	pushq $L58
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L349:
	movl -36(%rbp),%ecx
	testl %ecx,%ecx
	movl $256,%eax
	cmovnzl %ecx,%eax
	movl %eax,-36(%rbp)
	leaq -40(%rbp),%rdx
	leaq -48(%rbp),%rsi
	xorl %edi,%edi
	call _declarator
	movq %rbx,%rsi
	movq %rax,%rdi
	call _graft
	movq %rax,%rbx
	xorl %edx,%edx
	movq -48(%rbp),%rsi
	movq %rbx,%rdi
	call _validate
	movq %rbx,%rdi
	call _formal_type
	movq %rax,%rbx
	movq %rbx,%rsi
	movq %r13,%rdi
	call _new_formal
	movq -48(%rbp),%rdi
	xorl %ecx,%ecx
	movl _current_scope(%rip),%edx
	movl $134217728,%esi
	call _unique
	movl -36(%rbp),%esi
	orl $134217728,%esi
	movq -48(%rbp),%rdi
	call _new_symbol
	movq %rbx,32(%rax)
	movl _outer_scope(%rip),%esi
	movq %rax,%rdi
	call _insert
	cmpl $21,_token(%rip)
	jnz L328
L357:
	call _lex
	cmpl $19,_token(%rip)
	jnz L333
L360:
	call _lex
	orq $1048576,(%r13)
	jmp L328
L330:
	call _lex
L328:
	movl $_prototype0,%edx
	movl $7,%esi
	movl _outer_scope(%rip),%edi
	call _walk_scope
	movq %r12,%rdi
	call _exit_scope
L325:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_id_list:
L365:
	pushq %rbx
	pushq %r12
L366:
	movq %rdi,%r12
	xorl %edi,%edi
	call _enter_scope
L368:
	movl $1,%edi
	call _expect
	movq _token+24(%rip),%rbx
	call _lex
	movq %rbx,%rdi
	call _named_type
	testq %rax,%rax
	jz L374
L372:
	pushq $L375
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L374:
	xorl %ecx,%ecx
	movl _current_scope(%rip),%edx
	movl $134217728,%esi
	movq %rbx,%rdi
	call _unique
	movl $134217984,%esi
	movq %rbx,%rdi
	call _new_symbol
	movl _outer_scope(%rip),%esi
	movq %rax,%rdi
	call _insert
	cmpl $21,_token(%rip)
	jnz L377
L376:
	call _lex
	jmp L368
L377:
	movq %r12,%rdi
	call _exit_scope
L367:
	popq %r12
	popq %rbx
	ret 


_declarator0:
L380:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L381:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
	cmpl $12,_token(%rip)
	jnz L388
L390:
	leaq -32(%rbp),%rdi
	call _lookahead
	movl -32(%rbp),%eax
	cmpl $13,%eax
	jz L388
L391:
	testl $536870912,%eax
	jnz L388
L394:
	cmpl $1,%eax
	jnz L400
L398:
	movq -8(%rbp),%rdi
	call _named_type
	testq %rax,%rax
	jz L400
L388:
	testl $256,(%rbx)
	jz L407
L405:
	movl $1,%edi
	call _expect
L407:
	cmpl $1,_token(%rip)
	jnz L409
L408:
	movq _token+24(%rip),%rax
	testq %r12,%r12
	jz L412
L411:
	movq %rax,(%r12)
	jmp L485
L412:
	pushq $L414
	pushq %rax
	pushq $4
	call _error
	addq $24,%rsp
	jmp L418
L409:
	testq %r12,%r12
	jz L418
L415:
	movq $0,(%r12)
	jmp L418
L400:
	call _lex
	movq %rbx,%rdx
	movq %r12,%rsi
	movq %r13,%rdi
	call _declarator
	movq %rax,%r13
L486:
	movl $13,%edi
	call _expect
L485:
	call _lex
L418:
	movl _token(%rip),%eax
	cmpl $14,%eax
	jz L425
L488:
	cmpl $12,%eax
	jz L447
L489:
	movq %r13,%rax
L382:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L447:
	call _lex
	movq %r13,%rdx
	xorl %esi,%esi
	movl $557056,%edi
	call _new_tnode
	movq %rax,%r13
	movl _token(%rip),%eax
	cmpl $13,%eax
	jz L486
L448:
	cmpq $0,24(%r13)
	jnz L456
L454:
	testl $32,(%rbx)
	jz L456
L455:
	testl $536870912,%eax
	jnz L462
L461:
	cmpl $1,%eax
	jnz L467
L465:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L467
L462:
	movl $_formal_chain,%esi
	movq %r13,%rdi
	call _prototype
	jmp L486
L467:
	orl $64,(%rbx)
	movl $_formal_chain,%edi
	call _id_list
	jmp L486
L456:
	testl $536870912,%eax
	jnz L473
L472:
	cmpl $1,%eax
	jnz L486
L476:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L486
L473:
	xorl %esi,%esi
	movq %r13,%rdi
	call _prototype
	jmp L486
L425:
	call _lex
	movq %r13,%rdx
	xorl %esi,%esi
	movl $16384,%edi
	call _new_tnode
	movq %rax,%r13
	cmpl $15,_token(%rip)
	jz L443
L426:
	call _constant_expr
	movl %eax,16(%r13)
	cmpl $0,%eax
	jg L431
L429:
	testq %r12,%r12
	jz L434
L433:
	movq (%r12),%rcx
	jmp L435
L434:
	xorl %ecx,%ecx
L435:
	pushq %rax
	pushq $L432
	pushq %rcx
	pushq $4
	call _error
	addq $32,%rsp
L431:
	cmpl $134217728,16(%r13)
	jle L443
L436:
	testq %r12,%r12
	jz L441
L440:
	movq (%r12),%rax
	jmp L442
L441:
	xorl %eax,%eax
L442:
	pushq $L439
	pushq %rax
	pushq $4
	call _error
	addq $24,%rsp
L443:
	movl $15,%edi
	call _expect
	jmp L485


_declarator:
L491:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L492:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
	movq $0,-8(%rbp)
	cmpl $229638175,_token(%rip)
	jnz L495
L494:
	call _lex
	xorl %esi,%esi
	leaq -8(%rbp),%rdi
	call _qualifiers
	movq %rbx,%rdx
	movq %r12,%rsi
	movq %r13,%rdi
	call _declarator
	movq -8(%rbp),%rdi
	orq $65536,%rdi
	movq %rax,%rdx
	xorl %esi,%esi
	call _new_tnode
	jmp L493
L495:
	movq %rbx,%rdx
	movq %r12,%rsi
	movq %r13,%rdi
	call _declarator0
L493:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_declarations:
L498:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L499:
	movl %edi,-8(%rbp)
	movq %rsi,%r14
	movq %rdx,%r13
	leaq -8(%rbp),%rsi
	leaq -4(%rbp),%rdi
	call _specifiers
	movq %rax,%r12
	cmpl $23,_token(%rip)
	jnz L506
L508:
	movl -8(%rbp),%eax
	testl $6,%eax
	jz L506
L509:
	testl $128,%eax
	jnz L506
L505:
	movl -4(%rbp),%edi
	testl %edi,%edi
	jz L514
L512:
	call _s_to_k
	pushq %rax
	pushq $L515
	pushq $0
	pushq $0
	call _error
	addq $32,%rsp
L514:
	movq (%r12),%rax
	andl $393216,%eax
	jz L543
L516:
	pushq %rax
	pushq $L519
	pushq $0
	pushq $0
	call _error
	addq $32,%rsp
	jmp L543
L506:
	orl $16,-8(%rbp)
L521:
	movl -8(%rbp),%eax
	movl %eax,-20(%rbp)
	leaq -20(%rbp),%rdx
	leaq -16(%rbp),%rsi
	xorl %edi,%edi
	call _declarator
	movq %rax,%rdi
	testq %rdi,%rdi
	jz L527
L525:
	andl $-9,-20(%rbp)
L527:
	movq %r12,%rsi
	call _graft
	movq %rax,%rbx
	xorl %edx,%edx
	movq -16(%rbp),%rsi
	movq %rbx,%rdi
	call _validate
	movq %r14,%r8
	leaq -20(%rbp),%rcx
	movq %rbx,%rdx
	movl -4(%rbp),%esi
	movq -16(%rbp),%rdi
	call *%r13
	testl %eax,%eax
	jnz L500
L530:
	testl $1,-20(%rbp)
	jnz L534
L532:
	pushq $L535
	pushq -16(%rbp)
	pushq $4
	call _error
	addq $24,%rsp
L534:
	cmpl $21,_token(%rip)
	jnz L540
L536:
	call _lex
	andl $-49,-8(%rbp)
	jmp L521
L540:
	movl $23,%edi
	call _expect
L543:
	call _lex
L500:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_local:
L544:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L545:
	movq %rdi,%r13
	movl %esi,%ebx
	movq %rdx,%r12
	testl %ebx,%ebx
	jnz L549
L547:
	testq $32768,(%r12)
	movl $256,%eax
	movl $32,%ebx
	cmovzl %eax,%ebx
L549:
	testl $32,%ebx
	movl _outer_scope(%rip),%edx
	jz L554
L553:
	xorl %ecx,%ecx
	movl $1016,%esi
	movq %r13,%rdi
	call _unique
	xorl %ecx,%ecx
	movq %r12,%rdx
	movl %ebx,%esi
	movq %r13,%rdi
	call _global
	movl _outer_scope(%rip),%esi
	movq %rax,%rdi
	call _redirect
	jmp L555
L554:
	xorl %ecx,%ecx
	movl $2040,%esi
	movq %r13,%rdi
	call _unique
	movl %ebx,%esi
	movq %r13,%rdi
	call _new_symbol
	movq %rax,%r14
	movq %r12,32(%r14)
	movl _outer_scope(%rip),%esi
	movq %r14,%rdi
	call _insert
	testl $8,%ebx
	jnz L555
L556:
	testq $32768,(%r12)
	jz L560
L559:
	pushq $L562
	pushq %r13
	pushq $4
	call _error
	addq $24,%rsp
	jmp L555
L560:
	testl $448,%ebx
	jz L564
L563:
	movq %r14,%rdi
	call _init_auto
	jmp L555
L564:
	movl %ebx,%esi
	movq %r14,%rdi
	call _init_static
L555:
	xorl %eax,%eax
L546:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_locals:
L567:
L570:
	movl _token(%rip),%eax
	testl $536870912,%eax
	jnz L571
L573:
	cmpl $1,%eax
	jnz L569
L577:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L569
L571:
	movl $_local,%edx
	xorl %esi,%esi
	movl $256,%edi
	call _declarations
	jmp L570
L569:
	ret 


_old_arg:
L581:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L582:
	movq %rdi,%r12
	movl %esi,%r14d
	movq %rdx,%rbx
	testl %r14d,%r14d
	jz L589
L590:
	testl $128,%r14d
	jnz L589
L591:
	movl %r14d,%edi
	call _s_to_k
	pushq %rax
	pushq $L58
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L589:
	testl %r14d,%r14d
	movl $256,%r13d
	cmovnzl %r14d,%r13d
	movl $2,%ecx
	movl $2,%edx
	movl $134217728,%esi
	movq %r12,%rdi
	call _lookup
	movq %rax,%r14
	testq %r14,%r14
	jnz L599
L597:
	pushq $L600
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L599:
	cmpq $0,32(%r14)
	jz L603
L601:
	pushq $L604
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L603:
	testq $1024,(%rbx)
	jz L607
L605:
	orl $16777216,%r13d
L607:
	orl $134217728,%r13d
	movl %r13d,12(%r14)
	movq %rbx,%rdi
	call _formal_type
	movq %rax,32(%r14)
	xorl %eax,%eax
L583:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_funcdef:
L609:
	pushq %rbx
	pushq %r12
L610:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl $_formal_chain,%edi
	call _reenter_scope
	testl $64,(%r12)
	jz L614
L615:
	movl _token(%rip),%eax
	testl $536870912,%eax
	jnz L616
L618:
	cmpl $1,%eax
	jnz L614
L622:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L614
L616:
	movl $_old_arg,%edx
	xorl %esi,%esi
	movl $384,%edi
	call _declarations
	jmp L615
L614:
	movq %rbx,%rdi
	call _enter_func
	movl $1,%edi
	call _compound
	movl $_func_chain,%edi
	call _exit_scope
	call _exit_func
L611:
	popq %r12
	popq %rbx
	ret 


_external:
L626:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L627:
	movq %rdi,%r15
	movl %esi,%r12d
	movq %rdx,%r14
	movq %rcx,%r13
	movl $0,-8(%rbp)
	testl %r12d,%r12d
	jz L634
L635:
	testl $56,%r12d
	jnz L634
L636:
	movl %r12d,%edi
	call _s_to_k
	pushq %rax
	pushq $L58
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L634:
	testl %r12d,%r12d
	movl $32,%ebx
	cmovnzl %r12d,%ebx
	testl $8,%r12d
	jz L643
L642:
	xorl %r8d,%r8d
	movq %r13,%rcx
	movq %r14,%rdx
	movl %r12d,%esi
	movq %r15,%rdi
	call _local
	jmp L644
L643:
	xorl %ecx,%ecx
	movl $1,%edx
	movl $520,%esi
	movq %r15,%rdi
	call _unique
	movl $1,%ecx
	movq %r14,%rdx
	movl %ebx,%esi
	movq %r15,%rdi
	call _global
	movq %rax,%rdi
	testq $32768,(%r14)
	jz L646
L645:
	movl _token(%rip),%eax
	cmpl $21,%eax
	jz L644
L659:
	cmpl $23,%eax
	jz L644
L660:
	movl (%r13),%eax
	testl $32,%eax
	jz L644
L656:
	testl $8,%eax
	jnz L644
L652:
	movq %rdi,%rsi
	movq %r13,%rdi
	call _funcdef
	movl $1,-8(%rbp)
	jmp L644
L646:
	movl %r12d,%esi
	call _init_static
L644:
	cmpq $0,_formal_chain(%rip)
	jz L665
L663:
	testl $64,(%r13)
	jz L668
L666:
	pushq $L669
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
L668:
	movl $_formal_chain,%edi
	call _free_symbols
L665:
	movl -8(%rbp),%eax
L628:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_externals:
L671:
L674:
	cmpl $0,_token(%rip)
	jz L673
L675:
	movl $_external,%edx
	xorl %esi,%esi
	movl $288,%edi
	call _declarations
	movq _stmt_arena(%rip),%rax
	movq %rax,_stmt_arena+8(%rip)
	call _purge_anons
	jmp L674
L673:
	ret 


_abstract:
L680:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L681:
	movl $0,-4(%rbp)
	leaq -4(%rbp),%rsi
	xorl %edi,%edi
	call _specifiers
	movq %rax,%rbx
	leaq -4(%rbp),%rdx
	xorl %esi,%esi
	xorl %edi,%edi
	call _declarator
	movq %rbx,%rsi
	movq %rax,%rdi
	call _graft
	movq %rax,%rbx
	movl $1,%edx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _validate
	movq %rbx,%rax
L682:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L111:
 .byte 109,105,115,115,105,110,103,32
 .byte 109,101,109,98,101,114,32,105
 .byte 100,101,110,116,105,102,105,101
 .byte 114,0
L375:
 .byte 105,115,32,97,32,116,121,112
 .byte 101,100,101,102,0
L669:
 .byte 109,105,115,112,108,97,99,101
 .byte 100,32,111,108,100,45,115,116
 .byte 121,108,101,32,97,114,103,117
 .byte 109,101,110,116,115,0
L171:
 .byte 37,84,32,105,115,32,105,110
 .byte 99,111,109,112,108,101,116,101
 .byte 0
L562:
 .byte 110,111,32,108,111,99,97,108
 .byte 32,102,117,110,99,116,105,111
 .byte 110,115,0
L322:
 .byte 37,84,32,100,101,99,108,97
 .byte 114,101,100,32,105,110,32,97
 .byte 114,103,117,109,101,110,116,32
 .byte 108,105,115,116,0
L307:
 .byte 116,111,111,32,109,97,110,121
 .byte 32,116,121,112,101,32,115,112
 .byte 101,99,105,102,105,101,114,115
 .byte 0
L58:
 .byte 105,110,118,97,108,105,100,32
 .byte 115,116,111,114,97,103,101,32
 .byte 99,108,97,115,115,32,37,107
 .byte 0
L62:
 .byte 102,117,110,99,116,105,111,110
 .byte 115,32,99,97,110,39,116,32
 .byte 98,101,32,109,101,109,98,101
 .byte 114,115,0
L519:
 .byte 117,115,101,108,101,115,115,32
 .byte 37,113,0
L535:
 .byte 109,105,115,115,105,110,103,32
 .byte 100,101,99,108,97,114,97,116
 .byte 105,111,110,32,115,112,101,99
 .byte 105,102,105,101,114,115,0
L247:
 .byte 110,111,32,115,116,111,114,97
 .byte 103,101,32,99,108,97,115,115
 .byte 32,112,101,114,109,105,116,116
 .byte 101,100,32,104,101,114,101,0
L89:
 .byte 97,108,105,103,110,109,101,110
 .byte 116,32,102,105,101,108,100,115
 .byte 32,109,117,115,116,32,98,101
 .byte 32,97,110,111,110,121,109,111
 .byte 117,115,0
L439:
 .byte 115,111,114,114,121,44,32,100
 .byte 105,109,101,110,115,105,111,110
 .byte 32,116,111,111,32,98,105,103
 .byte 0
L122:
 .byte 117,110,105,111,110,115,32,99
 .byte 97,110,39,116,32,104,97,118
 .byte 101,32,102,108,101,120,105,98
 .byte 108,101,32,97,114,114,97,121
 .byte 115,0
L432:
 .byte 98,111,103,117,115,32,100,105
 .byte 109,101,110,115,105,111,110,32
 .byte 40,37,100,41,0
L251:
 .byte 109,117,108,116,105,112,108,101
 .byte 32,115,116,111,114,97,103,101
 .byte 32,99,108,97,115,115,32,115
 .byte 112,101,99,105,102,105,101,114
 .byte 115,0
L69:
 .byte 98,105,116,102,105,101,108,100
 .byte 115,32,109,117,115,116,32,104
 .byte 97,118,101,32,105,110,116,101
 .byte 103,114,97,108,32,116,121,112
 .byte 101,0
L77:
 .byte 102,105,101,108,100,32,119,105
 .byte 100,116,104,32,101,120,99,101
 .byte 101,100,115,32,116,104,97,116
 .byte 32,111,102,32,104,111,115,116
 .byte 32,116,121,112,101,0
L205:
 .byte 116,97,103,32,99,111,110,102
 .byte 117,115,105,111,110,44,32,112
 .byte 114,101,118,105,111,117,115,108
 .byte 121,32,37,84,32,37,76,0
L414:
 .byte 97,98,115,116,114,97,99,116
 .byte 32,116,121,112,101,32,114,101
 .byte 113,117,105,114,101,100,0
L515:
 .byte 115,116,114,97,121,32,115,116
 .byte 111,114,97,103,101,32,99,108
 .byte 97,115,115,32,37,107,0
L212:
 .byte 37,84,32,97,108,114,101,97
 .byte 100,121,32,100,101,102,105,110
 .byte 101,100,32,37,76,0
L604:
 .byte 116,121,112,101,32,97,108,114
 .byte 101,97,100,121,32,100,101,99
 .byte 108,97,114,101,100,0
L600:
 .byte 105,115,32,110,111,116,32,97
 .byte 110,32,97,114,103,117,109,101
 .byte 110,116,0
.local _formal_chain
.comm _formal_chain, 8, 8

.globl _stmt_arena
.globl _named_type
.globl _lookahead
.globl _lex
.globl _func_chain
.globl _enter_scope
.globl _new_symbol
.globl _error
.globl _expect
.globl _init_static
.globl _graft
.globl _reenter_scope
.globl _insert
.globl _purge_anons
.globl _insert_member
.globl _exit_func
.globl _fieldify
.globl _path
.globl _constant_expr
.globl _locals
.globl _new_formal
.globl _global
.globl _line_no
.globl _get_tnode
.globl _enter_func
.globl _new_tnode
.globl _qualify
.globl _formal_type
.globl _redirect
.globl _unique
.globl _abstract
.globl _free_symbols
.globl _map_type
.globl _int_type
.globl _walk_scope
.globl _init_auto
.globl _lookup
.globl _externals
.globl _exit_strun
.globl _current_scope
.globl _outer_scope
.globl _compound
.globl _validate
.globl _exit_scope
.globl _token
.globl _size_of
