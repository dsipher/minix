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
	setz %r8b
	movzbl %r8b,%r8d
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
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
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
	movq %rdi,%r12
	movl %esi,%ebx
	movl $1,%edx
	movl $1074266112,%esi
	movq %r12,%rdi
	call _lookup_constant
	movslq %ebx,%rbx
	movq 344(%r12),%rdx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq %rbx,8(%rdx,%rcx)
	movq 344(%r12),%rax
	movq $0,16(%rcx,%rax)
	movq 320(%r12),%rcx
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
	movq %rax,-80(%rbp)
	movq -80(%rbp),%rax
	movl (%rax),%ebx
	leaq -48(%rbp),%rax
	movq %rax,-56(%rbp)
	movq -56(%rbp),%rax
	movq %rax,-104(%rbp)
	leaq -24(%rbp),%rax
	movq %rax,-64(%rbp)
	movq -64(%rbp),%r15
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
	movq -80(%rbp),%rax
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
	movl $0,-96(%rbp)
	xorl %r14d,%r14d
	movl $0,-68(%rbp)
	testl $2147483648,%ebx
	movl $1,%eax
	cmovnzl %eax,%r14d
	movslq %r14d,%rcx
	shlq $5,%rcx
	movq -80(%rbp),%rax
	movl 8(%rax,%rcx),%r12d
	shll $10,%r12d
	shrl $15,%r12d
L282:
	movl %ebx,%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl %eax,%r14d
	jge L284
L283:
	movslq %r14d,%r13
	shlq $5,%r13
	movq -80(%rbp),%rax
	movl 8(%rax,%r13),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L286
L285:
	movq -80(%rbp),%rax
	movl 16(%r13,%rax),%esi
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
	movslq -96(%rbp),%rcx
	leaq (%rcx,%rcx,2),%rcx
	shlq $3,%rcx
	movq -88(%rbp),%rdx
	movq 344(%rdx),%rdx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rsi
	shlq $3,%rsi
	movq 8(%rdx,%rsi),%rax
	movq %rax,-40(%rbp,%rcx)
	movq -88(%rbp),%rdx
	movq 344(%rdx),%rax
	movq 16(%rsi,%rax),%rax
	movq %rax,-32(%rbp,%rcx)
	movq -80(%rbp),%rax
	movl 8(%rax,%r13),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -40(%rbp,%rcx),%rsi
	call _normalize_con
	jmp L287
L293:
	movl $1,-68(%rbp)
	jmp L287
L286:
	movslq -96(%rbp),%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq -80(%rbp),%rax
	movq 24(%r13,%rax),%rax
	movq %rax,-40(%rbp,%rcx)
	movq -80(%rbp),%rax
	movq 32(%r13,%rax),%rax
	movq %rax,-32(%rbp,%rcx)
L287:
	incl %r14d
	incl -96(%rbp)
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
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%r12d
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
	movq -64(%rbp),%rax
	movq %rax,-104(%rbp)
	movq -56(%rbp),%r15
	jmp L300
L304:
	movq -32(%rbp),%rax
	cmpq -8(%rbp),%rax
	jnz L300
L307:
	movq $0,-8(%rbp)
	movq $0,-32(%rbp)
L300:
	cmpq $0,16(%r15)
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
	movq -104(%rbp),%rax
	cmpq $0,16(%rax)
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
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	movq 8(%r15),%rcx
	xorq %rax,%rcx
	jmp L589
L420:
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	movq 8(%r15),%rcx
	orq %rax,%rcx
	jmp L589
L412:
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	movq 8(%r15),%rcx
	andq %rax,%rcx
	jmp L589
L404:
	movq -104(%rbp),%rax
	movq 8(%rax),%rdx
	movq 8(%r15),%rcx
	shlq %cl,%rdx
	jmp L597
L396:
	testq $342,%r12
	jz L400
L399:
	movq -104(%rbp),%rax
	movq 8(%rax),%rdx
	movq 8(%r15),%rcx
	sarq %cl,%rdx
	jmp L597
L400:
	movq -104(%rbp),%rax
	movq 8(%rax),%rdx
	movq 8(%r15),%rcx
	shrq %cl,%rdx
	jmp L597
