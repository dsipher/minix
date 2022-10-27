.data
.align 4
_lineno:
	.int 1
.align 4
_bracecnt:
	.int 0
.align 4
_brackcnt:
	.int 0
.align 4
_parencnt:
	.int 0
.align 8
_keywords:
	.quad L1
	.int 261
	.int 261
	.quad L2
	.int 262
	.int 262
	.quad L3
	.int 332
	.int 332
	.quad L4
	.int 11
	.int 290
	.quad L5
	.int 291
	.int 291
	.quad L6
	.int 292
	.int 292
	.quad L7
	.int 293
	.int 293
	.quad L8
	.int 10
	.int 290
	.quad L9
	.int 294
	.int 294
	.quad L10
	.int 295
	.int 295
	.quad L11
	.int 323
	.int 323
	.quad L12
	.int 296
	.int 296
	.quad L13
	.int 3
	.int 290
	.quad L14
	.int 14
	.int 290
	.quad L15
	.int 297
	.int 297
	.quad L16
	.int 298
	.int 298
	.quad L17
	.int 298
	.int 298
	.quad L18
	.int 337
	.int 337
	.quad L19
	.int 300
	.int 300
	.quad L20
	.int 301
	.int 301
	.quad L21
	.int 288
	.int 288
	.quad L22
	.int 302
	.int 302
	.quad L23
	.int 5
	.int 290
	.quad L24
	.int 1
	.int 290
	.quad L25
	.int 4
	.int 290
	.quad L26
	.int 304
	.int 304
	.quad L27
	.int 305
	.int 305
	.quad L28
	.int 306
	.int 306
	.quad L29
	.int 320
	.int 320
	.quad L30
	.int 321
	.int 321
	.quad L31
	.int 7
	.int 290
	.quad L32
	.int 338
	.int 338
	.quad L33
	.int 9
	.int 290
	.quad L34
	.int 339
	.int 339
	.quad L35
	.int 322
	.int 322
	.quad L36
	.int 2
	.int 290
	.quad L37
	.int 8
	.int 290
	.quad L38
	.int 299
	.int 299
	.quad L39
	.int 340
	.int 340
	.quad L40
	.int 6
	.int 290
	.quad L41
	.int 13
	.int 290
	.quad L42
	.int 12
	.int 290
	.quad L43
	.int 341
	.int 341
.text

_peek:
L44:
	pushq %rbx
L45:
	call _input
	movl %eax,%ebx
	movl %ebx,%edi
	call _unput
	movl %ebx,%eax
L46:
	popq %rbx
	ret 


_gettok:
L48:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L49:
	movq %rdi,%r12
	movq (%r12),%rcx
	movq %rsi,%rbx
	movq %rcx,-8(%rbp)
	movl (%rbx),%eax
	movl %eax,-12(%rbp)
	movq %rcx,-24(%rbp)
	call _input
	testl %eax,%eax
	jz L51
L53:
	movq -8(%rbp),%rcx
	movb %al,(%rcx)
	movq -8(%rbp),%rcx
	movb $0,1(%rcx)
	movslq %eax,%rdx
	testb $7,___ctype+1(%rdx)
	jnz L57
L62:
	cmpl $46,%eax
	jz L57
L58:
	cmpl $95,%eax
	jnz L50
L57:
	movq -24(%rbp),%rsi
	leaq 1(%rsi),%rcx
	movq %rcx,-24(%rbp)
	movb %al,(%rsi)
	testb $3,___ctype+1(%rdx)
	jnz L74
L70:
	cmpl $95,%eax
	jnz L94
L74:
	call _input
	movl %eax,%r13d
	testl %r13d,%r13d
	jz L77
L75:
	movq -8(%rbp),%rax
	movq -24(%rbp),%rdx
	subq %rax,%rdx
	movslq -12(%rbp),%rax
	cmpq %rax,%rdx
	jl L80
L78:
	movl $L84,%r9d
	leaq -24(%rbp),%r8
	movl $100,%ecx
	addl $2,%edx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	testl %eax,%eax
	jnz L80
L81:
	pushq -8(%rbp)
	pushq $L85
	call _FATAL
	addq $16,%rsp
L80:
	movslq %r13d,%r13
	testb $7,___ctype+1(%r13)
	jnz L86
L89:
	cmpl $95,%r13d
	jnz L87
