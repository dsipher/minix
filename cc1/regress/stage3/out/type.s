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
L67:
	cmpq $8192,%rdi
	jz L58
L68:
	cmpq $32768,%rdi
	jnz L54
L61:
	testq %rsi,%rsi
	jz L54
L62:
	movq (%rsi),%rcx
	xorq 8(%rcx),%rax
	movq 8(%rsi),%rsi
	jmp L61
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
L71:
L72:
	movq %rcx,%rax
	andl $127,%eax
	movslq %eax,%rax
	movq _buckets(,%rax,8),%rax
L74:
	testq %rax,%rax
	jz L77
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
	jmp L74
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
	movslq %ebx,%rbx
	movq _buckets(,%rbx,8),%rcx
	movq %rcx,32(%rax)
	movq %rax,_buckets(,%rbx,8)
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
	movq 8(%rbx),%rcx
	andl $127,%ecx
	movslq %ecx,%rcx
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
L144:
	testq %rsi,%rsi
	jz L151
L145:
	movq 8(%rsi),%rcx
	movq _formal_slab+8(%rip),%rax
	movq %rax,(%rsi)
	movq %rsi,_formal_slab+8(%rip)
	incl _formal_slab+20(%rip)
	movq %rcx,%rsi
	jmp L144
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
	xorl %ebx,%ebx
L159:
	movslq %ebx,%rax
	shlq $4,%rax
	movq _map+8(%rax),%r12
	cmpq $0,8(%r12)
	jnz L164
L162:
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
L164:
	incl %ebx
	cmpl $24,%ebx
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
L171:
	testq $16384,(%rax)
	jz L173
L172:
	movq 24(%rax),%rax
	jmp L171
L173:
	movq (%rbx),%rax
	andq %r12,%rax
	cmpq %rax,%r12
	jz L174
L176:
	xorl %r13d,%r13d
L178:
	movq (%rbx),%rax
	testq $16384,%rax
	jz L180
L179:
	movslq 16(%rbx),%rsi
	movq %r13,%rdx
	movl $16384,%edi
	call _new_tnode
	movq %rax,%r13
	movq 24(%rbx),%rbx
	jmp L178
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
L248:
	testq %rcx,%rcx
	jz L251
L252:
	testq %rax,%rax
	jz L251
L249:
	movq 8(%rcx),%rcx
	movq 8(%rax),%rax
	jmp L248
L251:
	cmpq %rax,%rcx
	setz %al
	movzbl %al,%eax
	ret
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
	setz %al
	movzbl %al,%eax
	ret
L207:
	movq 16(%rdi),%rax
	cmpq 16(%rsi),%rax
	setz %al
	movzbl %al,%eax
L195:
	ret 


_compat:
L265:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L266:
	movq %rdi,%r12
	movq %rsi,%rbx
L268:
	testq %r12,%r12
	jz L271
L280:
	testq %rbx,%rbx
	jz L271
L276:
	cmpq %rbx,%r12
	jz L271
L272:
	movq %rbx,%rsi
	movq %r12,%rdi
	call _tnode_compat
	testl %eax,%eax
	jz L271
L269:
	movq (%r12),%rax
	testq $32768,%rax
	jz L286
L295:
	testq $524288,%rax
	jnz L286
L287:
	movq (%rbx),%rax
	testq $32768,%rax
	jz L284
L299:
	testq $524288,%rax
	jnz L286
L284:
	movq 16(%r12),%r14
	movq 16(%rbx),%r13
L303:
	testq %r14,%r14
	jz L286
L307:
	testq %r13,%r13
	jz L286
L304:
	movq (%r14),%rdi
	movq (%r13),%rsi
	call _compat
	testl %eax,%eax
	jz L311
L313:
	movq 8(%r14),%r14
	movq 8(%r13),%r13
	jmp L303
L311:
	xorl %eax,%eax
	jmp L267
L286:
	movq 24(%r12),%r12
	movq 24(%rbx),%rbx
	jmp L268
L271:
	cmpq %rbx,%r12
	setz %al
	movzbl %al,%eax
L267:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_compose:
L316:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L317:
	movq %rdx,-8(%rbp)
	xorl %r15d,%r15d
	movq %rdi,%r14
	movq %rsi,%r13
