.text

_alloc0:
L1:
L2:
	movl $0,408(%rdi)
	movl $0,412(%rdi)
	movq $0,416(%rdi)
	movq $_local_arena,424(%rdi)
	movl $0,432(%rdi)
	movl $0,436(%rdi)
	movq $0,440(%rdi)
	movq $_local_arena,448(%rdi)
	movl $0,456(%rdi)
	movl $0,460(%rdi)
	movq $0,464(%rdi)
	movq $_local_arena,472(%rdi)
	movl $0,480(%rdi)
	movl $0,484(%rdi)
	movq $0,488(%rdi)
	movq $_local_arena,496(%rdi)
	movl $0,504(%rdi)
	movl $0,508(%rdi)
	movq $0,512(%rdi)
	movq $_local_arena,520(%rdi)
	movl $0,528(%rdi)
	movl $0,532(%rdi)
	movq $0,536(%rdi)
	movq $_local_arena,544(%rdi)
L3:
	ret 


_local0:
L34:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L35:
	movq %rdi,%r13
	xorl %r12d,%r12d
	jmp L37
L41:
	movq 16(%r13),%rax
	movq (%rax,%r12,8),%rbx
	testq %rbx,%rbx
	jz L43
L42:
	xorl %r14d,%r14d
L45:
	cmpl 412(%r13),%r14d
	jge L52
L46:
	movq 416(%r13),%rdx
	movl %r14d,%eax
	shlq $4,%rax
	movl 8(%rdx,%rax),%esi
	xorl %r8d,%r8d
	movl $2,%ecx
	movl 12(%rdx,%rax),%edx
	movq %rbx,%rdi
	call _insn_substitute_reg
	testl %eax,%eax
	jz L51
L49:
	orl $26,_opt_request(%rip)
L51:
	incl %r14d
	jmp L45
L52:
	cmpl $0,_tmp_defs(%rip)
	jl L56
L55:
	movl $0,_tmp_defs+4(%rip)
	jmp L57
L56:
	movl _tmp_defs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_defs,%edi
	call _vector_insert
L57:
	xorl %edx,%edx
	movl $_tmp_defs,%esi
	movq %rbx,%rdi
	call _insn_defs
	cmpl $0,_tmp_regs(%rip)
	jl L62
L61:
	movl $0,_tmp_regs+4(%rip)
	jmp L63
L62:
	movl _tmp_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_tmp_regs,%edi
	call _vector_insert
L63:
	leaq 432(%r13),%r14
	movl $_tmp_defs,%edx
	leaq 432(%r13),%rsi
	movl $_tmp_regs,%edi
	call _union_regs
	movq (%r14),%rax
	movq %rax,-24(%rbp)
	movq 8(%r14),%rax
	movq %rax,-16(%rbp)
	movq 16(%r14),%rax
	movq %rax,-8(%rbp)
	movq _tmp_regs(%rip),%rax
	movq %rax,(%r14)
	movq _tmp_regs+8(%rip),%rax
	movq %rax,8(%r14)
	movq _tmp_regs+16(%rip),%rax
	movq %rax,16(%r14)
	movq -24(%rbp),%rax
	movq %rax,_tmp_regs(%rip)
	movq -16(%rbp),%rax
	movq %rax,_tmp_regs+8(%rip)
	movq -8(%rbp),%rax
	movq %rax,_tmp_regs+16(%rip)
	xorl %r14d,%r14d
L67:
	cmpl _tmp_defs+4(%rip),%r14d
	jge L73
L71:
	movq _tmp_defs+8(%rip),%rax
	movl (%rax,%r14,4),%eax
	movl %eax,-28(%rbp)
	testl %eax,%eax
	jz L73
L72:
	xorl %r15d,%r15d
L75:
	cmpl 412(%r13),%r15d
	jge L78
L76:
	movq 416(%r13),%rdx
	movslq %r15d,%rcx
	shlq $4,%rcx
	movl 8(%rdx,%rcx),%eax
	movl -28(%rbp),%esi
	cmpl %eax,%esi
	jz L83
L82:
	cmpl 12(%rdx,%rcx),%esi
	jnz L81
L83:
	movl $16,%ecx
	movl $1,%edx
	movl %r15d,%esi
	leaq 408(%r13),%rdi
	call _vector_delete
	decl %r15d
