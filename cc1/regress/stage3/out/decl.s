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
	cmpl _s_k_map(,%rcx,8),%edi
	jz L30
L32:
	incl %ecx
	cmpl $5,%ecx
	jl L27
	ret
L30:
	movl _s_k_map+4(,%rcx,8),%eax
L25:
	ret 


_k_to_s:
L34:
L35:
	xorl %ecx,%ecx
L38:
	cmpl _s_k_map+4(,%rcx,8),%edi
	jz L41
L43:
	incl %ecx
	cmpl $5,%ecx
	jl L38
	ret
L41:
	movl _s_k_map(,%rcx,8),%eax
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
	movq %rdi,%r14
	movl %esi,%edi
	movq %rdx,%r13
	movq %rcx,%r12
	movq %r8,%rbx
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
	testq $32768,(%r13)
	jz L61
L59:
	pushq $L62
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
L61:
	cmpl $486539286,_token(%rip)
	jnz L65
L63:
	call _lex
	call _constant_expr
	movl %eax,%r15d
	testq $1022,(%r13)
	jnz L68
L66:
	pushq $L69
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
L68:
	cmpl $0,%r15d
	jl L74
L73:
	xorl %esi,%esi
	movq %r13,%rdi
	call _size_of
	shll $3,%eax
	cmpl %eax,%r15d
	jle L72
L74:
	pushq $L77
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
L72:
	xorl %edx,%edx
	movl %r15d,%esi
	movq %r13,%rdi
	call _fieldify
	movq %rax,%r13
L65:
	movq (%r13),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L80
L85:
	movq $545460846592,%rax
	andq %rcx,%rax
	sarq $32,%rax
	jnz L80
L86:
	testq %r14,%r14
	jz L80
L82:
	pushq $L89
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
L80:
	testq %r14,%r14
	jnz L92
L90:
	movq (%r13),%rax
	movq $549755813888,%rcx
	testq %rax,%rcx
	jnz L92
L94:
	testq $8192,%rax
	jz L101
L107:
	movq 16(%r13),%rax
	cmpq $0,(%rax)
	jnz L101
L108:
	movl (%r12),%eax
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
	testq $16384,(%r13)
	jz L117
L115:
	cmpl $0,16(%r13)
	jnz L117
L116:
	testl $2,12(%rbx)
	jz L114
L119:
	pushq $L122
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
	jmp L114
L117:
	movq %r14,%rsi
	movq %r13,%rdi
	call _size_of
L114:
	movq %r13,%rdx
	movq %r14,%rsi
	movq %rbx,%rdi
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
	movq %rdi,%r12
	movq %rsi,%rbx
	cmpl $16,_token(%rip)
	jnz L150
L148:
	call _lex
	xorl %r14d,%r14d
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
	movq %rax,%r13
	call _lex
	cmpl $1048633,_token(%rip)
	jnz L157
L155:
	call _lex
	call _constant_expr
	movl %eax,%r14d
L157:
	movl %r14d,%eax
	incl %r14d
	movl %eax,48(%r13)
	movl _outer_scope(%rip),%esi
	movq %r13,%rdi
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
	movq %rax,24(%r12)
	movl _line_no(%rip),%eax
	movl %eax,20(%r12)
	orl $1073741824,12(%r12)
	orl $4,(%rbx)
L150:
	testl $1073741824,12(%r12)
	jnz L170
L168:
	pushq %r12
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
	jmp L226
L197:
	movl $1,%ecx
	movl _outer_scope(%rip),%edx
L226:
	movl $7,%esi
	movq %r12,%rdi
	call _lookup
	movq %rax,%r13
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
L317:
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
L318:
	.short L244-_specifiers
	.short L255-_specifiers
	.short L278-_specifiers
	.short L244-_specifiers
	.short L244-_specifiers
	.short L265-_specifiers
	.short L265-_specifiers
	.short L265-_specifiers
	.short L265-_specifiers
	.short L265-_specifiers
	.short L265-_specifiers
	.short L265-_specifiers
	.short L265-_specifiers
	.short L265-_specifiers
	.short L288-_specifiers
