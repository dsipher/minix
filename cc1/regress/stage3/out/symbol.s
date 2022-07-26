.data
.align 8
_symbol_slab:
	.int 80
	.int 100
	.fill 16, 1, 0
.local L4
.comm L4, 4, 4
.text

_new_symbol:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq _symbol_slab+8(%rip),%rdx
	movq %rdi,%r12
	movl %esi,%ebx
	testq %rdx,%rdx
	jz L6
L5:
	movq (%rdx),%rax
	movq %rax,_symbol_slab+8(%rip)
	jmp L7
L6:
	movl $_symbol_slab,%edi
	call _refill_slab
	movq %rax,%rdx
L7:
	decl _symbol_slab+20(%rip)
	movl $80,%ecx
	movq %rdx,%rdi
	xorl %eax,%eax
	rep 
	stosb 
	movq %r12,(%rdx)
	movl %ebx,12(%rdx)
	movl L4(%rip),%eax
	incl %eax
	movl %eax,L4(%rip)
	movl %eax,16(%rdx)
	movq _path(%rip),%rax
	movq %rax,24(%rdx)
	movl _line_no(%rip),%eax
	movl %eax,20(%rdx)
	movq %rdx,%rax
L3:
	popq %r12
	popq %rbx
	ret 


_free_symbols:
L12:
	pushq %rbx
	pushq %r12
L13:
	movq %rdi,%rbx
L15:
	movq (%rbx),%r12
	testq %r12,%r12
	jz L14
L16:
	movq 56(%r12),%rax
	movq %rax,(%rbx)
	testl $7,12(%r12)
	jnz L18
L21:
	movq _symbol_slab+8(%rip),%rax
	movq %rax,(%r12)
	movq %r12,_symbol_slab+8(%rip)
	incl _symbol_slab+20(%rip)
	jmp L15
L18:
	leaq 40(%r12),%rdi
	call _free_symbols
	movq _zombies(%rip),%rax
	movq %rax,56(%r12)
	movq %r12,_zombies(%rip)
	incl _nr_zombies(%rip)
	jmp L15
L14:
	popq %r12
	popq %rbx
	ret 


_insert:
L24:
L25:
	movl %esi,8(%rdi)
	movq (%rdi),%rax
	testq %rax,%rax
	jz L32
L31:
	movl (%rax),%eax
	andl $63,%eax
	jmp L33
L32:
	movl $64,%eax
L33:
	leaq _symtab(,%rax,8),%rdx
L27:
	movq (%rdx),%rax
	testq %rax,%rax
	jz L36
L34:
	cmpl 8(%rax),%esi
	jge L36
L35:
	leaq 72(%rax),%rdx
	jmp L27
L36:
	movq %rdx,64(%rdi)
	movq (%rdx),%rax
	leaq 72(%rdi),%rcx
	movq %rax,72(%rdi)
	movq (%rdx),%rax
	testq %rax,%rax
	jz L43
L41:
	movq %rcx,64(%rax)
L43:
	movq %rdi,(%rdx)
	testl %esi,%esi
	jz L26
L44:
	movslq %esi,%rsi
	movq _linkp(,%rsi,8),%rax
	movq %rdi,(%rax)
	addq $56,%rdi
	movq %rdi,_linkp(,%rsi,8)
L26:
	ret 


_redirect:
L47:
	pushq %rbx
	pushq %r12
L48:
	movq %rdi,%r12
	movl %esi,%ebx
	movl %ebx,%ecx
	movl %ebx,%edx
	movl $1024,%esi
	movq (%r12),%rdi
	call _lookup
	testq %rax,%rax
	jnz L49
L50:
	movl $1024,%esi
	movq (%r12),%rdi
	call _new_symbol
	movq %r12,48(%rax)
	movl %ebx,%esi
	movq %rax,%rdi
	call _insert
L49:
	popq %r12
	popq %rbx
	ret 


_lookup:
L53:
L54:
	movl %ecx,%r11d
	cmpl %r11d,%edx
	jnz L57
L56:
	xorl %r10d,%r10d
	jmp L58
L57:
	movq _strun_scopes(%rip),%r10
L58:
	testq %rdi,%rdi
	jz L64
L63:
	movl (%rdi),%eax
	andl $63,%eax
	jmp L65
