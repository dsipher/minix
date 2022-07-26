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
	movzbl L41(%rip),%eax
	sarb $1,%al
	movb %al,L41(%rip)
	testq $1,%rbx
	jz L47
L46:
	orl $-128,%eax
	movb %al,L41(%rip)
	jmp L48
L47:
	andl $127,%eax
	movb %al,L41(%rip)
L48:
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
L53:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L54:
	movq %rsi,%rbx
	movq %rdi,%rax
	andl $7168,%eax
	andl $131071,%edi
	testq %rax,%rax
	jz L57
L56:
	cmpq $1024,%rdi
	jz L62
L92:
	cmpq $2048,%rdi
	jz L66
L93:
	cmpq $4096,%rdi
	jnz L55
L66:
	movq 16(%rbp),%rax
	movsd 16(%rbp),%xmm0
	subq $24,%rsp
	movsd %xmm0,16(%rsp)
	movq %rax,8(%rsp)
	movq $L67,(%rsp)
	call _out
	addq $24,%rsp
	jmp L55
L62:
	cvtsd2ss 16(%rbp),%xmm0
	movss %xmm0,-4(%rbp)
	movl -4(%rbp),%eax
	cvtss2sd %xmm0,%xmm0
	subq $24,%rsp
	movsd %xmm0,16(%rsp)
	movl %eax,8(%rsp)
	movq $L63,(%rsp)
	call _out
	addq $24,%rsp
	jmp L55
L57:
	cmpq $2,%rdi
	jz L74
	jl L70
L97:
	cmpq $65536,%rdi
	jz L87
	jg L70
L98:
	cmpl $4,%edi
	jz L74
L99:
	cmpl $8,%edi
	jz L74
L100:
	cmpl $16,%edi
	jz L78
L101:
	cmpl $32,%edi
	jz L78
L102:
	cmpl $64,%edi
	jz L82
L103:
	cmpl $128,%edi
	jz L82
L104:
	cmpl $256,%edi
	jz L87
L105:
	cmpl $512,%edi
	jz L87
	jnz L70
L82:
	movq _out_f(%rip),%rsi
	movl $L83,%edi
	call _fputs
	jmp L70
L78:
	movq _out_f(%rip),%rsi
	movl $L79,%edi
	call _fputs
	jmp L70
L87:
	movq _out_f(%rip),%rsi
	movl $L88,%edi
	call _fputs
	jmp L70
L74:
	movq _out_f(%rip),%rsi
	movl $L75,%edi
	call _fputs
L70:
	pushq 16(%rbp)
	pushq %rbx
	pushq $L90
	call _out
	addq $24,%rsp
L55:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_init_pad:
L108:
	pushq %rbx
L109:
	movq _state(%rip),%rax
	movl %edi,%ebx
	cmpq $0,(%rax)
	jnz L110
L111:
	movl $8,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	movl %edx,%esi
	testl %esi,%esi
	jz L116
L114:
	xorl %edi,%edi
	call _out_bits
L116:
	movl $8,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	testl %eax,%eax
	jz L110
L117:
	pushq %rax
	pushq $L120
	call _out
	addq $16,%rsp
L110:
	popq %rbx
	ret 


_init_value:
L121:
	pushq %rbx
	pushq %r12
	pushq %r13
L122:
	movq _state(%rip),%rax
	movq %rdi,%r12
	movq %rdx,%rbx
	movq (%rax),%rdi
	testq %rdi,%rdi
	jz L125
L124:
	movq 32(%rdi),%rax
	testq $73726,(%rax)
	jnz L128
L127:
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
	jmp L129
L128:
	call _sym_tree
	movq %rax,%r13
L129:
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
	jmp L123
L125:
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
	jz L131
L130:
	cmpl $2147483650,(%rbx)
	jnz L133
L136:
	cmpq $0,24(%rbx)
	jz L135
L133:
	pushq $L140
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L135:
	movq $545460846592,%rsi
	andq (%r12),%rsi
	sarq $32,%rsi
	movq 16(%rbx),%rdi
	call _out_bits
	jmp L123
