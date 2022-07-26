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
	xorl %eax,%eax
L5:
	movslq %eax,%rcx
	shlq $4,%rcx
	cmpl _map(%rcx),%edi
	jz L8
L10:
	incl %eax
	cmpl $24,%eax
	jl L5
L7:
	pushq $L12
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
	jmp L3
L8:
	movq _map+8(%rcx),%rbx
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
L19:
	movq (%rbx),%rax
	testq %rax,%rax
	jz L22
L20:
	leaq 8(%rax),%rbx
	jmp L19
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
L36:
	testq %r13,%r13
	jz L31
L37:
	movq (%r13),%rsi
	movq %rbx,%rdi
	call _new_formal
	movq 8(%r13),%r13
	jmp L36
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
L42:
	movl %edi,%eax
	andl $131071,%eax
	bsfl %eax,%eax
	incl %eax
	shll $2,%eax
	movslq %eax,%rax
	testq $131072,%rdi
	jz L46
L44:
	addq $2,%rax
L46:
	testq $262144,%rdi
	jz L49
L47:
	incq %rax
L49:
	movq $580999813330387073,%rcx
	imulq %rcx,%rax
	movq $549755813888,%rcx
	testq %rdi,%rcx
	jz L52
L50:
	xorq $-1,%rax
	movq $545460846592,%r8
	andq %rdi,%r8
	sarq $32,%r8
	movq $69269232549888,%rcx
	andq %rdi,%rcx
	sarq $40,%rcx
	addq %rcx,%r8
	addq %r8,%rax
L52:
	andl $131071,%edi
	cmpq $16384,%rdi
	jz L56
L68:
	cmpq $8192,%rdi
	jz L58
L69:
	cmpq $32768,%rdi
	jnz L54
L61:
	testq %rsi,%rsi
	jz L54
L62:
	movq (%rsi),%rcx
	xorq 8(%rcx),%rax
	movq 8(%rsi),%rsi
	testq %rsi,%rsi
	jnz L62
	jz L54
L58:
	sarq $5,%rsi
	xorq %rsi,%rax
	jmp L54
L56:
	xorq %rsi,%rax
L54:
	sarq $5,%rdx
	xorq %rdx,%rax
L43:
	ret 


_tnode_find:
L72:
L73:
	movq %rcx,%rax
	andl $127,%eax
	movslq %eax,%rax
	movq _buckets(,%rax,8),%rax
L75:
	testq %rax,%rax
	jz L78
L76:
	cmpq 8(%rax),%rcx
	jnz L77
L86:
	movq (%rax),%r8
	cmpq %r8,%rdi
	jnz L77
L82:
	cmpq 24(%rax),%rdx
	jnz L77
L81:
	testq $32768,%r8
	jz L92
L91:
	movq 16(%rax),%r10
	movq %rsi,%r9
L94:
	testq %r10,%r10
	jz L97
L102:
	testq %r9,%r9
	jz L97
L98:
	movq (%r10),%r8
	cmpq (%r9),%r8
	jnz L97
L95:
	movq 8(%r10),%r10
	movq 8(%r9),%r9
	testq %r10,%r10
	jnz L102
L97:
	testq %r10,%r10
	jnz L77
L109:
	testq %r9,%r9
	jnz L77
	ret
L92:
	cmpq 16(%rax),%rsi
	jz L74
L77:
	movq 32(%rax),%rax
	jmp L75
L78:
	xorl %eax,%eax
L74:
	ret 


_get_tnode:
L121:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L122:
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
	jnz L123
L124:
	movq %r12,%rdx
	movq %r13,%rsi
	movq %r14,%rdi
	call _new_tnode
	movq %rbx,8(%rax)
	andl $127,%ebx
	movslq %ebx,%rbx
	movq _buckets(,%rbx,8),%rcx
	movq %rcx,32(%rax)
	movq %rax,_buckets(,%rbx,8)
L123:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_graft:
L131:
	pushq %rbx
	pushq %r12
	pushq %r13
L132:
	movq %rdi,%r12
	movq %rsi,%rdx
L134:
	movq %r12,%rbx
	testq %r12,%r12
	jz L136
L135:
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
	jnz L138
L140:
	movq 8(%rbx),%rcx
	andl $127,%ecx
	movslq %ecx,%rcx
	movq _buckets(,%rcx,8),%rax
	movq %rax,32(%rbx)
	movq %rbx,_buckets(,%rcx,8)
	movq %rbx,%rdx
	jmp L134