L64:
	movl $64,%eax
L65:
	movq _symtab(,%rax,8),%rax
L59:
	testq %rax,%rax
	jz L62
L60:
	movq 72(%rax),%r9
	movl 8(%rax),%ecx
	cmpl %ecx,%r11d
	jg L62
L68:
	cmpl %ecx,%edx
	jl L61
L72:
	movl $1,%r8d
	shlq %cl,%r8
	testq %r10,%r8
	jnz L61
L76:
	cmpq (%rax),%rdi
	jnz L61
L80:
	testl $1024,12(%rax)
	jz L84
L82:
	movq 48(%rax),%rax
L84:
	testl %esi,12(%rax)
	jnz L55
L61:
	movq %r9,%rax
	jmp L59
L62:
	xorl %eax,%eax
L55:
	ret 


_lookup_member:
L90:
	pushq %rbx
L91:
	movq 48(%rsi),%r8
L93:
	testq %r8,%r8
	jz L96
L94:
	movq (%r8),%rdx
	leaq 72(%r8),%rcx
	movq 72(%r8),%rax
	cmpq %rdx,%rdi
	jz L100
L99:
	movq %rax,%r8
	jmp L93
L100:
	testq %rax,%rax
	jz L105
L103:
	movq 64(%r8),%rdx
	movq %rdx,64(%rax)
L105:
	movq 72(%r8),%rdx
	movq 64(%r8),%rax
	movq %rdx,(%rax)
	leaq 48(%rsi),%rax
	movq %rax,64(%r8)
	movq 48(%rsi),%rax
	movq %rax,72(%r8)
	movq 48(%rsi),%rax
	testq %rax,%rax
	jz L111
L109:
	movq %rcx,64(%rax)
L111:
	movq %r8,48(%rsi)
	movq %r8,%rbx
	jmp L92
L96:
	pushq %rsi
	pushq $L113
	pushq %rdi
	pushq $4
	call _error
	addq $32,%rsp
L92:
	movq %rbx,%rax
	popq %rbx
	ret 


_named_type:
L114:
L115:
	movl $1,%ecx
	movl _outer_scope(%rip),%edx
	movl $2040,%esi
	call _lookup
	testq %rax,%rax
	jz L118
L120:
	testl $8,12(%rax)
	jz L118
L117:
	movq 32(%rax),%rax
	ret
L118:
	xorl %eax,%eax
L116:
	ret 


_global:
L126:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L127:
	movq %rdi,%r15
	movl %esi,%ebx
	movq %rdx,%r14
	movl %ecx,%r13d
	xorl %ecx,%ecx
	movl $1,%edx
	movl $48,%esi
	movq %r15,%rdi
	call _lookup
	movq %rax,%r12
	testq %r12,%r12
	jz L130
L129:
	testl $32,12(%r12)
	jz L134
L135:
	testl $16,%ebx
	jz L134
L136:
	pushq $L139
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
L134:
	movq %r12,%rdx
	movq %r14,%rsi
	movq 32(%r12),%rdi
	call _compose
	movq %rax,32(%r12)
	cmpl 8(%r12),%r13d
	jle L131
L143:
	movq 72(%r12),%rcx
	testq %rcx,%rcx
	jz L148
L146:
	movq 64(%r12),%rax
	movq %rax,64(%rcx)
L148:
	movq 72(%r12),%rcx
	movq 64(%r12),%rax
	movq %rcx,(%rax)
	movl $1,%esi
	movq %r12,%rdi
	call _insert
	jmp L131
L130:
	movl %ebx,%esi
	movq %r15,%rdi
	call _new_symbol
	movq %rax,%r12
	movq %r14,32(%rax)
	movl %r13d,%esi
	movq %rax,%rdi
	call _insert
L131:
	movq %r12,%rax
L128:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_enter_scope:
L150:
	pushq %rbx
L151:
	movl _current_scope(%rip),%eax
	movl %edi,%ebx
	incl %eax
	movl %eax,_current_scope(%rip)
	cmpl $64,%eax
	jnz L155
L153:
	pushq $L156
	pushq $0
	pushq $1
	call _error
	addq $24,%rsp
