.text

_hash:
L1:
L2:
	xorl %eax,%eax
	testl $1,(%rdi)
	jz L5
L4:
	incq %rdi
	jmp L7
L5:
	movq 16(%rdi),%rdi
L7:
	movb (%rdi),%cl
	testb %cl,%cl
	jz L3
L8:
	shll $3,%eax
	movsbl %cl,%ecx
	incq %rdi
	xorl %eax,%ecx
	movl %ecx,%eax
	jmp L7
L3:
	ret 


_insert:
L11:
	pushq %rbx
	pushq %r12
	pushq %r13
L12:
	movq %rdi,%r13
	movq %r13,%rdi
	call _hash
	movl %eax,%ebx
	andl $63,%ebx
	movl $80,%edi
	call _safe_malloc
	movq %rax,%r12
	movq %r12,%rdi
	call _vstring_init
	movq %r13,%rsi
	movq %r12,%rdi
	call _vstring_concat
	leaq 32(%r12),%rax
	movq $0,32(%r12)
	movq %rax,40(%r12)
	leaq 48(%r12),%rax
	movq $0,48(%r12)
	movq %rax,56(%r12)
	movl $0,24(%r12)
	movslq %ebx,%rbx
	shlq $4,%rbx
	leaq _buckets(%rbx),%rdx
	movq _buckets(%rbx),%rax
	leaq 64(%r12),%rcx
	movq %rax,64(%r12)
	testq %rax,%rax
	jz L24
L23:
	movq _buckets(%rbx),%rax
	movq %rcx,72(%rax)
	jmp L25
L24:
	movq %rcx,_buckets+8(%rbx)
L25:
	movq %r12,_buckets(%rbx)
	movq %rdx,72(%r12)
	movq %r12,%rax
L13:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 8
_predefs:
	.quad L27
	.int 32
	.fill 4, 1, 0
	.quad L28
	.int 16
	.fill 4, 1, 0
	.quad L29
	.int 8
	.fill 4, 1, 0
	.quad L30
	.int 4
	.fill 4, 1, 0
	.quad L31
	.int 2
	.fill 4, 1, 0
	.quad L32
	.int 1
	.fill 4, 1, 0
.text

_macro_predef:
L33:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L34:
	xorl %eax,%eax
	movq %rax,-24(%rbp)
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movl -24(%rbp),%eax
	andl $-2,%eax
	orl $1,%eax
	movl %eax,-24(%rbp)
	xorl %r12d,%r12d
L37:
	leaq -24(%rbp),%rdi
	call _vstring_clear
	movslq %r12d,%r13
	shlq $4,%r13
	movq _predefs(%r13),%rsi
	leaq -24(%rbp),%rdi
	call _vstring_puts
	leaq -24(%rbp),%rdi
	call _insert
	movq %rax,%rbx
	movl _predefs+8(%r13),%ecx
	movl %ecx,24(%rbx)
	xorl %eax,%eax
	cmpl $32,%ecx
	jnz L41
L43:
	movl $1,%edi
	call _token_number
L41:
	testq %rax,%rax
	jz L47
L48:
	leaq 32(%rax),%rdx
	movq $0,32(%rax)
	movq 56(%rbx),%rcx
	movq %rcx,40(%rax)
	movq 56(%rbx),%rcx
	movq %rax,(%rcx)
	movq %rdx,56(%rbx)
L47:
	incl %r12d
	cmpl $6,%r12d
	jl L37
L39:
	leaq -24(%rbp),%rdi
	call _vstring_free
L35:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_tokens:
L54:
	pushq %rbp
	movq %rsp,%rbp
	subq $72,%rsp
	pushq %rbx
	pushq %r12
L55:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl 24(%r12),%eax
	andl $63,%eax
	cmpl $16,%eax
	jz L60
L88:
	cmpl $8,%eax
	jz L62
L89:
	cmpl $4,%eax
	jz L67
L90:
	cmpl $2,%eax
	jz L75
	jnz L57
