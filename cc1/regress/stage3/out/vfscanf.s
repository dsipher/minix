.text
.align 2
L99:
	.short L15-_dscan
	.short L11-_dscan
	.short L15-_dscan
	.short L11-_dscan
	.short L11-_dscan
	.short L34-_dscan
	.short L34-_dscan
	.short L34-_dscan
	.short L34-_dscan
	.short L34-_dscan
	.short L34-_dscan
	.short L34-_dscan
	.short L34-_dscan
	.short L34-_dscan
	.short L34-_dscan

_dscan:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movq %rdi,%r15
	movq %rsi,%r14
	movl %edx,-16(%rbp)
	movq %rcx,-8(%rbp)
	movq %r15,%rbx
	xorl %r13d,%r13d
	xorl %r12d,%r12d
L4:
	cmpl %r13d,-16(%rbp)
	jle L7
L5:
	decl (%r14)
	js L9
L8:
	movq 24(%r14),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r14)
	movzbl (%rcx),%eax
	jmp L10
L9:
	movq %r14,%rdi
	call ___fillbuf
L10:
	movb %al,(%rbx)
	incq %rbx
	cmpl $43,%eax
	jl L92
L94:
	cmpl $57,%eax
	jg L92
L91:
	leal -43(%rax),%ecx
	movzwl L99(,%rcx,2),%ecx
	addl $_dscan,%ecx
	jmp *%rcx
L34:
	testl %r12d,%r12d
	jz L35
L42:
	cmpl $1,%r12d
	jz L35
L38:
	cmpl $3,%r12d
	jnz L36
L35:
	movl $3,%r12d
	jmp L6
L36:
	cmpl $2,%r12d
	jz L46
L53:
	cmpl $4,%r12d
	jz L46
L49:
	cmpl $5,%r12d
	jnz L47
L46:
	movl $5,%r12d
	jmp L6
L47:
	cmpl $6,%r12d
	jz L57
L60:
	cmpl $7,%r12d
	jnz L12
L57:
	movl $7,%r12d
	jmp L6
L15:
	testl %r12d,%r12d
	jz L18
L19:
	cmpl $6,%r12d
	jnz L12
L18:
	incl %r12d
	jmp L6
L92:
	cmpl $69,%eax
	jz L67
L96:
	cmpl $101,%eax
	jz L67
L11:
	cmpl $46,%eax
	jnz L12
L79:
	cmpl $1,%r12d
	jg L82
L81:
	movl $2,%r12d
	jmp L6
L82:
	cmpl $3,%r12d
	jnz L12
L84:
	incl %r12d
	jmp L6
L67:
	cmpl $3,%r12d
	jl L12
L71:
	cmpl $5,%r12d
	jg L12
L70:
	movl $6,%r12d
L6:
	incl %r13d
	jmp L4
L12:
	decq %rbx
	movq %r14,%rsi
	movl %eax,%edi
	call _ungetc
L7:
	movb $0,(%rbx)
	xorl %esi,%esi
	movq %r15,%rdi
	call _strtod
	movq -8(%rbp),%rax
	movsd %xmm0,(%rax)
	subq %r15,%rbx
	movl %ebx,%eax
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lscan:
L100:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L101:
	movq %rdi,-32(%rbp)
	movq %rsi,%r15
	movl %edx,%r14d
	movl %ecx,-16(%rbp)
	movl %r8d,-8(%rbp)
	movq %r9,-24(%rbp)
	movq -32(%rbp),%rbx
	testl %r14d,%r14d
	jnz L104
L103:
	xorl %r13d,%r13d
	jmp L105
L104:
	cmpl $16,%r14d
	movl $3,%eax
	movl $6,%r13d
	cmovnzl %eax,%r13d
L105:
	xorl %r12d,%r12d
L109:
	cmpl %r12d,-16(%rbp)
	jle L112
L110:
	decl (%r15)
	js L114
L113:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movzbl (%rcx),%eax
	jmp L115
L114:
	movq %r15,%rdi
	call ___fillbuf
L115:
	movb %al,(%rbx)
	incq %rbx
	cmpl $43,%eax
	jz L120
	jl L116
L199:
	cmpl $120,%eax
	jz L150
	jg L116
L200:
	cmpb $45,%al
	jz L120
L201:
	cmpb $48,%al
	jz L134
L202:
	cmpb $88,%al
	jz L150
	jnz L116
