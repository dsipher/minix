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
	movq %rax,(%rsi)
	ret
L14:
	movq (%rsi),%rax
	movzwq %ax,%rax
	movq %rax,(%rsi)
	ret
L12:
	movq (%rsi),%rax
	movswq %ax,%rax
	movq %rax,(%rsi)
	ret
L10:
	movq (%rsi),%rax
	movzbq %al,%rax
	movq %rax,(%rsi)
	ret
L18:
	movq (%rsi),%rax
	movl %eax,%eax
	movq %rax,(%rsi)
	ret
L8:
	movq (%rsi),%rax
	movsbq %al,%rax
	movq %rax,(%rsi)
L3:
	ret 


_con_in_range:
L29:
L30:
	andl $131071,%edi
	cmpq $2,%rdi
	jz L36
	jl L32
L74:
	cmpq $128,%rdi
	jz L66
	jg L32
L75:
	cmpb $4,%dil
	jz L36
L76:
	cmpb $8,%dil
	jz L54
L77:
	cmpb $16,%dil
	jz L42
L78:
	cmpb $32,%dil
	jz L60
L79:
	cmpb $64,%dil
	jnz L32
L48:
	movq (%rsi),%rax
	cmpq $-2147483648,%rax
	jl L51
L49:
	cmpq $2147483647,%rax
	jg L51
L50:
	movl $1,%eax
	ret
L51:
	xorl %eax,%eax
	ret
L60:
	movq (%rsi),%rax
	cmpq $0,%rax
	jl L63
L61:
	cmpq $65535,%rax
	jg L63
L62:
	movl $1,%eax
	ret
L63:
	xorl %eax,%eax
	ret
L42:
	movq (%rsi),%rax
	cmpq $-32768,%rax
	jl L45
L43:
	cmpq $32767,%rax
	jg L45
L44:
	movl $1,%eax
	ret
L45:
	xorl %eax,%eax
	ret
L54:
	movq (%rsi),%rax
	cmpq $0,%rax
	jl L57
L55:
	cmpq $255,%rax
	jg L57
L56:
	movl $1,%eax
	ret
L57:
	xorl %eax,%eax
	ret
L66:
	movq (%rsi),%rcx
	cmpq $0,%rcx
	jl L69
L67:
	movl $-1,%eax
	cmpq %rax,%rcx
	jg L69
L68:
	movl $1,%eax
	ret
L69:
	xorl %eax,%eax
	ret
L32:
	movl $1,%eax
	ret
L36:
	movq (%rsi),%rax
	cmpq $-128,%rax
	jl L39
L37:
	cmpq $127,%rax
	jg L39
L38:
	movl $1,%eax
	ret
L39:
	xorl %eax,%eax
L31:
	ret 

L108:
	.quad 0x43e0000000000000

_cast_con:
L82:
L83:
	movq %rdi,%r9
	andl $7168,%r9d
	setz %r8b
	movzbl %r8b,%r8d
	testq $7168,%rsi
	setz %al
	movzbl %al,%eax
	cmpl %eax,%r8d
	jz L87
L86:
	testq %r9,%r9
	jz L89
L88:
	testl %ecx,%ecx
	jz L91
L93:
	testq $342,%rsi
	jz L96
L95:
	cvtsi2sdq (%rdx),%xmm0
	movsd %xmm0,(%rdx)
	jmp L87
L96:
	movq (%rdx),%rcx
	cmpq $0,%rcx
	jg L98
L99:
	movq %rcx,%rax
	andl $1,%eax
	orq %rcx,%rax
	cvtsi2sdq %rax,%xmm0
	addsd %xmm0,%xmm0
	jmp L100
L98:
	cvtsi2sdq %rcx,%xmm0
L100:
	movsd %xmm0,(%rdx)
	jmp L87
L91:
	xorl %eax,%eax
	ret
L89:
	testq $342,%rdi
	movsd (%rdx),%xmm1
	jz L102
L101:
	cvttsd2siq %xmm1,%rax
	movq %rax,(%rdx)
	jmp L87
L102:
	movsd L108(%rip),%xmm0
	ucomisd %xmm0,%xmm1
	jb L104
L105:
	subsd %xmm0,%xmm1
	cvttsd2siq %xmm1,%rcx
	movq $-9223372036854775808,%rax
	xorq %rax,%rcx
	jmp L106
L104:
	cvttsd2siq %xmm1,%rcx
L106:
	movq %rcx,(%rdx)
L87:
	movl $1,%eax
L84:
	ret 


_cmp_cons:
L109:
L110:
	xorl %eax,%eax
	testq $7168,%rdi
	jz L113
L115:
	movsd 8(%rsi),%xmm1
	movsd 8(%rdx),%xmm0
	ucomisd %xmm0,%xmm1
	jnz L120
L118:
	orl $1537,%eax
L120:
	ucomisd %xmm0,%xmm1
	jbe L123
L121:
	orl $1282,%eax
