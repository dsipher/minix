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
	jmp L157
L151:
	cmpq $0,16(%rdi)
L157:
	setz %al
	movzbl %al,%eax
	ret
L145:
	xorl %eax,%eax
L142:
	ret 


_nonzero_tree:
L158:
L159:
	cmpl $2147483650,(%rdi)
	jnz L163
L164:
	cmpq $0,24(%rdi)
	jnz L163
L161:
	movq 8(%rdi),%rax
	testq $7168,(%rax)
	jz L169
L168:
	movsd 16(%rdi),%xmm0
	ucomisd L156(%rip),%xmm0
	jmp L174
L169:
	cmpq $0,16(%rdi)
L174:
	setnz %al
	movzbl %al,%eax
	ret
L163:
	xorl %eax,%eax
L160:
	ret 

L542:
	.quad 0xbff0000000000000
.align 2
L543:
	.short L439-_fold0
	.short L417-_fold0
	.short L428-_fold0
	.short L447-_fold0
	.short L455-_fold0

_fold0:
L175:
	pushq %rbp
	movq %rsp,%rbp
	subq $64,%rsp
	pushq %rbx
L176:
	movq %rdi,%rbx
	movl (%rbx),%eax
	movl %eax,%ecx
	andl $1073741824,%ecx
	jz L179
L178:
	cmpl $1073741830,%eax
	jnz L186
L184:
	movq 16(%rbx),%rdx
	cmpl $2147483650,(%rdx)
	jnz L186
L185:
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
	jz L507
L188:
	movq %rbx,%rdi
	call _chop
	jmp L550
L186:
	movq 16(%rbx),%rcx
	cmpl $2147483650,(%rcx)
	jnz L507
L195:
	cmpq $0,24(%rcx)
	jnz L507
L196:
	cmpl $1073741834,%eax
	jz L544
L538:
	cmpl $1073741832,%eax
	jz L208
L539:
	cmpl $1073741833,%eax
	jnz L507
L219:
	notq 16(%rcx)
	jmp L544
L208:
	movq 8(%rcx),%rax
	testq $7168,(%rax)
	jz L212
L211:
	movsd 16(%rcx),%xmm1
	movsd L542(%rip),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,16(%rcx)
	jmp L544
L212:
	negq 16(%rcx)
L544:
	movq %rbx,%rdi
	call _chop
	jmp L177
L179:
	testl $2147483648,%eax
	jnz L507
L226:
	testl %ecx,%ecx
	jnz L507
L227:
	movq 16(%rbx),%rdi
	call _nonzero_tree
	testl %eax,%eax
	jz L231
L230:
	movl (%rbx),%eax
	cmpl $41,%eax
	jz L236
L533:
	cmpl $40,%eax
	jz L548
L534:
	cmpl $39,%eax
	jnz L232
L240:
	movq $1,-8(%rbp)
	leaq -8(%rbp),%rsi
	jmp L549
L236:
	movq %rbx,%rdi
	call _chop_right
	movq %rax,%rdi
	jmp L545
L231:
	movq 16(%rbx),%rdi
	call _zero_tree
	testl %eax,%eax
	jz L232
L242:
	movl (%rbx),%eax
	cmpl $41,%eax
	jz L248
L528:
	cmpl $40,%eax
	jz L250
L529:
	cmpl $39,%eax
	jnz L232
L548:
	movq %rbx,%rdi
	jmp L547
L232:
	movl (%rbx),%edx
	testl $536870912,%edx
	jz L256
L261:
	movq 16(%rbx),%rcx
	cmpl $2147483650,(%rcx)
	jnz L256
L262:
	movq 24(%rbx),%rax
	cmpl $2147483650,(%rax)
	jnz L256
L258:
	cmpq $0,24(%rax)
	jz L256
L271:
	cmpq $0,24(%rcx)
	jz L256
L272:
	movq %rax,16(%rbx)
	movq %rcx,24(%rbx)
L256:
	cmpl $27,%edx
	jnz L280
L285:
	movq 16(%rbx),%rax
	cmpl $2147483650,(%rax)
	jnz L280
