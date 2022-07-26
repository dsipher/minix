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
	testq %r8,%r8
	jnz L94
	jz L96
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
L115:
L116:
	movl $1,%ecx
	movl _outer_scope(%rip),%edx
	movl $2040,%esi
	call _lookup
	testq %rax,%rax
	jz L119
L121:
	testl $8,12(%rax)
	jz L119
L118:
	movq 32(%rax),%rax
	ret
L119:
	xorl %eax,%eax
L117:
	ret 


_global:
L127:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L128:
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
	jz L131
L130:
	testl $32,12(%r12)
	jz L135
L136:
	testl $16,%ebx
	jz L135
L137:
	pushq $L140
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
L135:
	movq %r12,%rdx
	movq %r14,%rsi
	movq 32(%r12),%rdi
	call _compose
	movq %rax,32(%r12)
	cmpl 8(%r12),%r13d
	jle L132
L144:
	movq 72(%r12),%rcx
	testq %rcx,%rcx
	jz L149
L147:
	movq 64(%r12),%rax
	movq %rax,64(%rcx)
L149:
	movq 72(%r12),%rcx
	movq 64(%r12),%rax
	movq %rcx,(%rax)
	movl $1,%esi
	movq %r12,%rdi
	call _insert
	jmp L132
L131:
	movl %ebx,%esi
	movq %r15,%rdi
	call _new_symbol
	movq %rax,%r12
	movq %r14,32(%rax)
	movl %r13d,%esi
	movq %rax,%rdi
	call _insert
L132:
	movq %r12,%rax
L129:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_enter_scope:
L151:
	pushq %rbx
L152:
	movl _current_scope(%rip),%eax
	movl %edi,%ebx
	incl %eax
	movl %eax,_current_scope(%rip)
	cmpl $64,%eax
	jnz L156
L154:
	pushq $L157
	pushq $0
	pushq $1
	call _error
	addq $24,%rsp
L156:
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
	jz L159
L158:
	orq %rdx,%rsi
	movq %rsi,_strun_scopes(%rip)
	jmp L153
L159:
	notq %rsi
	andq %rdx,%rsi
	movq %rsi,_strun_scopes(%rip)
	movl %eax,_outer_scope(%rip)
L153:
	popq %rbx
	ret 


_walk_scope:
L161:
	pushq %rbx
	pushq %r12
	pushq %r13
L162:
	movl %esi,%r13d
	movq %rdx,%r12
	movslq %edi,%rdi
	movq _chains(,%rdi,8),%rbx
L164:
	testq %rbx,%rbx
	jz L163
L165:
	testl %r13d,12(%rbx)
	jz L170
L168:
	movq %rbx,%rdi
	call *%r12
L170:
	movq 56(%rbx),%rbx
	jmp L164
L163:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_exit_scope:
L171:
L172:
	movslq _current_scope(%rip),%rax
	movq _chains(,%rax,8),%rdx
L174:
	testq %rdx,%rdx
	jz L177
L178:
	movq 72(%rdx),%rcx
	testq %rcx,%rcx
	jz L183
L181:
	movq 64(%rdx),%rax
	movq %rax,64(%rcx)
L183:
	movq 72(%rdx),%rcx
	movq 64(%rdx),%rax
	movq %rcx,(%rax)
	movq 56(%rdx),%rdx
	testq %rdx,%rdx
	jnz L178
L177:
	movslq _current_scope(%rip),%rax
	testq %rdi,%rdi
	jz L185
L184:
	movq (%rdi),%rcx
	movq _linkp(,%rax,8),%rax
	movq %rcx,(%rax)
	movslq _current_scope(%rip),%rax
	movq _chains(,%rax,8),%rax
	movq %rax,(%rdi)
	jmp L186
L185:
	leaq _chains(,%rax,8),%rdi
	call _free_symbols
L186:
	movl _current_scope(%rip),%eax
	cmpl _outer_scope(%rip),%eax
	jnz L189
L190:
	movl _outer_scope(%rip),%ecx
	decl %ecx
	movl %ecx,_outer_scope(%rip)
	movq _strun_scopes(%rip),%rax
	movl $1,%edx
	shlq %cl,%rdx
	testq %rax,%rdx
	jnz L190
L189:
	decl _current_scope(%rip)
L173:
	ret 


_reenter_scope:
L194:
	pushq %rbx
	pushq %r12
L195:
	movq %rdi,%r12
	xorl %edi,%edi
	call _enter_scope
L197:
	movq (%r12),%rdi
	testq %rdi,%rdi
	jz L196
L198:
	movq 56(%rdi),%rbx
	movl _outer_scope(%rip),%esi
	call _insert
	movq %rbx,(%r12)
	jmp L197
L196:
	popq %r12
	popq %rbx
	ret 


