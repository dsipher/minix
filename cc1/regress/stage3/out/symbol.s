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
	jmp L150
L130:
	movl %ebx,%esi
	movq %r15,%rdi
	call _new_symbol
	movq %rax,%r12
	movq %r14,32(%rax)
	movl %r13d,%esi
	movq %rax,%rdi
L150:
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
	movl _current_scope(%rip),%edx
	movq _strun_scopes(%rip),%rax
	movb %dl,%cl
	movl $1,%esi
	shlq %cl,%rsi
	testl %ebx,%ebx
	jz L159
L158:
	orq %rax,%rsi
	movq %rsi,_strun_scopes(%rip)
	jmp L153
L159:
	notq %rsi
	andq %rax,%rsi
	movq %rsi,_strun_scopes(%rip)
	movl %edx,_outer_scope(%rip)
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
	jmp L174
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
L193:
	pushq %rbx
	pushq %r12
L194:
	movq %rdi,%r12
	xorl %edi,%edi
	call _enter_scope
L196:
	movq (%r12),%rdi
	testq %rdi,%rdi
	jz L195
L197:
	movq 56(%rdi),%rbx
	movl _outer_scope(%rip),%esi
	call _insert
	movq %rbx,(%r12)
	jmp L196
L195:
	popq %r12
	popq %rbx
	ret 


_unique:
L199:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L200:
	movq %rdi,%r14
	movl %esi,%ebx
	movq %rcx,%r13
	testq %r14,%r14
	jz L201
L205:
	movl %edx,%ecx
	movl %ebx,%esi
	movq %r14,%rdi
	call _lookup
	movq %rax,%r12
	testq %rax,%rax
	jz L201
L202:
	andl $134219776,%ebx
	cmpl $134217728,%ebx
	jz L212
L218:
	cmpl $2048,%ebx
	jz L214
	jnz L209
L212:
	pushq $L213
	pushq %r14
	pushq $4
	call _error
	addq $24,%rsp
L214:
	pushq %r12
	pushq %r13
	pushq $L215
	pushq %r14
	pushq $4
	call _error
	addq $40,%rsp
L209:
	pushq %r12
	pushq $L216
	pushq %r14
	pushq $4
	call _error
	addq $32,%rsp
L201:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_absorb:
L221:
	pushq %rbx
	pushq %r12
	pushq %r13
L222:
	movq %rdi,%r13
	movl %edx,%r12d
	movq 40(%rsi),%rbx
L224:
	testq %rbx,%rbx
	jz L223
L225:
	movq (%rbx),%rdi
	testq %rdi,%rdi
	jz L230
L228:
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
L230:
	movq 56(%rbx),%rbx
	jmp L224
L223:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_insert_member:
L231:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L232:
	movq %rdi,-8(%rbp)
	movq %rsi,%r15
	movq %rdx,%r14
	movq -8(%rbp),%rcx
	movl _current_scope(%rip),%edx
	movl $2048,%esi
	movq %r15,%rdi
	call _unique
	movq %r14,%rdi
	call _align_of
	movl %eax,-12(%rbp)
	movq -8(%rbp),%rax
	movl 36(%rax),%ecx
	cmpl %ecx,-12(%rbp)
	movl -12(%rbp),%eax
	cmovgel %eax,%ecx
	movq -8(%rbp),%rax
	movl %ecx,36(%rax)
	movq -8(%rbp),%rax
	movl 12(%rax),%ecx
	testl $2,%ecx
	jz L238
L237:
	xorl %r13d,%r13d
	jmp L239
L238:
	movq -8(%rbp),%rax
	movl 32(%rax),%r13d
L239:
	movslq %r13d,%r13
	testl $67108864,%ecx
	jz L242
L240:
	pushq $L243
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
L242:
	movq (%r14),%rax
	testq $131072,%rax
	jnz L244
L247:
	testq $8192,%rax
	jz L246
L251:
	movq 16(%r14),%rax
	testl $4194304,12(%rax)
	jz L246
L244:
	movq -8(%rbp),%rax
	orl $4194304,12(%rax)
L246:
	testq $16384,(%r14)
	jz L256
L258:
	cmpl $0,16(%r14)
	jnz L256
