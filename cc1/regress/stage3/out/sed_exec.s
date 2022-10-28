.data
_LTLMSG:
	.byte 115,101,100,58,32,108,105,110
	.byte 101,32,116,111,111,32,108,111
	.byte 110,103,10,0
.align 8
_lnum:
	.quad 0
.align 8
_aptr:
	.quad _appends
.text

_execute:
L1:
	pushq %rbx
L2:
	movq %rdi,%rbx
	testq %rbx,%rbx
	jz L6
L4:
	movl $___stdin,%edx
	movl $L10,%esi
	movq %rbx,%rdi
	call _freopen
	testq %rax,%rax
	jnz L6
L7:
	pushq %rbx
	pushq $L11
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L6:
	movq _pending(%rip),%rbx
	testq %rbx,%rbx
	jz L17
L12:
	movq $0,_pending(%rip)
L15:
	movq %rbx,%rdi
	call _command
	cmpl $0,_delete(%rip)
	jnz L28
L46:
	cmpl $0,_jump(%rip)
	jz L71
L48:
	movl $0,_jump(%rip)
	movq 16(%rbx),%rbx
	testq %rbx,%rbx
	jz L28
L25:
	cmpb $0,24(%rbx)
	jz L28
L26:
	movq (%rbx),%rax
	testq %rax,%rax
	jnz L33
L32:
	testl $1,48(%rbx)
	jz L15
L33:
	testq %rax,%rax
	jz L71
L39:
	movq %rbx,%rdi
	call _selected
	testl %eax,%eax
	jnz L15
L71:
	addq $56,%rbx
	jmp L25
L28:
	cmpw $0,_nflag(%rip)
	jnz L57
L58:
	cmpl $0,_delete(%rip)
	jnz L57
L59:
	movq _spend(%rip),%rsi
	subq $_linebuf,%rsi
	movl $___stdout,%ecx
	movl $1,%edx
	movl $_linebuf,%edi
	call _fwrite
	cmpl $0,_line_with_newline(%rip)
	jz L57
L62:
	decl ___stdout(%rip)
	js L66
L65:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $10,(%rcx)
	jmp L57
L66:
	movl $___stdout,%esi
	movl $10,%edi
	call ___flushbuf
L57:
	cmpq $_appends,_aptr(%rip)
	jbe L70
L68:
	call _readout
L70:
	movl $0,_delete(%rip)
L17:
	movl $4001,%esi
	movl $_linebuf,%edi
	call _sed_getline
	cmpq $-1,%rax
	jnz L23
L3:
	popq %rbx
	ret 
L23:
	movq %rax,_spend(%rip)
	movl $_cmds,%ebx
	jmp L25


_selected:
L72:
	pushq %rbx
	pushq %r12
	pushq %r13
L73:
	movq %rdi,%r13
	movq (%r13),%rdi
	movq 8(%r13),%r12
	xorl %ebx,%ebx
	movl 48(%r13),%ecx
	testl $16,%ecx
	jz L76
L75:
	movb (%r12),%al
	movl $1,%ebx
	cmpb $20,%al
	jz L77
L79:
	cmpb $18,%al
	jnz L82
L81:
	movzbq 1(%r12),%rax
	movq _linenum(,%rax,8),%rax
	cmpq _lnum(%rip),%rax
	jg L77
L84:
	andl $4294967279,%ecx
	jmp L115
L82:
	xorl %esi,%esi
	movq %r12,%rdi
	call _match
	testl %eax,%eax
	jz L77
L87:
	andl $4294967279,48(%r13)
	jmp L77
L76:
	movb (%rdi),%al
	cmpb $20,%al
	jnz L91
L90:
	cmpl $0,_lastline(%rip)
	movl $1,%eax
	cmovnzl %eax,%ebx
	jmp L77
L91:
	cmpb $18,%al
	jnz L97
L96:
	movzbq 1(%rdi),%rax
	movq _linenum(,%rax,8),%rax
	cmpq %rax,_lnum(%rip)
	jnz L77
L99:
	movl $1,%ebx
	testq %r12,%r12
	jz L77
L102:
	orl $16,%ecx
L115:
	movl %ecx,48(%r13)
	jmp L77
L97:
	xorl %esi,%esi
	call _match
	testl %eax,%eax
	jz L77
L105:
	movl $1,%ebx
	testq %r12,%r12
	jz L77
L108:
	orl $16,48(%r13)
L77:
	testl $1,48(%r13)
	jz L112
L111:
	testl %ebx,%ebx
	setz %al
	movzbl %al,%eax
	jmp L74
L112:
	movl %ebx,%eax
L74:
	popq %r13
	popq %r12
	popq %rbx
	ret 


__match:
L116:
	pushq %rbx
	pushq %r12
	pushq %r13
