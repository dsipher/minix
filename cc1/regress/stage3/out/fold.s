.text

_normalize_con:
L1:
L2:
	andl $131071,%edi
	cmpq $2,%rdi
	jz L8
	jl L3
L21:
	cmpq $128,%rdi
	jz L18
	jg L3
L22:
	cmpb $4,%dil
	jz L8
L23:
	cmpb $8,%dil
	jz L10
L24:
	cmpb $16,%dil
	jz L12
L25:
	cmpb $32,%dil
	jz L14
L26:
	cmpb $64,%dil
	jnz L3
L16:
	movq (%rsi),%rax
	movslq %eax,%rax
	jmp L29
L14:
	movq (%rsi),%rax
	movzwq %ax,%rax
	jmp L29
L12:
	movq (%rsi),%rax
	movswq %ax,%rax
	jmp L29
L10:
	movq (%rsi),%rax
	movzbq %al,%rax
	jmp L29
L18:
	movq (%rsi),%rax
	movl %eax,%eax
	jmp L29
L8:
	movq (%rsi),%rax
	movsbq %al,%rax
L29:
	movq %rax,(%rsi)
L3:
	ret 


_con_in_range:
L30:
L31:
	andl $131071,%edi
	cmpq $2,%rdi
	jz L37
	jl L83
L75:
	cmpq $128,%rdi
	jz L67
	jg L83
L76:
	cmpb $4,%dil
	jz L37
L77:
	cmpb $8,%dil
	jz L55
L78:
	cmpb $16,%dil
	jz L43
L79:
	cmpb $32,%dil
	jz L61
L80:
	cmpb $64,%dil
	jnz L83
L49:
	movq (%rsi),%rax
	cmpq $-2147483648,%rax
	jl L84
L50:
	cmpq $2147483647,%rax
	jg L84
	jle L83
L61:
	movq (%rsi),%rax
	cmpq $0,%rax
	jl L84
L62:
	cmpq $65535,%rax
	jg L84
	jle L83
L43:
	movq (%rsi),%rax
	cmpq $-32768,%rax
	jl L84
L44:
	cmpq $32767,%rax
	jg L84
	jle L83
L55:
	movq (%rsi),%rax
	cmpq $0,%rax
	jl L84
L56:
	cmpq $255,%rax
	jg L84
	jle L83
L67:
	movq (%rsi),%rcx
	cmpq $0,%rcx
	jl L84
L68:
	movl $4294967295,%eax
	cmpq %rax,%rcx
	jg L84
	jle L83
L37:
	movq (%rsi),%rax
	cmpq $-128,%rax
	jl L84
L38:
	cmpq $127,%rax
	jg L84
L83:
	movl $1,%eax
	ret
L84:
	xorl %eax,%eax
L32:
	ret 

L111:
	.quad 0x43e0000000000000

_cast_con:
L85:
L86:
	movq %rdi,%r9
	andl $7168,%r9d
	setz %al
	movzbl %al,%r8d
	testq $7168,%rsi
	setz %al
	movzbl %al,%eax
	cmpl %eax,%r8d
	jz L90
L89:
	testq %r9,%r9
	jz L92
L91:
	testl %ecx,%ecx
	jz L94
L96:
	testq $342,%rsi
	jz L99
L98:
	cvtsi2sdq (%rdx),%xmm0
	jmp L112
L99:
	movq (%rdx),%rcx
	cmpq $0,%rcx
	jg L101
L102:
	movq %rcx,%rax
	andl $1,%eax
	orq %rcx,%rax
	cvtsi2sdq %rax,%xmm0
	addsd %xmm0,%xmm0
	jmp L112
L101:
	cvtsi2sdq %rcx,%xmm0
L112:
	movsd %xmm0,(%rdx)
	jmp L90
L94:
	xorl %eax,%eax
	ret
L92:
	testq $342,%rdi
	movsd (%rdx),%xmm1
	jz L105
L104:
	cvttsd2siq %xmm1,%rax
	movq %rax,(%rdx)
	jmp L90
L105:
	movsd L111(%rip),%xmm0
	ucomisd %xmm0,%xmm1
	jb L107
L108:
	subsd %xmm0,%xmm1
	cvttsd2siq %xmm1,%rcx
	movq $-9223372036854775808,%rax
	xorq %rax,%rcx
	jmp L109
L107:
	cvttsd2siq %xmm1,%rcx
L109:
	movq %rcx,(%rdx)
L90:
	movl $1,%eax
L87:
	ret 


_cmp_cons:
L113:
L114:
	xorl %eax,%eax
	testq $7168,%rdi
	jz L117
L119:
	movsd 8(%rsi),%xmm1
	movsd 8(%rdx),%xmm0
	ucomisd %xmm0,%xmm1
	jnz L124
L122:
	orl $1537,%eax
L124:
	ucomisd %xmm0,%xmm1
	jbe L127
L125:
	orl $1282,%eax
L127:
	ucomisd %xmm0,%xmm1
	jb L159
	ret
L117:
	testq $342,%rdi
	jz L146