L255:
	xorl %r12d,%r12d
	movq -8(%rbp),%rax
	orl $67108864,12(%rax)
	movslq _current_scope(%rip),%rax
	cmpq $0,_chains(,%rax,8)
	jnz L257
L262:
	pushq $L265
	pushq %r15
	pushq $4
	call _error
	addq $24,%rsp
	jmp L257
L256:
	xorl %esi,%esi
	movq %r14,%rdi
	call _size_of
	shll $3,%eax
	movl %eax,%r12d
L257:
	movq (%r14),%rcx
	movq $549755813888,%rax
	testq %rcx,%rax
	jz L267
L266:
	movq $545460846592,%rsi
	andq %rcx,%rsi
	sarq $32,%rsi
	movl %esi,%ebx
	testl %esi,%esi
	jz L269
L272:
	movslq %r12d,%rdi
	movq %r13,%rax
	cqto 
	idivq %rdi
	movq %rax,%rcx
	imulq %rdi,%rcx
	movslq %esi,%rax
	leaq -1(%r13,%rax),%rax
	cqto 
	idivq %rdi
	imulq %rdi,%rax
	cmpq %rax,%rcx
	jz L271
L269:
	movl %r12d,%eax
	decl %eax
	movslq %eax,%rax
	movslq %r12d,%rcx
	addq %r13,%rax
	cqto 
	idivq %rcx
	imulq %rcx,%rax
	movq %rax,%r13
L271:
	movslq %r12d,%r12
	movq %r13,%rax
	cqto 
	idivq %r12
	movq %r14,%rdi
	call _fieldify
	movq %rax,%r14
	jmp L268
L267:
	movl -12(%rbp),%ecx
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
L268:
	movl $8,%ecx
	movq %r13,%rax
	cqto 
	idivq %rcx
	movslq -12(%rbp),%rcx
	cqto 
	idivq %rcx
	movl %eax,%r12d
	imull -12(%rbp),%r12d
	movq -8(%rbp),%rax
	testl $2,12(%rax)
	jz L277
L276:
	movq -8(%rbp),%rax
	movl 32(%rax),%ecx
	cmpl %ecx,%ebx
	cmovgel %ebx,%ecx
	movq -8(%rbp),%rax
	movl %ecx,32(%rax)
	jmp L278
L277:
	movslq %ebx,%rbx
	addq %rbx,%r13
	movq -8(%rbp),%rax
	movl %r13d,32(%rax)
L278:
	cmpq $1073741824,%r13
	jle L284
L282:
	pushq -8(%rbp)
	pushq $L285
	pushq $0
	pushq $1
	call _error
	addq $32,%rsp
L284:
	testq %r15,%r15
	jnz L288
L286:
	testq $8192,(%r14)
	jz L233
L292:
	movq 16(%r14),%rsi
	cmpq $0,(%rsi)
	jnz L233
L289:
	movl %r12d,%edx
	movq -8(%rbp),%rdi
	call _absorb
L288:
	movl $2048,%esi
	movq %r15,%rdi
	call _new_symbol
	movq %r15,(%rax)
	movq %r14,32(%rax)
	movl %r12d,48(%rax)
	movl _current_scope(%rip),%esi
	movq %rax,%rdi
	call _insert
L233:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_exit_strun:
L297:
	pushq %rbx
L298:
	movslq _current_scope(%rip),%rax
	movq %rdi,%rbx
	cmpq $0,_chains(,%rax,8)
	jnz L302
L300:
	pushq %rbx
	pushq $L303
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L302:
	leaq 40(%rbx),%rdi
	call _exit_scope
	movq 40(%rbx),%rdx
L304:
	testq %rdx,%rdx
	jz L307
L308:
	leaq 48(%rbx),%rax
	movq %rax,64(%rdx)
	movq 48(%rbx),%rax
	leaq 72(%rdx),%rcx
	movq %rax,72(%rdx)
	movq 48(%rbx),%rax
	testq %rax,%rax
	jz L313
L311:
	movq %rcx,64(%rax)
L313:
	movq %rdx,48(%rbx)
	movq 56(%rdx),%rdx
	jmp L304
L307:
	cmpl $0,32(%rbx)
	jnz L316