L86:
	movq -24(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-24(%rbp)
	movb %r13b,(%rcx)
	jmp L74
L87:
	movq -24(%rbp),%rax
	movb $0,(%rax)
	movl %r13d,%edi
	call _unput
L77:
	movq -24(%rbp),%rax
	movb $0,(%rax)
	movl $97,%r13d
	jmp L69
L94:
	call _input
	movl %eax,%r13d
	testl %r13d,%r13d
	jz L97
L95:
	movq -8(%rbp),%rax
	movq -24(%rbp),%rdx
	subq %rax,%rdx
	movslq -12(%rbp),%rax
	cmpq %rax,%rdx
	jl L100
L98:
	movl $L84,%r9d
	leaq -24(%rbp),%r8
	movl $100,%ecx
	addl $2,%edx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	testl %eax,%eax
	jnz L100
L101:
	pushq -8(%rbp)
	pushq $L104
	call _FATAL
	addq $16,%rsp
L100:
	movslq %r13d,%r13
	testb $4,___ctype+1(%r13)
	jnz L105
L124:
	cmpl $101,%r13d
	jz L105
L120:
	cmpl $69,%r13d
	jz L105
L116:
	cmpl $46,%r13d
	jz L105
L112:
	cmpl $43,%r13d
	jz L105
L108:
	cmpl $45,%r13d
	jnz L106
L105:
	movq -24(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-24(%rbp)
	movb %r13b,(%rcx)
	jmp L94
L106:
	movl %r13d,%edi
	call _unput
L97:
	movq -24(%rbp),%rax
	movb $0,(%rax)
	leaq -32(%rbp),%rsi
	movq -8(%rbp),%rdi
	call _strtod
	movq -8(%rbp),%rax
	movq -32(%rbp),%rdi
	cmpq %rdi,%rax
	jnz L130
L129:
	movb $0,1(%rax)
	movq -8(%rbp),%rax
	movsbl (%rax),%r13d
	movq -32(%rbp),%rdi
	incq %rdi
	call _unputstr
	jmp L69
L130:
	call _unputstr
	movq -32(%rbp),%rax
	movb $0,(%rax)
	movl $48,%r13d
L69:
	movq -8(%rbp),%rax
	movq %rax,(%r12)
	movl -12(%rbp),%eax
	movl %eax,(%rbx)
	movl %r13d,%eax
	jmp L50
L51:
	xorl %eax,%eax
L50:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 4
_sc:
	.int 0
.align 4
_reg:
	.int 0
.align 8
L136:
	.quad 0
.align 4
L137:
	.int 5
.text
L509:
	.quad 0x0
.align 2
L510:
	.short L158-_yylex
	.short L243-_yylex
	.short L493-_yylex
	.short L194-_yylex
	.short L403-_yylex
	.short L379-_yylex
	.short L219-_yylex
	.short L181-_yylex
	.short L488-_yylex
	.short L469-_yylex
	.short L348-_yylex
	.short L310-_yylex
	.short L181-_yylex
	.short L329-_yylex
	.short L181-_yylex
	.short L374-_yylex
	.short L181-_yylex
	.short L181-_yylex
	.short L181-_yylex
	.short L181-_yylex
	.short L181-_yylex
	.short L181-_yylex
	.short L181-_yylex
	.short L181-_yylex
	.short L181-_yylex
	.short L181-_yylex
	.short L181-_yylex
	.short L202-_yylex
	.short L267-_yylex
	.short L279-_yylex
	.short L291-_yylex
.align 4
L514:
	.int 9
	.int 10
	.int 13
	.int 91
	.int 92
	.int 93
	.int 94
	.int 123
	.int 124
	.int 125
	.int 126
.align 2
L515:
	.short L158-_yylex
	.short L184-_yylex
	.short L158-_yylex
	.short L483-_yylex
	.short L207-_yylex
	.short L460-_yylex
	.short L391-_yylex
	.short L478-_yylex
	.short L231-_yylex
	.short L451-_yylex
	.short L262-_yylex

_yylex:
L133:
	pushq %rbx
L134:
	cmpq $0,L136(%rip)
	jnz L140
L141:
	movslq L137(%rip),%rdi
	call _malloc
	movq %rax,L136(%rip)
	testq %rax,%rax
	jnz L140
L142:
	pushq $L145
	call _FATAL
	addq $8,%rsp
L140:
	cmpl $0,_sc(%rip)
	jnz L146
L148:
	cmpl $0,_reg(%rip)
	jnz L154
L158:
	movl $L137,%esi
	movl $L136,%edi
	call _gettok
	movl %eax,%ebx
	testl %ebx,%ebx
	jz L162
L164:
	movslq %ebx,%rbx
	movb ___ctype+1(%rbx),%al
	testb $3,%al
	jnz L170
L169:
	cmpl $95,%ebx
	jz L170
L171:
	testb $4,%al
	jnz L174
L176:
	movl %ebx,_yylval(%rip)
	cmpl $32,%ebx
	jl L506
L508:
	cmpl $62,%ebx
	jg L506
L505:
	leal -32(%rbx),%eax
	movzwl L510(,%rax,2),%eax
	addl $_yylex,%eax
	jmp *%rax
L194:
	call _input
	cmpl $10,%eax
	jz L199
L197:
	testl %eax,%eax
	jnz L194
L199:
	movl %eax,%edi
	call _unput
	jmp L158
L291:
	call _peek
	cmpl $61,%eax
	jnz L293
L292:
	call _input
	movl $283,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L297
L295:
	movl $283,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L297:
	movl $283,%eax
	jmp L135
L293:
	call _peek
	cmpl $62,%eax
	jnz L300
L299:
	call _input
	movl $281,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L304
L302:
	movl $281,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L304:
	movl $281,%eax
	jmp L135
L300:
	movl $284,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L308
L306:
	movl $284,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L308:
	movl $284,%eax
	jmp L135
L279:
	call _peek
	cmpl $61,%eax
	jnz L281
L280:
	call _input
	movl $282,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L285
L283:
	movl $282,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L285:
	movl $282,%eax
	jmp L135
L281:
	movl $312,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L502
	jnz L524
L267:
	call _peek
	cmpl $61,%eax
	jnz L269
L268:
	call _input
	movl $285,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L273
L271:
	movl $285,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L273:
	movl $285,%eax
	jmp L135
L269:
	movl $286,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L277
L275:
	movl $286,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L277:
	movl $286,%eax
	jmp L135
L202:
	cmpl $0,_dbg(%rip)
	jz L499
	jnz L527
L374:
	cmpl $0,_dbg(%rip)
	jz L377
L375:
	movl $47,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L377:
	movl $47,%eax
	jmp L135
L329:
	call _peek
	cmpl $45,%eax
	jnz L331
L330:
	call _input
	movl $346,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L335
L333:
	movl $346,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L335:
	movl $346,%eax
	jmp L135
L331:
	call _peek
	cmpl $61,%eax
	jnz L338
L337:
	call _input
	movl $315,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L502
	jnz L524
L338:
	cmpl $0,_dbg(%rip)
	jz L346
L344:
	movl $45,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L346:
	movl $45,%eax
	jmp L135
L310:
	call _peek
	cmpl $43,%eax
	jnz L312
L311:
	call _input
	movl $347,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L316
L314:
	movl $347,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L316:
	movl $347,%eax
	jmp L135
L312:
	call _peek
	cmpl $61,%eax
	jnz L319
L318:
	call _input
	movl $314,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L502
	jnz L524
L319:
	cmpl $0,_dbg(%rip)
	jz L327
L325:
	movl $43,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L327:
	movl $43,%eax
	jmp L135
L348:
	call _peek
	cmpl $61,%eax
	jnz L350
L349:
	call _input
	movl $316,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L502
	jnz L524
L350:
	call _peek
	cmpl $42,%eax
	jnz L357
L356:
	call _input
	call _peek
	cmpl $61,%eax
	jnz L360
L359:
	call _input
	movl $319,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L502
	jnz L524
L360:
	cmpl $0,_dbg(%rip)
	jz L503
	jnz L523
L357:
	cmpl $0,_dbg(%rip)
	jz L372
L370:
	movl $42,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L372:
	movl $42,%eax
	jmp L135
L469:
	decl _parencnt(%rip)
	jns L472
L470:
	pushq $L473
	call _SYNTAX
	addq $8,%rsp
L472:
	cmpl $0,_dbg(%rip)
	jz L476
L474:
	movl $41,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L476:
	movl $41,%eax
	jmp L135
L488:
	incl _parencnt(%rip)
	cmpl $0,_dbg(%rip)
	jz L491
L489:
	movl $40,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L491:
	movl $40,%eax
	jmp L135
L219:
	call _peek
	cmpl $38,%eax
	jnz L221
L220:
	call _input
	cmpl $0,_dbg(%rip)
	jz L225
L223:
	movl $279,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L225:
	movl $279,%eax
	jmp L135
L221:
	cmpl $0,_dbg(%rip)
	jz L229
L227:
	movl $38,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L229:
	movl $38,%eax
	jmp L135
L379:
	call _peek
	cmpl $61,%eax
	jnz L381
L380:
	call _input
	movl $318,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L502
	jnz L524
L381:
	cmpl $0,_dbg(%rip)
	jz L389
L387:
	movl $37,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L389:
	movl $37,%eax
	jmp L135
L403:
	movl $L137,%esi
	movl $L136,%edi
	call _gettok
	movslq %eax,%rax
	testb $3,___ctype+1(%rax)
	jz L405
L404:
	movl $L3,%esi
	movq L136(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jz L407
L409:
	call _peek
	cmpl $40,%eax
	jz L419
L422:
	cmpl $91,%eax
	jz L419
L424:
	cmpl $0,_infunc(%rip)
	jz L428
L426:
	movq L136(%rip),%rdi
	call _isarg
	cmpl $0,%eax
	jl L428
L419:
	movq L136(%rip),%rdi
	call _unputstr
	cmpl $0,_dbg(%rip)
	jz L504
	jnz L522
L428:
	movq L136(%rip),%rdi
	movq _symtab(%rip),%rcx
	movl $3,%edx
	movsd L509(%rip),%xmm0
	movl $L434,%esi
	call _setsymtab
	movq %rax,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L437
L435:
	movl $331,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L437:
	movl $331,%eax
	jmp L135
L407:
	movl $L410,%edi
	call _unputstr
	cmpl $0,_dbg(%rip)
	jz L504
	jnz L522
L405:
	testl %eax,%eax
	jnz L440
L439:
	pushq $L442
	call _SYNTAX
	addq $8,%rsp
	cmpl $0,_dbg(%rip)
	jz L499
	jnz L527
L440:
	movq L136(%rip),%rdi
	call _unputstr
	cmpl $0,_dbg(%rip)
	jz L504
L522:
	movl $348,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L504:
	movl $348,%eax
	jmp L135
L493:
	call _string
	jmp L135
L243:
	call _peek
	cmpl $61,%eax
	jnz L245
L244:
	call _input
	movl $287,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L249
L247:
	movl $287,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L249:
	movl $287,%eax
	jmp L135
L245:
	call _peek
	cmpl $126,%eax
	jnz L252
L251:
	call _input
	movl $266,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L501
	jnz L525
L252:
	cmpl $0,_dbg(%rip)
	jz L260
L258:
	movl $343,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L260:
	movl $343,%eax
	jmp L135
L506:
	xorl %eax,%eax
L511:
	cmpl L514(,%rax,4),%ebx
	jz L512
L513:
	incl %eax
	cmpl $11,%eax
	jb L511
	jae L181
L512:
	movzwl L515(,%rax,2),%eax
	addl $_yylex,%eax
	jmp *%rax
L207:
	call _peek
	cmpl $10,%eax
	jnz L209
L208:
	call _input
	jmp L158
L209:
	call _peek
	cmpl $13,%eax
	jnz L212
L211:
	call _input
	call _input
	incl _lineno(%rip)
	jmp L158
L212:
	cmpl $0,_dbg(%rip)
	jz L500
	jnz L526
L262:
	movl $265,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L501
L525:
	movl $267,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L501:
	movl $267,%eax
	jmp L135
L451:
	decl _bracecnt(%rip)
	jns L454
L452:
	pushq $L455
	call _SYNTAX
	addq $8,%rsp
L454:
	movl $1,_sc(%rip)
	cmpl $0,_dbg(%rip)
	jz L499
L527:
	movl $59,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L499:
	movl $59,%eax
	jmp L135
L231:
	call _peek
	cmpl $124,%eax
	jnz L233
L232:
	call _input
	cmpl $0,_dbg(%rip)
	jz L237
L235:
	movl $280,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L237:
	movl $280,%eax
	jmp L135
L233:
	cmpl $0,_dbg(%rip)
	jz L241
L239:
	movl $124,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L241:
	movl $124,%eax
	jmp L135
L478:
	incl _bracecnt(%rip)
	cmpl $0,_dbg(%rip)
	jz L481
L479:
	movl $123,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L481:
	movl $123,%eax
	jmp L135
L391:
	call _peek
	cmpl $61,%eax
	jnz L393
L392:
	call _input
	movl $319,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L502
L524:
	movl $313,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L502:
	movl $313,%eax
	jmp L135
L393:
	cmpl $0,_dbg(%rip)
	jz L503
L523:
	movl $345,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L503:
	movl $345,%eax
	jmp L135
L460:
	decl _brackcnt(%rip)
	jns L463
L461:
	pushq $L464
	call _SYNTAX
	addq $8,%rsp
L463:
	cmpl $0,_dbg(%rip)
	jz L467
L465:
	movl $93,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L467:
	movl $93,%eax
	jmp L135
L483:
	incl _brackcnt(%rip)
	cmpl $0,_dbg(%rip)
	jz L486
L484:
	movl $91,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L486:
	movl $91,%eax
	jmp L135
L184:
	cmpl $0,_dbg(%rip)
	jz L187
L185:
	movl $263,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L187:
	movl $263,%eax
	jmp L135
L181:
	cmpl $0,_dbg(%rip)
	jz L500
L526:
	movl %ebx,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L500:
	movl %ebx,%eax
	jmp L135
L174:
	movq L136(%rip),%rdi
	call _tostring
	movq %rax,%rbx
	movq L136(%rip),%rdi
	call _atof
	movq L136(%rip),%rdi
	movq _symtab(%rip),%rcx
	movl $9,%edx
	movq %rbx,%rsi
	call _setsymtab
	movq %rax,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L179
L177:
	movl $334,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L179:
	movl $334,%eax
	jmp L135
L170:
	movq L136(%rip),%rdi
	call _word
	jmp L135
L162:
	xorl %eax,%eax
	jmp L135
L154:
	movl $0,_reg(%rip)
	call _regexpr
	jmp L135
L146:
	movl $0,_sc(%rip)
	cmpl $0,_dbg(%rip)
	jz L151
L149:
	movl $125,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L151:
	movl $125,%eax
L135:
	popq %rbx
	ret 

.data
.align 8
L531:
	.quad 0
.align 4
L532:
	.int 500
.text
.align 2
L667:
	.short L591-_string
	.short L591-_string
	.short L591-_string
	.short L591-_string
	.short L591-_string
	.short L591-_string
	.short L591-_string
	.short L591-_string

_string:
L528:
	pushq %rbp
	movq %rsp,%rbp
	subq $112,%rsp
	pushq %rbx
L529:
	cmpq $0,L531(%rip)
	jnz L535
L536:
	movslq L532(%rip),%rdi
	call _malloc
	movq %rax,L531(%rip)
	testq %rax,%rax
	jnz L535
L533:
	pushq $L540
	call _FATAL
	addq $8,%rsp
L535:
	movq L531(%rip),%rax
	movq %rax,-8(%rbp)
L541:
	call _input
	movl %eax,%ebx
	movq -8(%rbp),%rdx
	cmpl $34,%ebx
	jz L544
L542:
	subq L531(%rip),%rdx
	movl $L548,%r9d
	leaq -8(%rbp),%r8
	movl $500,%ecx
	addl $2,%edx
	movl $L532,%esi
	movl $L531,%edi
	call _adjbuf
	testl %eax,%eax
	jnz L547
L545:
	pushq L531(%rip)
	pushq $L549
	call _FATAL
	addq $16,%rsp
L547:
	cmpl $10,%ebx
	jz L555
L646:
	cmpl $13,%ebx
	jz L555
L647:
	testl %ebx,%ebx
	jz L555
L648:
	cmpl $92,%ebx
	jz L562
L649:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb %bl,(%rcx)
	jmp L541
L562:
	call _input
	cmpl $48,%eax
	jl L652
L654:
	cmpl $55,%eax
	jg L652
L651:
	leal -48(%rax),%ecx
	movzwl L667(,%rcx,2),%ecx
	addl $_string,%ecx
	jmp *%rcx
L591:
	subl $48,%eax
	movl %eax,-112(%rbp)
	call _peek
	cmpl $48,%eax
	jl L668
L595:
	cmpl $56,%eax
	jge L668
L592:
	movl -112(%rbp),%ebx
	call _input
	leal (%rax,%rbx,8),%eax
	subl $48,%eax
	movl %eax,-112(%rbp)
	call _peek
	cmpl $48,%eax
	jl L668
L602:
	cmpl $56,%eax
	jge L668
L599:
	movl -112(%rbp),%ebx
	call _input
	leal (%rax,%rbx,8),%eax
	subl $48,%eax
	movl %eax,-112(%rbp)
	jmp L668
L652:
	cmpl $34,%eax
	jz L566
	jl L563
L656:
	cmpl $120,%eax
	jz L607
	jg L563
L657:
	cmpb $92,%al
	jz L582
L658:
	cmpb $97,%al
	jz L580
L659:
	cmpb $98,%al
	jz L576
L660:
	cmpb $102,%al
	jz L572
L661:
	cmpb $110,%al
	jz L568
L662:
	cmpb $114,%al
	jz L574
L663:
	cmpb $116,%al
	jz L570
L664:
	cmpb $118,%al
	jnz L563
L578:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $11,(%rcx)
	jmp L541
L570:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $9,(%rcx)
	jmp L541
L574:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $13,(%rcx)
	jmp L541
L568:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $10,(%rcx)
	jmp L541
L572:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $12,(%rcx)
	jmp L541
L576:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $8,(%rcx)
	jmp L541
L580:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $7,(%rcx)
	jmp L541
L582:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $92,(%rcx)
	jmp L541
L607:
	leaq -108(%rbp),%rbx
	jmp L608
L612:
	leaq -108(%rbp),%rdx
	movq %rbx,%rcx
	subq %rdx,%rcx
	cmpq $98,%rcx
	jge L611
L609:
	movslq %eax,%rax
	testb $4,___ctype+1(%rax)
	jnz L616
L623:
	cmpl $97,%eax
	jl L619
L627:
	cmpl $102,%eax
	jle L616
L619:
	cmpl $65,%eax
	jl L611
L631:
	cmpl $70,%eax
	jg L611
L616:
	movb %al,(%rbx)
	incq %rbx
L608:
	call _input
	testl %eax,%eax
	jnz L612
L611:
	movb $0,(%rbx)
	movl %eax,%edi
	call _unput
	leaq -108(%rbp),%rcx
	leaq -112(%rbp),%rax
	pushq %rax
	pushq $L636
	pushq %rcx
	call _sscanf
	addq $24,%rsp
L668:
	movb -112(%rbp),%cl
	movq -8(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-8(%rbp)
	movb %cl,(%rdx)
	jmp L541
L563:
	movq -8(%rbp),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,-8(%rbp)
	movb %al,(%rdx)
	jmp L541
L566:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $34,(%rcx)
	jmp L541
L555:
	pushq L531(%rip)
	pushq $L556
	call _SYNTAX
	addq $16,%rsp
	incl _lineno(%rip)
	testl %ebx,%ebx
	jnz L541
L557:
	pushq $L560
	call _FATAL
	addq $8,%rsp
	jmp L541
L544:
	movb $0,(%rdx)
	movq L531(%rip),%rdi
	call _tostring
	movq -8(%rbp),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,-8(%rbp)
	movb $32,(%rdx)
	movq -8(%rbp),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,-8(%rbp)
	movb $0,(%rdx)
	movq L531(%rip),%rdi
	movq _symtab(%rip),%rcx
	movl $14,%edx
	movsd L509(%rip),%xmm0
	movq %rax,%rsi
	call _setsymtab
	movq %rax,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L643
L641:
	movl $335,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L643:
	movl $335,%eax
L530:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_binsearch:
L669:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L670:
	movq %rdi,%r14
	movq %rsi,%r13
	xorl %r12d,%r12d
	decl %edx
	movl %edx,%ebx
L672:
	cmpl %ebx,%r12d
	jg L674
L673:
	movl $2,%ecx
	leal (%rbx,%r12),%eax
	cltd 
	idivl %ecx
	movl %eax,%r15d
	movslq %r15d,%rax
	shlq $4,%rax
	movq (%rax,%r13),%rsi
	movq %r14,%rdi
	call _strcmp
	cmpl $0,%eax
	jl L675
	jz L679
L678:
	leal 1(%r15),%r12d
	jmp L672
L675:
	decl %r15d
	movl %r15d,%ebx
	jmp L672
L679:
	movl %r15d,%eax
	jmp L671
L674:
	movl $-1,%eax
L671:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_word:
L683:
	pushq %rbx
	pushq %r12
L684:
	movq %rdi,%r12
	movl $43,%edx
	movl $_keywords,%esi
	movq %r12,%rdi
	call _binsearch
	movslq %eax,%rbx
	shlq $4,%rbx
	cmpl $-1,%eax
	jnz L686
L688:
	call _peek
	movl %eax,%ebx
	cmpl $40,%ebx
	jz L733
L739:
	cmpl $0,_infunc(%rip)
	jz L733
L735:
	movq %r12,%rdi
	call _isarg
	cmpl $0,%eax
	jl L733
L732:
	movl %eax,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L745
L743:
	movl $289,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L745:
	movl $289,%eax
	jmp L685
L733:
	movq _symtab(%rip),%rcx
	movl $7,%edx
	movsd L509(%rip),%xmm0
	movl $L434,%esi
	movq %r12,%rdi
	call _setsymtab
	movq %rax,_yylval(%rip)
	movl _dbg(%rip),%eax
	cmpl $40,%ebx
	jnz L748
L747:
	testl %eax,%eax
	jz L752
L750:
	movl $333,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L752:
	movl $333,%eax
	jmp L685
L748:
	testl %eax,%eax
	jz L756
L754:
	movl $330,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L756:
	movl $330,%eax
	jmp L685
L686:
	movl _keywords+8(%rbx),%eax
	movl %eax,_yylval(%rip)
	movl _keywords+12(%rbx),%edi
	cmpl $290,%edi
	jz L692
L759:
	cmpl $298,%edi
	jz L705
L760:
	cmpl $338,%edi
	jz L714
L761:
	cmpl $332,%edi
	jz L723
L762:
	cmpl $0,_dbg(%rip)
	jz L764
L728:
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
	jmp L764
L723:
	movq _symtab(%rip),%rcx
	movl $1,%edx
	movsd L509(%rip),%xmm0
	movl $L434,%esi
	movl $L3,%edi
	call _setsymtab
	movq %rax,_yylval(%rip)
	cmpl $0,_dbg(%rip)
	jz L726
L724:
	movl $332,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L726:
	movl $332,%eax
	jmp L685
L714:
	cmpl $0,_infunc(%rip)
	jnz L717
L715:
	pushq $L718
	call _SYNTAX
	addq $8,%rsp
L717:
	cmpl $0,_dbg(%rip)
	jz L764
L719:
	movl _keywords+12(%rbx),%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
	jmp L764
L705:
	cmpl $0,_infunc(%rip)
	jz L708
L706:
	pushq $L709
	call _SYNTAX
	addq $8,%rsp
L708:
	cmpl $0,_dbg(%rip)
	jz L764
L710:
	movl _keywords+12(%rbx),%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
	jmp L764
L692:
	cmpl $6,_keywords+8(%rbx)
	jnz L695
L696:
	cmpl $0,_safe(%rip)
	jz L695
L693:
	pushq $L700
	call _SYNTAX
	addq $8,%rsp
L695:
	cmpl $0,_dbg(%rip)
	jz L764
L701:
	movl _keywords+12(%rbx),%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L764:
	movl _keywords+12(%rbx),%eax
L685:
	popq %r12
	popq %rbx
	ret 


_startreg:
L765:
L766:
	movl $1,_reg(%rip)
L767:
	ret 

.data
.align 8
L771:
	.quad 0
.align 4
L772:
	.int 500
.text

_regexpr:
L768:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L769:
	cmpq $0,L771(%rip)
	jnz L775
L776:
	movslq L772(%rip),%rdi
	call _malloc
	movq %rax,L771(%rip)
	testq %rax,%rax
	jnz L775
L773:
	pushq $L780
	call _FATAL
	addq $8,%rsp
L775:
	movq L771(%rip),%rax
	movq %rax,-8(%rbp)
L781:
	call _input
	movl %eax,%ebx
	cmpl $47,%ebx
	jz L784
L785:
	testl %ebx,%ebx
	jz L784
L782:
	movq L771(%rip),%rax
	movq -8(%rbp),%rdx
	subq %rax,%rdx
	movl $L792,%r9d
	leaq -8(%rbp),%r8
	movl $500,%ecx
	addl $3,%edx
	movl $L772,%esi
	movl $L771,%edi
	call _adjbuf
	testl %eax,%eax
	jnz L791
L789:
	pushq L771(%rip)
	pushq $L793
	call _FATAL
	addq $16,%rsp
L791:
	cmpl $10,%ebx
	jz L794
L795:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	cmpl $92,%ebx
	jnz L800
L799:
	movq %rax,-8(%rbp)
	movb $92,(%rcx)
	call _input
	movq -8(%rbp),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,-8(%rbp)
	movb %al,(%rdx)
	jmp L781
L800:
	movq %rax,-8(%rbp)
	movb %bl,(%rcx)
	jmp L781
L794:
	pushq L771(%rip)
	pushq $L797
	call _SYNTAX
	addq $16,%rsp
	movl $10,%edi
	call _unput
L784:
	movq -8(%rbp),%rax
	movb $0,(%rax)
	testl %ebx,%ebx
	jnz L804
L802:
	pushq L771(%rip)
	pushq $L805
	call _SYNTAX
	addq $16,%rsp
L804:
	movq L771(%rip),%rdi
	call _tostring
	movq %rax,_yylval(%rip)
	movl $47,%edi
	call _unput
	cmpl $0,_dbg(%rip)
	jz L808
L806:
	movl $336,%edi
	call _tokname
	pushq %rax
	pushq $L152
	call _printf
	addq $16,%rsp
L808:
	movl $336,%eax
L770:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
_ep:
	.quad _ebuf
.align 8
_yysptr:
	.quad _yysbuf
.align 8
_yyin:
	.quad 0
.text

_input:
L810:
L811:
	movq _yysptr(%rip),%rcx
	cmpq $_yysbuf,%rcx
	jbe L814
L813:
	leaq -1(%rcx),%rax
	movq %rax,_yysptr(%rip)
	movzbl -1(%rcx),%eax
	jmp L815
L814:
	movq _lexprog(%rip),%rcx
	testq %rcx,%rcx
	jz L817
L816:
	movzbl (%rcx),%eax
	testl %eax,%eax
	jz L815
L819:
	incq %rcx
	movq %rcx,_lexprog(%rip)
	jmp L815
L817:
	call _pgetc
L815:
	cmpl $10,%eax
	jnz L823
L822:
	incl _lineno(%rip)
	jmp L824
L823:
	cmpl $-1,%eax
	movl $0,%ecx
	cmovzl %ecx,%eax
L824:
	cmpq $_ebuf+300,_ep(%rip)
	jb L830
L828:
	movq $_ebuf,_ep(%rip)
L830:
	movq _ep(%rip),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,_ep(%rip)
	movb %al,(%rdx)
	movsbl %al,%eax
L812:
	ret 


_unput:
L832:
	pushq %rbx
L833:
	movl %edi,%ebx
	cmpl $10,%ebx
	jnz L837
L835:
	decl _lineno(%rip)
L837:
	cmpq $_yysbuf+100,_yysptr(%rip)
	jb L840
L838:
	pushq $_yysbuf
	pushq $L841
	call _FATAL
	addq $16,%rsp
L840:
	movq _yysptr(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_yysptr(%rip)
	movb %bl,(%rcx)
	movq _ep(%rip),%rax
	decq %rax
	movq %rax,_ep(%rip)
	cmpq $_ebuf,%rax
	jae L834
L842:
	movq $_ebuf+299,_ep(%rip)
L834:
	popq %rbx
	ret 


_unputstr:
L845:
	pushq %rbx
	pushq %r12
L846:
	movq %rdi,%r12
	movq %r12,%rdi
	call _strlen
	decl %eax
	movl %eax,%ebx
	jmp L848
L849:
	movslq %ebx,%rbx
	movsbl (%rbx,%r12),%edi
	call _unput
	decl %ebx
L848:
	cmpl $0,%ebx
	jge L849
L847:
	popq %r12
	popq %rbx
	ret 

L434:
	.byte 0
L797:
	.byte 110,101,119,108,105,110,101,32
	.byte 105,110,32,114,101,103,117,108
	.byte 97,114,32,101,120,112,114,101
	.byte 115,115,105,111,110,32,37,46
	.byte 49,48,115,46,46,46,0
L3:
	.byte 78,70,0
L464:
	.byte 101,120,116,114,97,32,93,0
L25:
	.byte 108,111,103,0
L473:
	.byte 101,120,116,114,97,32,41,0
L709:
	.byte 105,108,108,101,103,97,108,32
	.byte 110,101,115,116,101,100,32,102
	.byte 117,110,99,116,105,111,110,0
L29:
	.byte 112,114,105,110,116,0
L548:
	.byte 115,116,114,105,110,103,0
L40:
	.byte 115,121,115,116,101,109,0
L6:
	.byte 99,108,111,115,101,0
L152:
	.byte 108,101,120,32,37,115,10,0
L39:
	.byte 115,117,98,115,116,114,0
L718:
	.byte 114,101,116,117,114,110,32,110
	.byte 111,116,32,105,110,32,102,117
	.byte 110,99,116,105,111,110,0
L18:
	.byte 103,101,116,108,105,110,101,0
L10:
	.byte 100,111,0
L31:
	.byte 114,97,110,100,0
L32:
	.byte 114,101,116,117,114,110,0
L30:
	.byte 112,114,105,110,116,102,0
L21:
	.byte 105,110,0
L442:
	.byte 117,110,101,120,112,101,99,116
	.byte 101,100,32,101,110,100,32,111
	.byte 102,32,105,110,112,117,116,32
	.byte 97,102,116,101,114,32,36,0
L34:
	.byte 115,112,108,105,116,0
L37:
	.byte 115,114,97,110,100,0
L145:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 121,121,108,101,120,0
L7:
	.byte 99,111,110,116,105,110,117,101
	.byte 0
L42:
	.byte 116,111,117,112,112,101,114,0
L35:
	.byte 115,112,114,105,110,116,102,0
L410:
	.byte 40,78,70,41,0
L841:
	.byte 112,117,115,104,101,100,32,98
	.byte 97,99,107,32,116,111,111,32
	.byte 109,117,99,104,58,32,37,46
	.byte 50,48,115,46,46,46,0
L9:
	.byte 100,101,108,101,116,101,0
L560:
	.byte 103,105,118,105,110,103,32,117
	.byte 112,0
L1:
	.byte 66,69,71,73,78,0
L556:
	.byte 110,111,110,45,116,101,114,109
	.byte 105,110,97,116,101,100,32,115
	.byte 116,114,105,110,103,32,37,46
	.byte 49,48,115,46,46,46,0
L20:
	.byte 105,102,0
L23:
	.byte 105,110,116,0
L11:
	.byte 101,108,115,101,0
L14:
	.byte 102,102,108,117,115,104,0
L15:
	.byte 102,111,114,0
L549:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,115,116,114,105,110,103,32
	.byte 37,46,49,48,115,46,46,46
	.byte 0
L805:
	.byte 110,111,110,45,116,101,114,109
	.byte 105,110,97,116,101,100,32,114
	.byte 101,103,117,108,97,114,32,101
	.byte 120,112,114,101,115,115,105,111
	.byte 110,32,37,46,49,48,115,46
	.byte 46,46,0
L28:
	.byte 110,101,120,116,102,105,108,101
	.byte 0
L22:
	.byte 105,110,100,101,120,0
L636:
	.byte 37,120,0
L12:
	.byte 101,120,105,116,0
L43:
	.byte 119,104,105,108,101,0
L27:
	.byte 110,101,120,116,0
L4:
	.byte 97,116,97,110,50,0
L780:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,114,101,120,32,101,120,112
	.byte 114,0
L700:
	.byte 115,121,115,116,101,109,32,105
	.byte 115,32,117,110,115,97,102,101
	.byte 0
L33:
	.byte 115,105,110,0
L793:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,114,101,103,32,101,120,112
	.byte 114,32,37,46,49,48,115,46
	.byte 46,46,0
L5:
	.byte 98,114,101,97,107,0
L8:
	.byte 99,111,115,0
L24:
	.byte 108,101,110,103,116,104,0
L85:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,110,97,109,101,32,37,46
	.byte 49,48,115,46,46,46,0
L17:
	.byte 102,117,110,99,116,105,111,110
	.byte 0
L455:
	.byte 101,120,116,114,97,32,125,0
L540:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,115,116,114,105,110,103,115
	.byte 0
L16:
	.byte 102,117,110,99,0
L13:
	.byte 101,120,112,0
L41:
	.byte 116,111,108,111,119,101,114,0
L2:
	.byte 69,78,68,0
L19:
	.byte 103,115,117,98,0
L36:
	.byte 115,113,114,116,0
L792:
	.byte 114,101,103,101,120,112,114,0
L38:
	.byte 115,117,98,0
L104:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,110,117,109,98,101,114,32
	.byte 37,46,49,48,115,46,46,46
	.byte 0
L84:
	.byte 103,101,116,116,111,107,0
L26:
	.byte 109,97,116,99,104,0
.globl _ebuf
.comm _ebuf, 300, 1
.globl _yysbuf
.comm _yysbuf, 100, 1

.globl _unput
.globl _ebuf
.globl _isarg
.globl _peek
.globl _dbg
.globl _yysptr
.globl _yysbuf
.globl _infunc
.globl _startreg
.globl _malloc
.globl _SYNTAX
.globl _yylex
.globl _adjbuf
.globl _unputstr
.globl _reg
.globl _keywords
.globl _safe
.globl _strtod
.globl _sc
.globl _setsymtab
.globl _lineno
.globl _printf
.globl _pgetc
.globl _tostring
.globl _strcmp
.globl ___ctype
.globl _symtab
.globl _word
.globl _yylval
.globl _bracecnt
.globl _input
.globl _regexpr
.globl _string
.globl _ep
.globl _lexprog
.globl _tokname
.globl _sscanf
.globl _yyin
.globl _strlen
.globl _binsearch
.globl _gettok
.globl _FATAL
.globl _parencnt
.globl _brackcnt
.globl _atof
