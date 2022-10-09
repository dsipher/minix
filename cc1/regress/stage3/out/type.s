.data
.align 8
_tnode_slab:
	.int 40
	.int 100
	.fill 16, 1, 0
.align 8
_formal_slab:
	.int 16
	.int 100
	.fill 16, 1, 0
.align 8
_void_type:
	.quad 1
	.fill 32, 1, 0
.align 8
_char_type:
	.quad 2
	.fill 32, 1, 0
.align 8
_schar_type:
	.quad 4
	.fill 32, 1, 0
.align 8
_uchar_type:
	.quad 8
	.fill 32, 1, 0
.align 8
_short_type:
	.quad 16
	.fill 32, 1, 0
.align 8
_ushort_type:
	.quad 32
	.fill 32, 1, 0
.align 8
_int_type:
	.quad 64
	.fill 32, 1, 0
.align 8
_uint_type:
	.quad 128
	.fill 32, 1, 0
.align 8
_long_type:
	.quad 256
	.fill 32, 1, 0
.align 8
_ulong_type:
	.quad 512
	.fill 32, 1, 0
.align 8
_float_type:
	.quad 1024
	.fill 32, 1, 0
.align 8
_double_type:
	.quad 2048
	.fill 32, 1, 0
.align 8
_ldouble_type:
	.quad 4096
	.fill 32, 1, 0
.align 8
_map:
	.int 256
	.fill 4, 1, 0
	.quad _void_type
	.int 512
	.fill 4, 1, 0
	.quad _char_type
	.int 66048
	.fill 4, 1, 0
	.quad _schar_type
	.int 33280
	.fill 4, 1, 0
	.quad _uchar_type
	.int 1024
	.fill 4, 1, 0
	.quad _short_type
	.int 3072
	.fill 4, 1, 0
	.quad _short_type
	.int 66560
	.fill 4, 1, 0
	.quad _short_type
	.int 68608
	.fill 4, 1, 0
	.quad _short_type
	.int 33792
	.fill 4, 1, 0
	.quad _ushort_type
	.int 35840
	.fill 4, 1, 0
	.quad _ushort_type
	.int 2048
	.fill 4, 1, 0
	.quad _int_type
	.int 65536
	.fill 4, 1, 0
	.quad _int_type
	.int 67584
	.fill 4, 1, 0
	.quad _int_type
	.int 32768
	.fill 4, 1, 0
	.quad _uint_type
	.int 34816
	.fill 4, 1, 0
	.quad _uint_type
	.int 4096
	.fill 4, 1, 0
	.quad _long_type
	.int 6144
	.fill 4, 1, 0
	.quad _long_type
	.int 69632
	.fill 4, 1, 0
	.quad _long_type
	.int 71680
	.fill 4, 1, 0
	.quad _long_type
	.int 36864
	.fill 4, 1, 0
	.quad _ulong_type
	.int 38912
	.fill 4, 1, 0
	.quad _ulong_type
	.int 8192
	.fill 4, 1, 0
	.quad _float_type
	.int 16384
	.fill 4, 1, 0
	.quad _double_type
	.int 20480
	.fill 4, 1, 0
	.quad _ldouble_type
.text

_map_type:
L1:
	pushq %rbx
L2:
	xorl %ecx,%ecx
L5:
	movl %ecx,%eax
	shlq $4,%rax
	cmpl _map(%rax),%edi
	jz L8
L10:
	incl %ecx
	cmpl $24,%ecx
	jl L5
L7:
	pushq $L12
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
	jmp L3
L8:
	movq _map+8(%rax),%rbx
L3:
	movq %rbx,%rax
	popq %rbx
	ret 


_new_formal:
L13:
	pushq %rbx
	pushq %r12
	pushq %r13
L14:
	movq _formal_slab+8(%rip),%r12
	movq %rdi,%rbx
	movq %rsi,%r13
	testq %r12,%r12
	jz L17
L16:
	movq (%r12),%rax
	movq %rax,_formal_slab+8(%rip)
	jmp L18
L17:
	movl $_formal_slab,%edi
	call _refill_slab
	movq %rax,%r12
L18:
	decl _formal_slab+20(%rip)
	movq %r13,%rdi
	call _unqualify
	movq %rax,(%r12)
	movq $0,8(%r12)
	addq $16,%rbx
	jmp L19
L20:
	leaq 8(%rax),%rbx
