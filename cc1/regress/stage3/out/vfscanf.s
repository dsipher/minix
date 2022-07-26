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
	subq $368,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L206:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %rdx,-192(%rbp)
	movl $0,-248(%rbp)
	movl $0,-152(%rbp)
L208:
	movsbl (%r14),%ebx
	leaq 1(%r14),%rcx
	movq %rcx,%r14
	testl %ebx,%ebx
	jz L211
L209:
	movslq %ebx,%rax
	movq %rax,-176(%rbp)
	movq -176(%rbp),%rax
	testb $8,___ctype+1(%rax)
	jz L213
L215:
	decl (%r15)
	js L219
L218:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-336(%rbp)
	movq -336(%rbp),%rax
	movq %rax,24(%r15)
	movzbl (%rcx),%eax
	jmp L220
L219:
	movq %r15,%rdi
	call ___fillbuf
L220:
	movslq %eax,%rcx
	movq %rcx,-344(%rbp)
	movq -344(%rbp),%rcx
	testb $8,___ctype+1(%rcx)
	jz L217
L216:
	incl -248(%rbp)
	jmp L215
L217:
	cmpl $-1,%eax
	jz L211
L223:
	movq %r15,%rsi
	movl %eax,%edi
	call _ungetc
	jmp L208
L213:
	cmpl $37,%ebx
	jnz L229
L227:
	movl $0,-200(%rbp)
	movl $0,-160(%rbp)
	movl $0,-168(%rbp)
	movsbl (%rcx),%ebx
	leaq 1(%rcx),%r14
	cmpl $42,%ebx
	jnz L240
L238:
	movl $1,-160(%rbp)
	movsbl 1(%rcx),%ebx
	addq $2,%rcx
	movq %rcx,%r14
L240:
	movl %ebx,-352(%rbp)
	subl $48,-352(%rbp)
	cmpl $10,-352(%rbp)
	jae L242
L241:
	xorl %r13d,%r13d
L244:
	movl %ebx,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L243
L245:
	leal (%r13,%r13,4),%r13d
	addl %r13d,%r13d
	addl %ebx,%r13d
	subl $48,%r13d
	movsbl (%r14),%ebx
	incq %r14
	jmp L244
L242:
	movl $-1,%r13d
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
	movl %ebx,-200(%rbp)
	movsbl (%r14),%eax
	movl %eax,-184(%rbp)
	incq %r14
	movl -184(%rbp),%ebx
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
	decl (%r15)
	js L274
L273:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-264(%rbp)
	movq -264(%rbp),%rax
	movq %rax,24(%r15)
	movzbl (%rcx),%eax
	jmp L275
L274:
	movq %r15,%rdi
	call ___fillbuf
L275:
	movslq %eax,%rcx
	movq %rcx,-272(%rbp)
	movq -272(%rbp),%rcx
	testb $8,___ctype+1(%rcx)
	jz L272
L271:
	incl -248(%rbp)
	jmp L270
L272:
	movq %r15,%rsi
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
	movl $18,%r13d
	movl $16,%edx
	movl $112,-200(%rbp)
	jmp L294
L286:
	movl $8,%edx
	jmp L282
L435:
	movq -192(%rbp),%rax
	addq $8,%rax
	movq %rax,-296(%rbp)
	movq -192(%rbp),%rax
	movq (%rax),%rax
	movq %rax,-304(%rbp)
	cmpl $108,-200(%rbp)
	jnz L437
L436:
	movslq -248(%rbp),%rcx
	movq %rcx,-216(%rbp)
	movq -296(%rbp),%rax
	movq %rax,-192(%rbp)
	movq -216(%rbp),%rcx
	movq -304(%rbp),%rax
	movq %rcx,(%rax)
	jmp L208
L437:
	cmpl $104,-200(%rbp)
	jnz L440