L319:
	testq %r14,%r14
	jz L322
L331:
	testq %r13,%r13
	jz L322
L327:
	cmpq %r13,%r14
	jz L322
L323:
	movq %r13,%rsi
	movq %r14,%rdi
	call _tnode_compat
	testl %eax,%eax
	jz L322
L320:
	movq (%r14),%rdi
	testq $16384,%rdi
	jz L336
L335:
	movl 16(%r14),%esi
	movl 16(%r13),%eax
	cmpl %eax,%esi
	cmovlel %eax,%esi
	movslq %esi,%rsi
	movq %r15,%rdx
	movl $16384,%edi
	call _new_tnode
	movq %rax,%r15
	jmp L337
L336:
	testq $32768,%rdi
	jz L342
L347:
	testq $524288,%rdi
	jz L345
L344:
	movq (%r13),%rdi
	movq %r15,%rdx
	movq 16(%r13),%rsi
	call _new_tnode
	movq %rax,%r15
	jmp L337
L345:
	movq (%r13),%rax
	testq $32768,%rax
	jz L352
L354:
	testq $524288,%rax
	jz L352
L351:
	movq %r15,%rdx
	movq 16(%r14),%rsi
	call _new_tnode
	movq %rax,%r15
	jmp L337
L352:
	movq %r15,%rdx
	xorl %esi,%esi
	call _new_tnode
	movq %rax,%r15
	movq 16(%r14),%r12
	movq 16(%r13),%rbx
L358:
	testq %r12,%r12
	jz L337
L362:
	testq %rbx,%rbx
	jz L337
L359:
	movq (%r12),%rdi
	movq -8(%rbp),%rdx
	movq (%rbx),%rsi
	call _compose
	movq %rax,%rsi
	movq %r15,%rdi
	call _new_formal
	movq 8(%r12),%r12
	movq 8(%rbx),%rbx
	jmp L358
L342:
	movq %r15,%rdx
	movq 16(%r14),%rsi
	call _new_tnode
	movq %rax,%r15
L337:
	movq 24(%r14),%r14
	movq 24(%r13),%r13
	jmp L319
L322:
	cmpq %r13,%r14
	jz L368
L366:
	pushq -8(%rbp)
	pushq $L369
	movq -8(%rbp),%rax
	pushq (%rax)
	pushq $4
	call _error
	addq $32,%rsp
L368:
	movq %r14,%rsi
	movq %r15,%rdi
	call _graft
L318:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_formal_type:
L371:
L372:
	movq %rdi,%rax
	movq (%rax),%rcx
	testq $16384,%rcx
	jz L375
L374:
	movq 24(%rax),%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
	ret
L375:
	testq $32768,%rcx
	jz L373
L377:
	movq %rax,%rdx
	xorl %esi,%esi
	movl $65536,%edi
	call _get_tnode
L373:
	ret 


_t_size:
L381:
L382:
	testq $48,%rdi
	jnz L384
L386:
	testq $1216,%rdi
	jnz L388
L390:
	testq $72448,%rdi
	movl $8,%ecx
	movl $1,%eax
	cmovnzl %ecx,%eax
	ret
L388:
	movl $4,%eax
	ret
L384:
	movl $2,%eax
L383:
	ret 


_size_of:
L397:
	pushq %rbx
	pushq %r12
	pushq %r13
L398:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl $1,%r13d
L400:
	testq %r12,%r12
	jz L402
L401:
	movq (%r12),%rax
	andl $131071,%eax
	cmpq $16384,%rax
	jz L406
L433:
	cmpq $8192,%rax
	jz L412
L434:
	cmpq $1,%rax
	jz L418
L435:
	cmpq $32768,%rax
	jz L420
	jnz L403
L418:
	pushq $L419
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L420:
	pushq $L421
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L403:
	movq (%r12),%rdi
	call _t_size
	movslq %eax,%rax
	imulq %rax,%r13
	jmp L404
L412:
	movq 16(%r12),%rax
	testl $1073741824,12(%rax)
	jz L414
L413:
	movslq 32(%rax),%rax
	imulq %rax,%r13
	jmp L404
L414:
	pushq %rax
	pushq $L416
	pushq %rbx
	pushq $4
	call _error
	addq $32,%rsp
	jmp L404