L19:
	movq (%rbx),%rax
	testq %rax,%rax
	jnz L20
L22:
	movq %r12,(%rbx)
L15:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_new_tnode:
L23:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L24:
	movq _tnode_slab+8(%rip),%rbx
	movq %rdi,%r14
	movq %rsi,%r13
	movq %rdx,%r12
	testq %rbx,%rbx
	jz L27
L26:
	movq (%rbx),%rax
	movq %rax,_tnode_slab+8(%rip)
	jmp L28
L27:
	movl $_tnode_slab,%edi
	call _refill_slab
	movq %rax,%rbx
L28:
	decl _tnode_slab+20(%rip)
	movq %r14,(%rbx)
	movq %r13,16(%rbx)
	movq %r12,24(%rbx)
	testq $32768,%r14
	jz L31
L32:
	testq %r13,%r13
	jz L31
L29:
	movq $0,16(%rbx)
	jmp L36
L37:
	movq (%r13),%rsi
	movq %rbx,%rdi
	call _new_formal
	movq 8(%r13),%r13
L36:
	testq %r13,%r13
	jnz L37
L31:
	movq %rbx,%rax
L25:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_tnode_hash:
L41:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L42:
	movq %rdi,%r12
	movq %rsi,%rbx
	movq %rdx,%r14
	movq %r12,%r13
	andl $131071,%r13d
	movq %r13,%rdi
	call ___builtin_ctz
	incl %eax
	shll $2,%eax
	movslq %eax,%rax
	testq $131072,%r12
	jz L46
L44:
	addq $2,%rax
L46:
	testq $262144,%r12
	jz L49
L47:
	incq %rax
L49:
	movq $580999813330387073,%rcx
	imulq %rcx,%rax
	movq $549755813888,%rcx
	testq %r12,%rcx
	jz L52
L50:
	xorq $-1,%rax
	movq $545460846592,%rdx
	andq %r12,%rdx
	sarq $32,%rdx
	movq $69269232549888,%rcx
	andq %r12,%rcx
	sarq $40,%rcx
	addq %rcx,%rdx
	addq %rdx,%rax
L52:
	cmpq $16384,%r13
	jz L56
L67:
	cmpq $8192,%r13
	jz L58
L68:
	cmpq $32768,%r13
	jnz L54
L61:
	testq %rbx,%rbx
	jz L54
L62:
	movq (%rbx),%rcx
	xorq 8(%rcx),%rax
	movq 8(%rbx),%rbx
	jmp L61
L58:
	sarq $5,%rbx
	xorq %rbx,%rax
	jmp L54
L56:
	xorq %rax,%rbx
	movq %rbx,%rax
L54:
	sarq $5,%r14
	xorq %r14,%rax
L43:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_tnode_find:
L71:
L72:
	movq %rcx,%rax
	andl $127,%eax
	movslq %eax,%rax
	movq _buckets(,%rax,8),%rax
	jmp L74
L75:
	cmpq 8(%rax),%rcx
	jnz L76
L85:
	movq (%rax),%r8
	cmpq %r8,%rdi
	jnz L76
L81:
	cmpq 24(%rax),%rdx
	jnz L76
L80:
	testq $32768,%r8
	jz L91
L90:
	movq 16(%rax),%r10
	movq %rsi,%r9
L93:
	testq %r10,%r10
	jz L96
L101:
	testq %r9,%r9
	jz L96
L97:
	movq (%r10),%r8
	cmpq (%r9),%r8
	jnz L96
L94:
	movq 8(%r10),%r10
	movq 8(%r9),%r9
	jmp L93
L96:
	testq %r10,%r10
	jnz L76
L108:
	testq %r9,%r9
	jnz L76
	ret
L91:
	cmpq 16(%rax),%rsi
	jz L73
L76:
	movq 32(%rax),%rax
L74:
	testq %rax,%rax
	jnz L75
L77:
	xorl %eax,%eax
L73:
	ret 


_get_tnode:
L119:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L120:
	movq %rdi,%r14
	movq %rsi,%r13
	movq %rdx,%r12
	movq %r12,%rdx
	movq %r13,%rsi
	movq %r14,%rdi
	call _tnode_hash
	movq %rax,%rbx
	movq %rbx,%rcx
	movq %r12,%rdx
	movq %r13,%rsi
	movq %r14,%rdi
	call _tnode_find
	testq %rax,%rax
	jnz L121