L314:
	pushq %rbx
	pushq $L317
	pushq $0
	pushq $4
	call _error
	addq $32,%rsp
L316:
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
L299:
	popq %rbx
	ret 


_lookup_label:
L318:
	pushq %rbx
	pushq %r12
L319:
	movq %rdi,%r12
	movl $2,%ecx
	movl $2,%edx
	movl $4096,%esi
	movq %r12,%rdi
	call _lookup
	movq %rax,%rbx
	testq %rax,%rax
	jnz L323
L321:
	movl $4096,%esi
	movq %r12,%rdi
	call _new_symbol
	movq %rax,%rbx
	call _new_block
	movq %rax,48(%rbx)
	movl $2,%esi
	movq %rbx,%rdi
	call _insert
L323:
	movq %rbx,%rax
L320:
	popq %r12
	popq %rbx
	ret 


_check0:
L325:
L326:
	testl $1073741824,12(%rdi)
	jnz L327
L328:
	pushq %rdi
	pushq $L331
	pushq (%rdi)
	pushq $4
	call _error
	addq $32,%rsp
L327:
	ret 


_check_labels:
L332:
L333:
	movl $_check0,%edx
	movl $4096,%esi
	movl $2,%edi
	call _walk_scope
L334:
	ret 


_anon_static:
L335:
	pushq %rbx
	pushq %r12
L336:
	movq %rdi,%r12
	movl %esi,%ebx
	movq _anons(%rip),%rax
L338:
	testq %rax,%rax
	jz L341
L339:
	cmpl 48(%rax),%ebx
	jnz L344
L345:
	cmpq 32(%rax),%r12
	jz L337
L344:
	movq 56(%rax),%rax
	jmp L338
L341:
	movl $16,%esi
	xorl %edi,%edi
	call _new_symbol
	movq %r12,32(%rax)
	movl %ebx,48(%rax)
	movq _anons(%rip),%rcx
	movq %rcx,56(%rax)
	movq %rax,_anons(%rip)
L337:
	popq %r12
	popq %rbx
	ret 


_purge_anons:
L351:
L352:
	movl $_anons,%edi
	call _free_symbols
L353:
	ret 


_implicit:
L354:
	pushq %rbx
	pushq %r12
L355:
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
	jnz L359
L357:
	pushq $L360
	pushq %r12
	pushq $0
	call _error
	addq $24,%rsp
	orl $8388608,12(%rbx)
L359:
	movq %rbx,%rax
L356:
	popq %r12
	popq %rbx
	ret 


_registerize:
L362:
L363:
	movq (%rdi),%rcx
L365:
	testq %rcx,%rcx
	jz L364
L366:
	movl 12(%rcx),%eax
	testl $256,%eax
	jz L371
L369:
	andl $-257,%eax
	orl $128,%eax
	movl %eax,12(%rcx)
L371:
	movq 56(%rcx),%rcx
	jmp L365
L364:
	ret 


_symbol_to_reg:
L372:
	pushq %rbx
L373:
	movq %rdi,%rbx
	movl 44(%rbx),%eax
	cmpl _reg_generation(%rip),%eax
	jge L377
L375:
	movq %rbx,%rdi
	call _assign_reg
	movl %eax,40(%rbx)
	movl _reg_generation(%rip),%eax
	movl %eax,44(%rbx)
L377:
	movl 40(%rbx),%eax
L374:
	popq %rbx
	ret 


_symbol_offset:
L379:
	pushq %rbx
L380:
	movq %rdi,%rbx
	cmpl $0,48(%rbx)
	jnz L384
L382:
	movq 32(%rbx),%rdi
	call _frame_alloc
	movl %eax,48(%rbx)
L384:
	movl 48(%rbx),%eax
L381:
	popq %rbx
	ret 


_print_global:
L386:
L387:
	cmpl $1,8(%rsi)
	jg L390
L392:
	movq (%rsi),%rcx
	testq %rcx,%rcx
	jz L390
L389:
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L396
	pushq %rdi
	call _fprintf
	addq $32,%rsp
	ret
L390:
	cmpl $0,48(%rsi)
	jnz L399
L397:
	movl _last_asmlab(%rip),%eax
	incl %eax
	movl %eax,_last_asmlab(%rip)
	movl %eax,48(%rsi)