L67:
	cmpq $0,48(%r12)
	jnz L75
L68:
	leaq -8(%rbp),%rdi
	call _time
	leaq -8(%rbp),%rdi
	call _localtime
	movq %rax,%rcx
	movl $L71,%edx
	movl $64,%esi
	leaq -72(%rbp),%rdi
	call _strftime
	leaq -72(%rbp),%rdi
	call _token_string
	leaq 32(%rax),%rdx
	movq $0,32(%rax)
	movq 56(%r12),%rcx
	movq %rcx,40(%rax)
	movq 56(%r12),%rcx
	movq %rax,(%rcx)
	movq %rdx,56(%r12)
L75:
	cmpq $0,48(%r12)
	jnz L57
L76:
	leaq -8(%rbp),%rdi
	call _time
	leaq -8(%rbp),%rdi
	call _localtime
	movq %rax,%rcx
	movl $L79,%edx
	movl $64,%esi
	leaq -72(%rbp),%rdi
	call _strftime
	leaq -72(%rbp),%rdi
	call _token_string
	leaq 32(%rax),%rdx
	movq $0,32(%rax)
	movq 56(%r12),%rcx
	movq %rcx,40(%rax)
	movq 56(%r12),%rcx
	movq %rax,(%rcx)
	movq %rdx,56(%r12)
L57:
	leaq 48(%r12),%rsi
	movq %rbx,%rdi
	call _list_copy
	jmp L56
L62:
	movq _input_stack(%rip),%rdi
	testl $1,8(%rdi)
	jz L64
L63:
	addq $9,%rdi
	jmp L65
L64:
	movq 24(%rdi),%rdi
L65:
	call _token_string
	jmp L84
L60:
	movq _input_stack(%rip),%rax
	movl 32(%rax),%edi
	call _token_number
L84:
	leaq 32(%rax),%rdx
	movq $0,32(%rax)
	movq 8(%rbx),%rcx
	movq %rcx,40(%rax)
	movq 8(%rbx),%rcx
	movq %rax,(%rcx)
	movq %rdx,8(%rbx)
L56:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_macro_lookup:
L93:
	pushq %rbx
	pushq %r12
	pushq %r13
L94:
	movq %rdi,%r13
	movq %r13,%rdi
	call _hash
	movl %eax,%ebx
	andl $63,%ebx
	movslq %ebx,%rax
	shlq $4,%rax
	movq _buckets(%rax),%r12
L96:
	testq %r12,%r12
	jz L99
L97:
	movq %r13,%rsi
	movq %r12,%rdi
	call _vstring_same
	leaq 64(%r12),%rdx
	movq 64(%r12),%rcx
	testl %eax,%eax
	jnz L103
L102:
	movq %rcx,%r12
	jmp L96
L103:
	movq 72(%r12),%rax
	testq %rcx,%rcx
	jz L107
L106:
	movq %rax,72(%rcx)
	jmp L108
L107:
	movslq %ebx,%rcx
	shlq $4,%rcx
	movq %rax,_buckets+8(%rcx)
L108:
	movq 64(%r12),%rcx
	movq 72(%r12),%rax
	movq %rcx,(%rax)
	movslq %ebx,%rbx
	shlq $4,%rbx
	leaq _buckets(%rbx),%rcx
	movq _buckets(%rbx),%rax
	movq %rax,64(%r12)
	testq %rax,%rax
	jz L113
L112:
	movq _buckets(%rbx),%rax
	movq %rdx,72(%rax)
	jmp L114
L113:
	movq %rdx,_buckets+8(%rbx)
L114:
	movq %r12,_buckets(%rbx)
	movq %rcx,72(%r12)
	movq %r12,%rax
	jmp L95
L99:
	xorl %eax,%eax