L122:
	movq %r12,%rdx
	movq %r13,%rsi
	movq %r14,%rdi
	call _new_tnode
	movq %rbx,8(%rax)
	andl $127,%ebx
	movslq %ebx,%rdx
	movq _buckets(,%rdx,8),%rcx
	movq %rcx,32(%rax)
	movq %rax,_buckets(,%rdx,8)
L121:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_graft:
L129:
	pushq %rbx
	pushq %r12
	pushq %r13
L130:
	movq %rdi,%r12
	movq %rsi,%rdx
L132:
	movq %r12,%rbx
	testq %r12,%r12
	jz L134
L133:
	leaq 24(%r12),%r13
	movq 24(%r12),%r12
	movq %rdx,(%r13)
	movq (%rbx),%rdi
	movq 16(%rbx),%rsi
	call _tnode_hash
	movq %rax,8(%rbx)
	movq (%rbx),%rdi
	movq 16(%rbx),%rsi
	movq %rax,%rcx
	movq (%r13),%rdx
	call _tnode_find
	movq %rax,%rdx
	testq %rdx,%rdx
	jnz L136
L138:
	movq 8(%rbx),%rax
	andl $127,%eax
	movslq %eax,%rcx
	movq _buckets(,%rcx,8),%rax
	movq %rax,32(%rbx)
	movq %rbx,_buckets(,%rcx,8)
	movq %rbx,%rdx
	jmp L132
L136:
	testq $32768,(%rbx)
	jz L151
L141:
	movq 16(%rbx),%rsi
	jmp L144
L145:
	movq 8(%rsi),%rcx
	movq _formal_slab+8(%rip),%rax
	movq %rax,(%rsi)
	movq %rsi,_formal_slab+8(%rip)
	incl _formal_slab+20(%rip)
	movq %rcx,%rsi
L144:
	testq %rsi,%rsi
	jnz L145
L151:
	movq _tnode_slab+8(%rip),%rax
	movq %rax,(%rbx)
	movq %rbx,_tnode_slab+8(%rip)
	incl _tnode_slab+20(%rip)
	jmp L132
L134:
	movq %rdx,%rax
L131:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_seed_types:
L155:
	pushq %rbx
	pushq %r12
L156:
	xorl %r12d,%r12d
L159:
	movl %r12d,%eax
	shlq $4,%rax
	movq _map+8(%rax),%rbx
	cmpq $0,8(%rbx)
	jnz L164
L162:
	xorl %edx,%edx
	xorl %esi,%esi
	movq (%rbx),%rdi
	call _tnode_hash
	movq %rax,8(%rbx)
	incl _nr_static_tnodes(%rip)
	movq 8(%rbx),%rax
	andl $127,%eax
	movslq %eax,%rcx
	movq _buckets(,%rcx,8),%rax
	movq %rax,32(%rbx)
	movq %rbx,_buckets(,%rcx,8)
L164:
	incl %r12d
	cmpl $24,%r12d
	jl L159
L157:
	popq %r12
	popq %rbx
	ret 


_qualify:
L168:
	pushq %rbx
	pushq %r12
	pushq %r13
L169:
	movq %rdi,%rbx
	movq %rsi,%r12
	movq %rbx,%rax
	jmp L171
L172:
	movq 24(%rax),%rax
L171:
	testq $16384,(%rax)
	jnz L172
L173:
	movq (%rbx),%rax
	andq %r12,%rax
	cmpq %rax,%r12
	jz L174
L176:
	xorl %r13d,%r13d
	jmp L178
L179:
	movslq 16(%rbx),%rsi
	movq %r13,%rdx
	movl $16384,%edi
	call _new_tnode
	movq %rax,%r13
	movq 24(%rbx),%rbx
L178:
	movq (%rbx),%rax
	testq $16384,%rax
	jnz L179
L180:
	testq $32768,%rax
	jz L183
L181:
	pushq $L184
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L183:
	orq (%rbx),%r12
	movq %r13,%rdx
	movq 16(%rbx),%rsi
	movq %r12,%rdi
	call _new_tnode
	movq 24(%rbx),%rsi
	movq %rax,%rdi
	call _graft
	jmp L170
L174:
	movq %rbx,%rax
L170:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_unqualify:
L186:
L187:
	movq %rdi,%rax
	movq (%rax),%rdi
	testq $393216,%rdi
	jz L188
