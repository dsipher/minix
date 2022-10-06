.text

_add_accept:
L1:
	pushq %rbx
	pushq %r12
L2:
	movl %edi,%ebx
	movl %esi,%r12d
	movslq %ebx,%rbx
	movq _finalst(%rip),%rax
	movslq (%rax,%rbx,4),%rcx
	movq _transchar(%rip),%rax
	cmpl $257,(%rax,%rcx,4)
	jnz L5
L4:
	movq _accptnum(%rip),%rax
	movl %r12d,(%rax,%rcx,4)
	jmp L3
L5:
	movl $257,%edi
	call _mkstate
	movslq %eax,%rax
	movq _accptnum(%rip),%rcx
	movl %r12d,(%rcx,%rax,4)
	movl %eax,%esi
	movl %ebx,%edi
	call _link_machines
L3:
	popq %r12
	popq %rbx
	ret 


_copysingl:
L7:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L8:
	movl %edi,%r14d
	movl %esi,%r13d
	movl $257,%edi
	call _mkstate
	movl %eax,%r12d
	movl $1,%ebx
	jmp L10
L11:
	movl %r14d,%edi
	call _dupmachine
	movl %eax,%esi
	movl %r12d,%edi
	call _link_machines
	movl %eax,%r12d
	incl %ebx
L10:
	cmpl %ebx,%r13d
	jge L11
L13:
	movl %r12d,%eax
L9:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_dumpnfa:
L15:
	pushq %rbx
	pushq %r12
L16:
	pushq %rdi
	pushq $L18
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%ebx
	jmp L19
L20:
	pushq %rbx
	pushq $L23
	pushq $___stderr
	call _fprintf
	movq _transchar(%rip),%rax
	movl (%rax,%rbx,4),%esi
	movq _trans1(%rip),%rax
	movl (%rax,%rbx,4),%edx
	movq _trans2(%rip),%rax
	movl (%rax,%rbx,4),%ecx
	movq _accptnum(%rip),%rax
	movl (%rax,%rbx,4),%r12d
	pushq %rcx
	pushq %rdx
	pushq %rsi
	pushq $L24
	pushq $___stderr
	call _fprintf
	addq $64,%rsp
	testl %r12d,%r12d
	jz L27
L25:
	pushq %r12
	pushq $L28
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L27:
	pushq $L29
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	incl %ebx
L19:
	cmpl _lastnfa(%rip),%ebx
	jle L20
L22:
	pushq $L30
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L17:
	popq %r12
	popq %rbx
	ret 


_dupmachine:
L31:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L32:
	movl %edi,%ebx
	xorl %r12d,%r12d
	movslq %ebx,%rcx
	movq _lastst(%rip),%rax
	movl (%rax,%rcx,4),%r15d
	movq _firstst(%rip),%rax
	movl (%rax,%rcx,4),%r14d
	jmp L34
L35:
	movslq %r14d,%r14
	movq _transchar(%rip),%rax
	movl (%rax,%r14,4),%edi
	call _mkstate
	movl %eax,%r12d
	movq _trans1(%rip),%rax
	movl (%rax,%r14,4),%esi
	testl %esi,%esi
	jz L40
L38:
	movslq %r12d,%r13
	movq _finalst(%rip),%rax
	addl %r12d,%esi
	subl %r14d,%esi
	movl (%rax,%r13,4),%edi
	call _mkxtion
	movq _transchar(%rip),%rax
	cmpl $257,(%rax,%r14,4)
	jnz L40
L44:
	movq _trans2(%rip),%rax
	movl (%rax,%r14,4),%esi
	testl %esi,%esi
	jz L40
L41:
	movq _finalst(%rip),%rax
	addl %r12d,%esi
	subl %r14d,%esi
	movl (%rax,%r13,4),%edi
	call _mkxtion
L40:
	movq _accptnum(%rip),%rdx
	movl (%rdx,%r14,4),%ecx
	movslq %r12d,%rax
	movl %ecx,(%rdx,%rax,4)
	incl %r14d
L34:
	cmpl %r14d,%r15d
	jge L35
L37:
	testl %r12d,%r12d
	jnz L50
L48:
	movl $L51,%edi
	call _flexfatal
