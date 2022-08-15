.text

_opt_prune:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L2:
	movq _all_blocks(%rip),%r12
L4:
	testq %r12,%r12
	jnz L5
L27:
	movq _all_blocks(%rip),%rbx
L28:
	testq %rbx,%rbx
	jz L31
L29:
	testl $1,4(%rbx)
	jz L34
L32:
	movq %rbx,%rdi
	call _unswitch_block
L34:
	movq 112(%rbx),%rbx
	jmp L28
L31:
	movq _all_blocks(%rip),%rbx
L35:
	testq %rbx,%rbx
	jz L38
L36:
	movq %rbx,%rdi
	call _fuse_block
	testl %eax,%eax
	jnz L27
L41:
	movq 112(%rbx),%rbx
	jmp L35
L38:
	movq _all_blocks(%rip),%r12
L43:
	testq %r12,%r12
	jz L46
L44:
	xorl %ebx,%ebx
L47:
	cmpl 60(%r12),%ebx
	jge L50
L48:
	movl %ebx,%esi
	movq %r12,%rdi
	call _bypass_succ
	testl %eax,%eax
	jnz L51
L53:
	incl %ebx
	jmp L47
L51:
	orl $8,_opt_request(%rip)
	jmp L27
L50:
	movq 112(%r12),%r12
	jmp L43
L46:
	xorl %edx,%edx
	xorl %esi,%esi
	xorl %edi,%edi
	call _walk_blocks
	movq _all_blocks(%rip),%rbx
L55:
	testq %rbx,%rbx
	jz L3
L56:
	cmpq _exit_block(%rip),%rbx
	jz L57
L61:
	testl $2,4(%rbx)
	jnz L57
L63:
	movq %rbx,%rdi
	call _kill_block
L57:
	movq 112(%rbx),%rbx
	jmp L55
L3:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L5:
	xorl %ebx,%ebx
L8:
	cmpl 12(%r12),%ebx
	jge L11
L12:
	movq 16(%r12),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%rdi
	testq %rdi,%rdi
	jz L11
L9:
	cmpl $0,(%rdi)
	jz L16
L19:
	leaq -8(%rbp),%rdx
	leaq -4(%rbp),%rsi
	call _insn_is_copy
	testl %eax,%eax
	jz L18
L23:
	movl -4(%rbp),%eax
	cmpl -8(%rbp),%eax
	jnz L18
L16:
	movl $8,%ecx
	movl $1,%edx
	movl %ebx,%esi
	leaq 8(%r12),%rdi
	call _vector_delete
	decl %ebx
L18:
	incl %ebx
	jmp L8
L11:
	movq 112(%r12),%r12
	jmp L4


_fixcc0:
L66:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L67:
	movslq _fixcc_map+4(%rip),%rcx
	movq %rdi,%r15
	movl $0,-12(%rbp)
	movq _fixcc_map+8(%rip),%rdi
	movb $13,%al
	rep 
	stosb 
	movl $0,-28(%rbp)
L69:
	movl -28(%rbp),%eax
	cmpl 12(%r15),%eax
	jge L75
L73:
	movq 16(%r15),%rcx
	movslq -28(%rbp),%rax
	movq %rax,-24(%rbp)
	movq -24(%rbp),%rax
	movq (%rcx,%rax,8),%r14
	testq %r14,%r14
	jz L75
L74:
	movl (%r14),%edx
	cmpb $24,%dl
	jb L82
L80:
	cmpb $35,%dl
	ja L82
L81:
	movq _fixcc_map+8(%rip),%rcx
	subb $24,%dl
	movl 16(%r14),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	movslq %eax,%rax
	movb %dl,(%rcx,%rax)
	jmp L71
L82:
	leaq -8(%rbp),%rdx
	leaq -4(%rbp),%rsi
	movq %r14,%rdi
	call _insn_is_copy
	testl %eax,%eax
	jnz L85
