.data
.align 8
_void_tree:
	.int -2147483648
	.int 0
	.quad _void_type
	.fill 16, 1, 0
.text

_chop:
L1:
	pushq %rbx
L2:
	movq 8(%rdi),%rcx
	movq 16(%rdi),%rax
	movq %rcx,8(%rax)
	movq 16(%rdi),%rbx
	cmpl $2147483650,(%rbx)
	jnz L9
L7:
	movq 8(%rbx),%rax
	movq (%rax),%rdi
	andl $131071,%edi
	leaq 16(%rbx),%rsi
	call _normalize_con
L9:
	movq %rbx,%rax
L3:
	popq %rbx
	ret 


_chop_left:
L11:
	pushq %rbx
L12:
	movq 8(%rdi),%rcx
	movq 16(%rdi),%rax
	movq %rcx,8(%rax)
	movq 16(%rdi),%rbx
	cmpl $2147483650,(%rbx)
	jnz L19
L17:
	movq 8(%rbx),%rax
	movq (%rax),%rdi
	andl $131071,%edi
	leaq 16(%rbx),%rsi
	call _normalize_con
L19:
	movq %rbx,%rax
L13:
	popq %rbx
	ret 


_chop_right:
L21:
	pushq %rbx
L22:
	movq 8(%rdi),%rcx
	movq 24(%rdi),%rax
	movq %rcx,8(%rax)
	movq 24(%rdi),%rbx
	cmpl $2147483650,(%rbx)
	jnz L29
L27:
	movq 8(%rbx),%rax
	movq (%rax),%rdi
	andl $131071,%edi
	leaq 16(%rbx),%rsi
	call _normalize_con
L29:
	movq %rbx,%rax
L23:
	popq %rbx
	ret 


_unary_tree:
L31:
L32:
	movq _stmt_arena+8(%rip),%r8
	movq %r8,%rcx
	andl $7,%ecx
	jz L39
L37:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%r8
	movq %r8,_stmt_arena+8(%rip)
L39:
	movq _stmt_arena+8(%rip),%rax
	leaq 32(%rax),%rcx
	movq %rcx,_stmt_arena+8(%rip)
	movl %edi,(%rax)
	movl $0,4(%rax)
	movq %rsi,8(%rax)
	movq %rdx,16(%rax)
	movq $0,24(%rax)
L33:
	ret 


_binary_tree:
L41:
L42:
	movq _stmt_arena+8(%rip),%r9
	movq %r9,%r8
	andl $7,%r8d
	jz L49
L47:
	movl $8,%eax
	subq %r8,%rax
	addq %rax,%r9
	movq %r9,_stmt_arena+8(%rip)
L49:
	movq _stmt_arena+8(%rip),%rax
	leaq 32(%rax),%r8
	movq %r8,_stmt_arena+8(%rip)
	movl %edi,(%rax)
	movl $0,4(%rax)
	movq %rsi,8(%rax)
	movq %rdx,16(%rax)
	movq %rcx,24(%rax)
L43:
	ret 


_con_tree:
L51:
L52:
	movq _stmt_arena+8(%rip),%rdx
	movq %rdx,%rcx
	andl $7,%ecx
	jz L59
L57:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%rdx
	movq %rdx,_stmt_arena+8(%rip)
L59:
	movq _stmt_arena+8(%rip),%rax
	leaq 32(%rax),%rcx
	movq %rcx,_stmt_arena+8(%rip)
	movl $-2147483646,(%rax)
	movl $0,4(%rax)
	movq %rdi,8(%rax)
	movq (%rsi),%rcx
	movq %rcx,16(%rax)
	movq $0,24(%rax)
L53:
	ret 


_sym_tree:
L61:
L62:
	movq _stmt_arena+8(%rip),%rdx
	movq %rdx,%rcx
	andl $7,%ecx
	jz L69
L67:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%rdx
	movq %rdx,_stmt_arena+8(%rip)
L69:
	movq _stmt_arena+8(%rip),%rax
	leaq 32(%rax),%rcx
	movq %rcx,_stmt_arena+8(%rip)
	movl $-1879048191,(%rax)
	movl $0,4(%rax)
	movq 32(%rdi),%rcx
	movq %rcx,8(%rax)
	movq %rdi,24(%rax)
	movq $0,16(%rax)
L63:
	ret 


_seq_tree:
L71:
L72:
	testq %rdi,%rdi
	jz L74
L76:
	testq %rsi,%rsi
	jz L78
L82:
	movq _stmt_arena+8(%rip),%rdx
	movq %rdx,%rcx
	andl $7,%ecx
	jz L87
L85:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%rdx
	movq %rdx,_stmt_arena+8(%rip)
L87:
	movq _stmt_arena+8(%rip),%rax
	leaq 32(%rax),%rcx
	movq %rcx,_stmt_arena+8(%rip)
	movl $44,(%rax)
	movl $0,4(%rax)
	movq $_void_type,8(%rax)
	movq %rdi,16(%rax)
	movq %rsi,24(%rax)
	ret
L78:
	movq %rdi,%rax
	ret
L74:
	movq %rsi,%rax
L73:
	ret 


_blk_tree:
L89:
L90:
	movq _stmt_arena+8(%rip),%r9
	movq %r9,%r8
	andl $7,%r8d
	jz L97
L95:
	movl $8,%eax
	subq %r8,%rax
	addq %rax,%r9
	movq %r9,_stmt_arena+8(%rip)