L134:
	cmpl $1,%r13d
	jg L136
L135:
	movl $2,%r13d
	jmp L111
L136:
	cmpl $2,%r13d
	jnz L139
L138:
	movl $8,%r14d
	jmp L197
L139:
	cmpl $5,%r13d
	jle L197
L144:
	cmpl $8,%r13d
	jz L197
L142:
	movl $8,%r13d
	jmp L111
L150:
	cmpl $2,%r13d
	jnz L152
L151:
	movl $16,%r14d
	jmp L197
L152:
	cmpl $8,%r13d
	jz L197
	jnz L117
L116:
	movl %eax,%ecx
	subl $48,%ecx
	cmpl $2,%r13d
	jle L159
L161:
	cmpl $10,%ecx
	jae L174
L178:
	cmpl %ecx,%r14d
	jg L197
L174:
	movl %eax,%ecx
	subl $97,%ecx
	cmpl $26,%ecx
	jae L170
L182:
	movl %eax,%ecx
	subl $87,%ecx
	cmpl %ecx,%r14d
	jg L197
L170:
	movl %eax,%ecx
	subl $65,%ecx
	cmpl $26,%ecx
	jae L117
L186:
	movl %eax,%ecx
	subl $55,%ecx
	cmpl %ecx,%r14d
	jg L197
	jle L117
L159:
	cmpl $10,%ecx
	jae L117
L162:
	movl $10,%r14d
L197:
	movl $5,%r13d
	jmp L111
L120:
	testl %r13d,%r13d
	jz L123
L128:
	cmpl $3,%r13d
	jz L123
L124:
	cmpl $6,%r13d
	jz L123
L117:
	decq %rbx
	movq %r15,%rsi
	movl %eax,%edi
	call _ungetc
	jmp L112
L123:
	incl %r13d
L111:
	incl %r12d
	jmp L109
L112:
	movb $0,(%rbx)
	cmpl $0,-8(%rbp)
	jz L194
L193:
	movl %r14d,%edx
	xorl %esi,%esi
	movq -32(%rbp),%rdi
	call _strtol
	movq -24(%rbp),%rcx
	movq %rax,(%rcx)
	jmp L195
L194:
	movl %r14d,%edx
	xorl %esi,%esi
	movq -32(%rbp),%rdi
	call _strtoul
	movq -24(%rbp),%rcx
	movq %rax,(%rcx)
L195:
	subq -32(%rbp),%rbx
	movl %ebx,%eax
L102:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L467:
	.short L428-_vfscanf
	.short L281-_vfscanf
	.short L321-_vfscanf
	.short L321-_vfscanf
	.short L321-_vfscanf
	.short L211-_vfscanf
	.short L284-_vfscanf
	.short L211-_vfscanf
	.short L211-_vfscanf
	.short L211-_vfscanf
	.short L211-_vfscanf
	.short L435-_vfscanf
	.short L286-_vfscanf
	.short L433-_vfscanf
	.short L211-_vfscanf
	.short L211-_vfscanf
	.short L346-_vfscanf
	.short L211-_vfscanf
	.short L288-_vfscanf
	.short L211-_vfscanf
	.short L211-_vfscanf
	.short L291-_vfscanf

_vfscanf:
L205:
	pushq %rbp
	movq %rsp,%rbp
	subq $408,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L206:
	movq %rdi,-408(%rbp)
	movq %rsi,%r15
	movq %rdx,-288(%rbp)
	movl $0,-280(%rbp)
	movl $0,-152(%rbp)
L208:
	movsbl (%r15),%ebx
	incq %r15
	testl %ebx,%ebx
	jz L211
L209:
	movslq %ebx,%rax
	movq %rax,-176(%rbp)
	movq -176(%rbp),%rax
	testb $8,___ctype+1(%rax)
	jz L213
L215:
	movq -408(%rbp),%rax
	decl (%rax)
	js L219