L131:
	movq 8(%rbx),%rax
	movq (%rax),%rdi
	movq 24(%rbx),%rsi
	subq $8,%rsp
	movq 16(%rbx),%rax
	movq %rax,(%rsp)
	call _out_word
	addq $8,%rsp
L123:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_init_strlit:
L141:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L142:
	movq %rdi,%r13
	movl %esi,%r12d
	testq $16384,(%r13)
	jz L145
L147:
	cmpl $0,16(%r13)
	jnz L145
L144:
	movq _token+24(%rip),%rax
	movl 4(%rax),%ebx
	incl %ebx
	jmp L146
L145:
	movl 16(%r13),%ebx
	movq _token+24(%rip),%rax
	cmpl 4(%rax),%ebx
	jge L146
L151:
	pushq $L154
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L146:
	movq _state(%rip),%rax
	movq (%rax),%rax
	movq _token+24(%rip),%rdi
	testq %rax,%rax
	jz L156
L155:
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
	jmp L157
L156:
	movl %ebx,%esi
	call _out_literal
L157:
	call _lex
	movl %ebx,%eax
L143:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_init_array:
L162:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L163:
	movq %rdi,%r15
	movl %esi,-8(%rbp)
	movl %edx,%ebx
	movq 24(%r15),%r14
	xorl %esi,%esi
	movq %r14,%rdi
	call _size_of
	movl %eax,%r13d
	xorl %r12d,%r12d
L165:
	testq $16384,(%r15)
	jz L172
L176:
	cmpl $0,16(%r15)
	jz L171
L172:
	cmpl 16(%r15),%r12d
	jnz L171
L169:
	pushq $L180
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L171:
	movl %r12d,%edx
	imull %r13d,%edx
	addl -8(%rbp),%edx
	xorl %esi,%esi
	movq %r14,%rdi
	call _init
	incl %r12d
	testl $2,%ebx
	jnz L183
L184:
	cmpl 16(%r15),%r12d
	jz L168
L183:
	cmpl $21,_token(%rip)
	jnz L168
L189:
	call _lex
	jmp L165
L168:
	testq $16384,(%r15)
	jz L193
L196:
	cmpl $0,16(%r15)
	jz L195
L193:
	movl 16(%r15),%edi
	subl %r12d,%edi
	imull %r13d,%edi
	shll $3,%edi
	call _init_pad
L195:
	movl %r12d,%eax
L164:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_init_strun:
L201:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L202:
	movq %rdi,-8(%rbp)
	movl %esi,-16(%rbp)
	movl %edx,%ebx
	xorl %r12d,%r12d
	movq -8(%rbp),%rax
	movq 16(%rax),%r15
	movq 40(%r15),%r14
L207:
	testq %r14,%r14
	jz L212
L210:
	testl $33554432,12(%r14)
	jz L212
L211:
	movq 56(%r14),%r14
	jmp L207
L212:
	testl $1073741824,12(%r15)
	jnz L218
L214:
	pushq %r15
	pushq $L217
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L218:
	testq %r14,%r14
	jnz L224
L222:
	pushq %r15
	pushq $L225
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L224:
	movl 48(%r14),%r13d
	shll $3,%r13d
	subl %r12d,%r13d
	movq 32(%r14),%rax
	movq (%rax),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L228
L226:
	movq $69269232549888,%rax
	andq %rcx,%rax
	sarq $40,%rax
	addl %eax,%r13d
L228:
	movl %r13d,%edi
	call _init_pad
	addl %r13d,%r12d
	movq 32(%r14),%rdi
	movl 48(%r14),%edx
	addl -16(%rbp),%edx
	xorl %esi,%esi
	call _init
	movq 32(%r14),%rdi
	movq (%rdi),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L230
L229:
	movq $545460846592,%rax
	andq %rcx,%rax
	sarq $32,%rax
	addl %eax,%r12d
	jmp L231
L230:
	xorl %esi,%esi
	call _size_of
	shll $3,%eax
	addl %eax,%r12d
L231:
	movq 56(%r14),%r14
L235:
	testq %r14,%r14
	jz L240