L50:
	subl %r14d,%r12d
	leal 1(%r12,%rbx),%eax
	movslq %ebx,%rbx
	movq _firstst(%rip),%rdx
	movl (%rdx,%rbx,4),%ecx
	leal 1(%r12,%rcx),%ecx
	movslq %eax,%rax
	movl %ecx,(%rdx,%rax,4)
	movq _finalst(%rip),%rdx
	movl (%rdx,%rbx,4),%ecx
	leal 1(%r12,%rcx),%ecx
	movl %ecx,(%rdx,%rax,4)
	movq _lastst(%rip),%rdx
	movl (%rdx,%rbx,4),%ecx
	leal 1(%r12,%rcx),%ecx
	movl %ecx,(%rdx,%rax,4)
L33:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_finish_rule:
L53:
	pushq %rbx
	pushq %r12
	pushq %r13
L54:
	movl %esi,%r13d
	movl %edx,%r12d
	movl %ecx,%ebx
	movl _num_rules(%rip),%esi
	call _add_accept
	movslq _num_rules(%rip),%rdx
	movq _rule_linenum(%rip),%rcx
	movl _linenum(%rip),%eax
	movl %eax,(%rcx,%rdx,4)
	cmpl $0,_continued_action(%rip)
	jz L58
L56:
	movslq _num_rules(%rip),%rcx
	movq _rule_linenum(%rip),%rdx
	decl (%rdx,%rcx,4)
L58:
	movl _num_rules(%rip),%eax
	pushq %rax
	pushq $L59
	pushq _temp_action_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl _num_rules(%rip),%eax
	movq _rule_type(%rip),%rcx
	movslq %eax,%rax
	testl %r13d,%r13d
	jz L61
L60:
	movl $1,(%rcx,%rax,4)
	cmpl $0,_performance_report(%rip)
	jz L65
L63:
	movslq _num_rules(%rip),%rax
	movq _rule_linenum(%rip),%rcx
	movl (%rcx,%rax,4),%eax
	pushq %rax
	pushq $L66
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L65:
	movl $1,_variable_trailing_context_rules(%rip)
	jmp L62
L61:
	movl $0,(%rcx,%rax,4)
	cmpl $0,%r12d
	jg L71
L70:
	cmpl $0,%ebx
	jle L62
L71:
	pushq $L76
	pushq _temp_action_file(%rip)
	call _fprintf
	addq $16,%rsp
	movq _temp_action_file(%rip),%rax
	cmpl $0,%r12d
	jle L78
L77:
	pushq %r12
	pushq $L75
	pushq $L74
	pushq $L80
	pushq %rax
	call _fprintf
	addq $40,%rsp
	jmp L79
L78:
	pushq %rbx
	pushq $L74
	pushq $L81
	pushq %rax
	call _fprintf
	addq $32,%rsp
L79:
	pushq $L82
	pushq _temp_action_file(%rip)
	call _fprintf
	addq $16,%rsp
L62:
	movq _temp_action_file(%rip),%rdi
	call _line_directive_out
L55:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_link_machines:
L83:
	pushq %rbx
	pushq %r12
L84:
	movl %edi,%r12d
	movl %esi,%ebx
	testl %r12d,%r12d
	jnz L87
L86:
	movl %ebx,%eax
	jmp L85
L87:
	testl %ebx,%ebx
	jz L101
L91:
	movslq %r12d,%r12
	movq _finalst(%rip),%rax
	movl %ebx,%esi
	movl (%rax,%r12,4),%edi
	call _mkxtion
	movslq %ebx,%rbx
	movq _finalst(%rip),%rcx
	movl (%rcx,%rbx,4),%eax
	movl %eax,(%rcx,%r12,4)
	movq _lastst(%rip),%rdx
	movl (%rdx,%r12,4),%eax
	movl (%rdx,%rbx,4),%ecx
	cmpl %ecx,%eax
	cmovlel %ecx,%eax
	movl %eax,(%rdx,%r12,4)
	movq _firstst(%rip),%rdx
	movl (%rdx,%r12,4),%eax
	movl (%rdx,%rbx,4),%ecx
	cmpl %ecx,%eax
	cmovgel %ecx,%eax
	movl %eax,(%rdx,%r12,4)
L101:
	movl %r12d,%eax
L85:
	popq %r12
	popq %rbx
	ret 


_mark_beginning_as_normal:
L102:
	pushq %rbx
L103:
	movslq %edi,%rbx
	movq _state_type(%rip),%rcx
	movl (%rcx,%rbx,4),%eax
	cmpl $1,%eax
	jz L104
L124:
	cmpl $2,%eax
	jz L110