L286:
	movq 24(%rbx),%rcx
	cmpl $2147483650,(%rcx)
	jnz L280
L282:
	movq 24(%rax),%rax
	cmpq 24(%rcx),%rax
	jnz L280
L292:
	movq $0,24(%rcx)
	movq 16(%rbx),%rax
	movq $0,24(%rax)
L280:
	movq 24(%rbx),%rdi
	cmpl $2147483650,(%rdi)
	jnz L507
L298:
	cmpq $0,24(%rdi)
	jnz L507
L299:
	movq 16(%rbx),%rax
	movl (%rax),%edx
	cmpl $2147483650,%edx
	jnz L304
L302:
	movl (%rbx),%ecx
	cmpl $536870938,%ecx
	jz L312
L524:
	cmpl $27,%ecx
	jz L326
L304:
	cmpl $2147483650,%edx
	jnz L507
L339:
	cmpq $0,24(%rax)
	jnz L507
L340:
	movl (%rbx),%ecx
	cmpl $536870942,%ecx
	jl L509
L511:
	cmpl $536870946,%ecx
	jg L509
L508:
	addl $-536870942,%ecx
	movzwl L543(,%rcx,2),%ecx
	addl $_fold0,%ecx
	jmp *%rcx
L455:
	movq 8(%rax),%rcx
	testq $7168,(%rcx)
	jz L459
L458:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	jmp L563
L459:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
L563:
	setnz %al
	movzbl %al,%eax
	movslq %eax,%rax
	movq %rax,-32(%rbp)
	leaq -32(%rbp),%rsi
	jmp L549
L447:
	movq 8(%rax),%rcx
	testq $7168,(%rcx)
	jz L451
L450:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	jmp L562
L451:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
L562:
	setz %al
	movzbl %al,%eax
	movslq %eax,%rax
	movq %rax,-24(%rbp)
	leaq -24(%rbp),%rsi
	jmp L549
L428:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	orq %rdx,%rcx
	movq %rcx,16(%rax)
	jmp L546
L417:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	andq %rdx,%rcx
	movq %rcx,16(%rax)
	jmp L546
L439:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	xorq %rdx,%rcx
	movq %rcx,16(%rax)
	jmp L546
L509:
	cmpl $23,%ecx
	jz L346
L513:
	cmpl $24,%ecx
	jz L363
L514:
	cmpl $28,%ecx
	jz L406
L515:
	cmpl $29,%ecx
	jz L395
L516:
	cmpl $35,%ecx
	jz L463
L517:
	cmpl $36,%ecx
	jz L474
L518:
	cmpl $37,%ecx
	jz L496
L519:
	cmpl $38,%ecx
	jz L485
L520:
	cmpl $536870937,%ecx
	jnz L507
L381:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L385
L384:
	movsd 16(%rax),%xmm1
	movsd 16(%rdi),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,16(%rax)
	jmp L546
L385:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	imulq %rdx,%rcx
	movq %rcx,16(%rax)
	jmp L546
L485:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L489
L488:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	jmp L569
L489:
	testq $342,%rcx
	jz L492
L491:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setl %al
	jmp L568
L492:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
L569:
	setb %al
L568:
	movzbl %al,%eax
	movslq %eax,%rax
	movq %rax,-56(%rbp)
	leaq -56(%rbp),%rsi
	jmp L549
L496:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L500
L499:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	jmp L571
L500:
	testq $342,%rcx
	jz L503
L502:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setle %al
	jmp L570
L503:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
L571:
	setbe %al
L570:
	movzbl %al,%eax
	movslq %eax,%rax
	movq %rax,-64(%rbp)
	leaq -64(%rbp),%rsi
	jmp L549
L474:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L478
L477:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	jmp L567
L478:
	testq $342,%rcx
	jz L481
L480:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setge %al
	jmp L566
L481:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
L567:
	setae %al
L566:
	movzbl %al,%eax
	movslq %eax,%rax
	movq %rax,-48(%rbp)
	leaq -48(%rbp),%rsi
	jmp L549
L463:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L467
L466:
	movsd 16(%rax),%xmm0
	ucomisd 16(%rdi),%xmm0
	jmp L565
