.text

_parse_actions:
L1:
	pushq %rbx
L2:
	movl %edi,%ebx
	movl %ebx,%edi
	call _get_shifts
	movq %rax,%rsi
	movl %ebx,%edi
	call _add_reductions
L3:
	popq %rbx
	ret 


_get_shifts:
L5:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L6:
	xorl %r15d,%r15d
	movslq %edi,%rcx
	movq _shift_table(%rip),%rax
	movq (%rax,%rcx,8),%r14
	testq %r14,%r14
	jz L10
L8:
	movswl 10(%r14),%r13d
	decl %r13d
	jmp L11
L12:
	movslq %r13d,%r13
	movswl 12(%r14,%r13,2),%r12d
	movslq %r12d,%r12
	movq _accessing_symbol(%rip),%rax
	movswl (%rax,%r12,2),%ebx
	cmpl _start_symbol(%rip),%ebx
	jge L17
L15:
	movl $24,%edi
	call _allocate
	movq %r15,(%rax)
	movw %bx,8(%rax)
	movw %r12w,10(%rax)
	movslq %ebx,%rbx
	movq _symbol_prec(%rip),%rcx
	movw (%rcx,%rbx,2),%cx
	movw %cx,12(%rax)
	movb $1,14(%rax)
	movq _symbol_assoc(%rip),%rcx
	movb (%rbx,%rcx),%cl
	movb %cl,15(%rax)
	movq %rax,%r15
L17:
	decl %r13d
L11:
	cmpl $0,%r13d
	jge L12
L10:
	movq %r15,%rax
L7:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_add_reductions:
L19:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L20:
	movl _ntokens(%rip),%eax
	movl %edi,%r8d
	movq %rsi,%rdi
	movl $32,%ecx
	addl $31,%eax
	cltd 
	idivl %ecx
	movl %eax,-4(%rbp)
	movslq %r8d,%r8
	movq _lookaheads(%rip),%rcx
	movswl (%rcx,%r8,2),%r14d
	incl %r8d
	movslq %r8d,%rax
	movswl (%rcx,%rax,2),%r15d
	jmp L22
L23:
	movslq %r14d,%r14
	movq _LAruleno(%rip),%rax
	movswl (%rax,%r14,2),%r13d
	movl %r14d,%ecx
	imull -4(%rbp),%ecx
	movslq %ecx,%rcx
	movq _LA(%rip),%rax
	leaq (%rax,%rcx,4),%r12
	movl _ntokens(%rip),%ebx
	decl %ebx
L26:
	cmpl $0,%ebx
	jl L29
L27:
	movl %ebx,%eax
	sarl $5,%eax
	movslq %eax,%rax
	shlq $2,%rax
	movb %bl,%cl
	movl (%rax,%r12),%eax
	shrl %cl,%eax
	testl $1,%eax
	jz L32
L30:
	movl %ebx,%edx
	movl %r13d,%esi
	call _add_reduce
	movq %rax,%rdi
L32:
	decl %ebx
	jmp L26
L29:
	incl %r14d
L22:
	cmpl %r14d,%r15d
	jg L23
L25:
	movq %rdi,%rax
L21:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_add_reduce:
L34:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L35:
	movq %rdi,%r15
	movl %esi,%ebx
	movl %edx,%r14d
	xorl %r13d,%r13d
	movq %r15,%r12
	jmp L37
L41:
	movswl 8(%r12),%eax
	cmpl %eax,%r14d
	jle L45
L38:
	movq %r12,%r13
	movq (%r12),%r12
L37:
	testq %r12,%r12
	jnz L41
	jz L45
L52:
	movswl 8(%r12),%eax
	cmpl %eax,%r14d
	jnz L56
L48:
	cmpb $1,14(%r12)
	jnz L56
L46:
	movq %r12,%r13
	movq (%r12),%r12
L45:
	testq %r12,%r12
	jnz L52
	jz L56
L67:
	movswl 8(%r12),%eax
	cmpl %eax,%r14d
	jnz L58
L63:
	cmpb $2,14(%r12)
	jnz L58
L59:
	movswl 10(%r12),%eax
	cmpl %eax,%ebx
	jle L58
L57:
	movq %r12,%r13
	movq (%r12),%r12