.align 2
L319:
	.short L244-_specifiers
	.short L278-_specifiers
	.short L237-_specifiers
	.short L244-_specifiers
	.short L278-_specifiers
	.short L237-_specifiers
	.short L237-_specifiers
	.short L255-_specifiers

_specifiers:
L227:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L228:
	movq %rdi,%r15
	movq %rsi,%r14
	xorl %r13d,%r13d
	xorl %r12d,%r12d
	movq $0,-8(%rbp)
	testq %r15,%r15
	jz L233
L230:
	movl $0,(%r15)
L233:
	movl _token(%rip),%eax
	cmpl $-1610612651,%eax
	jl L311
L313:
	cmpl $-1610612644,%eax
	jg L311
L310:
	addl $1610612651,%eax
	movzwl L319(,%rax,2),%eax
	addl $_specifiers,%eax
	jmp *%rax
L311:
	xorl %ecx,%ecx
L314:
	cmpl L317(,%rcx,4),%eax
	jz L315
L316:
	incl %ecx
	cmpl $15,%ecx
	jb L314
	jae L237
L315:
	movzwl L318(,%rcx,2),%ecx
	addl $_specifiers,%ecx
	jmp *%rcx
L288:
	testq %r13,%r13
	jnz L237
L296:
	testl %r12d,%r12d
	jnz L237
L297:
	movq _token+24(%rip),%rdi
	call _named_type
	movq %rax,%r13
	testq %rax,%rax
	jz L237
L293:
	orl $9,(%r14)
	jmp L309
L265:
	testq %r13,%r13
	jnz L273
L269:
	andl $130816,%eax
	testl %r12d,%eax
	jnz L273
L271:
	orl %eax,%r12d
	jmp L320
L278:
	testq %r13,%r13
	jnz L273
L282:
	testl %r12d,%r12d
	jnz L273
L284:
	movq %r14,%rdi
	call _tag_specifier
	movq %rax,%r13
	jmp L233
L273:
	pushq $L308
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
	jmp L229
L255:
	movq %r14,%rsi
	leaq -8(%rbp),%rdi
	call _qualifiers
	jmp L233
L244:
	testq %r15,%r15
	jnz L247
L245:
	pushq $L248
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L247:
	cmpl $0,(%r15)
	jz L251
L249:
	pushq $L252
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L251:
	movl _token(%rip),%edi
	call _k_to_s
	movl %eax,(%r15)
L320:
	orl $1,(%r14)
L309:
	call _lex
	jmp L233
L237:
	testl %r12d,%r12d
	jz L303
L301:
	movl %r12d,%edi
	call _map_type
	movq %rax,%r13
L303:
	testq %r13,%r13
	movl $_int_type,%eax
	cmovzq %rax,%r13
	movq -8(%rbp),%rsi
	movq %r13,%rdi
	call _qualify
	movq %rax,%rbx
L229:
	movq %rbx,%rax
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_prototype0:
L321:
L322:
	pushq %rdi
	pushq $L324
	pushq $0
	pushq $0
	call _error
	addq $32,%rsp
L323:
	ret 


_prototype:
L325:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L326:
	movq %rdi,%r12
	movq %rsi,%rbx
	andq $-524289,(%r12)
	xorl %edi,%edi
	call _enter_scope
	cmpl $2684354907,_token(%rip)
	jnz L335
L331:
	leaq -32(%rbp),%rdi
	call _lookahead
	cmpl $13,(%rax)
	jz L332
L335:
	movl _token(%rip),%eax
	testl $536870912,%eax
	jnz L339
L338:
	cmpl $1,%eax
	jnz L330
L342:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L330
L339:
	movl $0,-40(%rbp)
	leaq -40(%rbp),%rsi
	leaq -36(%rbp),%rdi
	call _specifiers
	movq %rax,%r13
	movl -36(%rbp),%edi
	testl %edi,%edi
	jz L351