L467:
	testq $342,%rcx
	jz L470
L469:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
	setg %al
	jmp L564
L470:
	movq 16(%rax),%rax
	cmpq 16(%rdi),%rax
L565:
	seta %al
L564:
	movzbl %al,%eax
	movslq %eax,%rax
	movq %rax,-40(%rbp)
	leaq -40(%rbp),%rsi
	jmp L549
L395:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	shlq %cl,%rdx
	movq %rdx,16(%rax)
	jmp L546
L406:
	movq 8(%rax),%rcx
	testq $342,(%rcx)
	jz L410
L409:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	sarq %cl,%rdx
	jmp L558
L410:
	movq 16(%rax),%rdx
	movq 16(%rdi),%rcx
	shrq %cl,%rdx
L558:
	movq %rdx,16(%rax)
	jmp L546
L363:
	call _zero_tree
	testl %eax,%eax
	jnz L507
L370:
	movq 16(%rbx),%rsi
	movq 8(%rsi),%rax
	testq $342,(%rax)
	movq 24(%rbx),%rcx
	jz L374
L373:
	movq 16(%rsi),%rax
	cqto 
	idivq 16(%rcx)
	jmp L553
L374:
	movq 16(%rsi),%rax
	xorl %edx,%edx
	divq 16(%rcx)
L553:
	movq %rdx,16(%rsi)
	jmp L551
L346:
	call _zero_tree
	testl %eax,%eax
	jnz L507
L353:
	movq 16(%rbx),%rsi
	movq 8(%rsi),%rax
	movq (%rax),%rax
	testq $7168,%rax
	movq 24(%rbx),%rcx
	jz L357
L356:
	movsd 16(%rsi),%xmm0
	divsd 16(%rcx),%xmm0
	movsd %xmm0,16(%rsi)
	jmp L551
L357:
	testq $342,%rax
	jz L360
L359:
	movq 16(%rsi),%rax
	cqto 
	idivq 16(%rcx)
	jmp L552
L360:
	movq 16(%rsi),%rax
	xorl %edx,%edx
	divq 16(%rcx)
L552:
	movq %rax,16(%rsi)
L551:
	movq %rbx,%rdi
	call _chop_left
L550:
	movq %rax,%rbx
L507:
	movq %rbx,%rax
	jmp L177
L326:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L330
L329:
	movsd 16(%rax),%xmm0
	subsd 16(%rdi),%xmm0
	movsd %xmm0,16(%rax)
	jmp L546
L330:
	movq 16(%rax),%rcx
	subq 16(%rdi),%rcx
	movq %rcx,16(%rax)
	jmp L546
L312:
	movq 8(%rax),%rcx
	movq (%rcx),%rcx
	testq $7168,%rcx
	jz L316
L315:
	movsd 16(%rax),%xmm1
	movsd 16(%rdi),%xmm0
	addsd %xmm1,%xmm0
	movsd %xmm0,16(%rax)
	jmp L546
L316:
	movq 16(%rax),%rdx
	addq 16(%rdi),%rdx
	movq %rdx,16(%rax)
L546:
	movq %rbx,%rdi
L545:
	call _chop_left
	jmp L177
L250:
	movq $0,-16(%rbp)
	leaq -16(%rbp),%rsi
L549:
	movl $_int_type,%edi
	call _con_tree
	jmp L177
L248:
	movq %rbx,%rdi
	call _chop_right
	movq %rax,%rdi
L547:
	call _chop_right
L177:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_indirect0:
L572:
	pushq %rbx
L573:
	movq %rdi,%rbx
	movq 16(%rbx),%rdx
	movl (%rbx),%eax
	cmpl $1073741831,%eax
	jz L578
L623:
	cmpl $1342177283,%eax
	jz L595
L624:
	cmpl $1073741828,%eax
	jnz L576
L595:
	movl (%rdx),%ecx
	cmpl $2147483650,%ecx
	jnz L597
L603:
	movq 24(%rdx),%rax
	testq %rax,%rax
	jz L597
L599:
	cmpq $0,16(%rdx)
	jnz L597