L406:
	movl 16(%r12),%eax
	cmpl $0,%eax
	jle L408
L407:
	movslq %eax,%rax
	imulq %rax,%r13
	jmp L404
L408:
	pushq $L410
	pushq %rbx
	pushq $4
	call _error
	addq $24,%rsp
L404:
	cmpq $134217728,%r13
	jle L425
L423:
	pushq $L426
	pushq %rbx
	pushq $1
	call _error
	addq $24,%rsp
L425:
	testq $65536,(%r12)
	jnz L402
L429:
	movq 24(%r12),%r12
	jmp L400
L402:
	movl %r13d,%eax
L399:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_align_of:
L438:
L439:
	movq %rdi,%rcx
L441:
	movq (%rcx),%rdi
	testq $16384,%rdi
	jz L443
L442:
	movq 24(%rcx),%rcx
	jmp L441
L443:
	movq %rdi,%rax
	andl $131071,%eax
	cmpq $8192,%rax
	jz L447
L457:
	cmpq $32768,%rax
	jz L453
L458:
	cmpq $1,%rax
	jz L453
L459:
	call _t_size
	ret
L447:
	movq 16(%rcx),%rax
	testl $1073741824,12(%rax)
	jnz L448
L453:
	movl $1,%eax
	ret
L448:
	movl 36(%rax),%eax
L440:
	ret 


_simpatico:
L461:
	pushq %rbx
	pushq %r12
L462:
	movq %rsi,%r12
	movq (%rdi),%rdi
	testq $73726,%rdi
	jz L468
L478:
	movq (%r12),%rax
	testq $73726,%rax
	jz L468
L474:
	testq $7168,%rdi
	setz %cl
	movzbl %cl,%ecx
	testq $7168,%rax
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L468
L470:
	andl $131071,%edi
	call _t_size
	movl %eax,%ebx
	movq (%r12),%rdi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%ebx
	jnz L468
L467:
	movl $1,%eax
	jmp L463
L468:
	xorl %eax,%eax
L463:
	popq %r12
	popq %rbx
	ret 


_narrower:
L484:
	pushq %rbx
	pushq %r12
L485:
	movq %rsi,%r12
	movq (%rdi),%rdi
	testq $73726,%rdi
	jz L491
L501:
	movq (%r12),%rax
	testq $73726,%rax
	jz L491
L497:
	testq $7168,%rdi
	setz %cl
	movzbl %cl,%ecx
	testq $7168,%rax
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L491
L493:
	andl $131071,%edi
	call _t_size
	movl %eax,%ebx
	movq (%r12),%rdi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%ebx
	jge L491
L490:
	movl $1,%eax
	jmp L486
L491:
	xorl %eax,%eax
L486:
	popq %r12
	popq %rbx
	ret 


_wider:
L507:
	pushq %rbx
	pushq %r12
L508:
	movq %rsi,%r12
	movq (%rdi),%rdi
	testq $73726,%rdi
	jz L514
L524:
	movq (%r12),%rax
	testq $73726,%rax
	jz L514
L520:
	testq $7168,%rdi
	setz %cl
	movzbl %cl,%ecx
	testq $7168,%rax
	setz %al
	movzbl %al,%eax
	cmpl %eax,%ecx
	jnz L514
L516:
	andl $131071,%edi
	call _t_size
	movl %eax,%ebx
	movq (%r12),%rdi
	andl $131071,%edi
	call _t_size
	cmpl %eax,%ebx
	jle L514
L513:
	movl $1,%eax
	jmp L509
L514:
	xorl %eax,%eax
L509:
	popq %r12
	popq %rbx
	ret 


_fieldify:
L530:
L531:
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
L532:
	ret 


_unfieldify:
L534:
L535:
	movq %rdi,%rax
	movq (%rax),%rdi
	movq $549755813888,%rcx
	testq %rdi,%rcx
	jz L536
L537:
	movq %rdi,%rax
	andl $131071,%eax
	andl $393216,%edi
	orq %rax,%rdi
	xorl %edx,%edx
	xorl %esi,%esi
	call _get_tnode
L536:
	ret 


_validate:
L541:
	pushq %rbx
	pushq %r12
	pushq %r13