L125:
	movl $L121,%edi
	call _flexerror
	jmp L104
L110:
	movl $1,(%rcx,%rbx,4)
	movq _transchar(%rip),%rax
	cmpl $257,(%rax,%rbx,4)
	jnz L104
L111:
	movq _trans1(%rip),%rax
	movl (%rax,%rbx,4),%edi
	testl %edi,%edi
	jz L116
L114:
	call _mark_beginning_as_normal
L116:
	movq _trans2(%rip),%rax
	movl (%rax,%rbx,4),%edi
	testl %edi,%edi
	jz L104
L117:
	call _mark_beginning_as_normal
L104:
	popq %rbx
	ret 


_mkbranch:
L127:
	pushq %rbx
	pushq %r12
	pushq %r13
L128:
	movl %edi,%r13d
	movl %esi,%r12d
	testl %r13d,%r13d
	jnz L131
L130:
	movl %r12d,%eax
	jmp L129
L131:
	testl %r12d,%r12d
	jz L134
L132:
	movl $257,%edi
	call _mkstate
	movl %eax,%ebx
	movl %r13d,%esi
	movl %ebx,%edi
	call _mkxtion
	movl %r12d,%esi
	movl %ebx,%edi
	call _mkxtion
	movl %ebx,%eax
	jmp L129
L134:
	movl %r13d,%eax
L129:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_mkclos:
L139:
L140:
	call _mkposcl
	movl %eax,%edi
	call _mkopt
L141:
	ret 


_mkopt:
L143:
	pushq %rbx
L144:
	movl %edi,%ebx
	movslq %ebx,%rbx
	movq _finalst(%rip),%rax
	movslq (%rax,%rbx,4),%rcx
	movq _transchar(%rip),%rax
	cmpl $257,(%rax,%rcx,4)
	jnz L146
L149:
	movq _trans1(%rip),%rax
	cmpl $0,(%rax,%rcx,4)
	jz L148
L146:
	movl $257,%edi
	call _mkstate
	movl %eax,%esi
	movl %ebx,%edi
	call _link_machines
	movl %eax,%ebx
L148:
	movl $257,%edi
	call _mkstate
	movl %ebx,%esi
	movl %eax,%edi
	call _link_machines
	movl %eax,%ebx
	movslq %ebx,%rbx
	movq _finalst(%rip),%rax
	movl (%rax,%rbx,4),%esi
	movl %ebx,%edi
	call _mkxtion
	movl %ebx,%eax
L145:
	popq %rbx
	ret 


_mkor:
L154:
	pushq %rbx
	pushq %r12
	pushq %r13
L155:
	movl %edi,%ebx
	movl %esi,%r13d
	testl %ebx,%ebx
	jnz L158
L157:
	movl %r13d,%eax
	jmp L156
L158:
	testl %r13d,%r13d
	jz L188
L162:
	movl $257,%edi
	call _mkstate
	movl %ebx,%esi
	movl %eax,%edi
	call _link_machines
	movl %eax,%ebx
	movl %r13d,%esi
	movl %ebx,%edi
	call _mkxtion
	movslq %ebx,%rax
	movq _finalst(%rip),%r8
	movl (%r8,%rax,4),%edi
	movslq %edi,%rdx
	movq _transchar(%rip),%rcx
	cmpl $257,(%rcx,%rdx,4)
	jnz L166
L172:
	movq _trans1(%rip),%rax
	cmpl $0,(%rax,%rdx,4)
	jnz L166
L168:
	movq _accptnum(%rip),%rax
	cmpl $0,(%rax,%rdx,4)
	jnz L166
L165:
	movl %edi,%r12d
	movslq %r13d,%rax
	movl %edi,%esi
	movl (%r8,%rax,4),%edi
	jmp L189
L166:
	movslq %r13d,%r13
	movslq (%r8,%r13,4),%r12
	cmpl $257,(%rcx,%r12,4)
	jnz L177
L183:
	movq _trans1(%rip),%rax
	cmpl $0,(%rax,%r12,4)
	jnz L177
L179:
	movq _accptnum(%rip),%rax
	cmpl $0,(%rax,%r12,4)
	jnz L177
L176:
	movl %r12d,%esi
	jmp L189
L177:
	movl $257,%edi
	call _mkstate
	movl %eax,%esi
	movl %ebx,%edi
	call _link_machines
	movl %eax,%ebx
	movslq %eax,%rax
	movq _finalst(%rip),%rcx
	movl (%rcx,%rax,4),%r12d
	movl %r12d,%esi
	movl (%rcx,%r13,4),%edi
