.data
.align 8
_nop_insn:
	.int 0
	.fill 4, 1, 0
.align 8
_cc_text:
	.quad L1
	.quad L2
	.quad L3
	.quad L4
	.quad L5
	.quad L6
	.quad L7
	.quad L8
	.quad L9
	.quad L10
	.quad L11
	.quad L12
	.quad L13
_commuted_cc:
	.byte 0
	.byte 1
	.byte 0
	.byte 0
	.byte 7
	.byte 6
	.byte 5
	.byte 4
	.byte 11
	.byte 10
	.byte 9
	.byte 8
_ccops:
	.byte 4
	.byte 0
	.byte 6
	.byte 13
	.byte 4
	.byte 6
	.byte 6
	.byte 4
	.byte 4
	.byte 7
	.byte 1
	.byte 13
	.byte 4
	.byte 1
	.byte 1
	.byte 4
	.byte 4
	.byte 5
	.byte 12
	.byte 13
	.byte 0
	.byte 6
	.byte 6
	.byte 0
	.byte 0
	.byte 7
	.byte 5
	.byte 13
	.byte 0
	.byte 1
	.byte 12
	.byte 13
	.byte 0
	.byte 5
	.byte 5
	.byte 0
	.byte 6
	.byte 7
	.byte 12
	.byte 13
	.byte 6
	.byte 1
	.byte 12
	.byte 4
	.byte 6
	.byte 5
	.byte 12
	.byte 0
	.byte 7
	.byte 1
	.byte 1
	.byte 7
	.byte 7
	.byte 5
	.byte 5
	.byte 7
	.byte 1
	.byte 5
	.byte 12
	.byte 7
	.byte 8
	.byte 0
	.byte 10
	.byte 13
	.byte 8
	.byte 10
	.byte 10
	.byte 8
	.byte 8
	.byte 11
	.byte 1
	.byte 13
	.byte 8
	.byte 1
	.byte 1
	.byte 8
	.byte 8
	.byte 9
	.byte 12
	.byte 13
	.byte 0
	.byte 10
	.byte 10
	.byte 0
	.byte 0
	.byte 11
	.byte 9
	.byte 13
	.byte 0
	.byte 1
	.byte 12
	.byte 13
	.byte 0
	.byte 9
	.byte 9
	.byte 0
	.byte 10
	.byte 11
	.byte 12
	.byte 13
	.byte 10
	.byte 1
	.byte 12
	.byte 8
	.byte 10
	.byte 9
	.byte 12
	.byte 0
	.byte 11
	.byte 1
	.byte 1
	.byte 11
	.byte 11
	.byte 9
	.byte 9
	.byte 11
	.byte 1
	.byte 9
	.byte 12
	.byte 11
.text

_union_cc:
L14:
L15:
	movl %edi,%eax
	movl %esi,%edx
	xorl $1,%edx
	cmpl %edx,%eax
	jz L62
L19:
	cmpl %esi,%eax
	jz L16
L23:
	cmpl $13,%eax
	jz L25
L27:
	cmpl $13,%esi
	jz L16
L31:
	cmpl $12,%eax
	jz L62
L36:
	cmpl $12,%esi
	jnz L35
L62:
	movl $12,%eax
	ret
L35:
	xorl %r8d,%r8d
L42:
	movsbl _ccops(,%r8,4),%edi
	cmpl %edi,%eax
	jnz L48
L52:
	movsbl _ccops+1(,%r8,4),%edx
	cmpl %edx,%esi
	jz L45
L48:
	cmpl %edi,%esi
	jnz L47
L56:
	movsbl _ccops+1(,%r8,4),%edx
	cmpl %edx,%eax
	jz L45
L47:
	incl %r8d
	cmpl $30,%r8d
	jl L42
	jge L44
L45:
	movsbl _ccops+2(,%r8,4),%ecx
L44:
	movl %ecx,%eax
	ret
L25:
	movl %esi,%eax
L16:
	ret 


_intersect_cc:
L64:
L65:
	movl %edi,%eax
	movl %esi,%edx
	xorl $1,%edx
	cmpl %edx,%eax
	jz L112
L69:
	cmpl %esi,%eax
	jz L66
L73:
	cmpl $12,%eax
	jz L75
L77:
	cmpl $12,%esi
	jz L66
L81:
	cmpl $13,%eax
	jz L112
L86:
	cmpl $13,%esi
	jnz L85
L112:
	movl $13,%eax
	ret
L85:
	xorl %r8d,%r8d
L92:
	movsbl _ccops(,%r8,4),%edi
	cmpl %edi,%eax
	jnz L98
L102:
	movsbl _ccops+1(,%r8,4),%edx
	cmpl %edx,%esi
	jz L95
L98:
	cmpl %edi,%esi
	jnz L97
L106:
	movsbl _ccops+1(,%r8,4),%edx
	cmpl %edx,%eax
	jz L95
L97:
	incl %r8d
	cmpl $30,%r8d
	jl L92
	jge L94
L95:
	movsbl _ccops+3(,%r8,4),%ecx
L94:
	movl %ecx,%eax
	ret
L75:
	movl %esi,%eax
L66:
	ret 

.data
.align 8
_insn_text:
	.quad L114
	.quad 0
	.quad 0
	.quad L115
	.quad L116
	.quad L117
	.quad 0
	.quad L118
	.quad L119
	.quad L120
	.quad L121
	.quad L122
	.quad L123
	.quad L124
	.quad L125
	.quad L126
	.quad L127
	.quad L128
	.quad L129
	.quad L130
	.quad L131
	.quad L132
	.quad L133
	.quad L134
	.quad L135
	.quad L136
	.quad L137
	.quad L138
	.quad L139
	.quad L140
	.quad L141
	.quad L142
	.quad L143
	.quad L144
	.quad L145
	.quad L146
	.quad L147
	.quad L148
	.quad L149
	.quad L150
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad 0
	.quad L151
	.quad L152
	.quad L152
	.quad L152
	.quad L153
	.quad L154
	.quad L155
	.quad L156
	.quad L157
	.quad L158
	.quad L159
	.quad L160
	.quad L161
	.quad L162
	.quad L163
	.quad L164
	.quad L165
	.quad L166
	.quad L167
	.quad L168
	.quad L155
	.quad L169
	.quad L170
	.quad L171
	.quad L172
	.quad L173
	.quad L174
	.quad L175
	.quad L176
	.quad L177
	.quad L178
	.quad L179
	.quad L180
	.quad L181
	.quad L182
	.quad L183
	.quad L184
	.quad L184
	.quad L184
	.quad L185
	.quad L186
	.quad L187
	.quad L188
	.quad L189
	.quad L190
	.quad L191
	.quad L192
	.quad L193
	.quad L194
	.quad L195
	.quad L196
	.quad L197
	.quad L198
	.quad L199
	.quad L200
	.quad L201
	.quad L202
	.quad L203
	.quad L204
	.quad L205
	.quad L206
	.quad L207
	.quad L208
	.quad L209
	.quad L207
	.quad L208
	.quad L209
	.quad L210
	.quad L211
	.quad L212
	.quad L213
	.quad L214
	.quad L215
	.quad L216
	.quad L217
	.quad L218
	.quad L219
	.quad L220
	.quad L221
	.quad L222
	.quad L223
	.quad L224
	.quad L225
	.quad L226
	.quad L227
	.quad L228
	.quad L229
	.quad L230
	.quad L231
	.quad L232
	.quad L233
	.quad L234
	.quad L235
	.quad L236
	.quad L237
	.quad L238
	.quad L239
	.quad L240
	.quad L241
	.quad L242
	.quad L243
	.quad L244
	.quad L245
	.quad L246
	.quad L247
	.quad L248
	.quad L249
	.quad L250
	.quad L251
	.quad L252
	.quad L253
	.quad L254
	.quad L255
	.quad L256
	.quad L257
	.quad L258
	.quad L259
	.quad L260
	.quad L261
	.quad L262
	.quad L263
	.quad L264
	.quad L265
	.quad L266
	.quad L267
	.quad L268
	.quad L269
	.quad L270
	.quad L271
	.quad L272