L97:
	movq _stmt_arena+8(%rip),%rax
	leaq 32(%rax),%r8
	movq %r8,_stmt_arena+8(%rip)
	movl %edi,(%rax)
	movl $0,4(%rax)
	movq 8(%rsi),%rdi
	movq %rdi,8(%rax)
	movq _stmt_arena+8(%rip),%r9
	movq %r9,%r8
	andl $7,%r8d
	jz L103
L101:
	movl $8,%edi
	subq %r8,%rdi
	addq %rdi,%r9
	movq %r9,_stmt_arena+8(%rip)
L103:
	movq _stmt_arena+8(%rip),%r8
	leaq 32(%r8),%rdi
	movq %rdi,_stmt_arena+8(%rip)
	movl $42,(%r8)
	movl $0,4(%r8)
	movq $_void_type,8(%r8)
	movq %r8,16(%rax)
	movq %rsi,16(%r8)
	movq 16(%rax),%rsi
	movq %rdx,24(%rsi)
	movq %rcx,24(%rax)
L91:
	ret 


_actual:
L105:
	pushq %rbx
	pushq %r12
L106:
	movq %rdi,%r12
	movq %rsi,%rbx
	cmpl $63,4(%r12)
	jnz L110
L108:
	pushq $L111
	pushq $0
	pushq $1
	call _error
	addq $24,%rsp
L110:
	movl 4(%r12),%eax
	testl %eax,%eax
	jz L116
L115:
	cmpl $4,%eax
	jl L114
L119:
	cmpl $0,%eax
	jle L114
L123:
	movl %eax,%ecx
	decl %ecx
	testl %eax,%ecx
	jnz L114
L116:
	testl %eax,%eax
	jz L128
L127:
	shll $1,%eax
	jmp L130
L128:
	movl $4,%eax
L130:
	movq _stmt_arena+8(%rip),%rsi
	movq %rsi,%rdx
	andl $7,%edx
	jz L135
L133:
	movl $8,%ecx
	subq %rdx,%rcx
	addq %rcx,%rsi
	movq %rsi,_stmt_arena+8(%rip)
L135:
	movq _stmt_arena+8(%rip),%rsi
	movslq %eax,%rax
	leaq (%rsi,%rax,8),%rax
	movq %rax,_stmt_arena+8(%rip)
	xorl %edx,%edx
L136:
	cmpl 4(%r12),%edx
	jge L139
L137:
	movq 24(%r12),%rax
	movslq %edx,%rcx
	movq (%rax,%rcx,8),%rax
	movq %rax,(%rsi,%rcx,8)
	incl %edx
	jmp L136
L139:
	movq %rsi,24(%r12)
L114:
	movq 24(%r12),%rcx
	movslq 4(%r12),%rax
	movq %rbx,(%rcx,%rax,8)
	incl 4(%r12)
L107:
	popq %r12
	popq %rbx
	ret 

L156:
	.quad 0x0

_zero_tree:
L140:
L141:
	cmpl $2147483650,(%rdi)
	jnz L145
L146:
	cmpq $0,24(%rdi)
	jnz L145
L143:
	movq 8(%rdi),%rax
	testq $7168,(%rax)
	jz L151
L150:
	movsd 16(%rdi),%xmm0
	ucomisd L156(%rip),%xmm0
	setz %al
	movzbl %al,%eax
	ret
L151:
	cmpq $0,16(%rdi)
	setz %al
	movzbl %al,%eax
	ret
L145:
	xorl %eax,%eax
L142:
	ret 


_nonzero_tree:
L157:
L158:
	cmpl $2147483650,(%rdi)
	jnz L162
L163:
	cmpq $0,24(%rdi)
	jnz L162
L160:
	movq 8(%rdi),%rax
	testq $7168,(%rax)
	jz L168
L167:
	movsd 16(%rdi),%xmm0
	ucomisd L156(%rip),%xmm0
	setnz %al
	movzbl %al,%eax
	ret
L168:
	cmpq $0,16(%rdi)
	setnz %al
	movzbl %al,%eax
	ret
L162:
	xorl %eax,%eax
L159:
	ret 

L540:
	.quad 0xbff0000000000000
.align 2
L541:
	.short L437-_fold0
	.short L415-_fold0
	.short L426-_fold0
	.short L445-_fold0
	.short L453-_fold0

_fold0:
L173:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
L174:
	movq %rdi,%rbx
	movl (%rbx),%eax
	movl %eax,%ecx
	andl $1073741824,%ecx
	jz L177
L176:
	cmpl $1073741830,%eax
	jnz L184
L182:
	movq 16(%rbx),%rdx
	cmpl $2147483650,(%rdx)
	jnz L184
L183:
	movq 8(%rbx),%rax
	movq (%rax),%rdi
	andl $131071,%edi
	movq 8(%rdx),%rax
	movq (%rax),%rsi
	andl $131071,%esi
	cmpq $0,24(%rdx)
	setz %cl
	movzbl %cl,%ecx
	addq $16,%rdx
	call _cast_con
	testl %eax,%eax
	jz L505
L186:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	jmp L505
L184:
	movq 16(%rbx),%rcx
	cmpl $2147483650,(%rcx)
	jnz L505
L193:
	cmpq $0,24(%rcx)
	jnz L505
L194:
	cmpl $1073741834,%eax
	jz L200