L138:
	testq $32768,(%rbx)
	jz L153
L143:
	movq 16(%rbx),%rsi
L146:
	testq %rsi,%rsi
	jz L153
L147:
	movq 8(%rsi),%rcx
	movq _formal_slab+8(%rip),%rax
	movq %rax,(%rsi)
	movq %rsi,_formal_slab+8(%rip)
	incl _formal_slab+20(%rip)
	movq %rcx,%rsi
	testq %rsi,%rsi
	jnz L147
L153:
	movq _tnode_slab+8(%rip),%rax
	movq %rax,(%rbx)
	movq %rbx,_tnode_slab+8(%rip)
	incl _tnode_slab+20(%rip)
	jmp L134
L136:
	movq %rdx,%rax
L133:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_seed_types:
L158:
	pushq %rbx
	pushq %r12
L159:
	xorl %ebx,%ebx
L162:
	movslq %ebx,%rax
	shlq $4,%rax
	movq _map+8(%rax),%r12
	cmpq $0,8(%r12)
	jnz L167
L165:
	xorl %edx,%edx
	xorl %esi,%esi
	movq (%r12),%rdi
	call _tnode_hash
	movq %rax,8(%r12)
	incl _nr_static_tnodes(%rip)
	movq 8(%r12),%rcx
	andl $127,%ecx
	movslq %ecx,%rcx
	movq _buckets(,%rcx,8),%rax
	movq %rax,32(%r12)
	movq %r12,_buckets(,%rcx,8)
L167:
	incl %ebx
	cmpl $24,%ebx
	jl L162
L160:
	popq %r12
	popq %rbx
	ret 


_qualify:
L171:
	pushq %rbx
	pushq %r12
	pushq %r13
L172:
	movq %rdi,%rbx
	movq %rsi,%r12
	movq %rbx,%rax
L174:
	testq $16384,(%rax)
	jz L176
L175:
	movq 24(%rax),%rax
	jmp L174
L176:
	movq (%rbx),%rax
	andq %r12,%rax
	cmpq %rax,%r12
	jz L177
L179:
	xorl %r13d,%r13d
L181:
	movq (%rbx),%rax
	testq $16384,%rax
	jz L183
L182:
	movslq 16(%rbx),%rsi
	movq %r13,%rdx
	movl $16384,%edi
	call _new_tnode
	movq %rax,%r13
	movq 24(%rbx),%rbx
	jmp L181
L183:
	testq $32768,%rax
	jz L186
L184:
	pushq $L187
	pushq $0
	pushq $4
	call _error
	addq $24,%rsp
L186:
	orq (%rbx),%r12
	movq %r13,%rdx
	movq 16(%rbx),%rsi
	movq %r12,%rdi
	call _new_tnode
	movq 24(%rbx),%rsi
	movq %rax,%rdi
	call _graft
	jmp L173
L177:
	movq %rbx,%rax
L173:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_unqualify:
L189:
L190:
	movq %rdi,%rax
	movq (%rax),%rdi
	testq $393216,%rdi
	jz L191
L192:
	andq $-393217,%rdi
	movq 16(%rax),%rsi
	movq 24(%rax),%rdx
	call _get_tnode
L191:
	ret 


_tnode_compat:
L196:
L197:
	movq (%rdi),%r8
	movq %r8,%rdx
	andl $393216,%edx
	movq (%rsi),%rax
	movq %rax,%rcx
	andl $393216,%ecx
	cmpq %rcx,%rdx
	jnz L262
L201:
	movq %r8,%rdx
	andl $131071,%edx
	movq %rax,%rcx
	andl $131071,%ecx
	cmpq %rcx,%rdx
	jnz L262
L205:
	cmpq $8192,%rdx
	jz L210
L265:
	cmpq $16384,%rdx
	jz L212
L266:
	cmpq $32768,%rdx
	jnz L263
L222:
	movq %r8,%r9
	andl $32768,%r9d
	jz L228
L226:
	testq $1048576,%r8
	jz L228
L227:
	movl $1,%r10d
	jmp L229
L228:
	xorl %r10d,%r10d
L229:
	movq %rax,%rcx
	andl $32768,%ecx
	jz L232
L230:
	testq $1048576,%rax
	jz L232
L231:
	movl $1,%edx
	jmp L233
L232:
	xorl %edx,%edx
L233:
	cmpl %edx,%r10d
	jz L225
L262:
	xorl %eax,%eax
	ret
