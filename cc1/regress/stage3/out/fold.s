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
	movl (%rax),%ebx
	movq %rax,-80(%rbp)
	leaq -48(%rbp),%r15
	movq %r15,-56(%rbp)
	leaq -24(%rbp),%r14
	movq %r14,-64(%rbp)
	cmpl $603979787,%ebx
	jnz L227
L233:
	movq -80(%rbp),%rax
	movl 8(%rax),%ecx
	movl %ecx,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L227
L234:
	movq -80(%rbp),%rax
	movl 40(%rax),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L227
L230:
	movq -80(%rbp),%rax
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
	testl %ebx,%ebx
	jz L221
L544:
	cmpl $41943048,%ebx
	jz L221
L545:
	cmpl $58720258,%ebx
	jz L221
L546:
	cmpl $553648133,%ebx
	jz L221
L547:
	cmpl $822083623,%ebx
	jz L221
L548:
	cmpl $855638054,%ebx
	jz L221
L549:
	cmpl $-1870659577,%ebx
	jz L485
L552:
	cmpl $-1610612733,%ebx
	jz L485
L553:
	cmpl $-1577058300,%ebx
	jz L485
L554:
	cmpl $-1493172218,%ebx
	jz L485
L555:
	cmpl $8388609,%ebx
	jz L485
L556:
	cmpb $24,%bl
	jb L266
L264:
	cmpb $35,%bl
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
	subl $2550136856,%ebx
	movq $0,-32(%rbp)
	movq -88(%rbp),%rdi
	call _get_ccs
	movb %bl,%cl
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
	xorl %r13d,%r13d
	movl $0,-96(%rbp)
	movl $0,-68(%rbp)
	testl $2147483648,%ebx
	movl $1,%eax
	movl -96(%rbp),%ecx
	cmovnzl %eax,%ecx
	movslq %ecx,%rcx
	movl %ecx,-96(%rbp)
	shlq $5,%rcx
	movq -80(%rbp),%rax
	movl 8(%rax,%rcx),%r12d
	shll $10,%r12d
	shrl $15,%r12d
L282:
	movl %ebx,%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl %eax,-96(%rbp)
	jge L284
L283:
	movslq -96(%rbp),%rax
	shlq $5,%rax
	movq %rax,-104(%rbp)
	movq -80(%rbp),%rcx
	movq -104(%rbp),%rax
	movl 8(%rcx,%rax),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L286
L285:
	movq -80(%rbp),%rcx
	movq -104(%rbp),%rax
	movl 16(%rax,%rcx),%esi
	movq -88(%rbp),%rax
	movq 320(%rax),%rdx
	movl %esi,%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andb $63,%cl
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
	movslq %r13d,%r13
	leaq (%r13,%r13,2),%rcx
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
	movq -80(%rbp),%rdx
	movq -104(%rbp),%rax
	movl 8(%rdx,%rax),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -40(%rbp,%rcx),%rsi
	call _normalize_con
	jmp L287
L293:
	movl $1,-68(%rbp)
	jmp L287
L286:
	movslq %r13d,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $3,%rdx
	movq -80(%rbp),%rcx
	movq -104(%rbp),%rax
	movq 24(%rax,%rcx),%rax
	movq %rax,-40(%rbp,%rdx)
	movq -80(%rbp),%rcx
	movq -104(%rbp),%rax
	movq 32(%rax,%rcx),%rax
	movq %rax,-32(%rbp,%rdx)
L287:
	incl -96(%rbp)
	incl %r13d
	jmp L282
L284:
	cmpl $0,-68(%rbp)
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
	movq -80(%rbp),%rdi
	call _insn_defs
	xorl %ebx,%ebx
L515:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L221
L519:
	movq _tmp_regs+8(%rip),%rax
	movslq %ebx,%rbx
	movl (%rax,%rbx,4),%r12d
	testl %r12d,%r12d
	jz L221
L520:
	movl %r12d,%esi
	movq -88(%rbp),%rdi
	call _remove_constant
	andl $1073725440,%r12d
	movl %r12d,%ecx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%edx
	shlq %cl,%rdx
	notq %rdx
	movq -88(%rbp),%rax
	movq 320(%rax),%rax
	sarl $20,%r12d
	movslq %r12d,%r12
	andq %rdx,(%rax,%r12,8)
	incl %ebx
	jmp L515