L189:
	andq $-393217,%rdi
	movq 16(%rax),%rsi
	movq 24(%rax),%rdx
	call _get_tnode
L188:
	ret 


_tnode_compat:
L193:
L194:
	movq (%rdi),%r8
	movq %r8,%rdx
	andl $393216,%edx
	movq (%rsi),%rax
	movq %rax,%rcx
	andl $393216,%ecx
	cmpq %rcx,%rdx
	jnz L258
L198:
	movq %r8,%rdx
	andl $131071,%edx
	movq %rax,%rcx
	andl $131071,%ecx
	cmpq %rcx,%rdx
	jnz L258
L202:
	cmpq $8192,%rdx
	jz L207
L261:
	cmpq $16384,%rdx
	jz L209
L262:
	cmpq $32768,%rdx
	jnz L259
L219:
	movq %r8,%r9
	andl $32768,%r9d
	jz L225
L223:
	testq $1048576,%r8
	jz L225
L224:
	movl $1,%r10d
	jmp L226
L225:
	xorl %r10d,%r10d
L226:
	movq %rax,%rcx
	andl $32768,%ecx
	jz L229
L227:
	testq $1048576,%rax
	jz L229
L228:
	movl $1,%edx
	jmp L230
L229:
	xorl %edx,%edx
L230:
	cmpl %edx,%r10d
	jz L222
L258:
	xorl %eax,%eax
	ret
L222:
	testq %r9,%r9
	jz L235
L239:
	testq $524288,%r8
	jnz L259
L235:
	testq %rcx,%rcx
	jz L234
L243:
	testq $524288,%rax
	jnz L259
L234:
	movq 16(%rdi),%rcx
	movq 16(%rsi),%rax
	jmp L248
L252:
	testq %rax,%rax
	jz L251
L249:
	movq 8(%rcx),%rcx
	movq 8(%rax),%rax
L248:
	testq %rcx,%rcx
	jnz L252
L251:
	cmpq %rax,%rcx
	jmp L265
L209:
	movl 16(%rdi),%ecx
	testl %ecx,%ecx
	jz L259
L213:
	movl 16(%rsi),%eax
	testl %eax,%eax
	jnz L210
L259:
	movl $1,%eax
	ret
L210:
	cmpl %eax,%ecx
	jmp L265
L207:
	movq 16(%rdi),%rax
	cmpq 16(%rsi),%rax
L265:
	setz %al
	movzbl %al,%eax
L195:
	ret 


_compat:
L266:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L267:
	movq %rdi,%r12
	movq %rsi,%rbx
	jmp L269
L281:
	testq %rbx,%rbx
	jz L272
L277:
	cmpq %rbx,%r12
	jz L272
L273:
	movq %rbx,%rsi
	movq %r12,%rdi
	call _tnode_compat
	testl %eax,%eax
	jz L272
L270:
	movq (%r12),%rax
	testq $32768,%rax
	jz L287
L296:
	testq $524288,%rax
	jnz L287
L288:
	movq (%rbx),%rax
	testq $32768,%rax
	jz L285
L300:
	testq $524288,%rax
	jnz L287
L285:
	movq 16(%r12),%r14
	movq 16(%rbx),%r13
L304:
	testq %r14,%r14
	jz L287
L308:
	testq %r13,%r13
	jz L287
L305:
	movq (%r14),%rdi
	movq (%r13),%rsi
	call _compat
	testl %eax,%eax
	jz L312
L314:
	movq 8(%r14),%r14
	movq 8(%r13),%r13
	jmp L304
L312:
	xorl %eax,%eax
	jmp L268
L287:
	movq 24(%r12),%r12
	movq 24(%rbx),%rbx
L269:
	testq %r12,%r12
	jnz L281
L272:
	cmpq %rbx,%r12
	setz %al
	movzbl %al,%eax
L268:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_compose:
L317:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L318:
	movq %rdx,-8(%rbp) # spill
	xorl %r13d,%r13d
	movq %rdi,%r12
	movq %rsi,%rbx
	jmp L320
L332:
	testq %rbx,%rbx
	jz L323
L328:
	cmpq %rbx,%r12
	jz L323
L324:
	movq %rbx,%rsi
	movq %r12,%rdi
	call _tnode_compat
	testl %eax,%eax
	jz L323
L321:
	movq (%r12),%rdi
	testq $16384,%rdi
	jz L337