L155:
	movslq _current_scope(%rip),%rax
	movq $0,_chains(,%rax,8)
	movslq _current_scope(%rip),%rcx
	leaq _chains(,%rcx,8),%rax
	movq %rax,_linkp(,%rcx,8)
	movl _current_scope(%rip),%eax
	movq _strun_scopes(%rip),%rdx
	movl %eax,%ecx
	movl $1,%esi
	shlq %cl,%rsi
	testl %ebx,%ebx
	jz L158
L157:
	orq %rdx,%rsi
	movq %rsi,_strun_scopes(%rip)
	jmp L152
L158:
	notq %rsi
	andq %rdx,%rsi
	movq %rsi,_strun_scopes(%rip)
	movl %eax,_outer_scope(%rip)
L152:
	popq %rbx
	ret 


_walk_scope:
L160:
	pushq %rbx
	pushq %r12
	pushq %r13
L161:
	movl %esi,%r13d
	movq %rdx,%r12
	movslq %edi,%rdi
	movq _chains(,%rdi,8),%rbx
L163:
	testq %rbx,%rbx
	jz L162
L164:
	testl %r13d,12(%rbx)
	jz L169
L167:
	movq %rbx,%rdi
	call *%r12
L169:
	movq 56(%rbx),%rbx
	jmp L163
L162:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_exit_scope:
L170:
L171:
	movslq _current_scope(%rip),%rax
	movq _chains(,%rax,8),%rdx
L173:
	testq %rdx,%rdx
	jz L176
L177:
	movq 72(%rdx),%rcx
	testq %rcx,%rcx
	jz L182
L180:
	movq 64(%rdx),%rax
	movq %rax,64(%rcx)
L182:
	movq 72(%rdx),%rcx
	movq 64(%rdx),%rax
	movq %rcx,(%rax)
	movq 56(%rdx),%rdx
	jmp L173
L176:
	movslq _current_scope(%rip),%rax
	testq %rdi,%rdi
	jz L184
L183:
	movq (%rdi),%rcx
	movq _linkp(,%rax,8),%rax
	movq %rcx,(%rax)
	movslq _current_scope(%rip),%rax
	movq _chains(,%rax,8),%rax
	movq %rax,(%rdi)
	jmp L185
L184:
	leaq _chains(,%rax,8),%rdi
	call _free_symbols
L185:
	movl _current_scope(%rip),%eax
	cmpl _outer_scope(%rip),%eax
	jnz L188
L189:
	movl _outer_scope(%rip),%ecx
	decl %ecx
	movl %ecx,_outer_scope(%rip)
	movq _strun_scopes(%rip),%rax
	movl $1,%edx
	shlq %cl,%rdx
	testq %rax,%rdx
	jnz L189
L188:
	decl _current_scope(%rip)
L172:
	ret 


_reenter_scope:
L192:
	pushq %rbx
	pushq %r12
L193:
	movq %rdi,%r12
	xorl %edi,%edi
	call _enter_scope
L195:
	movq (%r12),%rdi
	testq %rdi,%rdi
	jz L194
L196:
	movq 56(%rdi),%rbx
	movl _outer_scope(%rip),%esi
	call _insert
	movq %rbx,(%r12)
	jmp L195
L194:
	popq %r12
	popq %rbx
	ret 


_unique:
L198:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L199:
	movq %rdi,%r14
	movl %esi,%ebx
	movq %rcx,%r13
	testq %r14,%r14
	jz L200
L204:
	movl %edx,%ecx
	movl %ebx,%esi
	movq %r14,%rdi
	call _lookup
	movq %rax,%r12
	testq %rax,%rax
	jz L200
L201:
	andl $134219776,%ebx
	cmpl $134217728,%ebx
	jz L211
L217:
	cmpl $2048,%ebx
	jz L213
	jnz L208
L211:
	pushq $L212
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
L213:
	pushq %r12
	pushq %r13
	pushq $L214
	pushq %r14
	pushq $4
	call _error
	addq $40,%rsp
L208:
	pushq %r12
	pushq $L215
	pushq %r14
	pushq $4
	call _error
	addq $32,%rsp
L200:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_absorb:
L220:
	pushq %rbx
	pushq %r12
	pushq %r13
L221:
	movq %rdi,%r13
	movl %edx,%r12d
	movq 40(%rsi),%rbx