.text

_new_insn:
L273:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L274:
	movl %edi,%r13d
	movl %esi,%r14d
	movq _func_arena+8(%rip),%rdx
	movq %rdx,%rcx
	andl $7,%ecx
	jz L281
L279:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%rdx
	movq %rdx,_func_arena+8(%rip)
L281:
	movq _func_arena+8(%rip),%r12
	cmpl $8388609,%r13d
	jz L285
L303:
	cmpl $58720258,%r13d
	jz L293
L304:
	movl %r13d,%ebx
	andl $805306368,%ebx
	sarl $28,%ebx
	leal (%rbx,%r14),%edx
	movslq %edx,%rdx
	shlq $5,%rdx
	leaq 8(%r12,%rdx),%rax
	movq %rax,_func_arena+8(%rip)
	addq $8,%rdx
	xorl %esi,%esi
	movq %r12,%rdi
	call ___builtin_memset
	andl $63,%r14d
	shll $5,%r14d
	movl 4(%r12),%eax
	andl $4294965279,%eax
	orl %r14d,%eax
	movl %eax,4(%r12)
L295:
	movl %ebx,%eax
	decl %ebx
	testl %eax,%eax
	jz L283
L296:
	movb %bl,%cl
	movb $5,%al
	imulb %cl
	leal 8(%rax),%ecx
	movl %r13d,%eax
	sarl %cl,%eax
	andb $31,%al
	movb %al,%cl
	movl $1,%edx
	shll %cl,%edx
	movslq %ebx,%rcx
	shlq $5,%rcx
	andl $131071,%edx
	shll $5,%edx
	movl 8(%r12,%rcx),%eax
	andl $4290773023,%eax
	orl %edx,%eax
	movl %eax,8(%r12,%rcx)
	jmp L295
L293:
	leaq 24(%r12),%rax
	movq %rax,_func_arena+8(%rip)
	movl $24,%edx
	xorl %esi,%esi
	movq %r12,%rdi
	call ___builtin_memset
	movq _path(%rip),%rax
	movq %rax,8(%r12)
	movl _line_no(%rip),%eax
	movl %eax,16(%r12)
	jmp L283
L285:
	leaq 64(%r12),%rax
	movq %rax,_func_arena+8(%rip)
	movl $64,%edx
	xorl %esi,%esi
	movq %r12,%rdi
	call ___builtin_memset
	movl $0,16(%r12)
	movl $0,20(%r12)
	movq $0,24(%r12)
	movq $_func_arena,32(%r12)
	movl $0,40(%r12)
	movl $0,44(%r12)
	movq $0,48(%r12)
	movq $_func_arena,56(%r12)
L283:
	movl %r13d,(%r12)
	movq %r12,%rax
L275:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_dup_insn:
L306:
	pushq %rbx
	pushq %r12
	pushq %r13
L307:
	movq %rdi,%r12
	movl (%r12),%edi
	movl 4(%r12),%esi
	shll $21,%esi
	shrl $26,%esi
	call _new_insn
	movq %rax,%rbx
	movq (%r12),%rax
	movq %rax,(%rbx)
	movl (%rbx),%edx
	cmpl $8388609,%edx
	jz L312
L324:
	cmpl $58720258,%edx
	jz L320
L325:
	andl $805306368,%edx
	sarl $28,%edx
	movl 4(%rbx),%eax
	shll $21,%eax
	shrl $26,%eax
	addl %eax,%edx
	shlq $5,%rdx
	leaq 8(%r12),%rsi
	leaq 8(%rbx),%rdi
	call ___builtin_memcpy
	jmp L310
L320:
	movq 8(%r12),%rcx
	leaq 8(%r13),%rax
	movq %rcx,(%rax)
	movl 16(%r12),%eax
	addq $16,%r13
	movl %eax,(%r13)
	jmp L310
L312:
	movq 8(%r12),%rax
	movq %rax,8(%rbx)
	movl $8,%edx
	leaq 16(%r12),%rsi
	leaq 16(%rbx),%rdi
	call _dup_vector
	movl $8,%edx
	leaq 40(%r12),%rsi
	leaq 40(%rbx),%rdi
	call _dup_vector
L310:
	movq %rbx,%rax
L308:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_commute_insn:
L327:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
L328:
	movq %rdi,%rdx
	movl (%rdx),%eax
	cmpl $-1342177266,%eax
	jz L338
L342:
	cmpl $-1342177264,%eax
	jz L338
L343:
	cmpl $-1275068395,%eax
	jz L338
L344:
	cmpl $-1275068394,%eax
	jz L338
L345:
	cmpl $-1275068393,%eax
	jnz L329
L338:
	movl $32,%ecx
	leaq 40(%rdx),%rsi
	leaq -32(%rbp),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq 72(%rdx),%rsi
	leaq 40(%rdx),%rdi
	rep 
	movsb 
	movl $32,%ecx
	leaq -32(%rbp),%rsi
	leaq 72(%rdx),%rdi
	rep 
	movsb 
L329:
	movq %rbp,%rsp
	popq %rbp
	ret 


_normalize_operand:
L348:
L349:
	movl (%rdi),%eax
	movl %eax,%ecx
	andl $4194272,%ecx
	cmpl $262144,%ecx
	jz L353
L351:
	movl $0,4(%rdi)
L353:
	movl %eax,%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jz L357
L397:
	cmpl $1,%ecx
	jnz L355
L359:
	movl $0,12(%rdi)
	andl $4294967271,%eax
	movl %eax,(%rdi)
	movq $0,16(%rdi)
	movq $0,24(%rdi)
	jmp L355
L357:
	movl $0,8(%rdi)
	movl $0,12(%rdi)
	andl $4294967271,%eax
	movl %eax,(%rdi)
L355:
	movl 12(%rdi),%eax
	testl %eax,%eax
	jz L362
L367:
	testl $24,(%rdi)
	jnz L362
L368:
	cmpl $0,8(%rdi)
	jnz L362
L364:
	movl %eax,8(%rdi)
	movl $0,12(%rdi)
L362:
	movl (%rdi),%eax
	movl %eax,%ecx
	andl $7,%ecx
	cmpl $3,%ecx
	jz L350
L371:
	andl $4294967288,%eax
	orl $4,%eax
	movl %eax,(%rdi)
	movl 8(%rdi),%ecx
	testl %ecx,%ecx
	jnz L376
L377:
	cmpl $0,12(%rdi)
	jnz L376
L378:
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,(%rdi)
L376:
	testl %ecx,%ecx
	jz L350