L336:
	movl 16(%r12),%esi
	movl 16(%rbx),%eax
	cmpl %eax,%esi
	cmovlel %eax,%esi
	movslq %esi,%rsi
	movq %r13,%rdx
	movl $16384,%edi
	jmp L372
L337:
	testq $32768,%rdi
	jz L373
L348:
	testq $524288,%rdi
	jz L346
L345:
	movq (%rbx),%rdi
	movq %r13,%rdx
	movq 16(%rbx),%rsi
	jmp L372
L346:
	movq (%rbx),%rax
	testq $32768,%rax
	jz L353
L355:
	testq $524288,%rax
	jz L353
L373:
	movq %r13,%rdx
	movq 16(%r12),%rsi
L372:
	call _new_tnode
	movq %rax,%r13
	jmp L338
L353:
	movq %r13,%rdx
	xorl %esi,%esi
	call _new_tnode
	movq %rax,%r13
	movq 16(%r12),%r15
	movq 16(%rbx),%r14
L359:
	testq %r15,%r15
	jz L338
L363:
	testq %r14,%r14
	jz L338
L360:
	movq (%r15),%rdi
	movq -8(%rbp),%rdx # spill
	movq (%r14),%rsi
	call _compose
	movq %rax,%rsi
	movq %r13,%rdi
	call _new_formal
	movq 8(%r15),%r15
	movq 8(%r14),%r14
	jmp L359
L338:
	movq 24(%r12),%r12
	movq 24(%rbx),%rbx
L320:
	testq %r12,%r12
	jnz L332
L323:
	cmpq %rbx,%r12
	jz L369
L367:
	pushq -8(%rbp) # spill
	pushq $L370
	movq -8(%rbp),%rax # spill
	pushq (%rax)
	pushq $4
	call _error
	addq $32,%rsp
L369:
	movq %r12,%rsi
	movq %r13,%rdi
	call _graft
L319:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_formal_type:
L374:
L375:
	movq %rdi,%rax
	movq (%rax),%rcx
	testq $16384,%rcx
	jz L378
L377:
	movq 24(%rax),%rdx
	jmp L384
L378:
	testq $32768,%rcx
	jz L376
L380:
	movq %rax,%rdx
L384:
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
L376:
	ret 


_t_size:
L385:
L386:
	testq $48,%rdi
	jnz L388
L390:
	testq $1216,%rdi
	jnz L392
L394:
	testq $72448,%rdi
	movl $8,%ecx
	movl $1,%eax
	cmovnzl %ecx,%eax
	ret
L392:
	movl $4,%eax
	ret
L388:
	movl $2,%eax
L387:
	ret 


_size_of:
L401:
	pushq %rbx
	pushq %r12
	pushq %r13
L402:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl $1,%r13d
	jmp L404
L405:
	movq (%r12),%rax
	andl $131071,%eax
	cmpq $16384,%rax
	jz L410
L437:
	cmpq $8192,%rax
	jz L416
L438:
	cmpq $1,%rax
	jz L422
L439:
	cmpq $32768,%rax
	jz L424
	jnz L407
L422:
	pushq $L423
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L424:
	pushq $L425
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L407:
	movq (%r12),%rdi
	call _t_size
	jmp L443
L416:
	movq 16(%r12),%rax
	testl $1073741824,12(%rax)
	jz L418
L417:
	movslq 32(%rax),%rax
	jmp L442
L418:
	pushq %rax
	pushq $L420
	pushq %rbx
	pushq $4
	call _error
	addq $32,%rsp
	jmp L408
L410:
	movl 16(%r12),%eax
	cmpl $0,%eax
	jle L412
L443:
	movslq %eax,%rax
L442:
	imulq %rax,%r13
	jmp L408
L412:
	pushq $L414
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L408:
	cmpq $134217728,%r13
	jle L429
L427:
	pushq $L430
	pushq %rbx
	pushq $1
	call _error
	addq $24,%rsp
L429:
	testq $65536,(%r12)
	jnz L406
L433:
	movq 24(%r12),%r12
L404:
	testq %r12,%r12
	jnz L405
L406:
	movl %r13d,%eax
L403:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_align_of:
L444:
L445:
	movq %rdi,%rcx
	jmp L447
L448:
	movq 24(%rcx),%rcx
L447:
	movq (%rcx),%rdi
	testq $16384,%rdi
	jnz L448
L449:
	movq %rdi,%rax
	andl $131071,%eax
	cmpq $8192,%rax
	jz L453