L439:
	movq -296(%rbp),%rax
	movq %rax,-192(%rbp)
	movzwl -248(%rbp),%ecx
	movq -304(%rbp),%rax
	movw %cx,(%rax)
	jmp L208
L440:
	movq -296(%rbp),%rax
	movq %rax,-192(%rbp)
	movl -248(%rbp),%ecx
	movq -304(%rbp),%rax
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
	cmpl $-1,%r13d
	movl $1,%eax
	cmovzl %eax,%r13d
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
	cmpl $-1,%r13d
	jz L292
L295:
	cmpl $128,%r13d
	jle L294
L292:
	movl $128,%r13d
L294:
	leaq -136(%rbp),%r9
	movl -168(%rbp),%r8d
	movl %r13d,%ecx
	movq %r15,%rsi
	leaq -128(%rbp),%rdi
	call _lscan
	testl %eax,%eax
	jz L211
L301:
	addl -248(%rbp),%eax
	movl %eax,-248(%rbp)
	cmpl $0,-160(%rbp)
	jnz L208
L305:
	movq -192(%rbp),%rax
	addq $8,%rax
	movq %rax,-328(%rbp)
	movq -136(%rbp),%rcx
	movq %rcx,-320(%rbp)
	movq -192(%rbp),%rax
	movq (%rax),%rax
	movq %rax,-360(%rbp)
	cmpl $112,-200(%rbp)
	jnz L308
L307:
	movq -328(%rbp),%rax
	movq %rax,-192(%rbp)
	movq -320(%rbp),%rcx
	movq -360(%rbp),%rax
	movq %rcx,(%rax)
	jmp L309
L308:
	cmpl $108,-200(%rbp)
	jnz L311
L310:
	movq -328(%rbp),%rax
	movq %rax,-192(%rbp)
	movq -320(%rbp),%rcx
	movq -360(%rbp),%rax
	movq %rcx,(%rax)
	jmp L309
L311:
	cmpl $104,-200(%rbp)
	jnz L314
L313:
	movq -328(%rbp),%rax
	movq %rax,-192(%rbp)
	movzwl -320(%rbp),%ecx
	movq -360(%rbp),%rax
	movw %cx,(%rax)
	jmp L309
L314:
	movq -328(%rbp),%rax
	movq %rax,-192(%rbp)
	movl -320(%rbp),%ecx
	movq -360(%rbp),%rax
	movl %ecx,(%rax)
L309:
	incl -152(%rbp)
	jmp L208
L321:
	cmpl $-1,%r13d
	jz L322
L325:
	cmpl $128,%r13d
	jle L324
L322:
	movl $128,%r13d
L324:
	leaq -144(%rbp),%rcx
	movl %r13d,%edx
	movq %r15,%rsi
	leaq -128(%rbp),%rdi
	call _dscan
	testl %eax,%eax
	jz L211
L331:
	addl -248(%rbp),%eax
	movl %eax,-248(%rbp)
	cmpl $0,-160(%rbp)
	jnz L208
L335:
	cmpl $108,-200(%rbp)
	jz L337
L340:
	cmpl $76,-200(%rbp)
	jnz L338
L337:
	movq -192(%rbp),%rax
	addq $8,%rax
	movq %rax,-192(%rbp)
	movq -8(%rax),%rax
	movq %rax,-224(%rbp)
	movsd -144(%rbp),%xmm0
	movq -224(%rbp),%rax
	movsd %xmm0,(%rax)
	jmp L339
L338:
	cvtsd2ss -144(%rbp),%xmm0
	movq -192(%rbp),%rax
	addq $8,%rax
	movq %rax,-192(%rbp)
	movq -8(%rax),%rax
	movq %rax,-232(%rbp)
	movq -232(%rbp),%rax
	movss %xmm0,(%rax)
L339:
	incl -152(%rbp)
	jmp L208
L229:
	decl (%r15)
	js L234
