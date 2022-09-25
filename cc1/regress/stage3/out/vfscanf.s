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
	movl %edx,-12(%rbp)
	movq %rcx,-8(%rbp)
	movq %r15,%rbx
	xorl %r13d,%r13d
	xorl %r12d,%r12d
L4:
	cmpl %r13d,-12(%rbp)
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
	jz L100
L19:
	cmpl $6,%r12d
	jz L100
	jnz L12
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
L100:
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
L101:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L102:
	movq %rdi,-32(%rbp)
	movq %rsi,%r15
	movl %edx,%r14d
	movl %ecx,-20(%rbp)
	movl %r8d,-4(%rbp)
	movq %r9,-16(%rbp)
	movq -32(%rbp),%rbx
	testl %r14d,%r14d
	jnz L105
L104:
	xorl %r13d,%r13d
	jmp L106
L105:
	cmpl $16,%r14d
	movl $3,%eax
	movl $6,%r13d
	cmovnzl %eax,%r13d
L106:
	xorl %r12d,%r12d
	jmp L110
L111:
	decl (%r15)
	js L115
L114:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movzbl (%rcx),%eax
	jmp L116
L115:
	movq %r15,%rdi
	call ___fillbuf
L116:
	movb %al,(%rbx)
	incq %rbx
	cmpl $43,%eax
	jz L121
	jl L117
L200:
	cmpl $120,%eax
	jz L151
	jg L117
L201:
	cmpb $45,%al
	jz L121
L202:
	cmpb $48,%al
	jz L135
L203:
	cmpb $88,%al
	jz L151
	jnz L117
L135:
	cmpl $1,%r13d
	jg L137
L136:
	movl $2,%r13d
	jmp L112
L137:
	cmpl $2,%r13d
	jnz L140
L139:
	movl $8,%r14d
	jmp L198
L140:
	cmpl $5,%r13d
	jle L198
L145:
	cmpl $8,%r13d
	jz L198
L143:
	movl $8,%r13d
	jmp L112
L151:
	cmpl $2,%r13d
	jnz L153
L152:
	movl $16,%r14d
	jmp L198
L153:
	cmpl $8,%r13d
	jz L198
	jnz L118
L117:
	movl %eax,%ecx
	subl $48,%ecx
	cmpl $2,%r13d
	jle L160
L162:
	cmpl $10,%ecx
	jae L175
L179:
	cmpl %ecx,%r14d
	jg L198
L175:
	movl %eax,%ecx
	subl $97,%ecx
	cmpl $26,%ecx
	jae L171
L183:
	movl %eax,%ecx
	subl $87,%ecx
	cmpl %ecx,%r14d
	jg L198
L171:
	movl %eax,%ecx
	subl $65,%ecx
	cmpl $26,%ecx
	jae L118
L187:
	movl %eax,%ecx
	subl $55,%ecx
	cmpl %ecx,%r14d
	jg L198
	jle L118
L160:
	cmpl $10,%ecx
	jae L118
L163:
	movl $10,%r14d
L198:
	movl $5,%r13d
	jmp L112
L121:
	testl %r13d,%r13d
	jz L124
L129:
	cmpl $3,%r13d
	jz L124
L125:
	cmpl $6,%r13d
	jz L124
L118:
	decq %rbx
	movq %r15,%rsi
	movl %eax,%edi
	call _ungetc
	jmp L113
L124:
	incl %r13d
L112:
	incl %r12d
L110:
	cmpl %r12d,-20(%rbp)
	jg L111
L113:
	movb $0,(%rbx)
	cmpl $0,-4(%rbp)
	jz L195
L194:
	movl %r14d,%edx
	xorl %esi,%esi
	movq -32(%rbp),%rdi
	call _strtol
	jmp L206
L195:
	movl %r14d,%edx
	xorl %esi,%esi
	movq -32(%rbp),%rdi
	call _strtoul
L206:
	movq -16(%rbp),%rcx
	movq %rax,(%rcx)
	subq -32(%rbp),%rbx
	movl %ebx,%eax