L225:
	testq %r9,%r9
	jz L238
L242:
	testq $524288,%r8
	jnz L263
L238:
	testq %rcx,%rcx
	jz L237
L246:
	testq $524288,%rax
	jnz L263
L237:
	movq 16(%rdi),%rcx
	movq 16(%rsi),%rax
L251:
	testq %rcx,%rcx
	jz L254
L255:
	testq %rax,%rax
	jz L254
L252:
	movq 8(%rcx),%rcx
	movq 8(%rax),%rax
	testq %rcx,%rcx
	jnz L255
L254:
	cmpq %rax,%rcx
	setz %al
	movzbl %al,%eax
	ret
L212:
	movl 16(%rdi),%ecx
	testl %ecx,%ecx
	jz L263
L216:
	movl 16(%rsi),%eax
	testl %eax,%eax
	jnz L213
L263:
	movl $1,%eax
	ret
L213:
	cmpl %eax,%ecx
	setz %al
	movzbl %al,%eax
	ret
L210:
	movq 16(%rdi),%rax
	cmpq 16(%rsi),%rax
	setz %al
	movzbl %al,%eax
L198:
	ret 


_compat:
L269:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L270:
	movq %rdi,%r12
	movq %rsi,%rbx
L272:
	testq %r12,%r12
	jz L275
L284:
	testq %rbx,%rbx
	jz L275
L280:
	cmpq %rbx,%r12
	jz L275
L276:
	movq %rbx,%rsi
	movq %r12,%rdi
	call _tnode_compat
	testl %eax,%eax
	jz L275
L273:
	movq (%r12),%rax
	testq $32768,%rax
	jz L290
L299:
	testq $524288,%rax
	jnz L290
L291:
	movq (%rbx),%rax
	testq $32768,%rax
	jz L288
L303:
	testq $524288,%rax
	jnz L290
L288:
	movq 16(%r12),%r14
	movq 16(%rbx),%r13
L307:
	testq %r14,%r14
	jz L290
L311:
	testq %r13,%r13
	jz L290
L308:
	movq (%r14),%rdi
	movq (%r13),%rsi
	call _compat
	testl %eax,%eax
	jz L315
L317:
	movq 8(%r14),%r14
	movq 8(%r13),%r13
	jmp L307
L315:
	xorl %eax,%eax
	jmp L271
L290:
	movq 24(%r12),%r12
	movq 24(%rbx),%rbx
	jmp L272
L275:
	cmpq %rbx,%r12
	setz %al
	movzbl %al,%eax
L271:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_compose:
L320:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L321:
	movq %rdx,-8(%rbp)
	xorl %r15d,%r15d
	movq %rdi,%r14
	movq %rsi,%r13
L323:
	testq %r14,%r14
	jz L326
L335:
	testq %r13,%r13
	jz L326
L331:
	cmpq %r13,%r14
	jz L326
L327:
	movq %r13,%rsi
	movq %r14,%rdi
	call _tnode_compat
	testl %eax,%eax
	jz L326
L324:
	movq (%r14),%rdi
	testq $16384,%rdi
	jz L340
L339:
	movl 16(%r14),%esi
	movl 16(%r13),%eax
	cmpl %eax,%esi
	cmovlel %eax,%esi
	movslq %esi,%rsi
	movq %r15,%rdx
	movl $16384,%edi
	call _new_tnode
	movq %rax,%r15
	jmp L341
L340:
	testq $32768,%rdi
	jz L346
L351:
	testq $524288,%rdi
	jz L349
L348:
	movq (%r13),%rdi
	movq %r15,%rdx
	movq 16(%r13),%rsi
	call _new_tnode
	movq %rax,%r15
	jmp L341
L349:
	movq (%r13),%rax
	testq $32768,%rax
	jz L356
L358:
	testq $524288,%rax
	jz L356
L355:
	movq %r15,%rdx
	movq 16(%r14),%rsi
	call _new_tnode
	movq %rax,%r15
	jmp L341
L356:
	movq %r15,%rdx
	xorl %esi,%esi
	call _new_tnode
	movq %rax,%r15
	movq 16(%r14),%r12
	movq 16(%r13),%rbx
L362:
	testq %r12,%r12
	jz L341
L366:
	testq %rbx,%rbx
	jz L341
L363:
	movq (%r12),%rdi
	movq -8(%rbp),%rdx
	movq (%rbx),%rsi
	call _compose
	movq %rax,%rsi
	movq %r15,%rdi
	call _new_formal
	movq 8(%r12),%r12
	movq 8(%rbx),%rbx
	jmp L362