L435:
	movq 8(%r15),%rcx
	testq %rcx,%rcx
	jz L485
L440:
	testq $342,%r12
	jz L444
L443:
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	cqto 
	idivq %rcx
	jmp L597
L444:
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	xorl %edx,%edx
	divq %rcx
L597:
	movq -104(%rbp),%rax
	movq %rdx,8(%rax)
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
	movq %r15,%rdx
	movq -104(%rbp),%rsi
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
	cmpq $0,8(%r15)
	jz L485
L453:
	testq $7168,%r12
	jz L460
L459:
	movq -104(%rbp),%rax
	movsd 8(%rax),%xmm0
	divsd 8(%r15),%xmm0
	jmp L587
L460:
	testq $342,%r12
	jz L463
L462:
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	cqto 
	idivq 8(%r15)
	jmp L586
L463:
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	xorl %edx,%edx
	divq 8(%r15)
L586:
	movq -104(%rbp),%rcx
	movq %rax,8(%rcx)
	jmp L277
L385:
	testq $7168,%r12
	jz L389
L388:
	movq -104(%rbp),%rax
	movsd 8(%rax),%xmm1
	movsd 8(%r15),%xmm0
	jmp L588
L389:
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	movq 8(%r15),%rcx
	imulq %rax,%rcx
	jmp L589
L475:
	testq $768,%r12
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	jz L479
L478:
	bsrq %rax,%rcx
	jmp L596
L479:
	bsrl %eax,%ecx
	jmp L596
L467:
	testq $768,%r12
	movq -104(%rbp),%rax
	movq 8(%rax),%rax
	jz L471
L470:
	bsfq %rax,%rcx
	jmp L596
L471:
	bsfl %eax,%ecx
L596:
	movslq %ecx,%rcx
	jmp L589
L380:
	movq -104(%rbp),%rax
	notq 8(%rax)
	jmp L277
L372:
	testq $7168,%r12
	jz L376
L375:
	movq -104(%rbp),%rax
	movsd 8(%rax),%xmm1
	movsd L582(%rip),%xmm0
L588:
	mulsd %xmm1,%xmm0
	jmp L587
L376:
	movq -104(%rbp),%rax
	negq 8(%rax)
	jmp L277
L355:
	movq -80(%rbp),%rax
	movl 8(%rax),%edi
	shll $10,%edi
	shrl $15,%edi
	movq -104(%rbp),%rdx
	cmpq $0,16(%rdx)
	setz %cl
	movzbl %cl,%ecx
	movq -104(%rbp),%rdx
	addq $8,%rdx
	movq %r12,%rsi
	call _cast_con
	testl %eax,%eax
	jnz L277
	jz L485
L345:
	testq $7168,%r12
	jz L349
L348:
	movq -104(%rbp),%rax
	movsd 8(%rax),%xmm0
	subsd 8(%r15),%xmm0
	jmp L587
L349:
	movq -104(%rbp),%rax
	movq 8(%rax),%rcx
	subq 8(%r15),%rcx
	jmp L589
L334:
	testq $7168,%r12
	jz L338
L337:
	movq -104(%rbp),%rax
	movsd 8(%rax),%xmm1
	movsd 8(%r15),%xmm0
	addsd %xmm1,%xmm0
L587:
	movq -104(%rbp),%rax
	movsd %xmm0,8(%rax)
	jmp L277
L338:
	movq -104(%rbp),%rax
	movq 8(%rax),%rcx
	addq 8(%r15),%rcx
L589:
	movq -104(%rbp),%rax
	movq %rcx,8(%rax)
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
	movq -104(%rbp),%rsi
	addq $8,%rsi
	call _normalize_con
	movl $1,%edx
	movl -92(%rbp),%esi
	movq -88(%rbp),%rdi
	call _lookup_constant
	movq -88(%rbp),%rcx
	movq 344(%rcx),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rdi
	shlq $3,%rdi
	movq -104(%rbp),%rsi
	movq 8(%rsi),%rax
	movq %rax,8(%rcx,%rdi)
	movq -104(%rbp),%rsi
	movq 16(%rsi),%rdx
	movq -88(%rbp),%rcx
	movq 344(%rcx),%rax
	movq %rdx,16(%rdi,%rax)
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
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%r12d
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
L599:
	pushq %rbx