L134:
	movq 8(%rsi),%rsi
	movq 8(%rdx),%rcx
	cmpq %rcx,%rsi
	jnz L139
L137:
	orl $97,%eax
L139:
	cmpq %rcx,%rsi
	jle L142
L140:
	orl $82,%eax
L142:
	cmpq %rcx,%rsi
	jge L115
L143:
	orl $162,%eax
	ret
L146:
	movq 8(%rsi),%rsi
	movq 8(%rdx),%rcx
	cmpq %rcx,%rsi
	jnz L151
L149:
	orl $1537,%eax
L151:
	cmpq %rcx,%rsi
	jbe L154
L152:
	orl $1282,%eax
L154:
	cmpq %rcx,%rsi
	jae L115
L159:
	orl $2562,%eax
L115:
	ret 


_init_state:
L160:
	pushq %rbx
L161:
	movq %rdi,%rbx
	movl _nr_assigned_regs(%rip),%edx
	addl $63,%edx
	sarl $6,%edx
	cmpl (%rbx),%edx
	jg L170
L169:
	movl %edx,4(%rbx)
	jmp L171
L170:
	movl 4(%rbx),%esi
	subl %esi,%edx
	movl $8,%ecx
	movq %rbx,%rdi
	call _vector_insert
L171:
	movslq 4(%rbx),%rcx
	shlq $3,%rcx
	movq 8(%rbx),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	cmpl $0,24(%rbx)
	jl L176
L175:
	movl $0,28(%rbx)
	jmp L162
L176:
	movl 28(%rbx),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $24,%ecx
	leaq 24(%rbx),%rdi
	call _vector_insert
L162:
	popq %rbx
	ret 


_lookup_constant:
L178:
	pushq %rbx
	pushq %r12
	pushq %r13
L179:
	movq %rdi,%r13
	movl %esi,%r12d
	xorl %ebx,%ebx
L181:
	cmpl 340(%r13),%ebx
	jge L184
L182:
	movq 344(%r13),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movl (%rcx,%rax),%eax
	cmpl %eax,%r12d
	jz L198
L187:
	cmpl %eax,%r12d
	jb L184
L191:
	incl %ebx
	jmp L181
L184:
	testl %edx,%edx
	jz L194
L193:
	movl $24,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 336(%r13),%rdi
	call _vector_insert
	movq 344(%r13),%rcx
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movl %r12d,(%rcx,%rax)
L198:
	movl %ebx,%eax
	jmp L180
L194:
	movl $-1,%eax
L180:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_remove_constant:
L199:
	pushq %rbx
L200:
	movq %rdi,%rbx
	xorl %edx,%edx
	movq %rbx,%rdi
	call _lookup_constant
	movl %eax,%esi
	cmpl $-1,%esi
	jz L201
L202:
	movl $24,%ecx
	movl $1,%edx
	leaq 336(%rbx),%rdi
	call _vector_delete
L201:
	popq %rbx
	ret 


_set_ccs:
L205:
	pushq %rbx
	pushq %r12
L206:
	movq %rdi,%rbx
	movl %esi,%r12d
	movl $1,%edx
	movl $1074266112,%esi
	movq %rbx,%rdi
	call _lookup_constant
	movslq %r12d,%r12
	movq 344(%rbx),%rdx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq %r12,8(%rdx,%rcx)
	movq 344(%rbx),%rax
	movq $0,16(%rcx,%rax)
	movq 320(%rbx),%rcx
	movq $-4294967297,%rax
	andq (%rcx),%rax
	movq %rax,(%rcx)
L207:
	popq %r12
	popq %rbx
	ret 


_get_ccs:
L211:
	pushq %rbx
L212:
	movq %rdi,%rbx
	xorl %edx,%edx
	movl $1074266112,%esi
	movq %rbx,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jnz L215
L214:
	xorl %eax,%eax
	jmp L213
L215:
	movq 344(%rbx),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq 8(%rcx,%rax),%rax
L213:
	popq %rbx
	ret 

L582:
	.quad 0xbff0000000000000
.align 2
L583:
	.short L435-_eval
	.short L396-_eval
	.short L404-_eval
	.short L412-_eval
	.short L420-_eval
	.short L428-_eval

_eval:
L219:
	pushq %rbp
	movq %rsp,%rbp
	subq $104,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L220:
	movq %rdi,-88(%rbp)
	movq -88(%rbp),%rax
	movq 16(%rax),%rax
	movslq %esi,%rsi
	movq (%rax,%rsi,8),%rax
	movl (%rax),%r14d
	movq %rax,-72(%rbp)
	leaq -48(%rbp),%r13
	movq %r13,-56(%rbp)
	leaq -24(%rbp),%rax
	movq %rax,-104(%rbp)
	cmpl $603979787,%r14d
	jnz L227
L233:
	movq -72(%rbp),%rax
	movl 8(%rax),%ecx
	movl %ecx,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L227
L234:
	movq -72(%rbp),%rax
	movl 40(%rax),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L227
L230:
	movq -72(%rbp),%rax
	movl 16(%rax),%edx
	cmpl 48(%rax),%edx
	jnz L227