L297:
	cmpl $603979787,%ebx
	jz L304
L559:
	cmpl $-1342177265,%ebx
	jz L304
L560:
	cmpl $-1342177266,%ebx
	jnz L300
L312:
	cmpq $0,-8(%rbp)
	jz L300
L318:
	cmpq $0,-32(%rbp)
	jz L300
L319:
	movq -64(%rbp),%r15
	movq -56(%rbp),%r14
	jmp L300
L304:
	movq -32(%rbp),%rax
	cmpq -8(%rbp),%rax
	jnz L300
L307:
	movq $0,-8(%rbp)
	movq $0,-32(%rbp)
L300:
	cmpq $0,16(%r14)
	jnz L485
L328:
	cmpl $-1342177266,%ebx
	jz L334
L564:
	cmpl $-1342177265,%ebx
	jz L345
L565:
	cmpl $-1610612726,%ebx
	jz L355
L566:
	cmpl $-1610612727,%ebx
	jz L277
L567:
	cmpq $0,16(%r15)
	jnz L485
L364:
	cmpl $-1275068398,%ebx
	jl L570
L572:
	cmpl $-1275068393,%ebx
	jg L570
L569:
	addl $1275068398,%ebx
	movzwl L583(,%rbx,2),%eax
	addl $_eval,%eax
	jmp *%rax
L428:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	xorq %rcx,%rax
	jmp L589
L420:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	orq %rcx,%rax
	jmp L589
L412:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	andq %rcx,%rax
	jmp L589
L404:
	movq 8(%r15),%rax
	movq 8(%r14),%rcx
	shlq %cl,%rax
	jmp L589
L396:
	testq $342,%r12
	jz L400
L399:
	movq 8(%r15),%rax
	movq 8(%r14),%rcx
	sarq %cl,%rax
	jmp L589
L400:
	movq 8(%r15),%rax
	movq 8(%r14),%rcx
	shrq %cl,%rax
	jmp L589
L435:
	movq 8(%r14),%rcx
	testq %rcx,%rcx
	jz L485
L440:
	testq $342,%r12
	jz L444
L443:
	movq 8(%r15),%rax
	cqto 
	idivq %rcx
	jmp L585
L444:
	movq 8(%r15),%rax
	xorl %edx,%edx
	divq %rcx
L585:
	movq %rdx,8(%r15)
	jmp L277
L570:
	cmpl $-1610612724,%ebx
	jz L372
L574:
	cmpl $-1543503859,%ebx
	jz L380
L575:
	cmpl $-1543503836,%ebx
	jz L467
L576:
	cmpl $-1543503835,%ebx
	jz L475
L577:
	cmpl $-1342177264,%ebx
	jz L385
L578:
	cmpl $-1342177263,%ebx
	jz L447
L579:
	cmpl $603979787,%ebx
	jnz L485
L369:
	movq %r14,%rdx
	movq %r15,%rsi
	movq %r12,%rdi
	call _cmp_cons
	movl %eax,%esi
L584:
	movq -88(%rbp),%rdi
	call _set_ccs
	jmp L221
L447:
	testq $1022,%r12
	jz L453
L451:
	cmpq $0,8(%r14)
	jz L485
L453:
	testq $7168,%r12
	jz L460
L459:
	movsd 8(%r15),%xmm0
	divsd 8(%r14),%xmm0
	jmp L587
L460:
	testq $342,%r12
	jz L463
L462:
	movq 8(%r15),%rax
	cqto 
	idivq 8(%r14)
	jmp L589
L463:
	movq 8(%r15),%rax
	xorl %edx,%edx
	divq 8(%r14)
	jmp L589
L385:
	testq $7168,%r12
	jz L389
L388:
	movsd 8(%r15),%xmm1
	movsd 8(%r14),%xmm0
	jmp L588
L389:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	imulq %rcx,%rax
	jmp L589
L475:
	testq $768,%r12
	movq 8(%r15),%rax
	jz L479