L352:
	testl $128,%edi
	jnz L351
L353:
	call _s_to_k
	pushq %rax
	pushq $L58
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L351:
	movl -36(%rbp),%ecx
	testl %ecx,%ecx
	movl $256,%eax
	cmovnzl %ecx,%eax
	movl %eax,-36(%rbp)
	leaq -40(%rbp),%rdx
	leaq -48(%rbp),%rsi
	xorl %edi,%edi
	call _declarator
	movq %r13,%rsi
	movq %rax,%rdi
	call _graft
	movq %rax,%r13
	xorl %edx,%edx
	movq -48(%rbp),%rsi
	movq %r13,%rdi
	call _validate
	movq %r13,%rdi
	call _formal_type
	movq %rax,%r13
	movq %r13,%rsi
	movq %r12,%rdi
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
	movq %r13,32(%rax)
	movl _outer_scope(%rip),%esi
	movq %rax,%rdi
	call _insert
	cmpl $21,_token(%rip)
	jnz L330
L359:
	call _lex
	cmpl $19,_token(%rip)
	jnz L335
L362:
	call _lex
	orq $1048576,(%r12)
	jmp L330
L332:
	call _lex
L330:
	movl $_prototype0,%edx
	movl $7,%esi
	movl _outer_scope(%rip),%edi
	call _walk_scope
	movq %rbx,%rdi
	call _exit_scope
L327:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_id_list:
L367:
	pushq %rbx
	pushq %r12
L368:
	movq %rdi,%r12
	xorl %edi,%edi
	call _enter_scope
L370:
	movl $1,%edi
	call _expect
	movq _token+24(%rip),%rbx
	call _lex
	movq %rbx,%rdi
	call _named_type
	testq %rax,%rax
	jz L376
L374:
	pushq $L377
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L376:
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
	jnz L379
L378:
	call _lex
	jmp L370
L379:
	movq %r12,%rdi
	call _exit_scope
L369:
	popq %r12
	popq %rbx
	ret 


_declarator0:
L382:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L383:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
	cmpl $12,_token(%rip)
	jnz L390
L392:
	leaq -32(%rbp),%rdi
	call _lookahead
	movl -32(%rbp),%eax
	cmpl $13,%eax
	jz L390
L393:
	testl $536870912,%eax
	jnz L390
L396:
	cmpl $1,%eax
	jnz L402
L400:
	movq -8(%rbp),%rdi
	call _named_type
	testq %rax,%rax
	jz L402
L390:
	testl $256,(%rbx)
	jz L409
L407:
	movl $1,%edi
	call _expect
L409:
	cmpl $1,_token(%rip)
	jnz L411
L410:
	movq _token+24(%rip),%rax
	testq %r12,%r12
	jz L414
L413:
	movq %rax,(%r12)
	jmp L487
L414:
	pushq $L416
	pushq %rax
	pushq $4
	call _error
	addq $24,%rsp
	jmp L420
L411:
	testq %r12,%r12
	jz L420
L417:
	movq $0,(%r12)
	jmp L420
L402:
	call _lex
	movq %rbx,%rdx
	movq %r12,%rsi
	movq %r13,%rdi
	call _declarator
	movq %rax,%r13
L488:
	movl $13,%edi
L493:
	call _expect
L487:
	call _lex
L420:
	movl _token(%rip),%eax
	cmpl $14,%eax
	jz L427
L490:
	cmpl $12,%eax
	jz L449
L491:
	movq %r13,%rax
L384:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L449:
	call _lex
	movq %r13,%rdx
	xorl %esi,%esi
	movl $557056,%edi
	call _new_tnode
	movq %rax,%r13
	movl _token(%rip),%eax
	cmpl $13,%eax
	jz L488
L450:
	cmpq $0,24(%r13)
	jnz L458
L456:
	testl $32,(%rbx)
	jz L458
L457:
	testl $536870912,%eax
	jnz L464
