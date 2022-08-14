.text

_push:
L1:
L2:
	movq _stmt_arena+8(%rip),%rdx
	movq %rdx,%rcx
	andl $7,%ecx
	jz L9
L7:
	movl $8,%eax
	subq %rcx,%rax
	addq %rax,%rdx
	movq %rdx,_stmt_arena+8(%rip)
L9:
	movq _stmt_arena+8(%rip),%rcx
	leaq 24(%rcx),%rax
	movq %rax,_stmt_arena+8(%rip)
	movq %rdi,(%rcx)
	movq $0,8(%rcx)
	movq _state(%rip),%rax
	movq %rax,16(%rcx)
	movq %rcx,_state(%rip)
L3:
	ret 


_header:
L10:
	pushq %rbx
L11:
	movq %rdi,%rbx
	movq 32(%rbx),%rax
	testq $131072,(%rax)
	movl $2,%eax
	movl $1,%edi
	cmovzl %eax,%edi
	call _seg
	movq 32(%rbx),%rdi
	call _align_of
	cmpl $1,%eax
	jle L18
L16:
	pushq %rax
	pushq $L19
	call _out
	addq $16,%rsp
L18:
	pushq %rbx
	pushq $L20
	call _out
	addq $16,%rsp
L12:
	popq %rbx
	ret 


_ref:
L21:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L22:
	movq _state(%rip),%rax
	movq %rdi,%rbx
	movl %esi,%r12d
	movq (%rax),%rdi
	call _sym_tree
	movq %rax,%r13
	movq %rbx,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %r13,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%r13
	movq %r13,%rax
	testl %r12d,%r12d
	jz L23
L24:
	movslq %r12d,%r12
	movq %r12,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_long_type,%edi
	call _con_tree
	movq %rax,%r12
	movq %rbx,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %r12,%rcx
	movq %r13,%rdx
	movq %rax,%rsi
	movl $536870938,%edi
	call _binary_tree
L23:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_next:
L28:
L29:
	movq _pushback(%rip),%rax
	testq %rax,%rax
	jz L32
L31:
	movq $0,_pushback(%rip)
	ret
L32:
	movq _state(%rip),%rax
	cmpq $0,(%rax)
	jz L35
L34:
	call _assignment
	ret
L35:
	call _static_expr
L30:
	ret 

.local L41
.comm L41, 1, 1
.local L42
.comm L42, 4, 4

_out_bits:
L38:
	pushq %rbx
	pushq %r12
L39:
	movq %rdi,%rbx
	movl %esi,%r12d
L43:
	movl %r12d,%eax
	decl %r12d
	testl %eax,%eax
	jz L40
L44:
	movb L41(%rip),%al
	sarb $1,%al
	movb %al,L41(%rip)
	testq $1,%rbx
	jz L47
L46:
	orb $-128,%al
	jmp L53
L47:
	andb $127,%al
L53:
	movb %al,L41(%rip)
	movl L42(%rip),%eax
	sarq $1,%rbx
	leal 1(%rax),%ecx
	movl %ecx,L42(%rip)
	movl $8,%ecx
	incl %eax
	cltd 
	idivl %ecx
	testl %edx,%edx
	jnz L43
L49:
	movzbl L41(%rip),%eax
	pushq %rax
	pushq $L52
	call _out
	addq $16,%rsp
	jmp L43
L40:
	popq %r12
	popq %rbx
	ret 


_out_word:
L54:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L55:
	movq %rsi,%rbx
	movq %rdi,%rax
	andl $7168,%eax
	andl $131071,%edi
	testq %rax,%rax
	jz L58
L57:
	cmpq $1024,%rdi
	jz L63
L93:
	cmpq $2048,%rdi
	jz L67
L94:
	cmpq $4096,%rdi
	jnz L56
L67:
	movq 16(%rbp),%rax
	movsd 16(%rbp),%xmm0
	subq $24,%rsp
	movsd %xmm0,16(%rsp)
	movq %rax,8(%rsp)
	movq $L68,(%rsp)
	jmp L109