L223:
	testq %rbx,%rbx
	jz L222
L224:
	movq (%rbx),%rdi
	testq %rdi,%rdi
	jz L229
L227:
	movq %r13,%rcx
	movl _current_scope(%rip),%edx
	movl $2048,%esi
	call _unique
	movl $33556480,%esi
	movq (%rbx),%rdi
	call _new_symbol
	movq 32(%rbx),%rcx
	movq %rcx,32(%rax)
	movl 48(%rbx),%ecx
	addl %r12d,%ecx
	movl %ecx,48(%rax)
	movl _current_scope(%rip),%esi
	movq %rax,%rdi
	call _insert
L229:
	movq 56(%rbx),%rbx
	jmp L223
L222:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_insert_member:
L230:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L231:
	movq %rdi,%r15
	movq %rsi,-40(%rbp)
	movq %rdx,%r14
	movq %r15,%rcx
	movl _current_scope(%rip),%edx
	movl $2048,%esi
	movq -40(%rbp),%rdi
	call _unique
	movq %r14,%rdi
	call _align_of
	movl %eax,-16(%rbp)
	movl 36(%r15),%ecx
	cmpl %ecx,-16(%rbp)
	movl -16(%rbp),%eax
	cmovgel %eax,%ecx
	movl %ecx,36(%r15)
	movl 12(%r15),%eax
	testl $2,%eax
	jz L237
L236:
	xorl %r13d,%r13d
	jmp L238
L237:
	movl 32(%r15),%r13d
L238:
	movslq %r13d,%r13
	testl $67108864,%eax
	jz L241
L239:
	pushq $L242
	pushq -40(%rbp)
	pushq $4
	call _error
	addq $24,%rsp
L241:
	movq (%r14),%rax
	testq $131072,%rax
	jnz L243
L246:
	testq $8192,%rax
	jz L245
L250:
	movq 16(%r14),%rax
	testl $4194304,12(%rax)
	jz L245
L243:
	orl $4194304,12(%r15)
L245:
	testq $16384,(%r14)
	jz L255
L257:
	cmpl $0,16(%r14)
	jnz L255
L254:
	xorl %r12d,%r12d
	orl $67108864,12(%r15)
	movslq _current_scope(%rip),%rax
	cmpq $0,_chains(,%rax,8)
	jnz L256
L261:
	pushq $L264
	pushq -40(%rbp)
	pushq $4
	call _error
	addq $24,%rsp
	jmp L256
L255:
	xorl %esi,%esi
	movq %r14,%rdi
	call _size_of
	shll $3,%eax
	movl %eax,%r12d
L256:
	movq (%r14),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L266
L265:
	movq $545460846592,%rsi
	andq %rcx,%rsi
	sarq $32,%rsi
	movl %esi,%ebx
	testl %esi,%esi
	jz L268
L271:
	movslq %r12d,%rdi
	movq %r13,%rax
	cqto 
	idivq %rdi
	movq %rax,%rcx
	imulq %rdi,%rcx
	movslq %esi,%rax
	movq %rax,-8(%rbp)
	movq -8(%rbp),%rax
	leaq -1(%r13,%rax),%rax
	cqto 
	idivq %rdi
	imulq %rdi,%rax
	cmpq %rax,%rcx
	jz L270
L268:
	movl %r12d,%eax
	decl %eax
	movslq %eax,%rax
	movslq %r12d,%rcx
	addq %r13,%rax
	cqto 
	idivq %rcx
	imulq %rcx,%rax
	movq %rax,%r13
L270:
	movslq %r12d,%r12
	movq %r13,%rax
	cqto 
	idivq %r12
	movq %r14,%rdi
	call _fieldify
	movq %rax,%r14
	jmp L267
L266:
	movl -16(%rbp),%ecx
	shll $3,%ecx
	movl %ecx,%eax
	decl %eax
	movslq %eax,%rax
	movslq %ecx,%rcx
	addq %r13,%rax
	cqto 
	idivq %rcx
	imulq %rcx,%rax
	movq %rax,%r13
	movl %r12d,%ebx