L189:
	call _mkxtion
	movslq %ebx,%rbx
	movq _finalst(%rip),%rax
	movl %r12d,(%rax,%rbx,4)
L188:
	movl %ebx,%eax
L156:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_mkposcl:
L190:
	pushq %rbx
	pushq %r12
L191:
	movl %edi,%ebx
	movslq %ebx,%rbx
	movq _finalst(%rip),%rax
	movl (%rax,%rbx,4),%edi
	movslq %edi,%rcx
	movq _transchar(%rip),%rax
	cmpl $257,(%rax,%rcx,4)
	jnz L194
L196:
	movq _trans1(%rip),%rax
	cmpl $0,(%rax,%rcx,4)
	jnz L194
L193:
	movl %ebx,%esi
	call _mkxtion
	movl %ebx,%eax
	jmp L192
L194:
	movl $257,%edi
	call _mkstate
	movl %eax,%r12d
	movl %ebx,%esi
	movl %r12d,%edi
	call _mkxtion
	movl %r12d,%esi
	movl %ebx,%edi
	call _link_machines
L192:
	popq %r12
	popq %rbx
	ret 


_mkrep:
L202:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L203:
	movl %edi,%r15d
	movl %esi,%ebx
	movl %edx,%r14d
	leal -1(%rbx),%esi
	movl %r15d,%edi
	call _copysingl
	movl %eax,%r13d
	cmpl $-1,%r14d
	jnz L206
L205:
	movl %r15d,%edi
	call _dupmachine
	movl %eax,%edi
	call _mkclos
	movl %eax,%esi
	jmp L213
L206:
	movl $257,%edi
	call _mkstate
	movl %eax,%r12d
	jmp L208
L209:
	movl %r15d,%edi
	call _dupmachine
	movl %r12d,%esi
	movl %eax,%edi
	call _link_machines
	movl %eax,%edi
	call _mkopt
	movl %eax,%r12d
	incl %ebx
L208:
	cmpl %ebx,%r14d
	jg L209
L211:
	movl %r12d,%esi
L213:
	movl %r13d,%edi
	call _link_machines
	movl %eax,%esi
	movl %r15d,%edi
	call _link_machines
L204:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_mkstate:
L214:
	pushq %rbx
L215:
	movl _lastnfa(%rip),%eax
	movl %edi,%ebx
	incl %eax
	movl %eax,_lastnfa(%rip)
	movl _current_mns(%rip),%esi
	cmpl %esi,%eax
	jl L219
L217:
	leal 1000(%rsi),%eax
	movl %eax,_current_mns(%rip)
	cmpl $31999,%eax
	jl L222
L220:
	addl $1000,%esi
	movl $L223,%edi
	call _lerrif
L222:
	incl _num_reallocs(%rip)
	movl $4,%edx
	movl _current_mns(%rip),%esi
	movq _firstst(%rip),%rdi
	call _reallocate_array
	movq %rax,_firstst(%rip)
	movl $4,%edx
	movl _current_mns(%rip),%esi
	movq _lastst(%rip),%rdi
	call _reallocate_array
	movq %rax,_lastst(%rip)
	movl $4,%edx
	movl _current_mns(%rip),%esi
	movq _finalst(%rip),%rdi
	call _reallocate_array
	movq %rax,_finalst(%rip)
	movl $4,%edx
	movl _current_mns(%rip),%esi
	movq _transchar(%rip),%rdi
	call _reallocate_array
	movq %rax,_transchar(%rip)
	movl $4,%edx
	movl _current_mns(%rip),%esi
	movq _trans1(%rip),%rdi
	call _reallocate_array
	movq %rax,_trans1(%rip)
	movl $4,%edx
	movl _current_mns(%rip),%esi
	movq _trans2(%rip),%rdi
	call _reallocate_array
	movq %rax,_trans2(%rip)
	movl $4,%edx
	movl _current_mns(%rip),%esi
	movq _accptnum(%rip),%rdi
	call _reallocate_array
	movq %rax,_accptnum(%rip)
	movl $4,%edx
	movl _current_mns(%rip),%esi
	movq _assoc_rule(%rip),%rdi
	call _reallocate_array
	movq %rax,_assoc_rule(%rip)
	movl $4,%edx
	movl _current_mns(%rip),%esi
	movq _state_type(%rip),%rdi
	call _reallocate_array
	movq %rax,_state_type(%rip)