L117:
	movq %rdi,%r12
	testl %esi,%esi
	jnz L120
L119:
	movl $_linebuf,%ebx
	movq $0,_locs(%rip)
	jmp L121
L120:
	cmpb $0,(%r12)
	jnz L164
L124:
	movq _loc2(%rip),%rax
	movq %rax,%rcx
	subq _loc1(%rip),%rcx
	jnz L128
L126:
	incq %rax
	movq %rax,_loc2(%rip)
L128:
	movq _loc2(%rip),%rbx
	movq %rbx,_locs(%rip)
L121:
	cmpb $0,(%r12)
	jnz L129
L131:
	cmpb $2,1(%r12)
	jz L141
L156:
	xorl %edx,%edx
	leaq 1(%r12),%rsi
	movq %rbx,%rdi
	call _advance
	testl %eax,%eax
	jnz L165
L161:
	movb (%rbx),%al
	incq %rbx
	testb %al,%al
	jnz L156
	jz L164
L141:
	movb 2(%r12),%r13b
L144:
	cmpb (%rbx),%r13b
	jnz L146
L149:
	xorl %edx,%edx
	leaq 1(%r12),%rsi
	movq %rbx,%rdi
	call _advance
	testl %eax,%eax
	jnz L165
L146:
	movb (%rbx),%al
	incq %rbx
	testb %al,%al
	jnz L144
	jz L164
L165:
	movq %rbx,_loc1(%rip)
	movl $1,%eax
	jmp L118
L129:
	movq %rbx,_loc1(%rip)
	cmpb $2,1(%r12)
	jnz L137
L135:
	movb 2(%r12),%al
	cmpb (%rbx),%al
	jz L137
L164:
	xorl %eax,%eax
	jmp L118
L137:
	xorl %edx,%edx
	leaq 1(%r12),%rsi
	movq %rbx,%rdi
	call _advance
L118:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_match:
L166:
	pushq %rbx
	pushq %r12
	pushq %r13
L167:
	movq _loc2(%rip),%r13
	movq %rdi,%r12
	movl %esi,%ebx
	movl %ebx,%esi
	movq %r12,%rdi
	call __match
	testq %r13,%r13
	jz L168
L176:
	movq _loc1(%rip),%rdx
	cmpq %rdx,%r13
	jnz L168
L172:
	movq _loc2(%rip),%rsi
	movq %rsi,%rcx
	subq %rdx,%rcx
	jnz L168
L169:
	incq %rsi
	movq %rsi,_loc2(%rip)
	movl %ebx,%esi
	movq %r12,%rdi
	call __match
L168:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 2
L309:
	.short L192-_advance
	.short L277-_advance
	.short L198-_advance
	.short L272-_advance
	.short L213-_advance
	.short L282-_advance
	.short L205-_advance
	.short L189-_advance
	.short L205-_advance
	.short L189-_advance
	.short L219-_advance
	.short L233-_advance
	.short L221-_advance
	.short L189-_advance
	.short L227-_advance
	.short L260-_advance
	.short L189-_advance
	.short L189-_advance
	.short L189-_advance
	.short L189-_advance
	.short L211-_advance

_advance:
L182:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L183:
	movq %rdi,-8(%rbp)
	movq %rsi,%r14
	movq %rdx,-16(%rbp) # spill
	movl $-1,%r13d
L185:
	movb (%r14),%cl
	incq %r14
	cmpb $2,%cl
	jl L189
L308:
	cmpb $22,%cl
	jg L189
L306:
	leal -2(%rcx),%eax
	movzbl %al,%eax
	movzwl L309(,%rax,2),%eax
	addl $_advance,%eax
	jmp *%rax
L227:
	movzbq (%r14),%rax
	movq _brastart(,%rax,8),%rdi
	incq %r14
	movq _bracend(,%rax,8),%rax
	subq %rdi,%rax
	movslq %eax,%rbx
	movq %rbx,%rdx
	movq -8(%rbp),%rsi
	call _memcmp
	testl %eax,%eax
	jnz L304
L228:
	addq -8(%rbp),%rbx
	movq %rbx,-8(%rbp)
	jmp L185
L221:
	movb (%r14),%al
	movsbl %al,%r13d
	movq -8(%rbp),%rcx
	cmpq $0,-16(%rbp) # spill
	jnz L222
L223:
	movzbq %al,%rax
	incq %r14
	movq %rcx,_bracend(,%rax,8)
	jmp L185
L222:
	movq -16(%rbp),%rax # spill
	movq %rcx,(%rax)
	jmp L305
L233:
	movq -8(%rbp),%r12
	movb (%r14),%al
	movsbl %al,%ecx
	cmpl %ecx,%r13d
	jge L237