L81:
	incl %r15d
	jmp L75
L78:
	incl %r14d
	jmp L67
L73:
	leaq -32(%rbp),%rdx
	leaq -28(%rbp),%rsi
	movq %rbx,%rdi
	call _insn_is_copy
	testl %eax,%eax
	jz L88
L89:
	movl 412(%r13),%esi
	leal 1(%rsi),%eax
	cmpl 408(%r13),%eax
	jge L93
L92:
	movl %eax,412(%r13)
	jmp L94
L93:
	movl $16,%ecx
	movl $1,%edx
	leaq 408(%r13),%rdi
	call _vector_insert
L94:
	movl (%r13),%edx
	movq 416(%r13),%rcx
	movl 412(%r13),%eax
	decl %eax
	movslq %eax,%rax
	shlq $4,%rax
	movl %edx,(%rcx,%rax)
	movq 416(%r13),%rcx
	movl 412(%r13),%eax
	decl %eax
	movslq %eax,%rax
	shlq $4,%rax
	movl %r12d,4(%rcx,%rax)
	movq 416(%r13),%rcx
	movl 412(%r13),%eax
	decl %eax
	movslq %eax,%rax
	shlq $4,%rax
	movl -28(%rbp),%edx
	movl %edx,8(%rcx,%rax)
	movq 416(%r13),%rdx
	movl 412(%r13),%ecx
	decl %ecx
	movslq %ecx,%rcx
	shlq $4,%rcx
	movl -32(%rbp),%eax
	movl %eax,12(%rdx,%rcx)
L88:
	incl %r12d
L37:
	cmpl 12(%r13),%r12d
	jl L41
L43:
	testl $1,4(%r13)
	jz L36
L98:
	movl 80(%r13),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L36
L99:
	xorl %esi,%esi
	jmp L102
L103:
	movl 88(%r13),%edx
	movq 416(%r13),%rcx
	movl %esi,%eax
	shlq $4,%rax
	cmpl 8(%rcx,%rax),%edx
	jnz L108
L106:
	movl 12(%rcx,%rax),%eax
	movl %eax,88(%r13)
	orl $8,_opt_request(%rip)
L108:
	incl %esi
L102:
	cmpl 412(%r13),%esi
	jl L103
L36:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_gen0:
L109:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L110:
	movq %rdi,%r12
	movl _u_card(%rip),%ebx
	addl $63,%ebx
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %ebx,%edx
	sarl %cl,%edx
	cmpl 456(%r12),%edx
	jg L119
L118:
	movl %edx,460(%r12)
	jmp L120
L119:
	movl 460(%r12),%esi
	subl %esi,%edx
	movl $8,%ecx
	leaq 456(%r12),%rdi
	call _vector_insert
L120:
	movslq 460(%r12),%rdx
	shlq $3,%rdx
	xorl %esi,%esi
	movq 464(%r12),%rdi
	call ___builtin_memset
	xorl %ebx,%ebx
	jmp L121
L122:
	movq _u+8(%rip),%rdi
	movslq _next_u(%rip),%rsi
	shlq $4,%rsi
	movq 416(%r12),%rdx
	movl %ebx,%ecx
	shlq $4,%rcx
	movq (%rdx,%rcx),%rax
	movq %rax,(%rdi,%rsi)
	movq 8(%rdx,%rcx),%rax
	movq %rax,8(%rdi,%rsi)
	movb _next_u(%rip),%cl
	movl $1,%r14d
	shlq %cl,%r14
	movq 464(%r12),%r13
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl _next_u(%rip),%eax
	sarl %cl,%eax
	movslq %eax,%rax
	orq %r14,(%r13,%rax,8)
	incl _next_u(%rip)
	incl %ebx
L121:
	cmpl 412(%r12),%ebx
	jl L122
L111:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_kill0:
L128:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L129:
	movq %rdi,%r12
	movl _u_card(%rip),%ebx
	addl $63,%ebx
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %ebx,%edx
	sarl %cl,%edx
	cmpl 480(%r12),%edx
	jg L138
L137:
	movl %edx,484(%r12)
	jmp L139