L233:
	movq 24(%r15),%rax
	movq %rax,-240(%rbp)
	movq -240(%rbp),%rax
	incq %rax
	movq %rax,-208(%rbp)
	movq -208(%rbp),%rax
	movq %rax,24(%r15)
	movq -240(%rbp),%rax
	movzbl (%rax),%eax
	jmp L235
L234:
	movq %r15,%rdi
	call ___fillbuf
L235:
	cmpl %eax,%ebx
	jnz L230
L232:
	incl -248(%rbp)
	jmp L208
L230:
	movq %r15,%rsi
	movl %eax,%edi
	call _ungetc
	jmp L211
L396:
	movl $0,-168(%rbp)
	movsbl (%r14),%ecx
	incq %r14
	cmpl $94,%ecx
	jnz L399
L397:
	movl $1,-168(%rbp)
	movsbl (%r14),%ecx
	incq %r14
L399:
	leaq -128(%rbp),%r12
	cmpl $93,%ecx
	jnz L403
L400:
	movb %cl,-128(%rbp)
	leaq -127(%rbp),%r12
	movsbl (%r14),%ecx
	incq %r14
L403:
	testl %ecx,%ecx
	jz L405
L406:
	cmpl $93,%ecx
	jz L405
L404:
	cmpl $45,%ecx
	jnz L411
L417:
	leaq -128(%rbp),%rax
	movq %rax,-312(%rbp)
	cmpq -312(%rbp),%r12
	jz L411
L413:
	movzbl (%r14),%eax
	cmpb $93,%al
	jz L411
L410:
	movsbl -1(%r12),%ecx
	movsbl %al,%eax
	incq %r14
	cmpl %eax,%ecx
	jg L421
L424:
	incl %ecx
	cmpl %ecx,%eax
	jl L412
L425:
	movb %cl,(%r12)
	incq %r12
	jmp L424
L421:
	decq %r12
	jmp L412
L411:
	movb %cl,(%r12)
	incq %r12
L412:
	movsbl (%r14),%ecx
	incq %r14
	jmp L403
L405:
	movb $0,(%r12)
	movl $91,%ebx
L346:
	cmpl $0,-160(%rbp)
	jnz L349
L347:
	movq -192(%rbp),%rax
	addq $8,%rax
	movq %rax,-192(%rbp)
	movq -8(%rax),%r12
L349:
	movl $0,-256(%rbp)
L350:
	cmpl $0,%r13d
	jl L351
L354:
	cmpl -256(%rbp),%r13d
	jle L353
L351:
	decl (%r15)
	js L362
L361:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-280(%rbp)
	movq -280(%rbp),%rax
	movq %rax,24(%r15)
	movzbl (%rcx),%eax
	movl %eax,-368(%rbp)
	jmp L363
L362:
	movq %r15,%rdi
	call ___fillbuf
	movl %eax,-368(%rbp)
L363:
	cmpl $-1,-368(%rbp)
	jz L353
L360:
	cmpl $115,%ebx
	jnz L368
L372:
	movslq -368(%rbp),%rax
	movq %rax,-288(%rbp)
	movq -288(%rbp),%rax
	testb $8,___ctype+1(%rax)
	jnz L365
L368:
	cmpl $91,%ebx
	jnz L367
L376:
	movl -368(%rbp),%esi
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
	movzbl -368(%rbp),%eax
	movb %al,(%r12)
	incq %r12
L383:
	incl -256(%rbp)
	jmp L350
L365:
	movq %r15,%rsi
	movl -368(%rbp),%edi
	call _ungetc
L353:
	cmpl $0,-256(%rbp)
	jz L211
L386:
	movl -256(%rbp),%eax
	addl %eax,-248(%rbp)
	cmpl $0,-160(%rbp)
	jnz L208
L390:
	cmpl $99,%ebx
	jz L394
L392:
	movb $0,(%r12)
L394:
	incl -152(%rbp)
	jmp L208
L211:
	cmpl $0,-152(%rbp)
	jnz L448
L450:
	testl $16,8(%r15)
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