L87:
	leaq -4(%rbp),%rsi
	movq %r14,%rdi
	call _insn_is_cmpz
	testl %eax,%eax
	jz L115
L92:
	movq _fixcc_map+8(%rip),%rcx
	movl -4(%rbp),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	movslq %eax,%rax
	movsbl (%rcx,%rax),%r13d
	cmpl $13,%r13d
	jz L115
L93:
	movl -28(%rbp),%ebx
	incl %ebx
	cmpl 12(%r15),%ebx
	jge L97
L96:
	movq 16(%r15),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%r12
	jmp L98
L97:
	xorl %r12d,%r12d
L98:
	movl -28(%rbp),%edx
	movl $1074266112,%esi
	movq %r15,%rdi
	call _range_by_def
	movl %eax,%esi
	movq %r15,%rdi
	call _range_span
	testq %r12,%r12
	movl $2147483646,%ecx
	cmovnzl %ebx,%ecx
	cmpl %ecx,%eax
	jg L115
L99:
	testq %r12,%r12
	jz L106
L105:
	movl (%r12),%eax
	cmpl $-1744830440,%eax
	jz L111
L145:
	cmpl $-1744830439,%eax
	jz L109
	jnz L115
L111:
	xorl $1,%r13d
L109:
	addl $2550136856,%r13d
	movl %r13d,(%r12)
	jmp L107
L106:
	movl %r13d,%esi
	movq %r15,%rdi
	call _rewrite_znz_succs
	testl %eax,%eax
	jnz L107
L115:
	testl $67108864,(%r14)
	jnz L126
L125:
	movq %r14,%rdi
	call _insn_defs_cc0
	testl %eax,%eax
	jz L127
L126:
	movslq _fixcc_map+4(%rip),%rcx
	movq _fixcc_map+8(%rip),%rdi
	movb $13,%al
	rep 
	stosb 
	jmp L71
L127:
	cmpl $0,_fixcc_regs(%rip)
	jl L133
L132:
	movl $0,_fixcc_regs+4(%rip)
	jmp L134
L133:
	movl _fixcc_regs+4(%rip),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	movl $_fixcc_regs,%edi
	call _vector_insert
L134:
	xorl %edx,%edx
	movl $_fixcc_regs,%esi
	movq %r14,%rdi
	call _insn_defs
	xorl %edx,%edx
L135:
	cmpl _fixcc_regs+4(%rip),%edx
	jge L71
L139:
	movq _fixcc_regs+8(%rip),%rcx
	movslq %edx,%rax
	movl (%rcx,%rax,4),%eax
	movl %eax,-4(%rbp)
	testl %eax,%eax
	jz L71
L140:
	movq _fixcc_map+8(%rip),%rcx
	andl $1073725440,%eax
	sarl $14,%eax
	movslq %eax,%rax
	movb $13,(%rcx,%rax)
	incl %edx
	jmp L135
L107:
	movq 16(%r15),%rcx
	movq -24(%rbp),%rax
	movq $_nop_insn,(%rcx,%rax,8)
	movl -28(%rbp),%esi
	movq %r15,%rdi
	call _live_kill_dead
	orl %eax,-12(%rbp)
	orl $32,_opt_request(%rip)
	jmp L71
L85:
	movq _fixcc_map+8(%rip),%rdx
	movl -8(%rbp),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	movslq %eax,%rax
	movb (%rdx,%rax),%cl
	movl -4(%rbp),%eax
	andl $1073725440,%eax
	sarl $14,%eax
	movslq %eax,%rax
	movb %cl,(%rdx,%rax)
L71:
	incl -28(%rbp)
	jmp L69
L75:
	movl -12(%rbp),%eax
L68:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_opt_lir_fixcc:
L148:
	pushq %rbx
	pushq %r12