L63:
	cvtsd2ss 16(%rbp),%xmm0
	movss %xmm0,-4(%rbp)
	movl -4(%rbp),%eax
	cvtss2sd %xmm0,%xmm0
	subq $24,%rsp
	movsd %xmm0,16(%rsp)
	movl %eax,8(%rsp)
	movq $L64,(%rsp)
	jmp L109
L58:
	cmpq $2,%rdi
	jz L75
	jl L71
L98:
	cmpq $65536,%rdi
	jz L88
	jg L71
L99:
	cmpl $4,%edi
	jz L75
L100:
	cmpl $8,%edi
	jz L75
L101:
	cmpl $16,%edi
	jz L79
L102:
	cmpl $32,%edi
	jz L79
L103:
	cmpl $64,%edi
	jz L83
L104:
	cmpl $128,%edi
	jz L83
L105:
	cmpl $256,%edi
	jz L88
L106:
	cmpl $512,%edi
	jz L88
	jnz L71
L83:
	movq _out_f(%rip),%rsi
	movl $L84,%edi
	jmp L110
L79:
	movq _out_f(%rip),%rsi
	movl $L80,%edi
	jmp L110
L88:
	movq _out_f(%rip),%rsi
	movl $L89,%edi
	jmp L110
L75:
	movq _out_f(%rip),%rsi
	movl $L76,%edi
L110:
	call _fputs
L71:
	pushq 16(%rbp)
	pushq %rbx
	pushq $L91
L109:
	call _out
	addq $24,%rsp
L56:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_init_pad:
L111:
	pushq %rbx
L112:
	movq _state(%rip),%rax
	movl %edi,%ebx
	cmpq $0,(%rax)
	jnz L113
L114:
	movl $8,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	movl %edx,%esi
	testl %esi,%esi
	jz L119
L117:
	xorl %edi,%edi
	call _out_bits
L119:
	movl $8,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	testl %eax,%eax
	jz L113
L120:
	pushq %rax
	pushq $L123
	call _out
	addq $16,%rsp
L113:
	popq %rbx
	ret 


_init_value:
L124:
	pushq %rbx
	pushq %r12
	pushq %r13
L125:
	movq _state(%rip),%rax
	movq %rdi,%r12
	movq %rdx,%rbx
	movq (%rax),%rdi
	testq %rdi,%rdi
	jz L128
L127:
	movq 32(%rdi),%rax
	testq $73726,(%rax)
	jnz L131
L130:
	movq %r12,%rdi
	call _ref
	movq %rax,%rdx
	movq %r12,%rsi
	movl $1342177283,%edi
	call _unary_tree
	movq %rax,%r13
	movq %r12,%rdi
	call _unfieldify
	movq %rax,8(%r13)
	jmp L132
L131:
	call _sym_tree
	movq %rax,%r13
L132:
	movq %rbx,%rdx
	movq %r13,%rsi
	movl $1048634,%edi
	call _build_tree
	movq _state(%rip),%rcx
	movq %rax,%rsi
	movq 8(%rcx),%rdi
	call _seq_tree
	movq _state(%rip),%rcx
	movq %rax,8(%rcx)
	jmp L126
L128:
	movl $1048634,%edx
	movq %r12,%rsi
	movq %rbx,%rdi
	call _fake
	movq %rax,%rdi
	call _fold
	movq %rax,%rbx
	movq (%r12),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L134
L133:
	cmpl $2147483650,(%rbx)
	jnz L136
L139:
	cmpq $0,24(%rbx)
	jz L138
L136:
	pushq $L143
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L138:
	movq $545460846592,%rsi
	andq (%r12),%rsi
	sarq $32,%rsi
	movq 16(%rbx),%rdi
	call _out_bits
	jmp L126
L134:
	movq 8(%rbx),%rax
	movq (%rax),%rdi
	movq 24(%rbx),%rsi
	subq $8,%rsp
	movq 16(%rbx),%rax
	movq %rax,(%rsp)
	call _out_word
	addq $8,%rsp