L238:
	testl $33554432,12(%r14)
	jz L240
L239:
	movq 56(%r14),%r14
	jmp L235
L240:
	testl $2,12(%r15)
	movl $0,%eax
	cmovnzq %rax,%r14
	testl $2,%ebx
	jnz L250
L248:
	testq %r14,%r14
	jz L221
L250:
	cmpl $21,_token(%rip)
	jnz L221
L253:
	call _lex
	jmp L218
L221:
	xorl %esi,%esi
	movq -8(%rbp),%rdi
	call _size_of
	shll $3,%eax
	subl %r12d,%eax
	movl %eax,%edi
	call _init_pad
L203:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_init:
L257:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L258:
	movq %rdi,%r13
	movl %esi,%ebx
	movl %edx,%r12d
	cmpl $16,_token(%rip)
	jnz L261
L260:
	orl $2,%ebx
	call _lex
	jmp L262
L261:
	andl $-3,%ebx
L262:
	movl _token(%rip),%eax
	cmpl $2,%eax
	jz L268
L266:
	cmpl $16,%eax
	jz L268
L267:
	call _next
	movq %rax,_pushback(%rip)
	jmp L265
L268:
	xorl %eax,%eax
L265:
	movq (%r13),%rcx
	testq $73726,%rcx
	jnz L274
L273:
	testq $8192,%rcx
	jz L279
L285:
	testq %rax,%rax
	jz L279
L286:
	movq 8(%rax),%rax
	testq $8192,(%rax)
	jz L279
L282:
	testl $2,%ebx
	jnz L279
L274:
	call _next
	movl %ebx,%ecx
	movq %rax,%rdx
	movl %r12d,%esi
	movq %r13,%rdi
	call _init_value
	jmp L272
L279:
	testq $16384,%rcx
	jz L291
L296:
	cmpl $0,16(%r13)
	jnz L291
L297:
	testl $1,%ebx
	jnz L291
L293:
	pushq $L300
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L291:
	testq $16384,(%r13)
	jz L306
L308:
	movq 24(%r13),%rax
	testq $14,(%rax)
	jz L306
L309:
	cmpl $2,_token(%rip)
	jnz L306
L305:
	movl %ebx,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _init_strlit
	movl %eax,%r14d
	jmp L272
L306:
	testl $1,%ebx
	jz L314
L315:
	testl $2,%ebx
	jnz L314
L316:
	pushq $L319
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L314:
	testq $8192,(%r13)
	jz L321
L320:
	movl %ebx,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _init_strun
	jmp L272
L321:
	movl %ebx,%edx
	movl %r12d,%esi
	movq %r13,%rdi
	call _init_array
	movl %eax,%r14d
L272:
	testl $2,%ebx
	jz L325
L326:
	movl $17,%edi
	call _expect
	call _lex
L325:
	testq $16384,(%r13)
	jz L331
L332:
	cmpl $0,16(%r13)
	jnz L331
L333:
	movslq %r14d,%rsi
	movq 24(%r13),%rdx
	movl $16384,%edi
	call _get_tnode
	movq %rax,%r13
L331:
	movq %r13,%rax
L259:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_init_bss:
L337:
	pushq %rbx
	pushq %r12
	pushq %r13
L338:
	movq %rdi,%r13
	movq 32(%r13),%rdi
	movq (%r13),%rsi
	call _size_of
	movl %eax,%r12d
	movq 32(%r13),%rdi
	call _align_of
	movl %eax,%ebx
	testl $16,12(%r13)
	jz L342
L340:
	pushq %r13
	pushq $L343
	call _out
	addq $16,%rsp
L342:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq $L344
	call _out
	addq $32,%rsp
	orl $1073741824,12(%r13)
L339:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_init_static:
L345:
	pushq %rbx
	pushq %r12
L346:
	movq %rdi,%r12
	movl %esi,%ebx
	cmpl $1048633,_token(%rip)
	jnz L349
L348:
	xorl %edi,%edi
	call _push
	testl $32,%ebx
	jz L353
L351:
	pushq $L354
	pushq (%r12)
	pushq $4
	call _error
	addq $24,%rsp