L234:
	movzbq %al,%rax
	movq %r12,_bracend(,%rax,8)
	movzbq (%r14),%rax
	movq -8(%rbp),%rcx
	movq %rcx,_brastart(,%rax,8)
L237:
	movq -8(%rbp),%rbx
	leaq 1(%r14),%r15
	leaq -8(%rbp),%rdx
	leaq 1(%r14),%rsi
	movq %rbx,%rdi
	call _advance
	testl %eax,%eax
	jz L251
L238:
	movb (%r14),%al
	movsbl %al,%ecx
	cmpl %ecx,%r13d
	jge L242
L243:
	movq -8(%rbp),%rcx
	cmpq %rbx,%rcx
	jz L242
L240:
	movzbq %al,%rax
	movq %rcx,_bracend(,%rax,8)
	movzbq (%r14),%rax
	movq %rbx,_brastart(,%rax,8)
L242:
	cmpq %rbx,-8(%rbp)
	jnz L237
	jz L251
L252:
	incq %r15
L251:
	cmpb $14,(%r15)
	jnz L252
L253:
	leaq 2(%r15),%r14
	movq -8(%rbp),%rax
	cmpq %r12,%rax
	jz L185
L256:
	incq %rax
	movq %rax,-8(%rbp)
	jmp L258
L219:
	movzbq (%r14),%rax
	incq %r14
	movq -8(%rbp),%rcx
	movq %rcx,_brastart(,%rax,8)
	jmp L185
L205:
	movq -8(%rbp),%rax
	cmpb $0,(%rax)
	jz L185
	jnz L304
L282:
	movq -8(%rbp),%r12
L283:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb (%rcx),%cl
	movzbl %cl,%eax
	sarl $3,%eax
	movsbl (%rax,%r14),%edx
	andb $7,%cl
	movl $1,%eax
	shll %cl,%eax
	testl %edx,%eax
	jnz L283
L284:
	addq $32,%r14
	jmp L258
L213:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb (%rcx),%cl
	movzbl %cl,%eax
	sarl $3,%eax
	movsbl (%r14,%rax),%edx
	andb $7,%cl
	movl $1,%eax
	shll %cl,%eax
	testl %edx,%eax
	jz L304
L214:
	addq $32,%r14
	jmp L185
L272:
	movq -8(%rbp),%r12
L273:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	cmpb $0,(%rcx)
	jnz L273
	jz L258
L198:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	cmpb $0,(%rcx)
	jnz L185
	jz L304
L277:
	movq -8(%rbp),%r12
L278:
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb (%rcx),%al
	cmpb (%r14),%al
	jz L278
L280:
	incq %r14
L258:
	movq -8(%rbp),%rax
	decq %rax
	movq %rax,-8(%rbp)
	cmpq %rax,%r12
	jz L185
L291:
	movq -8(%rbp),%rdi
	cmpq _locs(%rip),%rdi
	jz L304
L296:
	movq -16(%rbp),%rdx # spill
	movq %r14,%rsi
	call _advance
	testl %eax,%eax
	jnz L305
L300:
	movq -8(%rbp),%rcx
	leaq -1(%rcx),%rax
	movq %rax,-8(%rbp)
	cmpq %rcx,%r12
	jb L291
	jae L304
L192:
	movb (%r14),%cl
	incq %r14
	movq -8(%rbp),%rdx
	leaq 1(%rdx),%rax
	movq %rax,-8(%rbp)
	cmpb (%rdx),%cl
	jz L185
	jnz L304
L211:
	movq -8(%rbp),%rax
	movq %rax,_loc2(%rip)
	jmp L305
L260:
	movzbq (%r14),%rax
	movq _brastart(,%rax,8),%r15
	movq _bracend(,%rax,8),%r13
	subq %r15,%r13
	movq -8(%rbp),%rbx
L261:
	movslq %r13d,%r12
	movq %r12,%rdx
	movq -8(%rbp),%rsi
	movq %r15,%rdi
	call _memcmp
	testl %eax,%eax
	jz L262
L264:
	movq -8(%rbp),%rdi
	cmpq %rbx,%rdi
	jb L304
L265:
	movq -16(%rbp),%rdx # spill
	leaq 1(%r14),%rsi
	call _advance
	testl %eax,%eax
	jnz L305
L269:
	movslq %r13d,%rax
	subq %rax,-8(%rbp)
	jmp L264
L305:
	movl $1,%eax
	jmp L184
L304:
	xorl %eax,%eax
L184:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L262:
	addq -8(%rbp),%r12
	movq %r12,-8(%rbp)
	jmp L261
L189:
	decq %r14
	movsbl %cl,%ecx
	pushq %rcx
	pushq $L303
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $2,%edi
	call _exit
	jmp L185