L123:
	ucomisd %xmm0,%xmm1
	jae L111
L124:
	orl $2562,%eax
	ret
L113:
	testq $342,%rdi
	jz L142
L130:
	movq 8(%rsi),%rsi
	movq 8(%rdx),%rcx
	cmpq %rcx,%rsi
	jnz L135
L133:
	orl $97,%eax
L135:
	cmpq %rcx,%rsi
	jle L138
L136:
	orl $82,%eax
L138:
	cmpq %rcx,%rsi
	jge L111
L139:
	orl $162,%eax
	ret
L142:
	movq 8(%rsi),%rsi
	movq 8(%rdx),%rcx
	cmpq %rcx,%rsi
	jnz L147
L145:
	orl $1537,%eax
L147:
	cmpq %rcx,%rsi
	jbe L150
L148:
	orl $1282,%eax
L150:
	cmpq %rcx,%rsi
	jae L111
L151:
	orl $2562,%eax
L111:
	ret 


_init_state:
L155:
	pushq %rbx
L156:
	movq %rdi,%rbx
	movl _nr_assigned_regs(%rip),%edx
	addl $63,%edx
	sarl $6,%edx
	cmpl (%rbx),%edx
	jg L165
L164:
	movl %edx,4(%rbx)
	jmp L166
L165:
	movl 4(%rbx),%esi
	subl %esi,%edx
	movl $8,%ecx
	movq %rbx,%rdi
	call _vector_insert
L166:
	movslq 4(%rbx),%rcx
	shlq $3,%rcx
	movq 8(%rbx),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	cmpl $0,24(%rbx)
	jl L171
L170:
	movl $0,28(%rbx)
	jmp L157
L171:
	movl 28(%rbx),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $24,%ecx
	leaq 24(%rbx),%rdi
	call _vector_insert
L157:
	popq %rbx
	ret 


_lookup_constant:
L173:
	pushq %rbx
	pushq %r12
	pushq %r13
L174:
	movq %rdi,%r13
	movl %esi,%r12d
	xorl %ebx,%ebx
L176:
	cmpl 340(%r13),%ebx
	jge L179
L177:
	movq 344(%r13),%rcx
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movl (%rcx,%rax),%eax
	cmpl %eax,%r12d
	jz L193
L182:
	cmpl %eax,%r12d
	jb L179
L186:
	incl %ebx
	jmp L176
L179:
	testl %edx,%edx
	jz L189
L188:
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
L193:
	movl %ebx,%eax
	jmp L175
L189:
	movl $-1,%eax
L175:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_remove_constant:
L194:
	pushq %rbx
L195:
	movq %rdi,%rbx
	xorl %edx,%edx
	movq %rbx,%rdi
	call _lookup_constant
	movl %eax,%esi
	cmpl $-1,%esi
	jz L196
L197:
	movl $24,%ecx
	movl $1,%edx
	leaq 336(%rbx),%rdi
	call _vector_delete
L196:
	popq %rbx
	ret 


_set_ccs:
L200:
	pushq %rbx
	pushq %r12
L201:
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
L202:
	popq %r12
	popq %rbx
	ret 


_get_ccs:
L206:
	pushq %rbx
L207:
	movq %rdi,%rbx
	xorl %edx,%edx
	movl $1074266112,%esi
	movq %rbx,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jnz L210
L209:
	xorl %eax,%eax
	jmp L208
L210:
	movq 344(%rbx),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq 8(%rcx,%rax),%rax
L208:
	popq %rbx
	ret 

L577:
	.quad 0xbff0000000000000
.align 2
L578:
	.short L430-_eval
	.short L391-_eval
	.short L399-_eval
	.short L407-_eval
	.short L415-_eval
	.short L423-_eval

_eval:
L214:
	pushq %rbp
	movq %rsp,%rbp
	subq $120,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L215:
	movq %rdi,-96(%rbp)
	movq -96(%rbp),%rdx
	movq 16(%rdx),%rax
	movslq %esi,%rsi
	movq (%rax,%rsi,8),%rdx
	movq %rdx,-80(%rbp)
	movq -80(%rbp),%rdx
	movl (%rdx),%r13d
	leaq -48(%rbp),%rax
	movq %rax,-56(%rbp)
	movq -56(%rbp),%r15
	leaq -24(%rbp),%rax
	movq %rax,-64(%rbp)
	movq -64(%rbp),%r14
	cmpl $603979787,%r13d
	jnz L222
L228:
	movq -80(%rbp),%rdx
	movl 8(%rdx),%ecx
	movl %ecx,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L222
L229:
	movq -80(%rbp),%rdx
	movl 40(%rdx),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L222
L225:
	movq -80(%rbp),%rdx
	movl 16(%rdx),%eax
	movl %eax,-112(%rbp)
	movq -80(%rbp),%rdx
	movl -112(%rbp),%eax
	cmpl 48(%rdx),%eax
	jnz L222