L463:
	cmpl $1,%eax
	jnz L469
L467:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L469
L464:
	movl $_formal_chain,%esi
	jmp L494
L469:
	orl $64,(%rbx)
	movl $_formal_chain,%edi
	call _id_list
	jmp L488
L458:
	testl $536870912,%eax
	jnz L475
L474:
	cmpl $1,%eax
	jnz L488
L478:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L488
L475:
	xorl %esi,%esi
L494:
	movq %r13,%rdi
	call _prototype
	jmp L488
L427:
	call _lex
	movq %r13,%rdx
	xorl %esi,%esi
	movl $16384,%edi
	call _new_tnode
	movq %rax,%r13
	cmpl $15,_token(%rip)
	jz L445
L428:
	call _constant_expr
	movl %eax,16(%r13)
	cmpl $0,%eax
	jg L433
L431:
	testq %r12,%r12
	jz L436
L435:
	movq (%r12),%rcx
	jmp L437
L436:
	xorl %ecx,%ecx
L437:
	pushq %rax
	pushq $L434
	pushq %rcx
	pushq $4
	call _error
	addq $32,%rsp
L433:
	cmpl $134217728,16(%r13)
	jle L445
L438:
	testq %r12,%r12
	jz L443
L442:
	movq (%r12),%rax
	jmp L444
L443:
	xorl %eax,%eax
L444:
	pushq $L441
	pushq %rax
	pushq $4
	call _error
	addq $24,%rsp
L445:
	movl $15,%edi
	jmp L493


_declarator:
L495:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L496:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
	movq $0,-8(%rbp)
	cmpl $229638175,_token(%rip)
	jnz L499
L498:
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
	jmp L497
L499:
	movq %rbx,%rdx
	movq %r12,%rsi
	movq %r13,%rdi
	call _declarator0
L497:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_declarations:
L502:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L503:
	movl %edi,-8(%rbp)
	movq %rsi,%r14
	movq %rdx,%r13
	leaq -8(%rbp),%rsi
	leaq -4(%rbp),%rdi
	call _specifiers
	movq %rax,%r12
	cmpl $23,_token(%rip)
	jnz L510
L512:
	movl -8(%rbp),%eax
	testl $6,%eax
	jz L510
L513:
	testl $128,%eax
	jnz L510
L509:
	movl -4(%rbp),%edi
	testl %edi,%edi
	jz L518
L516:
	call _s_to_k
	pushq %rax
	pushq $L519
	pushq $0
	pushq $0
	call _error
	addq $32,%rsp
L518:
	movq (%r12),%rax
	andl $393216,%eax
	jz L547
L520:
	pushq %rax
	pushq $L523
	pushq $0
	pushq $0
	call _error
	addq $32,%rsp
	jmp L547
L510:
	orl $16,-8(%rbp)
L525:
	movl -8(%rbp),%eax
	movl %eax,-20(%rbp)
	leaq -20(%rbp),%rdx
	leaq -16(%rbp),%rsi
	xorl %edi,%edi
	call _declarator
	movq %rax,%rdi
	testq %rdi,%rdi
	jz L531
L529:
	andl $-9,-20(%rbp)
L531:
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
	jnz L504
L534:
	testl $1,-20(%rbp)
	jnz L538
L536:
	pushq $L539
	pushq -16(%rbp)
	pushq $4
	call _error
	addq $24,%rsp
L538:
	cmpl $21,_token(%rip)
	jnz L544
L540:
	call _lex
	andl $-49,-8(%rbp)
	jmp L525
L544:
	movl $23,%edi
	call _expect
L547:
	call _lex
L504:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_local:
L548:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L549:
	movq %rdi,%r14
	movl %esi,%r12d
	movq %rdx,%r13
	testl %r12d,%r12d
	jnz L553
L551:
	testq $32768,(%r13)
	movl $256,%eax
	movl $32,%r12d
	cmovzl %eax,%r12d
L553:
	testl $32,%r12d
	movl _outer_scope(%rip),%edx
	jz L558
