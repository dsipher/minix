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
	movq %rdi,%r15
	xorl %r14d,%r14d
L37:
	cmpl 12(%r15),%r14d
	jge L43
L41:
	movq 16(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r13
	testq %r13,%r13
	jz L43
L42:
	xorl %ebx,%ebx
L45:
	cmpl 412(%r15),%ebx
	jge L52
L46:
	movq 416(%r15),%rdx
	movslq %ebx,%rax
	shlq $4,%rax
	movl 8(%rdx,%rax),%esi
	xorl %r8d,%r8d
	movl $2,%ecx
	movl 12(%rdx,%rax),%edx
	movq %r13,%rdi
	call _insn_substitute_reg
	testl %eax,%eax
	jz L51
L49:
	orl $26,_opt_request(%rip)
L51:
	incl %ebx
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
	movq %r13,%rdi
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
	leaq 432(%r15),%rbx
	movl $_tmp_defs,%edx
	leaq 432(%r15),%rsi
	movl $_tmp_regs,%edi
	call _union_regs
	movq (%rbx),%rax
	movq %rax,-24(%rbp)
	movq 8(%rbx),%rax
	movq %rax,-16(%rbp)
	movq 16(%rbx),%rax
	movq %rax,-8(%rbp)
	movq _tmp_regs(%rip),%rax
	movq %rax,(%rbx)
	movq _tmp_regs+8(%rip),%rax
	movq %rax,8(%rbx)
	movq _tmp_regs+16(%rip),%rax
	movq %rax,16(%rbx)
	movq -24(%rbp),%rax
	movq %rax,_tmp_regs(%rip)
	movq -16(%rbp),%rax
	movq %rax,_tmp_regs+8(%rip)
	movq -8(%rbp),%rax
	movq %rax,_tmp_regs+16(%rip)
	xorl %ebx,%ebx
L67:
	cmpl _tmp_defs+4(%rip),%ebx
	jge L73
L71:
	movq _tmp_defs+8(%rip),%rcx
	movslq %ebx,%rax
	movl (%rcx,%rax,4),%eax
	movl %eax,-28(%rbp)
	testl %eax,%eax
	jz L73
L72:
	xorl %r12d,%r12d
L75:
	cmpl 412(%r15),%r12d
	jge L78
L76:
	movq 416(%r15),%rdx
	movslq %r12d,%rcx
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
	movl %r12d,%esi
	leaq 408(%r15),%rdi
	call _vector_delete
	decl %r12d
L81:
	incl %r12d
	jmp L75
L78:
	incl %ebx
	jmp L67
L73:
	leaq -32(%rbp),%rdx
	leaq -28(%rbp),%rsi
	movq %r13,%rdi
	call _insn_is_copy
	testl %eax,%eax
	jz L88
L89:
	movl 412(%r15),%esi
	leal 1(%rsi),%eax
	cmpl 408(%r15),%eax
	jge L93
L92:
	movl %eax,412(%r15)
	jmp L94
L93:
	movl $16,%ecx
	movl $1,%edx
	leaq 408(%r15),%rdi
	call _vector_insert
L94:
	movl (%r15),%edx
	movq 416(%r15),%rcx
	movl 412(%r15),%eax
	decl %eax
	movslq %eax,%rax
	shlq $4,%rax
	movl %edx,(%rcx,%rax)
	movq 416(%r15),%rcx
	movl 412(%r15),%eax
	decl %eax
	movslq %eax,%rax
	shlq $4,%rax
	movl %r14d,4(%rcx,%rax)
	movq 416(%r15),%rcx
	movl 412(%r15),%eax
	decl %eax
	movslq %eax,%rax
	shlq $4,%rax
	movl -28(%rbp),%edx
	movl %edx,8(%rcx,%rax)
	movq 416(%r15),%rdx
	movl 412(%r15),%ecx
	decl %ecx
	movslq %ecx,%rcx
	shlq $4,%rcx
	movl -32(%rbp),%eax
	movl %eax,12(%rdx,%rcx)
L88:
	incl %r14d
	jmp L37
L43:
	testl $1,4(%r15)
	jz L36
L98:
	movl 80(%r15),%eax
	andl $7,%eax
	cmpl $1,%eax
	jnz L36
L99:
	xorl %esi,%esi
L102:
	cmpl 412(%r15),%esi
	jge L36
L103:
	movl 88(%r15),%edx
	movq 416(%r15),%rcx
	movslq %esi,%rax
	shlq $4,%rax
	cmpl 8(%rcx,%rax),%edx
	jnz L108
L106:
	movl 12(%rcx,%rax),%eax
	movl %eax,88(%r15)
	orl $8,_opt_request(%rip)
L108:
	incl %esi
	jmp L102
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
L110:
	movq %rdi,%rbx
	movl _u_card(%rip),%edx
	addl $63,%edx
	sarl $6,%edx
	cmpl 456(%rbx),%edx
	jg L119
L118:
	movl %edx,460(%rbx)
	jmp L120
L119:
	movl 460(%rbx),%esi
	subl %esi,%edx
	movl $8,%ecx
	leaq 456(%rbx),%rdi
	call _vector_insert
L120:
	movslq 460(%rbx),%rcx
	shlq $3,%rcx
	movq 464(%rbx),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	xorl %r8d,%r8d
L121:
	cmpl 412(%rbx),%r8d
	jge L111
L122:
	movq _u+8(%rip),%rdi
	movslq _next_u(%rip),%rsi
	shlq $4,%rsi
	movq 416(%rbx),%rdx
	movslq %r8d,%rcx
	shlq $4,%rcx
	movq (%rdx,%rcx),%rax
	movq %rax,(%rdi,%rsi)
	movq 8(%rdx,%rcx),%rax
	movq %rax,8(%rdi,%rsi)
	movl _next_u(%rip),%eax
	movl %eax,%ecx
	andl $63,%ecx
	movl $1,%edx
	shlq %cl,%rdx
	movq 464(%rbx),%rcx
	sarl $6,%eax
	movslq %eax,%rax
	orq %rdx,(%rcx,%rax,8)
	incl _next_u(%rip)
	incl %r8d
	jmp L121
L111:
	popq %rbx
	ret 


_kill0:
L128:
	pushq %rbx
	pushq %r12
	pushq %r13
L129:
	movq %rdi,%r12
	movl _u_card(%rip),%edx
	addl $63,%edx
	sarl $6,%edx
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
	movslq 484(%r12),%rcx
	shlq $3,%rcx
	movq 488(%r12),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	xorl %ebx,%ebx
L140:
	cmpl _u+4(%rip),%ebx
	jge L130
L141:
	movq _u+8(%rip),%rax
	movslq %ebx,%r13
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
	movl %ebx,%ecx
	andl $63,%ecx
	movl $1,%edx
	shlq %cl,%rdx
	movq 488(%r12),%rcx
	movl %ebx,%eax
	sarl $6,%eax
	movslq %eax,%rax
	orq %rdx,(%rcx,%rax,8)
L146:
	incl %ebx
	jmp L140
L130:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_init0:
L154:
	pushq %rbx
L155:
	movq %rdi,%rbx
	movl _u_card(%rip),%edx
	addl $63,%edx
	sarl $6,%edx
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
	movl _u_card(%rip),%edx
	addl $63,%edx
	sarl $6,%edx
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
	movslq 508(%rbx),%rcx
	cmpq %rax,%rbx
	jnz L176
L175:
	shlq $3,%rcx
	xorl %eax,%eax
	rep 
	stosb 
	movslq 532(%rbx),%rcx
	shlq $3,%rcx
	movq 536(%rbx),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	jmp L156
L176:
	shlq $3,%rcx
	movl $255,%eax
	rep 
	stosb 
	movslq 532(%rbx),%rcx
	shlq $3,%rcx
	movq 536(%rbx),%rdi
	movl $255,%eax
	rep 
	stosb 
	movl 532(%rbx),%edi
	xorl %esi,%esi
L181:
	cmpl %esi,%edi
	jle L184
L182:
	movq 488(%rbx),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	notq %rcx
	movq 536(%rbx),%rax
	andq %rcx,(%rax,%rdx,8)
	incl %esi
	jmp L181
L184:
	movl 532(%rbx),%edi
	xorl %esi,%esi
L188:
	cmpl %esi,%edi
	jle L156
L189:
	movq 464(%rbx),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 536(%rbx),%rax
	orq %rcx,(%rax,%rdx,8)
	incl %esi
	jmp L188
L156:
	popq %rbx
	ret 


_global0:
L192:
	pushq %rbx
	pushq %r12
L193:
	movslq _tmp_bits+4(%rip),%rcx
	movq %rdi,%r12
	shlq $3,%rcx
	movq _tmp_bits+8(%rip),%rdi
	xorl %eax,%eax
	rep 
	stosb 
	xorl %ebx,%ebx
L195:
	cmpl 36(%r12),%ebx
	jge L198
L196:
	movq 40(%r12),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rsi
	testl %ebx,%ebx
	jnz L205
L202:
	movl $8,%edx
	addq $528,%rsi
	movl $_tmp_bits,%edi
	call _dup_vector
	jmp L201
L205:
	movl _tmp_bits+4(%rip),%r8d
	xorl %edi,%edi
L208:
	cmpl %edi,%r8d
	jle L201
L209:
	movq 536(%rsi),%rax
	movslq %edi,%rdx
	movq (%rax,%rdx,8),%rcx
	movq _tmp_bits+8(%rip),%rax
	andq %rcx,(%rax,%rdx,8)
	incl %edi
	jmp L208
L201:
	incl %ebx
	jmp L195
L198:
	movl _tmp_bits+4(%rip),%edi
	xorl %esi,%esi
L215:
	cmpl %esi,%edi
	jle L218
L216:
	movq _tmp_bits+8(%rip),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 512(%r12),%rax
	cmpq (%rax,%rdx,8),%rcx
	jnz L219
L221:
	incl %esi
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
	movl 532(%r12),%edi
	xorl %esi,%esi
L233:
	cmpl %esi,%edi
	jle L236
L234:
	movq 488(%r12),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	notq %rcx
	movq 536(%r12),%rax
	andq %rcx,(%rax,%rdx,8)
	incl %esi
	jmp L233
L236:
	movl 532(%r12),%edi
	xorl %esi,%esi
L240:
	cmpl %esi,%edi
	jle L243
L241:
	movq 464(%r12),%rax
	movslq %esi,%rdx
	movq (%rax,%rdx,8),%rcx
	movq 536(%r12),%rax
	orq %rcx,(%rax,%rdx,8)
	incl %esi
	jmp L240
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
L254:
	cmpl _u_card(%rip),%ebx
	jge L247
L255:
	movq 512(%r12),%rcx
	movl %ebx,%eax
	sarl $6,%eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rdx
	movl %ebx,%ecx
	andl $63,%ecx
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
	movslq %ebx,%rcx
	shlq $4,%rcx
	movq (%rdx,%rcx),%rax
	movq %rax,(%rdi,%rsi)
	movq 8(%rdx,%rcx),%rax
	movq %rax,8(%rdi,%rsi)
L260:
	incl %ebx
	jmp L254
L247:
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
L285:
	testq %rbx,%rbx
	jz L288
L286:
	movq %rbx,%rdi
	call _alloc0
	movq 112(%rbx),%rbx
	jmp L285
L288:
	movq _all_blocks(%rip),%rbx
L289:
	testq %rbx,%rbx
	jz L292
L290:
	movq %rbx,%rdi
	call _local0
	movq 112(%rbx),%rbx
	jmp L289
L292:
	movl $0,_u_card(%rip)
	movl $0,_next_u(%rip)
	movq _all_blocks(%rip),%rcx
L293:
	movl _u_card(%rip),%edx
	testq %rcx,%rcx
	jz L297
L294:
	addl 412(%rcx),%edx
	movl %edx,_u_card(%rip)
	movq 112(%rcx),%rcx
	jmp L293
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
L303:
	testq %rbx,%rbx
	jz L306
L304:
	movq %rbx,%rdi
	call _gen0
	movq 112(%rbx),%rbx
	jmp L303
L306:
	movq _all_blocks(%rip),%rbx
L307:
	testq %rbx,%rbx
	jz L310
L308:
	movq %rbx,%rdi
	call _kill0
	movq 112(%rbx),%rbx
	jmp L307
L310:
	movq _all_blocks(%rip),%rbx
L311:
	testq %rbx,%rbx
	jz L315
L312:
	movq %rbx,%rdi
	call _init0
	movq 112(%rbx),%rbx
	jmp L311
L315:
	movl _u_card(%rip),%edx
	addl $63,%edx
	sarl $6,%edx
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
L324:
	testq %rbx,%rbx
	jz L327
L325:
	movq %rbx,%rdi
	call _import0
	movq 112(%rbx),%rbx
	jmp L324
L327:
	movq _all_blocks(%rip),%rbx
L328:
	testq %rbx,%rbx
	jz L332
L329:
	movq %rbx,%rdi
	call _local0
	movq 112(%rbx),%rbx
	jmp L328
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