L600:
	xorl %ebx,%ebx
L602:
	movl 4(%rdi),%eax
	testl $4,%eax
	jnz L603
L607:
	orl $4,%eax
	movl %eax,4(%rdi)
	incl %ebx
	call _unconditional_succ
	movq %rax,%rdi
	testq %rax,%rax
	jnz L602
L603:
	movl %ebx,%eax
L601:
	popq %rbx
	ret 


_mark_all:
L610:
	pushq %rbx
	pushq %r12
	pushq %r13
L611:
	movq %rdi,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
L613:
	cmpl 60(%r13),%ebx
	jge L616
L614:
	movq 64(%r13),%rcx
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rdi
	call _mark
	addl %eax,%r12d
	incl %ebx
	jmp L613
L616:
	movl %r12d,%eax
L612:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_meet0:
L618:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L619:
	movq %rdi,%r15
	leaq 312(%r15),%rdi
	call _init_state
	movl $0,-4(%rbp)
L621:
	movl -4(%rbp),%eax
	cmpl 36(%r15),%eax
	jge L620
L622:
	movq 40(%r15),%rcx
	movslq -4(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-24(%rbp)
	movl $0,-32(%rbp)
	xorl %r14d,%r14d
	movl 316(%r15),%eax
	movl %eax,-28(%rbp)
	xorl %esi,%esi
L628:
	cmpl %esi,-28(%rbp)
	jg L629
L632:
	cmpl 340(%r15),%r14d
	jge L661
L635:
	movq -24(%rbp),%rcx
	movl -32(%rbp),%eax
	cmpl 388(%rcx),%eax
	jl L636
L661:
	cmpl 340(%r15),%r14d
	jl L662
L667:
	movq -24(%rbp),%rcx
	movl -32(%rbp),%eax
	cmpl 388(%rcx),%eax
	jge L669
L668:
	movq -24(%rbp),%rax
	movq 392(%rax),%rcx
	movslq -32(%rbp),%rax
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
	jnz L672
L673:
	movl 340(%r15),%esi
	leal 1(%rsi),%eax
	cmpl 336(%r15),%eax
	jge L677
L676:
	movl %eax,340(%r15)
	jmp L678
L677:
	movl $24,%ecx
	movl $1,%edx
	leaq 336(%r15),%rdi
	call _vector_insert
L678:
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
L672:
	incl -32(%rbp)
	jmp L667
L669:
	incl -4(%rbp)
	jmp L621
L662:
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
	jz L665
L664:
	movl $24,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 336(%r15),%rdi
	call _vector_delete
	jmp L661
L665:
	incl %r14d
	jmp L661
L636:
	movq 344(%r15),%rdi
	movslq %r14d,%rax
	leaq (%rax,%rax,2),%r13
	shlq $3,%r13
	movl (%rdi,%r13),%esi
	movq -24(%rbp),%rax
	movq 392(%rax),%rdx
	movslq -32(%rbp),%rax
	leaq (%rax,%rax,2),%r12
	shlq $3,%r12
	movl (%rdx,%r12),%eax
	movq 320(%r15),%r9
	movl %esi,%ecx
	andl $1073725440,%ecx
	movl %ecx,%r8d
	sarl $20,%r8d
	movslq %r8d,%r8
	movq %r8,-16(%rbp)
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%ebx
	shlq %cl,%rbx
	movq -16(%rbp),%r8
	testq %rbx,(%r9,%r8,8)
	jz L640
L639:
	movl $24,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 336(%r15),%rdi
	call _vector_delete
	jmp L632
L640:
	movl %eax,%ecx
	andl $1073725440,%ecx
	movl %ecx,%r8d
	sarl $20,%r8d
	movslq %r8d,%r8
	movq (%r9,%r8,8),%r9
	sarl $14,%ecx
	andb $63,%cl
	movl $1,%r8d
	shlq %cl,%r8
	testq %r9,%r8
	jnz L679
L643:
	cmpl %eax,%esi
	jb L645
	jz L649
L648:
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
	jmp L680
L649:
	movq 8(%rdi,%r13),%rax
	cmpq 8(%rdx,%r12),%rax
	jnz L656
L654:
	movq 16(%rdi,%r13),%rax
	cmpq 16(%rdx,%r12),%rax
	jnz L656
L680:
	incl %r14d
	jmp L679
L656:
	movl $24,%ecx
	movl $1,%edx
	movl %r14d,%esi
	leaq 336(%r15),%rdi
	call _vector_delete
	movq 320(%r15),%rcx
	movq -16(%rbp),%rax
	orq %rbx,(%rcx,%rax,8)
L679:
	incl -32(%rbp)
	jmp L632
L645:
	incl %r14d
	jmp L632
L629:
	movq -24(%rbp),%rax
	movq 368(%rax),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 320(%r15),%rax
	orq %rcx,(%rax,%rdx,8)
	incl %esi
	jmp L628
L620:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_prop0:
L681:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L682:
	movq %rdi,%r12
	movl $1,%ebx
	testl $4,4(%r12)
	movl $0,%r13d
	jz L684
L686:
	movq %r12,%rdi
	call _meet0
L688:
	cmpl 12(%r12),%r13d
	jge L691
L689:
	movl %r13d,%esi
	movq %r12,%rdi
	call _eval
	incl %r13d
	jmp L688
L691:
	movl 316(%r12),%edi
	xorl %esi,%esi
L695:
	cmpl %esi,%edi
	jle L698
L696:
	movq 320(%r12),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 368(%r12),%rax
	cmpq (%rax,%rdx,8),%rcx
	jnz L721
L701:
	incl %esi
	jmp L695
L698:
	movl 340(%r12),%eax
	cmpl 388(%r12),%eax
	jnz L721
L707:
	xorl %edi,%edi
L709:
	cmpl 340(%r12),%edi
	jge L712
L710:
	movq 344(%r12),%rsi
	movslq %edi,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $3,%rdx
	movq 8(%rsi,%rdx),%rax
	movq 392(%r12),%rcx
	cmpq 8(%rdx,%rcx),%rax
	jnz L721
L716:
	movq 16(%rsi,%rdx),%rax
	cmpq 16(%rdx,%rcx),%rax
	jnz L721
L717:
	incl %edi
	jmp L709
L712:
	xorl %ebx,%ebx
L721:
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
	jmp L683
L684:
	movl %r13d,%eax
L683:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_fold0:
L725:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L726:
	movq %rdi,%r15
	movq %r15,%rdi
	call _meet0
	xorl %r14d,%r14d
L728:
	cmpl 12(%r15),%r14d
	jge L734
L732:
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r12
	testq %r12,%r12
	jz L734
L733:
	xorl %ebx,%ebx
L736:
	cmpl 340(%r15),%ebx
	jge L739
L737:
	movq 344(%r15),%rcx
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movl (%rcx,%rax),%esi
	movq 16(%rcx,%rax),%rdx
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	movq %r12,%rdi
	call _insn_substitute_con
	addq $8,%rsp
	testl %eax,%eax
	jz L742
L740:
	orl $26,_opt_request(%rip)
L742:
	incl %ebx
	jmp L736
L739:
	movl %r14d,%esi
	movq %r15,%rdi
	call _eval
	cmpl $0,_tmp_regs(%rip)
	jl L747
L746:
	movl $0,_tmp_regs+4(%rip)
	jmp L748
L747:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L748:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r12,%rdi
	call _insn_defs
	cmpl $1,_tmp_regs+4(%rip)
	jnz L730
L751:
	movq _tmp_regs+8(%rip),%rax
	movl (%rax),%eax
	movl %eax,-4(%rbp)
	xorl %edx,%edx
	movl -4(%rbp),%esi
	movq %r15,%rdi
	call _lookup_constant
	movl %eax,%ebx
	cmpl $-1,%ebx
	jz L730
L755:
	testl $16777216,(%r12)
	jnz L730
L760:
	movq %r12,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jnz L730
L762:
	testl $8388608,(%r12)
	jnz L730
L768:
	testl $1,4(%r12)
	jnz L730
L770:
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r13
	movq 16(%r15),%rax
	movslq %r14d,%r12
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
	movl -4(%rbp),%esi
	movq %r13,%rdi
	call _insn_substitute_con
	addq $8,%rsp
	movq 16(%r15),%rax
	movq %r13,(%rax,%r12,8)
	orl $26,_opt_request(%rip)
L730:
	incl %r14d
	jmp L728
L734:
	movq 320(%r15),%rax
	movq (%rax),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	setnz %bl
	movzbl %bl,%ebx
	movq %r15,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L775
L780:
	testl %ebx,%ebx
	jnz L775
L781:
	movq %r15,%rdi
	call _get_ccs
	testl %eax,%eax
	jz L775
L777:
	movq %r15,%rdi
	call _get_ccs
	movl $1,%edx
	movl %eax,%esi
	movq %r15,%rdi
	call _predict_succ
	orl $32,_opt_request(%rip)
L775:
	testl $1,4(%r15)
	jz L727
L795:
	movl 80(%r15),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L727
L796:
	xorl %edx,%edx
	movl 88(%r15),%esi
	movq %r15,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L727
L792:
	movq 344(%r15),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jnz L727
L788:
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	movl $1,%esi
	movq %r15,%rdi
	call _predict_switch_succ
	addq $8,%rsp
	orl $32,_opt_request(%rip)
L727:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_project0:
L799:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L800:
	movq %rdi,%r12
	movq %r12,%rdi
	call _unconditional_succ
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L801
L817:
	cmpl $1,12(%rbx)
	jnz L801
L813:
	movq 16(%rbx),%rax
	leaq -4(%rbp),%rsi
	movq (%rax),%rdi
	call _insn_is_cmp_con
	testl %eax,%eax
	jz L801
L809:
	xorl %edx,%edx
	movl -4(%rbp),%esi
	movq %r12,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L801
L805:
	movq 344(%r12),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jnz L801
L802:
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
L801:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_opt_lir_fold:
L821:
	pushq %rbx
	pushq %r12
L822:
	movq _all_blocks(%rip),%rbx
L824:
	testq %rbx,%rbx
	jz L827
L825:
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
	jmp L824
L827:
	xorl %edi,%edi
	call _sequence_blocks
	movq _entry_block(%rip),%rdi
	call _mark
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
L849:
	movl $_prop0,%edi
	call _iterate_blocks
	xorl %ebx,%ebx
	movq _all_blocks(%rip),%r12
L852:
	testq %r12,%r12
	jz L855
L853:
	testl $4,4(%r12)
	jz L854
L858:
	movq %r12,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L861
L860:
	movq 320(%r12),%rax
	movq (%rax),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	jnz L906
L866:
	movq %r12,%rdi
	call _get_ccs
	testl %eax,%eax
	jz L906
L868:
	movq %r12,%rdi
	call _get_ccs
	xorl %edx,%edx
	movl %eax,%esi
	movq %r12,%rdi
	call _predict_succ
	jmp L907
L861:
	testl $1,4(%r12)
	jz L854
L873:
	movl 80(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L854
L874:
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
	jnz L906
L884:
	xorl %edx,%edx
	movq %r12,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L906
L886:
	movq 344(%r12),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jz L882
L906:
	movq %r12,%rdi
	call _mark_all
	jmp L905
L882:
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	xorl %esi,%esi
	movq %r12,%rdi
	call _predict_switch_succ
	addq $8,%rsp
L907:
	movq %rax,%rdi
	call _mark
L905:
	addl %eax,%ebx
L854:
	movq 112(%r12),%r12
	jmp L852
L855:
	testl %ebx,%ebx
	jnz L849
L850:
	movq _all_blocks(%rip),%rbx
L888:
	testq %rbx,%rbx
	jz L891
L889:
	testl $4,4(%rbx)
	jz L894
L892:
	movq %rbx,%rdi
	call _fold0
L894:
	movq 112(%rbx),%rbx
	jmp L888
L891:
	movq _all_blocks(%rip),%rbx
L895:
	testq %rbx,%rbx
	jz L902
L896:
	testl $4,4(%rbx)
	jz L901
L899:
	movq %rbx,%rdi
	call _project0
L901:
	movq 112(%rbx),%rbx
	jmp L895
L902:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L823:
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