L95:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_macro_define:
L117:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L118:
	movq %rdi,%r14
	leaq -16(%rbp),%rcx
	xorl %eax,%eax
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movq $0,-16(%rbp)
	movq %rcx,-8(%rbp)
	xorl %r13d,%r13d
	leaq -24(%rbp),%rdx
	movl $52,%esi
	movq %r14,%rdi
	call _list_match
	movq (%r14),%rax
	testq %rax,%rax
	jz L122
L123:
	cmpl $536870927,(%rax)
	jnz L122
L124:
	xorl %esi,%esi
	movq %r14,%rdi
	call _list_pop
	movl $-2147483648,%r13d
	movq (%r14),%rax
	testq %rax,%rax
	jz L134
L130:
	cmpl $536870928,(%rax)
	jz L129
L134:
	movq %r14,%rdi
	call _list_strip_ends
	leaq -32(%rbp),%rdx
	movl $52,%esi
	movq %r14,%rdi
	call _list_match
	movq -32(%rbp),%rax
	movq $0,32(%rax)
	movq -8(%rbp),%rax
	movq -32(%rbp),%rcx
	movq %rax,40(%rcx)
	movq -8(%rbp),%rax
	movq -32(%rbp),%rcx
	movq %rcx,(%rax)
	movq -32(%rbp),%rax
	addq $32,%rax
	movq %rax,-8(%rbp)
	movq %r14,%rdi
	call _list_strip_ends
	movq (%r14),%rax
	testq %rax,%rax
	jz L129
L144:
	cmpl $536870959,(%rax)
	jnz L129
L145:
	xorl %esi,%esi
	movq %r14,%rdi
	call _list_pop
	jmp L134
L129:
	xorl %edx,%edx
	movl $536870928,%esi
	movq %r14,%rdi
	call _list_match
L122:
	leaq -16(%rbp),%r12
	leaq -16(%rbp),%rsi
	movq %r14,%rdi
	call _list_normalize
	movq -24(%rbp),%rdi
	addq $8,%rdi
	call _macro_lookup
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L150
L149:
	testl $63,24(%rbx)
	jz L154
L152:
	testl $1,(%rbx)
	jz L157
L156:
	leaq 1(%rbx),%rax
	jmp L158
L157:
	movq 16(%rbx),%rax
L158:
	pushq %rax
	pushq $L155
	call _error
	addq $16,%rsp
L154:
	leaq -16(%rbp),%rsi
	leaq 32(%rbx),%rdi
	call _list_same
	testl %eax,%eax
	jz L163
L166:
	movq %r14,%rsi
	leaq 48(%rbx),%rdi
	call _list_same
	testl %eax,%eax
	jz L163
L168:
	cmpl 24(%rbx),%r13d
	jz L161
L163:
	testl $1,(%rbx)
	jz L172
L171:
	incq %rbx
	jmp L173
L172:
	movq 16(%rbx),%rbx
L173:
	pushq %rbx
	pushq $L170
	call _error
	addq $16,%rsp
L161:
	xorl %esi,%esi
	leaq -16(%rbp),%rdi
	call _list_cut
	xorl %esi,%esi
	movq %r14,%rdi
	call _list_cut
	jmp L151
L150:
	movq -24(%rbp),%rdi
	addq $8,%rdi
	call _insert
	movl %r13d,24(%rax)
	movq -16(%rbp),%rdx
	testq %rdx,%rdx
	jz L179
L177:
	movq 40(%rax),%rcx
	movq %rdx,(%rcx)
	movq 40(%rax),%rdx
	movq -16(%rbp),%rcx
	movq %rdx,40(%rcx)
	movq -8(%rbp),%rcx
	movq %rcx,40(%rax)
	movq $0,-16(%rbp)
	movq %r12,-8(%rbp)
L179:
	movq (%r14),%rdx
	testq %rdx,%rdx
	jz L151
L186:
	movq 56(%rax),%rcx
	movq %rdx,(%rcx)
	movq 56(%rax),%rdx
	movq (%r14),%rcx
	movq %rdx,40(%rcx)
	movq 8(%r14),%rcx
	movq %rcx,56(%rax)
	movq $0,(%r14)
	movq %r14,8(%r14)
