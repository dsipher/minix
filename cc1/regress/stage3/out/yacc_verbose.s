.text

_print_gotos:
L1:
	pushq %rbx
	pushq %r12
L2:
	movq _verbose_file(%rip),%rcx
	movl %edi,%ebx
	decl (%rcx)
	movq _verbose_file(%rip),%rsi
	js L5
L4:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L6
L5:
	movl $10,%edi
	call ___flushbuf
L6:
	movslq %ebx,%rbx
	movq _shift_table(%rip),%rax
	movq (%rax,%rbx,8),%r12
	xorl %ebx,%ebx
	jmp L7
L8:
	movswl 12(%r12,%rbx,2),%edx
	movslq %edx,%rdx
	movq _accessing_symbol(%rip),%rax
	movswl (%rax,%rdx,2),%ecx
	cmpl _start_symbol(%rip),%ecx
	jl L13
L11:
	movslq %ecx,%rcx
	movq _symbol_name(%rip),%rax
	pushq %rdx
	pushq (%rax,%rcx,8)
	pushq $L14
	pushq _verbose_file(%rip)
	call _fprintf
	addq $32,%rsp
L13:
	incl %ebx
L7:
	movswl 10(%r12),%eax
	cmpl %eax,%ebx
	jl L8
L3:
	popq %r12
	popq %rbx
	ret 


_print_reductions:
L15:
	pushq %rbx
	pushq %r12
L16:
	movq %rdi,%rbx
	movl %esi,%r12d
	movq %rbx,%rax
	jmp L18
L19:
	cmpb $2,14(%rax)
	jnz L24
L25:
	cmpb $2,16(%rax)
	jge L24
L34:
	testq %rbx,%rbx
	jz L37
L35:
	cmpb $2,14(%rbx)
	jnz L40
L41:
	movswl 10(%rbx),%edx
	cmpl %edx,%r12d
	jz L40
L38:
	subl $2,%edx
	cmpb $0,16(%rbx)
	jnz L40
L45:
	movswq 8(%rbx),%rcx
	movq _symbol_name(%rip),%rax
	pushq %rdx
	pushq (%rax,%rcx,8)
	pushq $L48
	pushq _verbose_file(%rip)
	call _fprintf
	addq $32,%rsp
L40:
	movq (%rbx),%rbx
	jmp L34
L37:
	cmpl $0,%r12d
	jle L17
L49:
	subl $2,%r12d
	pushq %r12
	pushq $L52
	pushq _verbose_file(%rip)
	call _fprintf
	addq $24,%rsp
	jmp L17
L24:
	movq (%rax),%rax
L18:
	testq %rax,%rax
	jnz L19
L21:
	pushq $L33
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
L17:
	popq %r12
	popq %rbx
	ret 


_print_shifts:
L53:
	pushq %rbx
L54:
	movq %rdi,%rbx
	xorl %ecx,%ecx
	movq %rbx,%rax
	jmp L56
L57:
	cmpb $2,16(%rax)
	jge L62
L63:
	cmpb $1,14(%rax)
	jnz L62
L60:
	incl %ecx
L62:
	movq (%rax),%rax
L56:
	testq %rax,%rax
	jnz L57
L59:
	cmpl $0,%ecx
	jg L70
	jle L55
L71:
	cmpb $1,14(%rbx)
	jnz L76
L77:
	cmpb $0,16(%rbx)
	jnz L76
L74:
	movswq 8(%rbx),%rdx
	movq _symbol_name(%rip),%rcx
	movswl 10(%rbx),%eax
	pushq %rax
	pushq (%rcx,%rdx,8)
	pushq $L81
	pushq _verbose_file(%rip)
	call _fprintf
	addq $32,%rsp
L76:
	movq (%rbx),%rbx
L70:
	testq %rbx,%rbx
	jnz L71
L55:
	popq %rbx
	ret 


_print_actions:
L82:
	pushq %rbx
	pushq %r12
L83:
	movswl _final_state(%rip),%eax
	movl %edi,%ebx
	cmpl %eax,%ebx
	jnz L87
L85:
	pushq $L88
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
L87:
	movslq %ebx,%rbx
	movq _parser(%rip),%rax
	movq (%rax,%rbx,8),%r12
	testq %r12,%r12
	jz L91
L89:
	movq %r12,%rdi
	call _print_shifts
	movq _defred(%rip),%rax
	movswl (%rax,%rbx,2),%esi
	movq %r12,%rdi
	call _print_reductions