L103:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.align 2
L469:
	.short L430-_vfscanf
	.short L283-_vfscanf
	.short L323-_vfscanf
	.short L323-_vfscanf
	.short L323-_vfscanf
	.short L213-_vfscanf
	.short L286-_vfscanf
	.short L213-_vfscanf
	.short L213-_vfscanf
	.short L213-_vfscanf
	.short L213-_vfscanf
	.short L437-_vfscanf
	.short L288-_vfscanf
	.short L435-_vfscanf
	.short L213-_vfscanf
	.short L213-_vfscanf
	.short L348-_vfscanf
	.short L213-_vfscanf
	.short L290-_vfscanf
	.short L213-_vfscanf
	.short L213-_vfscanf
	.short L293-_vfscanf

_vfscanf:
L207:
	pushq %rbp
	movq %rsp,%rbp
	subq $200,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L208:
	movq %rdi,%r15
	movq %rsi,-184(%rbp)
	movq %rdx,-168(%rbp)
	xorl %eax,%eax
	movq %rax,-176(%rbp)
	movl $0,-148(%rbp)
L210:
	movq -184(%rbp),%rax
	movsbl (%rax),%ecx
	incq %rax
	movq %rax,-184(%rbp)
	movl %ecx,%r14d
	testl %ecx,%ecx
	jz L213
L211:
	movslq %ecx,%rcx
	testb $8,___ctype+1(%rcx)
	jz L215
L217:
	decl (%r15)
	js L221
L220:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movzbl (%rcx),%eax
	jmp L222
L221:
	movq %r15,%rdi
	call ___fillbuf
L222:
	movslq %eax,%rax
	testb $8,___ctype+1(%rax)
	jz L219
L218:
	movq -176(%rbp),%rax
	incl %eax
	movq %rax,-176(%rbp)
	jmp L217
L219:
	cmpl $-1,%eax
	jz L213
L225:
	movq %r15,%rsi
	movl %eax,%edi
	call _ungetc
	jmp L210
L215:
	cmpl $37,%ecx
	jnz L231
L229:
	movl $0,-188(%rbp)
	movl $0,-152(%rbp)
	movl $0,-156(%rbp)
	movsbl (%rax),%r14d
	leaq 1(%rax),%rcx
	movq %rcx,-184(%rbp)
	cmpl $42,%r14d
	jnz L242
L240:
	movl $1,-152(%rbp)
	movsbl 1(%rax),%r14d
	addq $2,%rax
	movq %rax,-184(%rbp)
L242:
	movl %r14d,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L244
L243:
	xorl %r13d,%r13d
L246:
	movl %r14d,%eax
	subl $48,%eax
	cmpl $10,%eax
	jae L245
L247:
	leal (%r13,%r13,4),%r13d
	addl %r13d,%r13d
	addl %r14d,%r13d
	subl $48,%r13d
	movq -184(%rbp),%rax
	movsbl (%rax),%r14d
	incq %rax
	movq %rax,-184(%rbp)
	jmp L246
L244:
	movl $-1,%r13d
L245:
	cmpl $104,%r14d
	jz L250
L257:
	cmpl $108,%r14d
	jz L250
L253:
	cmpl $76,%r14d
	jnz L252
L250:
	movl %r14d,-188(%rbp)
	movq -184(%rbp),%rax
	movsbl (%rax),%eax
	movl %eax,-160(%rbp)
	incq -184(%rbp)
	movl -160(%rbp),%r14d
L252:
	cmpl $91,%r14d
	jz L263
L268:
	cmpl $99,%r14d
	jz L263
L264:
	cmpl $110,%r14d
	jz L263
L272:
	decl (%r15)
	js L276
L275:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movzbl (%rcx),%eax
	jmp L277
L276:
	movq %r15,%rdi
	call ___fillbuf
L277:
	movslq %eax,%rax
	testb $8,___ctype+1(%rax)
	jz L274
L273:
	movq -176(%rbp),%rax
	incl %eax
	movq %rax,-176(%rbp)
	jmp L272
L274:
	movq %r15,%rsi
	movl %eax,%edi
	call _ungetc
L263:
	cmpl $99,%r14d
	jl L458
L460:
	cmpl $120,%r14d
	jg L458
L457:
	leal -99(%r14),%eax
	movzwl L469(,%rax,2),%eax
	addl $_vfscanf,%eax
	jmp *%rax
L290:
	movl $10,%edx
	jmp L284
L435:
	movl $18,%r13d
	movl $16,%edx
	movl $112,-188(%rbp)
	jmp L296
L288:
	movl $8,%edx
	jmp L284