L346:
	movq %r15,%rdx
	movq 16(%r14),%rsi
	call _new_tnode
	movq %rax,%r15
L341:
	movq 24(%r14),%r14
	movq 24(%r13),%r13
	jmp L323
L326:
	cmpq %r13,%r14
	jz L372
L370:
	pushq -8(%rbp)
	pushq $L373
	movq -8(%rbp),%rax
	pushq (%rax)
	pushq $4
	call _error
	addq $32,%rsp
L372:
	movq %r14,%rsi
	movq %r15,%rdi
	call _graft
L322:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_formal_type:
L375:
L376:
	movq %rdi,%rax
	movq (%rax),%rcx
	testq $16384,%rcx
	jz L379
L378:
	movq 24(%rax),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	ret
L379:
	testq $32768,%rcx
	jz L377
L381:
	movq %rax,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
L377:
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
L404:
	testq %r12,%r12
	jz L406
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
	movslq %eax,%rax
	imulq %rax,%r13
	jmp L408
L416:
	movq 16(%r12),%rax
	testl $1073741824,12(%rax)
	jz L418
L417:
	movslq 32(%rax),%rax
	imulq %rax,%r13
	jmp L408
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
L411:
	movslq %eax,%rax
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
	jmp L404
L406:
	movl %r13d,%eax
L403:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_align_of:
L442:
L443:
	movq %rdi,%rcx
L445:
	movq (%rcx),%rdi
	testq $16384,%rdi
	jz L447
L446:
	movq 24(%rcx),%rcx
	jmp L445
L447:
	movq %rdi,%rax
	andl $131071,%eax
	cmpq $8192,%rax
	jz L451
L461:
	cmpq $32768,%rax
	jz L457
L462:
	cmpq $1,%rax
	jz L457
L463:
	call _t_size
	ret
L451:
	movq 16(%rcx),%rax
	testl $1073741824,12(%rax)
	jnz L452
L457:
	movl $1,%eax
	ret
L452:
	movl 36(%rax),%eax
L444:
	ret 


_simpatico:
L465:
	pushq %rbx
	pushq %r12
L466:
	movq %rsi,%r12
	movq (%rdi),%rdi
	testq $73726,%rdi
	jz L472
L482:
	movq (%r12),%rax
	testq $73726,%rax
	jz L472
L478:
	testq $7168,%rdi
	setz %cl
	movzbl %cl,%ecx
	testq $7168,%rax
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L472
L474:
	andl $131071,%edi
	call _t_size
	movl %eax,%ebx
	movq (%r12),%rdi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%ebx
	jnz L472
L471:
	movl $1,%eax
	jmp L467
L472:
	xorl %eax,%eax
L467:
	popq %r12
	popq %rbx
	ret 


_narrower:
L488:
	pushq %rbx
	pushq %r12
L489:
	movq %rsi,%r12
	movq (%rdi),%rdi
	testq $73726,%rdi
	jz L495
L505:
	movq (%r12),%rax
	testq $73726,%rax
	jz L495
L501:
	testq $7168,%rdi
	setz %cl
	movzbl %cl,%ecx
	testq $7168,%rax
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L495
L497:
	andl $131071,%edi
	call _t_size
	movl %eax,%ebx
	movq (%r12),%rdi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%ebx
	jge L495
L494:
	movl $1,%eax
	jmp L490
L495:
	xorl %eax,%eax
L490:
	popq %r12
	popq %rbx
	ret 


_wider:
L511:
	pushq %rbx
	pushq %r12
L512:
	movq %rsi,%r12
	movq (%rdi),%rdi
	testq $73726,%rdi
	jz L518
L528:
	movq (%r12),%rax
	testq $73726,%rax
	jz L518
L524:
	testq $7168,%rdi
	setz %cl
	movzbl %cl,%ecx
	testq $7168,%rax
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L518
L520:
	andl $131071,%edi
	call _t_size
	movl %eax,%ebx
	movq (%r12),%rdi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%ebx
	jle L518
L517:
	movl $1,%eax
	jmp L513
L518:
	xorl %eax,%eax
L513:
	popq %r12
	popq %rbx
	ret 