L219:
	movslq _lastnfa(%rip),%rax
	movq _firstst(%rip),%rcx
	movl %eax,(%rcx,%rax,4)
	movslq _lastnfa(%rip),%rax
	movq _finalst(%rip),%rcx
	movl %eax,(%rcx,%rax,4)
	movslq _lastnfa(%rip),%rax
	movq _lastst(%rip),%rcx
	movl %eax,(%rcx,%rax,4)
	movslq _lastnfa(%rip),%rax
	movq _transchar(%rip),%rcx
	movl %ebx,(%rcx,%rax,4)
	movslq _lastnfa(%rip),%rax
	movq _trans1(%rip),%rcx
	movl $0,(%rcx,%rax,4)
	movslq _lastnfa(%rip),%rax
	movq _trans2(%rip),%rcx
	movl $0,(%rcx,%rax,4)
	movslq _lastnfa(%rip),%rax
	movq _accptnum(%rip),%rcx
	movl $0,(%rcx,%rax,4)
	movslq _lastnfa(%rip),%rcx
	movq _assoc_rule(%rip),%rdx
	movl _num_rules(%rip),%eax
	movl %eax,(%rdx,%rcx,4)
	movslq _lastnfa(%rip),%rcx
	movq _state_type(%rip),%rdx
	movl _current_state_type(%rip),%eax
	movl %eax,(%rdx,%rcx,4)
	cmpl $0,%ebx
	jl L226
L225:
	cmpl $257,%ebx
	jnz L228
L227:
	incl _numeps(%rip)
	jmp L226
L228:
	cmpl $0,_useecs(%rip)
	jz L226
L230:
	testl %ebx,%ebx
	jz L234
L233:
	movl %ebx,%edi
	jmp L235
L234:
	movl _csize(%rip),%edi
L235:
	movl $_ecgroup,%edx
	movl $_nextecm,%esi
	call _mkechar
L226:
	movl _lastnfa(%rip),%eax
L216:
	popq %rbx
	ret 


_mkxtion:
L237:
L238:
	movslq %edi,%rdx
	movq _trans1(%rip),%rax
	cmpl $0,(%rax,%rdx,4)
	jnz L241
L240:
	movl %esi,(%rax,%rdx,4)
	ret
L241:
	movq _transchar(%rip),%rax
	cmpl $257,(%rax,%rdx,4)
	jnz L243
L246:
	movq _trans2(%rip),%rcx
	cmpl $0,(%rcx,%rdx,4)
	jz L244
L243:
	movl $L250,%edi
	call _flexfatal
	ret
L244:
	incl _eps2(%rip)
	movl %esi,(%rcx,%rdx,4)
L239:
	ret 


_new_rule:
L251:
L252:
	movl _num_rules(%rip),%eax
	incl %eax
	movl %eax,_num_rules(%rip)
	movl _current_max_rules(%rip),%esi
	cmpl %esi,%eax
	jl L256
L254:
	incl _num_reallocs(%rip)
	leal 100(%rsi),%eax
	movl %eax,_current_max_rules(%rip)
	movl $4,%edx
	addl $100,%esi
	movq _rule_type(%rip),%rdi
	call _reallocate_array
	movq %rax,_rule_type(%rip)
	movl $4,%edx
	movl _current_max_rules(%rip),%esi
	movq _rule_linenum(%rip),%rdi
	call _reallocate_array
	movq %rax,_rule_linenum(%rip)
L256:
	cmpl $8191,_num_rules(%rip)
	jle L259
L257:
	movl $8191,%esi
	movl $L260,%edi
	call _lerrif
L259:
	movslq _num_rules(%rip),%rcx
	movq _rule_linenum(%rip),%rdx
	movl _linenum(%rip),%eax
	movl %eax,(%rdx,%rcx,4)
L253:
	ret 

L30:
	.byte 42,42,42,42,42,42,42,42
	.byte 42,42,32,101,110,100,32,111
	.byte 102,32,100,117,109,112,10,0
L18:
	.byte 10,10,42,42,42,42,42,42
	.byte 42,42,42,42,32,98,101,103
	.byte 105,110,110,105,110,103,32,100
	.byte 117,109,112,32,111,102,32,110
	.byte 102,97,32,119,105,116,104,32
	.byte 115,116,97,114,116,32,115,116
	.byte 97,116,101,32,37,100,10,0
