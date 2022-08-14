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
L7:
	movswl 10(%r12),%eax
	cmpl %eax,%ebx
	jge L3
L8:
	movslq %ebx,%rax
	movswl 12(%r12,%rax,2),%edx
	movslq %edx,%rcx
	movq _accessing_symbol(%rip),%rax
	movswl (%rax,%rcx,2),%ecx
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
	jmp L7
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
L18:
	testq %rax,%rax
	jz L21
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
	jmp L18
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
L56:
	testq %rax,%rax
	jz L59
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
	jmp L56
L59:
	cmpl $0,%ecx
	jle L55
L70:
	testq %rbx,%rbx
	jz L55
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
	jmp L70
L55:
	popq %rbx
	ret 


_print_actions:
L82:
	pushq %rbx
	pushq %r12
	pushq %r13
L83:
	movswl _final_state(%rip),%eax
	movl %edi,%r12d
	cmpl %eax,%r12d
	jnz L87
L85:
	pushq $L88
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
L87:
	movslq %r12d,%rbx
	movq _parser(%rip),%rax
	movq (%rax,%rbx,8),%r13
	testq %r13,%r13
	jz L91
L89:
	movq %r13,%rdi
	call _print_shifts
	movq _defred(%rip),%rax
	movswl (%rax,%rbx,2),%esi
	movq %r13,%rdi
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
	movl %r12d,%edi
	call _print_gotos
L84:
	popq %r13
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
	movl $3,%r12d
L106:
	cmpl _nrules(%rip),%r12d
	jge L104
L107:
	movslq %r12d,%rbx
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
	leaq (%rax,%rcx,2),%rbx
L114:
	movw (%rbx),%cx
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
	addq $2,%rbx
	jmp L114
L117:
	movl %r12d,%ecx
	subl $2,%ecx
	pushq %rcx
	pushq $L119
	pushq %rax
	call _fprintf
	addq $24,%rsp
L112:
	incl %r12d
	jmp L106
L104:
	popq %r12
	popq %rbx
	ret 


_log_conflicts:
L120:
	pushq %rbx
	pushq %r12
L121:
	pushq $L123
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
	xorl %r12d,%r12d
L124:
	cmpl _nstates(%rip),%r12d
	jge L122
L125:
	movslq %r12d,%rbx
	movq _SRconflicts(%rip),%rax
	cmpw $0,(%rax,%rbx,2)
	jnz L128
L131:
	movq _RRconflicts(%rip),%rax
	cmpw $0,(%rax,%rbx,2)
	jz L130
L128:
	pushq %r12
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
	incl %r12d
	jmp L124
L122:
	popq %r12
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
	movl $-1,%r14d
	movslq %r15d,%rcx
	movq _parser(%rip),%rax
	movq (%rax,%rcx,8),%r13
L164:
	testq %r13,%r13
	jz L163
L165:
	movb 16(%r13),%cl
	cmpb $2,%cl
	jz L166
L170:
	movswl 8(%r13),%eax
	cmpl %eax,%r14d
	jz L173
L172:
	movl %eax,%r14d
	movswl 10(%r13),%r12d
	cmpb $1,14(%r13)
	movl $2,%eax
	movl $1,%ebx
	cmovnzl %eax,%ebx
	jmp L166
L173:
	cmpb $1,%cl
	jnz L166
L178:
	movswl _final_state(%rip),%eax
	cmpl %eax,%r15d
	jnz L182
L184:
	testl %r14d,%r14d
	jnz L182
L181:
	movswl 10(%r13),%eax
	subl $2,%eax
	pushq %rax
	pushq %r15
	pushq $L188
	pushq _verbose_file(%rip)
	call _fprintf
	addq $32,%rsp
	jmp L166
L182:
	movslq %r14d,%rsi
	movq _symbol_name(%rip),%rax
	movq _verbose_file(%rip),%rdx
	movswl 10(%r13),%ecx
	subl $2,%ecx
	movq (%rax,%rsi,8),%rax
	cmpl $1,%ebx
	jnz L190