L542:
	movq %rdi,%r13
	movq %rsi,%r12
	testq $1,(%r13)
	jz L551
L547:
	testl %edx,%edx
	jnz L551
L544:
	pushq $L419
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L551:
	testq %r13,%r13
	jz L543
L552:
	movq 24(%r13),%rbx
	testq $16384,(%r13)
	jz L557
L555:
	testq $16384,(%rbx)
	jz L560
L561:
	cmpl $0,16(%rbx)
	jnz L560
L558:
	pushq $L565
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L560:
	testq $32768,(%rbx)
	jz L568
L566:
	pushq $L569
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L568:
	testq $1,(%rbx)
	jz L572
L570:
	pushq $L573
	pushq %r12
	pushq $4
	call _error
	addq $24,%rsp
L572:
	testq $8192,(%rbx)
	jz L557
L574:
	movq 16(%rbx),%rax
	testl $1073741824,12(%rax)
	jnz L579
L577:
	pushq %rax
	pushq $L580
	pushq %r12
	pushq $4
	call _error
	addq $32,%rsp
L579:
	movq 16(%rbx),%rcx
	movl 12(%rcx),%eax
	testl $1,%eax
	jz L557
L584:
	testl $67108864,%eax
	jz L557
L581:
	pushq %rcx
	pushq $L588
	pushq %r12
	pushq $4
	call _error
	addq $32,%rsp
L557:
	testq $32768,(%r13)
	jz L591
L592:
	movq (%rbx),%rax
	movq %rax,%rcx
	andl $16384,%ecx
	jnz L589
L596:
	testq $32768,%rax
	jz L591
L589:
	testq %rcx,%rcx
	movl $L602,%eax
	movl $L601,%ecx
	cmovzq %rax,%rcx
	pushq %rcx
	pushq $L600
	pushq %r12
	pushq $4
	call _error
	addq $32,%rsp
L591:
	movq %rbx,%r13
	jmp L551
L543:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L569:
 .byte 97,114,114,97,121,32,111,102
 .byte 32,102,117,110,99,116,105,111
 .byte 110,0
L416:
 .byte 37,84,32,105,115,32,105,110
 .byte 99,111,109,112,108,101,116,101
 .byte 0
L602:
 .byte 102,117,110,99,116,105,111,110
 .byte 115,0
L184:
 .byte 99,97,110,39,116,32,113,117
 .byte 97,108,105,102,121,32,102,117
 .byte 110,99,116,105,111,110,32,116
 .byte 121,112,101,115,0
L601:
 .byte 97,114,114,97,121,115,0
L419:
 .byte 105,108,108,101,103,97,108,32
 .byte 117,115,101,32,111,102,32,118
 .byte 111,105,100,32,116,121,112,101
 .byte 0
L580:
 .byte 97,114,114,97,121,32,111,102
 .byte 32,105,110,99,111,109,112,108
 .byte 101,116,101,32,37,84,0
L369:
 .byte 99,111,110,102,108,105,99,116
 .byte 105,110,103,32,116,121,112,101
 .byte 115,32,37,76,0
L426:
 .byte 116,121,112,101,32,116,111,111
 .byte 32,108,97,114,103,101,0
L588:
 .byte 97,114,114,97,121,32,111,102
 .byte 32,102,108,101,120,105,98,108
 .byte 101,32,37,84,0
L410:
 .byte 105,110,99,111,109,112,108,101
 .byte 116,101,32,97,114,114,97,121
 .byte 32,116,121,112,101,0
L12:
 .byte 105,110,118,97,108,105,100,32
 .byte 116,121,112,101,32,115,112,101
 .byte 99,105,102,105,99,97,116,105
 .byte 111,110,0
L573:
 .byte 97,114,114,97,121,32,111,102
 .byte 32,118,111,105,100,0
L421:
 .byte 105,108,108,101,103,97,108,32
 .byte 117,115,101,32,111,102,32,102
 .byte 117,110,99,116,105,111,110,32
 .byte 116,121,112,101,0
L565:
 .byte 105,110,118,97,108,105,100,32
 .byte 97,114,114,97,121,32,115,112
 .byte 101,99,105,102,105,99,97,116
 .byte 105,111,110,0
L600:
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