L218:
	movq -408(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,-384(%rbp)
	movq -384(%rbp),%rcx
	movq -408(%rbp),%rax
	movq %rcx,24(%rax)
	movzbl (%rdx),%eax
	jmp L220
L219:
	movq -408(%rbp),%rdi
	call ___fillbuf
L220:
	movslq %eax,%rcx
	movq %rcx,-392(%rbp)
	movq -392(%rbp),%rcx
	testb $8,___ctype+1(%rcx)
	jz L217
L216:
	incl -280(%rbp)
	jmp L215
L217:
	cmpl $-1,%eax
	jz L211
L223:
	movq -408(%rbp),%rsi
	movl %eax,%edi
	call _ungetc
	jmp L208
L213:
	cmpl $37,%ebx
	jnz L229
L227:
	movl $0,-232(%rbp)
	movl $0,-160(%rbp)
	movl $0,-168(%rbp)
	movsbl (%r15),%ebx
	incq %r15
	cmpl $42,%ebx
	jnz L240
L238:
	movl $1,-160(%rbp)
	movsbl (%r15),%eax
	movl %eax,-192(%rbp)
	incq %r15
	movl -192(%rbp),%ebx
L240:
	movl %ebx,-400(%rbp)
	subl $48,-400(%rbp)
	cmpl $10,-400(%rbp)
	jae L242
L241:
	xorl %r14d,%r14d
L244:
	movl %ebx,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L243
L245:
	leal (%r14,%r14,4),%r14d
	addl %r14d,%r14d
	addl %ebx,%r14d
	subl $48,%r14d
	movsbl (%r15),%ebx
	incq %r15
	jmp L244
L242:
	movl $-1,%r14d
L243:
	cmpl $104,%ebx
	jz L248
L255:
	cmpl $108,%ebx
	jz L248
L251:
	cmpl $76,%ebx
	jnz L250
L248:
	movl %ebx,-232(%rbp)
	movsbl (%r15),%eax
	movl %eax,-200(%rbp)
	incq %r15
	movl -200(%rbp),%ebx
L250:
	cmpl $91,%ebx
	jz L261
L266:
	cmpl $99,%ebx
	jz L261
L262:
	cmpl $110,%ebx
	jz L261
L270:
	movq -408(%rbp),%rax
	decl (%rax)
	js L274
L273:
	movq -408(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,-336(%rbp)
	movq -336(%rbp),%rcx
	movq -408(%rbp),%rax
	movq %rcx,24(%rax)
	movzbl (%rdx),%eax
	jmp L275
L274:
	movq -408(%rbp),%rdi
	call ___fillbuf
L275:
	movslq %eax,%rcx
	movq %rcx,-344(%rbp)
	movq -344(%rbp),%rcx
	testb $8,___ctype+1(%rcx)
	jz L272
L271:
	incl -280(%rbp)
	jmp L270
L272:
	movq -408(%rbp),%rsi
	movl %eax,%edi
	call _ungetc
L261:
	cmpl $99,%ebx
	jl L456
L458:
	cmpl $120,%ebx
	jg L456
L455:
	leal -99(%rbx),%eax
	movzwl L467(,%rax,2),%eax
	addl $_vfscanf,%eax
	jmp *%rax
L288:
	movl $10,%edx
	jmp L282
L433:
	movl $18,%r14d
	movl $16,%edx
	movl $112,-232(%rbp)
	jmp L294
L286:
	movl $8,%edx
	jmp L282
L435:
	movq -288(%rbp),%rax
	addq $8,%rax
	movq %rax,-320(%rbp)
	movq -288(%rbp),%rax
	movq (%rax),%rax
	movq %rax,-328(%rbp)
	cmpl $108,-232(%rbp)
	jnz L437
L436:
	movslq -280(%rbp),%rcx
	movq %rcx,-208(%rbp)
	movq -320(%rbp),%rax
	movq %rax,-288(%rbp)
	movq -208(%rbp),%rcx
	movq -328(%rbp),%rax
	movq %rcx,(%rax)
	jmp L208
L437:
	cmpl $104,-232(%rbp)
	jnz L440
L439:
	movzwl -280(%rbp),%ecx
	movw %cx,-224(%rbp)
	movq -320(%rbp),%rax
	movq %rax,-288(%rbp)
	movzwl -224(%rbp),%ecx
	movq -328(%rbp),%rax
	movw %cx,(%rax)
	jmp L208
L440:
	movq -320(%rbp),%rax
	movq %rax,-288(%rbp)
	movl -280(%rbp),%ecx
	movq -328(%rbp),%rax
	movl %ecx,(%rax)
	jmp L208
L284:
	xorl %edx,%edx
	movl $1,-168(%rbp)
	jmp L282
L281:
	movl $10,%edx
	movl $1,-168(%rbp)
	jmp L282
L428:
	cmpl $-1,%r14d
	movl $1,%eax
	cmovzl %eax,%r14d
	jmp L346
L456:
	cmpl $0,%ebx
	jle L211
L460:
	cmpl $91,%ebx
	jz L396
	jg L211
L461:
	cmpb $37,%bl
	jz L229
L462:
	cmpb $69,%bl
	jz L321
L463:
	cmpb $71,%bl
	jz L321
L464:
	cmpb $88,%bl
	jnz L211
L291:
	movl $16,%edx
L282:
	cmpl $-1,%r14d
	jz L292
L295:
	cmpl $128,%r14d
	jle L294
L292:
	movl $128,%r14d
L294:
	leaq -136(%rbp),%r9
	movl -168(%rbp),%r8d
	movl %r14d,%ecx
	movq -408(%rbp),%rsi
	leaq -128(%rbp),%rdi
	call _lscan
	testl %eax,%eax
	jz L211
L301:
	addl -280(%rbp),%eax
	movl %eax,-280(%rbp)
	cmpl $0,-160(%rbp)
	jnz L208
L305:
	movq -288(%rbp),%rax
	addq $8,%rax
	movq %rax,-376(%rbp)
	movq -136(%rbp),%rax
	movq %rax,-368(%rbp)
	movq -288(%rbp),%rax
	movq (%rax),%rcx
	cmpl $112,-232(%rbp)
	jnz L308
L307:
	movq -376(%rbp),%rax
	movq %rax,-288(%rbp)
	movq -368(%rbp),%rax
	movq %rax,(%rcx)
	jmp L309
L308:
	cmpl $108,-232(%rbp)
	jnz L311
L310:
	movq -376(%rbp),%rax
	movq %rax,-288(%rbp)
	movq -368(%rbp),%rax
	movq %rax,(%rcx)
	jmp L309
L311:
	cmpl $104,-232(%rbp)
	jnz L314
L313:
	movq -376(%rbp),%rax
	movq %rax,-288(%rbp)
	movzwl -368(%rbp),%eax
	movw %ax,(%rcx)
	jmp L309
L314:
	movq -376(%rbp),%rax
	movq %rax,-288(%rbp)
	movl -368(%rbp),%eax
	movl %eax,(%rcx)
L309:
	incl -152(%rbp)
	jmp L208
L321:
	cmpl $-1,%r14d
	jz L322
L325:
	cmpl $128,%r14d
	jle L324
L322:
	movl $128,%r14d
L324:
	leaq -144(%rbp),%rcx
	movl %r14d,%edx
	movq -408(%rbp),%rsi
	leaq -128(%rbp),%rdi
	call _dscan
	testl %eax,%eax
	jz L211
L331:
	addl -280(%rbp),%eax
	movl %eax,-280(%rbp)
	cmpl $0,-160(%rbp)
	jnz L208
L335:
	cmpl $108,-232(%rbp)
	jz L337
L340:
	cmpl $76,-232(%rbp)
	jnz L338
L337:
	addq $8,-288(%rbp)
	movq -288(%rbp),%rax
	movq -8(%rax),%rax
	movq %rax,-240(%rbp)
	movsd -144(%rbp),%xmm0
	movq -240(%rbp),%rax
	movsd %xmm0,(%rax)
	jmp L339
L338:
	cvtsd2ss -144(%rbp),%xmm0
	addq $8,-288(%rbp)
	movq -288(%rbp),%rax
	movq -8(%rax),%rax
	movq %rax,-248(%rbp)
	movq -248(%rbp),%rax
	movss %xmm0,(%rax)
L339:
	incl -152(%rbp)
	jmp L208
L229:
	movq -408(%rbp),%rax
	decl (%rax)
	js L234
L233:
	movq -408(%rbp),%rax
	movq 24(%rax),%rcx
	movq %rcx,-296(%rbp)
	movq -296(%rbp),%rcx
	incq %rcx
	movq %rcx,-184(%rbp)
	movq -184(%rbp),%rcx
	movq -408(%rbp),%rax
	movq %rcx,24(%rax)
	movq -296(%rbp),%rcx
	movzbl (%rcx),%eax
	jmp L235
L234:
	movq -408(%rbp),%rdi
	call ___fillbuf
L235:
	cmpl %eax,%ebx
	jnz L230
L232:
	incl -280(%rbp)
	jmp L208
L230:
	movq -408(%rbp),%rsi
	movl %eax,%edi
	call _ungetc
	jmp L211
L396:
	movl $0,-168(%rbp)
	movsbl (%r15),%edx
	incq %r15
	cmpl $94,%edx
	jnz L399
L397:
	movl $1,-168(%rbp)
	movsbl (%r15),%edx
	incq %r15
	movq %r15,-264(%rbp)
	movq -264(%rbp),%r15
L399:
	leaq -128(%rbp),%rax
	movq %rax,-216(%rbp)
	movq -216(%rbp),%r13
	cmpl $93,%edx
	jnz L403
L400:
	movb %dl,-128(%rbp)
	leaq -127(%rbp),%rax
	movq %rax,-272(%rbp)
	movq -272(%rbp),%r13
	movsbl (%r15),%edx
	incq %r15
L403:
	testl %edx,%edx
	jz L405
L406:
	cmpl $93,%edx
	jz L405
L404:
	cmpl $45,%edx
	jnz L411
L417:
	leaq -128(%rbp),%rax
	movq %rax,-360(%rbp)
	cmpq -360(%rbp),%r13
	jz L411
L413:
	movzbl (%r15),%ecx
	cmpb $93,%cl
	jz L411
L410:
	movsbl -1(%r13),%eax
	movsbl %cl,%ecx
	incq %r15
	cmpl %ecx,%eax
	jg L421
L424:
	incl %eax
	cmpl %eax,%ecx
	jl L412
L425:
	movb %al,(%r13)
	incq %r13
	jmp L424
L421:
	decq %r13
	jmp L412
L411:
	movb %dl,(%r13)
	incq %r13
L412:
	movsbl (%r15),%edx
	incq %r15
	jmp L403
L405:
	movb $0,(%r13)
	movl $91,%ebx
L346:
	cmpl $0,-160(%rbp)
	jnz L349
L347:
	addq $8,-288(%rbp)
	movq -288(%rbp),%rax
	movq -8(%rax),%r13
L349:
	movl $0,-352(%rbp)
L350:
	cmpl $0,%r14d
	jl L351
L354:
	cmpl -352(%rbp),%r14d
	jle L353
L351:
	movq -408(%rbp),%rax
	decl (%rax)
	js L362
L361:
	movq -408(%rbp),%rax
	movq 24(%rax),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,-304(%rbp)
	movq -304(%rbp),%rcx
	movq -408(%rbp),%rax
	movq %rcx,24(%rax)
	movzbl (%rdx),%r12d
	jmp L363
L362:
	movq -408(%rbp),%rdi
	call ___fillbuf
	movl %eax,%r12d
L363:
	cmpl $-1,%r12d
	jz L353
L360:
	cmpl $115,%ebx
	jnz L368
L372:
	movslq %r12d,%rax
	movq %rax,-312(%rbp)
	movq -312(%rbp),%rax
	testb $8,___ctype+1(%rax)
	jnz L365
L368:
	cmpl $91,%ebx
	jnz L367
L376:
	movl %r12d,%esi
	leaq -128(%rbp),%rdi
	call _strchr
	testq %rax,%rax
	setz %al
	movzbl %al,%eax
	cmpl %eax,-168(%rbp)
	jnz L365
L367:
	cmpl $0,-160(%rbp)
	jnz L383
L381:
	movb %r12b,(%r13)
	incq %r13
L383:
	incl -352(%rbp)
	jmp L350
L365:
	movq -408(%rbp),%rsi
	movl %r12d,%edi
	call _ungetc
L353:
	cmpl $0,-352(%rbp)
	jz L211
L386:
	movl -352(%rbp),%eax
	addl -280(%rbp),%eax
	movl %eax,-352(%rbp)
	movl -352(%rbp),%eax
	movl %eax,-256(%rbp)
	movl -256(%rbp),%ecx
	movl %ecx,-280(%rbp)
	cmpl $0,-160(%rbp)
	jnz L208
L390:
	cmpl $99,%ebx
	jz L394
L392:
	movb $0,(%r13)
L394:
	incl -152(%rbp)
	jmp L208
L211:
	cmpl $0,-152(%rbp)
	jnz L448
L450:
	movq -408(%rbp),%rax
	testl $16,8(%rax)
	jz L448
L447:
	movl $-1,%eax
	jmp L207
L448:
	movl -152(%rbp),%eax
L207:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


.globl ___fillbuf
.globl _strtoul
.globl _strtol
.globl _strtod
.globl _vfscanf
.globl ___ctype
.globl _strchr
.globl _ungetc