L392:
	cmpl $0,12(%rdi)
	jnz L350
L393:
	cmpq $0,16(%rdi)
	jnz L350
L389:
	cmpq $0,24(%rdi)
	jnz L350
L385:
	movl (%rdi),%eax
	andl $4294967288,%eax
	orl $1,%eax
	movl %eax,(%rdi)
L350:
	ret 


_same_operand:
L400:
L401:
	movl (%rdi),%r10d
	movl %r10d,%r11d
	andl $7,%r11d
	movl (%rsi),%eax
	movl %eax,%ecx
	andl $7,%ecx
	cmpl %ecx,%r11d
	jnz L460
L405:
	testl %r11d,%r11d
	jz L461
L409:
	movl %r10d,%edx
	andl $4194272,%edx
	movl %eax,%ecx
	andl $4194272,%ecx
	cmpl %ecx,%edx
	jnz L460
L413:
	testl $262144,%r10d
	jz L417
L415:
	movl 4(%rdi),%edx
	movl %edx,%r9d
	andl $268435455,%r9d
	movl 4(%rsi),%ecx
	movl %ecx,%r8d
	andl $268435455,%r8d
	cmpl %r8d,%r9d
	jnz L460
L420:
	andl $4026531840,%edx
	andl $4026531840,%ecx
	cmpl %ecx,%edx
	jnz L460
L417:
	cmpl $1,%r11d
	jz L429
L463:
	cmpl $3,%r11d
	jz L436
L464:
	cmpl $4,%r11d
	jz L436
L465:
	cmpl $2,%r11d
	jz L449
	jnz L461
L436:
	movl 8(%rdi),%ecx
	cmpl 8(%rsi),%ecx
	jnz L460
L439:
	movl 12(%rdi),%ecx
	cmpl 12(%rsi),%ecx
	jnz L460
L443:
	andl $24,%r10d
	andl $24,%eax
	cmpl %eax,%r10d
	jnz L460
L449:
	movq 16(%rdi),%rax
	cmpq 16(%rsi),%rax
	jnz L460
L452:
	movq 24(%rdi),%rax
	cmpq 24(%rsi),%rax
	jnz L460
	jz L461
L429:
	movl 8(%rdi),%eax
	cmpl 8(%rsi),%eax
	jnz L460
L461:
	movl $1,%eax
	ret
L460:
	xorl %eax,%eax
L402:
	ret 


_same_insn:
L468:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L469:
	movq %rdi,%r13
	movq %rsi,%r12
	movl (%r13),%edi
	cmpl (%r12),%edi
	jnz L537
L473:
	movl 4(%r13),%ecx
	movl %ecx,%esi
	andl $1,%esi
	movl 4(%r12),%eax
	movl %eax,%edx
	andl $1,%edx
	cmpl %edx,%esi
	jnz L537
L477:
	cmpl $8388609,%edi
	jz L482
L539:
	cmpl $-1493172218,%edi
	jz L508
L540:
	cmpl $385878080,%edi
	jnz L480
L518:
	movl %ecx,%esi
	andl $28672,%esi
	movl %eax,%edx
	andl $28672,%edx
	cmpl %edx,%esi
	jnz L537
L521:
	andl $491520,%ecx
	andl $491520,%eax
	cmpl %eax,%ecx
	jz L480
	jnz L537
L508:
	movl %ecx,%esi
	andl $2016,%esi
	movl %eax,%edx
	andl $2016,%edx
	cmpl %edx,%esi
	jnz L537
L511:
	andl $2048,%ecx
	andl $2048,%eax
	cmpl %eax,%ecx
	jz L480
	jnz L537
L482:
	movl %ecx,%esi
	andl $4,%esi
	movl %eax,%edx
	andl $4,%edx
	cmpl %edx,%esi
	jnz L537
L485:
	movl %ecx,%esi
	andl $8,%esi
	movl %eax,%edx
	andl $8,%edx
	cmpl %edx,%esi
	jnz L537
L489:
	andl $16,%ecx
	andl $16,%eax
	cmpl %eax,%ecx
	jnz L537
L493:
	movq 8(%r13),%rax
	cmpq 8(%r12),%rax
	jnz L537
L497:
	leaq 16(%r12),%rsi
	leaq 16(%r13),%rdi
	call _same_regmap
	testl %eax,%eax
	jz L537
L501:
	leaq 40(%r12),%rsi
	leaq 40(%r13),%rdi
	call _same_regmap
	testl %eax,%eax
	jz L537
L480:
	movl (%r13),%ebx
	andl $805306368,%ebx
	sarl $28,%ebx
	movl 4(%r13),%eax
	shll $21,%eax
	shrl $26,%eax
	addl %eax,%ebx
	xorl %r14d,%r14d
L528:
	cmpl %r14d,%ebx
	jle L531
L529:
	movl %r14d,%eax
	shlq $5,%rax
	leaq 8(%rax,%r12),%rsi
	leaq 8(%r13,%rax),%rdi
	call _same_operand
	testl %eax,%eax
	jz L537
L534:
	incl %r14d
	jmp L528
L537:
	xorl %eax,%eax
	jmp L470
L531:
	movl $1,%eax
L470:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_out_operand:
L543:
	pushq %rbx
L544:
	movq %rdi,%rbx
	movl (%rbx),%eax
	andl $7,%eax
	cmpl $1,%eax
	jz L549
L625:
	cmpl $2,%eax
	jz L558
L626:
	cmpl $4,%eax
	jz L572
L627:
	cmpl $3,%eax
	jnz L545
L572:
	testl %esi,%esi
	jz L575
L573:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L577
L576:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $42,(%rcx)
	jmp L575
L577:
	movl $42,%edi
	call ___flushbuf
L575:
	testl $6144,(%rbx)
	jz L581
L579:
	movslq 16(%rbx),%rax
	movq %rax,16(%rbx)
L581:
	movq 24(%rbx),%rax
	testq %rax,%rax
	jnz L582
L589:
	cmpq $0,16(%rbx)
	jnz L582
L585:
	cmpl $0,8(%rbx)
	jnz L584
L593:
	cmpl $0,12(%rbx)
	jnz L584
L582:
	pushq 16(%rbx)
	pushq %rax
	pushq $L569
	call _out
	addq $24,%rsp
L584:
	cmpl $0,8(%rbx)
	jnz L597
L600:
	cmpl $0,12(%rbx)
	jz L598
L597:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L605
L604:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $40,(%rcx)
	jmp L606
L605:
	movl $40,%edi
	call ___flushbuf
L606:
	movl 8(%rbx),%eax
	testl %eax,%eax
	jz L609
L607:
	pushq %rax
	pushq $L610
	call _out
	addq $16,%rsp
L609:
	movl 12(%rbx),%eax
	testl %eax,%eax
	jz L613
L611:
	pushq %rax
	pushq $L614
	call _out
	addq $16,%rsp
L613:
	movl (%rbx),%ecx
	testl $24,%ecx
	jz L617
L615:
	shll $27,%ecx
	shrl $30,%ecx
	movl $1,%eax
	shll %cl,%eax
	pushq %rax
	pushq $L618
	call _out
	addq $16,%rsp
L617:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L620
L619:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $41,(%rcx)
	jmp L545
L620:
	movl $41,%edi
	call ___flushbuf
	jmp L545