_substitute:
L310:
	pushq %rbx
	pushq %r12
L311:
	movq %rdi,%r12
	xorl %ebx,%ebx
L313:
	movl %ebx,%esi
	movq 16(%r12),%rdi
	call _match
	testl %eax,%eax
	jz L315
L314:
	incl %ebx
	movl 52(%r12),%eax
	testl %eax,%eax
	jz L316
L319:
	cmpl %eax,%ebx
	jnz L313
L316:
	movq 32(%r12),%rdi
	call _dosub
L315:
	testl %ebx,%ebx
	jz L324
L326:
	testl $2,48(%r12)
	jz L330
L331:
	movl $1,%esi
	movq 16(%r12),%rdi
	call _match
	testl %eax,%eax
	jz L330
L334:
	movq 32(%r12),%rdi
	call _dosub
	movq _loc2(%rip),%rax
	cmpb $0,(%rax)
	jnz L331
L330:
	movl $1,%eax
	jmp L312
L324:
	xorl %eax,%eax
L312:
	popq %r12
	popq %rbx
	ret 


_dosub:
L339:
	pushq %rbx
	pushq %r12
L340:
	movq %rdi,%r12
	movl $_linebuf,%ecx
	movl $_genbuf,%ebx
L342:
	cmpq _loc1(%rip),%rcx
	jb L343
L345:
	movsbl (%r12),%eax
	incq %r12
	testl %eax,%eax
	jz L348
L346:
	movl %eax,%edx
	andl $128,%edx
	jz L350
L352:
	movl %eax,%ecx
	andl $127,%ecx
	cmpl $48,%ecx
	jnz L350
L349:
	movq _loc1(%rip),%rsi
	movq _loc2(%rip),%rdx
	jmp L381
L350:
	testl %edx,%edx
	jz L351
L364:
	andl $127,%eax
	cmpl $49,%eax
	jl L351
L360:
	cmpl $58,%eax
	jge L351
L357:
	subl $49,%eax
	movslq %eax,%rax
	movq _brastart(,%rax,8),%rsi
	movq _bracend(,%rax,8),%rdx
L381:
	movq %rbx,%rdi
	call _place
	movq %rax,%rbx
	jmp L345
L351:
	andb $127,%al
	movb %al,(%rbx)
	incq %rbx
	cmpq $_genbuf+4000,%rbx
	jb L345
L369:
	pushq $_LTLMSG
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L345
L348:
	movq _loc2(%rip),%r12
	movq %r12,%rcx
	subq _loc1(%rip),%rcx
	movq %rbx,%rax
	subq $_genbuf,%rax
	addq $_linebuf,%rax
	movq %rax,_loc2(%rip)
	subq %rcx,%rax
	movq %rax,_loc1(%rip)
L372:
	movb (%r12),%al
	incq %r12
	movb %al,(%rbx)
	incq %rbx
	testb %al,%al
	jz L374
L373:
	cmpq $_genbuf+4000,%rbx
	jb L372
L375:
	pushq $_LTLMSG
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L372
L374:
	movl $_linebuf,%eax
	movl $_genbuf,%edx
L378:
	movb (%rdx),%cl
	incq %rdx
	movb %cl,(%rax)
	incq %rax
	testb %cl,%cl
	jnz L378
L380:
	decq %rax
	movq %rax,_spend(%rip)
L341:
	popq %r12
	popq %rbx
	ret 
L343:
	movb (%rcx),%al
	incq %rcx
	movb %al,(%rbx)
	incq %rbx
	jmp L342


_place:
L382:
	pushq %rbx
	pushq %r12
	pushq %r13
L383:
	movq %rdi,%r13
	movq %rsi,%r12
	movq %rdx,%rbx
L385:
	cmpq %rbx,%r12
	jae L387
L386:
	movb (%r12),%al
	incq %r12
	movb %al,(%r13)
	incq %r13
	cmpq $_genbuf+4000,%r13
	jb L385
L388:
	pushq $_LTLMSG
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L385
L387:
	movq %r13,%rax
L384:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_listto:
L392:
	pushq %rbx
	pushq %r12
L393:
	movq %rdi,%r12
	movq %rsi,%rbx
	jmp L395
L396:
	movsbl (%r12),%ecx
	subl $32,%ecx
	cmpl $95,%ecx
	jae L400
L399:
	movl %eax,(%rbx)
	cmpl $0,%eax
	jl L403
L402:
	movb (%r12),%dl
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb %dl,(%rcx)
	jmp L401
L403:
	movsbl (%r12),%edi
	movq %rbx,%rsi
	jmp L447
L400:
	movl %eax,(%rbx)
	cmpl $0,%eax
	jl L406
L405:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $92,(%rcx)
	jmp L407