L221:
	testl $10944,%ecx
	movl $1537,%eax
	movl $97,%esi
	cmovzl %eax,%esi
	movq -96(%rbp),%rdi
	call _set_ccs
	jmp L216
L222:
	testl %r13d,%r13d
	jz L216
L539:
	cmpl $41943048,%r13d
	jz L216
L540:
	cmpl $58720258,%r13d
	jz L216
L541:
	cmpl $553648133,%r13d
	jz L216
L542:
	cmpl $822083623,%r13d
	jz L216
L543:
	cmpl $855638054,%r13d
	jz L216
L544:
	cmpl $-1870659577,%r13d
	jz L480
L547:
	cmpl $-1610612733,%r13d
	jz L480
L548:
	cmpl $-1577058300,%r13d
	jz L480
L549:
	cmpl $-1493172218,%r13d
	jz L480
L550:
	cmpl $8388609,%r13d
	jz L480
L551:
	cmpb $24,%r13b
	jb L261
L259:
	cmpb $35,%r13b
	ja L261
L260:
	movq -96(%rbp),%rdx
	movq 320(%rdx),%rax
	movq (%rax),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	jnz L480
L265:
	movq -96(%rbp),%rdi
	call _get_ccs
	testl %eax,%eax
	jz L504
L269:
	subl $2550136856,%r13d
	movq $0,-32(%rbp)
	movq -96(%rbp),%rdi
	call _get_ccs
	movl %r13d,%ecx
	movl $1,%edx
	shll %cl,%edx
	testl %edx,%eax
	setnz %al
	movzbl %al,%eax
	movslq %eax,%rax
	movq %rax,-40(%rbp)
	jmp L272
L261:
	movq $0,-8(%rbp)
	movl $0,-104(%rbp)
	movl $0,-120(%rbp)
	movl $0,-72(%rbp)
	testl $2147483648,%r13d
	movl $1,%ecx
	movl -120(%rbp),%eax
	cmovnzl %ecx,%eax
	movl %eax,-120(%rbp)
	movslq -120(%rbp),%rax
	shlq $5,%rax
	movq -80(%rbp),%rdx
	movl 8(%rdx,%rax),%ebx
	shll $10,%ebx
	shrl $15,%ebx
L277:
	movl %r13d,%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl %eax,-120(%rbp)
	jge L279