L353:
	testl $1073741824,12(%r12)
	jz L357
L355:
	pushq %r12
	pushq $L358
	pushq (%r12)
	pushq $4
	call _error
	addq $32,%rsp
L357:
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
	jmp L347
L349:
	cmpl $32,%ebx
	jz L347
L365:
	cmpl $1,8(%r12)
	jnz L369
L368:
	orl $268435456,12(%r12)
	cmpl $16,%ebx
	jnz L347
L371:
	movq 32(%r12),%rdi
	movq (%r12),%rsi
	call _size_of
	jmp L347
L369:
	movq %r12,%rdi
	call _init_bss
L347:
	popq %r12
	popq %rbx
	ret 


_init_auto:
L374:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L375:
	movq %rdi,%r13
	cmpl $1048633,_token(%rip)
	jnz L378
L377:
	movq %r13,%rdi
	call _push
	call _lex
	cmpb $0,_g_flag(%rip)
	jz L385
L383:
	xorl %esi,%esi
	movl $58720258,%edi
	call _new_insn
	movq _current_block(%rip),%rsi
	movq %rax,%rdi
	call _append_insn
L385:
	xorl %edx,%edx
	movl $1,%esi
	movq 32(%r13),%rdi
	call _init
	movq %rax,32(%r13)
	testq $73726,(%rax)
	jnz L388
L386:
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
L388:
	movq _state(%rip),%rax
	movq 8(%rax),%rdi
	call _gen
	movq _state(%rip),%rax
	movq 16(%rax),%rax
	movq %rax,_state(%rip)
	jmp L376
L378:
	movq 32(%r13),%rdi
	movq (%r13),%rsi
	call _size_of
L376:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_tentative:
L392:
	pushq %rbx
L393:
	movq %rdi,%rbx
	testl $1073741824,12(%rbx)
	jnz L394
L397:
	movq 32(%rbx),%rax
	testq $16384,(%rax)
	jz L401
L402:
	cmpl $0,16(%rax)
	jnz L401
L399:
	pushq $L406
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
L401:
	movq 32(%rbx),%rax
	testq $8192,(%rax)
	jz L409
L410:
	movq 16(%rax),%rax
	testl $1073741824,12(%rax)
	jnz L409
L407:
	pushq %rax
	pushq $L414
	pushq (%rbx)
	pushq $4
	call _error
	addq $32,%rsp
L409:
	movq %rbx,%rdi
	call _init_bss