L598:
	movq _out_f(%rip),%rsi
	movl $L622,%edi
	call _fputs
	jmp L545
L558:
	testl %esi,%esi
	jnz L561
L559:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L563
L562:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $36,(%rcx)
	jmp L561
L563:
	movl $36,%edi
	call ___flushbuf
L561:
	testl $229376,(%rbx)
	jz L566
L565:
	movsd 16(%rbx),%xmm0
	subq $16,%rsp
	movsd %xmm0,8(%rsp)
	movq $L568,(%rsp)
	call _out
	addq $16,%rsp
	jmp L545
L566:
	pushq 16(%rbx)
	pushq 24(%rbx)
	pushq $L569
	jmp L630
L549:
	testl %esi,%esi
	jz L552
L550:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L554
L553:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $42,(%rcx)
	jmp L552
L554:
	movl $42,%edi
	call ___flushbuf
L552:
	movl 8(%rbx),%ecx
	movl (%rbx),%eax
	shll $10,%eax
	shrl $15,%eax
	pushq %rax
	pushq %rcx
	pushq $L556
L630:
	call _out
	addq $24,%rsp
L545:
	popq %rbx
	ret 

.data
.align 8
L634:
	.quad L635
	.quad L636
	.quad L637
	.quad L638
	.quad L639
	.quad L640
	.quad L641
	.quad L642
	.quad L643
	.quad L644
	.quad L645
	.quad L646
.text

_out_ccs:
L631:
	pushq %rbx
	pushq %r12
L632:
	movl %edi,%r12d
	movq _out_f(%rip),%rsi
	movl $L647,%edi
	call _fputs
	xorl %ebx,%ebx
L649:
	movb %bl,%cl
	movl $1,%eax
	shll %cl,%eax
	testl %r12d,%eax
	jz L654
L652:
	pushq L634(,%rbx,8)
	pushq $L655
	call _out
	addq $16,%rsp
L654:
	incl %ebx
	cmpl $12,%ebx
	jl L649
L651:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L657
L656:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $93,(%rcx)
	jmp L633
L657:
	movl $93,%edi
	call ___flushbuf
L633:
	popq %r12
	popq %rbx
	ret 

.local L670
.comm L670, 8, 8

_out_insn:
L659:
	pushq %rbx
	pushq %r12
	pushq %r13
L660:
	movq %rdi,%r12
	movl (%r12),%ebx
	cmpl $8388609,%ebx
	jz L665
L725:
	cmpl $58720258,%ebx
	jz L669
L726:
	cmpl $-1493172218,%ebx
	jz L677
L727:
	movzbq %bl,%rax
	pushq _insn_text(,%rax,8)
	pushq $L709
	call _out
	addq $16,%rsp
	andl $805306368,%ebx
	sarl $28,%ebx
L710:
	movl %ebx,%eax
	decl %ebx
	testl %eax,%eax
	jz L663
L711:
	movslq %ebx,%rcx
	shlq $5,%rcx
	cmpl $385878080,(%r12)
	setz %al
	movzbl %al,%esi
	leaq 8(%r12,%rcx),%rdi
	call _out_operand
	testl %ebx,%ebx
	jz L710
L714:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L718
L717:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $44,(%rcx)
	jmp L710
L718:
	movl $44,%edi
	call ___flushbuf
	jmp L710
L677:
	movq _out_f(%rip),%rsi
	movl $L678,%edi
	call _fputs
	movl $1,%esi
	leaq 40(%r12),%rdi
	call _out_operand
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L680
L679:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $40,(%rcx)
	jmp L681
L680:
	movl $40,%edi
	call ___flushbuf
L681:
	testl $2016,4(%r12)
	jz L684
L682:
	xorl %ebx,%ebx
	jmp L685
L686:
	testl %ebx,%ebx
	jz L691
L689:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L693
L692:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $44,(%rcx)
	jmp L691
L693:
	movl $44,%edi
	call ___flushbuf
L691:
	leal 2(%rbx),%r13d
	shlq $5,%r13
	xorl %esi,%esi
	leaq 8(%r12,%r13),%rdi
	call _out_operand
	testl $262144,8(%r12,%r13)
	jz L697
L695:
	movl 12(%r13,%r12),%eax
	movl %eax,%ecx
	andl $268435455,%ecx
	shrl $28,%eax
	pushq %rax
	pushq %rcx
	pushq $L698
	call _out
	addq $24,%rsp
L697:
	incl %ebx
L685:
	movl 4(%r12),%eax
	shll $21,%eax
	shrl $26,%eax
	cmpl %eax,%ebx
	jb L686
L684:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L700
L699:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $41,(%rcx)
	jmp L701
L700:
	movl $41,%edi
	call ___flushbuf
L701:
	testl $7,8(%r12)
	jz L663
L702:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L706
L705:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $44,(%rcx)
	jmp L707
L706:
	movl $44,%edi
	call ___flushbuf
L707:
	xorl %esi,%esi
	leaq 8(%r12),%rdi
	call _out_operand
	jmp L663
L669:
	movl 16(%r12),%eax
	pushq %rax
	pushq $L671
	call _out
	addq $16,%rsp
	movq 8(%r12),%rax
	cmpq L670(%rip),%rax
	jz L663
L672:
	pushq %rax
	pushq $L675
	call _out
	addq $16,%rsp
	movq _path(%rip),%rax
	movq %rax,L670(%rip)
	jmp L663
L665:
	pushq 8(%r12)
	pushq $L666
	call _out
	pushq $L667
	call _out
	addq $24,%rsp
L663:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L722
L721:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L661
L722:
	movl $10,%edi
	call ___flushbuf
L661:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_insn_defs_cc0:
L729:
L730:
	movl (%rdi),%eax
	cmpl $-1610612724,%eax
	jz L741
L750:
	cmpl $-1342177266,%eax
	jz L741
L751:
	cmpl $-1342177265,%eax
	jz L741
L752:
	cmpl $-1342177264,%eax
	jz L741
L753:
	cmpl $-1342177263,%eax
	jz L741
L754:
	cmpl $8388609,%eax
	jnz L748
L735:
	movl 4(%rdi),%eax
	shll $27,%eax
	shrl $31,%eax
	ret
L741:
	testl $2129856,8(%rdi)
	jnz L742
L748:
	xorl %eax,%eax
	ret
L742:
	movl $1,%eax
L731:
	ret 


_insn_uses_mem0:
L757:
L758:
	movl (%rdi),%eax
	cmpl $8388609,%eax
	jz L763
L778:
	xorl %ecx,%ecx
	testl $2147483648,%eax
	jz L768
L765:
	testl $1073741824,%eax
	setz %al
	movzbl %al,%ecx
L768:
	movl (%rdi),%eax
	andl $805306368,%eax
	sarl $28,%eax
	cmpl %eax,%ecx
	jge L771
L769:
	movslq %ecx,%rax
	shlq $5,%rax
	movl 8(%rdi,%rax),%eax
	andl $7,%eax
	cmpl $3,%eax
	jz L772
L774:
	incl %ecx
	jmp L768
L772:
	movl $1,%eax
	ret
L771:
	xorl %eax,%eax
	ret
L763:
	movl 4(%rdi),%eax
	shll $29,%eax
	shrl $31,%eax
L759:
	ret 