L267:
	movq $8,-32(%rbp)
	movq %r13,%rax
	cqto 
	idivq -32(%rbp)
	movslq -16(%rbp),%rcx
	movq %rcx,-24(%rbp)
	cqto 
	idivq -24(%rbp)
	movl %eax,%r12d
	imull -16(%rbp),%r12d
	testl $2,12(%r15)
	jz L276
L275:
	movl 32(%r15),%eax
	cmpl %eax,%ebx
	cmovgel %ebx,%eax
	movl %eax,32(%r15)
	jmp L277
L276:
	movslq %ebx,%rbx
	addq %rbx,%r13
	movl %r13d,32(%r15)
L277:
	cmpq $1073741824,%r13
	jle L283
L281:
	pushq %r15
	pushq $L284
	pushq $0
	pushq $1
	call _error
	addq $32,%rsp
L283:
	cmpq $0,-40(%rbp)
	jnz L287
L285:
	testq $8192,(%r14)
	jz L232
L291:
	movq 16(%r14),%rsi
	cmpq $0,(%rsi)
	jnz L232
L288:
	movl %r12d,%edx
	movq %r15,%rdi
	call _absorb
L287:
	movl $2048,%esi
	movq -40(%rbp),%rdi
	call _new_symbol
	movq -40(%rbp),%rcx
	movq %rcx,(%rax)
	movq %r14,32(%rax)
	movl %r12d,48(%rax)
	movl _current_scope(%rip),%esi
	movq %rax,%rdi
	call _insert
L232:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_exit_strun:
L296:
	pushq %rbx
L297:
	movslq _current_scope(%rip),%rax
	movq %rdi,%rbx
	cmpq $0,_chains(,%rax,8)
	jnz L301
L299:
	pushq %rbx
	pushq $L302
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L301:
	leaq 40(%rbx),%rdi
	call _exit_scope
	movq 40(%rbx),%rdx
L303:
	testq %rdx,%rdx
	jz L306
L307:
	leaq 48(%rbx),%rax
	movq %rax,64(%rdx)
	movq 48(%rbx),%rax
	leaq 72(%rdx),%rcx
	movq %rax,72(%rdx)
	movq 48(%rbx),%rax
	testq %rax,%rax
	jz L312
L310:
	movq %rcx,64(%rax)
L312:
	movq %rdx,48(%rbx)
	movq 56(%rdx),%rdx
	jmp L303
L306:
	cmpl $0,32(%rbx)
	jnz L315
L313:
	pushq %rbx
	pushq $L316
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L315:
	movl 32(%rbx),%edx
	movl 36(%rbx),%eax
	movl %eax,%ecx
	shll $3,%ecx
	leal -1(%rdx,%rax,8),%eax
	cltd 
	idivl %ecx
	imull %ecx,%eax
	movl $8,%ecx
	cltd 
	idivl %ecx
	movl %eax,32(%rbx)
	orl $1073741824,12(%rbx)
L298:
	popq %rbx
	ret 


_lookup_label:
L317:
	pushq %rbx
	pushq %r12
L318:
	movq %rdi,%r12
	movl $2,%ecx
	movl $2,%edx
	movl $4096,%esi
	movq %r12,%rdi
	call _lookup
	movq %rax,%rbx
	testq %rax,%rax
	jnz L322
L320:
	movl $4096,%esi
	movq %r12,%rdi
	call _new_symbol
	movq %rax,%rbx
	call _new_block
	movq %rax,48(%rbx)
	movl $2,%esi
	movq %rbx,%rdi
	call _insert
L322:
	movq %rbx,%rax
L319:
	popq %r12
	popq %rbx
	ret 


_check0:
L324:
L325:
	testl $1073741824,12(%rdi)
	jnz L326
L327:
	pushq %rdi
	pushq $L330
	pushq (%rdi)
	pushq $4
	call _error
	addq $32,%rsp
L326:
	ret 


_check_labels:
L331:
L332:
	movl $_check0,%edx
	movl $4096,%esi
	movl $2,%edi
	call _walk_scope
L333:
	ret 


_anon_static:
L334:
	pushq %rbx
	pushq %r12
L335:
	movq %rdi,%r12
	movl %esi,%ebx
	movq _anons(%rip),%rax
L337:
	testq %rax,%rax
	jz L340
L338:
	cmpl 48(%rax),%ebx
	jnz L343