L138:
	movl 484(%r12),%esi
	subl %esi,%edx
	movl $8,%ecx
	leaq 480(%r12),%rdi
	call _vector_insert
L139:
	movslq 484(%r12),%rdx
	shlq $3,%rdx
	xorl %esi,%esi
	movq 488(%r12),%rdi
	call ___builtin_memset
	xorl %ebx,%ebx
	jmp L140
L141:
	movq _u+8(%rip),%rax
	movl %ebx,%r13d
	shlq $4,%r13
	movl 8(%rax,%r13),%esi
	leaq 432(%r12),%rdi
	call _contains_reg
	testl %eax,%eax
	jnz L148
L147:
	movq _u+8(%rip),%rax
	movl 12(%r13,%rax),%esi
	leaq 432(%r12),%rdi
	call _contains_reg
	testl %eax,%eax
	jz L146
L148:
	movb %bl,%cl
	movl $1,%r14d
	shlq %cl,%r14
	movq 488(%r12),%r13
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %ebx,%eax
	sarl %cl,%eax
	orq %r14,(%r13,%rax,8)
L146:
	incl %ebx
L140:
	cmpl _u+4(%rip),%ebx
	jl L141
L130:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_init0:
L154:
	pushq %rbx
	pushq %r12
L155:
	movq %rdi,%rbx
	movl _u_card(%rip),%r12d
	addl $63,%r12d
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %r12d,%edx
	sarl %cl,%edx
	cmpl 504(%rbx),%edx
	jg L164
L163:
	movl %edx,508(%rbx)
	jmp L165
L164:
	movl 508(%rbx),%esi
	subl %esi,%edx
	movl $8,%ecx
	leaq 504(%rbx),%rdi
	call _vector_insert
L165:
	movl _u_card(%rip),%r12d
	addl $63,%r12d
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %r12d,%edx
	sarl %cl,%edx
	cmpl 528(%rbx),%edx
	jg L173
L172:
	movl %edx,532(%rbx)
	jmp L174
L173:
	movl 532(%rbx),%esi
	subl %esi,%edx
	movl $8,%ecx
	leaq 528(%rbx),%rdi
	call _vector_insert
L174:
	movq _entry_block(%rip),%rax
	movq 512(%rbx),%rdi
	movslq 508(%rbx),%rdx
	cmpq %rax,%rbx
	jnz L176
L175:
	shlq $3,%rdx
	xorl %esi,%esi
	call ___builtin_memset
	movslq 532(%rbx),%rdx
	shlq $3,%rdx
	xorl %esi,%esi
	movq 536(%rbx),%rdi
	call ___builtin_memset
	jmp L156
L176:
	shlq $3,%rdx
	movl $255,%esi
	call ___builtin_memset
	movslq 532(%rbx),%rdx
	shlq $3,%rdx
	movl $255,%esi
	movq 536(%rbx),%rdi
	call ___builtin_memset
	movl 532(%rbx),%esi
	xorl %edx,%edx
	jmp L181
L182:
	movq 488(%rbx),%rax
	movq (%rax,%rdx,8),%rcx
	notq %rcx
	movq 536(%rbx),%rax
	andq %rcx,(%rax,%rdx,8)
	incl %edx
L181:
	cmpl %edx,%esi
	jg L182
L184:
	movl 532(%rbx),%esi
	xorl %edx,%edx
	jmp L188
L189:
	movq 464(%rbx),%rax
	movq (%rax,%rdx,8),%rcx
	movq 536(%rbx),%rax
	orq %rcx,(%rax,%rdx,8)
	incl %edx
L188:
	cmpl %edx,%esi
	jg L189
L156:
	popq %r12
	popq %rbx
	ret 


_global0:
L192:
	pushq %rbx
	pushq %r12
L193:
	movslq _tmp_bits+4(%rip),%rdx
	movq %rdi,%r12
	shlq $3,%rdx
	xorl %esi,%esi
	movq _tmp_bits+8(%rip),%rdi
	call ___builtin_memset
	xorl %ebx,%ebx
	jmp L195
L196:
	movq 40(%r12),%rax
	movq (%rax,%rbx,8),%rsi
	testl %ebx,%ebx
	jnz L205
L202:
	movl $8,%edx
	addq $528,%rsi
	movl $_tmp_bits,%edi
	call _dup_vector
	jmp L201