L91:
	movq _shift_table(%rip),%rax
	movq (%rax,%rbx,8),%rcx
	testq %rcx,%rcx
	jz L84
L95:
	movw 10(%rcx),%ax
	cmpw $0,%ax
	jle L84
L92:
	movswl %ax,%eax
	decl %eax
	movslq %eax,%rax
	movswq 12(%rcx,%rax,2),%rcx
	movq _accessing_symbol(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	cmpl _start_symbol(%rip),%eax
	jl L84
L99:
	movl %ebx,%edi
	call _print_gotos
L84:
	popq %r12
	popq %rbx
	ret 


_log_unused:
L102:
	pushq %rbx
	pushq %r12
L103:
	pushq $L105
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
	movl $3,%ebx
	jmp L106
L107:
	movq _rules_used(%rip),%rax
	cmpw $0,(%rax,%rbx,2)
	jnz L112
L110:
	movq _rlhs(%rip),%rax
	movswq (%rax,%rbx,2),%rcx
	movq _symbol_name(%rip),%rax
	pushq (%rax,%rcx,8)
	pushq $L113
	pushq _verbose_file(%rip)
	call _fprintf
	addq $24,%rsp
	movq _rrhs(%rip),%rax
	movswq (%rax,%rbx,2),%rcx
	movq _ritem(%rip),%rax
	leaq (%rax,%rcx,2),%r12
L114:
	movw (%r12),%cx
	movq _verbose_file(%rip),%rax
	cmpw $0,%cx
	jl L117
L115:
	movswq %cx,%rcx
	movq _symbol_name(%rip),%rdx
	pushq (%rdx,%rcx,8)
	pushq $L118
	pushq %rax
	call _fprintf
	addq $24,%rsp
	addq $2,%r12
	jmp L114
L117:
	movl %ebx,%ecx
	subl $2,%ecx
	pushq %rcx
	pushq $L119
	pushq %rax
	call _fprintf
	addq $24,%rsp
L112:
	incl %ebx
L106:
	cmpl _nrules(%rip),%ebx
	jl L107
L104:
	popq %r12
	popq %rbx
	ret 


_log_conflicts:
L120:
	pushq %rbx
L121:
	pushq $L123
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
	xorl %ebx,%ebx
	jmp L124
L125:
	movq _SRconflicts(%rip),%rax
	cmpw $0,(%rax,%rbx,2)
	jnz L128
L131:
	movq _RRconflicts(%rip),%rax
	cmpw $0,(%rax,%rbx,2)
	jz L130
L128:
	pushq %rbx
	pushq $L135
	pushq _verbose_file(%rip)
	call _fprintf
	addq $24,%rsp
	movq _SRconflicts(%rip),%rax
	movw (%rax,%rbx,2),%ax
	cmpw $1,%ax
	jz L136
	jl L138
L140:
	movswl %ax,%eax
	pushq %rax
	pushq $L143
	pushq _verbose_file(%rip)
	call _fprintf
	addq $24,%rsp
	jmp L138
L136:
	pushq $L139
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
L138:
	movq _SRconflicts(%rip),%rax
	cmpw $0,(%rax,%rbx,2)
	jz L146
L147:
	movq _RRconflicts(%rip),%rax
	cmpw $0,(%rax,%rbx,2)
	jz L146
L144:
	pushq $L151
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
L146:
	movq _RRconflicts(%rip),%rax
	movw (%rax,%rbx,2),%ax
	cmpw $1,%ax
	jz L152
	jl L154
L156:
	movswl %ax,%eax
	pushq %rax
	pushq $L159
	pushq _verbose_file(%rip)
	call _fprintf
	addq $24,%rsp
	jmp L154
L152:
	pushq $L155
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
L154:
	pushq $L160
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
L130:
	incl %ebx
L124:
	cmpl _nstates(%rip),%ebx
	jl L125
L122:
	popq %rbx
	ret 


_print_conflicts:
L161:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L162:
	movl %edi,%r15d
	movl $-1,%ebx
	movslq %r15d,%r15
	movq _parser(%rip),%rax
	movq (%rax,%r15,8),%r14
	jmp L164
L165:
	movb 16(%r14),%cl
	cmpb $2,%cl
	jz L166
L170:
	movswl 8(%r14),%eax
	cmpl %eax,%ebx
	jz L173
L172:
	movl %eax,%ebx
	movswl 10(%r14),%r13d
	cmpb $1,14(%r14)
	movl $2,%eax
	movl $1,%r12d
	cmovnzl %eax,%r12d
	jmp L166
L173:
	cmpb $1,%cl
	jnz L166
L178:
	movswl _final_state(%rip),%eax
	cmpl %eax,%r15d
	jnz L182
L184:
	testl %ebx,%ebx
	jnz L182
L181:
	movswl 10(%r14),%eax
	subl $2,%eax
	pushq %rax
	pushq %r15
	pushq $L188
	pushq _verbose_file(%rip)
	call _fprintf
	addq $32,%rsp
	jmp L166
L182:
	movslq %ebx,%rbx
	movq _symbol_name(%rip),%rax
	movq _verbose_file(%rip),%rdx
	movswl 10(%r14),%ecx
	subl $2,%ecx
	movq (%rax,%rbx,8),%rax
	cmpl $1,%r12d
	jnz L190
L189:
	pushq %rax
	pushq %rcx
	pushq %r13
	pushq %r15
	pushq $L192
	jmp L194
L190:
	movl %r13d,%esi
	subl $2,%esi
	pushq %rax
	pushq %rcx
	pushq %rsi
	pushq %r15
	pushq $L193
L194:
	pushq %rdx
	call _fprintf
	addq $48,%rsp
L166:
	movq (%r14),%r14
L164:
	testq %r14,%r14
	jnz L165
L163:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_print_nulls:
L195:
	pushq %rbx
	pushq %r12
L196:
	xorl %r12d,%r12d
	movslq %edi,%rcx
	movq _parser(%rip),%rax
	movq (%rax,%rcx,8),%rcx
	jmp L198
L199:
	cmpb $2,14(%rcx)
	jnz L204
L205:
	movb 16(%rcx),%al
	testb %al,%al
	jz L202
L209:
	cmpb $1,%al
	jnz L204
L202:
	movswl 10(%rcx),%eax
	movslq %eax,%rax
	movq _rrhs(%rip),%rdi
	movswl (%rdi,%rax,2),%esi
	incl %esi
	leal 1(%rax),%edx
	movslq %edx,%rdx
	movswl (%rdi,%rdx,2),%edx
	cmpl %edx,%esi
	jnz L204
L213:
	xorl %r8d,%r8d
L216:
	cmpl %r8d,%r12d
	jle L219
L220:
	movq _null_rules(%rip),%rdx
	movswl (%rdx,%r8,2),%edx
	cmpl %edx,%eax
	jle L219
L218:
	incl %r8d
	jmp L216
L219:
	movl %r8d,%esi
	movq _null_rules(%rip),%rdx
	cmpl %r8d,%r12d
	jnz L226
L225:
	incl %r12d
	jmp L241
L226:
	movswl (%rdx,%rsi,2),%edx
	cmpl %edx,%eax
	jz L204
L228:
	incl %r12d
	movl %r12d,%esi
	decl %esi
L231:
	movq _null_rules(%rip),%rdx
	cmpl %esi,%r8d
	jge L234
L232:
	movl %esi,%edi
	decl %edi
	movslq %edi,%rdi
	movw (%rdx,%rdi,2),%di
	movslq %esi,%rsi
	movw %di,(%rdx,%rsi,2)
	decl %esi
	jmp L231
L234:
	movl %r8d,%esi
L241:
	movw %ax,(%rdx,%rsi,2)
L204:
	movq (%rcx),%rcx
L198:
	testq %rcx,%rcx
	jnz L199
L201:
	xorl %ebx,%ebx
	jmp L235
L236:
	movq _null_rules(%rip),%rcx
	movswl (%rcx,%rbx,2),%esi
	movslq %esi,%rsi
	movq _rlhs(%rip),%rcx
	movswq (%rcx,%rsi,2),%rdx
	movq _symbol_name(%rip),%rcx
	subl $2,%esi
	pushq %rsi
	pushq (%rcx,%rdx,8)
	pushq $L239
	pushq %rax
	call _fprintf
	addq $32,%rsp
	incl %ebx
L235:
	movq _verbose_file(%rip),%rax
	cmpl %ebx,%r12d
	jg L236
L238:
	pushq $L240
	pushq %rax
	call _fprintf
	addq $16,%rsp
L197:
	popq %r12
	popq %rbx
	ret 


_print_core:
L242:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L243:
	movslq %edi,%rcx
	movq _state_table(%rip),%rax
	movq (%rax,%rcx,8),%r14
	movswl 20(%r14),%r13d
	xorl %r12d,%r12d
	jmp L245
L246:
	movswq 22(%r14,%r12,2),%rcx
	movq _ritem(%rip),%rax
	leaq (%rax,%rcx,2),%rbx
	movq %rbx,%rax
L249:
	movw (%rax),%r15w
	cmpw $0,%r15w
	jl L251
L250:
	addq $2,%rax
	jmp L249
L251:
	movswl %r15w,%r15d
	negl %r15d
	movslq %r15d,%r15
	movq _rlhs(%rip),%rax
	movswq (%rax,%r15,2),%rcx
	movq _symbol_name(%rip),%rax
	pushq (%rax,%rcx,8)
	pushq $L252
	pushq _verbose_file(%rip)
	call _fprintf
	addq $24,%rsp
	movq _rrhs(%rip),%rax
	movswq (%rax,%r15,2),%rax
	movq _ritem(%rip),%rcx
	leaq (%rcx,%rax,2),%r15
L253:
	movq _verbose_file(%rip),%rax
	cmpq %r15,%rbx
	jbe L256
L254:
	movswq (%r15),%rcx
	movq _symbol_name(%rip),%rdx
	pushq (%rdx,%rcx,8)
	pushq $L257
	pushq %rax
	call _fprintf
	addq $24,%rsp
	addq $2,%r15
	jmp L253
L256:
	decl (%rax)
	movq _verbose_file(%rip),%rsi
	js L259
L258:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $46,(%rcx)
	jmp L261
L259:
	movl $46,%edi
	call ___flushbuf
L261:
	movw (%r15),%cx
	movq _verbose_file(%rip),%rax
	cmpw $0,%cx
	jl L263
L262:
	movswq %cx,%rcx
	movq _symbol_name(%rip),%rdx
	pushq (%rdx,%rcx,8)
	pushq $L118
	pushq %rax
	call _fprintf
	addq $24,%rsp
	addq $2,%r15
	jmp L261
L263:
	movswl %cx,%edx
	movl $-2,%ecx
	subl %edx,%ecx
	pushq %rcx
	pushq $L119
	pushq %rax
	call _fprintf
	addq $24,%rsp
	incl %r12d
L245:
	cmpl %r12d,%r13d
	jg L246
L244:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_print_state:
L264:
	pushq %rbx
L265:
	movl %edi,%ebx
	testl %ebx,%ebx
	jz L269
L267:
	pushq $L123
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
L269:
	movslq %ebx,%rbx
	movq _SRconflicts(%rip),%rax
	cmpw $0,(%rax,%rbx,2)
	jnz L270
L273:
	movq _RRconflicts(%rip),%rax
	cmpw $0,(%rax,%rbx,2)
	jz L272
L270:
	movl %ebx,%edi
	call _print_conflicts
L272:
	pushq %rbx
	pushq $L277
	pushq _verbose_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl %ebx,%edi
	call _print_core
	movl %ebx,%edi
	call _print_nulls
	movl %ebx,%edi
	call _print_actions
L266:
	popq %rbx
	ret 


_verbose:
L278:
	pushq %rbx
L279:
	cmpb $0,_vflag(%rip)
	jz L280
L283:
	movl _nrules(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_null_rules(%rip)
	testq %rax,%rax
	jnz L287
L285:
	call _no_space
L287:
	pushq $L288
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
	xorl %ebx,%ebx
	jmp L289
L290:
	movl %ebx,%edi
	call _print_state
	incl %ebx
L289:
	cmpl _nstates(%rip),%ebx
	jl L290
L292:
	movq _null_rules(%rip),%rdi
	call _free
	cmpw $0,_nunused(%rip)
	jz L295
L293:
	call _log_unused
L295:
	cmpl $0,_SRtotal(%rip)
	jnz L296
L299:
	cmpl $0,_RRtotal(%rip)
	jz L298
L296:
	call _log_conflicts
L298:
	movq _verbose_file(%rip),%rdx
	movl _ntokens(%rip),%ecx
	movl _nvars(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq $L303
	pushq %rdx
	call _fprintf
	movl _nrules(%rip),%eax
	movq _verbose_file(%rip),%rdx
	movl _nstates(%rip),%ecx
	subl $2,%eax
	pushq %rcx
	pushq %rax
	pushq $L304
	pushq %rdx
	call _fprintf
	addq $64,%rsp
L280:
	popq %rbx
	ret 

L33:
	.byte 9,46,32,32,101,114,114,111
	.byte 114,10,0
L14:
	.byte 9,37,115,32,32,103,111,116
	.byte 111,32,37,100,10,0
L105:
	.byte 10,10,82,117,108,101,115,32
	.byte 110,101,118,101,114,32,114,101
	.byte 100,117,99,101,100,58,10,0
L304:
	.byte 37,100,32,103,114,97,109,109
	.byte 97,114,32,114,117,108,101,115
	.byte 44,32,37,100,32,115,116,97
	.byte 116,101,115,10,0
L118:
	.byte 32,37,115,0
L239:
	.byte 9,37,115,32,58,32,46,32
	.byte 32,40,37,100,41,10,0
L188:
	.byte 37,100,58,32,115,104,105,102
	.byte 116,47,114,101,100,117,99,101
	.byte 32,99,111,110,102,108,105,99
	.byte 116,32,40,97,99,99,101,112
	.byte 116,44,32,114,101,100,117,99
	.byte 101,32,37,100,41,32,111,110
	.byte 32,36,101,110,100,10,0
L155:
	.byte 49,32,114,101,100,117,99,101
	.byte 47,114,101,100,117,99,101,32
	.byte 99,111,110,102,108,105,99,116
	.byte 0
L160:
	.byte 46,10,0
L240:
	.byte 10,0
L151:
	.byte 44,32,0
L88:
	.byte 9,36,101,110,100,32,32,97
	.byte 99,99,101,112,116,10,0
L113:
	.byte 9,37,115,32,58,0
L119:
	.byte 32,32,40,37,100,41,10,0
L135:
	.byte 83,116,97,116,101,32,37,100
	.byte 32,99,111,110,116,97,105,110
	.byte 115,32,0
L159:
	.byte 37,100,32,114,101,100,117,99
	.byte 101,47,114,101,100,117,99,101
	.byte 32,99,111,110,102,108,105,99
	.byte 116,115,0
L288:
	.byte 12,10,0
L192:
	.byte 37,100,58,32,115,104,105,102
	.byte 116,47,114,101,100,117,99,101
	.byte 32,99,111,110,102,108,105,99
	.byte 116,32,40,115,104,105,102,116
	.byte 32,37,100,44,32,114,101,100
	.byte 117,99,101,32,37,100,41,32
	.byte 111,110,32,37,115,10,0
L81:
	.byte 9,37,115,32,32,115,104,105
	.byte 102,116,32,37,100,10,0
L303:
	.byte 10,10,37,100,32,116,101,114
	.byte 109,105,110,97,108,115,44,32
	.byte 37,100,32,110,111,110,116,101
	.byte 114,109,105,110,97,108,115,10
	.byte 0
L143:
	.byte 37,100,32,115,104,105,102,116
	.byte 47,114,101,100,117,99,101,32
	.byte 99,111,110,102,108,105,99,116
	.byte 115,0
L252:
	.byte 9,37,115,32,58,32,0
L123:
	.byte 10,10,0
L139:
	.byte 49,32,115,104,105,102,116,47
	.byte 114,101,100,117,99,101,32,99
	.byte 111,110,102,108,105,99,116,0
L277:
	.byte 115,116,97,116,101,32,37,100
	.byte 10,0
L257:
	.byte 37,115,32,0
L193:
	.byte 37,100,58,32,114,101,100,117
	.byte 99,101,47,114,101,100,117,99
	.byte 101,32,99,111,110,102,108,105
	.byte 99,116,32,40,114,101,100,117
	.byte 99,101,32,37,100,44,32,114
	.byte 101,100,117,99,101,32,37,100
	.byte 41,32,111,110,32,37,115,10
	.byte 0
L48:
	.byte 9,37,115,32,32,114,101,100
	.byte 117,99,101,32,37,100,10,0
L52:
	.byte 9,46,32,32,114,101,100,117
	.byte 99,101,32,37,100,10,0
.local _null_rules
.comm _null_rules, 8, 8

.globl _free
.globl _rlhs
.globl _vflag
.globl _state_table
.globl _malloc
.globl _shift_table
.globl _verbose_file
.globl _ntokens
.globl _rules_used
.globl _rrhs
.globl _verbose
.globl _RRconflicts
.globl _SRconflicts
.globl ___flushbuf
.globl _start_symbol
.globl _final_state
.globl _accessing_symbol
.globl _symbol_name
.globl _nrules
.globl _nunused
.globl _RRtotal
.globl _parser
.globl _ritem
.globl _nvars
.globl _defred
.globl _SRtotal
.globl _nstates
.globl _fprintf
.globl _no_space