L437:
	movq -168(%rbp),%rax
	leaq 8(%rax),%rdx
	movq (%rax),%rcx
	cmpl $108,-188(%rbp)
	jnz L439
L438:
	movq -176(%rbp),%rax
	movslq %eax,%rax
	movq %rax,-176(%rbp)
	movq %rdx,-168(%rbp)
	movq -176(%rbp),%rax
	movq %rax,(%rcx)
	jmp L210
L439:
	cmpl $104,-188(%rbp)
	jnz L442
L441:
	movq %rdx,-168(%rbp)
	movq -176(%rbp),%rax
	movw %ax,(%rcx)
	jmp L210
L442:
	movq %rdx,-168(%rbp)
	movq -176(%rbp),%rax
	movl %eax,(%rcx)
	jmp L210
L286:
	xorl %edx,%edx
	jmp L472
L283:
	movl $10,%edx
L472:
	movl $1,-156(%rbp)
	jmp L284
L430:
	cmpl $-1,%r13d
	movl $1,%eax
	cmovzl %eax,%r13d
	jmp L348
L458:
	cmpl $0,%r14d
	jle L213
L462:
	cmpl $91,%r14d
	jz L398
	jg L213
L463:
	cmpb $37,%r14b
	jz L231
L464:
	cmpb $69,%r14b
	jz L323
L465:
	cmpb $71,%r14b
	jz L323
L466:
	cmpb $88,%r14b
	jnz L213
L293:
	movl $16,%edx
L284:
	cmpl $-1,%r13d
	jz L294
L297:
	cmpl $128,%r13d
	jle L296
L294:
	movl $128,%r13d
L296:
	leaq -136(%rbp),%r9
	movl -156(%rbp),%r8d
	movl %r13d,%ecx
	movq %r15,%rsi
	leaq -128(%rbp),%rdi
	call _lscan
	testl %eax,%eax
	jz L213
L303:
	movq -176(%rbp),%rcx
	addl %ecx,%eax
	movl %eax,%ecx
	movq %rcx,-176(%rbp)
	cmpl $0,-152(%rbp)
	jnz L210
L307:
	movq -168(%rbp),%rax
	addq $8,%rax
	movq -136(%rbp),%rdx
	movq -168(%rbp),%rcx
	movq (%rcx),%rcx
	cmpl $112,-188(%rbp)
	jz L470
L310:
	cmpl $108,-188(%rbp)
	jnz L313
L470:
	movq %rax,-168(%rbp)
	movq %rdx,(%rcx)
	jmp L471
L313:
	cmpl $104,-188(%rbp)
	jnz L316
L315:
	movq %rax,-168(%rbp)
	movw %dx,(%rcx)
	jmp L471
L316:
	movq %rax,-168(%rbp)
	movl %edx,(%rcx)
	jmp L471
L323:
	cmpl $-1,%r13d
	jz L324
L327:
	cmpl $128,%r13d
	jle L326
L324:
	movl $128,%r13d
L326:
	leaq -144(%rbp),%rcx
	movl %r13d,%edx
	movq %r15,%rsi
	leaq -128(%rbp),%rdi
	call _dscan
	testl %eax,%eax
	jz L213
L333:
	movq -176(%rbp),%rcx
	addl %ecx,%eax
	movl %eax,%ecx
	movq %rcx,-176(%rbp)
	cmpl $0,-152(%rbp)
	jnz L210
L337:
	cmpl $108,-188(%rbp)
	jz L339
L342:
	cmpl $76,-188(%rbp)
	jnz L340
L339:
	movq -168(%rbp),%rax
	addq $8,%rax
	movq %rax,-168(%rbp)
	movq -8(%rax),%rax
	movsd -144(%rbp),%xmm0
	movsd %xmm0,(%rax)
	jmp L471
L340:
	cvtsd2ss -144(%rbp),%xmm0
	movq -168(%rbp),%rax
	addq $8,%rax
	movq %rax,-168(%rbp)
	movq -8(%rax),%rax
	movss %xmm0,(%rax)
	jmp L471
L231:
	decl (%r15)
	js L236
L235:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movzbl (%rcx),%eax
	jmp L237
L236:
	movq %r15,%rdi
	call ___fillbuf
L237:
	cmpl %eax,%r14d
	jnz L232