_fieldify:
L534:
L535:
	movq (%rdi),%rcx
	movq %rcx,%rax
	andl $131071,%eax
	andl $393216,%ecx
	orq %rax,%rcx
	movq $549755813888,%rax
	orq %rcx,%rax
	movslq %esi,%rsi
	shlq $32,%rsi
	orq %rax,%rsi
	movslq %edx,%rdi
	shlq $40,%rdi
	orq %rsi,%rdi
	xorl %edx,%edx
	xorl %esi,%esi
	call _get_tnode
L536:
	ret 


_unfieldify:
L538:
L539:
	movq %rdi,%rax
	movq (%rax),%rdi
	movq $549755813888,%rcx
	testq %rdi,%rcx
	jz L540
L541:
	movq %rdi,%rax
	andl $131071,%eax
	andl $393216,%edi
	orq %rax,%rdi
	xorl %edx,%edx
	xorl %esi,%esi
	call _get_tnode
L540:
	ret 


_validate:
L545:
	pushq %rbx
	pushq %r12
	pushq %r13
L546:
	movq %rdi,%r13
	movq %rsi,%r12
	testq $1,(%r13)
	jz L555
L551:
	testl %edx,%edx
	jnz L555
L548:
	pushq $L423
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L555:
	testq %r13,%r13
	jz L547
L556:
	movq 24(%r13),%rbx
	testq $16384,(%r13)
	jz L561
L559:
	testq $16384,(%rbx)
	jz L564
L565:
	cmpl $0,16(%rbx)
	jnz L564
L562:
	pushq $L569
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L564:
	testq $32768,(%rbx)
	jz L572
L570:
	pushq $L573
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L572:
	testq $1,(%rbx)
	jz L576
L574:
	pushq $L577
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L576:
	testq $8192,(%rbx)
	jz L561
L578:
	movq 16(%rbx),%rax
	testl $1073741824,12(%rax)
	jnz L583
L581:
	pushq %rax
	pushq $L584
	pushq %r12
	pushq $4
	call _error
	addq $32,%rsp
L583:
	movq 16(%rbx),%rcx
	movl 12(%rcx),%eax
	testl $1,%eax
	jz L561
L588:
	testl $67108864,%eax
	jz L561
L585:
	pushq %rcx
	pushq $L592
	pushq %r12
	pushq $4
	call _error
	addq $32,%rsp
L561:
	testq $32768,(%r13)
	jz L595
L596:
	movq (%rbx),%rax
	movq %rax,%rcx
	andl $16384,%ecx
	jnz L593
L600:
	testq $32768,%rax
	jz L595
L593:
	testq %rcx,%rcx
	movl $L606,%eax
	movl $L605,%ecx
	cmovzq %rax,%rcx
	pushq %rcx
	pushq $L604
	pushq %r12
	pushq $4
	call _error
	addq $32,%rsp
L595:
	movq %rbx,%r13
	jmp L555
L547:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L573:
 .byte 97,114,114,97,121,32,111,102
 .byte 32,102,117,110,99,116,105,111
 .byte 110,0
L420:
 .byte 37,84,32,105,115,32,105,110
 .byte 99,111,109,112,108,101,116,101
 .byte 0
L606:
 .byte 102,117,110,99,116,105,111,110
 .byte 115,0
L187:
 .byte 99,97,110,39,116,32,113,117
 .byte 97,108,105,102,121,32,102,117
 .byte 110,99,116,105,111,110,32,116
 .byte 121,112,101,115,0
L605:
 .byte 97,114,114,97,121,115,0
L423:
 .byte 105,108,108,101,103,97,108,32
 .byte 117,115,101,32,111,102,32,118
 .byte 111,105,100,32,116,121,112,101
 .byte 0
L584:
 .byte 97,114,114,97,121,32,111,102
 .byte 32,105,110,99,111,109,112,108
 .byte 101,116,101,32,37,84,0
L373:
 .byte 99,111,110,102,108,105,99,116
 .byte 105,110,103,32,116,121,112,101
 .byte 115,32,37,76,0
L430:
 .byte 116,121,112,101,32,116,111,111
 .byte 32,108,97,114,103,101,0
L592:
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
L577:
 .byte 97,114,114,97,121,32,111,102
 .byte 32,118,111,105,100,0
L425:
 .byte 105,108,108,101,103,97,108,32
 .byte 117,115,101,32,111,102,32,102
 .byte 117,110,99,116,105,111,110,32
 .byte 116,121,112,101,0
L569:
 .byte 105,110,118,97,108,105,100,32
 .byte 97,114,114,97,121,32,115,112
 .byte 101,99,105,102,105,99,97,116
 .byte 105,111,110,0
L604:
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