L557:
	xorl %ecx,%ecx
	movl $1016,%esi
	movq %r14,%rdi
	call _unique
	xorl %ecx,%ecx
	movq %r13,%rdx
	movl %r12d,%esi
	movq %r14,%rdi
	call _global
	movl _outer_scope(%rip),%esi
	movq %rax,%rdi
	call _redirect
	jmp L559
L558:
	xorl %ecx,%ecx
	movl $2040,%esi
	movq %r14,%rdi
	call _unique
	movl %r12d,%esi
	movq %r14,%rdi
	call _new_symbol
	movq %rax,%rbx
	movq %r13,32(%rbx)
	movl _outer_scope(%rip),%esi
	movq %rbx,%rdi
	call _insert
	testl $8,%r12d
	jnz L559
L560:
	testq $32768,(%r13)
	jz L564
L563:
	pushq $L566
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
	jmp L559
L564:
	testl $448,%r12d
	jz L568
L567:
	movq %rbx,%rdi
	call _init_auto
	jmp L559
L568:
	movl %r12d,%esi
	movq %rbx,%rdi
	call _init_static
L559:
	xorl %eax,%eax
L550:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_locals:
L571:
L574:
	movl _token(%rip),%eax
	testl $536870912,%eax
	jnz L575
L577:
	cmpl $1,%eax
	jnz L573
L581:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L573
L575:
	movl $_local,%edx
	xorl %esi,%esi
	movl $256,%edi
	call _declarations
	jmp L574
L573:
	ret 


_old_arg:
L585:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L586:
	movq %rdi,%r14
	movl %esi,%r12d
	movq %rdx,%r13
	testl %r12d,%r12d
	jz L593
L594:
	testl $128,%r12d
	jnz L593
L595:
	movl %r12d,%edi
	call _s_to_k
	pushq %rax
	pushq $L58
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L593:
	testl %r12d,%r12d
	movl $256,%ebx
	cmovnzl %r12d,%ebx
	movl $2,%ecx
	movl $2,%edx
	movl $134217728,%esi
	movq %r14,%rdi
	call _lookup
	movq %rax,%r12
	testq %r12,%r12
	jnz L603
L601:
	pushq $L604
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
L603:
	cmpq $0,32(%r12)
	jz L607
L605:
	pushq $L608
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
L607:
	testq $1024,(%r13)
	jz L611
L609:
	orl $16777216,%ebx
L611:
	orl $134217728,%ebx
	movl %ebx,12(%r12)
	movq %r13,%rdi
	call _formal_type
	movq %rax,32(%r12)
	xorl %eax,%eax
L587:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_funcdef:
L613:
	pushq %rbx
	pushq %r12
L614:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl $_formal_chain,%edi
	call _reenter_scope
	testl $64,(%r12)
	jz L618
L619:
	movl _token(%rip),%eax
	testl $536870912,%eax
	jnz L620
L622:
	cmpl $1,%eax
	jnz L618
L626:
	movq _token+24(%rip),%rdi
	call _named_type
	testq %rax,%rax
	jz L618
L620:
	movl $_old_arg,%edx
	xorl %esi,%esi
	movl $384,%edi
	call _declarations
	jmp L619
L618:
	movq %rbx,%rdi
	call _enter_func
	movl $1,%edi
	call _compound
	movl $_func_chain,%edi
	call _exit_scope
	call _exit_func
L615:
	popq %r12
	popq %rbx
	ret 


_external:
L630:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L631:
	movq %rdi,%r12
	movl %esi,%r14d
	movq %rdx,%r15
	movq %rcx,%rbx
	movl $0,-4(%rbp) # spill
	testl %r14d,%r14d
	jz L638
L639:
	testl $56,%r14d
	jnz L638
L640:
	movl %r14d,%edi
	call _s_to_k
	pushq %rax
	pushq $L58
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L638:
	testl %r14d,%r14d
	movl $32,%r13d
	cmovnzl %r14d,%r13d
	testl $8,%r14d
	jz L647