L406:
	movq %rbx,%rsi
	movl $92,%edi
	call ___flushbuf
L407:
	movb (%r12),%al
	cmpb $8,%al
	jz L411
L441:
	cmpb $9,%al
	jz L416
L442:
	cmpb $10,%al
	jz L421
L443:
	cmpb $13,%al
	jz L426
L444:
	cmpb $27,%al
	jz L431
L445:
	movsbl %al,%eax
	pushq %rax
	pushq $L436
	pushq %rbx
	call _fprintf
	addq $24,%rsp
	jmp L401
L431:
	decl (%rbx)
	js L433
L432:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $101,(%rcx)
	jmp L401
L433:
	movq %rbx,%rsi
	movl $101,%edi
	jmp L447
L426:
	decl (%rbx)
	js L428
L427:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $114,(%rcx)
	jmp L401
L428:
	movq %rbx,%rsi
	movl $114,%edi
	jmp L447
L421:
	decl (%rbx)
	js L423
L422:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $110,(%rcx)
	jmp L401
L423:
	movq %rbx,%rsi
	movl $110,%edi
	jmp L447
L416:
	decl (%rbx)
	js L418
L417:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $116,(%rcx)
	jmp L401
L418:
	movq %rbx,%rsi
	movl $116,%edi
	jmp L447
L411:
	decl (%rbx)
	js L413
L412:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $98,(%rcx)
	jmp L401
L413:
	movq %rbx,%rsi
	movl $98,%edi
L447:
	call ___flushbuf
L401:
	incq %r12
L395:
	movq _spend(%rip),%rcx
	movl (%rbx),%eax
	decl %eax
	cmpq %rcx,%r12
	jb L396
L398:
	movl %eax,(%rbx)
	cmpl $0,%eax
	jl L438
L437:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $10,(%rcx)
	jmp L394
L438:
	movq %rbx,%rsi
	movl $10,%edi
	call ___flushbuf
L394:
	popq %r12
	popq %rbx
	ret 


_dumpto:
L448:
	pushq %rbx
	pushq %r12
L449:
	movq %rdi,%r12
	movq %rsi,%rbx
	jmp L451
L452:
	movsbl (%r12),%eax
	pushq %rax
	pushq $L436
	pushq %rbx
	call _fprintf
	addq $24,%rsp
	incq %r12
L451:
	cmpq _spend(%rip),%r12
	jb L452
L454:
	pushq $10
	pushq $L436
	pushq %rbx
	call _fprintf
	addq $24,%rsp
	decl (%rbx)
	js L456
L455:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $10,(%rcx)
	jmp L450
L456:
	movq %rbx,%rsi
	movl $10,%edi
	call ___flushbuf
L450:
	popq %r12
	popq %rbx
	ret 

.data
.align 8
L461:
	.quad 0
.text

_truncated:
L458:
	pushq %rbx
L459:
	movq _lnum(%rip),%rax
	movl %edi,%ebx
	cmpq L461(%rip),%rax
	jz L460
L464:
	movq %rax,L461(%rip)
	pushq $L466
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	testl %ebx,%ebx
	movl $L468,%eax
	movl $L467,%ecx
	cmovzq %rax,%rcx
	pushq _lnum(%rip)
	pushq %rcx
	pushq $___stderr
	call _fprintf
	pushq $4000
	pushq $L472
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
L460:
	popq %rbx
	ret 

.local L476
.comm L476, 4, 4
.local L477
.comm L477, 4000, 1
.data
.align 8
L478:
	.quad L477
.text
.align 2
L682:
	.short L513-_command
	.short L482-_command
	.short L675-_command
	.short L488-_command
	.short L677-_command
	.short L500-_command
	.short L516-_command
	.short L521-_command
	.short L530-_command
	.short L535-_command
	.short L544-_command
	.short L548-_command
	.short L558-_command
	.short L570-_command
	.short L579-_command
	.short L582-_command
	.short L598-_command
	.short L605-_command
	.short L611-_command
	.short L632-_command
	.short L632-_command
	.short L654-_command
	.short L638-_command
	.short L656-_command
	.short L670-_command
	.short L475-_command
	.short L475-_command
	.short L475-_command
	.short L475-_command
	.short L475-_command
	.short L475-_command
	.short L553-_command

_command:
L473:
	pushq %rbx
	pushq %r12
L474:
	movq %rdi,%r12
	movb 24(%r12),%cl
	cmpb $1,%cl
	jl L475
L681:
	cmpb $32,%cl
	jg L475
L679:
	leal -1(%rcx),%eax
	movzbl %al,%eax
	movzwl L682(,%rax,2),%eax
	addl $_command,%eax
	jmp *%rax