L56:
	testq %r12,%r12
	jnz L67
L58:
	movl $24,%edi
	call _allocate
	movq %r12,(%rax)
	movw %r14w,8(%rax)
	movw %bx,10(%rax)
	movslq %ebx,%rbx
	movq _rprec(%rip),%rcx
	movw (%rcx,%rbx,2),%cx
	movw %cx,12(%rax)
	movb $2,14(%rax)
	movq _rassoc(%rip),%rcx
	movb (%rbx,%rcx),%cl
	movb %cl,15(%rax)
	testq %r13,%r13
	jz L72
L71:
	movq %rax,(%r13)
	jmp L73
L72:
	movq %rax,%r15
L73:
	movq %r15,%rax
L36:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_find_final_state:
L75:
L76:
	movq _shift_table(%rip),%rax
	movq (%rax),%rdi
	movq _ritem(%rip),%rax
	movswl 2(%rax),%esi
	movswl 10(%rdi),%edx
	decl %edx
	jmp L78
L79:
	movslq %edx,%rdx
	movw 12(%rdi,%rdx,2),%cx
	movw %cx,_final_state(%rip)
	movswq %cx,%rcx
	movq _accessing_symbol(%rip),%rax
	movswl (%rax,%rcx,2),%eax
	cmpl %eax,%esi
	jz L77
L84:
	decl %edx
L78:
	cmpl $0,%edx
	jge L79
L77:
	ret 


_unused_rules:
L86:
L87:
	movl _nrules(%rip),%edi
	shll $1,%edi
	call _malloc
	movq %rax,_rules_used(%rip)
	testq %rax,%rax
	jnz L91
L89:
	call _no_space
L91:
	xorl %eax,%eax
	jmp L92
L93:
	movslq %eax,%rax
	movq _rules_used(%rip),%rcx
	movw $0,(%rcx,%rax,2)
	incl %eax
L92:
	cmpl %eax,_nrules(%rip)
	jg L93
L95:
	xorl %edx,%edx
	jmp L96
L97:
	movslq %edx,%rdx
	movq _parser(%rip),%rax
	movq (%rax,%rdx,8),%rcx
L100:
	testq %rcx,%rcx
	jz L103
L101:
	cmpb $2,14(%rcx)
	jnz L106
L107:
	cmpb $0,16(%rcx)
	jnz L106
L108:
	movswq 10(%rcx),%rax
	movq _rules_used(%rip),%rsi
	movw $1,(%rsi,%rax,2)
L106:
	movq (%rcx),%rcx
	jmp L100
L103:
	incl %edx
L96:
	cmpl _nstates(%rip),%edx
	jl L97
L99:
	movw $0,_nunused(%rip)
	movl $3,%eax
	jmp L111
L112:
	movslq %eax,%rax
	movq _rules_used(%rip),%rcx
	cmpw $0,(%rcx,%rax,2)
	jnz L117
L115:
	incw _nunused(%rip)
L117:
	incl %eax
L111:
	cmpl %eax,_nrules(%rip)
	jg L112
L114:
	movw _nunused(%rip),%cx
	testw %cx,%cx
	jz L88
L118:
	movq _myname(%rip),%rax
	cmpw $1,%cx
	jnz L122
L121:
	pushq %rax
	pushq $L124
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	ret
L122:
	movswl %cx,%ecx
	pushq %rcx
	pushq %rax
	pushq $L125
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L88:
	ret 


_remove_conflicts:
L126:
	pushq %rbx