_unique:
L200:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L201:
	movq %rdi,%r14
	movl %esi,%ebx
	movq %rcx,%r13
	testq %r14,%r14
	jz L202
L206:
	movl %edx,%ecx
	movl %ebx,%esi
	movq %r14,%rdi
	call _lookup
	movq %rax,%r12
	testq %rax,%rax
	jz L202
L203:
	andl $134219776,%ebx
	cmpl $134217728,%ebx
	jz L213
L219:
	cmpl $2048,%ebx
	jz L215
	jnz L210
L213:
	pushq $L214
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
L215:
	pushq %r12
	pushq %r13
	pushq $L216
	pushq %r14
	pushq $4
	call _error
	addq $40,%rsp
L210:
	pushq %r12
	pushq $L217
	pushq %r14
	pushq $4
	call _error
	addq $32,%rsp
L202:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_absorb:
L222:
	pushq %rbx
	pushq %r12
	pushq %r13
L223:
	movq %rdi,%r13
	movl %edx,%r12d
	movq 40(%rsi),%rbx
L225:
	testq %rbx,%rbx
	jz L224
L226:
	movq (%rbx),%rdi
	testq %rdi,%rdi
	jz L231
L229:
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
L231:
	movq 56(%rbx),%rbx
	jmp L225
L224:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_insert_member:
L232:
	pushq %rbp
	movq %rsp,%rbp
	subq $40,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L233:
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
	jz L239
L238:
	xorl %ebx,%ebx
	jmp L240
L239:
	movl 32(%r15),%ebx
L240:
	movslq %ebx,%rbx
	testl $67108864,%eax
	jz L243
L241:
	pushq $L244
	pushq -40(%rbp)
	pushq $4
	call _error
	addq $24,%rsp
L243:
	movq (%r14),%rax
	testq $131072,%rax
	jnz L245
L248:
	testq $8192,%rax
	jz L247
L252:
	movq 16(%r14),%rax
	testl $4194304,12(%rax)
	jz L247
L245:
	orl $4194304,12(%r15)
L247:
	testq $16384,(%r14)
	jz L257
L259:
	cmpl $0,16(%r14)
	jnz L257
L256:
	xorl %r13d,%r13d
	orl $67108864,12(%r15)
	movslq _current_scope(%rip),%rax
	cmpq $0,_chains(,%rax,8)
	jnz L258
L263:
	pushq $L266
	pushq -40(%rbp)
	pushq $4
	call _error
	addq $24,%rsp
	jmp L258
L257:
	xorl %esi,%esi
	movq %r14,%rdi
	call _size_of
	shll $3,%eax
	movl %eax,%r13d
L258:
	movq (%r14),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L268
L267:
	movq $545460846592,%rsi
	andq %rcx,%rsi
	sarq $32,%rsi
	movl %esi,%r12d
	testl %esi,%esi
	jz L270
L273:
	movslq %r13d,%rdi
	movq %rbx,%rax
	cqto 
	idivq %rdi
	movq %rax,%rcx
	imulq %rdi,%rcx
	movslq %esi,%rax
	movq %rax,-8(%rbp)
	movq -8(%rbp),%rax
	leaq -1(%rbx,%rax),%rax
	cqto 
	idivq %rdi
	imulq %rdi,%rax
	cmpq %rax,%rcx
	jz L272
L270:
	movl %r13d,%eax
	decl %eax
	movslq %eax,%rax
	movslq %r13d,%rcx
	addq %rbx,%rax
	cqto 
	idivq %rcx
	imulq %rcx,%rax
	movq %rax,%rbx
L272:
	movslq %r13d,%r13
	movq %rbx,%rax
	cqto 
	idivq %r13
	movq %r14,%rdi
	call _fieldify
	movq %rax,%r14
	jmp L269
L268:
	movl -16(%rbp),%ecx
	shll $3,%ecx
	movl %ecx,%eax
	decl %eax
	movslq %eax,%rax
	movslq %ecx,%rcx
	addq %rbx,%rax
	cqto 
	idivq %rcx
	imulq %rcx,%rax
	movq %rax,%rbx
	movl %r13d,%r12d
L269:
	movq $8,-32(%rbp)
	movq %rbx,%rax
	cqto 
	idivq -32(%rbp)
	movslq -16(%rbp),%rcx
	movq %rcx,-24(%rbp)
	cqto 
	idivq -24(%rbp)
	movl %eax,%r13d
	imull -16(%rbp),%r13d
	testl $2,12(%r15)
	jz L278
L277:
	movl 32(%r15),%eax
	cmpl %eax,%r12d
	cmovgel %r12d,%eax
	movl %eax,32(%r15)
	jmp L279
L278:
	movslq %r12d,%r12
	addq %r12,%rbx
	movl %ebx,32(%r15)
L279:
	cmpq $1073741824,%rbx
	jle L285