L536:
	cmpl $1073741832,%eax
	jz L206
L537:
	cmpl $1073741833,%eax
	jnz L505
L217:
	notq 16(%rcx)
	movq %rbx,%rdi
	call _chop
	jmp L175
L206:
	movq 8(%rcx),%rax
	testq $7168,(%rax)
	jz L210
L209:
	movsd 16(%rcx),%xmm1
	movsd L540(%rip),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,16(%rcx)
	jmp L211
L210:
	negq 16(%rcx)
L211:
	movq %rbx,%rdi
	call _chop
	jmp L175
L200:
	movq %rbx,%rdi
	call _chop
	jmp L175
L177:
	testl $2147483648,%eax
	jnz L505
L224:
	testl %ecx,%ecx
	jnz L505
L225:
	movq 16(%rbx),%rdi
	call _nonzero_tree
	testl %eax,%eax
	jz L229
L228:
	movl (%rbx),%eax
	cmpl $41,%eax
	jz L234
L531:
	cmpl $40,%eax
	jz L236
L532:
	cmpl $39,%eax
	jnz L230
L238:
	movq $1,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	jmp L175
L236:
	movq %rbx,%rdi
	call _chop_right
	jmp L175
L234:
	movq %rbx,%rdi
	call _chop_right
	movq %rax,%rdi
	call _chop_left
	jmp L175
L229:
	movq 16(%rbx),%rdi
	call _zero_tree
	testl %eax,%eax
	jz L230
L240:
	movl (%rbx),%eax
	cmpl $41,%eax
	jz L246
L526:
	cmpl $40,%eax
	jz L248
L527:
	cmpl $39,%eax
	jz L250
L230:
	movl (%rbx),%edx
	testl $536870912,%edx
	jz L254
L259:
	movq 16(%rbx),%rcx
	cmpl $2147483650,(%rcx)
	jnz L254
L260:
	movq 24(%rbx),%rax
	cmpl $2147483650,(%rax)
	jnz L254
L256:
	cmpq $0,24(%rax)
	jz L254
L269:
	cmpq $0,24(%rcx)
	jz L254
L270:
	movq %rax,16(%rbx)
	movq %rcx,24(%rbx)
L254:
	cmpl $27,%edx
	jnz L278
L283:
	movq 16(%rbx),%rax
	cmpl $2147483650,(%rax)
	jnz L278
L284:
	movq 24(%rbx),%rcx
	cmpl $2147483650,(%rcx)
	jnz L278
L280:
	movq 24(%rax),%rax
	cmpq 24(%rcx),%rax
	jnz L278
L290:
	movq $0,24(%rcx)
	movq 16(%rbx),%rax
	movq $0,24(%rax)
L278:
	movq 24(%rbx),%rdi
	cmpl $2147483650,(%rdi)
	jnz L505
L296:
	cmpq $0,24(%rdi)
	jnz L505
L297:
	movq 16(%rbx),%rax
	movl (%rax),%edx
	cmpl $2147483650,%edx
	jnz L302
L300:
	movl (%rbx),%ecx
	cmpl $536870938,%ecx
	jz L310
L522:
	cmpl $27,%ecx
	jz L324
L302:
	cmpl $2147483650,%edx
	jnz L505
L337:
	cmpq $0,24(%rax)
	jnz L505
L338:
	movl (%rbx),%ecx
	cmpl $536870942,%ecx
	jl L507
L509:
	cmpl $536870946,%ecx
	jg L507
L506:
	addl $-536870942,%ecx
	movzwl L541(,%rcx,2),%ecx
	addl $_fold0,%ecx
	jmp *%rcx
L453:
	movq 8(%rax),%rcx
	testq $7168,(%rcx)
	jz L457
L456:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	setnz %al
	movzbl %al,%eax
	jmp L458
L457:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setnz %al
	movzbl %al,%eax