L151:
	movq -24(%rbp),%rdi
	call _token_free
L119:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_macro_cmdline:
L192:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
L193:
	leaq -16(%rbp),%rcx
	xorl %eax,%eax
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movq $0,-16(%rbp)
	movq %rcx,-8(%rbp)
	movq %rdi,%rsi
	leaq -16(%rbp),%rdi
	call _input_tokenize
	leaq -16(%rbp),%rdi
	call _list_strip_ends
	movq -16(%rbp),%rax
	testq %rax,%rax
	jz L214
L198:
	cmpl $52,(%rax)
	jnz L214
L200:
	movq 32(%rax),%rsi
	testq %rsi,%rsi
	jz L204
L203:
	cmpl $536870925,(%rsi)
	jz L208
L214:
	xorl %eax,%eax
	jmp L194
L208:
	leaq -16(%rbp),%rdi
	call _list_drop
	jmp L205
L204:
	movl $1,%edi
	call _token_number
	leaq 32(%rax),%rdx
	movq $0,32(%rax)
	movq -8(%rbp),%rcx
	movq %rcx,40(%rax)
	movq -8(%rbp),%rcx
	movq %rax,(%rcx)
	movq %rdx,-8(%rbp)
L205:
	leaq -16(%rbp),%rdi
	call _macro_define
	movl $1,%eax
L194:
	movq %rbp,%rsp
	popq %rbp
	ret 


_macro_undef:
L215:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L216:
	leaq -8(%rbp),%rdx
	movl $52,%esi
	call _list_match
	movq -8(%rbp),%rdi
	addq $8,%rdi
	call _macro_lookup
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L220
L218:
	testl $63,24(%rbx)
	jz L223
L221:
	testl $1,(%rbx)
	jz L226
L225:
	leaq 1(%rbx),%rax
	jmp L227
L226:
	movq 16(%rbx),%rax
L227:
	pushq %rax
	pushq $L224
	call _error
	addq $16,%rsp
L223:
	xorl %esi,%esi
	leaq 32(%rbx),%rdi
	call _list_cut
	xorl %esi,%esi
	leaq 48(%rbx),%rdi
	call _list_cut
	movq %rbx,%rdi
	call _vstring_free
	movq -8(%rbp),%rdi
	addq $8,%rdi
	call _hash
	andl $63,%eax
	movq 64(%rbx),%rdx
	movq 72(%rbx),%rcx
	testq %rdx,%rdx
	jz L232
L231:
	movq %rcx,72(%rdx)
	jmp L233
L232:
	movslq %eax,%rax
	shlq $4,%rax
	movq %rcx,_buckets+8(%rax)
L233:
	movq 64(%rbx),%rcx
	movq 72(%rbx),%rax
	movq %rcx,(%rax)
	movq %rbx,%rdi
	call _free
L220:
	movq -8(%rbp),%rdi
	call _token_free
L217:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_arg_new:
L234:
	pushq %rbx
L235:
	movq %rdi,%rbx
	movl $32,%edi
	call _safe_malloc
	movq $0,(%rax)
	movq %rax,8(%rax)
	leaq 16(%rax),%rdx
	movq $0,16(%rax)
	movq 8(%rbx),%rcx
	movq %rcx,24(%rax)
	movq 8(%rbx),%rcx
	movq %rax,(%rcx)
	movq %rdx,8(%rbx)
L236:
	popq %rbx
	ret 


_args_clear:
L244:
	pushq %rbx
	pushq %r12
L245:
	movq %rdi,%rbx
L247:
	movq (%rbx),%r12
	testq %r12,%r12
	jz L246
L248:
	xorl %esi,%esi
	movq %r12,%rdi
	call _list_cut
	movq %r12,%rdi
	call _free
	movq 16(%r12),%rcx
	movq 24(%r12),%rax
	testq %rcx,%rcx
	jz L254