L596:
	movq 8(%rbx),%rdi
	movq 32(%rax),%rsi
	call _simpatico
	testl %eax,%eax
	jz L576
L607:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	movl $-1879048191,(%rax)
	jmp L576
L597:
	cmpl $1073741831,%ecx
	jnz L576
L610:
	movq 16(%rdx),%rax
	cmpl $2415919105,(%rax)
	jnz L627
L616:
	movq 8(%rbx),%rdi
	movq 24(%rax),%rax
	movq 32(%rax),%rsi
	call _simpatico
	testl %eax,%eax
	jz L576
	jnz L627
L578:
	movl (%rdx),%ecx
	cmpl $2415919105,%ecx
	jnz L580
L582:
	movq 24(%rdx),%rax
	testl $48,12(%rax)
	jz L580
L579:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	movl $-2147483646,(%rax)
	movq $0,16(%rax)
	jmp L576
L580:
	cmpl $1342177283,%ecx
	jz L627
L589:
	cmpl $1073741828,%ecx
	jnz L576
L627:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rdi
	call _chop
	movq %rax,%rbx
L576:
	movq %rbx,%rax
L574:
	popq %rbx
	ret 


_restrun0:
L628:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L629:
	movq %rdi,%r13
	cmpl $11,(%r13)
	jnz L633
L634:
	movq 8(%r13),%rax
	testq $8192,(%rax)
	jz L633
L635:
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
	jnz L649
L659:
	cmpl $0,4(%rbx)
	jz L649
L660:
	movq 24(%rbx),%rcx
	movq (%rcx),%rax
	cmpl $1073741831,(%rax)
	jnz L649
L656:
	movq 16(%rax),%rax
	cmpl $2415919105,(%rax)
	jnz L649
L652:
	movq 24(%rax),%rax
	testl $2097152,12(%rax)
	jz L649
L648:
	movq %r12,(%rcx)
	movq %rbx,%rdx
	jmp L664
L649:
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
L664:
	movq 8(%r13),%rsi
	movl $1073741828,%edi
	call _unary_tree
	movq %rax,%r13
L633:
	movq %r13,%rax
L630:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_recast0:
L665:
	pushq %rbx
L666:
	movq %rdi,%rbx
L668:
	cmpl $1073741830,(%rbx)
	jnz L670
L669:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _simpatico
	testl %eax,%eax
	jnz L674
L673:
	cmpl $1073741830,(%rbx)
	jnz L678
L687:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L678
L683:
	movq 16(%rbx),%rax
	cmpl $1073741830,(%rax)
	jnz L678
L691:
	movq 8(%rax),%rdi
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L678
L679:
	movq 16(%rbx),%rcx
	movq 8(%rcx),%rax
	testq $680,(%rax)
	jz L674
L695:
	movq 16(%rcx),%rax
	movq 8(%rax),%rax
	testq $342,(%rax)
	jz L674
L678:
	cmpl $1073741830,(%rbx)
	jnz L702
L707:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _narrower
	testl %eax,%eax
	jz L702
L703:
	movq 16(%rbx),%rax
	cmpl $1073741830,(%rax)
	jnz L702
L711:
	movq 8(%rax),%rdi
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jnz L674
L702:
	cmpl $1073741830,(%rbx)
	jnz L718
L723:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _narrower
	testl %eax,%eax
	jz L718
L719:
	movq 16(%rbx),%rax
	cmpl $1073741830,(%rax)
	jnz L718
L727:
	movq 8(%rax),%rdi
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _narrower
	testl %eax,%eax
	jnz L674
L718:
	cmpl $1073741830,(%rbx)
	jnz L670
L739:
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
	jz L670
L735:
	cmpl $1073741830,(%rcx)
	jnz L670
L743:
	movq 16(%rcx),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L670
L674:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	jmp L668
L670:
	movq %rbx,%rax
L667:
	popq %rbx
	ret 


_fpcast0:
L750:
	pushq %rbx
L751:
	movq %rdi,%rbx
	cmpl $1073741830,(%rbx)
	jnz L755