L151:
	xorl %ebx,%ebx
	movl $2,%edi
	call _live_analyze
	movl $0,_fixcc_regs(%rip)
	movl $0,_fixcc_regs+4(%rip)
	movq $0,_fixcc_regs+8(%rip)
	movq $_local_arena,_fixcc_regs+16(%rip)
	movl $0,_fixcc_map(%rip)
	movl $0,_fixcc_map+4(%rip)
	movq $0,_fixcc_map+8(%rip)
	movq $_local_arena,_fixcc_map+16(%rip)
	movl _nr_assigned_regs(%rip),%edx
	cmpl $0,%edx
	jg L164
L163:
	movl %edx,_fixcc_map+4(%rip)
	jmp L165
L164:
	movl $1,%ecx
	xorl %esi,%esi
	movl $_fixcc_map,%edi
	call _vector_insert
L165:
	movq _all_blocks(%rip),%r12
L166:
	testq %r12,%r12
	jz L170
L167:
	movq %r12,%rdi
	call _fixcc0
	orl %eax,%ebx
	movq 112(%r12),%r12
	jmp L166
L170:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
	testl %ebx,%ebx
	jnz L151
L150:
	popq %r12
	popq %rbx
	ret 


_opt_dead:
L173:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L176:
	xorl %r13d,%r13d
	movl $3,%edi
	call _live_analyze
	movl $0,-24(%rbp)
	movl $0,-20(%rbp)
	movq $0,-16(%rbp)
	movq $_local_arena,-8(%rbp)
	movq _all_blocks(%rip),%r12
L182:
	testq %r12,%r12
	jz L229
L183:
	movl 12(%r12),%ebx
L186:
	movl %ebx,%eax
	decl %ebx
	testl %eax,%eax
	jz L192
L190:
	movq 16(%r12),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%r14
	testq %r14,%r14
	jz L192
L191:
	movl (%r14),%eax
	testl $8388608,%eax
	jnz L186
L197:
	testl $1,4(%r14)
	jnz L186
L199:
	testl $16777216,%eax
	jnz L186
L206:
	movq %r14,%rdi
	call _insn_defs_mem0
	testl %eax,%eax
	jnz L186
L208:
	cmpl $0,-24(%rbp)
	jl L215
L214:
	movl $0,-20(%rbp)
	jmp L216
L215:
	movl -20(%rbp),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $4,%ecx
	leaq -24(%rbp),%rdi
	call _vector_insert
L216:
	movl $67108864,%edx
	leaq -24(%rbp),%rsi
	movq %r14,%rdi
	call _insn_defs
	xorl %r14d,%r14d
L217:
	cmpl -20(%rbp),%r14d
	jge L223
L221:
	movq -16(%rbp),%rcx
	movslq %r14d,%rax
	movl (%rcx,%rax,4),%esi
	testl %esi,%esi
	jz L223
L222:
	movl %ebx,%edx
	movq %r12,%rdi
	call _range_doa
	testl %eax,%eax
	jz L186
L227:
	incl %r14d
	jmp L217
L223:
	movq 16(%r12),%rcx
	movslq %ebx,%rax
	movq $_nop_insn,(%rcx,%rax,8)
	movl %ebx,%esi
	movq %r12,%rdi
	call _live_kill_dead
	orl %r13d,%eax
	movl %eax,%r13d
	orl $32,_opt_request(%rip)
	jmp L186
L192:
	movq 112(%r12),%r12
	jmp L182
L229:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
	testl %r13d,%r13d
	jnz L176
L175:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_merge0:
L232:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L233:
	movq %rdi,%r14
	movq %rsi,%r12
	call _new_block
	movq %rax,%rbx
	movq %r14,%rdx
	movl $12,%esi
	movq %rbx,%rdi
	call _add_succ
	xorl %r13d,%r13d
L235:
	cmpl 4(%r12),%r13d
	jl L236
L239:
	movq 8(%r12),%rax
	movq (%rax),%rcx
	movl 12(%rcx),%eax
	testl %eax,%eax
	jz L234
L245:
	movq 16(%rcx),%rcx
	decl %eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%r13
	movl $1,%r14d