L553:
	movq 40(%r12),%rax
	testq %rax,%rax
	movl $___stdout,%esi
	cmovnzq %rax,%rsi
	movl $_linebuf,%edi
	call _dumpto
	jmp L475
L670:
	movl $_linebuf,%edx
	movq 16(%r12),%rcx
L671:
	movzbq (%rdx),%rax
	movb (%rax,%rcx),%al
	movb %al,(%rdx)
	testb %al,%al
	jz L475
L672:
	incq %rdx
	jmp L671
L656:
	movl $_linebuf,%ecx
	movl $_genbuf,%edx
L657:
	movb (%rcx),%al
	incq %rcx
	movb %al,(%rdx)
	incq %rdx
	testb %al,%al
	jnz L657
L659:
	movl $L477,%edx
	movl $_linebuf,%eax
L661:
	movb (%rdx),%cl
	incq %rdx
	movb %cl,(%rax)
	incq %rax
	testb %cl,%cl
	jnz L661
L663:
	decq %rax
	movq %rax,_spend(%rip)
	movl $_genbuf,%edx
	movl $L477,%eax
L665:
	movb (%rdx),%cl
	incq %rdx
	movb %cl,(%rax)
	incq %rax
	testb %cl,%cl
	jnz L665
	jz L687
L638:
	movl $_linebuf,%ebx
L639:
	movb (%rbx),%al
	cmpb $10,%al
	jz L645
L643:
	testb %al,%al
	jz L645
L644:
	movq 40(%r12),%rax
	decl (%rax)
	leaq 1(%rbx),%rax
	movq 40(%r12),%rsi
	js L648
L647:
	movb (%rbx),%dl
	movq %rax,%rbx
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %dl,(%rcx)
	jmp L639
L648:
	movsbl (%rbx),%edi
	movq %rax,%rbx
	call ___flushbuf
	jmp L639
L645:
	movq 40(%r12),%rcx
	decl (%rcx)
	movq 40(%r12),%rsi
	js L684
L650:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	jmp L688
L654:
	pushq $_linebuf
	pushq $L496
	pushq 40(%r12)
	jmp L683
L632:
	cmpb $21,%cl
	setz %al
	movzbl %al,%eax
	cmpl %eax,L476(%rip)
	jz L475
L635:
	movl $0,L476(%rip)
	jmp L675
L611:
	movq %r12,%rdi
	call _substitute
	movl %eax,L476(%rip)
	movl 48(%r12),%ecx
	andl $12,%ecx
	jz L614
L615:
	testl %eax,%eax
	jz L614
L616:
	cmpl $4,%ecx
	jnz L582
L619:
	movl $_linebuf,%edi
	call _puts
L614:
	cmpl $0,L476(%rip)
	jz L475
L626:
	movq 40(%r12),%rax
	testq %rax,%rax
	jz L475
L627:
	pushq $_linebuf
	pushq $L496
	pushq %rax
	jmp L683
L598:
	cmpw $0,_nflag(%rip)
	jnz L601
L599:
	movl $_linebuf,%edi
	call _puts
L601:
	cmpq $_appends,_aptr(%rip)
	jbe L604
L602:
	call _readout
L604:
	xorl %edi,%edi
	call _exit
L605:
	movq _aptr(%rip),%rcx
	leaq 8(%rcx),%rax
	movq %rax,_aptr(%rip)
	movq %r12,(%rcx)
	cmpq $_appends+160,_aptr(%rip)
	jb L676
L606:
	pushq _lnum(%rip)
	pushq $L609
	jmp L686
L582:
	movl $_linebuf,%ebx
L583:
	movb (%rbx),%al
	cmpb $10,%al
	jz L589
L587:
	testb %al,%al
	jz L589
L588:
	decl ___stdout(%rip)
	leaq 1(%rbx),%rax
	js L592
L591:
	movb (%rbx),%dl
	movq ___stdout+24(%rip),%rcx
	movq %rax,%rbx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb %dl,(%rcx)
	jmp L583
L592:
	movsbl (%rbx),%edi
	movq %rax,%rbx
	movl $___stdout,%esi
	call ___flushbuf
	jmp L583
L589:
	decl ___stdout(%rip)
	js L595
L594:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
L688:
	movb $10,(%rcx)
	jmp L475
L595:
	movl $___stdout,%esi
L684:
	movl $10,%edi
	call ___flushbuf
	jmp L475
L579:
	movl $_linebuf,%edi
	call _puts
	jmp L475
L570:
	cmpq $_appends,_aptr(%rip)
	jbe L573
L571:
	call _readout