L283:
	pushq %r15
	pushq $L286
	pushq $0
	pushq $1
	call _error
	addq $32,%rsp
L285:
	cmpq $0,-40(%rbp)
	jnz L289
L287:
	testq $8192,(%r14)
	jz L234
L293:
	movq 16(%r14),%rsi
	cmpq $0,(%rsi)
	jnz L234
L290:
	movl %r13d,%edx
	movq %r15,%rdi
	call _absorb
L289:
	movl $2048,%esi
	movq -40(%rbp),%rdi
	call _new_symbol
	movq -40(%rbp),%rcx
	movq %rcx,(%rax)
	movq %r14,32(%rax)
	movl %r13d,48(%rax)
	movl _current_scope(%rip),%esi
	movq %rax,%rdi
	call _insert
L234:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_exit_strun:
L298:
	pushq %rbx
L299:
	movslq _current_scope(%rip),%rax
	movq %rdi,%rbx
	cmpq $0,_chains(,%rax,8)
	jnz L303
L301:
	pushq %rbx
	pushq $L304
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L303:
	leaq 40(%rbx),%rdi
	call _exit_scope
	movq 40(%rbx),%rdx
L305:
	testq %rdx,%rdx
	jz L308
L309:
	leaq 48(%rbx),%rax
	movq %rax,64(%rdx)
	movq 48(%rbx),%rax
	leaq 72(%rdx),%rcx
	movq %rax,72(%rdx)
	movq 48(%rbx),%rax
	testq %rax,%rax
	jz L314
L312:
	movq %rcx,64(%rax)
L314:
	movq %rdx,48(%rbx)
	movq 56(%rdx),%rdx
	testq %rdx,%rdx
	jnz L309
L308:
	cmpl $0,32(%rbx)
	jnz L317
L315:
	pushq %rbx
	pushq $L318
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L317:
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
L300:
	popq %rbx
	ret 


_lookup_label:
L320:
	pushq %rbx
	pushq %r12
L321:
	movq %rdi,%r12
	movl $2,%ecx
	movl $2,%edx
	movl $4096,%esi
	movq %r12,%rdi
	call _lookup
	movq %rax,%rbx
	testq %rax,%rax
	jnz L325
L323:
	movl $4096,%esi
	movq %r12,%rdi
	call _new_symbol
	movq %rax,%rbx
	call _new_block
	movq %rax,48(%rbx)
	movl $2,%esi
	movq %rbx,%rdi
	call _insert
L325:
	movq %rbx,%rax
L322:
	popq %r12
	popq %rbx
	ret 


_check0:
L327:
L328:
	testl $1073741824,12(%rdi)
	jnz L329
L330:
	pushq %rdi
	pushq $L333
	pushq (%rdi)
	pushq $4
	call _error
	addq $32,%rsp
L329:
	ret 


_check_labels:
L334:
L335:
	movl $_check0,%edx
	movl $4096,%esi
	movl $2,%edi
	call _walk_scope
L336:
	ret 


_anon_static:
L337:
	pushq %rbx
	pushq %r12
L338:
	movq %rdi,%r12
	movl %esi,%ebx
	movq _anons(%rip),%rax
L340:
	testq %rax,%rax
	jz L343
L341:
	cmpl 48(%rax),%ebx
	jnz L346
L347:
	cmpq 32(%rax),%r12
	jz L339
L346:
	movq 56(%rax),%rax
	testq %rax,%rax
	jnz L341
L343:
	movl $16,%esi
	xorl %edi,%edi
	call _new_symbol
	movq %r12,32(%rax)
	movl %ebx,48(%rax)
	movq _anons(%rip),%rcx
	movq %rcx,56(%rax)
	movq %rax,_anons(%rip)
L339:
	popq %r12
	popq %rbx
	ret 


_purge_anons:
L354:
L355:
	movl $_anons,%edi
	call _free_symbols
L356:
	ret 


_implicit:
L357:
	pushq %rbx
	pushq %r12
L358:
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
	jnz L362
L360:
	pushq $L363
	pushq %r12
	pushq $0
	call _error
	addq $24,%rsp
	orl $8388608,12(%rbx)
L362:
	movq %rbx,%rax
L359:
	popq %r12
	popq %rbx
	ret 


_registerize:
L365:
L366:
	movq (%rdi),%rcx
L368:
	testq %rcx,%rcx
	jz L367
L369:
	movl 12(%rcx),%eax
	testl $256,%eax
	jz L374
L372:
	andl $-257,%eax
	orl $128,%eax
	movl %eax,12(%rcx)
L374:
	movq 56(%rcx),%rcx
	testq %rcx,%rcx
	jnz L369
L367:
	ret 


_symbol_to_reg:
L376:
	pushq %rbx
L377:
	movq %rdi,%rbx
	movl 44(%rbx),%eax
	cmpl _reg_generation(%rip),%eax
	jge L381