L247:
	cmpl 4(%r12),%r14d
	jge L250
L248:
	movq 8(%r12),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%rcx
	movl 12(%rcx),%eax
	testl %eax,%eax
	jz L234
L253:
	movq 16(%rcx),%rcx
	decl %eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rsi
	movq %r13,%rdi
	call _same_insn
	testl %eax,%eax
	jz L234
L257:
	incl %r14d
	jmp L247
L250:
	xorl %r14d,%r14d
L259:
	cmpl 4(%r12),%r14d
	jge L262
L260:
	movq 8(%r12),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%rdi
	movl 12(%rdi),%esi
	decl %esi
	call _delete_insn
	incl %r14d
	jmp L259
L262:
	movq %rbx,%rsi
	movq %r13,%rdi
	call _append_insn
	jmp L239
L234:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 
L236:
	movq 8(%r12),%rcx
	movslq %r13d,%rax
	movq %rbx,%rdx
	movq %r14,%rsi
	movq (%rcx,%rax,8),%rdi
	call _replace_succ
	incl %r13d
	jmp L235


_opt_lir_merge:
L263:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L266:
	movl $0,-24(%rbp)
	movl $0,-20(%rbp)
	movq $0,-16(%rbp)
	movq $_local_arena,-8(%rbp)
L269:
	movq _all_blocks(%rip),%r15
L270:
	testq %r15,%r15
	jz L315
L271:
	xorl %r14d,%r14d
L274:
	cmpl 36(%r15),%r14d
	jge L277
L275:
	movq 40(%r15),%rcx
	movslq %r14d,%rax
	movq (%rcx,%rax,8),%r13
	cmpl $0,-24(%rbp)
	jl L282
L281:
	movl $0,-20(%rbp)
	jmp L283
L282:
	movl -20(%rbp),%esi
	xorl %edx,%edx
	subl %esi,%edx
	movl $8,%ecx
	leaq -24(%rbp),%rdi
	call _vector_insert
L283:
	movq %r13,%rdi
	call _unconditional_succ
	testq %rax,%rax
	jz L276
L286:
	cmpl $0,12(%r13)
	jz L276
L290:
	xorl %r12d,%r12d
L292:
	cmpl 36(%r15),%r12d
	jge L295
L293:
	movq 40(%r15),%rcx
	movslq %r12d,%rax
	movq (%rcx,%rax,8),%rbx
	cmpq %rbx,%r13
	jz L294
L298:
	movq %rbx,%rdi
	call _unconditional_succ
	testq %rax,%rax
	jz L294
L302:
	movl 12(%rbx),%eax
	testl %eax,%eax
	jz L294
L306:
	movq 16(%r13),%rdx
	movl 12(%r13),%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq (%rdx,%rcx,8),%rdi
	movq 16(%rbx),%rcx
	decl %eax
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rsi
	call _same_insn
	testl %eax,%eax
	jz L294
L308:
	movq %rbx,%rsi
	leaq -24(%rbp),%rdi
	call _add_block
L294:
	incl %r12d
	jmp L292
L295:
	cmpl $0,-20(%rbp)
	jnz L311
L276:
	incl %r14d
	jmp L274
L311:
	movq %r13,%rsi
	leaq -24(%rbp),%rdi
	call _add_block
	leaq -24(%rbp),%rsi
	movq %r15,%rdi
	call _merge0
	orl $32,_opt_request(%rip)
	jmp L269
L277:
	movq 112(%r15),%r15
	jmp L270
L315:
	movq _local_arena(%rip),%rax
	movq %rax,_local_arena+8(%rip)