_insn_defs_mem0:
L780:
L781:
	movl (%rdi),%eax
	cmpl $8388609,%eax
	jz L786
L798:
	testl $2147483648,%eax
	jz L790
L791:
	movl 8(%rdi),%eax
	andl $7,%eax
	cmpl $3,%eax
	jnz L790
L788:
	movl $1,%eax
	ret
L790:
	xorl %eax,%eax
	ret
L786:
	movl 4(%rdi),%eax
	shll $28,%eax
	shrl $31,%eax
L782:
	ret 

.align 4
L907:
	.int 186
	.int 187
	.int 188
	.int 189
	.int 8388609
	.int 16777400
	.int 41943048
	.int 41943106
	.int 41943107
	.int 50331831
	.int 58720258
	.int 335544700
	.int 335544711
	.int 335544715
	.int 335545480
	.int 335545484
	.int 335545993
	.int 335545997
	.int 335546506
	.int 335546510
	.int 385878080
.align 2
L908:
	.short L898-_insn_uses
	.short L898-_insn_uses
	.short L898-_insn_uses
	.short L898-_insn_uses
	.short L824-_insn_uses
	.short L860-_insn_uses
	.short L828-_insn_uses
	.short L898-_insn_uses
	.short L843-_insn_uses
	.short L858-_insn_uses
	.short L802-_insn_uses
	.short L849-_insn_uses
	.short L849-_insn_uses
	.short L849-_insn_uses
	.short L856-_insn_uses
	.short L856-_insn_uses
	.short L856-_insn_uses
	.short L856-_insn_uses
	.short L856-_insn_uses
	.short L856-_insn_uses
	.short L833-_insn_uses

_insn_uses:
L800:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L801:
	movq %rdi,%r15
	movq %rsi,%r14
	movl %edx,%ebx
	testl $134217728,%ebx
	jz L805
L806:
	testl $134217728,(%r15)
	jz L805
L803:
	movl $1074266112,%esi
	movq %r14,%rdi
	call _add_reg
L805:
	testl $33554432,%ebx
	jz L812
L813:
	testl $33554432,(%r15)
	jnz L810
L817:
	movq %r15,%rdi
	call _insn_uses_mem0
	testl %eax,%eax
	jz L812
L810:
	movl $1074282496,%esi
	movq %r14,%rdi
	call _add_reg
L812:
	movl (%r15),%ecx
	xorl %eax,%eax
L904:
	cmpl L907(,%rax,4),%ecx
	jz L905
L906:
	incl %eax
	cmpl $21,%eax
	jb L904
	jae L822
L905:
	movzwl L908(,%rax,2),%eax
	addl $_insn_uses,%eax
	jmp *%rax
L833:
	xorl %ebx,%ebx
	jmp L834
L835:
	movl _iargs(,%rbx,4),%esi
	movq %r14,%rdi
	call _add_reg
	incl %ebx
L834:
	movl 4(%r15),%eax
	shll $17,%eax
	shrl $29,%eax
	cmpl %eax,%ebx
	jb L835
L837:
	xorl %ebx,%ebx
L838:
	movl 4(%r15),%eax
	shll $13,%eax
	shrl $28,%eax
	cmpl %eax,%ebx
	jae L822
L839:
	movl _fargs(,%rbx,4),%esi
	movq %r14,%rdi
	call _add_reg
	incl %ebx
	jmp L838
L856:
	movl $-2147483648,%esi
	movq %r14,%rdi
	call _add_reg
	movl $-2147450880,%esi
	jmp L910
L849:
	movl $-2147483648,%esi
L910:
	movq %r14,%rdi
	call _add_reg
	jmp L822
L858:
	movl $-2147434496,%esi
	movq %r14,%rdi
	call _add_reg
	movl $-2147418112,%esi
	movq %r14,%rdi
	call _add_reg
	movl $-2147467264,%esi
	jmp L909
L843:
	movl $-1073479680,%esi
	jmp L909
L828:
	movq _func_ret_type(%rip),%rax
	testq $1,(%rax)
	jnz L802
L829:
	movq _func_ret_sym(%rip),%rdi
	call _symbol_to_reg
	movl %eax,%esi
	jmp L909
L860:
	movl $-2147418112,%esi
	movq %r14,%rdi
	call _add_reg
	movl $-2147467264,%esi
	movq %r14,%rdi
	call _add_reg
	jmp L898
L824:
	movq %r14,%rsi
	leaq 16(%r15),%rdi
	call _regmap_regs
	jmp L802
L898:
	movl $-2147483648,%esi
L909:
	movq %r14,%rdi
	call _add_reg
	jmp L802
L822:
	movl (%r15),%r12d
	andl $805306368,%r12d
	sarl $28,%r12d
	movl 4(%r15),%eax
	shll $21,%eax
	shrl $26,%eax
	addl %eax,%r12d
	xorl %r13d,%r13d
	jmp L867
L868:
	testl %r13d,%r13d
	jnz L871
L882:
	movl (%r15),%eax
	testl $2147483648,%eax
	jz L871
L878:
	testl $1073741824,%eax
	jnz L871
L874:
	movl %r13d,%eax
	shlq $5,%rax
	movl 8(%r15,%rax),%eax
	andl $7,%eax
	cmpl $1,%eax
	jz L873
L871:
	movl %r13d,%ebx
	shlq $5,%rbx
	movl 8(%r15,%rbx),%eax
	andl $7,%eax
	cmpl $3,%eax
	jz L890
L900:
	cmpl $4,%eax
	jz L890
L901:
	cmpl $1,%eax
	jz L894
	jnz L873
L890:
	movl 20(%r15,%rbx),%esi
	testl %esi,%esi
	jz L894
L891:
	movq %r14,%rdi
	call _add_reg
L894:
	movl 16(%r15,%rbx),%esi
	testl %esi,%esi
	jz L873
L895:
	movq %r14,%rdi
	call _add_reg
L873:
	incl %r13d
L867:
	cmpl %r12d,%r13d
	jl L868
L802:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.align 4
L983:
	.int 186
	.int 187
	.int 188
	.int 189
	.int 8388609
	.int 16777400
	.int 50331831
	.int 58720258
	.int 335544700
	.int 335544711
	.int 335544715
	.int 335545480
	.int 335545484
	.int 335545993
	.int 335545997
	.int 335546506
	.int 335546510
	.int 385878080
.align 2
L984:
	.short L979-_insn_defs
	.short L969-_insn_defs
	.short L969-_insn_defs
	.short L969-_insn_defs
	.short L939-_insn_defs
	.short L965-_insn_defs
	.short L964-_insn_defs
	.short L913-_insn_defs
	.short L979-_insn_defs
	.short L979-_insn_defs
	.short L979-_insn_defs
	.short L962-_insn_defs
	.short L962-_insn_defs
	.short L962-_insn_defs
	.short L962-_insn_defs
	.short L962-_insn_defs
	.short L962-_insn_defs
	.short L943-_insn_defs

_insn_defs:
L911:
	pushq %rbx
	pushq %r12
	pushq %r13
L912:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl %edx,%r13d
	testl $67108864,%r13d
	jz L916
L917:
	testl $67108864,(%r12)
	jnz L914
L921:
	movq %r12,%rdi
	call _insn_defs_cc0
	testl %eax,%eax
	jz L916
L914:
	movl $1074266112,%esi
	movq %rbx,%rdi
	call _add_reg