L126:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_init_strlit:
L144:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L145:
	movq %rdi,%r13
	movl %esi,%r12d
	testq $16384,(%r13)
	jz L148
L150:
	cmpl $0,16(%r13)
	jnz L148
L147:
	movq _token+24(%rip),%rax
	movl 4(%rax),%ebx
	incl %ebx
	jmp L149
L148:
	movl 16(%r13),%ebx
	movq _token+24(%rip),%rax
	cmpl 4(%rax),%ebx
	jge L149
L154:
	pushq $L157
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L149:
	movq _state(%rip),%rax
	movq (%rax),%rax
	movq _token+24(%rip),%rdi
	testq %rax,%rax
	jz L159
L158:
	movl 4(%rdi),%eax
	cmpl %eax,%ebx
	movl %ebx,%r14d
	cmovgel %eax,%r14d
	call _literal
	movq %rax,%rdi
	call _sym_tree
	movq %rax,%r15
	movq 8(%r15),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	movq %r15,%rdx
	movq %rax,%rsi
	movl $1073741831,%edi
	call _unary_tree
	movq %rax,%r15
	movslq %r14d,%r14
	movq %r14,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_ulong_type,%edi
	call _con_tree
	movq %rax,%r14
	movl %r12d,%esi
	movq %r13,%rdi
	call _ref
	movq %r14,%rcx
	movq %r15,%rdx
	movq %rax,%rsi
	movl $45,%edi
	call _blk_tree
	movq _state(%rip),%rcx
	movq %rax,%rsi
	movq 8(%rcx),%rdi
	call _seq_tree
	movq _state(%rip),%rcx
	movq %rax,8(%rcx)
	jmp L160
L159:
	movl %ebx,%esi
	call _out_literal
L160:
	call _lex
	movl %ebx,%eax
L146:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_init_array:
L165:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L166:
	movq %rdi,%r15
	movl %esi,-4(%rbp)
	movl %edx,%ebx
	movq 24(%r15),%r14
	xorl %esi,%esi
	movq %r14,%rdi
	call _size_of
	movl %eax,%r13d
	xorl %r12d,%r12d
L168:
	testq $16384,(%r15)
	jz L175
L179:
	cmpl $0,16(%r15)
	jz L174
L175:
	cmpl 16(%r15),%r12d
	jnz L174
L172:
	pushq $L183
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L174:
	movl %r12d,%edx
	imull %r13d,%edx
	addl -4(%rbp),%edx
	xorl %esi,%esi
	movq %r14,%rdi
	call _init
	incl %r12d
	testl $2,%ebx
	jnz L186
L187:
	cmpl 16(%r15),%r12d
	jz L171
L186:
	cmpl $21,_token(%rip)
	jnz L171
L192:
	call _lex
	jmp L168
L171:
	testq $16384,(%r15)
	jz L196
L199:
	cmpl $0,16(%r15)
	jz L198
L196:
	movl 16(%r15),%edi
	subl %r12d,%edi
	imull %r13d,%edi
	shll $3,%edi
	call _init_pad
L198:
	movl %r12d,%eax
L167:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_init_strun:
L204:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L205:
	movq %rdi,-8(%rbp)
	movl %esi,-12(%rbp)
	movl %edx,%ebx
	xorl %r12d,%r12d
	movq -8(%rbp),%rax
	movq 16(%rax),%r15
	movq 40(%r15),%r14
L210:
	testq %r14,%r14
	jz L215
L213:
	testl $33554432,12(%r14)
	jz L215
L214:
	movq 56(%r14),%r14
	jmp L210
L215:
	testl $1073741824,12(%r15)
	jnz L221
L217:
	pushq %r15
	pushq $L220
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L221:
	testq %r14,%r14
	jnz L227