L756:
	movq 8(%rbx),%rax
	testq $7168,(%rax)
	jz L755
L753:
	movq 16(%rbx),%rdx
	movq 8(%rdx),%rax
	movq (%rax),%rax
	testq $14,%rax
	jnz L760
L763:
	testq $48,%rax
	jz L761
L760:
	movl $_int_type,%esi
	jmp L771
L761:
	testq $128,%rax
	jz L755
L767:
	movl $_long_type,%esi
L771:
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,16(%rbx)
L755:
	movq %rbx,%rax
L752:
	popq %rbx
	ret 


_underlying:
L772:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L773:
	movq %rdi,%r14
	movq %rsi,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	cmpl $1073741830,(%r14)
	jnz L777
L778:
	movq 8(%r14),%rdi
	movq 16(%r14),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L777
L775:
	movq 16(%r14),%rax
	movq 8(%rax),%r12
L777:
	cmpl $1073741830,(%r13)
	jnz L784
L785:
	movq 8(%r13),%rdi
	movq 16(%r13),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L784
L782:
	movq 16(%r13),%rax
	movq 8(%rax),%rbx
L784:
	testq %r12,%r12
	jz L790
L792:
	testq %rbx,%rbx
	jz L790
L789:
	movq (%r12),%rcx
	andl $131071,%ecx
	movq (%rbx),%rax
	andl $131071,%eax
	cmpq %rax,%rcx
	jnz L791
	jz L833
L790:
	testq %r12,%r12
	jz L802
L807:
	cmpl $2147483650,(%r13)
	jnz L802
L811:
	cmpq $0,24(%r13)
	jnz L802
L803:
	movq (%r12),%rdi
	andl $131071,%edi
	leaq 16(%r13),%rsi
	call _con_in_range
	testl %eax,%eax
	jz L802
L833:
	movq %r12,%rax
	jmp L774
L802:
	testq %rbx,%rbx
	jz L791
L823:
	cmpl $2147483650,(%r14)
	jnz L791
L827:
	cmpq $0,24(%r14)
	jnz L791
L819:
	movq (%rbx),%rdi
	andl $131071,%edi
	leaq 16(%r14),%rsi
	call _con_in_range
	testl %eax,%eax
	jz L791
L816:
	movq %rbx,%rax
	jmp L774
L791:
	xorl %eax,%eax
L774:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_uncast0:
L834:
	pushq %rbx
L835:
	movq %rdi,%rbx
	cmpl $1073741830,(%rbx)
	jnz L858
L848:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _narrower
	testl %eax,%eax
	jz L858
L844:
	movq 8(%rbx),%rax
	testq $1022,(%rax)
	jz L858
L840:
	movq 16(%rbx),%rax
	movl (%rax),%eax
	cmpl $1073741832,%eax
	jz L839
L852:
	cmpl $1073741833,%eax
	jnz L858
L839:
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
L858:
	movq %rbx,%rax
L836:
	popq %rbx
	ret 

.align 2
L920:
	.short L883-_bincast0
	.short L883-_bincast0
	.short L912-_bincast0
	.short L912-_bincast0
	.short L912-_bincast0
	.short L883-_bincast0
	.short L883-_bincast0
	.short L883-_bincast0
.align 2
L921:
	.short L902-_bincast0
	.short L902-_bincast0
	.short L912-_bincast0
	.short L912-_bincast0
	.short L883-_bincast0
	.short L888-_bincast0
	.short L883-_bincast0

_bincast0:
L859:
	pushq %rbx
	pushq %r12
L860:
	movq %rdi,%rbx
	cmpl $1073741830,(%rbx)
	jnz L912
L869:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	call _narrower
	testl %eax,%eax
	jz L912
L865:
	movq 8(%rbx),%rax
	testq $66558,(%rax)
	jz L912
L864:
	movq 16(%rbx),%rcx
	movl (%rcx),%eax
	cmpl $23,%eax
	jl L914
L916:
	cmpl $29,%eax
	jg L914
L913:
	addl $-23,%eax
	movzwl L921(,%rax,2),%eax
	addl $_bincast0,%eax
	jmp *%rax