L379:
	movq %rbx,%rdi
	call _assign_reg
	movl %eax,40(%rbx)
	movl _reg_generation(%rip),%eax
	movl %eax,44(%rbx)
L381:
	movl 40(%rbx),%eax
L378:
	popq %rbx
	ret 


_symbol_offset:
L383:
	pushq %rbx
L384:
	movq %rdi,%rbx
	cmpl $0,48(%rbx)
	jnz L388
L386:
	movq 32(%rbx),%rdi
	call _frame_alloc
	movl %eax,48(%rbx)
L388:
	movl 48(%rbx),%eax
L385:
	popq %rbx
	ret 


_print_global:
L390:
L391:
	cmpl $1,8(%rsi)
	jg L394
L396:
	movq (%rsi),%rcx
	testq %rcx,%rcx
	jz L394
L393:
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L400
	pushq %rdi
	call _fprintf
	addq $32,%rsp
	ret
L394:
	cmpl $0,48(%rsi)
	jnz L403
L401:
	movl _last_asmlab(%rip),%eax
	incl %eax
	movl %eax,_last_asmlab(%rip)
	movl %eax,48(%rsi)
L403:
	movl 48(%rsi),%eax
	pushq %rax
	pushq $L404
	pushq %rdi
	call _fprintf
	addq $24,%rsp
L392:
	ret 


_out_globls:
L405:
	pushq %rbx
	pushq %r12
L406:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L409
L408:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L410
L409:
	movl $10,%edi
	call ___flushbuf
L410:
	xorl %ebx,%ebx
L412:
	movslq %ebx,%rax
	movq _symtab(,%rax,8),%r12
L415:
	testq %r12,%r12
	jz L418
L416:
	movl 12(%r12),%eax
	testl $32,%eax
	jz L421
L422:
	testl $1610612736,%eax
	jz L421
L419:
	pushq %r12
	pushq $L426
	call _out
	addq $16,%rsp
L421:
	movq 72(%r12),%r12
	jmp L415
L418:
	incl %ebx
	cmpl $64,%ebx
	jl L412
L407:
	popq %r12
	popq %rbx
	ret 

L304:
 .byte 37,84,32,104,97,115,32,110
 .byte 111,32,110,97,109,101,100,32
 .byte 109,101,109,98,101,114,115,0
L140:
 .byte 112,114,101,118,105,111,117,115
 .byte 108,121,32,100,101,99,108,97
 .byte 114,101,100,32,110,111,110,45
 .byte 115,116,97,116,105,99,0
L400:
 .byte 95,37,46,42,115,0
L426:
 .byte 46,103,108,111,98,108,32,37
 .byte 103,10,0
L333:
 .byte 108,97,98,101,108,32,110,101
 .byte 118,101,114,32,100,101,102,105
 .byte 110,101,100,32,40,37,76,41
 .byte 0
L214:
 .byte 100,117,112,108,105,99,97,116
 .byte 101,32,97,114,103,117,109,101
 .byte 110,116,32,105,100,101,110,116
 .byte 105,102,105,101,114,0
L113:
 .byte 110,111,32,115,117,99,104,32
 .byte 109,101,109,98,101,114,32,105
 .byte 110,32,37,84,0
L318:
 .byte 37,84,32,104,97,115,32,122
 .byte 101,114,111,32,115,105,122,101
 .byte 0
L286:
 .byte 37,84,32,101,120,99,101,101
 .byte 100,115,32,109,97,120,105,109
 .byte 117,109,32,115,116,114,117,99
 .byte 116,47,117,110,105,111,110,32
 .byte 115,105,122,101,0
L244:
 .byte 110,111,32,109,101,109,98,101
 .byte 114,115,32,97,108,108,111,119
 .byte 101,100,32,97,102,116,101,114
 .byte 32,102,108,101,120,105,98,108
 .byte 101,32,97,114,114,97,121,0
L266:
 .byte 102,108,101,120,105,98,108,101
 .byte 32,97,114,114,97,121,32,105
 .byte 115,32,102,105,114,115,116,32
 .byte 110,97,109,101,100,32,109,101
 .byte 109,98,101,114,0
L404:
 .byte 76,37,100,0
L216:
 .byte 97,108,114,101,97,100,121,32
 .byte 100,101,99,108,97,114,101,100
 .byte 32,105,110,32,37,84,32,37
 .byte 76,0
L157:
 .byte 115,99,111,112,101,32,110,101
 .byte 115,116,105,110,103,32,116,111
 .byte 111,32,100,101,101,112,0
L363:
 .byte 105,109,112,108,105,99,105,116
 .byte 32,102,117,110,99,116,105,111
 .byte 110,32,100,101,99,108,97,114
 .byte 97,116,105,111,110,0
L217:
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