L916:
	testl $16777216,%r13d
	jz L927
L928:
	testl $16777216,(%r12)
	jnz L925
L932:
	movq %r12,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jz L927
L925:
	movl $1074282496,%esi
	movq %rbx,%rdi
	call _add_reg
L927:
	movl (%r12),%ecx
	xorl %eax,%eax
L980:
	cmpl L983(,%rax,4),%ecx
	jz L981
L982:
	incl %eax
	cmpl $18,%eax
	jb L980
	jae L936
L981:
	movzwl L984(,%rax,2),%eax
	addl $_insn_defs,%eax
	jmp *%rax
L943:
	xorl %r12d,%r12d
L945:
	movl _iscratch(,%r12,4),%esi
	movq %rbx,%rdi
	call _add_reg
	incl %r12d
	cmpl $9,%r12d
	jl L945
L947:
	xorl %r12d,%r12d
L949:
	movl _fscratch(,%r12,4),%esi
	movq %rbx,%rdi
	call _add_reg
	incl %r12d
	cmpl $8,%r12d
	jl L949
	jge L913
L962:
	movl $-2147483648,%esi
	movq %rbx,%rdi
	call _add_reg
	movl $-2147450880,%esi
	jmp L985
L964:
	movl $-2147434496,%esi
	movq %rbx,%rdi
	call _add_reg
L965:
	movl $-2147418112,%esi
	movq %rbx,%rdi
	call _add_reg
	movl $-2147467264,%esi
	jmp L985
L939:
	movq %rbx,%rsi
	leaq 40(%r12),%rdi
	call _regmap_regs
	jmp L913
L969:
	movl $-2147450880,%esi
	movq %rbx,%rdi
	call _add_reg
L979:
	movl $-2147483648,%esi
	jmp L985
L936:
	testl $2147483648,%ecx
	jz L913
L975:
	movl 8(%r12),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L913
L972:
	movl 16(%r12),%esi
L985:
	movq %rbx,%rdi
	call _add_reg
L913:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_insn_substitute_con:
L986:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L987:
	movq %rdi,%r15
	movl %esi,-4(%rbp) # spill
	movq %rdx,-16(%rbp) # spill
	xorl %r14d,%r14d
	movl (%r15),%r13d
	andl $805306368,%r13d
	sarl $28,%r13d
	movl 4(%r15),%eax
	shll $21,%eax
	shrl $26,%eax
	addl %eax,%r13d
	xorl %r12d,%r12d
	jmp L989
L990:
	testl %r12d,%r12d
	jnz L1005
L1012:
	movl (%r15),%eax
	testl $2147483648,%eax
	jz L1005
L1014:
	testl $1073741824,%eax
	jnz L1005
L1010:
	movl %r12d,%eax
	shlq $5,%rax
	movl 8(%r15,%rax),%eax
	andl $7,%eax
	cmpl $1,%eax
	jz L995
L1005:
	movl %r12d,%ebx
	shlq $5,%rbx
	movl 8(%r15,%rbx),%edi
	movl %edi,%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L995
L1001:
	movl -4(%rbp),%eax # spill
	cmpl 16(%rbx,%r15),%eax
	jnz L995
L997:
	shll $10,%edi
	shrl $15,%edi
	leaq 16(%rbp),%rsi
	call _normalize_con
	movl 8(%r15,%rbx),%eax
	andl $4294967288,%eax
	orl $2,%eax
	movl %eax,8(%r15,%rbx)
	movq 16(%rbp),%rax
	movq %rax,24(%rbx,%r15)
	movq -16(%rbp),%rax # spill
	movq %rax,32(%rbx,%r15)
	incl %r14d
L995:
	incl %r12d
L989:
	cmpl %r12d,%r13d
	jg L990
L992:
	movl %r14d,%eax
L988:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_insn_substitute_reg:
L1032:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L1033:
	movq %rdi,%r15
	movl %esi,%r14d
	movl %edx,%r13d
	movl %ecx,-12(%rbp) # spill
	movq %r8,-8(%rbp) # spill
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	movl (%r15),%ecx
	cmpl $8388609,%ecx
	jnz L1036
L1035:
	testl $2,-12(%rbp) # spill
	jz L1040
L1038:
	movl %r13d,%edx
	movl %r14d,%esi
	leaq 16(%r15),%rdi
	call _regmap_substitute
	movl %eax,%r12d
L1040:
	testl $1,-12(%rbp) # spill
	jz L1037
L1041:
	movl %r13d,%edx
	movl %r14d,%esi
	leaq 40(%r15),%rdi
	call _regmap_substitute
	addl %eax,%r12d
	jmp L1037
L1036:
	andl $805306368,%ecx
	sarl $28,%ecx
	movl 4(%r15),%eax
	shll $21,%eax
	shrl $26,%eax
	addl %eax,%ecx
	xorl %eax,%eax
	jmp L1044
L1048:
	xorl %r8d,%r8d
	testl $2,-12(%rbp) # spill
	jz L1053
L1054:
	testl %eax,%eax
	jnz L1059
L1066:
	movl (%r15),%edx
	testl $2147483648,%edx
	jz L1059
L1068:
	testl $1073741824,%edx
	jnz L1059
L1064:
	movl %eax,%edx
	shlq $5,%rdx
	movl 8(%r15,%rdx),%edx
	andl $7,%edx
	cmpl $1,%edx
	jz L1053
L1059:
	movl %eax,%edi
	shlq $5,%rdi
	movl 8(%r15,%rdi),%edx
	movl %edx,%esi
	andl $7,%esi
	cmpl $3,%esi
	jz L1074
L1135:
	cmpl $4,%esi
	jz L1074
L1136:
	cmpl $1,%esi
	jz L1078
	jnz L1071
L1074:
	cmpl 20(%r15,%rdi),%r14d
	jnz L1078
L1075:
	movl $1,%r8d
	movl %r13d,20(%r15,%rdi)
L1078:
	cmpl 16(%r15,%rdi),%r14d
	jnz L1071
L1079:
	incl %r8d
	movl %r13d,16(%r15,%rdi)
L1071:
	testl %r8d,%r8d
	jz L1084
L1082:
	cmpl $3,%esi
	jnz L1086
L1085:
	movl $256,%ebx
	jmp L1084
L1086:
	shll $10,%edx
	shrl $15,%edx
	cmpq %rdx,%rbx
	cmovleq %rdx,%rbx
L1084:
	addl %r8d,%r12d
L1053:
	xorl %r8d,%r8d
	testl $1,-12(%rbp) # spill
	jz L1096
L1097:
	testl %eax,%eax
	jnz L1096
L1105:
	testl $2147483648,(%r15)
	jz L1096
L1106:
	movl 8(%r15),%edx
	andl $7,%edx
	cmpl $1,%edx
	jnz L1096
L1102:
	movl %eax,%edi
	shlq $5,%rdi
	movl 8(%r15,%rdi),%edx
	movl %edx,%esi
	andl $7,%esi
	cmpl $3,%esi
	jz L1113
L1140:
	cmpl $4,%esi
	jz L1113
L1141:
	cmpl $1,%esi
	jz L1117
	jnz L1110
L1113:
	cmpl 20(%r15,%rdi),%r14d
	jnz L1117
L1114:
	movl $1,%r8d
	movl %r13d,20(%r15,%rdi)