L463:
	cmpq $32768,%rax
	jz L459
L464:
	cmpq $1,%rax
	jz L459
L465:
	call _t_size
	ret
L453:
	movq 16(%rcx),%rax
	testl $1073741824,12(%rax)
	jnz L454
L459:
	movl $1,%eax
	ret
L454:
	movl 36(%rax),%eax
L446:
	ret 


_simpatico:
L467:
	pushq %rbx
	pushq %r12
L468:
	movq %rsi,%rbx
	movq (%rdi),%rdi
	testq $73726,%rdi
	jz L474
L484:
	movq (%rbx),%rdx
	testq $73726,%rdx
	jz L474
L480:
	testq $7168,%rdi
	setz %al
	movzbl %al,%ecx
	testq $7168,%rdx
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L474
L476:
	andl $131071,%edi
	call _t_size
	movl %eax,%r12d
	movq (%rbx),%rdi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%r12d
	jnz L474
L473:
	movl $1,%eax
	jmp L469
L474:
	xorl %eax,%eax
L469:
	popq %r12
	popq %rbx
	ret 


_narrower:
L490:
	pushq %rbx
	pushq %r12
L491:
	movq %rsi,%rbx
	movq (%rdi),%rdi
	testq $73726,%rdi
	jz L497
L507:
	movq (%rbx),%rdx
	testq $73726,%rdx
	jz L497
L503:
	testq $7168,%rdi
	setz %al
	movzbl %al,%ecx
	testq $7168,%rdx
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L497
L499:
	andl $131071,%edi
	call _t_size
	movl %eax,%r12d
	movq (%rbx),%rdi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%r12d
	jge L497
L496:
	movl $1,%eax
	jmp L492
L497:
	xorl %eax,%eax
L492:
	popq %r12
	popq %rbx
	ret 


_wider:
L513:
	pushq %rbx
	pushq %r12
L514:
	movq %rsi,%rbx
	movq (%rdi),%rdi
	testq $73726,%rdi
	jz L520
L530:
	movq (%rbx),%rdx
	testq $73726,%rdx
	jz L520
L526:
	testq $7168,%rdi
	setz %al
	movzbl %al,%ecx
	testq $7168,%rdx
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L520
L522:
	andl $131071,%edi
	call _t_size
	movl %eax,%r12d
	movq (%rbx),%rdi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%r12d
	jle L520
L519:
	movl $1,%eax
	jmp L515
L520:
	xorl %eax,%eax
L515:
	popq %r12
	popq %rbx
	ret 


_fieldify:
L536:
L537:
	movq (%rdi),%rax
	movq %rax,%rcx
	andl $131071,%ecx
	andl $393216,%eax
	orq %rcx,%rax
	movq $549755813888,%rcx
	orq %rax,%rcx
	movslq %esi,%rax
	shlq $32,%rax
	orq %rcx,%rax
	movslq %edx,%rdi
	shlq $40,%rdi
	orq %rax,%rdi
	xorl %edx,%edx
	xorl %esi,%esi
	call _get_tnode
L538:
	ret 


_unfieldify:
L540:
L541:
	movq %rdi,%rax
	movq (%rax),%rdi
	movq $549755813888,%rcx
	testq %rdi,%rcx
	jz L542
L543:
	movq %rdi,%rax
	andl $131071,%eax
	andl $393216,%edi
	orq %rax,%rdi
	xorl %edx,%edx
	xorl %esi,%esi
	call _get_tnode
L542:
	ret 


_validate:
L547:
	pushq %rbx
	pushq %r12
	pushq %r13
L548:
	movq %rdi,%r13
	movq %rsi,%r12
	testq $1,(%r13)
	jz L557
L553:
	testl %edx,%edx
	jnz L557
L550:
	pushq $L423
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
	jmp L557
L558:
	movq 24(%r13),%rbx
	testq $16384,(%r13)
	jz L563
L561:
	testq $16384,(%rbx)
	jz L566
L567:
	cmpl $0,16(%rbx)
	jnz L566
L564:
	pushq $L571
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L566:
	testq $32768,(%rbx)
	jz L574
L572:
	pushq $L575
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L574:
	testq $1,(%rbx)
	jz L578
L576:
	pushq $L579
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L578:
	testq $8192,(%rbx)
	jz L563
L580:
	movq 16(%rbx),%rax
	testl $1073741824,12(%rax)
	jnz L585