L253:
	movq %rax,24(%rcx)
	jmp L255
L254:
	movq %rax,8(%rbx)
L255:
	movq 16(%r12),%rcx
	movq 24(%r12),%rax
	movq %rcx,(%rax)
	jmp L247
L246:
	popq %r12
	popq %rbx
	ret 


_arg_i:
L256:
	pushq %rbx
L257:
	movq (%rdi),%rbx
L259:
	cmpl $0,%esi
	jle L262
L260:
	movq 16(%rbx),%rbx
	decl %esi
	jmp L259
L262:
	testq %rbx,%rbx
	jnz L265
L263:
	pushq $L266
	call _error
	addq $8,%rsp
L265:
	movq %rbx,%rax
L258:
	popq %rbx
	ret 


_gather:
L268:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L269:
	movq %rdi,%r15
	movq %rsi,%r14
	movq %rdx,%r13
	xorl %esi,%esi
	movq %r15,%rdi
	call _list_pop
	movq 32(%r14),%r12
L271:
	testq %r12,%r12
	jz L273
L272:
	movq %r13,%rdi
	call _arg_new
	movq %rax,%rbx
	xorl %edx,%edx
L274:
	movq (%r15),%rcx
	testq %rcx,%rcx
	jz L276
L275:
	testl %edx,%edx
	jnz L282
L280:
	movl (%rcx),%eax
	cmpl $536870959,%eax
	jz L276
L284:
	cmpl $536870928,%eax
	jz L276
L282:
	movl (%rcx),%eax
	cmpl $536870927,%eax
	jnz L291
L289:
	incl %edx
L291:
	cmpl $536870928,%eax
	jnz L295
L292:
	decl %edx
L295:
	leaq 32(%rcx),%rax
	movq 32(%rcx),%rdi
	movq 40(%rcx),%rsi
	testq %rdi,%rdi
	jz L299
L298:
	movq %rsi,40(%rdi)
	jmp L300
L299:
	movq %rsi,8(%r15)
L300:
	movq 32(%rcx),%rdi
	movq 40(%rcx),%rsi
	movq %rdi,(%rsi)
	movq $0,32(%rcx)
	movq 8(%rbx),%rsi
	movq %rsi,40(%rcx)
	movq 8(%rbx),%rsi
	movq %rcx,(%rsi)
	movq %rax,8(%rbx)
	jmp L274
L276:
	movq %rbx,%rdi
	call _list_strip_ends
	movq %rbx,%rdi
	call _list_fold_spaces
	movq %rbx,%rdi
	call _list_placeholder
	movq 32(%r12),%r12
	movq (%r15),%rax
	testq %rax,%rax
	jz L273
L307:
	cmpl $536870959,(%rax)
	jnz L273
L308:
	xorl %esi,%esi
	movq %r15,%rdi
	call _list_pop
	jmp L271
L273:
	testq %r12,%r12
	jz L314
L312:
	testl $1,(%r14)
	jz L317
L316:
	leaq 1(%r14),%rax
	jmp L318
L317:
	movq 16(%r14),%rax
L318:
	pushq %rax
	pushq $L315
	call _error
	addq $16,%rsp
L314:
	movq (%r15),%rdi
	call _list_skip_spaces
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L321
L319:
	testl $1,(%r14)
	jz L324
L323:
	leaq 1(%r14),%rax
	jmp L325
L324:
	movq 16(%r14),%rax
L325:
	pushq %rax
	pushq $L322
	call _error
	addq $16,%rsp
L321:
	cmpl $536870928,(%rbx)
	jz L328
L326:
	testl $1,(%r14)
	jz L331
L330:
	incq %r14
	jmp L332
L331:
	movq 16(%r14),%r14
L332:
	pushq %r14
	pushq $L329
	call _error
	addq $16,%rsp
L328:
	movq 32(%rbx),%rsi
	movq %r15,%rdi
	call _list_cut