L205:
	movl _tmp_bits+4(%rip),%edi
	xorl %edx,%edx
L208:
	cmpl %edx,%edi
	jle L201
L209:
	movq 536(%rsi),%rax
	movq (%rax,%rdx,8),%rcx
	movq _tmp_bits+8(%rip),%rax
	andq %rcx,(%rax,%rdx,8)
	incl %edx
	jmp L208
L201:
	incl %ebx
L195:
	cmpl 36(%r12),%ebx
	jl L196
L198:
	movl _tmp_bits+4(%rip),%esi
	xorl %edx,%edx
L215:
	cmpl %edx,%esi
	jle L218
L216:
	movq _tmp_bits+8(%rip),%rax
	movq (%rax,%rdx,8),%rcx
	movq 512(%r12),%rax
	cmpq (%rax,%rdx,8),%rcx
	jnz L219
L221:
	incl %edx
	jmp L215
L219:
	movl $8,%edx
	movl $_tmp_bits,%esi
	leaq 504(%r12),%rdi
	call _dup_vector
	movl $8,%edx
	movl $_tmp_bits,%esi
	leaq 528(%r12),%rdi
	call _dup_vector
	movl 532(%r12),%esi
	xorl %edx,%edx
	jmp L233
L234:
	movq 488(%r12),%rax
	movq (%rax,%rdx,8),%rcx
	notq %rcx
	movq 536(%r12),%rax
	andq %rcx,(%rax,%rdx,8)
	incl %edx
L233:
	cmpl %edx,%esi
	jg L234
L236:
	movl 532(%r12),%esi
	xorl %edx,%edx
	jmp L240
L241:
	movq 464(%r12),%rax
	movq (%rax,%rdx,8),%rcx
	movq 536(%r12),%rax
	orq %rcx,(%rax,%rdx,8)
	incl %edx
L240:
	cmpl %edx,%esi
	jg L241
L243:
	movl $1,%eax
	jmp L194
L218:
	xorl %eax,%eax
L194:
	popq %r12
	popq %rbx
	ret 


_import0:
L245:
	pushq %rbx
	pushq %r12
	pushq %r13
L246:
	movq %rdi,%r12
	cmpl $0,408(%r12)
	jl L252
L251:
	movl $0,412(%r12)
	jmp L253
L252:
	movl 412(%r12),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $16,%ecx
	leaq 408(%r12),%rdi
	call _vector_insert
L253:
	xorl %ebx,%ebx
	jmp L254
L255:
	movq 512(%r12),%r13
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %ebx,%eax
	sarl %cl,%eax
	movq (%r13,%rax,8),%rdx
	movb %bl,%cl
	movl $1,%eax
	shlq %cl,%rax
	testq %rdx,%rax
	jz L260
L261:
	movl 412(%r12),%esi
	leal 1(%rsi),%eax
	cmpl 408(%r12),%eax
	jge L265
L264:
	movl %eax,412(%r12)
	jmp L266
L265:
	movl $16,%ecx
	movl $1,%edx
	leaq 408(%r12),%rdi
	call _vector_insert
L266:
	movq 416(%r12),%rdi
	movl 412(%r12),%esi
	decl %esi
	movslq %esi,%rsi
	movq _u+8(%rip),%rdx
	shlq $4,%rsi
	movl %ebx,%ecx
	shlq $4,%rcx
	movq (%rdx,%rcx),%rax
	movq %rax,(%rdi,%rsi)
	movq 8(%rdx,%rcx),%rax
	movq %rax,8(%rdi,%rsi)
L260:
	incl %ebx
L254:
	cmpl _u_card(%rip),%ebx
	jl L255
L247:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_opt_lir_prop:
L267:
	pushq %rbx
L270:
	movl $0,_u(%rip)
	movl $0,_u+4(%rip)
	movq $0,_u+8(%rip)
	movq $_local_arena,_u+16(%rip)
	movl $0,_tmp_bits(%rip)
	movl $0,_tmp_bits+4(%rip)
	movq $0,_tmp_bits+8(%rip)
	movq $_local_arena,_tmp_bits+16(%rip)
	movl $0,_tmp_defs(%rip)
	movl $0,_tmp_defs+4(%rip)
	movq $0,_tmp_defs+8(%rip)
	movq $_local_arena,_tmp_defs+16(%rip)
	movl $0,_tmp_regs(%rip)
	movl $0,_tmp_regs+4(%rip)
	movq $0,_tmp_regs+8(%rip)
	movq $_local_arena,_tmp_regs+16(%rip)
	movq _all_blocks(%rip),%rbx
	jmp L285