L189:
	pushq %rax
	pushq %rcx
	pushq %r12
	pushq %r15
	pushq $L192
	jmp L194
L190:
	movl %r12d,%esi
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
	movq (%r13),%r13
	jmp L164
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
	movslq %edi,%rdi
	movq _parser(%rip),%rax
	movq (%rax,%rdi,8),%rcx
L198:
	testq %rcx,%rcx
	jz L201
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
	movslq %eax,%rdx
	movq _rrhs(%rip),%rdi
	movswl (%rdi,%rdx,2),%esi
	incl %esi
	leal 1(%rax),%edx
	movslq %edx,%rdx
	movswl (%rdi,%rdx,2),%edx
	cmpl %edx,%esi
	jnz L204
L213:
	xorl %edi,%edi
L216:
	cmpl %edi,%r12d
	jle L219
L220:
	movslq %edi,%rsi
	movq _null_rules(%rip),%rdx
	movswl (%rdx,%rsi,2),%edx
	cmpl %edx,%eax
	jle L219
L218:
	incl %edi
	jmp L216
L219:
	movslq %edi,%rsi
	movq _null_rules(%rip),%rdx
	cmpl %edi,%r12d
	jnz L226
L225:
	incl %r12d
	movw %ax,(%rdx,%rsi,2)
	jmp L204
L226:
	movswl (%rdx,%rsi,2),%edx
	cmpl %edx,%eax
	jz L204
L228:
	incl %r12d
	movl %r12d,%r9d
	decl %r9d
L231:
	movq _null_rules(%rip),%rdx
	cmpl %r9d,%edi
	jge L234
L232:
	movl %r9d,%esi
	decl %esi
	movslq %esi,%rsi
	movw (%rdx,%rsi,2),%r8w
	movslq %r9d,%rsi
	movw %r8w,(%rdx,%rsi,2)
	decl %r9d
	jmp L231
L234:
	movslq %edi,%rdi
	movw %ax,(%rdx,%rdi,2)
L204:
	movq (%rcx),%rcx
	jmp L198
L201:
	xorl %ebx,%ebx
L235:
	movq _verbose_file(%rip),%rax
	cmpl %ebx,%r12d
	jle L238
L236:
	movslq %ebx,%rcx
	movq _null_rules(%rip),%rdx
	movswl (%rdx,%rcx,2),%ecx
	movslq %ecx,%rsi
	movq _rlhs(%rip),%rdx
	movswq (%rdx,%rsi,2),%rsi
	movq _symbol_name(%rip),%rdx
	subl $2,%ecx
	pushq %rcx
	pushq (%rdx,%rsi,8)
	pushq $L239
	pushq %rax
	call _fprintf
	addq $32,%rsp
	incl %ebx
	jmp L235
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
L241:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L242:
	movslq %edi,%rdi
	movq _state_table(%rip),%rax
	movq (%rax,%rdi,8),%r15
	movswl 20(%r15),%r14d
	xorl %r13d,%r13d
L244:
	cmpl %r13d,%r14d
	jle L243
L245:
	movslq %r13d,%rax
	movswq 22(%r15,%rax,2),%rcx
	movq _ritem(%rip),%rax
	leaq (%rax,%rcx,2),%r12
	movq %r12,%rax
L248:
	movw (%rax),%bx
	cmpw $0,%bx
	jl L250
L249:
	addq $2,%rax
	jmp L248
L250:
	movswl %bx,%ebx
	negl %ebx
	movslq %ebx,%rbx
	movq _rlhs(%rip),%rax
	movswq (%rax,%rbx,2),%rcx
	movq _symbol_name(%rip),%rax
	pushq (%rax,%rcx,8)
	pushq $L251
	pushq _verbose_file(%rip)
	call _fprintf
	addq $24,%rsp
	movq _rrhs(%rip),%rax
	movswq (%rax,%rbx,2),%rax
	movq _ritem(%rip),%rcx
	leaq (%rcx,%rax,2),%rbx