L270:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_stringize:
L333:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L334:
	movq %rdi,%r12
	movq %rsi,%rbx
	movq (%r12),%r14
L336:
	testq %r14,%r14
	jz L335
L337:
	cmpl $1610612793,(%r14)
	jnz L340
L339:
	movq %r14,%rsi
	movq %r12,%rdi
	call _list_drop
	movq %rax,%r14
L342:
	testq %r14,%r14
	jz L344
L345:
	cmpl $51,(%r14)
	jnz L344
L343:
	movq %r14,%rsi
	movq %r12,%rdi
	call _list_drop
	movq %rax,%r14
	jmp L342
L344:
	testq %r14,%r14
	jz L349
L352:
	cmpl $2147483709,(%r14)
	jz L351
L349:
	pushq $L356
	call _error
	addq $8,%rsp
L351:
	movq 8(%r14),%rsi
	movq %rbx,%rdi
	call _arg_i
	movq %rax,%r13
	movq %r14,%rsi
	movq %r12,%rdi
	call _list_drop
	movq %rax,%r14
	movq %r13,%rdi
	call _list_stringize
	movq %rax,%rdx
	movq %r14,%rsi
	movq %r12,%rdi
	call _list_insert
	jmp L336
L340:
	movq 32(%r14),%r14
	jmp L336
L335:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_expand:
L357:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L358:
	movq %rdi,%r12
	movq %rsi,%rbx
	leaq -16(%rbp),%rcx
	xorl %eax,%eax
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movq $0,-16(%rbp)
	movq %rcx,-8(%rbp)
	movq (%r12),%r13
L360:
	testq %r13,%r13
	jz L359
L361:
	cmpl $2147483709,(%r13)
	jnz L364
L363:
	movq 8(%r13),%rsi
	movq %rbx,%rdi
	call _arg_i
	movq %rax,%rsi
	leaq -16(%rbp),%rdi
	call _list_copy
	movl $1610612794,%edx
	movq %r13,%rsi
	movq %r12,%rdi
	call _list_next_is
	testl %eax,%eax
	jnz L368
L369:
	movl $1610612794,%edx
	movq %r13,%rsi
	movq %r12,%rdi
	call _list_prev_is
	testl %eax,%eax
	jnz L368
L366:
	leaq -16(%rbp),%rdi
	call _macro_replace_all
L368:
	movq %r13,%rsi
	movq %r12,%rdi
	call _list_drop
	movq %rax,%r13
	leaq -16(%rbp),%rdx
	movq %rax,%rsi
	movq %r12,%rdi
	call _list_insert_list
	jmp L360
L364:
	movq 32(%r13),%r13
	jmp L360
L359:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_paste:
L373:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L374:
	movq %rdi,%r15
	movq (%r15),%r14
L376:
	testq %r14,%r14
	jz L375
L377:
	cmpl $1610612794,(%r14)
	jnz L380
L379:
	movq %r14,%rsi
	movq %r15,%rdi
	call _list_strip_around
	movq 40(%r14),%rax
	movq 8(%rax),%rax
	movq (%rax),%r13
	movq 32(%r14),%r12
	testq %r13,%r13
	jz L382
L385:
	testq %r12,%r12
	jnz L384
L382:
	pushq $L389
	call _error
	addq $8,%rsp
L384:
	movq %r12,%rsi
	movq %r13,%rdi
	call _token_paste
	movq %rax,%rbx
	movq %r13,%rsi
	movq %r15,%rdi
	call _list_drop
	movq %r12,%rsi
	movq %r15,%rdi
	call _list_drop
	movq %r14,%rsi
	movq %r15,%rdi
	call _list_drop
	movq %rax,%r14
	movq %rbx,%rdx
	movq %rax,%rsi
	movq %r15,%rdi
	call _list_insert
	jmp L376
L380:
	movq 32(%r14),%r14
	jmp L376