L344:
	cmpq 32(%rax),%r12
	jz L336
L343:
	movq 56(%rax),%rax
	jmp L337
L340:
	movl $16,%esi
	xorl %edi,%edi
	call _new_symbol
	movq %r12,32(%rax)
	movl %ebx,48(%rax)
	movq _anons(%rip),%rcx
	movq %rcx,56(%rax)
	movq %rax,_anons(%rip)
L336:
	popq %r12
	popq %rbx
	ret 


_purge_anons:
L350:
L351:
	movl $_anons,%edi
	call _free_symbols
L352:
	ret 


_implicit:
L353:
	pushq %rbx
	pushq %r12
L354:
	movq %rdi,%r12
	movl $_int_type,%edx
	xorl %esi,%esi
	movl $557056,%edi
	call _get_tnode
	xorl %ecx,%ecx
	movq %rax,%rdx
	movl $32,%esi
	movq %r12,%rdi
	call _global
	movq %rax,%rbx
	testl $8388608,12(%rbx)
	jnz L358
L356:
	pushq $L359
	pushq %r12
	pushq $0
	call _error
	addq $24,%rsp
	orl $8388608,12(%rbx)
L358:
	movq %rbx,%rax
L355:
	popq %r12
	popq %rbx
	ret 


_registerize:
L361:
L362:
	movq (%rdi),%rcx
L364:
	testq %rcx,%rcx
	jz L363
L365:
	movl 12(%rcx),%eax
	testl $256,%eax
	jz L370
L368:
	andl $-257,%eax
	orl $128,%eax
	movl %eax,12(%rcx)
L370:
	movq 56(%rcx),%rcx
	jmp L364
L363:
	ret 


_symbol_to_reg:
L371:
	pushq %rbx
L372:
	movq %rdi,%rbx
	movl 44(%rbx),%eax
	cmpl _reg_generation(%rip),%eax
	jge L376
L374:
	movq %rbx,%rdi
	call _assign_reg
	movl %eax,40(%rbx)
	movl _reg_generation(%rip),%eax
	movl %eax,44(%rbx)
L376:
	movl 40(%rbx),%eax
L373:
	popq %rbx
	ret 


_symbol_offset:
L378:
	pushq %rbx
L379:
	movq %rdi,%rbx
	cmpl $0,48(%rbx)
	jnz L383
L381:
	movq 32(%rbx),%rdi
	call _frame_alloc
	movl %eax,48(%rbx)
L383:
	movl 48(%rbx),%eax
L380:
	popq %rbx
	ret 


_print_global:
L385:
L386:
	cmpl $1,8(%rsi)
	jg L389
L391:
	movq (%rsi),%rcx
	testq %rcx,%rcx
	jz L389
L388:
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L395
	pushq %rdi
	call _fprintf
	addq $32,%rsp
	ret
L389:
	cmpl $0,48(%rsi)
	jnz L398
L396:
	movl _last_asmlab(%rip),%eax
	incl %eax
	movl %eax,_last_asmlab(%rip)
	movl %eax,48(%rsi)
L398:
	movl 48(%rsi),%eax
	pushq %rax
	pushq $L399
	pushq %rdi
	call _fprintf
	addq $24,%rsp
L387:
	ret 


_out_globls:
L400:
	pushq %rbx
	pushq %r12
L401:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L404
L403:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L405
L404:
	movl $10,%edi
	call ___flushbuf
L405:
	xorl %r12d,%r12d
L407:
	movslq %r12d,%rax
	movq _symtab(,%rax,8),%rbx
L410:
	testq %rbx,%rbx
	jz L413
L411:
	movl 12(%rbx),%eax
	testl $32,%eax
	jz L416
L417:
	testl $1610612736,%eax
	jz L416
L414:
	pushq %rbx
	pushq $L421
	call _out
	addq $16,%rsp
L416:
	movq 72(%rbx),%rbx
	jmp L410
L413:
	incl %r12d
	cmpl $64,%r12d
	jl L407
L402:
	popq %r12
	popq %rbx
	ret 

L302:
 .byte 37,84,32,104,97,115,32,110
 .byte 111,32,110,97,109,101,100,32
 .byte 109,101,109,98,101,114,115,0