L278:
	movslq -120(%rbp),%r12
	shlq $5,%r12
	movq -80(%rbp),%rdx
	movl 8(%rdx,%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L281
L280:
	movq -80(%rbp),%rdx
	movl 16(%r12,%rdx),%esi
	movq -96(%rbp),%rdx
	movq 320(%rdx),%rdx
	movl %esi,%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andl $63,%ecx
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L480
L285:
	xorl %edx,%edx
	movq -96(%rbp),%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L288
L287:
	movslq -104(%rbp),%rcx
	leaq (%rcx,%rcx,2),%rcx
	shlq $3,%rcx
	movq -96(%rbp),%rdx
	movq 344(%rdx),%rdx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rsi
	shlq $3,%rsi
	movq 8(%rdx,%rsi),%rax
	movq %rax,-40(%rbp,%rcx)
	movq -96(%rbp),%rdx
	movq 344(%rdx),%rax
	movq 16(%rsi,%rax),%rax
	movq %rax,-32(%rbp,%rcx)
	movq -80(%rbp),%rdx
	movl 8(%rdx,%r12),%edi
	shll $10,%edi
	shrl $15,%edi
	leaq -40(%rbp,%rcx),%rsi
	call _normalize_con
	jmp L282
L288:
	movl $1,-72(%rbp)
	jmp L282
L281:
	movslq -104(%rbp),%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movq -80(%rbp),%rdx
	movq 24(%r12,%rdx),%rax
	movq %rax,-40(%rbp,%rcx)
	movq -80(%rbp),%rdx
	movq 32(%r12,%rdx),%rax
	movq %rax,-32(%rbp,%rcx)
L282:
	incl -120(%rbp)
	incl -104(%rbp)
	jmp L277
L279:
	cmpl $0,-72(%rbp)
	jz L292
L504:
	cmpl $0,_tmp_regs(%rip)
	jl L508
L507:
	movl $0,_tmp_regs+4(%rip)
	jmp L509
L508:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L509:
	movl $67108864,%edx
	movl $_tmp_regs,%esi
	movq -80(%rbp),%rdi
	call _insn_defs
	xorl %ebx,%ebx
L510:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L216
L514:
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%r12d
	testl %r12d,%r12d
	jz L216
L515:
	movl %r12d,%esi
	movq -96(%rbp),%rdi
	call _remove_constant
	andl $1073725440,%r12d
	movl %r12d,%ecx
	sarl $14,%ecx
	andl $63,%ecx
	movl $1,%esi
	shlq %cl,%rsi
	notq %rsi
	movq -96(%rbp),%rdx
	movq 320(%rdx),%rax
	sarl $20,%r12d
	movslq %r12d,%r12
	andq %rsi,(%rax,%r12,8)
	incl %ebx
	jmp L510
L292:
	cmpl $603979787,%r13d
	jz L299
L554:
	cmpl $-1342177265,%r13d
	jz L299
L555:
	cmpl $-1342177266,%r13d
	jnz L295
L307:
	cmpq $0,-8(%rbp)
	jz L295
L313:
	cmpq $0,-32(%rbp)
	jz L295
L314:
	movq -64(%rbp),%r15
	movq -56(%rbp),%r14
	jmp L295
L299:
	movq -32(%rbp),%rax
	cmpq -8(%rbp),%rax
	jnz L295
L302:
	movq $0,-8(%rbp)
	movq $0,-32(%rbp)
L295:
	cmpq $0,16(%r14)
	jnz L480
L323:
	cmpl $-1342177266,%r13d
	jz L329
L559:
	cmpl $-1342177265,%r13d
	jz L340
L560:
	cmpl $-1610612726,%r13d
	jz L350
L561:
	cmpl $-1610612727,%r13d
	jz L272
L562:
	cmpq $0,16(%r15)
	jnz L480
L359:
	cmpl $-1275068398,%r13d
	jl L565
L567:
	cmpl $-1275068393,%r13d
	jg L565
L564:
	addl $1275068398,%r13d
	movzwl L578(,%r13,2),%eax
	addl $_eval,%eax
	jmp *%rax
L423:
	testq $342,%rbx
	jz L427
L426:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	xorq %rcx,%rax
	movq %rax,8(%r15)
	jmp L272
L427:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	xorq %rcx,%rax
	movq %rax,8(%r15)
	jmp L272
L415:
	testq $342,%rbx
	jz L419
L418:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	orq %rcx,%rax
	movq %rax,8(%r15)
	jmp L272
L419:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	orq %rcx,%rax
	movq %rax,8(%r15)
	jmp L272
L407:
	testq $342,%rbx
	jz L411
L410:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	andq %rcx,%rax
	movq %rax,8(%r15)
	jmp L272
L411:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	andq %rcx,%rax
	movq %rax,8(%r15)
	jmp L272
L399:
	testq $342,%rbx
	jz L403
L402:
	movq 8(%r15),%rax
	movq 8(%r14),%rcx
	shlq %cl,%rax
	movq %rax,8(%r15)
	jmp L272
L403:
	movq 8(%r15),%rax
	movq 8(%r14),%rcx
	shlq %cl,%rax
	movq %rax,8(%r15)
	jmp L272
L391:
	testq $342,%rbx
	jz L395
L394:
	movq 8(%r15),%rax
	movq 8(%r14),%rcx
	sarq %cl,%rax
	movq %rax,8(%r15)
	jmp L272
L395:
	movq 8(%r15),%rax
	movq 8(%r14),%rcx
	shrq %cl,%rax
	movq %rax,8(%r15)
	jmp L272
L430:
	movq 8(%r14),%rcx
	testq %rcx,%rcx
	jz L480
L435:
	testq $342,%rbx
	jz L439
L438:
	movq 8(%r15),%rax
	cqto 
	idivq %rcx
	movq %rdx,8(%r15)
	jmp L272
L439:
	movq 8(%r15),%rax
	xorl %edx,%edx
	divq %rcx
	movq %rdx,8(%r15)
	jmp L272
L565:
	cmpl $-1610612724,%r13d
	jz L367
L569:
	cmpl $-1543503859,%r13d
	jz L375
L570:
	cmpl $-1543503836,%r13d
	jz L462
L571:
	cmpl $-1543503835,%r13d
	jz L470
L572:
	cmpl $-1342177264,%r13d
	jz L380
L573:
	cmpl $-1342177263,%r13d
	jz L442
L574:
	cmpl $603979787,%r13d
	jnz L480
L364:
	movq %r14,%rdx
	movq %r15,%rsi
	movq %rbx,%rdi
	call _cmp_cons
	movl %eax,%esi
	movq -96(%rbp),%rdi
	call _set_ccs
	jmp L216
L442:
	testq $1022,%rbx
	jz L448
L446:
	cmpq $0,8(%r14)
	jz L480
L448:
	testq $7168,%rbx
	jz L455
L454:
	movsd 8(%r15),%xmm0
	divsd 8(%r14),%xmm0
	movsd %xmm0,8(%r15)
	jmp L272
L455:
	testq $342,%rbx
	jz L458
L457:
	movq 8(%r15),%rax
	cqto 
	idivq 8(%r14)
	movq %rax,8(%r15)
	jmp L272
L458:
	movq 8(%r15),%rax
	xorl %edx,%edx
	divq 8(%r14)
	movq %rax,8(%r15)
	jmp L272
L380:
	testq $7168,%rbx
	jz L384
L383:
	movsd 8(%r15),%xmm1
	movsd 8(%r14),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,8(%r15)
	jmp L272
L384:
	testq $342,%rbx
	jz L387
L386:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	imulq %rcx,%rax
	movq %rax,8(%r15)
	jmp L272
L387:
	movq 8(%r15),%rcx
	movq 8(%r14),%rax
	imulq %rcx,%rax
	movq %rax,8(%r15)
	jmp L272
L470:
	testq $768,%rbx
	movq 8(%r15),%rax
	jz L474
L473:
	bsrq %rax,%rax
	movslq %eax,%rax
	movq %rax,8(%r15)
	jmp L272
L474:
	bsrl %eax,%eax
	movslq %eax,%rax
	movq %rax,8(%r15)
	jmp L272
L462:
	testq $768,%rbx
	movq 8(%r15),%rax
	jz L466
L465:
	bsfq %rax,%rax
	movslq %eax,%rax
	movq %rax,8(%r15)
	jmp L272
L466:
	bsfl %eax,%eax
	movslq %eax,%rax
	movq %rax,8(%r15)
	jmp L272
L375:
	notq 8(%r15)
	jmp L272
L367:
	testq $7168,%rbx
	jz L371
L370:
	movsd 8(%r15),%xmm1
	movsd L577(%rip),%xmm0
	mulsd %xmm1,%xmm0
	movsd %xmm0,8(%r15)
	jmp L272
L371:
	negq 8(%r15)
	jmp L272
L350:
	movq -80(%rbp),%rdx
	movl 8(%rdx),%edi
	shll $10,%edi
	shrl $15,%edi
	cmpq $0,16(%r15)
	setz %cl
	movzbl %cl,%ecx
	leaq 8(%r15),%rdx
	movq %rbx,%rsi
	call _cast_con
	testl %eax,%eax
	jnz L272
	jz L480
L340:
	testq $7168,%rbx
	jz L344
L343:
	movsd 8(%r15),%xmm0
	subsd 8(%r14),%xmm0
	movsd %xmm0,8(%r15)
	jmp L272
L344:
	testq $342,%rbx
	jz L347
L346:
	movq 8(%r15),%rax
	subq 8(%r14),%rax
	movq %rax,8(%r15)
	jmp L272
L347:
	movq 8(%r15),%rax
	subq 8(%r14),%rax
	movq %rax,8(%r15)
	jmp L272
L329:
	testq $7168,%rbx
	jz L333
L332:
	movsd 8(%r15),%xmm1
	movsd 8(%r14),%xmm0
	addsd %xmm1,%xmm0
	movsd %xmm0,8(%r15)
	jmp L272
L333:
	testq $342,%rbx
	jz L336
L335:
	movq 8(%r15),%rax
	addq 8(%r14),%rax
	movq %rax,8(%r15)
	jmp L272
L336:
	movq 8(%r15),%rax
	addq 8(%r14),%rax
	movq %rax,8(%r15)
L272:
	movq -80(%rbp),%rdx
	movl 16(%rdx),%eax
	movl %eax,-88(%rbp)
	movq _reg_to_symbol+8(%rip),%rcx
	movl -88(%rbp),%eax
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
	movl -88(%rbp),%esi
	movq -96(%rbp),%rdi
	call _lookup_constant
	movq -96(%rbp),%rdx
	movq 344(%rdx),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rsi
	shlq $3,%rsi
	movq 8(%r15),%rax
	movq %rax,8(%rcx,%rsi)
	movq 16(%r15),%rcx
	movq -96(%rbp),%rdx
	movq 344(%rdx),%rax
	movq %rcx,16(%rsi,%rax)
	movq -80(%rbp),%rdx
	testl $67108864,(%rdx)
	jnz L529
L528:
	movq -80(%rbp),%rdi
	call _insn_defs_cc0
	testl %eax,%eax
	jz L216
L529:
	movl $1074266112,%esi
	movq -96(%rbp),%rdi
	call _remove_constant
	movq -96(%rbp),%rdx
	movq 320(%rdx),%rcx
	movq $4294967296,%rax
	orq %rax,(%rcx)
	jmp L216
L480:
	cmpl $0,_tmp_regs(%rip)
	jl L484
L483:
	movl $0,_tmp_regs+4(%rip)
	jmp L485
L484:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L485:
	movl $67108864,%edx
	movl $_tmp_regs,%esi
	movq -80(%rbp),%rdi
	call _insn_defs
	xorl %ebx,%ebx
L486:
	cmpl _tmp_regs+4(%rip),%ebx
	jge L216
L490:
	movq _tmp_regs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%r12d
	testl %r12d,%r12d
	jz L216
L491:
	movl %r12d,%esi
	movq -96(%rbp),%rdi
	call _remove_constant
	andl $1073725440,%r12d
	movl %r12d,%ecx
	sarl $14,%ecx
	andl $63,%ecx
	movl $1,%esi
	shlq %cl,%rsi
	movq -96(%rbp),%rdx
	movq 320(%rdx),%rax
	sarl $20,%r12d
	movslq %r12d,%r12
	orq %rsi,(%rax,%r12,8)
	incl %ebx
	jmp L486
L216:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_mark:
L579:
	pushq %rbx
L580:
	xorl %ebx,%ebx
L582:
	movl 4(%rdi),%eax
	testl $4,%eax
	jnz L583
L587:
	orl $4,%eax
	movl %eax,4(%rdi)
	incl %ebx
	call _unconditional_succ
	movq %rax,%rdi
	testq %rax,%rax
	jnz L582
L583:
	movl %ebx,%eax
L581:
	popq %rbx
	ret 


_mark_all:
L590:
	pushq %rbx
	pushq %r12
	pushq %r13
L591:
	movq %rdi,%r13
	xorl %r12d,%r12d
	xorl %ebx,%ebx
L593:
	cmpl 60(%r13),%ebx
	jge L596
L594:
	movq 64(%r13),%rcx
	movslq %ebx,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	movq 16(%rcx,%rax),%rdi
	call _mark
	addl %eax,%r12d
	incl %ebx
	jmp L593
L596:
	movl %r12d,%eax
L592:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_meet0:
L598:
	pushq %rbp
	movq %rsp,%rbp
	subq $56,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L599:
	movq %rdi,%r15
	leaq 312(%r15),%rdi
	call _init_state
	movl $0,-8(%rbp)
L601:
	movl -8(%rbp),%eax
	cmpl 36(%r15),%eax
	jge L600
L602:
	movq 40(%r15),%rcx
	movslq -8(%rbp),%rax
	movq (%rcx,%rax,8),%rax
	movq %rax,-24(%rbp)
	xorl %r14d,%r14d
	xorl %r13d,%r13d
	movl 316(%r15),%eax
	movl %eax,-48(%rbp)
	xorl %esi,%esi
L608:
	cmpl %esi,-48(%rbp)
	jle L612
L609:
	movq -24(%rbp),%rax
	movq 368(%rax),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 320(%r15),%rax
	orq %rcx,(%rax,%rdx,8)
	incl %esi
	cmpl %esi,-48(%rbp)
	jg L609
L612:
	cmpl 340(%r15),%r13d
	jge L641
L615:
	movq -24(%rbp),%rax
	cmpl 388(%rax),%r14d
	jl L616
L641:
	cmpl 340(%r15),%r13d
	jl L642
L647:
	movq -24(%rbp),%rax
	cmpl 388(%rax),%r14d
	jge L649
L648:
	movq -24(%rbp),%rax
	movq 392(%rax),%rcx
	movslq %r14d,%rax
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
	andl $63,%ecx
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L652
L653:
	movl 340(%r15),%esi
	leal 1(%rsi),%eax
	cmpl 336(%r15),%eax
	jge L657
L656:
	movl %eax,340(%r15)
	jmp L658
L657:
	movl $24,%ecx
	movl $1,%edx
	leaq 336(%r15),%rdi
	call _vector_insert
L658:
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
L652:
	incl %r14d
	jmp L647
L649:
	incl -8(%rbp)
	jmp L601
L642:
	movq 344(%r15),%rcx
	movslq %r13d,%rax
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
	andl $63,%ecx
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jz L645
L644:
	movl $24,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 336(%r15),%rdi
	call _vector_delete
	jmp L641
L645:
	incl %r13d
	jmp L641
L616:
	movq 344(%r15),%rsi
	movslq %r13d,%rax
	leaq (%rax,%rax,2),%r12
	shlq $3,%r12
	movl (%rsi,%r12),%eax
	movl %eax,-40(%rbp)
	movq -24(%rbp),%rax
	movq 392(%rax),%rdx
	movslq %r14d,%rax
	leaq (%rax,%rax,2),%rbx
	shlq $3,%rbx
	movl (%rdx,%rbx),%eax
	movq 320(%r15),%r8
	movl -40(%rbp),%ecx
	andl $1073725440,%ecx
	movl %ecx,%edi
	sarl $20,%edi
	movslq %edi,%rdi
	movq %rdi,-16(%rbp)
	sarl $14,%ecx
	andl $63,%ecx
	movq $1,-56(%rbp)
	shlq %cl,-56(%rbp)
	movq -16(%rbp),%rdi
	movq -56(%rbp),%rcx
	testq %rcx,(%r8,%rdi,8)
	jz L620
L619:
	movl $24,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 336(%r15),%rdi
	call _vector_delete
	jmp L612
L620:
	movl %eax,%ecx
	andl $1073725440,%ecx
	movl %ecx,%edi
	sarl $20,%edi
	movslq %edi,%rdi
	movq (%r8,%rdi,8),%rdi
	movq %rdi,-32(%rbp)
	sarl $14,%ecx
	andl $63,%ecx
	movl $1,%r8d
	shlq %cl,%r8
	movq -32(%rbp),%rdi
	testq %rdi,%r8
	jz L623
L622:
	incl %r14d
	jmp L612
L623:
	cmpl %eax,-40(%rbp)
	jb L625
	jz L629
L628:
	movl $24,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 336(%r15),%rdi
	call _vector_insert
	movq 344(%r15),%rdx
	movq -24(%rbp),%rax
	movq 392(%rax),%rcx
	movq (%rbx,%rcx),%rax
	movq %rax,(%r12,%rdx)
	movq 8(%rbx,%rcx),%rax
	movq %rax,8(%r12,%rdx)
	movq 16(%rbx,%rcx),%rax
	movq %rax,16(%r12,%rdx)
	incl %r13d
	incl %r14d
	jmp L612
L629:
	movq 8(%rsi,%r12),%rax
	cmpq 8(%rdx,%rbx),%rax
	jnz L636
L634:
	movq 16(%rsi,%r12),%rax
	cmpq 16(%rdx,%rbx),%rax
	jnz L636
L635:
	incl %r13d
	incl %r14d
	jmp L612
L636:
	movl $24,%ecx
	movl $1,%edx
	movl %r13d,%esi
	leaq 336(%r15),%rdi
	call _vector_delete
	movq 320(%r15),%rax
	movq -16(%rbp),%rdi
	movq -56(%rbp),%rcx
	orq %rcx,(%rax,%rdi,8)
	incl %r14d
	jmp L612
L625:
	incl %r13d
	jmp L612
L600:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_prop0:
L660:
	pushq %rbp
	movq %rsp,%rbp
	subq $48,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L661:
	movq %rdi,%r12
	movl $1,%ebx
	testl $4,4(%r12)
	movl $0,%r13d
	jz L663
L665:
	movq %r12,%rdi
	call _meet0
L667:
	cmpl 12(%r12),%r13d
	jge L670
L668:
	movl %r13d,%esi
	movq %r12,%rdi
	call _eval
	incl %r13d
	jmp L667
L670:
	movl 316(%r12),%edi
	xorl %esi,%esi
L674:
	cmpl %esi,%edi
	jle L677
L675:
	movq 320(%r12),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 368(%r12),%rax
	cmpq (%rax,%rdx,8),%rcx
	jnz L700
L680:
	incl %esi
	cmpl %esi,%edi
	jg L675
L677:
	movl 340(%r12),%eax
	cmpl 388(%r12),%eax
	jnz L700
L686:
	xorl %edi,%edi
L688:
	cmpl 340(%r12),%edi
	jge L691
L689:
	movq 344(%r12),%rsi
	movslq %edi,%rax
	leaq (%rax,%rax,2),%rdx
	shlq $3,%rdx
	movq 8(%rsi,%rdx),%rax
	movq 392(%r12),%rcx
	cmpq 8(%rdx,%rcx),%rax
	jnz L700
L695:
	movq 16(%rsi,%rdx),%rax
	cmpq 16(%rdx,%rcx),%rax
	jnz L700
L696:
	incl %edi
	jmp L688
L691:
	xorl %ebx,%ebx
L700:
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
	jmp L662
L663:
	movl %r13d,%eax
L662:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_fold0:
L705:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L706:
	movq %rdi,%r15
	movq %r15,%rdi
	call _meet0
	xorl %r14d,%r14d
L708:
	cmpl 12(%r15),%r14d
	jge L714
L712:
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r12
	testq %r12,%r12
	jz L714
L713:
	xorl %ebx,%ebx
L716:
	cmpl 340(%r15),%ebx
	jge L719
L717:
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
	jz L722
L720:
	orl $26,_opt_request(%rip)
L722:
	incl %ebx
	jmp L716
L719:
	movl %r14d,%esi
	movq %r15,%rdi
	call _eval
	cmpl $0,_tmp_regs(%rip)
	jl L727
L726:
	movl $0,_tmp_regs+4(%rip)
	jmp L728
L727:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L728:
	xorl %edx,%edx
	movl $_tmp_regs,%esi
	movq %r12,%rdi
	call _insn_defs
	cmpl $1,_tmp_regs+4(%rip)
	jnz L710
L731:
	movq _tmp_regs+8(%rip),%rax
	movl (%rax),%eax
	movl %eax,-8(%rbp)
	xorl %edx,%edx
	movl -8(%rbp),%esi
	movq %r15,%rdi
	call _lookup_constant
	movl %eax,%ebx
	cmpl $-1,%ebx
	jz L710
L735:
	testl $16777216,(%r12)
	jnz L710
L740:
	movq %r12,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jnz L710
L742:
	testl $8388608,(%r12)
	jnz L710
L748:
	testl $1,4(%r12)
	jnz L710
L750:
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
	movl -8(%rbp),%esi
	movq %r13,%rdi
	call _insn_substitute_con
	addq $8,%rsp
	movq 16(%r15),%rax
	movq %r13,(%rax,%r12,8)
	orl $26,_opt_request(%rip)
L710:
	incl %r14d
	jmp L708
L714:
	movq 320(%r15),%rax
	movq (%rax),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	setnz %bl
	movzbl %bl,%ebx
	movq %r15,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L755
L760:
	testl %ebx,%ebx
	jnz L755
L761:
	movq %r15,%rdi
	call _get_ccs
	testl %eax,%eax
	jz L755
L757:
	movq %r15,%rdi
	call _get_ccs
	movl $1,%edx
	movl %eax,%esi
	movq %r15,%rdi
	call _predict_succ
	orl $32,_opt_request(%rip)
L755:
	testl $1,4(%r15)
	jz L707
L775:
	movl 80(%r15),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L707
L776:
	xorl %edx,%edx
	movl 88(%r15),%esi
	movq %r15,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L707
L772:
	movq 344(%r15),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jnz L707
L768:
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	movl $1,%esi
	movq %r15,%rdi
	call _predict_switch_succ
	addq $8,%rsp
	orl $32,_opt_request(%rip)
L707:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_project0:
L779:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L780:
	movq %rdi,%r12
	movq %r12,%rdi
	call _unconditional_succ
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L781
L797:
	cmpl $1,12(%rbx)
	jnz L781
L793:
	movq 16(%rbx),%rax
	leaq -4(%rbp),%rsi
	movq (%rax),%rdi
	call _insn_is_cmp_con
	testl %eax,%eax
	jz L781
L789:
	xorl %edx,%edx
	movl -4(%rbp),%esi
	movq %r12,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L781
L785:
	movq 344(%r12),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jnz L781
L782:
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
L781:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_opt_lir_fold:
L801:
	pushq %rbx
	pushq %r12
L802:
	movq _all_blocks(%rip),%rbx
L804:
	testq %rbx,%rbx
	jz L807
L805:
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
	jmp L804
L807:
	xorl %edi,%edi
	call _sequence_blocks
	movq _entry_block(%rip),%rdi
	call _mark
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
L829:
	movl $_prop0,%edi
	call _iterate_blocks
	xorl %ebx,%ebx
	movq _all_blocks(%rip),%r12
L832:
	testq %r12,%r12
	jz L835
L833:
	testl $4,4(%r12)
	jz L834
L838:
	movq %r12,%rdi
	call _conditional_block
	testl %eax,%eax
	jz L841
L840:
	movq 320(%r12),%rax
	movq (%rax),%rcx
	movq $4294967296,%rax
	testq %rcx,%rax
	jnz L847
L846:
	movq %r12,%rdi
	call _get_ccs
	testl %eax,%eax
	jnz L848
L847:
	movq %r12,%rdi
	call _mark_all
	addl %eax,%ebx
	jmp L834
L848:
	movq %r12,%rdi
	call _get_ccs
	xorl %edx,%edx
	movl %eax,%esi
	movq %r12,%rdi
	call _predict_succ
	movq %rax,%rdi
	call _mark
	addl %eax,%ebx
	jmp L834
L841:
	testl $1,4(%r12)
	jz L834
L853:
	movl 80(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L834
L854:
	movl 88(%r12),%esi
	movq 320(%r12),%rdx
	movl %esi,%ecx
	andl $1073725440,%ecx
	movl %ecx,%eax
	sarl $20,%eax
	movslq %eax,%rax
	movq (%rdx,%rax,8),%rdx
	sarl $14,%ecx
	andl $63,%ecx
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jnz L861
L864:
	xorl %edx,%edx
	movq %r12,%rdi
	call _lookup_constant
	cmpl $-1,%eax
	jz L861
L866:
	movq 344(%r12),%rcx
	movslq %eax,%rax
	leaq (%rax,%rax,2),%rax
	shlq $3,%rax
	cmpq $0,16(%rcx,%rax)
	jz L862
L861:
	movq %r12,%rdi
	call _mark_all
	addl %eax,%ebx
	jmp L834
L862:
	subq $8,%rsp
	movq 8(%rcx,%rax),%rax
	movq %rax,(%rsp)
	xorl %esi,%esi
	movq %r12,%rdi
	call _predict_switch_succ
	addq $8,%rsp
	movq %rax,%rdi
	call _mark
	addl %eax,%ebx
L834:
	movq 112(%r12),%r12
	jmp L832
L835:
	testl %ebx,%ebx
	jnz L829
L830:
	movq _all_blocks(%rip),%rbx
L868:
	testq %rbx,%rbx
	jz L871
L869:
	testl $4,4(%rbx)
	jz L874
L872:
	movq %rbx,%rdi
	call _fold0
L874:
	movq 112(%rbx),%rbx
	jmp L868
L871:
	movq _all_blocks(%rip),%rbx
L875:
	testq %rbx,%rbx
	jz L882
L876:
	testl $4,4(%rbx)
	jz L881
L879:
	movq %rbx,%rdi
	call _project0
L881:
	movq 112(%rbx),%rbx
	jmp L875
L882:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L803:
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