L252:
	movq _verbose_file(%rip),%rax
	cmpq %rbx,%r12
	jbe L255
L253:
	movswq (%rbx),%rcx
	movq _symbol_name(%rip),%rdx
	pushq (%rdx,%rcx,8)
	pushq $L256
	pushq %rax
	call _fprintf
	addq $24,%rsp
	addq $2,%rbx
	jmp L252
L255:
	decl (%rax)
	movq _verbose_file(%rip),%rsi
	js L258
L257:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $46,(%rcx)
	jmp L260
L258:
	movl $46,%edi
	call ___flushbuf
L260:
	movw (%rbx),%dx
	movq _verbose_file(%rip),%rax
	cmpw $0,%dx
	jl L262
L261:
	movswq %dx,%rdx
	movq _symbol_name(%rip),%rcx
	pushq (%rcx,%rdx,8)
	pushq $L118
	pushq %rax
	call _fprintf
	addq $24,%rsp
	addq $2,%rbx
	jmp L260
L262:
	movswl %dx,%edx
	movl $-2,%ecx
	subl %edx,%ecx
	pushq %rcx
	pushq $L119
	pushq %rax
	call _fprintf
	addq $24,%rsp
	incl %r13d
	jmp L244
L243:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_print_state:
L263:
	pushq %rbx
L264:
	movl %edi,%ebx
	testl %ebx,%ebx
	jz L268
L266:
	pushq $L123
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
L268:
	movslq %ebx,%rcx
	movq _SRconflicts(%rip),%rax
	cmpw $0,(%rax,%rcx,2)
	jnz L269
L272:
	movq _RRconflicts(%rip),%rax
	cmpw $0,(%rax,%rcx,2)
	jz L271
L269:
	movl %ebx,%edi
	call _print_conflicts
L271:
	pushq %rbx
	pushq $L276
	pushq _verbose_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl %ebx,%edi
	call _print_core
	movl %ebx,%edi
	call _print_nulls
	movl %ebx,%edi
	call _print_actions
L265:
	popq %rbx
	ret 


_verbose:
L277:
	pushq %rbx
L278:
	cmpb $0,_vflag(%rip)
	jz L279
L282:
	movl _nrules(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_null_rules(%rip)
	testq %rax,%rax
	jnz L286
L284:
	call _no_space
L286:
	pushq $L287
	pushq _verbose_file(%rip)
	call _fprintf
	addq $16,%rsp
	xorl %ebx,%ebx
L288:
	cmpl _nstates(%rip),%ebx
	jge L291
L289:
	movl %ebx,%edi
	call _print_state
	incl %ebx
	jmp L288
L291:
	movq _null_rules(%rip),%rdi
	call _free
	cmpw $0,_nunused(%rip)
	jz L294
L292:
	call _log_unused
L294:
	cmpl $0,_SRtotal(%rip)
	jnz L295
L298:
	cmpl $0,_RRtotal(%rip)
	jz L297
L295:
	call _log_conflicts
L297:
	movq _verbose_file(%rip),%rdx
	movl _ntokens(%rip),%ecx
	movl _nvars(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq $L302
	pushq %rdx
	call _fprintf
	addq $32,%rsp
	movl _nrules(%rip),%eax
	movq _verbose_file(%rip),%rdx
	movl _nstates(%rip),%ecx
	subl $2,%eax
	pushq %rcx
	pushq %rax
	pushq $L303
	pushq %rdx
	call _fprintf
	addq $32,%rsp
L279:
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
L303:
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
L287:
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
L302:
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
L251:
	.byte 9,37,115,32,58,32,0
L123:
	.byte 10,10,0
L139:
	.byte 49,32,115,104,105,102,116,47
	.byte 114,101,100,117,99,101,32,99
	.byte 111,110,102,108,105,99,116,0
L276:
	.byte 115,116,97,116,101,32,37,100
	.byte 10,0
L256:
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