L478:
	bsrq %rax,%rax
	jmp L597
L479:
	bsrl %eax,%eax
	jmp L597
L467:
	testq $768,%r12
	movq 8(%r15),%rax
	jz L471
L470:
	bsfq %rax,%rax
	jmp L597
L471:
	bsfl %eax,%eax
L597:
	movslq %eax,%rax
	jmp L589
L380:
	notq 8(%r15)
	jmp L277
L372:
	testq $7168,%r12
	jz L376
L375:
	movsd 8(%r15),%xmm1
	movsd L582(%rip),%xmm0
L588:
	mulsd %xmm1,%xmm0
	jmp L587
L376:
	negq 8(%r15)
	jmp L277
L355:
	movq -80(%rbp),%rax
	movl 8(%rax),%edi
	shll $10,%edi
	shrl $15,%edi
	cmpq $0,16(%r15)
	setz %al
	movzbl %al,%ecx
	leaq 8(%r15),%rdx
	movq %r12,%rsi
	call _cast_con
	testl %eax,%eax
	jnz L277
	jz L485
L345:
	testq $7168,%r12
	jz L349
L348:
	movsd 8(%r15),%xmm0
	subsd 8(%r14),%xmm0
	jmp L587
L349:
	movq 8(%r15),%rax
	subq 8(%r14),%rax
	jmp L589
L334:
	testq $7168,%r12
	jz L338
L337:
	movsd 8(%r15),%xmm1
	movsd 8(%r14),%xmm0
	addsd %xmm1,%xmm0
L587:
	movsd %xmm0,8(%r15)
	jmp L277
L338:
	movq 8(%r15),%rax
	addq 8(%r14),%rax
L589:
	movq %rax,8(%r15)
L277:
	movq -80(%rbp),%rax
	movl 16(%rax),%eax
	movl %eax,-92(%rbp)
	movq _reg_to_symbol+8(%rip),%rcx
	movl -92(%rbp),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	subl $34,%eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rax
	movq 32(%rax),%rax
	movq (%rax),%rdi
	andl $131071,%edi
	leaq 8(%r15),%rsi
	call _normalize_con
	movl $1,%edx
	movl -92(%rbp),%esi
	movq -88(%rbp),%rdi
	call _lookup_constant
	movq -88(%rbp),%rcx
	movq 344(%rcx),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $3,%rdx
	movq 8(%r15),%rax
	movq %rax,8(%rcx,%rdx)
	movq 16(%r15),%rcx
	movq -88(%rbp),%rax
	movq 344(%rax),%rax
	movq %rcx,16(%rdx,%rax)
	movq -80(%rbp),%rax
	testl $67108864,(%rax)
	jnz L534
L533:
	movq -80(%rbp),%rdi
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
	movq -80(%rbp),%rdi
	call _insn_defs
	xorl %ebx,%ebx
L491:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L221
L495:
	movq _tmp_regs+8(%rip),%rax
	movslq %ebx,%rbx
	movl (%rax,%rbx,4),%r12d
	testl %r12d,%r12d
	jz L221
L496:
	movl %r12d,%esi
	movq -88(%rbp),%rdi
	call _remove_constant
	andl $1073725440,%r12d
	movl %r12d,%ecx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%edx
	shlq %cl,%rdx
	movq -88(%rbp),%rax
	movq 320(%rax),%rax
	sarl $20,%r12d
	movslq %r12d,%r12
	orq %rdx,(%rax,%r12,8)
	incl %ebx
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
L598:
	pushq %rbx
L599:
	xorl %ebx,%ebx
L601:
	movl 4(%rdi),%eax
	testl $4,%eax
	jnz L602
L606:
	orl $4,%eax
	movl %eax,4(%rdi)
	incl %ebx
	call _unconditional_succ
	movq %rax,%rdi
	testq %rax,%rax
	jnz L601
L602:
	movl %ebx,%eax
L600:
	popq %rbx
	ret 


_mark_all:
L609:
	pushq %rbx
	pushq %r12
	pushq %r13
L610:
	movq %rdi,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
L612:
	cmpl 60(%r13),%ebx
	jge L615