L265:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
_passes:
	.int 1
	.fill 4, 1, 0
	.quad _opt_lir_fixcc
	.quad L318
	.int 2
	.fill 4, 1, 0
	.quad _opt_lir_norm
	.quad L319
	.int 4
	.fill 4, 1, 0
	.quad _opt_lir_prop
	.quad L320
	.int 8
	.fill 4, 1, 0
	.quad _opt_dead
	.quad L321
	.int 16
	.fill 4, 1, 0
	.quad _opt_lir_reassoc
	.quad L322
	.int 32
	.fill 4, 1, 0
	.quad _opt_prune
	.quad L323
	.int 64
	.fill 4, 1, 0
	.quad _opt_lir_fold
	.quad L324
	.int 128
	.fill 4, 1, 0
	.quad _opt_lir_hoist
	.quad L325
	.int 256
	.fill 4, 1, 0
	.quad _opt_lir_dvn
	.quad L326
	.int 512
	.fill 4, 1, 0
	.quad _opt_lir_merge
	.quad L327
	.int 1024
	.fill 4, 1, 0
	.quad _opt_mch_fuse
	.quad L328
.text

_opt:
L329:
	pushq %rbx
L330:
	movl %edi,_opt_request(%rip)
	movl %esi,%ebx
	orl _opt_prohibit(%rip),%ebx
L332:
	movl %ebx,%esi
	notl %esi
	andl _opt_request(%rip),%esi
	jz L331
L333:
	xorl %edx,%edx
L336:
	movslq %edx,%rax
	leaq (%rax,%rax,2),%rcx
	shlq $3,%rcx
	movl _passes(%rcx),%eax
	testl %esi,%eax
	jnz L339
L341:
	incl %edx
	cmpl $11,%edx
	jl L336
	jge L332
L339:
	notl %eax
	andl _opt_request(%rip),%eax
	movl %eax,_opt_request(%rip)
	movq _passes+8(%rcx),%rax
	call *%rax
	jmp L332
L331:
	popq %rbx
	ret 

L320:
	.byte 108,105,114,95,112,114,111,112
	.byte 0
L323:
	.byte 112,114,117,110,101,0
L318:
	.byte 108,105,114,95,102,105,120,99
	.byte 99,0
L324:
	.byte 108,105,114,95,102,111,108,100
	.byte 0
L328:
	.byte 109,99,104,95,102,117,115,101
	.byte 0
L325:
	.byte 108,105,114,95,104,111,105,115
	.byte 116,0
L319:
	.byte 108,105,114,95,110,111,114,109
	.byte 0
L327:
	.byte 108,105,114,95,109,101,114,103
	.byte 101,0
L326:
	.byte 108,105,114,95,100,118,110,0
L322:
	.byte 108,105,114,95,114,101,97,115
	.byte 115,111,99,0
L321:
	.byte 100,101,97,100,0
.globl _opt_request
.comm _opt_request, 4, 4
.globl _opt_prohibit
.comm _opt_prohibit, 4, 4
.local _fixcc_map
.comm _fixcc_map, 24, 8
.local _fixcc_regs
.comm _fixcc_regs, 24, 8

.globl _nop_insn
.globl _new_block
.globl _replace_succ
.globl _all_blocks
.globl _insn_defs_mem0
.globl _range_span
.globl _rewrite_znz_succs
.globl _kill_block
.globl _opt
.globl _opt_mch_fuse
.globl _add_block
.globl _bypass_succ
.globl _live_kill_dead
.globl _range_by_def
.globl _opt_lir_reassoc
.globl _opt_lir_norm
.globl _exit_block
.globl _live_analyze
.globl _insn_is_copy
.globl _opt_prohibit
.globl _opt_lir_hoist
.globl _opt_lir_dvn
.globl _range_doa
.globl _insn_is_cmpz
.globl _opt_dead
.globl _opt_request
.globl _walk_blocks
.globl _fuse_block
.globl _add_succ
.globl _nr_assigned_regs
.globl _local_arena
.globl _append_insn
.globl _unconditional_succ
.globl _vector_insert
.globl _delete_insn
.globl _insn_defs_cc0
.globl _same_insn
.globl _opt_lir_fold
.globl _vector_delete
.globl _opt_lir_prop
.globl _insn_defs
.globl _unswitch_block
.globl _opt_prune