L225:
	pushq %r15
	pushq $L228
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L227:
	movl 48(%r14),%r13d
	shll $3,%r13d
	subl %r12d,%r13d
	movq 32(%r14),%rax
	movq (%rax),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L231
L229:
	movq $69269232549888,%rax
	andq %rcx,%rax
	sarq $40,%rax
	addl %eax,%r13d
L231:
	movl %r13d,%edi
	call _init_pad
	addl %r13d,%r12d
	movq 32(%r14),%rdi
	movl 48(%r14),%edx
	addl -12(%rbp),%edx
	xorl %esi,%esi
	call _init
	movq 32(%r14),%rdi
	movq (%rdi),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L233
L232:
	movq $545460846592,%rax
	andq %rcx,%rax
	sarq $32,%rax
	jmp L261
L233:
	xorl %esi,%esi
	call _size_of
	shll $3,%eax
L261:
	addl %eax,%r12d
L260:
	movq 56(%r14),%r14
	testq %r14,%r14
	jz L243
L241:
	testl $33554432,12(%r14)
	jnz L260
L243:
	testl $2,12(%r15)
	movl $0,%eax
	cmovnzq %rax,%r14
	testl $2,%ebx
	jnz L253
L251:
	testq %r14,%r14
	jz L224
L253:
	cmpl $21,_token(%rip)
	jnz L224
L256:
	call _lex
	jmp L221
L224:
	xorl %esi,%esi
	movq -8(%rbp),%rdi
	call _size_of
	shll $3,%eax
	subl %r12d,%eax
	movl %eax,%edi
	call _init_pad
L206:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_init:
L262:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L263:
	movq %rdi,%r13
	movl %esi,%ebx
	movl %edx,%r12d
	cmpl $16,_token(%rip)
	jnz L266
L265:
	orl $2,%ebx
	call _lex
	jmp L267
L266:
	andl $-3,%ebx
L267:
	movl _token(%rip),%eax
	cmpl $2,%eax
	jz L273
L271:
	cmpl $16,%eax
	jz L273
L272:
	call _next
	movq %rax,_pushback(%rip)
	jmp L270
L273:
	xorl %eax,%eax
L270:
	movq (%r13),%rcx
	testq $73726,%rcx
	jnz L279
L278:
	testq $8192,%rcx
	jz L284
L290:
	testq %rax,%rax
	jz L284
L291:
	movq 8(%rax),%rax
	testq $8192,(%rax)
	jz L284
L287:
	testl $2,%ebx
	jnz L284
L279:
	call _next
	movl %ebx,%ecx
	movq %rax,%rdx
	movl %r12d,%esi
	movq %r13,%rdi
	call _init_value
	jmp L277
L284:
	testq $16384,%rcx
	jz L296
L301:
	cmpl $0,16(%r13)
	jnz L296
L302:
	testl $1,%ebx
	jnz L296
L298:
	pushq $L305
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L296:
	testq $16384,(%r13)
	jz L311
L313:
	movq 24(%r13),%rax
	testq $14,(%rax)
	jz L311
L314:
	cmpl $2,_token(%rip)
	jnz L311
L310:
	movl %ebx,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _init_strlit
	jmp L342
L311:
	testl $1,%ebx
	jz L319
L320:
	testl $2,%ebx
	jnz L319
L321:
	pushq $L324
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L319:
	testq $8192,(%r13)
	jz L326
L325:
	movl %ebx,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _init_strun
	jmp L277
L326:
	movl %ebx,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _init_array
L342:
	movl %eax,%r14d
L277:
	testl $2,%ebx
	jz L330
L331:
	movl $17,%edi
	call _expect
	call _lex
L330:
	testq $16384,(%r13)
	jz L336
L337:
	cmpl $0,16(%r13)
	jnz L336
L338:
	movslq %r14d,%rsi
	movq 24(%r13),%rdx
	movl $16384,%edi
	call _get_tnode
	movq %rax,%r13
L336:
	movq %r13,%rax
L264:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_init_bss:
L343:
	pushq %rbx
	pushq %r12
	pushq %r13