L613:
	movq 64(%r13),%rcx
	movslq %ebx,%rbx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rdi
	call _mark
	addl %eax,%r12d
	incl %ebx
	jmp L612
L615:
	movl %r12d,%eax
L611:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_meet0:
L617:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L618:
	movq %rdi,%r15
	leaq 312(%r15),%rdi
	call _init_state
	movl $0,-4(%rbp)
L620:
	movl -4(%rbp),%eax
	cmpl 36(%r15),%eax
	jge L619
L621:
	movq 40(%r15),%rcx
	movslq -4(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-24(%rbp)
	xorl %eax,%eax
	movq %rax,-48(%rbp)
	xorl %r14d,%r14d
	movl 316(%r15),%eax
	movl %eax,-36(%rbp)
	xorl %edx,%edx
L627:
	cmpl %edx,-36(%rbp)
	jg L628
L631:
	cmpl 340(%r15),%r14d
	jge L660
L634:
	movq -24(%rbp),%rcx
	movq -48(%rbp),%rax
	cmpl 388(%rcx),%eax
	jl L635
L660:
	cmpl 340(%r15),%r14d
	jl L661
L666:
	movq -24(%rbp),%rcx
	movq -48(%rbp),%rax
	cmpl 388(%rcx),%eax
	jge L668
L667:
	movq -24(%rbp),%rax
	movq 392(%rax),%rcx
	movq -48(%rbp),%rax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rbx
	shlq $3,%rbx
	movl (%rcx,%rbx),%ecx
	movq 320(%r15),%rdx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L671
L672:
	movl 340(%r15),%esi
	leal 1(%rsi),%eax
	cmpl 336(%r15),%eax
	jge L676
L675:
	movl %eax,340(%r15)
	jmp L677
L676:
	movl $24,%ecx
	movl $1,%edx
	leaq 336(%r15),%rdi
	call _vector_insert
L677:
	movq 344(%r15),%rsi
	movl 340(%r15),%eax
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
L671:
	movq -48(%rbp),%rax
	incl %eax
	movq %rax,-48(%rbp)
	jmp L666
L668:
	incl -4(%rbp)
	jmp L620
L661:
	movq 344(%r15),%rcx
	movslq %r14d,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movl (%rcx,%rax),%ecx
	movq 320(%r15),%rdx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jz L664
L663:
	movl $24,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 336(%r15),%rdi
	call _vector_delete
	jmp L660
L664:
	incl %r14d
	jmp L660
L635:
	movq 344(%r15),%rsi
	movslq %r14d,%r14
	leaq (%r14,%r14,2),%r13
	shlq $3,%r13
	movl (%rsi,%r13),%eax
	movl %eax,-40(%rbp)
	movq -24(%rbp),%rax
	movq 392(%rax),%rdx
	movq -48(%rbp),%rax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%r12
	shlq $3,%r12
	movq %rax,-48(%rbp)
	movl (%rdx,%r12),%eax
	movq 320(%r15),%r8
	movl -40(%rbp),%ecx
	andl $1073725440,%ecx
	movl %ecx,%edi
	sarl $20,%edi
	movslq %edi,%rdi
	movq %rdi,-16(%rbp)
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%ebx
	shlq %cl,%rbx
	movq -16(%rbp),%rcx
	testq %rbx,(%r8,%rcx,8)
	jz L639
L638:
	movl $24,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 336(%r15),%rdi
	call _vector_delete
	jmp L631
L639:
	movl %eax,%ecx
	andl $1073725440,%ecx
	movl %ecx,%edi
	sarl $20,%edi
	movslq %edi,%rdi
	movq (%r8,%rdi,8),%rdi
	movq %rdi,-32(%rbp)
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%edi
	shlq %cl,%rdi
	movq -32(%rbp),%rcx
	testq %rcx,%rdi
	jnz L678
L642:
	cmpl %eax,-40(%rbp)
	jb L644
	jz L648
L647:
	movl $24,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 336(%r15),%rdi
	call _vector_insert
	movq 344(%r15),%rdx
	movq -24(%rbp),%rax
	movq 392(%rax),%rcx
	movq (%r12,%rcx),%rax
	movq %rax,(%r13,%rdx)
	movq 8(%r12,%rcx),%rax
	movq %rax,8(%r13,%rdx)
	movq 16(%r12,%rcx),%rax
	movq %rax,16(%r13,%rdx)
	jmp L679
L648:
	movq 8(%rsi,%r13),%rax
	cmpq 8(%rdx,%r12),%rax
	jnz L655
L653:
	movq 16(%rsi,%r13),%rax
	cmpq 16(%rdx,%r12),%rax
	jnz L655
L679:
	incl %r14d
	jmp L678
L655:
	movl $24,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 336(%r15),%rdi
	call _vector_delete
	movq 320(%r15),%rcx
	movq -16(%rbp),%rax
	orq %rbx,(%rcx,%rax,8)
L678:
	movq -48(%rbp),%rax
	incl %eax
	movq %rax,-48(%rbp)
	jmp L631
L644:
	incl %r14d
	jmp L631
L628:
	movq -24(%rbp),%rax
	movq 368(%rax),%rax
	movslq %edx,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 320(%r15),%rax
	orq %rcx,(%rax,%rdx,8)
	incl %edx
	jmp L627
L619:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_prop0:
L680:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L681:
	movq %rdi,%r12
	movl $1,%ebx
	testl $4,4(%r12)
	movl $0,%r13d
	jz L683
L685:
	movq %r12,%rdi
	call _meet0
L687:
	cmpl 12(%r12),%r13d
	jge L690
L688:
	movl %r13d,%esi
	movq %r12,%rdi
	call _eval
	incl %r13d
	jmp L687
L690:
	movl 316(%r12),%esi
	xorl %edx,%edx
L694:
	cmpl %edx,%esi
	jle L697
L695:
	movq 320(%r12),%rax
	movslq %edx,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 368(%r12),%rax
	cmpq (%rax,%rdx,8),%rcx
	jnz L720
L700:
	incl %edx
	jmp L694
L697:
	movl 340(%r12),%eax
	cmpl 388(%r12),%eax
	jnz L720
L706:
	xorl %esi,%esi
L708:
	cmpl 340(%r12),%esi
	jge L711
L709:
	movq 344(%r12),%rdi
	movslq %esi,%rsi
	leaq (%rsi,%rsi,2),%rdx
	shlq $3,%rdx
	movq 8(%rdi,%rdx),%rax
	movq 392(%r12),%rcx
	cmpq 8(%rdx,%rcx),%rax
	jnz L720
L715:
	movq 16(%rdi,%rdx),%rax
	cmpq 16(%rdx,%rcx),%rax
	jnz L720
L716:
	incl %esi
	jmp L708
L711:
	xorl %ebx,%ebx
L720:
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
	jmp L682
L683:
	movl %r13d,%eax
L682:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_fold0:
L724:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L725:
	movq %rdi,%r15
	movq %r15,%rdi
	call _meet0
	xorl %r12d,%r12d
L727:
	cmpl 12(%r15),%r12d
	jge L733
L731:
	movq 16(%r15),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%r13
	testq %r13,%r13
	jz L733
L732:
	xorl %ebx,%ebx
L735:
	cmpl 340(%r15),%ebx
	jge L738
L736:
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
	jz L741
L739:
	orl $26,_opt_request(%rip)
L741:
	incl %ebx
	jmp L735
L738:
	movl %r12d,%esi
	movq %r15,%rdi
	call _eval
	cmpl $0,_tmp_regs(%rip)
	jl L746
L745:
	movl $0,_tmp_regs+4(%rip)
	jmp L747
L746:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L747:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r13,%rdi
	call _insn_defs
	cmpl $1,_tmp_regs+4(%rip)
	jnz L729
L750:
	movq _tmp_regs+8(%rip),%rax
	movl (%rax),%r14d
	xorl %edx,%edx
	movl %r14d,%esi
	movq %r15,%rdi
	call _lookup_constant
	movl %eax,%ebx
	cmpl $-1,%ebx
	jz L729
L754:
	testl $16777216,(%r13)
	jnz L729
L759:
	movq %r13,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jnz L729
L761:
	testl $8388608,(%r13)
	jnz L729
L767:
	testl $1,4(%r13)
	jnz L729
L769:
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
L729:
	incl %r12d
	jmp L727
L733:
	movq 320(%r15),%rax
	movq (%rax),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	setnz %al
	movzbl %al,%ebx
	movq %r15,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L774
L779:
	testl %ebx,%ebx
	jnz L774
L780:
	movq %r15,%rdi
	call _get_ccs
	testl %eax,%eax
	jz L774
L776:
	movq %r15,%rdi
	call _get_ccs
	movl $1,%edx
	movl %eax,%esi
	movq %r15,%rdi
	call _predict_succ
	orl $32,_opt_request(%rip)
L774:
	testl $1,4(%r15)
	jz L726
L794:
	movl 80(%r15),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L726
L795:
	xorl %edx,%edx
	movl 88(%r15),%esi
	movq %r15,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L726
L791:
	movq 344(%r15),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jnz L726
L787:
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	movl $1,%esi
	movq %r15,%rdi
	call _predict_switch_succ
	addq $8,%rsp
	orl $32,_opt_request(%rip)
L726:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_project0:
L798:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L799:
	movq %rdi,%r12
	movq %r12,%rdi
	call _unconditional_succ
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L800
L816:
	cmpl $1,12(%rbx)
	jnz L800
L812:
	movq 16(%rbx),%rax
	leaq -4(%rbp),%rsi
	movq (%rax),%rdi
	call _insn_is_cmp_con
	testl %eax,%eax
	jz L800
L808:
	xorl %edx,%edx
	movl -4(%rbp),%esi
	movq %r12,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L800
L804:
	movq 344(%r12),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jnz L800
L801:
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
L800:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_opt_lir_fold:
L820:
	pushq %rbx
	pushq %r12
L821:
	movq _all_blocks(%rip),%rbx
L823:
	testq %rbx,%rbx
	jz L826
L824:
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
	jmp L823
L826:
	xorl %edi,%edi
	call _sequence_blocks
	movq _entry_block(%rip),%rdi
	call _mark
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
L848:
	movl $_prop0,%edi
	call _iterate_blocks
	xorl %ebx,%ebx
	movq _all_blocks(%rip),%r12
L851:
	testq %r12,%r12
	jz L854
L852:
	testl $4,4(%r12)
	jz L853
L857:
	movq %r12,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L860
L859:
	movq 320(%r12),%rax
	movq (%rax),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	jnz L905
L865:
	movq %r12,%rdi
	call _get_ccs
	testl %eax,%eax
	jz L905
L867:
	movq %r12,%rdi
	call _get_ccs
	xorl %edx,%edx
	movl %eax,%esi
	movq %r12,%rdi
	call _predict_succ
	jmp L906
L860:
	testl $1,4(%r12)
	jz L853
L872:
	movl 80(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L853
L873:
	movl 88(%r12),%esi
	movq 320(%r12),%rdx
	movl %esi,%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L905
L883:
	xorl %edx,%edx
	movq %r12,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L905
L885:
	movq 344(%r12),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jz L881
L905:
	movq %r12,%rdi
	call _mark_all
	jmp L904
L881:
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	xorl %esi,%esi
	movq %r12,%rdi
	call _predict_switch_succ
	addq $8,%rsp
L906:
	movq %rax,%rdi
	call _mark
L904:
	addl %eax,%ebx
L853:
	movq 112(%r12),%r12
	jmp L851
L854:
	testl %ebx,%ebx
	jnz L848
L849:
	movq _all_blocks(%rip),%rbx
L887:
	testq %rbx,%rbx
	jz L890
L888:
	testl $4,4(%rbx)
	jz L893
L891:
	movq %rbx,%rdi
	call _fold0
L893:
	movq 112(%rbx),%rbx
	jmp L887
L890:
	movq _all_blocks(%rip),%rbx
L894:
	testq %rbx,%rbx
	jz L901
L895:
	testl $4,4(%rbx)
	jz L900
L898:
	movq %rbx,%rdi
	call _project0
L900:
	movq 112(%rbx),%rbx
	jmp L894
L901:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L822:
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