L399:
	movl 48(%rsi),%eax
	pushq %rax
	pushq $L400
	pushq %rdi
	call _fprintf
	addq $24,%rsp
L388:
	ret 


_out_globls:
L401:
	pushq %rbx
	pushq %r12
L402:
	movq _out_f(%rip),%rcx
	decl (%rcx)
	movq _out_f(%rip),%rsi
	js L405
L404:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L406
L405:
	movl $10,%edi
	call ___flushbuf
L406:
	xorl %r12d,%r12d
L408:
	movslq %r12d,%rax
	movq _symtab(,%rax,8),%rbx
L411:
	testq %rbx,%rbx
	jz L414
L412:
	movl 12(%rbx),%eax
	testl $32,%eax
	jz L417
L418:
	testl $1610612736,%eax
	jz L417
L415:
	pushq %rbx
	pushq $L422
	call _out
	addq $16,%rsp
L417:
	movq 72(%rbx),%rbx
	jmp L411
L414:
	incl %r12d
	cmpl $64,%r12d
	jl L408
L403:
	popq %r12
	popq %rbx
	ret 

L303:
	.byte 37,84,32,104,97,115,32,110
	.byte 111,32,110,97,109,101,100,32
	.byte 109,101,109,98,101,114,115,0
L139:
	.byte 112,114,101,118,105,111,117,115
	.byte 108,121,32,100,101,99,108,97
	.byte 114,101,100,32,110,111,110,45
	.byte 115,116,97,116,105,99,0
L396:
	.byte 95,37,46,42,115,0
L422:
	.byte 46,103,108,111,98,108,32,37
	.byte 103,10,0
L331:
	.byte 108,97,98,101,108,32,110,101
	.byte 118,101,114,32,100,101,102,105
	.byte 110,101,100,32,40,37,76,41
	.byte 0
L213:
	.byte 100,117,112,108,105,99,97,116
	.byte 101,32,97,114,103,117,109,101
	.byte 110,116,32,105,100,101,110,116
	.byte 105,102,105,101,114,0
L113:
	.byte 110,111,32,115,117,99,104,32
	.byte 109,101,109,98,101,114,32,105
	.byte 110,32,37,84,0
L317:
	.byte 37,84,32,104,97,115,32,122
	.byte 101,114,111,32,115,105,122,101
	.byte 0
L285:
	.byte 37,84,32,101,120,99,101,101
	.byte 100,115,32,109,97,120,105,109
	.byte 117,109,32,115,116,114,117,99
	.byte 116,47,117,110,105,111,110,32
	.byte 115,105,122,101,0
L243:
	.byte 110,111,32,109,101,109,98,101
	.byte 114,115,32,97,108,108,111,119
	.byte 101,100,32,97,102,116,101,114
	.byte 32,102,108,101,120,105,98,108
	.byte 101,32,97,114,114,97,121,0
L265:
	.byte 102,108,101,120,105,98,108,101
	.byte 32,97,114,114,97,121,32,105
	.byte 115,32,102,105,114,115,116,32
	.byte 110,97,109,101,100,32,109,101
	.byte 109,98,101,114,0
L400:
	.byte 76,37,100,0
L215:
	.byte 97,108,114,101,97,100,121,32
	.byte 100,101,99,108,97,114,101,100
	.byte 32,105,110,32,37,84,32,37
	.byte 76,0
L157:
	.byte 115,99,111,112,101,32,110,101
	.byte 115,116,105,110,103,32,116,111
	.byte 111,32,100,101,101,112,0
L360:
	.byte 105,109,112,108,105,99,105,116
	.byte 32,102,117,110,99,116,105,111
	.byte 110,32,100,101,99,108,97,114
	.byte 97,116,105,111,110,0
L216:
	.byte 97,108,114,101,97,100,121,32
	.byte 100,101,99,108,97,114,101,100
	.byte 32,105,110,32,116,104,105,115
	.byte 32,115,99,111,112,101,32,37
	.byte 76,0
.globl _current_scope
.comm _current_scope, 4, 4
.globl _outer_scope
.comm _outer_scope, 4, 4
.globl _reg_generation
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