L1117:
	cmpl 16(%r15,%rdi),%r14d
	jnz L1110
L1118:
	incl %r8d
	movl %r13d,16(%r15,%rdi)
L1110:
	testl %r8d,%r8d
	jz L1123
L1121:
	cmpl $3,%esi
	jnz L1125
L1124:
	movl $256,%ebx
	jmp L1123
L1125:
	shll $10,%edx
	shrl $15,%edx
	cmpq %rdx,%rbx
	cmovleq %rdx,%rbx
L1123:
	addl %r8d,%r12d
L1096:
	incl %eax
L1044:
	cmpl %eax,%ecx
	jg L1048
L1037:
	cmpq $0,-8(%rbp) # spill
	jz L1132
L1130:
	movq -8(%rbp),%rax # spill
	movq %rbx,(%rax)
L1132:
	movl %r12d,%eax
L1034:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_insn_is_copy:
L1144:
L1145:
	movl (%rdi),%eax
	cmpl $-1610612727,%eax
	jz L1156
L1167:
	cmpl $-1610604220,%eax
	jz L1156
L1168:
	cmpl $-1610578875,%eax
	jz L1156
L1169:
	cmpl $-1610561978,%eax
	jz L1156
L1170:
	cmpl $-1610545081,%eax
	jz L1156
L1171:
	cmpl $-1610528184,%eax
	jz L1156
L1172:
	cmpl $-1610519735,%eax
	jnz L1147
L1156:
	movl 8(%rdi),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L1147
L1160:
	movl 40(%rdi),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L1147
L1157:
	movl 16(%rdi),%eax
	movl %eax,(%rsi)
	movl 48(%rdi),%eax
	movl %eax,(%rdx)
	movl $1,%eax
	ret
L1147:
	xorl %eax,%eax
L1146:
	ret 


_insn_is_cmpz:
L1175:
L1176:
	cmpl $603979787,(%rdi)
	jnz L1178
L1182:
	movl 8(%rdi),%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L1190
L1196:
	cmpq $0,32(%rdi)
	jnz L1190
L1197:
	cmpq $0,24(%rdi)
	jnz L1190
L1193:
	movl 40(%rdi),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L1190
L1189:
	movl 48(%rdi),%eax
	jmp L1225
L1190:
	movl 40(%rdi),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L1178
L1215:
	cmpq $0,64(%rdi)
	jnz L1178
L1216:
	cmpq $0,56(%rdi)
	jnz L1178
L1212:
	cmpl $1,%ecx
	jz L1208
L1178:
	xorl %eax,%eax
	ret
L1208:
	movl 16(%rdi),%eax
L1225:
	movl %eax,(%rsi)
	movl $1,%eax
L1177:
	ret 


_insn_is_cmp_con:
L1226:
L1227:
	cmpl $603979787,(%rdi)
	jnz L1229
L1233:
	movl 8(%rdi),%ecx
	andl $7,%ecx
	cmpl $2,%ecx
	jnz L1241
L1243:
	cmpq $0,32(%rdi)
	jnz L1241
L1244:
	movl 40(%rdi),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L1241
L1240:
	movl 48(%rdi),%eax
	jmp L1268
L1241:
	movl 40(%rdi),%eax
	andl $7,%eax
	cmpl $2,%eax
	jnz L1229
L1258:
	cmpq $0,64(%rdi)
	jnz L1229
L1259:
	cmpl $1,%ecx
	jz L1255
L1229:
	xorl %eax,%eax
	ret
L1255:
	movl 16(%rdi),%eax
L1268:
	movl %eax,(%rsi)
	movl $1,%eax
L1228:
	ret 

L645:
	.byte 65,69,0
L269:
	.byte 99,118,116,115,115,50,115,100
	.byte 0
L639:
	.byte 71,0
L255:
	.byte 115,101,116,98,101,0
L4:
	.byte 106,110,115,0
L189:
	.byte 110,111,116,113,0
L5:
	.byte 106,103,0
L675:
	.byte 44,34,37,83,34,0
L218:
	.byte 100,105,118,98,0
L133:
	.byte 79,82,0
L197:
	.byte 97,100,100,113,0
L640:
	.byte 76,69,0
L159:
	.byte 109,111,118,122,98,119,0
L144:
	.byte 83,69,84,66,69,0
L122:
	.byte 67,77,80,0
L12:
	.byte 106,98,0
L172:
	.byte 99,118,116,115,105,50,115,100
	.byte 108,0
L646:
	.byte 66,0
L216:
	.byte 105,100,105,118,108,0
L231:
	.byte 115,104,108,119,0
L259:
	.byte 98,115,102,113,0
L149:
	.byte 66,76,75,67,80,89,0
L247:
	.byte 115,101,116,110,122,0
L223:
	.byte 115,104,114,119,0
L709:
	.byte 9,37,115,32,0
L220:
	.byte 100,105,118,108,0
L211:
	.byte 109,117,108,115,100,0
L135:
	.byte 83,69,84,90,0
L117:
	.byte 83,84,79,82,69,0
L569:
	.byte 37,71,0
L235:
	.byte 97,110,100,119,0
L8:
	.byte 106,108,0
L678:
	.byte 9,67,65,76,76,32,0
L134:
	.byte 88,79,82,0
L158:
	.byte 109,111,118,115,100,0
L641:
	.byte 71,69,0
L191:
	.byte 110,101,103,119,0
L154:
	.byte 109,111,118,119,0
L214:
	.byte 105,100,105,118,98,0
L115:
	.byte 70,82,65,77,69,0
L254:
	.byte 115,101,116,97,0
L136:
	.byte 83,69,84,78,90,0
L642:
	.byte 76,0
L126:
	.byte 83,85,66,0
L190:
	.byte 110,101,103,98,0
L164:
	.byte 109,111,118,115,98,113,0
L127:
	.byte 77,85,76,0
L7:
	.byte 106,103,101,0
L234:
	.byte 97,110,100,98,0
L124:
	.byte 67,79,77,0
L160:
	.byte 109,111,118,122,98,108,0
L153:
	.byte 109,111,118,98,0
L128:
	.byte 68,73,86,0
L215:
	.byte 105,100,105,118,119,0
L199:
	.byte 97,100,100,115,100,0
L230:
	.byte 115,104,108,98,0
L183:
	.byte 117,99,111,109,105,115,100,0
L205:
	.byte 115,117,98,115,100,0
L150:
	.byte 66,76,75,83,69,84,0
L129:
	.byte 77,79,68,0
L222:
	.byte 115,104,114,98,0
L114:
	.byte 78,79,80,0
L666:
	.byte 37,83,0
L177:
	.byte 99,118,116,116,115,100,50,115
	.byte 105,113,0
L671:
	.byte 9,46,108,105,110,101,32,37
	.byte 100,0
L556:
	.byte 37,82,0
L622:
	.byte 40,37,114,105,112,41,0
L171:
	.byte 99,118,116,115,105,50,115,115
	.byte 113,0
L155:
	.byte 109,111,118,108,0
L6:
	.byte 106,108,101,0
L236:
	.byte 97,110,100,108,0
L618:
	.byte 44,37,100,0
L192:
	.byte 110,101,103,108,0
L13:
	.byte 106,109,112,0
L246:
	.byte 115,101,116,122,0
L185:
	.byte 108,101,97,113,0