L139:
 .byte 112,114,101,118,105,111,117,115
 .byte 108,121,32,100,101,99,108,97
 .byte 114,101,100,32,110,111,110,45
 .byte 115,116,97,116,105,99,0
L395:
 .byte 95,37,46,42,115,0
L421:
 .byte 46,103,108,111,98,108,32,37
 .byte 103,10,0
L330:
 .byte 108,97,98,101,108,32,110,101
 .byte 118,101,114,32,100,101,102,105
 .byte 110,101,100,32,40,37,76,41
 .byte 0
L212:
 .byte 100,117,112,108,105,99,97,116
 .byte 101,32,97,114,103,117,109,101
 .byte 110,116,32,105,100,101,110,116
 .byte 105,102,105,101,114,0
L113:
 .byte 110,111,32,115,117,99,104,32
 .byte 109,101,109,98,101,114,32,105
 .byte 110,32,37,84,0
L316:
 .byte 37,84,32,104,97,115,32,122
 .byte 101,114,111,32,115,105,122,101
 .byte 0
L284:
 .byte 37,84,32,101,120,99,101,101
 .byte 100,115,32,109,97,120,105,109
 .byte 117,109,32,115,116,114,117,99
 .byte 116,47,117,110,105,111,110,32
 .byte 115,105,122,101,0
L242:
 .byte 110,111,32,109,101,109,98,101
 .byte 114,115,32,97,108,108,111,119
 .byte 101,100,32,97,102,116,101,114
 .byte 32,102,108,101,120,105,98,108
 .byte 101,32,97,114,114,97,121,0
L264:
 .byte 102,108,101,120,105,98,108,101
 .byte 32,97,114,114,97,121,32,105
 .byte 115,32,102,105,114,115,116,32
 .byte 110,97,109,101,100,32,109,101
 .byte 109,98,101,114,0
L399:
 .byte 76,37,100,0
L214:
 .byte 97,108,114,101,97,100,121,32
 .byte 100,101,99,108,97,114,101,100
 .byte 32,105,110,32,37,84,32,37
 .byte 76,0
L156:
 .byte 115,99,111,112,101,32,110,101
 .byte 115,116,105,110,103,32,116,111
 .byte 111,32,100,101,101,112,0
L359:
 .byte 105,109,112,108,105,99,105,116
 .byte 32,102,117,110,99,116,105,111
 .byte 110,32,100,101,99,108,97,114
 .byte 97,116,105,111,110,0
L215:
 .byte 97,108,114,101,97,100,121,32
 .byte 100,101,99,108,97,114,101,100
 .byte 32,105,110,32,116,104,105,115
 .byte 32,115,99,111,112,101,32,37
 .byte 76,0
.comm _current_scope, 4, 4
.comm _outer_scope, 4, 4
.comm _reg_generation, 4, 4
.local _symtab
.comm _symtab, 520, 8
.local _strun_scopes
.comm _strun_scopes, 8, 8
.local _chains
.comm _chains, 512, 8
.local _linkp
.comm _linkp, 512, 8
.local _zombies
.comm _zombies, 8, 8
.local _nr_zombies
.comm _nr_zombies, 4, 4
.local _anons
.comm _anons, 8, 8

.globl _compose
.globl _symbol_offset
.globl _named_type
.globl _new_block
.globl _implicit
.globl _symbol_to_reg
.globl _enter_scope
.globl _new_symbol
.globl _error
.globl _out_globls
.globl _last_asmlab
.globl _reenter_scope
.globl _insert
.globl _purge_anons
.globl _insert_member
.globl _fieldify
.globl _path
.globl _check_labels
.globl _lookup_member
.globl _refill_slab
.globl _lookup_label
.globl _registerize
.globl _global
.globl _line_no
.globl _get_tnode
.globl _print_global
.globl _reg_generation
.globl _redirect
.globl ___flushbuf
.globl _unique
.globl _out
.globl _free_symbols
.globl _align_of
.globl _int_type
.globl _assign_reg
.globl _walk_scope
.globl _out_f
.globl _lookup
.globl _anon_static
.globl _exit_strun
.globl _current_scope
.globl _outer_scope
.globl _exit_scope
.globl _frame_alloc
.globl _fprintf
.globl _size_of