L286:
	movq %rbx,%rdi
	call _alloc0
	movq 112(%rbx),%rbx
L285:
	testq %rbx,%rbx
	jnz L286
L288:
	movq _all_blocks(%rip),%rbx
	jmp L289
L290:
	movq %rbx,%rdi
	call _local0
	movq 112(%rbx),%rbx
L289:
	testq %rbx,%rbx
	jnz L290
L292:
	movl $0,_u_card(%rip)
	movl $0,_next_u(%rip)
	movq _all_blocks(%rip),%rcx
	jmp L293
L294:
	addl 412(%rcx),%edx
	movl %edx,_u_card(%rip)
	movq 112(%rcx),%rcx
L293:
	movl _u_card(%rip),%edx
	testq %rcx,%rcx
	jnz L294
L297:
	cmpl %edx,_u(%rip)
	jl L301
L300:
	movl %edx,_u+4(%rip)
	jmp L302
L301:
	movl _u+4(%rip),%esi
	subl %esi,%edx
	movl $16,%ecx
	movl $_u,%edi
	call _vector_insert
L302:
	movq _all_blocks(%rip),%rbx
	jmp L303
L304:
	movq %rbx,%rdi
	call _gen0
	movq 112(%rbx),%rbx
L303:
	testq %rbx,%rbx
	jnz L304
L306:
	movq _all_blocks(%rip),%rbx
	jmp L307
L308:
	movq %rbx,%rdi
	call _kill0
	movq 112(%rbx),%rbx
L307:
	testq %rbx,%rbx
	jnz L308
L310:
	movq _all_blocks(%rip),%rbx
	jmp L311
L312:
	movq %rbx,%rdi
	call _init0
	movq 112(%rbx),%rbx
L311:
	testq %rbx,%rbx
	jnz L312
L315:
	movl _u_card(%rip),%ebx
	addl $63,%ebx
	movl $64,%edi
	call ___builtin_clz
	movb $31,%cl
	subb %al,%cl
	movl %ebx,%edx
	sarl %cl,%edx
	cmpl _tmp_bits(%rip),%edx
	jg L322
L321:
	movl %edx,_tmp_bits+4(%rip)
	jmp L323
L322:
	movl _tmp_bits+4(%rip),%esi
	subl %esi,%edx
	movl $8,%ecx
	movl $_tmp_bits,%edi
	call _vector_insert
L323:
	xorl %edi,%edi
	call _sequence_blocks
	movl $_global0,%edi
	call _iterate_blocks
	movq _all_blocks(%rip),%rbx
	jmp L324
L325:
	movq %rbx,%rdi
	call _import0
	movq 112(%rbx),%rbx
L324:
	testq %rbx,%rbx
	jnz L325
L327:
	movq _all_blocks(%rip),%rbx
	jmp L328
L329:
	movq %rbx,%rdi
	call _local0
	movq 112(%rbx),%rbx
L328:
	testq %rbx,%rbx
	jnz L329
L332:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L269:
	popq %rbx
	ret 

.local _tmp_regs
.comm _tmp_regs, 24, 8
.local _tmp_defs
.comm _tmp_defs, 24, 8
.local _u
.comm _u, 24, 8
.local _u_card
.comm _u_card, 4, 4
.local _next_u
.comm _next_u, 4, 4
.local _tmp_bits
.comm _tmp_bits, 24, 8

.globl _all_blocks
.globl _sequence_blocks
.globl _union_regs
.globl _contains_reg
.globl ___builtin_memset
.globl ___builtin_clz
.globl _insn_is_copy
.globl _entry_block
.globl _insn_substitute_reg
.globl _opt_request
.globl _iterate_blocks
.globl _local_arena
.globl _vector_insert
.globl _vector_delete
.globl _opt_lir_prop
.globl _dup_vector
.globl _insn_defs