L667:
	.byte 10,0
L203:
	.byte 115,117,98,113,0
L168:
	.byte 109,111,118,115,119,113,0
L165:
	.byte 109,111,118,122,119,108,0
L121:
	.byte 67,65,83,84,0
L11:
	.byte 106,97,101,0
L270:
	.byte 99,118,116,115,100,50,115,115
	.byte 0
L637:
	.byte 83,0
L245:
	.byte 120,111,114,113,0
L174:
	.byte 99,118,116,116,115,115,50,115
	.byte 105,108,0
L232:
	.byte 115,104,108,108,0
L181:
	.byte 99,109,112,113,0
L261:
	.byte 98,115,114,113,0
L638:
	.byte 78,83,0
L229:
	.byte 115,97,114,113,0
L3:
	.byte 106,115,0
L241:
	.byte 111,114,113,0
L224:
	.byte 115,104,114,108,0
L219:
	.byte 100,105,118,119,0
L213:
	.byte 100,105,118,115,100,0
L272:
	.byte 112,111,112,113,0
L209:
	.byte 105,109,117,108,113,0
L143:
	.byte 83,69,84,65,0
L610:
	.byte 37,114,0
L271:
	.byte 112,117,115,104,113,0
L201:
	.byte 115,117,98,119,0
L123:
	.byte 78,69,71,0
L145:
	.byte 83,69,84,65,69,0
L131:
	.byte 83,72,76,0
L194:
	.byte 97,100,100,98,0
L146:
	.byte 83,69,84,66,0
L251:
	.byte 115,101,116,108,101,0
L152:
	.byte 114,101,116,0
L264:
	.byte 114,101,112,0
L186:
	.byte 110,111,116,98,0
L116:
	.byte 76,79,65,68,0
L227:
	.byte 115,97,114,119,0
L239:
	.byte 111,114,119,0
L221:
	.byte 100,105,118,113,0
L148:
	.byte 66,83,82,0
L207:
	.byte 105,109,117,108,119,0
L139:
	.byte 83,69,84,71,0
L644:
	.byte 66,69,0
L258:
	.byte 98,115,102,108,0
L140:
	.byte 83,69,84,76,69,0
L266:
	.byte 99,119,116,100,0
L256:
	.byte 115,101,116,97,101,0
L243:
	.byte 120,111,114,119,0
L179:
	.byte 99,109,112,119,0
L263:
	.byte 115,116,111,115,98,0
L217:
	.byte 105,100,105,118,113,0
L248:
	.byte 115,101,116,115,0
L173:
	.byte 99,118,116,115,105,50,115,100
	.byte 113,0
L267:
	.byte 99,108,116,100,0
L125:
	.byte 65,68,68,0
L647:
	.byte 91,32,0
L162:
	.byte 109,111,118,115,98,119,0
L252:
	.byte 115,101,116,103,101,0
L196:
	.byte 97,100,100,108,0
L142:
	.byte 83,69,84,76,0
L210:
	.byte 109,117,108,115,115,0
L268:
	.byte 99,113,116,111,0
L157:
	.byte 109,111,118,115,115,0
L636:
	.byte 78,90,0
L188:
	.byte 110,111,116,108,0
L1:
	.byte 106,122,0
L141:
	.byte 83,69,84,71,69,0
L635:
	.byte 90,0
L240:
	.byte 111,114,108,0
L225:
	.byte 115,104,114,113,0
L119:
	.byte 82,69,84,85,82,78,0
L130:
	.byte 83,72,82,0
L208:
	.byte 105,109,117,108,108,0
L260:
	.byte 98,115,114,108,0
L2:
	.byte 106,110,122,0
L228:
	.byte 115,97,114,108,0
L257:
	.byte 115,101,116,98,0
L655:
	.byte 37,115,32,0
L244:
	.byte 120,111,114,108,0
L175:
	.byte 99,118,116,116,115,115,50,115
	.byte 105,113,0
L169:
	.byte 109,111,118,115,108,113,0
L233:
	.byte 115,104,108,113,0
L180:
	.byte 99,109,112,108,0
L698:
	.byte 32,60,37,100,58,37,100,62
	.byte 0
L198:
	.byte 97,100,100,115,115,0
L166:
	.byte 109,111,118,122,119,113,0
L250:
	.byte 115,101,116,103,0
L184:
	.byte 108,101,97,108,0
L182:
	.byte 117,99,111,109,105,115,115,0
L204:
	.byte 115,117,98,115,115,0
L202:
	.byte 115,117,98,108,0
L167:
	.byte 109,111,118,115,119,108,0
L237:
	.byte 97,110,100,113,0
L262:
	.byte 109,111,118,115,98,0
L193:
	.byte 110,101,103,113,0
L170:
	.byte 99,118,116,115,105,50,115,115
	.byte 108,0
L156:
	.byte 109,111,118,113,0
L226:
	.byte 115,97,114,98,0
L176:
	.byte 99,118,116,116,115,100,50,115
	.byte 105,108,0
L118:
	.byte 65,82,71,0
L614:
	.byte 44,37,114,0
L187:
	.byte 110,111,116,119,0
L9:
	.byte 106,97,0
L249:
	.byte 115,101,116,110,115,0
L206:
	.byte 105,109,117,108,98,0
L147:
	.byte 66,83,70,0
L238:
	.byte 111,114,98,0
L137:
	.byte 83,69,84,83,0
L10:
	.byte 106,98,101,0
L178:
	.byte 99,109,112,98,0
L242:
	.byte 120,111,114,98,0
L643:
	.byte 65,0
L265:
	.byte 99,98,116,119,0
L253:
	.byte 115,101,116,108,0
L120:
	.byte 77,79,86,69,0
L138:
	.byte 83,69,84,78,83,0
L132:
	.byte 65,78,68,0
L568:
	.byte 37,102,0
L200:
	.byte 115,117,98,98,0
L151:
	.byte 99,97,108,108,0
L195:
	.byte 97,100,100,119,0
L212:
	.byte 100,105,118,115,115,0
L161:
	.byte 109,111,118,122,98,113,0
L163:
	.byte 109,111,118,115,98,108,0

.globl _cc_text
.globl _fargs
.globl _nop_insn
.globl _insn_defs_mem0
.globl _union_cc
.globl _symbol_to_reg
.globl _fscratch
.globl _insn_uses_mem0
.globl _iscratch
.globl _func_ret_type
.globl _path
.globl _iargs
.globl _regmap_substitute
.globl _intersect_cc
.globl ___builtin_memset
.globl _line_no
.globl _insn_is_copy
.globl _insn_substitute_reg
.globl _insn_is_cmpz
.globl _add_reg
.globl _commute_insn
.globl _normalize_con
.globl ___flushbuf
.globl _out
.globl _same_operand
.globl _same_regmap
.globl ___builtin_memcpy
.globl _normalize_operand
.globl _out_f
.globl _new_insn
.globl _func_ret_sym
.globl _func_arena
.globl _insn_defs_cc0
.globl _same_insn
.globl _dup_insn
.globl _out_ccs
.globl _regmap_regs
.globl _insn_substitute_con
.globl _fputs
.globl _out_insn
.globl _out_operand
.globl _insn_is_cmp_con
.globl _dup_vector
.globl _insn_defs
.globl _insn_uses
.globl _commuted_cc