L81:
	.byte 37,115,32,45,61,32,37,100
	.byte 59,10,0
L75:
	.byte 121,121,95,98,112,0
L23:
	.byte 115,116,97,116,101,32,35,32
	.byte 37,52,100,9,0
L223:
	.byte 105,110,112,117,116,32,114,117
	.byte 108,101,115,32,97,114,101,32
	.byte 116,111,111,32,99,111,109,112
	.byte 108,105,99,97,116,101,100,32
	.byte 40,62,61,32,37,100,32,78
	.byte 70,65,32,115,116,97,116,101
	.byte 115,41,0
L66:
	.byte 86,97,114,105,97,98,108,101
	.byte 32,116,114,97,105,108,105,110
	.byte 103,32,99,111,110,116,101,120
	.byte 116,32,114,117,108,101,32,97
	.byte 116,32,108,105,110,101,32,37
	.byte 100,10,0
L29:
	.byte 10,0
L74:
	.byte 121,121,95,99,95,98,117,102
	.byte 95,112,32,61,32,121,121,95
	.byte 99,112,0
L260:
	.byte 116,111,111,32,109,97,110,121
	.byte 32,114,117,108,101,115,32,40
	.byte 62,32,37,100,41,33,0
L51:
	.byte 101,109,112,116,121,32,109,97
	.byte 99,104,105,110,101,32,105,110
	.byte 32,100,117,112,109,97,99,104
	.byte 105,110,101,40,41,0
L59:
	.byte 99,97,115,101,32,37,100,58
	.byte 10,0
L80:
	.byte 37,115,32,61,32,37,115,32
	.byte 43,32,37,100,59,10,0
L121:
	.byte 98,97,100,32,115,116,97,116
	.byte 101,32,116,121,112,101,32,105
	.byte 110,32,109,97,114,107,95,98
	.byte 101,103,105,110,110,105,110,103
	.byte 95,97,115,95,110,111,114,109
	.byte 97,108,40,41,0
L250:
	.byte 102,111,117,110,100,32,116,111
	.byte 111,32,109,97,110,121,32,116
	.byte 114,97,110,115,105,116,105,111
	.byte 110,115,32,105,110,32,109,107
	.byte 120,116,105,111,110,40,41,0
L76:
	.byte 42,121,121,95,99,112,32,61
	.byte 32,121,121,95,104,111,108,100
	.byte 95,99,104,97,114,59,32,47
	.byte 42,32,117,110,100,111,32,101
	.byte 102,102,101,99,116,115,32,111
	.byte 102,32,115,101,116,116,105,110
	.byte 103,32,117,112,32,121,121,116
	.byte 101,120,116,32,42,47,10,0
L24:
	.byte 37,51,100,58,32,32,37,52
	.byte 100,44,32,37,52,100,0
L82:
	.byte 89,89,95,68,79,95,66,69
	.byte 70,79,82,69,95,65,67,84
	.byte 73,79,78,59,32,47,42,32
	.byte 115,101,116,32,117,112,32,121
	.byte 121,116,101,120,116,32,97,103
	.byte 97,105,110,32,42,47,10,0
L28:
	.byte 32,32,91,37,100,93,0

.globl _assoc_rule
.globl _firstst
.globl _finalst
.globl _current_max_rules
.globl _mkclos
.globl _trans2
.globl _num_rules
.globl _mkopt
.globl _csize
.globl _useecs
.globl _variable_trailing_context_rules
.globl _performance_report
.globl _dupmachine
.globl _add_accept
.globl _temp_action_file
.globl _rule_linenum
.globl _num_reallocs
.globl _mkxtion
.globl _current_mns
.globl _mkbranch
.globl _state_type
.globl _continued_action
.globl _mkrep
.globl _link_machines
.globl _flexfatal
.globl _line_directive_out
.globl _mark_beginning_as_normal
.globl _lastnfa
.globl _dumpnfa
.globl _ecgroup
.globl _numeps
.globl _transchar
.globl _lastst
.globl _mkstate
.globl ___stderr
.globl _reallocate_array
.globl _linenum
.globl _nextecm
.globl _accptnum
.globl _mkposcl
.globl _mkechar
.globl _trans1
.globl _copysingl
.globl _new_rule
.globl _lerrif
.globl _flexerror
.globl _rule_type
.globl _mkor
.globl _current_state_type
.globl _finish_rule
.globl _fprintf
.globl _eps2