L394:
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
L415:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	movsd %xmm8,-8(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
L416:
	movq %rdi,%r13
	movsd %xmm0,%xmm8
	andq $-393217,%r13
	movq _fcons(%rip),%r12
L418:
	testq %r12,%r12
	jz L421
L419:
	ucomisd (%r12),%xmm8
	jz L421
L424:
	movq 16(%r12),%r12
	jmp L418
L421:
	testq %r12,%r12
	jnz L428
L426:
	movq _fcon_slab+8(%rip),%r12
	testq %r12,%r12
	jz L430
L429:
	movq (%r12),%rax
	movq %rax,_fcon_slab+8(%rip)
	jmp L431
L430:
	movl $_fcon_slab,%edi
	call _refill_slab
	movq %rax,%r12
L431:
	decl _fcon_slab+20(%rip)
	movsd %xmm8,(%r12)
	movl $0,8(%r12)
	movl $0,12(%r12)
	movq _fcons(%rip),%rax
	movq %rax,16(%r12)
	movq %r12,_fcons(%rip)
L428:
	cmpq $1024,%r13
	jnz L433
L432:
	leaq 8(%r12),%rbx
	jmp L434
L433:
	leaq 12(%r12),%rbx
L434:
	cmpl $0,(%rbx)
	jnz L437
L435:
	movl _last_asmlab(%rip),%eax
	incl %eax
	movl %eax,_last_asmlab(%rip)
	movl %eax,(%rbx)
	movl $1,%edi
	call _seg
	movl (%rbx),%eax
	pushq %rax
	pushq $L438
	call _out
	addq $16,%rsp
	subq $8,%rsp
	movq (%r12),%rax
	movq %rax,(%rsp)
	xorl %esi,%esi
	movq %r13,%rdi
	call _out_word
	addq $8,%rsp
L437:
	cmpq $1024,%r13
	movl $_double_type,%eax
	movl $_float_type,%edi
	cmovnzq %rax,%rdi
	movl (%rbx),%esi
	call _anon_static
L417:
	popq %r13
	popq %r12
	popq %rbx
	movsd -8(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 

L406:
 .byte 105,110,99,111,109,112,108,101
 .byte 116,101,32,97,114,114,97,121
 .byte 32,97,115,115,105,103,110,101
 .byte 100,32,111,110,101,32,101,108
 .byte 101,109,101,110,116,0
L52:
 .byte 32,46,98,121,116,101,32,37
 .byte 100,10,0
L300:
 .byte 99,97,110,39,116,32,105,110
 .byte 105,116,105,97,108,105,122,101
 .byte 32,102,108,101,120,105,98,108
 .byte 101,32,97,114,114,97,121,32
 .byte 109,101,109,98,101,114,115,0
L180:
 .byte 116,111,111,32,109,97,110,121
 .byte 32,105,110,105,116,105,97,108
 .byte 105,122,101,114,115,32,102,111
 .byte 114,32,97,114,114,97,121,0
L90:
 .byte 32,37,71,10,0
L20:
 .byte 37,103,58,10,0
L120:
 .byte 32,46,102,105,108,108,32,37
 .byte 100,44,32,49,44,32,48,10
 .byte 0
L88:
 .byte 9,46,113,117,97,100,0
L354:
 .byte 105,110,105,116,105,97,108,105
 .byte 122,101,114,32,111,110,32,96
 .byte 101,120,116,101,114,110,39,32
 .byte 100,101,99,108,97,114,97,116
 .byte 105,111,110,0
L154:
 .byte 115,116,114,105,110,103,32,108
 .byte 105,116,101,114,97,108,32,101
 .byte 120,99,101,101,100,115,32,108
 .byte 101,110,103,116,104,32,111,102
 .byte 32,97,114,114,97,121,0
L319:
 .byte 97,103,103,114,101,103,97,116
 .byte 101,32,105,110,105,116,105,97
 .byte 108,105,122,101,114,32,114,101
 .byte 113,117,105,114,101,115,32,98
 .byte 114,97,99,101,115,0
L225:
 .byte 116,111,111,32,109,97,110,121
 .byte 32,105,110,105,116,105,97,108
 .byte 105,122,101,114,115,32,102,111
 .byte 114,32,37,84,0
L217:
 .byte 99,97,110,39,116,32,105,110
 .byte 105,116,105,97,108,105,122,101
 .byte 32,105,110,99,111,109,112,108
 .byte 101,116,101,32,37,84,0
L67:
 .byte 9,46,113,117,97,100,32,37
 .byte 88,32,35,32,37,102,10,0
L75:
 .byte 9,46,98,121,116,101,0
L79:
 .byte 9,46,115,104,111,114,116,0
L140:
 .byte 105,110,118,97,108,105,100,32
 .byte 98,105,116,45,102,105,101,108
 .byte 100,32,105,110,105,116,105,97
 .byte 108,105,122,101,114,0
L343:
 .byte 46,108,111,99,97,108,32,37
 .byte 103,10,0
L358:
 .byte 114,101,100,101,102,105,110,105
 .byte 116,105,111,110,32,37,76,0
L63:
 .byte 9,46,105,110,116,32,37,120
 .byte 32,35,32,37,102,10,0
L438:
 .byte 37,76,58,10,0
L414:
 .byte 104,97,115,32,105,110,99,111
 .byte 109,112,108,101,116,101,32,116
 .byte 121,112,101,32,37,84,0
L19:
 .byte 46,97,108,105,103,110,32,37
 .byte 100,10,0
L344:
 .byte 46,99,111,109,109,32,37,103
 .byte 44,32,37,100,44,32,37,100
 .byte 10,0
L83:
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