L375:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_macro_replace:
L390:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L391:
	movq %rdi,%r14
	leaq -16(%rbp),%rcx
	xorl %eax,%eax
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movq $0,-16(%rbp)
	movq %rcx,-8(%rbp)
	leaq -32(%rbp),%r13
	xorl %eax,%eax
	movq %rax,-32(%rbp)
	movq %rax,-24(%rbp)
	movq $0,-32(%rbp)
	movq %r13,-24(%rbp)
	movq (%r14),%r12
	cmpl $52,(%r12)
	jnz L435
L395:
	leaq 8(%r12),%rdi
	call _macro_lookup
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L435
L400:
	movl 24(%rbx),%eax
	testl $1,%eax
	jnz L435
L402:
	testl $2147483648,%eax
	jz L406
L405:
	movq 32(%r12),%rdi
	call _list_skip_spaces
	movq %rax,%rsi
	testq %rsi,%rsi
	jz L435
L411:
	cmpl $536870927,(%rsi)
	jz L413
L435:
	xorl %eax,%eax
	jmp L392
L413:
	movq %r14,%rdi
	call _list_cut
	leaq -16(%rbp),%rdx
	movq %rbx,%rsi
	movq %r14,%rdi
	call _gather
	jmp L407
L406:
	xorl %esi,%esi
	movq %r14,%rdi
	call _list_pop
L407:
	leaq -32(%rbp),%rsi
	movq %rbx,%rdi
	call _tokens
	leaq -16(%rbp),%rsi
	leaq -32(%rbp),%rdi
	call _stringize
	leaq -16(%rbp),%rsi
	leaq -32(%rbp),%rdi
	call _expand
	leaq -32(%rbp),%rdi
	call _paste
	movq %rbx,%rsi
	leaq -32(%rbp),%rdi
	call _list_ennervate
	movq (%r14),%rcx
	testq %rcx,%rcx
	jz L421
L419:
	movq -24(%rbp),%rax
	movq %rcx,(%rax)
	movq -24(%rbp),%rcx
	movq (%r14),%rax
	movq %rcx,40(%rax)
	movq 8(%r14),%rax
	movq %rax,-24(%rbp)
	movq $0,(%r14)
	movq %r14,8(%r14)
L421:
	movq -32(%rbp),%rcx
	testq %rcx,%rcx
	jz L430
L428:
	movq 8(%r14),%rax
	movq %rcx,(%rax)
	movq 8(%r14),%rcx
	movq -32(%rbp),%rax
	movq %rcx,40(%rax)
	movq -24(%rbp),%rax
	movq %rax,8(%r14)
	movq $0,-32(%rbp)
	movq %r13,-24(%rbp)
L430:
	leaq -16(%rbp),%rdi
	call _args_clear
	movl $1,%eax
L392:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_macro_replace_all:
L436:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
L437:
	movq %rdi,%rbx
	leaq -16(%rbp),%rcx
	xorl %eax,%eax
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movq $0,-16(%rbp)
	movq %rcx,-8(%rbp)
	movq (%rbx),%rax
	testq %rax,%rax
	jz L448
L442:
	movq %rax,-16(%rbp)
	movq (%rbx),%rax
	movq %rcx,40(%rax)
	movq 8(%rbx),%rax
	movq %rax,-8(%rbp)
	movq $0,(%rbx)
	movq %rbx,8(%rbx)
L448:
	cmpq $0,-16(%rbp)
	jz L438
L449:
	leaq -16(%rbp),%rdi
	call _macro_replace
	testl %eax,%eax
	jnz L448
L451:
	leaq -24(%rbp),%rsi
	leaq -16(%rbp),%rdi
	call _list_pop
	movq -24(%rbp),%rax
	movq $0,32(%rax)
	movq 8(%rbx),%rax
	movq -24(%rbp),%rcx
	movq %rax,40(%rcx)
	movq 8(%rbx),%rax
	movq -24(%rbp),%rcx
	movq %rcx,(%rax)
	movq -24(%rbp),%rax
	addq $32,%rax
	movq %rax,8(%rbx)
	jmp L448