L226:
	testl $10944,%ecx
	movl $1537,%eax
	movl $97,%esi
	cmovzl %eax,%esi
	jmp L584
L227:
	testl %r14d,%r14d
	jz L221
L544:
	cmpl $41943048,%r14d
	jz L221
L545:
	cmpl $58720258,%r14d
	jz L221
L546:
	cmpl $553648133,%r14d
	jz L221
L547:
	cmpl $822083623,%r14d
	jz L221
L548:
	cmpl $855638054,%r14d
	jz L221
L549:
	cmpl $-1870659577,%r14d
	jz L485
L552:
	cmpl $-1610612733,%r14d
	jz L485
L553:
	cmpl $-1577058300,%r14d
	jz L485
L554:
	cmpl $-1493172218,%r14d
	jz L485
L555:
	cmpl $8388609,%r14d
	jz L485
L556:
	cmpb $24,%r14b
	jb L266
L264:
	cmpb $35,%r14b
	ja L266
L265:
	movq -88(%rbp),%rax
	movq 320(%rax),%rax
	movq (%rax),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	jnz L485
L270:
	movq -88(%rbp),%rdi
	call _get_ccs
	testl %eax,%eax
	jz L509
L274:
	subl $2550136856,%r14d
	movq $0,-32(%rbp)
	movq -88(%rbp),%rdi
	call _get_ccs
	movb %r14b,%cl
	movl $1,%edx
	shll %cl,%edx
	testl %edx,%eax
	setnz %al
	movzbl %al,%eax
	movslq %eax,%rax
	movq %rax,-40(%rbp)
	jmp L277
L266:
	movq $0,-8(%rbp)
	xorl %ebx,%ebx
	movl $0,-92(%rbp)
	movl $0,-60(%rbp)
	testl $2147483648,%r14d
	movl $1,%eax
	movl -92(%rbp),%ecx
	cmovnzl %eax,%ecx
	movslq %ecx,%rcx
	movl %ecx,-92(%rbp)
	shlq $5,%rcx
	movq -72(%rbp),%rax
	movl 8(%rax,%rcx),%r15d
	shll $10,%r15d
	shrl $15,%r15d
L282:
	movl %r14d,%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl %eax,-92(%rbp)
	jge L284