L888:
	movq 16(%rcx),%rax
	cmpl $1073741830,(%rax)
	jnz L912
L896:
	movq 8(%rax),%rdi
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L912
L892:
	movq 8(%rbx),%rdi
	movq 16(%rbx),%rax
	movq 16(%rax),%rax
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _simpatico
	testl %eax,%eax
	jz L912
L889:
	movq %rbx,%rdi
	call _chop
	movq %rax,%rbx
	movq 16(%rax),%rcx
	movq 16(%rcx),%rcx
	movq %rcx,16(%rax)
	jmp L912
L902:
	movq 16(%rcx),%rdi
	movq 24(%rcx),%rsi
	call _underlying
	movq %rax,%r12
	testq %r12,%r12
	jz L912
L906:
	movq 8(%rbx),%rsi
	movq %r12,%rdi
	call _simpatico
	testl %eax,%eax
	jz L912
L903:
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
	jmp L922
L914:
	cmpl $536870937,%eax
	jl L912
L919:
	cmpl $536870944,%eax
	jg L912
L917:
	addl $-536870937,%eax
	movzwl L920(,%rax,2),%eax
	addl $_bincast0,%eax
	jmp *%rax
L883:
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
	jz L912
L884:
	movq 8(%rbx),%rsi
	movq 24(%rbx),%rdx
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%rbx)
	movq %rax,%rdi
L922:
	call _simplify
	movq %rax,24(%rbx)
L912:
	movq %rbx,%rax
L861:
	popq %r12
	popq %rbx
	ret 

.align 2
L987:
	.short L947-_asgcast0
	.short L955-_asgcast0
	.short L955-_asgcast0
	.short L947-_asgcast0
	.short L947-_asgcast0

_asgcast0:
L923:
	pushq %rbx
L924:
	movq %rdi,%rbx
	movl (%rbx),%eax
	testl $2147483648,%eax
	jnz L983
L937:
	testl $1073741824,%eax
	jnz L983
L933:
	movq 16(%rbx),%rcx
	movq 8(%rcx),%rdx
	movq (%rdx),%rdi
	testq $66558,%rdi
	jz L983
L929:
	movq 24(%rbx),%rcx
	movq 8(%rcx),%rsi
	testq $66558,(%rsi)
	jz L983
L928:
	cmpl $134217740,%eax
	jl L983
L986:
	cmpl $134217744,%eax
	jg L983
L984:
	addl $-134217740,%eax
	movzwl L987(,%rax,2),%eax
	addl $_asgcast0,%eax
	jmp *%rax
L955:
	cmpl $2147483650,(%rcx)
	jnz L958
L963:
	cmpq $0,24(%rcx)
	jnz L958
L959:
	andl $131071,%edi
	leaq 16(%rcx),%rsi
	call _con_in_range
	testl %eax,%eax
	jnz L951
L958:
	movq 24(%rbx),%rax
	cmpl $1073741830,(%rax)
	jnz L983
L975:
	movq 8(%rax),%rdi
	movq 16(%rax),%rax
	movq 8(%rax),%rsi
	call _wider
	testl %eax,%eax
	jz L983
L971:
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
	jz L951
	jnz L983
L947:
	movq %rdx,%rdi
	call _simpatico
	testl %eax,%eax
	jnz L983
L951:
	movq 16(%rbx),%rax
	movq 8(%rax),%rsi
	movq 24(%rbx),%rdx
	movl $1073741830,%edi
	call _unary_tree
	movq %rax,24(%rbx)
	movq %rax,%rdi
	call _simplify
	movq %rax,24(%rbx)
L983:
	movq %rbx,%rax
L925:
	popq %rbx
	ret 


_relcast0:
L988:
	pushq %rbx
	pushq %r12
L989:
	movq %rdi,%r12
	movl (%r12),%eax
	cmpl $35,%eax
	jz L999
L1005:
	cmpl $36,%eax
	jz L999
L1006:
	cmpl $37,%eax
	jz L999
L1007:
	cmpl $38,%eax
	jz L999
L1008:
	cmpl $536870945,%eax
	jz L999