L458:
	movslq %eax,%rax
	movq %rax,-32(%rbp)
	leaq -32(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	jmp L175
L445:
	movq 8(%rax),%rcx
	testq $7168,(%rcx)
	jz L449
L448:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	setz %al
	movzbl %al,%eax
	jmp L450
L449:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setz %al
	movzbl %al,%eax
L450:
	movslq %eax,%rax
	movq %rax,-24(%rbp)
	leaq -24(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	jmp L175
L426:
	movq 8(%rax),%rcx
	testq $342,(%rcx)
	jz L430
L429:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	orq %rdx,%rcx
	movq %rcx,16(%rax)
	jmp L431
L430:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	orq %rdx,%rcx
	movq %rcx,16(%rax)
L431:
	movq %rbx,%rdi
	call _chop_left
	jmp L175
L415:
	movq 8(%rax),%rcx
	testq $342,(%rcx)
	jz L419
L418:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	andq %rdx,%rcx
	movq %rcx,16(%rax)
	jmp L420
L419:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	andq %rdx,%rcx
	movq %rcx,16(%rax)
L420:
	movq %rbx,%rdi
	call _chop_left
	jmp L175
L437:
	movq 8(%rax),%rcx
	testq $342,(%rcx)
	jz L441
L440:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	xorq %rdx,%rcx
	movq %rcx,16(%rax)
	jmp L442
L441:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	xorq %rdx,%rcx
	movq %rcx,16(%rax)
L442:
	movq %rbx,%rdi
	call _chop_left
	jmp L175
L507:
	cmpl $23,%ecx
	jz L344
L511:
	cmpl $24,%ecx
	jz L361
L512:
	cmpl $28,%ecx
	jz L404
L513:
	cmpl $29,%ecx
	jz L393
L514:
	cmpl $35,%ecx
	jz L461
L515:
	cmpl $36,%ecx
	jz L472
L516:
	cmpl $37,%ecx
	jz L494
L517:
	cmpl $38,%ecx
	jz L483
L518:
	cmpl $536870937,%ecx
	jnz L505
L379:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L383
L382:
	movsd 16(%rax),%xmm1
	movsd 16(%rdi),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,16(%rax)
	jmp L384
L383:
	testq $342,%rcx
	jz L386
L385:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	imulq %rdx,%rcx
	movq %rcx,16(%rax)
	jmp L384
L386:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	imulq %rdx,%rcx
	movq %rcx,16(%rax)
L384:
	movq %rbx,%rdi
	call _chop_left
	jmp L175
L483:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L487
L486:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	setb %al
	movzbl %al,%eax
	jmp L488
L487:
	testq $342,%rcx
	jz L490
L489:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setl %al
	movzbl %al,%eax
	jmp L488
L490:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setb %al
	movzbl %al,%eax
L488:
	movslq %eax,%rax
	movq %rax,-56(%rbp)
	leaq -56(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	jmp L175
L494:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L498
L497:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	setbe %al
	movzbl %al,%eax
	jmp L499
L498:
	testq $342,%rcx
	jz L501
L500:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setle %al
	movzbl %al,%eax
	jmp L499
L501:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setbe %al
	movzbl %al,%eax
L499:
	movslq %eax,%rax
	movq %rax,-64(%rbp)
	leaq -64(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	jmp L175
L472:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L476
L475:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	setae %al
	movzbl %al,%eax
	jmp L477
L476:
	testq $342,%rcx
	jz L479
L478:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setge %al
	movzbl %al,%eax
	jmp L477
L479:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setae %al
	movzbl %al,%eax
L477:
	movslq %eax,%rax
	movq %rax,-48(%rbp)
	leaq -48(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	jmp L175
L461:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L465
L464:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	seta %al
	movzbl %al,%eax
	jmp L466
L465:
	testq $342,%rcx
	jz L468
L467:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setg %al
	movzbl %al,%eax
	jmp L466
L468:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	seta %al
	movzbl %al,%eax
L466:
	movslq %eax,%rax
	movq %rax,-40(%rbp)
	leaq -40(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	jmp L175
L393:
	movq 8(%rax),%rcx
	testq $342,(%rcx)
	jz L397
L396:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	shlq %cl,%rdx
	movq %rdx,16(%rax)
	jmp L398
L397:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	shlq %cl,%rdx
	movq %rdx,16(%rax)
L398:
	movq %rbx,%rdi
	call _chop_left
	jmp L175
L404:
	movq 8(%rax),%rcx
	testq $342,(%rcx)
	jz L408
L407:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	sarq %cl,%rdx
	movq %rdx,16(%rax)
	jmp L409
L408:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	shrq %cl,%rdx
	movq %rdx,16(%rax)
L409:
	movq %rbx,%rdi
	call _chop_left
	jmp L175
L361:
	call _zero_tree
	testl %eax,%eax
	jnz L505
L368:
	movq 16(%rbx),%rsi
	movq 8(%rsi),%rax
	testq $342,(%rax)
	movq 24(%rbx),%rcx
	jz L372
L371:
	movq 16(%rsi),%rax
	cqto 
	idivq 16(%rcx)
	movq %rdx,16(%rsi)
	jmp L373
L372:
	movq 16(%rsi),%rax
	xorl %edx,%edx
	divq 16(%rcx)
	movq %rdx,16(%rsi)
L373:
	movq %rbx,%rdi
	call _chop_left
	movq %rax,%rbx
	jmp L505
L344:
	call _zero_tree
	testl %eax,%eax
	jnz L505
L351:
	movq 16(%rbx),%rsi
	movq 8(%rsi),%rax
	movq (%rax),%rax
	testq $7168,%rax
	movq 24(%rbx),%rcx
	jz L355
L354:
	movsd 16(%rsi),%xmm0
	divsd 16(%rcx),%xmm0
	movsd %xmm0,16(%rsi)
	jmp L356
L355:
	testq $342,%rax
	jz L358
L357:
	movq 16(%rsi),%rax
	cqto 
	idivq 16(%rcx)
	movq %rax,16(%rsi)
	jmp L356
L358:
	movq 16(%rsi),%rax
	xorl %edx,%edx
	divq 16(%rcx)
	movq %rax,16(%rsi)
L356:
	movq %rbx,%rdi
	call _chop_left
	movq %rax,%rbx
L505:
	movq %rbx,%rax
	jmp L175
L324:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L328
L327:
	movsd 16(%rax),%xmm0
	subsd 16(%rdi),%xmm0
	movsd %xmm0,16(%rax)
	jmp L329
L328:
	testq $342,%rcx
	jz L331
L330:
	movq 16(%rax),%rcx
	subq 16(%rdi),%rcx
	movq %rcx,16(%rax)
	jmp L329
L331:
	movq 16(%rax),%rcx
	subq 16(%rdi),%rcx
	movq %rcx,16(%rax)
L329:
	movq %rbx,%rdi
	call _chop_left
	jmp L175
L310:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L314
L313:
	movsd 16(%rax),%xmm1
	movsd 16(%rdi),%xmm0
	addsd %xmm1,%xmm0
	movsd %xmm0,16(%rax)
	jmp L315
L314:
	testq $342,%rcx
	jz L317
L316:
	movq 16(%rax),%rdx
	addq 16(%rdi),%rdx
	movq %rdx,16(%rax)
	jmp L315
L317:
	movq 16(%rax),%rdx
	addq 16(%rdi),%rdx
	movq %rdx,16(%rax)
L315:
	movq %rbx,%rdi
	call _chop_left
	jmp L175
L250:
	movq %rbx,%rdi
	call _chop_right
	jmp L175
L248:
	movq $0,-16(%rbp)
	leaq -16(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	jmp L175
L246:
	movq %rbx,%rdi
	call _chop_right
	movq %rax,%rdi
	call _chop_right
L175:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_indirect0:
L542:
	pushq %rbx
L543:
	movq %rdi,%rbx
	movq 16(%rbx),%rdx
	movl (%rbx),%eax
	cmpl $1073741831,%eax
	jz L548
L593:
	cmpl $1342177283,%eax
	jz L565
L594:
	cmpl $1073741828,%eax
	jnz L546
L565:
	movl (%rdx),%ecx
	cmpl $2147483650,%ecx
	jnz L567
L573:
	movq 24(%rdx),%rax
	testq %rax,%rax
	jz L567
L569:
	cmpq $0,16(%rdx)
	jnz L567
L566:
	movq 8(%rbx),%rdi
	movq 32(%rax),%rsi
	call _simpatico
	testl %eax,%eax
	jz L546
L577:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	movl $-1879048191,(%rax)
	jmp L546
L567:
	cmpl $1073741831,%ecx
	jnz L546
L580:
	movq 16(%rdx),%rax
	cmpl $2415919105,(%rax)
	jnz L583
L586:
	movq 8(%rbx),%rdi
	movq 24(%rax),%rax
	movq 32(%rax),%rsi
	call _simpatico
	testl %eax,%eax
	jz L546
L583:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rdi
	call _chop
	movq %rax,%rbx
	jmp L546
L548:
	movl (%rdx),%ecx
	cmpl $2415919105,%ecx
	jnz L550
L552:
	movq 24(%rdx),%rax
	testl $48,12(%rax)
	jz L550
L549:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	movl $-2147483646,(%rax)
	movq $0,16(%rax)
	jmp L546
L550:
	cmpl $1342177283,%ecx
	jz L556
L559:
	cmpl $1073741828,%ecx
	jnz L546
L556:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rdi
	call _chop
	movq %rax,%rbx
L546:
	movq %rbx,%rax
L544:
	popq %rbx
	ret 


_restrun0:
L597:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L598:
	movq %rdi,%r13
	cmpl $11,(%r13)
	jnz L602
L603:
	movq 8(%r13),%rax
	testq $8192,(%rax)
	jz L602
L604:
	movq 16(%r13),%rbx
	movq 8(%rbx),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%rsi
	movq %rbx,%rdi
	call _addrof
	movq %rax,%r12
	movq 24(%r13),%rbx
	movq 8(%rbx),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%rsi
	movq %rbx,%rdi
	call _addrof
	movq %rax,%rbx
	cmpl $1073741829,(%rbx)
	jnz L618
L628:
	cmpl $0,4(%rbx)
	jz L618
L629:
	movq 24(%rbx),%rcx
	movq (%rcx),%rax
	cmpl $1073741831,(%rax)
	jnz L618
L625:
	movq 16(%rax),%rax
	cmpl $2415919105,(%rax)
	jnz L618
L621:
	movq 24(%rax),%rax
	testl $2097152,12(%rax)
	jz L618
L617:
	movq %r12,(%rcx)
	movq %rbx,%rdx
	movq 8(%r13),%rsi
	movl $1073741828,%edi
	call _unary_tree
	movq %rax,%r13
	jmp L602
L618:
	xorl %esi,%esi
	movq 8(%r13),%rdi
	call _size_of
	movslq %eax,%rax
	movq %rax,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_ulong_type,%edi
	call _con_tree
	movq %rax,%rcx
	movq %rbx,%rdx
	movq %r12,%rsi
	movl $45,%edi
	call _blk_tree
	movq %rax,%rdx
	movq 8(%r13),%rsi
	movl $1073741828,%edi
	call _unary_tree
	movq %rax,%r13
L602:
	movq %r13,%rax
L599:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_recast0:
L633:
	pushq %rbx
L634:
	movq %rdi,%rbx
L636:
	cmpl $1073741830,(%rbx)
	jnz L638
L637:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _simpatico
	testl %eax,%eax
	jnz L642
L641:
	cmpl $1073741830,(%rbx)
	jnz L646
L655:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L646
L651:
	movq 16(%rbx),%rax
	cmpl $1073741830,(%rax)
	jnz L646
L659:
	movq 8(%rax),%rdi
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L646
L647:
	movq 16(%rbx),%rcx
	movq 8(%rcx),%rax
	testq $680,(%rax)
	jz L642
L663:
	movq 16(%rcx),%rax
	movq 8(%rax),%rax
	testq $342,(%rax)
	jz L642
L646:
	cmpl $1073741830,(%rbx)
	jnz L670
L675:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _narrower
	testl %eax,%eax
	jz L670
L671:
	movq 16(%rbx),%rax
	cmpl $1073741830,(%rax)
	jnz L670
L679:
	movq 8(%rax),%rdi
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jnz L642
L670:
	cmpl $1073741830,(%rbx)
	jnz L686
L691:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _narrower
	testl %eax,%eax
	jz L686
L687:
	movq 16(%rbx),%rax
	cmpl $1073741830,(%rax)
	jnz L686
L695:
	movq 8(%rax),%rdi
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _narrower
	testl %eax,%eax
	jnz L642
L686:
	cmpl $1073741830,(%rbx)
	jnz L638
L707:
	movq 8(%rbx),%rax
	testq $7168,(%rax)
	setz %dl
	movzbl %dl,%edx
	movq 16(%rbx),%rcx
	movq 8(%rcx),%rdi
	testq $7168,(%rdi)
	setz %al
	movzbl %al,%eax
	cmpl %eax,%edx
	jz L638
L703:
	cmpl $1073741830,(%rcx)
	jnz L638
L711:
	movq 16(%rcx),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L638
L642:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	jmp L636
L638:
	movq %rbx,%rax
L635:
	popq %rbx
	ret 


_fpcast0:
L718:
	pushq %rbx
L719:
	movq %rdi,%rbx
	cmpl $1073741830,(%rbx)
	jnz L723
L724:
	movq 8(%rbx),%rax
	testq $7168,(%rax)
	jz L723
L721:
	movq 16(%rbx),%rdx
	movq 8(%rdx),%rax
	movq (%rax),%rax
	testq $14,%rax
	jnz L728
L731:
	testq $48,%rax
	jz L729
L728:
	movl $_int_type,%esi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,16(%rbx)
	jmp L723
L729:
	testq $128,%rax
	jz L723
L735:
	movl $_long_type,%esi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,16(%rbx)
L723:
	movq %rbx,%rax
L720:
	popq %rbx
	ret 


_underlying:
L739:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L740:
	movq %rdi,%r14
	movq %rsi,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	cmpl $1073741830,(%r14)
	jnz L744
L745:
	movq 8(%r14),%rdi
	movq 16(%r14),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L744
L742:
	movq 16(%r14),%rax
	movq 8(%rax),%r12
L744:
	cmpl $1073741830,(%r13)
	jnz L751
L752:
	movq 8(%r13),%rdi
	movq 16(%r13),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L751
L749:
	movq 16(%r13),%rax
	movq 8(%rax),%rbx
L751:
	testq %r12,%r12
	jz L757
L759:
	testq %rbx,%rbx
	jz L757
L756:
	movq (%r12),%rcx
	andl $131071,%ecx
	movq (%rbx),%rax
	andl $131071,%eax
	cmpq %rax,%rcx
	jnz L758
	jz L800
L757:
	testq %r12,%r12
	jz L769
L774:
	cmpl $2147483650,(%r13)
	jnz L769
L778:
	cmpq $0,24(%r13)
	jnz L769
L770:
	movq (%r12),%rdi
	andl $131071,%edi
	leaq 16(%r13),%rsi
	call _con_in_range
	testl %eax,%eax
	jz L769
L800:
	movq %r12,%rax
	jmp L741
L769:
	testq %rbx,%rbx
	jz L758
L790:
	cmpl $2147483650,(%r14)
	jnz L758
L794:
	cmpq $0,24(%r14)
	jnz L758
L786:
	movq (%rbx),%rdi
	andl $131071,%edi
	leaq 16(%r14),%rsi
	call _con_in_range
	testl %eax,%eax
	jz L758
L783:
	movq %rbx,%rax
	jmp L741
L758:
	xorl %eax,%eax
L741:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_uncast0:
L801:
	pushq %rbx
L802:
	movq %rdi,%rbx
	cmpl $1073741830,(%rbx)
	jnz L804
L815:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _narrower
	testl %eax,%eax
	jz L804
L811:
	movq 8(%rbx),%rax
	testq $1022,(%rax)
	jz L804
L807:
	movq 16(%rbx),%rax
	movl (%rax),%eax
	cmpl $1073741832,%eax
	jz L806
L819:
	cmpl $1073741833,%eax
	jnz L804
L806:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	movq 8(%rbx),%rsi
	movq 16(%rbx),%rdx
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,16(%rbx)
	movq %rax,%rdi
	call _simplify
	movq %rax,16(%rbx)
	movq %rbx,%rax
	jmp L803
L804:
	movq %rbx,%rax
L803:
	popq %rbx
	ret 

.align 2
L886:
	.short L849-_bincast0
	.short L849-_bincast0
	.short L878-_bincast0
	.short L878-_bincast0
	.short L878-_bincast0
	.short L849-_bincast0
	.short L849-_bincast0
	.short L849-_bincast0
.align 2
L887:
	.short L868-_bincast0
	.short L868-_bincast0
	.short L878-_bincast0
	.short L878-_bincast0
	.short L849-_bincast0
	.short L854-_bincast0
	.short L849-_bincast0

_bincast0:
L825:
	pushq %rbx
	pushq %r12
L826:
	movq %rdi,%rbx
	cmpl $1073741830,(%rbx)
	jnz L878
L835:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _narrower
	testl %eax,%eax
	jz L878
L831:
	movq 8(%rbx),%rax
	testq $66558,(%rax)
	jz L878
L830:
	movq 16(%rbx),%rcx
	movl (%rcx),%eax
	cmpl $23,%eax
	jl L880
L882:
	cmpl $29,%eax
	jg L880
L879:
	addl $-23,%eax
	movzwl L887(,%rax,2),%eax
	addl $_bincast0,%eax
	jmp *%rax
L854:
	movq 16(%rcx),%rax
	cmpl $1073741830,(%rax)
	jnz L878
L862:
	movq 8(%rax),%rdi
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L878
L858:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 16(%rax),%rax
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _simpatico
	testl %eax,%eax
	jz L878
L855:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	movq 16(%rax),%rcx
	movq 16(%rcx),%rcx
	movq %rcx,16(%rax)
	jmp L878
L868:
	movq 16(%rcx),%rdi
	movq 24(%rcx),%rsi
	call _underlying
	movq %rax,%r12
	testq %r12,%r12
	jz L878
L872:
	movq 8(%rbx),%rsi
	movq %r12,%rdi
	call _simpatico
	testl %eax,%eax
	jz L878
L869:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	movq 16(%rbx),%rdx
	movq %r12,%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdx
	movq %r12,%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%rbx)
	movq 16(%rbx),%rdi
	call _simplify
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _simplify
	movq %rax,24(%rbx)
	jmp L878
L880:
	cmpl $536870937,%eax
	jl L878
L885:
	cmpl $536870944,%eax
	jg L878
L883:
	addl $-536870937,%eax
	movzwl L886(,%rax,2),%eax
	addl $_bincast0,%eax
	jmp *%rax
L849:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	movq 8(%rbx),%rsi
	movq 16(%rbx),%rdx
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,16(%rbx)
	movq %rax,%rdi
	call _simplify
	movq %rax,16(%rbx)
	cmpl $29,(%rbx)
	jz L878
L850:
	movq 8(%rbx),%rsi
	movq 24(%rbx),%rdx
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%rbx)
	movq %rax,%rdi
	call _simplify
	movq %rax,24(%rbx)
L878:
	movq %rbx,%rax
L827:
	popq %r12
	popq %rbx
	ret 

.align 2
L952:
	.short L912-_asgcast0
	.short L920-_asgcast0
	.short L920-_asgcast0
	.short L912-_asgcast0
	.short L912-_asgcast0

_asgcast0:
L888:
	pushq %rbx
L889:
	movq %rdi,%rbx
	movl (%rbx),%eax
	testl $2147483648,%eax
	jnz L948
L902:
	testl $1073741824,%eax
	jnz L948
L898:
	movq 16(%rbx),%rcx
	movq 8(%rcx),%rdx
	movq (%rdx),%rdi
	testq $66558,%rdi
	jz L948
L894:
	movq 24(%rbx),%rcx
	movq 8(%rcx),%rsi
	testq $66558,(%rsi)
	jz L948
L893:
	cmpl $134217740,%eax
	jl L948
L951:
	cmpl $134217744,%eax
	jg L948
L949:
	addl $-134217740,%eax
	movzwl L952(,%rax,2),%eax
	addl $_asgcast0,%eax
	jmp *%rax
L920:
	cmpl $2147483650,(%rcx)
	jnz L923
L928:
	cmpq $0,24(%rcx)
	jnz L923
L924:
	andl $131071,%edi
	leaq 16(%rcx),%rsi
	call _con_in_range
	testl %eax,%eax
	jnz L916
L923:
	movq 24(%rbx),%rax
	cmpl $1073741830,(%rax)
	jnz L948
L940:
	movq 8(%rax),%rdi
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L948
L936:
	movq 16(%rbx),%rax
	movq 8(%rax),%rax
	movq (%rax),%rcx
	andl $131071,%ecx
	movq 24(%rbx),%rax
	movq 16(%rax),%rax
	movq 8(%rax),%rax
	movq (%rax),%rax
	andl $131071,%eax
	cmpq %rax,%rcx
	jz L916
	jnz L948
L912:
	movq %rdx,%rdi
	call _simpatico
	testl %eax,%eax
	jnz L948
L916:
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	movq 24(%rbx),%rdx
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%rbx)
	movq %rax,%rdi
	call _simplify
	movq %rax,24(%rbx)
L948:
	movq %rbx,%rax
L890:
	popq %rbx
	ret 


_relcast0:
L953:
	pushq %rbx
	pushq %r12
L954:
	movq %rdi,%r12
	movl (%r12),%eax
	cmpl $35,%eax
	jz L964
L970:
	cmpl $36,%eax
	jz L964
L971:
	cmpl $37,%eax
	jz L964
L972:
	cmpl $38,%eax
	jz L964
L973:
	cmpl $536870945,%eax
	jz L964
L974:
	cmpl $536870946,%eax
	jnz L957
L964:
	movq 16(%r12),%rdi
	movq 24(%r12),%rsi
	call _underlying
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L957
L965:
	movq 16(%r12),%rdx
	movq %rbx,%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,16(%r12)
	movq 24(%r12),%rdx
	movq %rbx,%rsi
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%r12)
	movq 16(%r12),%rdi
	call _simplify
	movq %rax,16(%r12)
	movq 24(%r12),%rdi
	call _simplify
	movq %rax,24(%r12)
L957:
	movq %r12,%rax
L955:
	popq %r12
	popq %rbx
	ret 


_simplify:
L977:
	pushq %rbx
	pushq %r12
	pushq %r13
L978:
	movq %rdi,%rbx
	movl (%rbx),%eax
	movl %eax,%ecx
	andl $1073741824,%ecx
	jz L984
L983:
	movq 16(%rbx),%rdi
	call _simplify
	movq %rax,16(%rbx)
	xorl %r13d,%r13d
L986:
	cmpl 4(%rbx),%r13d
	jge L985
L987:
	movq 24(%rbx),%rax
	movslq %r13d,%r12
	movq (%rax,%r12,8),%rdi
	call _simplify
	movq 24(%rbx),%rcx
	movq %rax,(%rcx,%r12,8)
	incl %r13d
	jmp L986
L984:
	testl $2147483648,%eax
	jnz L985
L993:
	testl %ecx,%ecx
	jnz L985
L994:
	movq 16(%rbx),%rdi
	call _simplify
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _simplify
	movq %rax,24(%rbx)
L985:
	movq %rbx,%rdi
	call _indirect0
	movq %rax,%rdi
	call _fold0
	movq %rax,%rdi
	call _restrun0
	movq %rax,%rdi
	call _recast0
	movq %rax,%rdi
	call _fpcast0
	movq %rax,%rdi
	call _uncast0
	movq %rax,%rdi
	call _bincast0
	movq %rax,%rdi
	call _asgcast0
	movq %rax,%rdi
	call _relcast0
L979:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_addrof:
L998:
L999:
	movq %rdi,%rdx
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%rdi
	call _indirect0
L1000:
	ret 


_fold:
L1002:
	pushq %rbx
	pushq %r12
	pushq %r13
L1003:
	movq %rdi,%rbx
	movl (%rbx),%eax
	movl %eax,%ecx
	andl $1073741824,%ecx
	jz L1009
L1008:
	movq 16(%rbx),%rdi
	call _fold
	movq %rax,16(%rbx)
	xorl %r13d,%r13d
L1011:
	cmpl 4(%rbx),%r13d
	jge L1010
L1012:
	movq 24(%rbx),%rax
	movslq %r13d,%r12
	movq (%rax,%r12,8),%rdi
	call _fold
	movq 24(%rbx),%rcx
	movq %rax,(%rcx,%r12,8)
	incl %r13d
	jmp L1011
L1009:
	testl $2147483648,%eax
	jnz L1010
L1018:
	testl %ecx,%ecx
	jnz L1010
L1019:
	movq 16(%rbx),%rdi
	call _fold
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _fold
	movq %rax,24(%rbx)
L1010:
	movq %rbx,%rdi
	call _indirect0
	movq %rax,%rdi
	call _fold0
L1004:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_rewrite_volatiles:
L1023:
	pushq %rbx
	pushq %r12
	pushq %r13
L1024:
	movq %rdi,%rbx
	movl (%rbx),%eax
	cmpl $1073741831,%eax
	jz L1055
L1028:
	cmpl $2415919105,%eax
	jnz L1035
L1033:
	movq 24(%rbx),%rcx
	movq 32(%rcx),%rdx
	testq $262144,(%rdx)
	jz L1035
L1034:
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %rax,%rsi
	movq %rbx,%rdi
	call _addrof
	movq 16(%rax),%rcx
	movq %rax,%rdx
	movq 8(%rcx),%rsi
	movl $1342177283,%edi
	call _unary_tree
	movq %rax,%rbx
	jmp L1055
L1035:
	movl %eax,%ecx
	andl $1073741824,%ecx
	jz L1041
L1040:
	movq 16(%rbx),%rdi
	call _rewrite_volatiles
	movq %rax,16(%rbx)
	xorl %r13d,%r13d
L1043:
	cmpl 4(%rbx),%r13d
	jge L1055
L1044:
	movq 24(%rbx),%rax
	movslq %r13d,%r12
	movq (%rax,%r12,8),%rdi
	call _rewrite_volatiles
	movq 24(%rbx),%rcx
	movq %rax,(%rcx,%r12,8)
	incl %r13d
	jmp L1043
L1041:
	testl $2147483648,%eax
	jnz L1055
L1050:
	testl %ecx,%ecx
	jnz L1055
L1051:
	movq 16(%rbx),%rdi
	call _rewrite_volatiles
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _rewrite_volatiles
	movq %rax,24(%rbx)
L1055:
	movq %rbx,%rax
L1025:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L111:
 .byte 99,97,110,39,116,32,104,97
 .byte 110,100,108,101,32,116,104,97
 .byte 116,32,109,97,110,121,32,97
 .byte 114,103,117,109,101,110,116,115
 .byte 0

.globl _stmt_arena
.globl _sym_tree
.globl _rewrite_volatiles
.globl _narrower
.globl _unary_tree
.globl _con_tree
.globl _error
.globl _long_type
.globl _chop_left
.globl _addrof
.globl _blk_tree
.globl _get_tnode
.globl _nonzero_tree
.globl _normalize_con
.globl _simplify
.globl _fold
.globl _wider
.globl _int_type
.globl _cast_con
.globl _void_type
.globl _chop
.globl _zero_tree
.globl _con_in_range
.globl _seq_tree
.globl _chop_right
.globl _void_tree
.globl _actual
.globl _binary_tree
.globl _simpatico
.globl _ulong_type
.globl _size_of