L234:
	movq -176(%rbp),%rax
	incl %eax
	movq %rax,-176(%rbp)
	jmp L210
L232:
	movq %r15,%rsi
	movl %eax,%edi
	call _ungetc
	jmp L213
L398:
	movl $0,-156(%rbp)
	movq -184(%rbp),%rax
	movsbl (%rax),%edx
	incq %rax
	movq %rax,-184(%rbp)
	cmpl $94,%edx
	jnz L401
L399:
	movl $1,-156(%rbp)
	movq -184(%rbp),%rax
	movsbl (%rax),%edx
	incq %rax
	movq %rax,-184(%rbp)
L401:
	leaq -128(%rbp),%rax
	movq %rax,-200(%rbp)
	cmpl $93,%edx
	jnz L405
L402:
	movb %dl,-128(%rbp)
	leaq -127(%rbp),%rax
L474:
	movq %rax,-200(%rbp)
L473:
	movq -184(%rbp),%rax
	movsbl (%rax),%edx
	incq %rax
	movq %rax,-184(%rbp)
L405:
	testl %edx,%edx
	jz L407
L408:
	cmpl $93,%edx
	jz L407
L406:
	cmpl $45,%edx
	jnz L413
L419:
	leaq -128(%rbp),%rax
	cmpq %rax,-200(%rbp)
	jz L413
L415:
	movq -184(%rbp),%rax
	movb (%rax),%cl
	cmpb $93,%cl
	jz L413
L412:
	movq -200(%rbp),%rax
	movsbl -1(%rax),%edx
	movsbl %cl,%ecx
	incq -184(%rbp)
	cmpl %ecx,%edx
	jg L423
L426:
	incl %edx
	cmpl %edx,%ecx
	jl L473
L427:
	movq -200(%rbp),%rax
	movb %dl,(%rax)
	incq %rax
	movq %rax,-200(%rbp)
	jmp L426
L423:
	decq -200(%rbp)
	jmp L473
L413:
	movq -200(%rbp),%rax
	movb %dl,(%rax)
	incq %rax
	jmp L474
L407:
	movq -200(%rbp),%rax
	movb $0,(%rax)
	movl $91,%r14d
L348:
	cmpl $0,-152(%rbp)
	jnz L351
L349:
	movq -168(%rbp),%rax
	addq $8,%rax
	movq %rax,-168(%rbp)
	movq -8(%rax),%rax
	movq %rax,-200(%rbp)
L351:
	xorl %r12d,%r12d
L352:
	cmpl $0,%r13d
	jl L353
L356:
	cmpl %r12d,%r13d
	jle L355
L353:
	decl (%r15)
	js L364
L363:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movzbl (%rcx),%ebx
	jmp L365
L364:
	movq %r15,%rdi
	call ___fillbuf
	movl %eax,%ebx
L365:
	cmpl $-1,%ebx
	jz L355
L362:
	cmpl $115,%r14d
	jnz L370
L374:
	movslq %ebx,%rbx
	testb $8,___ctype+1(%rbx)
	jnz L367
L370:
	cmpl $91,%r14d
	jnz L369
L378:
	movl %ebx,%esi
	leaq -128(%rbp),%rdi
	call _strchr
	testq %rax,%rax
	setz %al
	movzbl %al,%eax
	cmpl %eax,-156(%rbp)
	jnz L367
L369:
	cmpl $0,-152(%rbp)
	jnz L385
L383:
	movq -200(%rbp),%rax
	movb %bl,(%rax)
	incq %rax
	movq %rax,-200(%rbp)
L385:
	incl %r12d
	jmp L352
L367:
	movq %r15,%rsi
	movl %ebx,%edi
	call _ungetc
L355:
	testl %r12d,%r12d
	jz L213
L388:
	movq -176(%rbp),%rax
	addl %r12d,%eax
	movq %rax,-176(%rbp)
	cmpl $0,-152(%rbp)
	jnz L210
L392:
	cmpl $99,%r14d
	jz L471
L394:
	movq -200(%rbp),%rax
	movb $0,(%rax)
L471:
	incl -148(%rbp)
	jmp L210
L213:
	cmpl $0,-148(%rbp)
	jnz L450
L452:
	testl $16,8(%r15)
	jz L450
L449:
	movl $-1,%eax
	jmp L209
L450:
	movl -148(%rbp),%eax
L209:
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