L344:
	movq %rdi,%r13
	movq 32(%r13),%rdi
	movq (%r13),%rsi
	call _size_of
	movl %eax,%r12d
	movq 32(%r13),%rdi
	call _align_of
	movl %eax,%ebx
	testl $16,12(%r13)
	jz L348
L346:
	pushq %r13
	pushq $L349
	call _out
	addq $16,%rsp
L348:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq $L350
	call _out
	addq $32,%rsp
	orl $1073741824,12(%r13)
L345:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_init_static:
L351:
	pushq %rbx
	pushq %r12
L352:
	movq %rdi,%r12
	movl %esi,%ebx
	cmpl $1048633,_token(%rip)
	jnz L355
L354:
	xorl %edi,%edi
	call _push
	testl $32,%ebx
	jz L359
L357:
	pushq $L360
	pushq (%r12)
	pushq $4
	call _error
	addq $24,%rsp
L359:
	testl $1073741824,12(%r12)
	jz L363
L361:
	pushq %r12
	pushq $L364
	pushq (%r12)
	pushq $4
	call _error
	addq $32,%rsp
L363:
	call _lex
	movq _path(%rip),%rax
	movq %rax,24(%r12)
	movl _line_no(%rip),%eax
	movl %eax,20(%r12)
	orl $1073741824,12(%r12)
	movq %r12,%rdi
	call _header
	xorl %edx,%edx
	movl $1,%esi
	movq 32(%r12),%rdi
	call _init
	movq %rax,32(%r12)
	movq _state(%rip),%rax
	movq 16(%rax),%rax
	movq %rax,_state(%rip)
	jmp L353
L355:
	cmpl $32,%ebx
	jz L353
L371:
	cmpl $1,8(%r12)
	jnz L375
L374:
	orl $268435456,12(%r12)
	cmpl $16,%ebx
	jnz L353
L377:
	movq 32(%r12),%rdi
	movq (%r12),%rsi
	call _size_of
	jmp L353
L375:
	movq %r12,%rdi
	call _init_bss
L353:
	popq %r12
	popq %rbx
	ret 


_init_auto:
L380:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L381:
	movq %rdi,%r13
	cmpl $1048633,_token(%rip)
	jnz L384
L383:
	movq %r13,%rdi
	call _push
	call _lex
	cmpb $0,_g_flag(%rip)
	jz L391
L389:
	xorl %esi,%esi
	movl $58720258,%edi
	call _new_insn
	movq _current_block(%rip),%rsi
	movq %rax,%rdi
	call _append_insn
L391:
	xorl %edx,%edx
	movl $1,%esi
	movq 32(%r13),%rdi
	call _init
	movq %rax,32(%r13)
	testq $73726,(%rax)
	jnz L394
L392:
	movq $0,-8(%rbp)
	leaq -8(%rbp),%rsi
	movl $_int_type,%edi
	call _con_tree
	movq %rax,%r12
	xorl %esi,%esi
	movq 32(%r13),%rdi
	call _size_of
	movslq %eax,%rax
	movq %rax,-16(%rbp)
	leaq -16(%rbp),%rsi
	movl $_ulong_type,%edi
	call _con_tree
	movq %rax,%rbx
	xorl %esi,%esi
	movq 32(%r13),%rdi
	call _ref
	movq %rbx,%rcx
	movq %r12,%rdx
	movq %rax,%rsi
	movl $46,%edi
	call _blk_tree
	movq _state(%rip),%rcx
	movq 8(%rcx),%rsi
	movq %rax,%rdi
	call _seq_tree
	movq _state(%rip),%rcx
	movq %rax,8(%rcx)
L394:
	movq _state(%rip),%rax
	movq 8(%rax),%rdi
	call _gen
	movq _state(%rip),%rax
	movq 16(%rax),%rax
	movq %rax,_state(%rip)
	jmp L382
L384:
	movq 32(%r13),%rdi
	movq (%r13),%rsi
	call _size_of