L646:
	xorl %r8d,%r8d
	movq %rbx,%rcx
	movq %r15,%rdx
	movl %r14d,%esi
	movq %r12,%rdi
	call _local
	jmp L648
L647:
	xorl %ecx,%ecx
	movl $1,%edx
	movl $520,%esi
	movq %r12,%rdi
	call _unique
	movl $1,%ecx
	movq %r15,%rdx
	movl %r13d,%esi
	movq %r12,%rdi
	call _global
	movq %rax,%rdi
	testq $32768,(%r15)
	jz L650
L649:
	movl _token(%rip),%eax
	cmpl $21,%eax
	jz L648
L663:
	cmpl $23,%eax
	jz L648
L664:
	movl (%rbx),%eax
	testl $32,%eax
	jz L648
L660:
	testl $8,%eax
	jnz L648
L656:
	movq %rdi,%rsi
	movq %rbx,%rdi
	call _funcdef
	movl $1,-4(%rbp) # spill
	jmp L648
L650:
	movl %r14d,%esi
	call _init_static
L648:
	cmpq $0,_formal_chain(%rip)
	jz L669
L667:
	testl $64,(%rbx)
	jz L672
L670:
	pushq $L673
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L672:
	movl $_formal_chain,%edi
	call _free_symbols
L669:
	movl -4(%rbp),%eax # spill
L632:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_externals:
L675:
	jmp L678
L679:
	movl $_external,%edx
	xorl %esi,%esi
	movl $288,%edi
	call _declarations
	movq _stmt_arena(%rip),%rax
	movq %rax,_stmt_arena+8(%rip)
	call _purge_anons
L678:
	cmpl $0,_token(%rip)
	jnz L679
L677:
	ret 


_abstract:
L684:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L685:
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
L686:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L111:
	.byte 109,105,115,115,105,110,103,32
	.byte 109,101,109,98,101,114,32,105
	.byte 100,101,110,116,105,102,105,101
	.byte 114,0
L377:
	.byte 105,115,32,97,32,116,121,112
	.byte 101,100,101,102,0
L673:
	.byte 109,105,115,112,108,97,99,101
	.byte 100,32,111,108,100,45,115,116
	.byte 121,108,101,32,97,114,103,117
	.byte 109,101,110,116,115,0
L171:
	.byte 37,84,32,105,115,32,105,110
	.byte 99,111,109,112,108,101,116,101
	.byte 0
L566:
	.byte 110,111,32,108,111,99,97,108
	.byte 32,102,117,110,99,116,105,111
	.byte 110,115,0
L324:
	.byte 37,84,32,100,101,99,108,97
	.byte 114,101,100,32,105,110,32,97
	.byte 114,103,117,109,101,110,116,32
	.byte 108,105,115,116,0
L308:
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
L523:
	.byte 117,115,101,108,101,115,115,32
	.byte 37,113,0
L539:
	.byte 109,105,115,115,105,110,103,32
	.byte 100,101,99,108,97,114,97,116
	.byte 105,111,110,32,115,112,101,99
	.byte 105,102,105,101,114,115,0
L248:
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
L441:
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
L434:
	.byte 98,111,103,117,115,32,100,105
	.byte 109,101,110,115,105,111,110,32
	.byte 40,37,100,41,0
L252:
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
L416:
	.byte 97,98,115,116,114,97,99,116
	.byte 32,116,121,112,101,32,114,101
	.byte 113,117,105,114,101,100,0
L519:
	.byte 115,116,114,97,121,32,115,116
	.byte 111,114,97,103,101,32,99,108
	.byte 97,115,115,32,37,107,0
L212:
	.byte 37,84,32,97,108,114,101,97
	.byte 100,121,32,100,101,102,105,110
	.byte 101,100,32,37,76,0
L608:
	.byte 116,121,112,101,32,97,108,114
	.byte 101,97,100,121,32,100,101,99
	.byte 108,97,114,101,100,0
L604:
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