L283:
	movslq -92(%rbp),%r12
	shlq $5,%r12
	movq -72(%rbp),%rax
	movl 8(%rax,%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L286
L285:
	movq -72(%rbp),%rax
	movl 16(%r12,%rax),%esi
	movq -88(%rbp),%rax
	movq 320(%rax),%rdx
	movl %esi,%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L485
L290:
	xorl %edx,%edx
	movq -88(%rbp),%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L293
L292:
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rcx
	shlq $3,%rcx
	movq -88(%rbp),%rdx
	movq 344(%rdx),%rsi
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $3,%rdx
	movq 8(%rsi,%rdx),%rax
	movq %rax,-40(%rbp,%rcx)
	movq -88(%rbp),%rax
	movq 344(%rax),%rax
	movq 16(%rdx,%rax),%rax
	movq %rax,-32(%rbp,%rcx)
	movq -72(%rbp),%rax
	movl 8(%rax,%r12),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -40(%rbp,%rcx),%rsi
	call _normalize_con
	jmp L287
L293:
	movl $1,-60(%rbp)
	jmp L287
L286:
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq -72(%rbp),%rax
	movq 24(%r12,%rax),%rax
	movq %rax,-40(%rbp,%rcx)
	movq -72(%rbp),%rax
	movq 32(%r12,%rax),%rax
	movq %rax,-32(%rbp,%rcx)
L287:
	incl -92(%rbp)
	incl %ebx
	jmp L282
L284:
	cmpl $0,-60(%rbp)
	jz L297
L509:
	cmpl $0,_tmp_regs(%rip)
	jl L513
L512:
	movl $0,_tmp_regs+4(%rip)
	jmp L514
L513:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L514:
	movl $67108864,%edx
	movl $_tmp_regs,%esi
	movq -72(%rbp),%rdi
	call _insn_defs
	xorl %r12d,%r12d
L515:
	cmpl _tmp_regs+4(%rip),%r12d
	jge L221
L519:
	movq _tmp_regs+8(%rip),%rax
	movslq %r12d,%r12
	movl (%rax,%r12,4),%ebx
	testl %ebx,%ebx
	jz L221
L520:
	movl %ebx,%esi
	movq -88(%rbp),%rdi
	call _remove_constant
	andl $1073725440,%ebx
	movl %ebx,%ecx
	sarl $14,%ecx
	movl $1,%edx
	shlq %cl,%rdx
	notq %rdx
	movq -88(%rbp),%rax
	movq 320(%rax),%rax
	sarl $20,%ebx
	movslq %ebx,%rbx
	andq %rdx,(%rax,%rbx,8)
	incl %r12d
	jmp L515
L297:
	cmpl $603979787,%r14d
	jz L304
L559:
	cmpl $-1342177265,%r14d
	jz L304
L560:
	cmpl $-1342177266,%r14d
	jnz L300
L312:
	cmpq $0,-8(%rbp)
	jz L300
L318:
	cmpq $0,-32(%rbp)
	jz L300
L319:
	movq -104(%rbp),%r13
	movq -56(%rbp),%rax
	movq %rax,-104(%rbp)
	jmp L300
L304:
	movq -32(%rbp),%rax
	cmpq -8(%rbp),%rax
	jnz L300
L307:
	movq $0,-8(%rbp)
	movq $0,-32(%rbp)
L300:
	movq -104(%rbp),%rax
	cmpq $0,16(%rax)
	jnz L485
L328:
	cmpl $-1342177266,%r14d
	jz L334
L564:
	cmpl $-1342177265,%r14d
	jz L345
L565:
	cmpl $-1610612726,%r14d
	jz L355
L566:
	cmpl $-1610612727,%r14d
	jz L277
L567:
	cmpq $0,16(%r13)
	jnz L485
L364:
	cmpl $-1275068398,%r14d
	jl L570
L572:
	cmpl $-1275068393,%r14d
	jg L570
L569:
	addl $1275068398,%r14d
	movzwl L583(,%r14,2),%eax
	addl $_eval,%eax
	jmp *%rax
L428:
	movq 8(%r13),%rcx
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	xorq %rcx,%rax
	jmp L589
L420:
	movq 8(%r13),%rcx
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	orq %rcx,%rax
	jmp L589
L412:
	movq 8(%r13),%rcx
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	andq %rcx,%rax
	jmp L589
L404:
	movq 8(%r13),%rdx
	movq -104(%rbp),%rax
	movq 8(%rax),%rcx
	shlq %cl,%rdx
	jmp L595
L396:
	testq $342,%r15
	jz L400
L399:
	movq 8(%r13),%rdx
	movq -104(%rbp),%rax
	movq 8(%rax),%rcx
	sarq %cl,%rdx
	jmp L595
L400:
	movq 8(%r13),%rdx
	movq -104(%rbp),%rax
	movq 8(%rax),%rcx
	shrq %cl,%rdx
	jmp L595
L435:
	movq -104(%rbp),%rax
	movq 8(%rax),%rcx
	testq %rcx,%rcx
	jz L485
L440:
	testq $342,%r15
	jz L444
L443:
	movq 8(%r13),%rax
	cqto 
	idivq %rcx
	jmp L595
L444:
	movq 8(%r13),%rax
	xorl %edx,%edx
	divq %rcx
L595:
	movq %rdx,8(%r13)
	jmp L277
L570:
	cmpl $-1610612724,%r14d
	jz L372
L574:
	cmpl $-1543503859,%r14d
	jz L380
L575:
	cmpl $-1543503836,%r14d
	jz L467
L576:
	cmpl $-1543503835,%r14d
	jz L475
L577:
	cmpl $-1342177264,%r14d
	jz L385
L578:
	cmpl $-1342177263,%r14d
	jz L447
L579:
	cmpl $603979787,%r14d
	jnz L485
L369:
	movq -104(%rbp),%rdx
	movq %r13,%rsi
	movq %r15,%rdi
	call _cmp_cons
	movl %eax,%esi
L584:
	movq -88(%rbp),%rdi
	call _set_ccs
	jmp L221
L447:
	testq $1022,%r15
	jz L453
L451:
	movq -104(%rbp),%rax
	cmpq $0,8(%rax)
	jz L485
L453:
	testq $7168,%r15
	jz L460
L459:
	movsd 8(%r13),%xmm0
	movq -104(%rbp),%rax
	divsd 8(%rax),%xmm0
	jmp L587
L460:
	testq $342,%r15
	jz L463
L462:
	movq 8(%r13),%rax
	cqto 
	movq -104(%rbp),%rcx
	idivq 8(%rcx)
	jmp L589
L463:
	movq 8(%r13),%rax
	xorl %edx,%edx
	movq -104(%rbp),%rcx
	divq 8(%rcx)
	jmp L589
L385:
	testq $7168,%r15
	jz L389
L388:
	movsd 8(%r13),%xmm1
	movq -104(%rbp),%rax
	movsd 8(%rax),%xmm0
	jmp L588
L389:
	movq 8(%r13),%rcx
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	imulq %rcx,%rax
	jmp L589
L475:
	testq $768,%r15
	movq 8(%r13),%rax
	jz L479
L478:
	bsrq %rax,%rax
	jmp L594
L479:
	bsrl %eax,%eax
	jmp L594
L467:
	testq $768,%r15
	movq 8(%r13),%rax
	jz L471
L470:
	bsfq %rax,%rax
	jmp L594
L471:
	bsfl %eax,%eax
L594:
	movslq %eax,%rax
L589:
	movq %rax,8(%r13)
	jmp L277
L380:
	notq 8(%r13)
	jmp L277
L372:
	testq $7168,%r15
	jz L376
L375:
	movsd 8(%r13),%xmm1
	movsd L582(%rip),%xmm0
L588:
	mulsd %xmm1,%xmm0
	jmp L587
L376:
	negq 8(%r13)
	jmp L277
L355:
	movq -72(%rbp),%rax
	movl 8(%rax),%edi
	shll $10,%edi
	shrl $15,%edi
	cmpq $0,16(%r13)
	setz %al
	movzbl %al,%ecx
	leaq 8(%r13),%rdx
	movq %r15,%rsi
	call _cast_con
	testl %eax,%eax
	jnz L277
	jz L485
L345:
	testq $7168,%r15
	jz L349
L348:
	movsd 8(%r13),%xmm0
	movq -104(%rbp),%rax
	subsd 8(%rax),%xmm0
	jmp L587
L349:
	movq 8(%r13),%rcx
	movq -104(%rbp),%rax
	subq 8(%rax),%rcx
	jmp L597
L334:
	testq $7168,%r15
	jz L338
L337:
	movsd 8(%r13),%xmm1
	movq -104(%rbp),%rax
	movsd 8(%rax),%xmm0
	addsd %xmm1,%xmm0
L587:
	movsd %xmm0,8(%r13)
	jmp L277
L338:
	movq 8(%r13),%rcx
	movq -104(%rbp),%rax
	addq 8(%rax),%rcx
L597:
	movq %rcx,8(%r13)
L277:
	movq -72(%rbp),%rax
	movl 16(%rax),%eax
	movl %eax,-76(%rbp)
	movq _reg_to_symbol+8(%rip),%rcx
	movl -76(%rbp),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	subl $34,%eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rax
	movq 32(%rax),%rax
	movq (%rax),%rdi
	andl $131071,%edi
	leaq 8(%r13),%rsi
	call _normalize_con
	movl $1,%edx
	movl -76(%rbp),%esi
	movq -88(%rbp),%rdi
	call _lookup_constant
	movq -88(%rbp),%rcx
	movq 344(%rcx),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $3,%rdx
	movq 8(%r13),%rax
	movq %rax,8(%rcx,%rdx)
	movq 16(%r13),%rcx
	movq -88(%rbp),%rax
	movq 344(%rax),%rax
	movq %rcx,16(%rdx,%rax)
	movq -72(%rbp),%rax
	testl $67108864,(%rax)
	jnz L534
L533:
	movq -72(%rbp),%rdi
	call _insn_defs_cc0
	testl %eax,%eax
	jz L221
L534:
	movl $1074266112,%esi
	movq -88(%rbp),%rdi
	call _remove_constant
	movq -88(%rbp),%rax
	movq 320(%rax),%rcx
	movq $4294967296,%rax
	orq %rax,(%rcx)
	jmp L221
L485:
	cmpl $0,_tmp_regs(%rip)
	jl L489
L488:
	movl $0,_tmp_regs+4(%rip)
	jmp L490
L489:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L490:
	movl $67108864,%edx
	movl $_tmp_regs,%esi
	movq -72(%rbp),%rdi
	call _insn_defs
	xorl %r12d,%r12d
L491:
	cmpl _tmp_regs+4(%rip),%r12d
	jge L221
L495:
	movq _tmp_regs+8(%rip),%rax
	movslq %r12d,%r12
	movl (%rax,%r12,4),%ebx
	testl %ebx,%ebx
	jz L221
L496:
	movl %ebx,%esi
	movq -88(%rbp),%rdi
	call _remove_constant
	andl $1073725440,%ebx
	movl %ebx,%ecx
	sarl $14,%ecx
	movl $1,%edx
	shlq %cl,%rdx
	movq -88(%rbp),%rax
	movq 320(%rax),%rax
	sarl $20,%ebx
	movslq %ebx,%rbx
	orq %rdx,(%rax,%rbx,8)
	incl %r12d
	jmp L491
L221:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_mark:
L600:
	pushq %rbx
L601:
	xorl %ebx,%ebx
L603:
	movl 4(%rdi),%eax
	testl $4,%eax
	jnz L604
L608:
	orl $4,%eax
	movl %eax,4(%rdi)
	incl %ebx
	call _unconditional_succ
	movq %rax,%rdi
	testq %rax,%rax
	jnz L603
L604:
	movl %ebx,%eax
L602:
	popq %rbx
	ret 


_mark_all:
L611:
	pushq %rbx
	pushq %r12
	pushq %r13
L612:
	movq %rdi,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
L614:
	cmpl 60(%r13),%ebx
	jge L617
L615:
	movq 64(%r13),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rdi
	call _mark
	addl %eax,%r12d
	incl %ebx
	jmp L614
L617:
	movl %r12d,%eax
L613:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_meet0:
L619:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L620:
	movq %rdi,%r14
	leaq 312(%r14),%rdi
	call _init_state
	movl $0,-4(%rbp)
L622:
	movl -4(%rbp),%eax
	cmpl 36(%r14),%eax
	jge L621
L623:
	movq 40(%r14),%rcx
	movslq -4(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-24(%rbp)
	xorl %eax,%eax
	movq %rax,-48(%rbp)
	xorl %r13d,%r13d
	movl 316(%r14),%eax
	movl %eax,-36(%rbp)
	xorl %edx,%edx
L629:
	cmpl %edx,-36(%rbp)
	jg L630
L633:
	cmpl 340(%r14),%r13d
	jge L662
L636:
	movq -24(%rbp),%rcx
	movq -48(%rbp),%rax
	cmpl 388(%rcx),%eax
	jl L637
L662:
	cmpl 340(%r14),%r13d
	jl L663
L668:
	movq -24(%rbp),%rcx
	movq -48(%rbp),%rax
	cmpl 388(%rcx),%eax
	jge L670
L669:
	movq -24(%rbp),%rax
	movq 392(%rax),%rcx
	movq -48(%rbp),%rax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rbx
	shlq $3,%rbx
	movl (%rcx,%rbx),%ecx
	movq 320(%r14),%rdx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L673
L674:
	movl 340(%r14),%esi
	leal 1(%rsi),%eax
	cmpl 336(%r14),%eax
	jge L678
L677:
	movl %eax,340(%r14)
	jmp L679
L678:
	movl $24,%ecx
	movl $1,%edx
	leaq 336(%r14),%rdi
	call _vector_insert
L679:
	movq 344(%r14),%rsi
	movl 340(%r14),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $3,%rdx
	movq -24(%rbp),%rax
	movq 392(%rax),%rcx
	movq (%rbx,%rcx),%rax
	movq %rax,(%rsi,%rdx)
	movq 8(%rbx,%rcx),%rax
	movq %rax,8(%rsi,%rdx)
	movq 16(%rbx,%rcx),%rax
	movq %rax,16(%rsi,%rdx)
L673:
	movq -48(%rbp),%rax
	incl %eax
	movq %rax,-48(%rbp)
	jmp L668
L670:
	incl -4(%rbp)
	jmp L622
L663:
	movq 344(%r14),%rcx
	movslq %r13d,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movl (%rcx,%rax),%ecx
	movq 320(%r14),%rdx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jz L666
L665:
	movl $24,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 336(%r14),%rdi
	call _vector_delete
	jmp L662
L666:
	incl %r13d
	jmp L662
L637:
	movq 344(%r14),%rsi
	movslq %r13d,%r13
	leaq (%r13,%r13,2),%r12
	shlq $3,%r12
	movl (%rsi,%r12),%eax
	movl %eax,-40(%rbp)
	movq -24(%rbp),%rax
	movq 392(%rax),%rdx
	movq -48(%rbp),%rax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rbx
	shlq $3,%rbx
	movq %rax,-48(%rbp)
	movl (%rdx,%rbx),%eax
	movq 320(%r14),%r8
	movl -40(%rbp),%ecx
	andl $1073725440,%ecx
	movl %ecx,%edi
	sarl $20,%edi
	movslq %edi,%rdi
	movq %rdi,-16(%rbp)
	sarl $14,%ecx
	movl $1,%r15d
	shlq %cl,%r15
	movq -16(%rbp),%rcx
	testq %r15,(%r8,%rcx,8)
	jz L641
L640:
	movl $24,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 336(%r14),%rdi
	call _vector_delete
	jmp L633
L641:
	movl %eax,%ecx
	andl $1073725440,%ecx
	movl %ecx,%edi
	sarl $20,%edi
	movslq %edi,%rdi
	movq (%r8,%rdi,8),%rdi
	movq %rdi,-32(%rbp)
	sarl $14,%ecx
	movl $1,%edi
	shlq %cl,%rdi
	movq -32(%rbp),%rcx
	testq %rcx,%rdi
	jnz L680
L644:
	cmpl %eax,-40(%rbp)
	jb L646
	jz L650
L649:
	movl $24,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 336(%r14),%rdi
	call _vector_insert
	movq 344(%r14),%rdx
	movq -24(%rbp),%rax
	movq 392(%rax),%rcx
	movq (%rbx,%rcx),%rax
	movq %rax,(%r12,%rdx)
	movq 8(%rbx,%rcx),%rax
	movq %rax,8(%r12,%rdx)
	movq 16(%rbx,%rcx),%rax
	movq %rax,16(%r12,%rdx)
	jmp L681
L650:
	movq 8(%rsi,%r12),%rax
	cmpq 8(%rdx,%rbx),%rax
	jnz L657
L655:
	movq 16(%rsi,%r12),%rax
	cmpq 16(%rdx,%rbx),%rax
	jnz L657
L681:
	incl %r13d
	jmp L680
L657:
	movl $24,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 336(%r14),%rdi
	call _vector_delete
	movq 320(%r14),%rcx
	movq -16(%rbp),%rax
	orq %r15,(%rcx,%rax,8)
L680:
	movq -48(%rbp),%rax
	incl %eax
	movq %rax,-48(%rbp)
	jmp L633
L646:
	incl %r13d
	jmp L633
L630:
	movq -24(%rbp),%rax
	movq 368(%rax),%rax
	movslq %edx,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 320(%r14),%rax
	orq %rcx,(%rax,%rdx,8)
	incl %edx
	jmp L629
L621:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_prop0:
L682:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L683:
	movq %rdi,%r12
	movl $1,%ebx
	testl $4,4(%r12)
	movl $0,%r13d
	jz L685
L687:
	movq %r12,%rdi
	call _meet0
L689:
	cmpl 12(%r12),%r13d
	jge L692
L690:
	movl %r13d,%esi
	movq %r12,%rdi
	call _eval
	incl %r13d
	jmp L689
L692:
	movl 316(%r12),%esi
	xorl %edx,%edx
L696:
	cmpl %edx,%esi
	jle L699
L697:
	movq 320(%r12),%rax
	movslq %edx,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 368(%r12),%rax
	cmpq (%rax,%rdx,8),%rcx
	jnz L722
L702:
	incl %edx
	jmp L696
L699:
	movl 340(%r12),%eax
	cmpl 388(%r12),%eax
	jnz L722
L708:
	xorl %esi,%esi
L710:
	cmpl 340(%r12),%esi
	jge L713
L711:
	movq 344(%r12),%rdi
	movslq %esi,%rsi
	leaq (%rsi,%rsi,2),%rdx
	shlq $3,%rdx
	movq 8(%rdi,%rdx),%rax
	movq 392(%r12),%rcx
	cmpq 8(%rdx,%rcx),%rax
	jnz L722
L717:
	movq 16(%rdi,%rdx),%rax
	cmpq 16(%rdx,%rcx),%rax
	jnz L722
L718:
	incl %esi
	jmp L710
L713:
	xorl %ebx,%ebx
L722:
	movl $48,%ecx
	leaq 312(%r12),%rsi
	leaq -48(%rbp),%rdi
	rep 
	movsb 
	movl $48,%ecx
	leaq 360(%r12),%rsi
	leaq 312(%r12),%rdi
	rep 
	movsb 
	movl $48,%ecx
	leaq -48(%rbp),%rsi
	leaq 360(%r12),%rdi
	rep 
	movsb 
	movl %ebx,%eax
	jmp L684
L685:
	movl %r13d,%eax
L684:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_fold0:
L726:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L727:
	movq %rdi,%r15
	movq %r15,%rdi
	call _meet0
	xorl %r12d,%r12d
L729:
	cmpl 12(%r15),%r12d
	jge L735
L733:
	movq 16(%r15),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%r13
	testq %r13,%r13
	jz L735
L734:
	xorl %ebx,%ebx
L737:
	cmpl 340(%r15),%ebx
	jge L740
L738:
	movq 344(%r15),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movl (%rcx,%rax),%esi
	movq 16(%rcx,%rax),%rdx
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	movq %r13,%rdi
	call _insn_substitute_con
	addq $8,%rsp
	testl %eax,%eax
	jz L743
L741:
	orl $26,_opt_request(%rip)
L743:
	incl %ebx
	jmp L737
L740:
	movl %r12d,%esi
	movq %r15,%rdi
	call _eval
	cmpl $0,_tmp_regs(%rip)
	jl L748
L747:
	movl $0,_tmp_regs+4(%rip)
	jmp L749
L748:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L749:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r13,%rdi
	call _insn_defs
	cmpl $1,_tmp_regs+4(%rip)
	jnz L731
L752:
	movq _tmp_regs+8(%rip),%rax
	movl (%rax),%r14d
	xorl %edx,%edx
	movl %r14d,%esi
	movq %r15,%rdi
	call _lookup_constant
	movl %eax,%ebx
	cmpl $-1,%ebx
	jz L731
L756:
	testl $16777216,(%r13)
	jnz L731
L761:
	movq %r13,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jnz L731
L763:
	testl $8388608,(%r13)
	jnz L731
L769:
	testl $1,4(%r13)
	jnz L731
L771:
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r13
	movq 16(%r15),%rax
	movslq %r12d,%r12
	movq (%rax,%r12,8),%rsi
	movl $32,%ecx
	addq $8,%rsi
	leaq 8(%r13),%rdi
	rep 
	movsb 
	movq 16(%r15),%rax
	movq (%rax,%r12,8),%rsi
	movl $32,%ecx
	addq $8,%rsi
	leaq 40(%r13),%rdi
	rep 
	movsb 
	movq 344(%r15),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rdx
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	movl %r14d,%esi
	movq %r13,%rdi
	call _insn_substitute_con
	addq $8,%rsp
	movq 16(%r15),%rax
	movq %r13,(%rax,%r12,8)
	orl $26,_opt_request(%rip)
L731:
	incl %r12d
	jmp L729
L735:
	movq 320(%r15),%rax
	movq (%rax),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	setnz %al
	movzbl %al,%ebx
	movq %r15,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L776
L781:
	testl %ebx,%ebx
	jnz L776
L782:
	movq %r15,%rdi
	call _get_ccs
	testl %eax,%eax
	jz L776
L778:
	movq %r15,%rdi
	call _get_ccs
	movl $1,%edx
	movl %eax,%esi
	movq %r15,%rdi
	call _predict_succ
	orl $32,_opt_request(%rip)
L776:
	testl $1,4(%r15)
	jz L728
L796:
	movl 80(%r15),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L728
L797:
	xorl %edx,%edx
	movl 88(%r15),%esi
	movq %r15,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L728
L793:
	movq 344(%r15),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jnz L728
L789:
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	movl $1,%esi
	movq %r15,%rdi
	call _predict_switch_succ
	addq $8,%rsp
	orl $32,_opt_request(%rip)
L728:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_project0:
L800:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L801:
	movq %rdi,%r12
	movq %r12,%rdi
	call _unconditional_succ
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L802
L818:
	cmpl $1,12(%rbx)
	jnz L802
L814:
	movq 16(%rbx),%rax
	leaq -4(%rbp),%rsi
	movq (%rax),%rdi
	call _insn_is_cmp_con
	testl %eax,%eax
	jz L802
L810:
	xorl %edx,%edx
	movl -4(%rbp),%esi
	movq %r12,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L802
L806:
	movq 344(%r12),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jnz L802
L803:
	movq 16(%rbx),%rax
	movq (%rax),%rdi
	call _dup_insn
	movq %r12,%rsi
	movq %rax,%rdi
	call _append_insn
	movq %rbx,%rsi
	movq %r12,%rdi
	call _dup_succs
	orl $64,_opt_request(%rip)
L802:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_opt_lir_fold:
L822:
	pushq %rbx
	pushq %r12
L823:
	movq _all_blocks(%rip),%rbx
L825:
	testq %rbx,%rbx
	jz L828
L826:
	andl $-5,4(%rbx)
	movl $0,312(%rbx)
	movl $0,316(%rbx)
	movq $0,320(%rbx)
	movq $_local_arena,328(%rbx)
	movl $0,336(%rbx)
	movl $0,340(%rbx)
	movq $0,344(%rbx)
	movq $_local_arena,352(%rbx)
	leaq 312(%rbx),%rdi
	call _init_state
	movl $0,360(%rbx)
	movl $0,364(%rbx)
	movq $0,368(%rbx)
	movq $_local_arena,376(%rbx)
	movl $0,384(%rbx)
	movl $0,388(%rbx)
	movq $0,392(%rbx)
	movq $_local_arena,400(%rbx)
	leaq 360(%rbx),%rdi
	call _init_state
	movq 112(%rbx),%rbx
	jmp L825
L828:
	xorl %edi,%edi
	call _sequence_blocks
	movq _entry_block(%rip),%rdi
	call _mark
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
L850:
	movl $_prop0,%edi
	call _iterate_blocks
	xorl %ebx,%ebx
	movq _all_blocks(%rip),%r12
L853:
	testq %r12,%r12
	jz L856
L854:
	testl $4,4(%r12)
	jz L855
L859:
	movq %r12,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L862
L861:
	movq 320(%r12),%rax
	movq (%rax),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	jnz L907
L867:
	movq %r12,%rdi
	call _get_ccs
	testl %eax,%eax
	jz L907
L869:
	movq %r12,%rdi
	call _get_ccs
	xorl %edx,%edx
	movl %eax,%esi
	movq %r12,%rdi
	call _predict_succ
	jmp L908
L862:
	testl $1,4(%r12)
	jz L855
L874:
	movl 80(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L855
L875:
	movl 88(%r12),%esi
	movq 320(%r12),%rdx
	movl %esi,%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L907
L885:
	xorl %edx,%edx
	movq %r12,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L907
L887:
	movq 344(%r12),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jz L883
L907:
	movq %r12,%rdi
	call _mark_all
	jmp L906
L883:
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	xorl %esi,%esi
	movq %r12,%rdi
	call _predict_switch_succ
	addq $8,%rsp
L908:
	movq %rax,%rdi
	call _mark
L906:
	addl %eax,%ebx
L855:
	movq 112(%r12),%r12
	jmp L853
L856:
	testl %ebx,%ebx
	jnz L850
L851:
	movq _all_blocks(%rip),%rbx
L889:
	testq %rbx,%rbx
	jz L892
L890:
	testl $4,4(%rbx)
	jz L895
L893:
	movq %rbx,%rdi
	call _fold0
L895:
	movq 112(%rbx),%rbx
	jmp L889
L892:
	movq _all_blocks(%rip),%rbx
L896:
	testq %rbx,%rbx
	jz L903
L897:
	testl $4,4(%rbx)
	jz L902
L900:
	movq %rbx,%rdi
	call _project0
L902:
	movq 112(%rbx),%rbx
	jmp L896
L903:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L824:
	popq %r12
	popq %rbx
	ret 

.local _tmp_regs
.comm _tmp_regs, 24, 8

.globl _all_blocks
.globl _reg_to_symbol
.globl _insn_defs_mem0
.globl _sequence_blocks
.globl _predict_succ
.globl _predict_switch_succ
.globl _entry_block
.globl _normalize_con
.globl _opt_request
.globl _conditional_block
.globl _cast_con
.globl _iterate_blocks
.globl _dup_succs
.globl _nr_assigned_regs
.globl _local_arena
.globl _new_insn
.globl _append_insn
.globl _con_in_range
.globl _unconditional_succ
.globl _vector_insert
.globl _insn_defs_cc0
.globl _dup_insn
.globl _insn_substitute_con
.globl _opt_lir_fold
.globl _vector_delete
.globl _insn_is_cmp_con
.globl _insn_defs