L127:
	movl $0,_SRtotal(%rip)
	movl $0,_RRtotal(%rip)
	movl _nstates(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_SRconflicts(%rip)
	movl _nstates(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_RRconflicts(%rip)
	xorl %eax,%eax
	jmp L129
L130:
	movl $0,_SRcount(%rip)
	movl $0,_RRcount(%rip)
	movl $-1,%edi
	movslq %eax,%rax
	movq _parser(%rip),%rcx
	movq (%rcx,%rax,8),%rsi
L133:
	testq %rsi,%rsi
	jz L136
L134:
	movswl 8(%rsi),%ecx
	cmpl %ecx,%edi
	jz L138
L137:
	movq %rsi,%rbx
	movl %ecx,%edi
	jmp L139
L138:
	movswl _final_state(%rip),%ecx
	cmpl %ecx,%eax
	jnz L145
L143:
	testl %edi,%edi
	jz L174
L145:
	cmpb $1,14(%rbx)
	jnz L148
L147:
	movw 12(%rbx),%dx
	cmpw $0,%dx
	jle L174
L153:
	movw 12(%rsi),%cx
	cmpw $0,%cx
	jg L154
L174:
	incl _SRcount(%rip)
	jmp L171
L154:
	cmpw %cx,%dx
	jl L173
	jg L172
L161:
	movb 15(%rbx),%cl
	cmpb $1,%cl
	jnz L164
L173:
	movb $2,16(%rbx)
	movq %rsi,%rbx
	jmp L139
L164:
	cmpb $2,%cl
	jz L172
L167:
	movb $2,16(%rbx)
L172:
	movb $2,16(%rsi)
	jmp L139
L148:
	incl _RRcount(%rip)
L171:
	movb $1,16(%rsi)
L139:
	movq (%rsi),%rsi
	jmp L133
L136:
	movl _SRtotal(%rip),%ecx
	movl _SRcount(%rip),%edx
	addl %edx,%ecx
	movl %ecx,_SRtotal(%rip)
	movl _RRtotal(%rip),%esi
	addl _RRcount(%rip),%esi
	movl %esi,_RRtotal(%rip)
	movslq %eax,%rax
	movq _SRconflicts(%rip),%rcx
	movw %dx,(%rcx,%rax,2)
	movl _RRcount(%rip),%ecx
	movq _RRconflicts(%rip),%rdx
	movw %cx,(%rdx,%rax,2)
	incl %eax
L129:
	cmpl %eax,_nstates(%rip)
	jg L130
L128:
	popq %rbx
	ret 


_total_conflicts:
L175:
L176:
	pushq _myname(%rip)
	pushq $L178
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl _SRtotal(%rip),%eax
	cmpl $1,%eax
	jz L179
	jl L181
L183:
	pushq %rax
	pushq $L186
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L181
L179:
	pushq $L182
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L181:
	cmpl $0,_SRtotal(%rip)
	jz L189
L190:
	cmpl $0,_RRtotal(%rip)
	jz L189
L187:
	pushq $L194
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L189:
	movl _RRtotal(%rip),%eax
	cmpl $1,%eax
	jz L195
	jl L197
L199:
	pushq %rax
	pushq $L202
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L197
L195:
	pushq $L198
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L197:
	pushq $L203
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L177:
	ret 


_sole_reduction:
L204:
L205:
	xorl %esi,%esi
	xorl %eax,%eax
	movslq %edi,%rdx
	movq _parser(%rip),%rcx
	movq (%rcx,%rdx,8),%rdx
	jmp L207
L208:
	movb 14(%rdx),%cl
	cmpb $1,%cl
	jnz L212
L214:
	cmpb $0,16(%rdx)
	jz L242
L212:
	cmpb $2,%cl
	jnz L213
L222:
	cmpb $0,16(%rdx)
	jnz L213
L219:
	cmpl $0,%eax
	jle L228
L229:
	movswl 10(%rdx),%ecx
	cmpl %ecx,%eax
	jnz L242
L228:
	cmpw $1,8(%rdx)
	jz L236
L234:
	incl %esi
L236:
	movswl 10(%rdx),%eax
L213:
	movq (%rdx),%rdx
L207:
	testq %rdx,%rdx
	jnz L208
L210:
	testl %esi,%esi
	jnz L206
L242:
	xorl %eax,%eax
L206:
	ret 


_defreds:
L243:
	pushq %rbx
L244:
	movl _nstates(%rip),%edi
	shll $1,%edi
	call _allocate
	movq %rax,_defred(%rip)
	xorl %ebx,%ebx
	jmp L246
L247:
	movl %ebx,%edi
	call _sole_reduction
	movslq %ebx,%rbx
	movq _defred(%rip),%rcx
	movw %ax,(%rcx,%rbx,2)
	incl %ebx
L246:
	cmpl %ebx,_nstates(%rip)
	jg L247
L245:
	popq %rbx
	ret 


_free_action_row:
L250:
	pushq %rbx
	jmp L253
L254:
	movq (%rdi),%rbx
	call _free
	movq %rbx,%rdi
L253:
	testq %rdi,%rdi
	jnz L254
L252:
	popq %rbx
	ret 


_free_parser:
L256:
	pushq %rbx
L257:
	xorl %ebx,%ebx
	jmp L259
L260:
	movslq %ebx,%rbx
	movq (%rdi,%rbx,8),%rdi
	call _free_action_row
	incl %ebx
L259:
	movl _nstates(%rip),%eax
	movq _parser(%rip),%rdi
	cmpl %eax,%ebx
	jl L260
L262:
	call _free
L258:
	popq %rbx
	ret 


_make_parser:
L263:
	pushq %rbx
L264:
	movl _nstates(%rip),%edi
	shll $3,%edi
	call _allocate
	movq %rax,_parser(%rip)
	xorl %ebx,%ebx
	jmp L266
L267:
	movl %ebx,%edi
	call _parse_actions
	movslq %ebx,%rbx
	movq _parser(%rip),%rcx
	movq %rax,(%rcx,%rbx,8)
	incl %ebx
L266:
	cmpl %ebx,_nstates(%rip)
	jg L267
L269:
	call _find_final_state
	call _remove_conflicts
	call _unused_rules
	movl _SRtotal(%rip),%ecx
	addl _RRtotal(%rip),%ecx
	cmpl $0,%ecx
	jle L272
L270:
	call _total_conflicts
L272:
	call _defreds
L265:
	popq %rbx
	ret 

L125:
	.byte 37,115,58,32,37,100,32,114
	.byte 117,108,101,115,32,110,101,118
	.byte 101,114,32,114,101,100,117,99
	.byte 101,100,10,0
L178:
	.byte 37,115,58,32,0
L198:
	.byte 49,32,114,101,100,117,99,101
	.byte 47,114,101,100,117,99,101,32
	.byte 99,111,110,102,108,105,99,116
	.byte 0
L203:
	.byte 46,10,0
L194:
	.byte 44,32,0
L202:
	.byte 37,100,32,114,101,100,117,99
	.byte 101,47,114,101,100,117,99,101
	.byte 32,99,111,110,102,108,105,99
	.byte 116,115,0
L186:
	.byte 37,100,32,115,104,105,102,116
	.byte 47,114,101,100,117,99,101,32
	.byte 99,111,110,102,108,105,99,116
	.byte 115,0
L182:
	.byte 49,32,115,104,105,102,116,47
	.byte 114,101,100,117,99,101,32,99
	.byte 111,110,102,108,105,99,116,0
L124:
	.byte 37,115,58,32,49,32,114,117
	.byte 108,101,32,110,101,118,101,114
	.byte 32,114,101,100,117,99,101,100
	.byte 10,0
.globl _parser
.comm _parser, 8, 8
.globl _SRtotal
.comm _SRtotal, 4, 4
.globl _RRtotal
.comm _RRtotal, 4, 4
.globl _SRconflicts
.comm _SRconflicts, 8, 8
.globl _RRconflicts
.comm _RRconflicts, 8, 8
.globl _defred
.comm _defred, 8, 8
.globl _rules_used
.comm _rules_used, 8, 8
.globl _nunused
.comm _nunused, 2, 2
.globl _final_state
.comm _final_state, 2, 2
.local _SRcount
.comm _SRcount, 4, 4
.local _RRcount
.comm _RRcount, 4, 4

.globl _free
.globl _symbol_assoc
.globl _free_parser
.globl _LAruleno
.globl _LA
.globl _malloc
.globl _shift_table
.globl _ntokens
.globl _rules_used
.globl _RRconflicts
.globl _SRconflicts
.globl _lookaheads
.globl _add_reductions
.globl _allocate
.globl _start_symbol
.globl _rprec
.globl _final_state
.globl _accessing_symbol
.globl _symbol_prec
.globl _nrules
.globl ___stderr
.globl _myname
.globl _parse_actions
.globl _nunused
.globl _RRtotal
.globl _parser
.globl _ritem
.globl _get_shifts
.globl _rassoc
.globl _add_reduce
.globl _defred
.globl _SRtotal
.globl _nstates
.globl _fprintf
.globl _make_parser
.globl _no_space