L382:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_tentative:
L398:
	pushq %rbx
L399:
	movq %rdi,%rbx
	testl $1073741824,12(%rbx)
	jnz L400
L403:
	movq 32(%rbx),%rax
	testq $16384,(%rax)
	jz L407
L408:
	cmpl $0,16(%rax)
	jnz L407
L405:
	pushq $L412
	pushq (%rbx)
	pushq $0
	call _error
	addq $24,%rsp
	movq 32(%rbx),%rax
	movq 24(%rax),%rdx
	movl $1,%esi
	movl $16384,%edi
	call _get_tnode
	movq %rax,32(%rbx)
L407:
	movq 32(%rbx),%rax
	testq $8192,(%rax)
	jz L415
L416:
	movq 16(%rax),%rax
	testl $1073741824,12(%rax)
	jnz L415
L413:
	pushq %rax
	pushq $L420
	pushq (%rbx)
	pushq $4
	call _error
	addq $32,%rsp
L415:
	movq %rbx,%rdi
	call _init_bss
L400:
	popq %rbx
	ret 

.data
.align 8
_fcon_slab:
	.int 24
	.int 10
	.fill 16, 1, 0
.text

_floateral:
L421:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	movsd %xmm8,-8(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
L422:
	movsd %xmm0,%xmm8
	andq $-393217,%rdi
	movq %rdi,%r13
	movq _fcons(%rip),%r12
L424:
	testq %r12,%r12
	jz L427
L425:
	ucomisd (%r12),%xmm8
	jz L427
L430:
	movq 16(%r12),%r12
	jmp L424
L427:
	testq %r12,%r12
	jnz L434
L432:
	movq _fcon_slab+8(%rip),%r12
	testq %r12,%r12
	jz L436
L435:
	movq (%r12),%rax
	movq %rax,_fcon_slab+8(%rip)
	jmp L437
L436:
	movl $_fcon_slab,%edi
	call _refill_slab
	movq %rax,%r12
L437:
	decl _fcon_slab+20(%rip)
	movsd %xmm8,(%r12)
	movl $0,8(%r12)
	movl $0,12(%r12)
	movq _fcons(%rip),%rax
	movq %rax,16(%r12)
	movq %r12,_fcons(%rip)
L434:
	cmpq $1024,%r13
	jnz L439
L438:
	leaq 8(%r12),%rbx
	jmp L440
L439:
	leaq 12(%r12),%rbx
L440:
	cmpl $0,(%rbx)
	jnz L443
L441:
	movl _last_asmlab(%rip),%eax
	incl %eax
	movl %eax,_last_asmlab(%rip)
	movl %eax,(%rbx)
	movl $1,%edi
	call _seg
	movl (%rbx),%eax
	pushq %rax
	pushq $L444
	call _out
	addq $16,%rsp
	subq $8,%rsp
	movq (%r12),%rax
	movq %rax,(%rsp)
	xorl %esi,%esi
	movq %r13,%rdi
	call _out_word
	addq $8,%rsp
L443:
	cmpq $1024,%r13
	movl $_double_type,%eax
	movl $_float_type,%edi
	cmovnzq %rax,%rdi
	movl (%rbx),%esi
	call _anon_static
L423:
	popq %r13
	popq %r12
	popq %rbx
	movsd -8(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 

L412:
	.byte 105,110,99,111,109,112,108,101
	.byte 116,101,32,97,114,114,97,121
	.byte 32,97,115,115,105,103,110,101
	.byte 100,32,111,110,101,32,101,108
	.byte 101,109,101,110,116,0
L52:
	.byte 32,46,98,121,116,101,32,37
	.byte 100,10,0
L305:
	.byte 99,97,110,39,116,32,105,110
	.byte 105,116,105,97,108,105,122,101
	.byte 32,102,108,101,120,105,98,108
	.byte 101,32,97,114,114,97,121,32
	.byte 109,101,109,98,101,114,115,0
L183:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,105,110,105,116,105,97,108
	.byte 105,122,101,114,115,32,102,111
	.byte 114,32,97,114,114,97,121,0
L91:
	.byte 32,37,71,10,0
L20:
	.byte 37,103,58,10,0
L123:
	.byte 32,46,102,105,108,108,32,37
	.byte 100,44,32,49,44,32,48,10
	.byte 0
L89:
	.byte 9,46,113,117,97,100,0
L360:
	.byte 105,110,105,116,105,97,108,105
	.byte 122,101,114,32,111,110,32,96
	.byte 101,120,116,101,114,110,39,32
	.byte 100,101,99,108,97,114,97,116
	.byte 105,111,110,0
L157:
	.byte 115,116,114,105,110,103,32,108
	.byte 105,116,101,114,97,108,32,101
	.byte 120,99,101,101,100,115,32,108
	.byte 101,110,103,116,104,32,111,102
	.byte 32,97,114,114,97,121,0
L324:
	.byte 97,103,103,114,101,103,97,116
	.byte 101,32,105,110,105,116,105,97
	.byte 108,105,122,101,114,32,114,101
	.byte 113,117,105,114,101,115,32,98
	.byte 114,97,99,101,115,0
L228:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,105,110,105,116,105,97,108
	.byte 105,122,101,114,115,32,102,111
	.byte 114,32,37,84,0
L220:
	.byte 99,97,110,39,116,32,105,110
	.byte 105,116,105,97,108,105,122,101
	.byte 32,105,110,99,111,109,112,108
	.byte 101,116,101,32,37,84,0
L68:
	.byte 9,46,113,117,97,100,32,37
	.byte 88,32,35,32,37,102,10,0
L76:
	.byte 9,46,98,121,116,101,0
L80:
	.byte 9,46,115,104,111,114,116,0
L143:
	.byte 105,110,118,97,108,105,100,32
	.byte 98,105,116,45,102,105,101,108
	.byte 100,32,105,110,105,116,105,97
	.byte 108,105,122,101,114,0
L349:
	.byte 46,108,111,99,97,108,32,37
	.byte 103,10,0
L364:
	.byte 114,101,100,101,102,105,110,105
	.byte 116,105,111,110,32,37,76,0
L64:
	.byte 9,46,105,110,116,32,37,120
	.byte 32,35,32,37,102,10,0
L444:
	.byte 37,76,58,10,0
L420:
	.byte 104,97,115,32,105,110,99,111
	.byte 109,112,108,101,116,101,32,116
	.byte 121,112,101,32,37,84,0
L19:
	.byte 46,97,108,105,103,110,32,37
	.byte 100,10,0
L350:
	.byte 46,99,111,109,109,32,37,103
	.byte 44,32,37,100,44,32,37,100
	.byte 10,0
L84:
	.byte 9,46,105,110,116,0
.local _state
.comm _state, 8, 8
.local _pushback
.comm _pushback, 8, 8
.local _fcons
.comm _fcons, 8, 8

.globl _stmt_arena
.globl _float_type
.globl _sym_tree
.globl _assignment
.globl _lex
.globl _floateral
.globl _unary_tree
.globl _con_tree
.globl _error
.globl _expect
.globl _last_asmlab
.globl _init_static
.globl _build_tree
.globl _long_type
.globl _path
.globl _out_literal
.globl _refill_slab
.globl _blk_tree
.globl _line_no
.globl _current_block
.globl _get_tnode
.globl _g_flag
.globl _unfieldify
.globl _init_bss
.globl _double_type
.globl _out
.globl _fold
.globl _align_of
.globl _int_type
.globl _seg
.globl _init_auto
.globl _out_f
.globl _tentative
.globl _new_insn
.globl _out_word
.globl _append_insn
.globl _seq_tree
.globl _anon_static
.globl _fake
.globl _fputs
.globl _gen
.globl _binary_tree
.globl _literal
.globl _token
.globl _static_expr
.globl _ulong_type
.globl _size_of