L573:
	movq _spend(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_spend(%rip)
	movb $10,(%rcx)
	movq _spend(%rip),%rdi
	movl $_linebuf+4001,%esi
	subq %rdi,%rsi
	call _sed_getline
	cmpq $-1,%rax
	jz L678
	jnz L689
L558:
	cmpw $0,_nflag(%rip)
	jnz L561
L559:
	movl $_linebuf,%edi
	call _puts
L561:
	cmpq $_appends,_aptr(%rip)
	jbe L564
L562:
	call _readout
L564:
	movl $4001,%esi
	movl $_linebuf,%edi
	call _sed_getline
	cmpq $-1,%rax
	jnz L689
L678:
	movq %r12,_pending(%rip)
	jmp L677
L548:
	movq 40(%r12),%rax
	testq %rax,%rax
	movl $___stdout,%esi
	cmovnzq %rax,%rsi
	movl $_linebuf,%edi
	call _listto
	jmp L475
L544:
	jmp L690
L535:
	movq L478(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,L478(%rip)
	movb $10,(%rcx)
	movq L478(%rip),%rbx
	movl $_linebuf,%ecx
L536:
	cmpq $L477+4000,%rbx
	ja L539
L541:
	movb (%rcx),%al
	incq %rcx
	movb %al,(%rbx)
	incq %rbx
	testb %al,%al
	jnz L536
	jz L537
L539:
	movl $1,%edi
	call _truncated
	movb $0,-1(%rbx)
L537:
	decq %rbx
	movq %rbx,L478(%rip)
	jmp L475
L530:
	movl $L477,%eax
	movl $_linebuf,%edx
L531:
	movb (%rdx),%cl
	incq %rdx
	movb %cl,(%rax)
	incq %rax
	testb %cl,%cl
	jnz L531
L687:
	decq %rax
	movq %rax,L478(%rip)
	jmp L475
L521:
	movq _spend(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,_spend(%rip)
	movb $10,(%rcx)
	movq _spend(%rip),%rbx
	movl $L477,%ecx
L522:
	cmpq $_linebuf+4000,%rbx
	ja L525
L527:
	movb (%rcx),%al
	incq %rcx
	movb %al,(%rbx)
	incq %rbx
	testb %al,%al
	jnz L522
	jz L523
L525:
	xorl %edi,%edi
	call _truncated
	movb $0,-1(%rbx)
L523:
	decq %rbx
	movq %rbx,_spend(%rip)
	jmp L475
L516:
	movl $_linebuf,%eax
	movl $L477,%edx
L517:
	movb (%rdx),%cl
	incq %rdx
	movb %cl,(%rax)
	incq %rax
	testb %cl,%cl
	jnz L517
L519:
	decq %rax
L689:
	movq %rax,_spend(%rip)
	jmp L475
L500:
	movl $_linebuf,%eax
	movl $_linebuf,%edx
L501:
	movb (%rdx),%cl
	incq %rdx
	cmpb $10,%cl
	jnz L502
L508:
	movb (%rdx),%cl
	incq %rdx
	movb %cl,(%rax)
	incq %rax
	testb %cl,%cl
	jnz L508
L510:
	decq %rax
	movq %rax,_spend(%rip)
	incl _jump(%rip)
	jmp L475
L502:
	testb %cl,%cl
	setz %cl
	movzbl %cl,%ecx
	movl %ecx,_delete(%rip)
	jnz L501
	jz L475
L677:
	movl $1,_delete(%rip)
	jmp L475
L488:
	movl $1,_delete(%rip)
	testl $16,48(%r12)
	jz L690
L492:
	cmpl $0,_lastline(%rip)
	jz L475
L690:
	pushq 16(%r12)
	pushq $L496
	call _printf
	addq $16,%rsp
	jmp L475
L675:
	movl $1,_jump(%rip)
	jmp L475
L482:
	movq _aptr(%rip),%rcx
	leaq 8(%rcx),%rax
	movq %rax,_aptr(%rip)
	movq %r12,(%rcx)
	cmpq $_appends+160,_aptr(%rip)
	jb L676
L483:
	pushq _lnum(%rip)
	pushq $L486
L686:
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L676:
	movq _aptr(%rip),%rax
	movq $0,(%rax)
	jmp L475
L513:
	pushq _lnum(%rip)
	pushq $L514
	pushq $___stdout
L683:
	call _fprintf
	addq $24,%rsp
L475:
	popq %r12
	popq %rbx
	ret 


_sed_getline:
L691:
	pushq %rbx
L692:
	movq %rdi,%rbx
	movl $___stdin,%edx
	movq %rbx,%rdi
	call _fgets
	testq %rax,%rax
	jz L695
L694:
	incq _lnum(%rip)
	jmp L697
L700:
	testb %al,%al
	jz L702
L701:
	incq %rbx
L697:
	movb (%rbx),%al
	cmpb $10,%al
	jnz L700
L702:
	cmpb $10,%al
	setz %al
	movzbl %al,%eax
	movl %eax,_line_with_newline(%rip)
	movb $0,(%rbx)
	cmpl $0,_last_line_used(%rip)
	jz L706
L704:
	movl $___stdin,%edi
	call _fgetc
	movl %eax,%edi
	cmpl $-1,%edi
	jz L708
L707:
	movl $___stdin,%esi
	call _ungetc
	jmp L706
L708:
	cmpl $0,_eargc(%rip)
	jnz L706
L710:
	movl $1,_lastline(%rip)
L706:
	movq %rbx,%rax
	jmp L693
L695:
	movq $-1,%rax
L693:
	popq %rbx
	ret 


_readout:
L715:
	pushq %rbx
L716:
	movq $_appends-8,_aptr(%rip)
L718:
	movq _aptr(%rip),%rcx
	leaq 8(%rcx),%rax
	movq %rax,_aptr(%rip)
	movq 8(%rcx),%rcx
	testq %rcx,%rcx
	jz L720
L719:
	movb 24(%rcx),%al
	movq 16(%rcx),%rdi
	cmpb $2,%al
	jnz L722
L721:
	pushq %rdi
	pushq $L496
	call _printf
	addq $16,%rsp
	jmp L718
L722:
	movl $L10,%esi
	call _fopen
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L718
L728:
	decl (%rbx)
	js L732
L731:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movzbl (%rcx),%eax
	jmp L733
L732:
	movq %rbx,%rdi
	call ___fillbuf
L733:
	cmpl $-1,%eax
	jz L730
L729:
	decl ___stdout(%rip)
	js L735
L734:
	movq ___stdout+24(%rip),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,___stdout+24(%rip)
	movb %al,(%rdx)
	jmp L728
L735:
	movsbl %al,%edi
	movl $___stdout,%esi
	call ___flushbuf
	jmp L728
L730:
	movq %rbx,%rdi
	call _fclose
	jmp L718
L720:
	movq $_appends,_aptr(%rip)
	movq $0,_appends(%rip)
L717:
	popq %rbx
	ret 

L468:
	.byte 108,105,110,101,32,37,108,100
	.byte 0
L466:
	.byte 115,101,100,58,32,0
L496:
	.byte 37,115,10,0
L436:
	.byte 37,48,50,120,0
L472:
	.byte 32,116,114,117,110,99,97,116
	.byte 101,100,32,116,111,32,37,100
	.byte 32,99,104,97,114,97,99,116
	.byte 101,114,115,10,0
L303:
	.byte 115,101,100,58,32,105,110,116
	.byte 101,114,110,97,108,32,82,69
	.byte 32,101,114,114,111,114,44,32
	.byte 37,111,10,0
L11:
	.byte 115,101,100,58,32,99,97,110
	.byte 39,116,32,111,112,101,110,32
	.byte 37,115,10,0
L10:
	.byte 114,0
L609:
	.byte 115,101,100,58,32,116,111,111
	.byte 32,109,97,110,121,32,114,101
	.byte 97,100,115,32,97,102,116,101
	.byte 114,32,108,105,110,101,32,37
	.byte 108,100,10,0
L467:
	.byte 104,111,108,100,32,115,112,97
	.byte 99,101,0
L486:
	.byte 115,101,100,58,32,116,111,111
	.byte 32,109,97,110,121,32,97,112
	.byte 112,101,110,100,115,32,97,102
	.byte 116,101,114,32,108,105,110,101
	.byte 32,37,108,100,10,0
L514:
	.byte 37,108,100,10,0
.local _spend
.comm _spend, 8, 8
.local _appends
.comm _appends, 160, 8
.local _genbuf
.comm _genbuf, 4000, 1
.local _loc1
.comm _loc1, 8, 8
.local _loc2
.comm _loc2, 8, 8
.local _locs
.comm _locs, 8, 8
.local _lastline
.comm _lastline, 4, 4
.local _line_with_newline
.comm _line_with_newline, 4, 4
.local _jump
.comm _jump, 4, 4
.local _delete
.comm _delete, 4, 4
.local _bracend
.comm _bracend, 72, 8
.local _brastart
.comm _brastart, 72, 8

.globl _nflag
.globl _execute
.globl ___fillbuf
.globl _linebuf
.globl _fgets
.globl _fopen
.globl ___stdout
.globl _puts
.globl _last_line_used
.globl _eargc
.globl _printf
.globl _cmds
.globl _memcmp
.globl ___flushbuf
.globl _fgetc
.globl _pending
.globl ___stderr
.globl ___stdin
.globl _linenum
.globl _fclose
.globl _fwrite
.globl _exit
.globl _freopen
.globl _fprintf
.globl _ungetc
