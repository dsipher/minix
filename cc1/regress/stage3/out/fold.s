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
	pushq %r12
L161:
	movq %rdi,%r12
	movl _nr_assigned_regs(%rip),%ebx
	addl $63,%ebx
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %ebx,%edx
	sarl %cl,%edx
	cmpl (%r12),%edx
	jg L170
L169:
	movl %edx,4(%r12)
	jmp L171
L170:
	movl 4(%r12),%esi
	subl %esi,%edx
	movl $8,%ecx
	movq %r12,%rdi
	call _vector_insert
L171:
	movslq 4(%r12),%rdx
	shlq $3,%rdx
	xorl %esi,%esi
	movq 8(%r12),%rdi
	call ___builtin_memset
	cmpl $0,24(%r12)
	jl L176
L175:
	movl $0,28(%r12)
	jmp L162
L176:
	movl 28(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $24,%ecx
	leaq 24(%r12),%rdi
	call _vector_insert
L162:
	popq %r12
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
	jmp L181
L182:
	movq 344(%r13),%rcx
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
L181:
	cmpl 340(%r13),%ebx
	jl L182
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
	movl %ebx,%eax
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
	movq 320(%rbx),%rbx
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl $32,%edx
	sarl %cl,%edx
	movq $-4294967297,%rax
	andq (%rbx,%rdx,8),%rax
	movq %rax,(%rbx,%rdx,8)
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
	subq $136,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L220:
	movq %rdi,-112(%rbp)
	movq -112(%rbp),%rax
	movq 16(%rax),%rax
	movslq %esi,%rsi
	movq (%rax,%rsi,8),%rcx
	movl (%rcx),%eax
	movl %eax,-132(%rbp)
	movq %rcx,-104(%rbp)
	leaq -48(%rbp),%r13
	movq %r13,-56(%rbp)
	leaq -24(%rbp),%r12
	movq %r12,-64(%rbp)
	cmpl $603979787,-132(%rbp)
	jnz L227
L233:
	movq -104(%rbp),%rax
	movl 8(%rax),%ecx
	movl %ecx,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L227
L234:
	movq -104(%rbp),%rax
	movl 40(%rax),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L227
L230:
	movq -104(%rbp),%rax
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
	cmpl $0,-132(%rbp)
	jz L221
L544:
	cmpl $41943048,-132(%rbp)
	jz L221
L545:
	cmpl $58720258,-132(%rbp)
	jz L221
L546:
	cmpl $553648133,-132(%rbp)
	jz L221
L547:
	cmpl $822083623,-132(%rbp)
	jz L221
L548:
	cmpl $855638054,-132(%rbp)
	jz L221
L549:
	cmpl $-1870659577,-132(%rbp)
	jz L485
L552:
	cmpl $-1610612733,-132(%rbp)
	jz L485
L553:
	cmpl $-1577058300,-132(%rbp)
	jz L485
L554:
	cmpl $-1493172218,-132(%rbp)
	jz L485
L555:
	cmpl $8388609,-132(%rbp)
	jz L485
L556:
	movl -132(%rbp),%eax
	cmpb $24,%al
	jb L266
L264:
	cmpb $35,%al
	ja L266
L265:
	movq -112(%rbp),%rax
	movq 320(%rax),%rax
	movq %rax,-80(%rbp)
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl $32,%edx
	sarl %cl,%edx
	movq -80(%rbp),%rax
	movq (%rax,%rdx,8),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	jnz L485
L270:
	movq -112(%rbp),%rdi
	call _get_ccs
	testl %eax,%eax
	jz L509
L274:
	movl -132(%rbp),%ebx
	subl $2550136856,%ebx
	movq $0,-32(%rbp)
	movq -112(%rbp),%rdi
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
	movl $0,-116(%rbp)
	movl $0,-124(%rbp)
	movl $0,-68(%rbp)
	testl $2147483648,-132(%rbp)
	movl $1,%eax
	movl -124(%rbp),%ecx
	cmovnzl %eax,%ecx
	movl %ecx,-124(%rbp)
	shlq $5,%rcx
	movq -104(%rbp),%rax
	movl 8(%rax,%rcx),%r14d
	shll $10,%r14d
	shrl $15,%r14d
	jmp L282
L283:
	movl -124(%rbp),%ebx
	shlq $5,%rbx
	movq -104(%rbp),%rax
	movl 8(%rax,%rbx),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L286
L285:
	movq -104(%rbp),%rax
	movl 16(%rbx,%rax),%eax
	movl %eax,-128(%rbp)
	movq -112(%rbp),%rax
	movq 320(%rax),%rax
	movq %rax,-96(%rbp)
	movl -128(%rbp),%r15d
	andl $1073725440,%r15d
	sarl $14,%r15d
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %r15d,%edx
	sarl %cl,%edx
	movq -96(%rbp),%rax
	movq (%rax,%rdx,8),%rdx
	movb %r15b,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L485
L290:
	xorl %edx,%edx
	movl -128(%rbp),%esi
	movq -112(%rbp),%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L293
L292:
	movl -116(%rbp),%ecx
	leaq (%rcx,%rcx,2),%rcx
	shlq $3,%rcx
	movq -112(%rbp),%rdx
	movq 344(%rdx),%rsi
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $3,%rdx
	movq 8(%rsi,%rdx),%rax
	movq %rax,-40(%rbp,%rcx)
	movq -112(%rbp),%rax
	movq 344(%rax),%rax
	movq 16(%rdx,%rax),%rax
	movq %rax,-32(%rbp,%rcx)
	movq -104(%rbp),%rax
	movl 8(%rax,%rbx),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -40(%rbp,%rcx),%rsi
	call _normalize_con
	jmp L287
L293:
	movl $1,-68(%rbp)
	jmp L287
L286:
	movl -116(%rbp),%eax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq -104(%rbp),%rax
	movq 24(%rbx,%rax),%rax
	movq %rax,-40(%rbp,%rcx)
	movq -104(%rbp),%rax
	movq 32(%rbx,%rax),%rax
	movq %rax,-32(%rbp,%rcx)
L287:
	incl -124(%rbp)
	incl -116(%rbp)
L282:
	movl -132(%rbp),%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl %eax,-124(%rbp)
	jl L283
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
	movq -104(%rbp),%rdi
	call _insn_defs
	xorl %r14d,%r14d
L515:
	cmpl _tmp_regs+4(%rip),%r14d
	jge L221
L519:
	movq _tmp_regs+8(%rip),%rax
	movl (%rax,%r14,4),%ebx
	testl %ebx,%ebx
	jz L221
L520:
	movl %ebx,%esi
	movq -112(%rbp),%rdi
	call _remove_constant
	andl $1073725440,%ebx
	sarl $14,%ebx
	movb %bl,%cl
	movl $1,%r13d
	shlq %cl,%r13
	notq %r13
	movq -112(%rbp),%rax
	movq 320(%rax),%r12
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	sarl %cl,%ebx
	andq %r13,(%r12,%rbx,8)
	incl %r14d
	jmp L515
L297:
	cmpl $603979787,-132(%rbp)
	jz L304
L559:
	cmpl $-1342177265,-132(%rbp)
	jz L304
L560:
	cmpl $-1342177266,-132(%rbp)
	jnz L300
L312:
	cmpq $0,-8(%rbp)
	jz L300
L318:
	cmpq $0,-32(%rbp)
	jz L300
L319:
	movq -64(%rbp),%r13
	movq -56(%rbp),%r12
	jmp L300
L304:
	movq -32(%rbp),%rax
	cmpq -8(%rbp),%rax
	jnz L300
L307:
	movq $0,-8(%rbp)
	movq $0,-32(%rbp)
L300:
	cmpq $0,16(%r12)
	jnz L485
L328:
	cmpl $-1342177266,-132(%rbp)
	jz L334
L564:
	cmpl $-1342177265,-132(%rbp)
	jz L345
L565:
	cmpl $-1610612726,-132(%rbp)
	jz L355
L566:
	cmpl $-1610612727,-132(%rbp)
	jz L277
L567:
	cmpq $0,16(%r13)
	jnz L485
L364:
	cmpl $-1275068398,-132(%rbp)
	jl L570
L572:
	cmpl $-1275068393,-132(%rbp)
	jg L570
L569:
	movl -132(%rbp),%eax
	addl $1275068398,%eax
	movzwl L583(,%rax,2),%eax
	addl $_eval,%eax
	jmp *%rax
L428:
	movq 8(%r13),%rcx
	movq 8(%r12),%rax
	xorq %rcx,%rax
	jmp L591
L420:
	movq 8(%r13),%rcx
	movq 8(%r12),%rax
	orq %rcx,%rax
	jmp L591
L412:
	movq 8(%r13),%rcx
	movq 8(%r12),%rax
	andq %rcx,%rax
	jmp L591
L404:
	movq 8(%r13),%rax
	movq 8(%r12),%rcx
	shlq %cl,%rax
	jmp L591
L396:
	testq $342,%r14
	jz L400
L399:
	movq 8(%r13),%rax
	movq 8(%r12),%rcx
	sarq %cl,%rax
	jmp L591
L400:
	movq 8(%r13),%rax
	movq 8(%r12),%rcx
	shrq %cl,%rax
	jmp L591
L435:
	movq 8(%r12),%rcx
	testq %rcx,%rcx
	jz L485
L440:
	testq $342,%r14
	jz L444
L443:
	movq 8(%r13),%rax
	cqto 
	idivq %rcx
	jmp L585
L444:
	movq 8(%r13),%rax
	xorl %edx,%edx
	divq %rcx
L585:
	movq %rdx,8(%r13)
	jmp L277
L570:
	cmpl $-1610612724,-132(%rbp)
	jz L372
L574:
	cmpl $-1543503859,-132(%rbp)
	jz L380
L575:
	cmpl $-1543503836,-132(%rbp)
	jz L467
L576:
	cmpl $-1543503835,-132(%rbp)
	jz L475
L577:
	cmpl $-1342177264,-132(%rbp)
	jz L385
L578:
	cmpl $-1342177263,-132(%rbp)
	jz L447
L579:
	cmpl $603979787,-132(%rbp)
	jnz L485
L369:
	movq %r12,%rdx
	movq %r13,%rsi
	movq %r14,%rdi
	call _cmp_cons
	movl %eax,%esi
L584:
	movq -112(%rbp),%rdi
	call _set_ccs
	jmp L221
L447:
	testq $1022,%r14
	jz L453
L451:
	cmpq $0,8(%r12)
	jz L485
L453:
	testq $7168,%r14
	jz L460
L459:
	movsd 8(%r13),%xmm0
	divsd 8(%r12),%xmm0
	jmp L589
L460:
	testq $342,%r14
	jz L463
L462:
	movq 8(%r13),%rax
	cqto 
	idivq 8(%r12)
	jmp L591
L463:
	movq 8(%r13),%rax
	xorl %edx,%edx
	divq 8(%r12)
	jmp L591
L385:
	testq $7168,%r14
	jz L389
L388:
	movsd 8(%r13),%xmm1
	movsd 8(%r12),%xmm0
	jmp L590
L389:
	movq 8(%r13),%rcx
	movq 8(%r12),%rax
	imulq %rcx,%rax
	jmp L591
L475:
	testq $768,%r14
	movq 8(%r13),%rdi
	jz L479
L478:
	call ___builtin_clzl
	xorl $63,%eax
	jmp L588
L479:
	call ___builtin_clz
	xorl $31,%eax
	jmp L588
L467:
	testq $768,%r14
	movq 8(%r13),%rdi
	jz L471
L470:
	call ___builtin_ctzl
	jmp L588
L471:
	call ___builtin_ctz
L588:
	movslq %eax,%rax
	jmp L591
L380:
	notq 8(%r13)
	jmp L277
L372:
	testq $7168,%r14
	jz L376
L375:
	movsd 8(%r13),%xmm1
	movsd L582(%rip),%xmm0
L590:
	mulsd %xmm1,%xmm0
	jmp L589
L376:
	negq 8(%r13)
	jmp L277
L355:
	movq -104(%rbp),%rax
	movl 8(%rax),%edi
	shll $10,%edi
	shrl $15,%edi
	cmpq $0,16(%r13)
	setz %al
	movzbl %al,%ecx
	leaq 8(%r13),%rdx
	movq %r14,%rsi
	call _cast_con
	testl %eax,%eax
	jnz L277
	jz L485
L345:
	testq $7168,%r14
	jz L349
L348:
	movsd 8(%r13),%xmm0
	subsd 8(%r12),%xmm0
	jmp L589
L349:
	movq 8(%r13),%rax
	subq 8(%r12),%rax
	jmp L591
L334:
	testq $7168,%r14
	jz L338
L337:
	movsd 8(%r13),%xmm1
	movsd 8(%r12),%xmm0
	addsd %xmm1,%xmm0
L589:
	movsd %xmm0,8(%r13)
	jmp L277
L338:
	movq 8(%r13),%rax
	addq 8(%r12),%rax
L591:
	movq %rax,8(%r13)
L277:
	movq -104(%rbp),%rax
	movl 16(%rax),%eax
	movl %eax,-120(%rbp)
	movq _reg_to_symbol+8(%rip),%rcx
	movl -120(%rbp),%eax
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
	movl -120(%rbp),%esi
	movq -112(%rbp),%rdi
	call _lookup_constant
	movq -112(%rbp),%rcx
	movq 344(%rcx),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $3,%rdx
	movq 8(%r13),%rax
	movq %rax,8(%rcx,%rdx)
	movq 16(%r13),%rcx
	movq -112(%rbp),%rax
	movq 344(%rax),%rax
	movq %rcx,16(%rdx,%rax)
	movq -104(%rbp),%rax
	testl $67108864,(%rax)
	jnz L534
L533:
	movq -104(%rbp),%rdi
	call _insn_defs_cc0
	testl %eax,%eax
	jz L221
L534:
	movl $1074266112,%esi
	movq -112(%rbp),%rdi
	call _remove_constant
	movq -112(%rbp),%rax
	movq 320(%rax),%rax
	movq %rax,-88(%rbp)
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl $32,%edx
	sarl %cl,%edx
	movq $4294967296,%rcx
	movq -88(%rbp),%rax
	orq %rcx,(%rax,%rdx,8)
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
	movq -104(%rbp),%rdi
	call _insn_defs
	xorl %r14d,%r14d
	jmp L491
L495:
	movq _tmp_regs+8(%rip),%rax
	movl (%rax,%r14,4),%ebx
	testl %ebx,%ebx
	jz L221
L496:
	movl %ebx,%esi
	movq -112(%rbp),%rdi
	call _remove_constant
	andl $1073725440,%ebx
	sarl $14,%ebx
	movb %bl,%cl
	movl $1,%r13d
	shlq %cl,%r13
	movq -112(%rbp),%rax
	movq 320(%rax),%r12
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	sarl %cl,%ebx
	orq %r13,(%r12,%rbx,8)
	incl %r14d
L491:
	cmpl _tmp_regs+4(%rip),%r14d
	jl L495
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
	jmp L613
L614:
	movq 64(%r13),%rcx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rdi
	call _mark
	addl %eax,%r12d
	incl %ebx
L613:
	cmpl 60(%r13),%ebx
	jl L614
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
	subq $104,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L619:
	movq %rdi,%r12
	leaq 312(%r12),%rdi
	call _init_state
	movl $0,-4(%rbp)
L621:
	movl -4(%rbp),%eax
	cmpl 36(%r12),%eax
	jge L620
L622:
	movq 40(%r12),%rcx
	movl -4(%rbp),%eax
	movq (%rcx,%rax,8),%rax
	movq %rax,-40(%rbp)
	xorl %eax,%eax
	movq %rax,-88(%rbp)
	xorl %ebx,%ebx
	movl 316(%r12),%eax
	movl %eax,-76(%rbp)
	xorl %edx,%edx
L628:
	cmpl %edx,-76(%rbp)
	jg L629
L632:
	cmpl 340(%r12),%ebx
	jge L661
L635:
	movq -40(%rbp),%rcx
	movq -88(%rbp),%rax
	cmpl 388(%rcx),%eax
	jl L636
L661:
	cmpl 340(%r12),%ebx
	jl L662
	jge L667
L668:
	movq -40(%rbp),%rax
	movq 392(%rax),%rcx
	movq -88(%rbp),%rax
	movl %eax,%eax
	leaq (%rax,%rax,2),%r13
	shlq $3,%r13
	movl (%rcx,%r13),%ebx
	movq 320(%r12),%rax
	movq %rax,-72(%rbp)
	andl $1073725440,%ebx
	sarl $14,%ebx
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %ebx,%edx
	sarl %cl,%edx
	movq -72(%rbp),%rax
	movq (%rax,%rdx,8),%rdx
	movb %bl,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L672
L673:
	movl 340(%r12),%esi
	leal 1(%rsi),%eax
	cmpl 336(%r12),%eax
	jge L677
L676:
	movl %eax,340(%r12)
	jmp L678
L677:
	movl $24,%ecx
	movl $1,%edx
	leaq 336(%r12),%rdi
	call _vector_insert
L678:
	movq 344(%r12),%rsi
	movl 340(%r12),%eax
	decl %eax
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $3,%rdx
	movq -40(%rbp),%rax
	movq 392(%rax),%rcx
	movq (%r13,%rcx),%rax
	movq %rax,(%rsi,%rdx)
	movq 8(%r13,%rcx),%rax
	movq %rax,8(%rsi,%rdx)
	movq 16(%r13,%rcx),%rax
	movq %rax,16(%rsi,%rdx)
L672:
	movq -88(%rbp),%rax
	incl %eax
	movq %rax,-88(%rbp)
L667:
	movq -40(%rbp),%rcx
	movq -88(%rbp),%rax
	cmpl 388(%rcx),%eax
	jl L668
L669:
	incl -4(%rbp)
	jmp L621
L662:
	movq 344(%r12),%rcx
	movl %ebx,%eax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movl (%rcx,%rax),%r13d
	movq 320(%r12),%rax
	movq %rax,-64(%rbp)
	andl $1073725440,%r13d
	sarl $14,%r13d
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %r13d,%edx
	sarl %cl,%edx
	movq -64(%rbp),%rax
	movq (%rax,%rdx,8),%rdx
	movb %r13b,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jz L665
L664:
	movl $24,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 336(%r12),%rdi
	call _vector_delete
	jmp L661
L665:
	incl %ebx
	jmp L661
L636:
	movq 344(%r12),%rcx
	movl %ebx,%ebx
	leaq (%rbx,%rbx,2),%rax
	shlq $3,%rax
	movl (%rcx,%rax),%ecx
	movq %rax,-104(%rbp)
	movl %ecx,-28(%rbp)
	movq -40(%rbp),%rax
	movq 392(%rax),%rcx
	movq -88(%rbp),%rax
	movl %eax,%eax
	leaq (%rax,%rax,2),%r15
	shlq $3,%r15
	movq %rax,-88(%rbp)
	movl (%rcx,%r15),%eax
	movl %eax,-44(%rbp)
	movq 320(%r12),%rax
	movq %rax,-16(%rbp)
	movl -28(%rbp),%r13d
	andl $1073725440,%r13d
	sarl $14,%r13d
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %r13d,%edx
	sarl %cl,%edx
	movb %r13b,%cl
	movl $1,%eax
	shlq %cl,%rax
	movq %rax,-96(%rbp)
	movq -16(%rbp),%rcx
	movq -96(%rbp),%rax
	testq %rax,(%rcx,%rdx,8)
	jz L640
L639:
	movl $24,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 336(%r12),%rdi
	call _vector_delete
	jmp L632
L640:
	movq 320(%r12),%rax
	movq %rax,-24(%rbp)
	movl -44(%rbp),%r14d
	andl $1073725440,%r14d
	sarl $14,%r14d
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %r14d,%edx
	sarl %cl,%edx
	movq -24(%rbp),%rax
	movq (%rax,%rdx,8),%rdx
	movb %r14b,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L679
L643:
	movl -44(%rbp),%eax
	cmpl %eax,-28(%rbp)
	jb L645
	jz L649
L648:
	movl $24,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 336(%r12),%rdi
	call _vector_insert
	movq 344(%r12),%rsi
	movq -40(%rbp),%rax
	movq 392(%rax),%rdx
	movq (%r15,%rdx),%rcx
	movq -104(%rbp),%rax
	movq %rcx,(%rax,%rsi)
	movq 8(%r15,%rdx),%rcx
	movq -104(%rbp),%rax
	movq %rcx,8(%rax,%rsi)
	movq 16(%r15,%rdx),%rcx
	movq -104(%rbp),%rax
	movq %rcx,16(%rax,%rsi)
	jmp L680
L649:
	movq 344(%r12),%rsi
	movq -104(%rbp),%rax
	movq 8(%rax,%rsi),%rdx
	movq -40(%rbp),%rax
	movq 392(%rax),%rcx
	cmpq 8(%r15,%rcx),%rdx
	jnz L656
L654:
	movq -104(%rbp),%rax
	movq 16(%rax,%rsi),%rax
	cmpq 16(%r15,%rcx),%rax
	jnz L656
L680:
	incl %ebx
	jmp L679
L656:
	movl $24,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 336(%r12),%rdi
	call _vector_delete
	movq 320(%r12),%rax
	movq %rax,-56(%rbp)
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	sarl %cl,%r13d
	movq -56(%rbp),%rcx
	movq -96(%rbp),%rax
	orq %rax,(%rcx,%r13,8)
L679:
	movq -88(%rbp),%rax
	incl %eax
	movq %rax,-88(%rbp)
	jmp L632
L645:
	incl %ebx
	jmp L632
L629:
	movq -40(%rbp),%rax
	movq 368(%rax),%rax
	movq (%rax,%rdx,8),%rcx
	movq 320(%r12),%rax
	orq %rcx,(%rax,%rdx,8)
	incl %edx
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
	jmp L688
L689:
	movl %r13d,%esi
	movq %r12,%rdi
	call _eval
	incl %r13d
L688:
	cmpl 12(%r12),%r13d
	jl L689
L691:
	movl 316(%r12),%esi
	xorl %edx,%edx
	jmp L695
L696:
	movq 320(%r12),%rax
	movq (%rax,%rdx,8),%rcx
	movq 368(%r12),%rax
	cmpq (%rax,%rdx,8),%rcx
	jnz L721
L701:
	incl %edx
L695:
	cmpl %edx,%esi
	jg L696
L698:
	movl 340(%r12),%eax
	cmpl 388(%r12),%eax
	jnz L721
L707:
	xorl %esi,%esi
	jmp L709
L710:
	movq 344(%r12),%rdi
	leaq (%rsi,%rsi,2),%rdx
	shlq $3,%rdx
	movq 8(%rdi,%rdx),%rax
	movq 392(%r12),%rcx
	cmpq 8(%rdx,%rcx),%rax
	jnz L721
L716:
	movq 16(%rdi,%rdx),%rax
	cmpq 16(%rdx,%rcx),%rax
	jnz L721
L717:
	incl %esi
L709:
	cmpl 340(%r12),%esi
	jl L710
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
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L726:
	movq %rdi,%r15
	movq %r15,%rdi
	call _meet0
	xorl %r12d,%r12d
	jmp L728
L732:
	movq 16(%r15),%rcx
	movl %r12d,%eax
	movq (%rcx,%rax,8),%r13
	testq %r13,%r13
	jz L734
L733:
	xorl %ebx,%ebx
L736:
	cmpl 340(%r15),%ebx
	jge L739
L737:
	movq 344(%r15),%rcx
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
	jz L742
L740:
	orl $26,_opt_request(%rip)
L742:
	incl %ebx
	jmp L736
L739:
	movl %r12d,%esi
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
	movq %r13,%rdi
	call _insn_defs
	cmpl $1,_tmp_regs+4(%rip)
	jnz L730
L751:
	movq _tmp_regs+8(%rip),%rax
	movl (%rax),%r14d
	xorl %edx,%edx
	movl %r14d,%esi
	movq %r15,%rdi
	call _lookup_constant
	movl %eax,%ebx
	cmpl $-1,%ebx
	jz L730
L755:
	testl $16777216,(%r13)
	jnz L730
L760:
	movq %r13,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jnz L730
L762:
	testl $8388608,(%r13)
	jnz L730
L768:
	testl $1,4(%r13)
	jnz L730
L770:
	xorl %esi,%esi
	movl $-1610612727,%edi
	call _new_insn
	movq %rax,%r13
	movq 16(%r15),%rax
	movl %r12d,%r12d
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
L730:
	incl %r12d
L728:
	cmpl 12(%r15),%r12d
	jl L732
L734:
	movq 320(%r15),%rbx
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl $32,%eax
	sarl %cl,%eax
	movq (%rbx,%rax,8),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	setnz %al
	movzbl %al,%ebx
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
	pushq %r13
	pushq %r14
	pushq %r15
L822:
	movq _all_blocks(%rip),%rbx
	jmp L824
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
L824:
	testq %rbx,%rbx
	jnz L825
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
	xorl %r14d,%r14d
	movq _all_blocks(%rip),%r15
	jmp L852
L853:
	testl $4,4(%r15)
	jz L854
L858:
	movq %r15,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L861
L860:
	movq 320(%r15),%rbx
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl $32,%eax
	sarl %cl,%eax
	movq (%rbx,%rax,8),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	jnz L906
L866:
	movq %r15,%rdi
	call _get_ccs
	testl %eax,%eax
	jz L906
L868:
	movq %r15,%rdi
	call _get_ccs
	xorl %edx,%edx
	movl %eax,%esi
	movq %r15,%rdi
	call _predict_succ
	jmp L907
L861:
	testl $1,4(%r15)
	jz L854
L873:
	movl 80(%r15),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L854
L874:
	movl 88(%r15),%r13d
	movq 320(%r15),%r12
	movl %r13d,%ebx
	andl $1073725440,%ebx
	sarl $14,%ebx
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %ebx,%eax
	sarl %cl,%eax
	movq (%r12,%rax,8),%rdx
	movb %bl,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L906
L884:
	xorl %edx,%edx
	movl %r13d,%esi
	movq %r15,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L906
L886:
	movq 344(%r15),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jz L882
L906:
	movq %r15,%rdi
	call _mark_all
	jmp L905
L882:
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	xorl %esi,%esi
	movq %r15,%rdi
	call _predict_switch_succ
	addq $8,%rsp
L907:
	movq %rax,%rdi
	call _mark
L905:
	addl %eax,%r14d
L854:
	movq 112(%r15),%r15
L852:
	testq %r15,%r15
	jnz L853
L855:
	testl %r14d,%r14d
	jnz L849
L850:
	movq _all_blocks(%rip),%rbx
	jmp L888
L889:
	testl $4,4(%rbx)
	jz L894
L892:
	movq %rbx,%rdi
	call _fold0
L894:
	movq 112(%rbx),%rbx
L888:
	testq %rbx,%rbx
	jnz L889
L891:
	movq _all_blocks(%rip),%rbx
	jmp L895
L896:
	testl $4,4(%rbx)
	jz L901
L899:
	movq %rbx,%rdi
	call _project0
L901:
	movq 112(%rbx),%rbx
L895:
	testq %rbx,%rbx
	jnz L896
L902:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L823:
	popq %r15
	popq %r14
	popq %r13
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
.globl ___builtin_clzl
.globl ___builtin_ctzl
.globl ___builtin_memset
.globl ___builtin_clz
.globl _entry_block
.globl ___builtin_ctz
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