L438:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L315:
 .byte 116,111,111,32,102,101,119,32
 .byte 97,114,103,117,109,101,110,116
 .byte 115,32,116,111,32,109,97,99
 .byte 114,111,32,39,37,115,39,0
L27:
 .byte 95,95,83,84,68,67,95,95
 .byte 0
L30:
 .byte 95,95,68,65,84,69,95,95
 .byte 0
L155:
 .byte 99,97,110,39,116,32,35,100
 .byte 101,102,105,110,101,32,114,101
 .byte 115,101,114,118,101,100,32,105
 .byte 100,101,110,116,105,102,105,101
 .byte 114,32,39,37,115,39,0
L266:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,97,114
 .byte 103,117,109,101,110,116,32,111
 .byte 117,116,32,111,102,32,98,111
 .byte 117,110,100,115,0
L356:
 .byte 105,108,108,101,103,97,108,32
 .byte 111,112,101,114,97,110,100,32
 .byte 116,111,32,115,116,114,105,110
 .byte 103,105,122,101,32,40,35,41
 .byte 0
L28:
 .byte 95,95,76,73,78,69,95,95
 .byte 0
L389:
 .byte 109,105,115,115,105,110,103,32
 .byte 111,112,101,114,97,110,100,115
 .byte 32,116,111,32,112,97,115,116
 .byte 101,32,40,35,35,41,32,111
 .byte 112,101,114,97,116,111,114,0
L31:
 .byte 95,95,84,73,77,69,95,95
 .byte 0
L32:
 .byte 100,101,102,105,110,101,100,0
L322:
 .byte 100,101,102,111,114,109,101,100
 .byte 32,97,114,103,117,109,101,110
 .byte 116,115,32,116,111,32,109,97
 .byte 99,114,111,32,39,37,115,39
 .byte 0
L79:
 .byte 37,72,58,37,77,58,37,83
 .byte 0
L29:
 .byte 95,95,70,73,76,69,95,95
 .byte 0
L224:
 .byte 99,97,110,39,116,32,35,117
 .byte 110,100,101,102,32,114,101,115
 .byte 101,114,118,101,100,32,105,100
 .byte 101,110,116,105,102,105,101,114
 .byte 32,39,37,115,39,0
L170:
 .byte 105,110,99,111,109,112,97,116
 .byte 105,98,108,101,32,114,101,45
 .byte 35,100,101,102,105,110,105,116
 .byte 105,111,110,32,111,102,32,39
 .byte 37,115,39,0
L71:
 .byte 37,98,32,37,100,32,37,89
 .byte 0
L329:
 .byte 116,111,111,32,109,97,110,121
 .byte 32,97,114,103,117,109,101,110
 .byte 116,115,32,116,111,32,109,97
 .byte 99,114,111,32,39,37,115,39
 .byte 0
.local _buckets
.comm _buckets, 1024, 8

.globl _input_tokenize
.globl _list_strip_around
.globl _free
.globl _token_number
.globl _vstring_init
.globl _vstring_same
.globl _localtime
.globl _macro_replace
.globl _list_ennervate
.globl _error
.globl _token_paste
.globl _list_insert
.globl _macro_cmdline
.globl _list_stringize
.globl _list_pop
.globl _vstring_concat
.globl _list_fold_spaces
.globl _token_string
.globl _safe_malloc
.globl _list_next_is
.globl _list_normalize
.globl _list_prev_is
.globl _list_cut
.globl _macro_undef
.globl _macro_define
.globl _vstring_puts
.globl _list_same
.globl _list_copy
.globl _vstring_clear
.globl _macro_replace_all
.globl _token_free
.globl _vstring_free
.globl _macro_lookup
.globl _macro_predef
.globl _time
.globl _strftime
.globl _list_insert_list
.globl _list_strip_ends
.globl _list_match
.globl _input_stack
.globl _list_skip_spaces
.globl _list_placeholder
.globl _list_drop