L1009:
	cmpl $536870946,%eax
	jnz L992
L999:
	movq 16(%r12),%rdi
	movq 24(%r12),%rsi
	call _underlying
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L992
L1000:
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
L992:
	movq %r12,%rax
L990:
	popq %r12
	popq %rbx
	ret 


_simplify:
L1012:
	pushq %rbx
	pushq %r12
	pushq %r13
L1013:
	movq %rdi,%rbx
	movl (%rbx),%eax
	movl %eax,%ecx
	andl $1073741824,%ecx
	jz L1019
L1018:
	movq 16(%rbx),%rdi
	call _simplify
	movq %rax,16(%rbx)
	xorl %r13d,%r13d
L1021:
	cmpl 4(%rbx),%r13d
	jge L1020
L1022:
	movq 24(%rbx),%rax
	movslq %r13d,%r12
	movq (%rax,%r12,8),%rdi
	call _simplify
	movq 24(%rbx),%rcx
	movq %rax,(%rcx,%r12,8)
	incl %r13d
	jmp L1021
L1019:
	testl $2147483648,%eax
	jnz L1020
L1028:
	testl %ecx,%ecx
	jnz L1020
L1029:
	movq 16(%rbx),%rdi
	call _simplify
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _simplify
	movq %rax,24(%rbx)
L1020:
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
L1014:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_addrof:
L1033:
L1034:
	movq %rdi,%rdx
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%rdi
	call _indirect0
L1035:
	ret 


_fold:
L1037:
	pushq %rbx
	pushq %r12
	pushq %r13
L1038:
	movq %rdi,%rbx
	movl (%rbx),%eax
	movl %eax,%ecx
	andl $1073741824,%ecx
	jz L1044
L1043:
	movq 16(%rbx),%rdi
	call _fold
	movq %rax,16(%rbx)
	xorl %r13d,%r13d
L1046:
	cmpl 4(%rbx),%r13d
	jge L1045
L1047:
	movq 24(%rbx),%rax
	movslq %r13d,%r12
	movq (%rax,%r12,8),%rdi
	call _fold
	movq 24(%rbx),%rcx
	movq %rax,(%rcx,%r12,8)
	incl %r13d
	jmp L1046
L1044:
	testl $2147483648,%eax
	jnz L1045
L1053:
	testl %ecx,%ecx
	jnz L1045
L1054:
	movq 16(%rbx),%rdi
	call _fold
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _fold
	movq %rax,24(%rbx)
L1045:
	movq %rbx,%rdi
	call _indirect0
	movq %rax,%rdi
	call _fold0
L1039:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_rewrite_volatiles:
L1058:
	pushq %rbx
	pushq %r12
	pushq %r13
L1059:
	movq %rdi,%rbx
	movl (%rbx),%eax
	cmpl $1073741831,%eax
	jz L1090
L1063:
	cmpl $2415919105,%eax
	jnz L1070
L1068:
	movq 24(%rbx),%rcx
	movq 32(%rcx),%rdx
	testq $262144,(%rdx)
	jz L1070
L1069:
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
	jmp L1090
L1070:
	movl %eax,%ecx
	andl $1073741824,%ecx
	jz L1076
L1075:
	movq 16(%rbx),%rdi
	call _rewrite_volatiles
	movq %rax,16(%rbx)
	xorl %r13d,%r13d
L1078:
	cmpl 4(%rbx),%r13d
	jge L1090
L1079:
	movq 24(%rbx),%rax
	movslq %r13d,%r12
	movq (%rax,%r12,8),%rdi
	call _rewrite_volatiles
	movq 24(%rbx),%rcx
	movq %rax,(%rcx,%r12,8)
	incl %r13d
	jmp L1078
L1076:
	testl $2147483648,%eax
	jnz L1090
L1085:
	testl %ecx,%ecx
	jnz L1090
L1086:
	movq 16(%rbx),%rdi
	call _rewrite_volatiles
	movq %rax,16(%rbx)
	movq 24(%rbx),%rdi
	call _rewrite_volatiles
	movq %rax,24(%rbx)
L1090:
	movq %rbx,%rax
L1060:
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