L583:
	pushq %rax
	pushq $L586
	pushq %r12
	pushq $4
	call _error
	addq $32,%rsp
L585:
	movq 16(%rbx),%rcx
	movl 12(%rcx),%eax
	testl $1,%eax
	jz L563
L590:
	testl $67108864,%eax
	jz L563
L587:
	pushq %rcx
	pushq $L594
	pushq %r12
	pushq $4
	call _error
	addq $32,%rsp
L563:
	testq $32768,(%r13)
	jz L597
L598:
	movq (%rbx),%rax
	movq %rax,%rcx
	andl $16384,%ecx
	jnz L595
L602:
	testq $32768,%rax
	jz L597
L595:
	testq %rcx,%rcx
	movl $L608,%eax
	movl $L607,%ecx
	cmovzq %rax,%rcx
	pushq %rcx
	pushq $L606
	pushq %r12
	pushq $4
	call _error
	addq $32,%rsp
L597:
	movq %rbx,%r13
L557:
	testq %r13,%r13
	jnz L558
L549:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L575:
	.byte 97,114,114,97,121,32,111,102
	.byte 32,102,117,110,99,116,105,111
	.byte 110,0
L420:
	.byte 37,84,32,105,115,32,105,110
	.byte 99,111,109,112,108,101,116,101
	.byte 0
L608:
	.byte 102,117,110,99,116,105,111,110
	.byte 115,0
L184:
	.byte 99,97,110,39,116,32,113,117
	.byte 97,108,105,102,121,32,102,117
	.byte 110,99,116,105,111,110,32,116
	.byte 121,112,101,115,0
L607:
	.byte 97,114,114,97,121,115,0
L423:
	.byte 105,108,108,101,103,97,108,32
	.byte 117,115,101,32,111,102,32,118
	.byte 111,105,100,32,116,121,112,101
	.byte 0
L586:
	.byte 97,114,114,97,121,32,111,102
	.byte 32,105,110,99,111,109,112,108
	.byte 101,116,101,32,37,84,0
L370:
	.byte 99,111,110,102,108,105,99,116
	.byte 105,110,103,32,116,121,112,101
	.byte 115,32,37,76,0
L430:
	.byte 116,121,112,101,32,116,111,111
	.byte 32,108,97,114,103,101,0
L594:
	.byte 97,114,114,97,121,32,111,102
	.byte 32,102,108,101,120,105,98,108
	.byte 101,32,37,84,0
L414:
	.byte 105,110,99,111,109,112,108,101
	.byte 116,101,32,97,114,114,97,121
	.byte 32,116,121,112,101,0
L12:
	.byte 105,110,118,97,108,105,100,32
	.byte 116,121,112,101,32,115,112,101
	.byte 99,105,102,105,99,97,116,105
	.byte 111,110,0
L579:
	.byte 97,114,114,97,121,32,111,102
	.byte 32,118,111,105,100,0
L425:
	.byte 105,108,108,101,103,97,108,32
	.byte 117,115,101,32,111,102,32,102
	.byte 117,110,99,116,105,111,110,32
	.byte 116,121,112,101,0
L571:
	.byte 105,110,118,97,108,105,100,32
	.byte 97,114,114,97,121,32,115,112
	.byte 101,99,105,102,105,99,97,116
	.byte 105,111,110,0
L606:
	.byte 102,117,110,99,116,105,111,110
	.byte 115,32,99,97,110,39,116,32
	.byte 114,101,116,117,114,110,32,37
	.byte 115,0
.local _buckets
.comm _buckets, 1024, 8
.local _nr_static_tnodes
.comm _nr_static_tnodes, 4, 4

.globl _float_type
.globl _compose
.globl _schar_type
.globl _narrower
.globl _error
.globl _graft
.globl _long_type
.globl _fieldify
.globl _char_type
.globl _unqualify
.globl _new_formal
.globl _refill_slab
.globl _uint_type
.globl _get_tnode
.globl _ldouble_type
.globl _new_tnode
.globl _qualify
.globl _formal_type
.globl _unfieldify
.globl ___builtin_ctz
.globl _double_type
.globl _align_of
.globl _ushort_type
.globl _wider
.globl _map_type
.globl _int_type
.globl _void_type
.globl _seed_types
.globl _short_type
.globl _validate
.globl _t_size
.globl _simpatico
.globl _ulong_type
.globl _size_of
.globl _uchar_type
.globl _compat
