.text

_check_for_backtracking:
L1:
	pushq %rbx
	pushq %r12
L2:
	movl %edi,%r12d
	movq %rsi,%rbx
	cmpl $0,_reject(%rip)
	jz L7
L11:
	movslq %r12d,%rcx
	movq _dfaacc(%rip),%rax
	cmpq $0,(%rax,%rcx,8)
	jz L4
L7:
	movslq %r12d,%r12
	movq _dfaacc(%rip),%rax
	cmpl $0,(%rax,%r12,8)
	jnz L3
L4:
	incl _num_backtracking(%rip)
	cmpl $0,_backtrack_report(%rip)
	jz L3
L15:
	pushq %r12
	pushq $L18
	pushq _backtrack_file(%rip)
	call _fprintf
	addq $24,%rsp
	movl %r12d,%esi
	movq _backtrack_file(%rip),%rdi
	call _dump_associated_rules
	movq %rbx,%rsi
	movq _backtrack_file(%rip),%rdi
	call _dump_transitions
	movq _backtrack_file(%rip),%rcx
	decl (%rcx)
	movq _backtrack_file(%rip),%rsi
	js L20
L19:
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb $10,(%rcx)
	jmp L3
L20:
	movl $10,%edi
	call ___flushbuf
L3:
	popq %r12
	popq %rbx
	ret 


_check_trailing_context:
L22:
L23:
	movl $1,%r10d
L25:
	cmpl %r10d,%esi
	jl L24
L26:
	movslq %r10d,%r10
	movslq (%rdi,%r10,4),%r8
	movq _state_type(%rip),%rax
	movl (%rax,%r8,4),%r9d
	movq _assoc_rule(%rip),%rax
	movl (%rax,%r8,4),%r8d
	cmpl $1,%r9d
	jz L31
L32:
	movslq %r8d,%r8
	movq _rule_type(%rip),%rax
	cmpl $1,(%rax,%r8,4)
	jnz L31
L30:
	cmpl $2,%r9d
	jnz L31
L36:
	movl $1,%eax
L39:
	cmpl %eax,%ecx
	jl L31
L40:
	movslq %eax,%rax
	testl $16384,(%rdx,%rax,4)
	jnz L43
L45:
	incl %eax
	jmp L39
L43:
	movslq %r8d,%rcx
	movq _rule_linenum(%rip),%rax
	movl (%rax,%rcx,4),%eax
	pushq %rax
	pushq _program_name(%rip)
	pushq $L46
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	ret
L31:
	incl %r10d
	jmp L25
L24:
	ret 


_dump_associated_rules:
L48:
	pushq %rbp
	movq %rsp,%rbp
	subq $408,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L49:
	movq %rdi,%r12
	xorl %ebx,%ebx
	movslq %esi,%rdx
	movq _dss(%rip),%rax
	movq (%rax,%rdx,8),%rax
	movq _dfasiz(%rip),%rcx
	movl (%rcx,%rdx,4),%edi
	movl $1,%esi
L51:
	movl $1,%r13d
	cmpl %esi,%edi
	jl L54
L52:
	movslq %esi,%rsi
	movslq (%rax,%rsi,4),%rdx
	movq _assoc_rule(%rip),%rcx
	movslq (%rcx,%rdx,4),%rdx
	movq _rule_linenum(%rip),%rcx
	movl (%rcx,%rdx,4),%edx
L55:
	cmpl %r13d,%ebx
	jl L58
L56:
	movslq %r13d,%r13
	cmpl -404(%rbp,%r13,4),%edx
	jz L58
L61:
	incl %r13d
	jmp L55
L58:
	cmpl %r13d,%ebx
	jge L65
L63:
	cmpl $100,%ebx
	jge L65
L66:
	incl %ebx
	movslq %ebx,%rcx
	movl %edx,-404(%rbp,%rcx,4)
L65:
	incl %esi
	jmp L51
L54:
	movl %ebx,%esi
	leaq -404(%rbp),%rdi
	call _bubble
	pushq $L69
	pushq %r12
	call _fprintf
	addq $16,%rsp
L70:
	cmpl %r13d,%ebx
	jl L73
L71:
	movl $8,%ecx
	movl %r13d,%eax
	cltd 
	idivl %ecx
	cmpl $1,%edx
	jnz L76
L74:
	decl (%r12)
	js L78
L77:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movb $10,(%rcx)
	jmp L76
L78:
	movq %r12,%rsi
	movl $10,%edi
	call ___flushbuf
L76:
	movslq %r13d,%rax
	movl -404(%rbp,%rax,4),%eax
	pushq %rax
	pushq $L80
	pushq %r12
	call _fprintf
	addq $24,%rsp
	incl %r13d
	jmp L70
L73:
	decl (%r12)
	js L82
L81:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movb $10,(%rcx)
	jmp L50
L82:
	movq %r12,%rsi
	movl $10,%edi
	call ___flushbuf
L50:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_dump_transitions:
L84:
	pushq %rbp
	movq %rsp,%rbp
	subq $1024,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L85:
	movq %rdi,%r13
	movq %rsi,%r12
	xorl %ebx,%ebx
L87:
	cmpl _csize(%rip),%ebx
	jge L90
L88:
	movslq %ebx,%rbx
	movl _ecgroup(,%rbx,4),%edi
	call _abs
	movslq %eax,%rax
	movl (%r12,%rax,4),%eax
	movl %eax,-1024(%rbp,%rbx,4)
	incl %ebx
	jmp L87
L90:
	pushq $L91
	pushq %r13
	call _fprintf
	addq $16,%rsp
	leaq -1024(%rbp),%rsi
	movq %r13,%rdi
	call _list_character_set
	xorl %ecx,%ecx
L92:
	cmpl _csize(%rip),%ecx
	jge L95
L93:
	movslq %ecx,%rcx
	cmpl $0,-1024(%rbp,%rcx,4)
	setz %al
	movzbl %al,%eax
	movl %eax,-1024(%rbp,%rcx,4)
	incl %ecx
	jmp L92
L95:
	pushq $L96
	pushq %r13
	call _fprintf
	addq $16,%rsp
	leaq -1024(%rbp),%rsi
	movq %r13,%rdi
	call _list_character_set
	decl (%r13)
	js L98
L97:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movb $10,(%rcx)
	jmp L86
L98:
	movq %r13,%rsi
	movl $10,%edi
	call ___flushbuf
L86:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 4
L103:
	.int 0
.local L104
.comm L104, 8, 8
.text

_epsclosure:
L100:
	pushq %rbp
	movq %rsp,%rbp
	subq $56,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L101:
	movq %rdi,%r15
	movl (%rsi),%eax
	movl %eax,-36(%rbp)
	movq %rsi,-8(%rbp)
	movq %rdx,-32(%rbp)
	movq %rcx,-16(%rbp)
	movq %r8,-24(%rbp)
	movl -36(%rbp),%r14d
	cmpl $0,L103(%rip)
	jnz L107
L105:
	movl $4,%esi
	movl _current_max_dfa_size(%rip),%edi
	call _allocate_array
	movq %rax,L104(%rip)
	movl $1,L103(%rip)
L107:
	movl $0,-48(%rbp)
	xorl %r12d,%r12d
	movl $0,-44(%rbp)
	movl $1,%r13d
L108:
	cmpl %r13d,-36(%rbp)
	jl L111
L109:
	movslq %r13d,%r13
	movslq (%r15,%r13,4),%rbx
	movq _trans1(%rip),%rax
	cmpl $0,(%rax,%rbx,4)
	jl L114
L112:
	movl _current_max_dfa_size(%rip),%esi
	incl %r12d
	cmpl %r12d,%esi
	jg L117
L115:
	leal 750(%rsi),%eax
	movl %eax,_current_max_dfa_size(%rip)
	incl _num_reallocs(%rip)
	movl $4,%edx
	addl $750,%esi
	movq %r15,%rdi
	call _reallocate_array
	movq %rax,%r15
	movl $4,%edx
	movl _current_max_dfa_size(%rip),%esi
	movq L104(%rip),%rdi
	call _reallocate_array
	movq %rax,L104(%rip)
L117:
	movslq %r12d,%rax
	movq L104(%rip),%rcx
	movl %ebx,(%rcx,%rax,4)
	movq _trans1(%rip),%rax
	subl $32000,(%rax,%rbx,4)
L114:
	movq _accptnum(%rip),%rax
	movl (%rax,%rbx,4),%edx
	testl %edx,%edx
	jz L120
L118:
	movl -44(%rbp),%ecx
	incl %ecx
	movl %ecx,-44(%rbp)
	movslq %ecx,%rcx
	movq -32(%rbp),%rax
	movl %edx,(%rax,%rcx,4)
L120:
	addl -48(%rbp),%ebx
	movl %ebx,-48(%rbp)
	incl %r13d
	jmp L108
L111:
	movl $1,-40(%rbp)
L121:
	cmpl -40(%rbp),%r12d
	jl L124
L122:
	movslq -40(%rbp),%rax
	movq L104(%rip),%rcx
	movslq (%rcx,%rax,4),%r13
	movq _transchar(%rip),%rax
	cmpl $257,(%rax,%r13,4)
	jnz L127
L125:
	movq _trans1(%rip),%rcx
	movl (%rcx,%r13,4),%eax
	leal 32000(%rax),%ebx
	movl %eax,-52(%rbp)
	testl %ebx,%ebx
	jz L127
L128:
	movslq %ebx,%rbx
	cmpl $0,(%rcx,%rbx,4)
	jl L133
L131:
	movl _current_max_dfa_size(%rip),%esi
	incl %r12d
	cmpl %r12d,%esi
	jg L136
L134:
	leal 750(%rsi),%eax
	movl %eax,_current_max_dfa_size(%rip)
	incl _num_reallocs(%rip)
	movl $4,%edx
	addl $750,%esi
	movq %r15,%rdi
	call _reallocate_array
	movq %rax,%r15
	movl $4,%edx
	movl _current_max_dfa_size(%rip),%esi
	movq L104(%rip),%rdi
	call _reallocate_array
	movq %rax,L104(%rip)
L136:
	movslq %r12d,%rax
	movq L104(%rip),%rcx
	movl %ebx,(%rcx,%rax,4)
	movq _trans1(%rip),%rax
	subl $32000,(%rax,%rbx,4)
	movq _accptnum(%rip),%rax
	movl (%rax,%rbx,4),%edx
	testl %edx,%edx
	jz L139
L137:
	movl -44(%rbp),%ecx
	incl %ecx
	movl %ecx,-44(%rbp)
	movslq %ecx,%rcx
	movq -32(%rbp),%rax
	movl %edx,(%rax,%rcx,4)
L139:
	testl %edx,%edx
	jnz L144
L143:
	movq _transchar(%rip),%rax
	cmpl $257,(%rax,%rbx,4)
	jz L133
L144:
	movl _current_max_dfa_size(%rip),%esi
	incl %r14d
	cmpl %r14d,%esi
	jg L149
L147:
	leal 750(%rsi),%eax
	movl %eax,_current_max_dfa_size(%rip)
	incl _num_reallocs(%rip)
	movl $4,%edx
	addl $750,%esi
	movq %r15,%rdi
	call _reallocate_array
	movq %rax,%r15
	movl $4,%edx
	movl _current_max_dfa_size(%rip),%esi
	movq L104(%rip),%rdi
	call _reallocate_array
	movq %rax,L104(%rip)
L149:
	movslq %r14d,%r14
	movl %ebx,(%r15,%r14,4)
	movl -48(%rbp),%ecx
	movl -52(%rbp),%eax
	leal 32000(%rax,%rcx),%eax
	movl %eax,-48(%rbp)
L133:
	movq _trans2(%rip),%rax
	movl (%rax,%r13,4),%r13d
	testl %r13d,%r13d
	jz L127
L150:
	movslq %r13d,%r13
	movq _trans1(%rip),%rax
	cmpl $0,(%rax,%r13,4)
	jl L127
L153:
	movl _current_max_dfa_size(%rip),%esi
	incl %r12d
	cmpl %r12d,%esi
	jg L158
L156:
	leal 750(%rsi),%eax
	movl %eax,_current_max_dfa_size(%rip)
	incl _num_reallocs(%rip)
	movl $4,%edx
	addl $750,%esi
	movq %r15,%rdi
	call _reallocate_array
	movq %rax,%r15
	movl $4,%edx
	movl _current_max_dfa_size(%rip),%esi
	movq L104(%rip),%rdi
	call _reallocate_array
	movq %rax,L104(%rip)
L158:
	movslq %r12d,%r12
	movq L104(%rip),%rax
	movl %r13d,(%rax,%r12,4)
	movq _trans1(%rip),%rax
	subl $32000,(%rax,%r13,4)
	movq _accptnum(%rip),%rax
	movl (%rax,%r13,4),%edx
	testl %edx,%edx
	jz L161
L159:
	movl -44(%rbp),%ecx
	incl %ecx
	movl %ecx,-44(%rbp)
	movslq %ecx,%rcx
	movq -32(%rbp),%rax
	movl %edx,(%rax,%rcx,4)
L161:
	testl %edx,%edx
	jnz L166
L165:
	movq _transchar(%rip),%rax
	cmpl $257,(%rax,%r13,4)
	jz L127
L166:
	movl _current_max_dfa_size(%rip),%esi
	leal 1(%r14),%ebx
	movl %ebx,%r14d
	cmpl %ebx,%esi
	jg L171
L169:
	leal 750(%rsi),%eax
	movl %eax,_current_max_dfa_size(%rip)
	incl _num_reallocs(%rip)
	movl $4,%edx
	addl $750,%esi
	movq %r15,%rdi
	call _reallocate_array
	movq %rax,%r15
	movl $4,%edx
	movl _current_max_dfa_size(%rip),%esi
	movq L104(%rip),%rdi
	call _reallocate_array
	movq %rax,L104(%rip)
L171:
	movslq %ebx,%rbx
	movl %r13d,(%r15,%rbx,4)
	addl -48(%rbp),%r13d
	movl %r13d,-48(%rbp)
L127:
	incl -40(%rbp)
	jmp L121
L124:
	movl $1,%ebx
L172:
	cmpl %ebx,%r12d
	jl L175
L173:
	movslq %ebx,%rbx
	movq L104(%rip),%rax
	movslq (%rax,%rbx,4),%rcx
	movq _trans1(%rip),%rdx
	movl (%rdx,%rcx,4),%eax
	cmpl $0,%eax
	jge L177
L176:
	addl $32000,%eax
	movl %eax,(%rdx,%rcx,4)
	jmp L178
L177:
	movl $L179,%edi
	call _flexfatal
L178:
	incl %ebx
	jmp L172
L175:
	movq -8(%rbp),%rax
	movl %r14d,(%rax)
	movq -24(%rbp),%rcx
	movl -48(%rbp),%eax
	movl %eax,(%rcx)
	movq -16(%rbp),%rcx
	movl -44(%rbp),%eax
	movl %eax,(%rcx)
	movq %r15,%rax
L102:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_increase_max_dfas:
L181:
L182:
	movl _current_max_dfas(%rip),%esi
	leal 1000(%rsi),%eax
	movl %eax,_current_max_dfas(%rip)
	incl _num_reallocs(%rip)
	movl $4,%edx
	addl $1000,%esi
	movq _base(%rip),%rdi
	call _reallocate_array
	movq %rax,_base(%rip)
	movl $4,%edx
	movl _current_max_dfas(%rip),%esi
	movq _def(%rip),%rdi
	call _reallocate_array
	movq %rax,_def(%rip)
	movl $4,%edx
	movl _current_max_dfas(%rip),%esi
	movq _dfasiz(%rip),%rdi
	call _reallocate_array
	movq %rax,_dfasiz(%rip)
	movl $4,%edx
	movl _current_max_dfas(%rip),%esi
	movq _accsiz(%rip),%rdi
	call _reallocate_array
	movq %rax,_accsiz(%rip)
	movl $4,%edx
	movl _current_max_dfas(%rip),%esi
	movq _dhash(%rip),%rdi
	call _reallocate_array
	movq %rax,_dhash(%rip)
	movl $8,%edx
	movl _current_max_dfas(%rip),%esi
	movq _dss(%rip),%rdi
	call _reallocate_array
	movq %rax,_dss(%rip)
	movl $8,%edx
	movl _current_max_dfas(%rip),%esi
	movq _dfaacc(%rip),%rdi
	call _reallocate_array
	movq %rax,_dfaacc(%rip)
	movq _nultrans(%rip),%rdi
	testq %rdi,%rdi
	jz L183
L184:
	movl $4,%edx
	movl _current_max_dfas(%rip),%esi
	call _reallocate_array
	movq %rax,_nultrans(%rip)
L183:
	ret 


_ntod:
L187:
	pushq %rbp
	movq %rsp,%rbp
	subq $5208,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L188:
	cmpl $0,_fullspd(%rip)
	jz L192
L190:
	movl $0,_firstfree(%rip)
L192:
	movl _num_rules(%rip),%eax
	movl $4,%esi
	leal 1(%rax),%edi
	call _allocate_array
	movq %rax,-5208(%rbp)
	movl $4,%esi
	movl _current_max_dfa_size(%rip),%edi
	call _allocate_array
	movq %rax,%r15
	movl $0,-5180(%rbp)
	movl $0,-5168(%rbp)
	xorl %eax,%eax
L193:
	cmpl _csize(%rip),%eax
	jg L196
L194:
	movslq %eax,%rax
	movl $0,-1028(%rbp,%rax,4)
	movl $0,-2056(%rbp,%rax,4)
	incl %eax
	jmp L193
L196:
	xorl %ecx,%ecx
L197:
	cmpl %ecx,_num_rules(%rip)
	jl L200
L198:
	movslq %ecx,%rcx
	movq -5208(%rbp),%rax
	movl $0,(%rax,%rcx,4)
	incl %ecx
	jmp L197
L200:
	cmpl $0,_trace(%rip)
	jz L203
L201:
	movq _scset(%rip),%rax
	movl 4(%rax),%edi
	call _dumpnfa
	movl $___stderr,%esi
	movl $L204,%edi
	call _fputs
L203:
	call _inittbl
	cmpl $0,_fullspd(%rip)
	jnz L207
L208:
	movl _ecgroup(%rip),%ecx
	movl _numecs(%rip),%eax
	cmpl %eax,%ecx
	jnz L207
L209:
	cmpl %eax,_csize(%rip)
	setz %al
	movzbl %al,%ecx
	cmpl $0,_fulltbl(%rip)
	jz L214
L215:
	testl %ecx,%ecx
	jnz L214
L216:
	movl $1,%eax
L219:
	cmpl %eax,_csize(%rip)
	jl L214
L220:
	cmpl %eax,_numecs(%rip)
	jz L227
L225:
	shll $1,%eax
	jmp L219
L214:
	testl %ecx,%ecx
	jz L207
L227:
	movl $4,%esi
	movl _current_max_dfas(%rip),%edi
	call _allocate_array
	movq %rax,_nultrans(%rip)
L207:
	cmpl $0,_fullspd(%rip)
	jz L231
L230:
	xorl %eax,%eax
L233:
	cmpl _numecs(%rip),%eax
	jg L236
L234:
	movslq %eax,%rax
	movl $0,-3084(%rbp,%rax,4)
	incl %eax
	jmp L233
L236:
	xorl %edx,%edx
	xorl %esi,%esi
	leaq -3084(%rbp),%rdi
	call _place_state
	jmp L232
L231:
	cmpl $0,_fulltbl(%rip)
	jz L232
L237:
	movq _nultrans(%rip),%rcx
	movl _numecs(%rip),%eax
	testq %rcx,%rcx
	jnz L366
L241:
	incl %eax
L366:
	pushq %rax
	movl %eax,-5172(%rbp)
	pushq $L243
	call _printf
	addq $16,%rsp
	xorl %ebx,%ebx
L244:
	cmpl -5172(%rbp),%ebx
	jge L247
L245:
	xorl %edi,%edi
	call _mk2data
	incl %ebx
	jmp L244
L247:
	movl $10,_datapos(%rip)
	movl $10,_dataline(%rip)
L232:
	movl _lastsc(%rip),%eax
	movl %eax,-5184(%rbp)
	movl %eax,-5176(%rbp)
	movl -5184(%rbp),%eax
	shll $1,%eax
	movl %eax,-5164(%rbp)
	movl %eax,-5184(%rbp)
	movl $1,%r12d
L248:
	cmpl -5184(%rbp),%r12d
	jg L251
L249:
	movl $1,-3088(%rbp)
	movl $2,%ecx
	movl %r12d,%eax
	cltd 
	idivl %ecx
	movl %edx,%esi
	movl $2,%ecx
	movl %r12d,%eax
	cltd 
	idivl %ecx
	movq _scset(%rip),%rcx
	cmpl $1,%esi
	jnz L253
L252:
	incl %eax
	movslq %eax,%rax
	movl (%rcx,%rax,4),%eax
	movl %eax,4(%r15)
	jmp L254
L253:
	movslq %eax,%rax
	movq _scbol(%rip),%rdx
	movl (%rdx,%rax,4),%edx
	movl (%rcx,%rax,4),%esi
	movl %edx,%edi
	call _mkbranch
	movslq -3088(%rbp),%rcx
	movl %eax,(%r15,%rcx,4)
L254:
	leaq -3096(%rbp),%r8
	leaq -3092(%rbp),%rcx
	movq -5208(%rbp),%rdx
	leaq -3088(%rbp),%rsi
	movq %r15,%rdi
	call _epsclosure
	movq %rax,%rbx
	movq %rbx,%r15
	movl -3088(%rbp),%esi
	movl -3092(%rbp),%eax
	leaq -3100(%rbp),%r9
	movl -3096(%rbp),%r8d
	movl %eax,%ecx
	movq -5208(%rbp),%rdx
	movq %rbx,%rdi
	call _snstods
	testl %eax,%eax
	jz L257
L255:
	movl -3092(%rbp),%eax
	addl %eax,_numas(%rip)
	movl -3088(%rbp),%esi
	addl %esi,_totnst(%rip)
	incl -5180(%rbp)
	cmpl $0,_variable_trailing_context_rules(%rip)
	jz L257
L261:
	cmpl $0,%eax
	jle L257
L262:
	movl %eax,%ecx
	movq -5208(%rbp),%rdx
	movq %rbx,%rdi
	call _check_trailing_context
L257:
	incl %r12d
	jmp L248
L251:
	cmpl $0,_fullspd(%rip)
	jnz L272
L265:
	movl $_end_of_buffer_state,%r9d
	xorl %r8d,%r8d
	xorl %ecx,%ecx
	movq -5208(%rbp),%rdx
	xorl %esi,%esi
	movq %r15,%rdi
	call _snstods
	testl %eax,%eax
	jnz L270
L268:
	movl $L271,%edi
	call _flexfatal
L270:
	incl _numas(%rip)
	movl -5176(%rbp),%eax
	leal 1(,%rax,2),%eax
	movl %eax,-5164(%rbp)
	incl -5180(%rbp)
L272:
	movl -5180(%rbp),%eax
	cmpl -5168(%rbp),%eax
	jle L274
L273:
	xorl %r14d,%r14d
	xorl %r13d,%r13d
	movl $1,%eax
L275:
	cmpl _numecs(%rip),%eax
	jg L278
L276:
	movslq %eax,%rax
	movl $0,-3084(%rbp,%rax,4)
	incl %eax
	jmp L275
L278:
	movl -5168(%rbp),%ecx
	incl %ecx
	movl %ecx,-5168(%rbp)
	movl %ecx,-3100(%rbp)
	movslq %ecx,%rcx
	movq _dss(%rip),%rax
	movq (%rax,%rcx,8),%rax
	movq %rax,-5192(%rbp)
	movq _dfasiz(%rip),%rax
	movl (%rax,%rcx,4),%eax
	movl %eax,-5196(%rbp)
	cmpl $0,_trace(%rip)
	jz L281
L279:
	pushq %rcx
	pushq $L282
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L281:
	leaq -1028(%rbp),%rcx
	leaq -2056(%rbp),%rdx
	movl -5196(%rbp),%esi
	movq -5192(%rbp),%rdi
	call _sympartition
	movl $1,%r12d
L283:
	cmpl %r12d,_numecs(%rip)
	jl L286
L284:
	movslq %r12d,%r12
	cmpl $0,-2056(%rbp,%r12,4)
	jz L289
L287:
	movl $0,-2056(%rbp,%r12,4)
	movl -1028(%rbp,%r12,4),%eax
	testl %eax,%eax
	jnz L291
L290:
	movq %r15,%rcx
	movl %r12d,%edx
	movl -5196(%rbp),%esi
	movq -5192(%rbp),%rdi
	call _symfollowset
	movl %eax,-3088(%rbp)
	leaq -3096(%rbp),%r8
	leaq -3092(%rbp),%rcx
	movq -5208(%rbp),%rdx
	leaq -3088(%rbp),%rsi
	movq %r15,%rdi
	call _epsclosure
	movq %rax,%r15
	movl -3088(%rbp),%esi
	movl -3092(%rbp),%eax
	leaq -3104(%rbp),%r9
	movl -3096(%rbp),%r8d
	movl %eax,%ecx
	movq -5208(%rbp),%rdx
	movq %r15,%rdi
	call _snstods
	testl %eax,%eax
	jz L295
L293:
	movl -3088(%rbp),%esi
	addl %esi,_totnst(%rip)
	incl -5180(%rbp)
	movl -3092(%rbp),%eax
	addl %eax,_numas(%rip)
	cmpl $0,_variable_trailing_context_rules(%rip)
	jz L295
L299:
	cmpl $0,%eax
	jle L295
L300:
	movl %eax,%ecx
	movq -5208(%rbp),%rdx
	movq %r15,%rdi
	call _check_trailing_context
L295:
	movl -3104(%rbp),%eax
	movl %eax,-3084(%rbp,%r12,4)
	cmpl $0,_trace(%rip)
	jz L305
L303:
	movl -3104(%rbp),%eax
	pushq %rax
	pushq %r12
	pushq $L306
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L305:
	leal 1(%r14),%eax
	movl %eax,%r14d
	movslq %eax,%rax
	movl $1,-4132(%rbp,%rax,4)
	movl -3104(%rbp),%ecx
	movl %ecx,-5160(%rbp,%rax,4)
	incl _numuniq(%rip)
	jmp L292
L291:
	movslq %eax,%rax
	movl -3084(%rbp,%rax,4),%ebx
	movl %ebx,-3084(%rbp,%r12,4)
	cmpl $0,_trace(%rip)
	jz L309
L307:
	pushq %rbx
	pushq %r12
	pushq $L306
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L309:
	xorl %ecx,%ecx
L310:
	leal 1(%rcx),%eax
	movl %eax,%ecx
	movslq %eax,%rax
	cmpl -5160(%rbp,%rax,4),%ebx
	jnz L310
L312:
	incl -4132(%rbp,%rax,4)
	incl _numdup(%rip)
L292:
	leal 1(%r13),%eax
	movl %eax,%r13d
	movslq %r12d,%rax
	movl $0,-1028(%rbp,%rax,4)
L289:
	leal 1(%r12),%eax
	movl %eax,%r12d
	jmp L283
L286:
	addl %r13d,_numsnpairs(%rip)
	cmpl $0,_caseins(%rip)
	jz L315
L316:
	cmpl $0,_useecs(%rip)
	jnz L315
L317:
	movl $65,%eax
	movl $97,%edx
L321:
	movslq %edx,%rdx
	movl -3084(%rbp,%rdx,4),%ecx
	movslq %eax,%rax
	movl %ecx,-3084(%rbp,%rax,4)
	incl %eax
	incl %edx
	cmpl $90,%eax
	jle L321
L315:
	movl -3100(%rbp),%eax
	cmpl %eax,-5164(%rbp)
	jge L326
L324:
	leaq -3084(%rbp),%rsi
	movl %eax,%edi
	call _check_for_backtracking
L326:
	movq _nultrans(%rip),%rdx
	testq %rdx,%rdx
	jz L329
L327:
	movslq _NUL_ec(%rip),%rax
	movl -3084(%rbp,%rax,4),%ecx
	movslq -3100(%rbp),%rax
	movl %ecx,(%rdx,%rax,4)
	movslq _NUL_ec(%rip),%rax
	movl $0,-3084(%rbp,%rax,4)
L329:
	movl _fulltbl(%rip),%ecx
	movl -3100(%rbp),%eax
	testl %ecx,%ecx
	jz L331
L330:
	movl _end_of_buffer_state(%rip),%ecx
	cmpl %eax,%ecx
	jnz L367
L333:
	negl %ecx
L367:
	movl %ecx,%edi
	call _mk2data
	movl $1,%ebx
L336:
	cmpl -5172(%rbp),%ebx
	jge L339
L337:
	movslq %ebx,%rbx
	movl -3084(%rbp,%rbx,4),%eax
	testl %eax,%eax
	jnz L342
L341:
	movl -3100(%rbp),%eax
	negl %eax
L342:
	movl %eax,%edi
	call _mk2data
	incl %ebx
	jmp L336
L339:
	movl $10,_datapos(%rip)
	movl $10,_dataline(%rip)
	jmp L272
L331:
	cmpl $0,_fullspd(%rip)
	jz L344
L343:
	movl %r13d,%edx
	movl %eax,%esi
	leaq -3084(%rbp),%rdi
	call _place_state
	jmp L272
L344:
	cmpl %eax,_end_of_buffer_state(%rip)
	jnz L347
L346:
	movl $-32766,%ecx
	xorl %edx,%edx
	xorl %esi,%esi
	movl %eax,%edi
	call _stack1
	jmp L272
L347:
	xorl %esi,%esi
	xorl %edx,%edx
	movl $1,%ecx
L349:
	cmpl %r14d,%ecx
	jg L352
L350:
	movslq %ecx,%rcx
	movl -4132(%rbp,%rcx,4),%eax
	cmpl %eax,%esi
	jge L355
L353:
	movl %eax,%esi
	movl -5160(%rbp,%rcx,4),%edx
L355:
	incl %ecx
	jmp L349
L352:
	movl %esi,%r8d
	movl %edx,%ecx
	movl %r13d,%edx
	movl -3100(%rbp),%esi
	leaq -3084(%rbp),%rdi
	call _bldtbl
	jmp L272
L274:
	cmpl $0,_fulltbl(%rip)
	jz L357
L356:
	call _dataend
	jmp L189
L357:
	cmpl $0,_fullspd(%rip)
	jnz L189
L359:
	call _cmptmps
L362:
	movl _onesp(%rip),%ecx
	cmpl $0,%ecx
	jle L364
L363:
	movslq %ecx,%rcx
	movl _onestate(,%rcx,4),%edi
	movl _onesym(,%rcx,4),%esi
	movl _onenext(,%rcx,4),%eax
	movl _onedef(,%rcx,4),%ecx
	movl %eax,%edx
	call _mk1tbl
	decl _onesp(%rip)
	jmp L362
L364:
	call _mkdeftbl
L189:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_snstods:
L368:
	pushq %rbp
	movq %rsp,%rbp
	subq $32,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L369:
	movq %rdi,%r15
	movl %esi,%r14d
	movq %rdx,-24(%rbp)
	movl %ecx,-28(%rbp)
	movl %r8d,-12(%rbp)
	movq %r9,-8(%rbp)
	xorl %r13d,%r13d
	movl $1,%r12d
L371:
	movl _lastdfa(%rip),%eax
	cmpl %eax,%r12d
	jg L374
L372:
	movslq %r12d,%r12
	movq _dhash(%rip),%rcx
	movl -12(%rbp),%eax
	cmpl (%rcx,%r12,4),%eax
	jnz L377
L375:
	movq _dfasiz(%rip),%rax
	cmpl (%rax,%r12,4),%r14d
	jnz L379
L378:
	movq _dss(%rip),%rax
	movq (%rax,%r12,8),%rbx
	testl %r13d,%r13d
	jnz L383
L381:
	movl %r14d,%esi
	movq %r15,%rdi
	call _bubble
	movl $1,%r13d
L383:
	movl $1,%ecx
L384:
	cmpl %ecx,%r14d
	jl L387
L385:
	movslq %ecx,%rcx
	movl (%r15,%rcx,4),%eax
	cmpl (%rbx,%rcx,4),%eax
	jnz L387
L390:
	incl %ecx
	jmp L384
L387:
	cmpl %ecx,%r14d
	jl L392
L394:
	incl _hshcol(%rip)
	jmp L377
L392:
	incl _dfaeql(%rip)
	movq -8(%rbp),%rax
	movl %r12d,(%rax)
	xorl %eax,%eax
	jmp L370
L379:
	incl _hshsave(%rip)
L377:
	incl %r12d
	jmp L371
L374:
	incl %eax
	movl %eax,_lastdfa(%rip)
	cmpl _current_max_dfas(%rip),%eax
	jl L398
L396:
	call _increase_max_dfas
L398:
	movl _lastdfa(%rip),%ebx
	leal 1(%r14),%edi
	shll $2,%edi
	call _malloc
	movslq %ebx,%rcx
	movq _dss(%rip),%rdx
	movq %rax,(%rdx,%rcx,8)
	movq _dss(%rip),%rax
	cmpq $0,(%rax,%rcx,8)
	jnz L401
L399:
	movl $L402,%edi
	call _flexfatal
L401:
	testl %r13d,%r13d
	jnz L405
L403:
	movl %r14d,%esi
	movq %r15,%rdi
	call _bubble
L405:
	movl $1,%edx
L406:
	movslq %ebx,%r12
	cmpl %edx,%r14d
	jl L409
L407:
	movslq %edx,%rdx
	movl (%r15,%rdx,4),%ecx
	movq _dss(%rip),%rax
	movq (%rax,%r12,8),%rax
	movl %ecx,(%rax,%rdx,4)
	incl %edx
	jmp L406
L409:
	movq _dfasiz(%rip),%rax
	movl %r14d,(%rax,%r12,4)
	movq _dhash(%rip),%rcx
	movl -12(%rbp),%eax
	movl %eax,(%rcx,%r12,4)
	movl _reject(%rip),%eax
	cmpl $0,-28(%rbp)
	jnz L411
L410:
	movq _dfaacc(%rip),%rcx
	testl %eax,%eax
	jz L414
L413:
	movq $0,(%rcx,%r12,8)
	jmp L415
L414:
	movl $0,(%rcx,%r12,8)
L415:
	movq _accsiz(%rip),%rax
	movl $0,(%rax,%r12,4)
	jmp L412
L411:
	testl %eax,%eax
	jz L417
L416:
	movl -28(%rbp),%esi
	movq -24(%rbp),%rdi
	call _bubble
	movl -28(%rbp),%edi
	incl %edi
	shll $2,%edi
	call _malloc
	movq _dfaacc(%rip),%rcx
	movq %rax,(%rcx,%r12,8)
	movq _dfaacc(%rip),%rax
	cmpq $0,(%rax,%r12,8)
	jnz L421
L419:
	movl $L402,%edi
	call _flexfatal
L421:
	movl $1,%edx
L422:
	movslq %ebx,%rbx
	cmpl %edx,-28(%rbp)
	jl L425
L423:
	movslq %edx,%rdx
	movq -24(%rbp),%rax
	movl (%rax,%rdx,4),%ecx
	movq _dfaacc(%rip),%rax
	movq (%rax,%rbx,8),%rax
	movl %ecx,(%rax,%rdx,4)
	incl %edx
	jmp L422
L425:
	movq _accsiz(%rip),%rcx
	movl -28(%rbp),%eax
	movl %eax,(%rcx,%rbx,4)
	jmp L412
L417:
	movl _num_rules(%rip),%edx
	incl %edx
	movl $1,%ecx
L426:
	cmpl %ecx,-28(%rbp)
	jl L429
L427:
	movslq %ecx,%rcx
	movq -24(%rbp),%rax
	movl (%rax,%rcx,4),%eax
	cmpl %eax,%edx
	cmovgl %eax,%edx
	incl %ecx
	jmp L426
L429:
	movslq %ebx,%rax
	movq _dfaacc(%rip),%rcx
	movl %edx,(%rcx,%rax,8)
L412:
	movq -8(%rbp),%rax
	movl %ebx,(%rax)
	movl $1,%eax
L370:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_symfollowset:
L434:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L435:
	movq %rdi,-8(%rbp)
	movl %esi,-12(%rbp)
	movl %edx,%r15d
	movq %rcx,%r14
	xorl %ebx,%ebx
	movl $1,%r13d
L437:
	cmpl %r13d,-12(%rbp)
	jl L440
L438:
	movslq %r13d,%r13
	movq -8(%rbp),%rax
	movslq (%rax,%r13,4),%rcx
	movq _transchar(%rip),%rax
	movl (%rax,%rcx,4),%edi
	movq _trans1(%rip),%rax
	movl (%rax,%rcx,4),%r12d
	cmpl $0,%edi
	jge L442
L441:
	negl %edi
	movslq %edi,%rdi
	movq _cclmap(%rip),%rax
	movl (%rax,%rdi,4),%edx
	movq _ccllen(%rip),%rax
	movl (%rax,%rdi,4),%ecx
	movq _cclng(%rip),%rsi
	xorl %eax,%eax
	cmpl $0,(%rsi,%rdi,4)
	jz L463
L447:
	cmpl %eax,%ecx
	jle L497
L448:
	leal (%rdx,%rax),%edi
	movslq %edi,%rdi
	movq _ccltbl(%rip),%rsi
	movzbl (%rdi,%rsi),%esi
	testl %esi,%esi
	jnz L453
L451:
	movl _NUL_ec(%rip),%esi
L453:
	cmpl %esi,%r15d
	jz L461
	jl L497
L456:
	incl %eax
	jmp L447
L463:
	cmpl %eax,%ecx
	jle L461
L464:
	leal (%rdx,%rax),%esi
	movslq %esi,%rsi
	movq _ccltbl(%rip),%rdi
	movzbl (%rsi,%rdi),%esi
	testl %esi,%esi
	jnz L469
L467:
	movl _NUL_ec(%rip),%esi
L469:
	cmpl %esi,%r15d
	jl L461
	jz L474
L472:
	incl %eax
	jmp L463
L474:
	incl %ebx
	movslq %ebx,%rbx
	movl %r12d,(%r14,%rbx,4)
	jmp L461
L442:
	cmpl $65,%edi
	jl L479
L485:
	cmpl $90,%edi
	jg L479
L481:
	cmpl $0,_caseins(%rip)
	jz L479
L478:
	movl $L489,%edi
	call _flexfatal
	jmp L461
L479:
	cmpl $257,%edi
	jz L461
L491:
	movslq %edi,%rax
	movl _ecgroup(,%rax,4),%edi
	call _abs
	cmpl %eax,%r15d
	jnz L461
L497:
	incl %ebx
	movslq %ebx,%rax
	movl %r12d,(%r14,%rax,4)
L461:
	incl %r13d
	jmp L437
L440:
	movl %ebx,%eax
L436:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_sympartition:
L498:
	pushq %rbp
	movq %rsp,%rbp
	subq $1056,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L499:
	movq %rdi,-1040(%rbp)
	movl %esi,-1044(%rbp)
	movq %rdx,%r15
	movq %rcx,-1056(%rbp)
	movl $1,%esi
L501:
	cmpl _numecs(%rip),%esi
	jg L504
L502:
	movl %esi,%edx
	decl %edx
	movslq %esi,%rcx
	movq -1056(%rbp),%rax
	movl %edx,(%rax,%rcx,4)
	incl %esi
	movl %esi,-1028(%rbp,%rcx,4)
	jmp L501
L504:
	movq -1056(%rbp),%rax
	movl $0,4(%rax)
	movslq _numecs(%rip),%rax
	movl $0,-1028(%rbp,%rax,4)
	movl $1,%r14d
L505:
	cmpl %r14d,-1044(%rbp)
	jl L500
L506:
	movslq %r14d,%r14
	movq -1040(%rbp),%rax
	movslq (%rax,%r14,4),%rcx
	movq _transchar(%rip),%rax
	movl (%rax,%rcx,4),%ebx
	cmpl $257,%ebx
	jz L511
L509:
	movl _lastccl(%rip),%eax
	negl %eax
	cmpl %eax,%ebx
	jl L512
L515:
	cmpl _csize(%rip),%ebx
	jle L514
L512:
	cmpl _csize(%rip),%ebx
	jle L520
L522:
	cmpl $256,%ebx
	jg L520
L519:
	movl $L526,%edi
	call _flexerror
	jmp L514
L520:
	movl $L527,%edi
	call _flexfatal
L514:
	cmpl $0,%ebx
	jl L529
L528:
	movslq %ebx,%rbx
	movl _ecgroup(,%rbx,4),%edi
	call _abs
	movl %eax,%ebx
	movq -1056(%rbp),%rdx
	leaq -1028(%rbp),%rsi
	movl %ebx,%edi
	call _mkechar
	movslq %ebx,%rbx
	movl $1,(%r15,%rbx,4)
	jmp L511
L529:
	negl %ebx
	movslq %ebx,%r13
	movq _ccllen(%rip),%rax
	movl (%rax,%r13,4),%r12d
	movq _cclmap(%rip),%rax
	movl (%rax,%r13,4),%ebx
	movslq %ebx,%rdi
	movq _ccltbl(%rip),%rax
	movl _numecs(%rip),%r8d
	movl _NUL_ec(%rip),%r9d
	movq -1056(%rbp),%rcx
	leaq -1028(%rbp),%rdx
	movl %r12d,%esi
	addq %rax,%rdi
	call _mkeccl
	movq _cclng(%rip),%rax
	xorl %ecx,%ecx
	cmpl $0,(%rax,%r13,4)
	jnz L531
L549:
	cmpl %ecx,%r12d
	jle L511
L550:
	leal (%rbx,%rcx),%eax
	movslq %eax,%rax
	movq _ccltbl(%rip),%rdx
	movzbl (%rax,%rdx),%eax
	testl %eax,%eax
	jnz L555
L553:
	movl _NUL_ec(%rip),%eax
L555:
	movslq %eax,%rax
	movl $1,(%r15,%rax,4)
	incl %ecx
	jmp L549
L531:
	xorl %edx,%edx
L534:
	cmpl %edx,%r12d
	jg L535
L556:
	incl %ecx
	cmpl %ecx,_numecs(%rip)
	jl L511
L546:
	movslq %ecx,%rax
	movl $1,(%r15,%rax,4)
	jmp L556
L511:
	incl %r14d
	jmp L505
L535:
	leal (%rbx,%rdx),%eax
	movslq %eax,%rax
	movq _ccltbl(%rip),%rsi
	movzbl (%rax,%rsi),%eax
	testl %eax,%eax
	jnz L557
L538:
	movl _NUL_ec(%rip),%eax
L557:
	incl %ecx
	cmpl %eax,%ecx
	jge L544
L542:
	movslq %ecx,%rcx
	movl $1,(%r15,%rcx,4)
	jmp L557
L544:
	incl %edx
	jmp L534
L500:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L179:
	.byte 99,111,110,115,105,115,116,101
	.byte 110,99,121,32,99,104,101,99
	.byte 107,32,102,97,105,108,101,100
	.byte 32,105,110,32,101,112,115,99
	.byte 108,111,115,117,114,101,40,41
	.byte 0
L91:
	.byte 32,111,117,116,45,116,114,97
	.byte 110,115,105,116,105,111,110,115
	.byte 58,32,0
L46:
	.byte 37,115,58,32,68,97,110,103
	.byte 101,114,111,117,115,32,116,114
	.byte 97,105,108,105,110,103,32,99
	.byte 111,110,116,101,120,116,32,105
	.byte 110,32,114,117,108,101,32,97
	.byte 116,32,108,105,110,101,32,37
	.byte 100,10,0
L96:
	.byte 10,32,106,97,109,45,116,114
	.byte 97,110,115,105,116,105,111,110
	.byte 115,58,32,69,79,70,32,0
L80:
	.byte 9,37,100,0
L18:
	.byte 83,116,97,116,101,32,35,37
	.byte 100,32,105,115,32,110,111,110
	.byte 45,97,99,99,101,112,116,105
	.byte 110,103,32,45,10,0
L204:
	.byte 10,10,68,70,65,32,68,117
	.byte 109,112,58,10,10,0
L271:
	.byte 99,111,117,108,100,32,110,111
	.byte 116,32,99,114,101,97,116,101
	.byte 32,117,110,105,113,117,101,32
	.byte 101,110,100,45,111,102,45,98
	.byte 117,102,102,101,114,32,115,116
	.byte 97,116,101,0
L527:
	.byte 98,97,100,32,116,114,97,110
	.byte 115,105,116,105,111,110,32,99
	.byte 104,97,114,97,99,116,101,114
	.byte 32,100,101,116,101,99,116,101
	.byte 100,32,105,110,32,115,121,109
	.byte 112,97,114,116,105,116,105,111
	.byte 110,40,41,0
L69:
	.byte 32,97,115,115,111,99,105,97
	.byte 116,101,100,32,114,117,108,101
	.byte 32,108,105,110,101,32,110,117
	.byte 109,98,101,114,115,58,0
L489:
	.byte 99,111,110,115,105,115,116,101
	.byte 110,99,121,32,99,104,101,99
	.byte 107,32,102,97,105,108,101,100
	.byte 32,105,110,32,115,121,109,102
	.byte 111,108,108,111,119,115,101,116
	.byte 0
L306:
	.byte 9,37,100,9,37,100,10,0
L402:
	.byte 100,121,110,97,109,105,99,32
	.byte 109,101,109,111,114,121,32,102
	.byte 97,105,108,117,114,101,32,105
	.byte 110,32,115,110,115,116,111,100
	.byte 115,40,41,0
L243:
	.byte 115,116,97,116,105,99,32,115
	.byte 104,111,114,116,32,105,110,116
	.byte 32,121,121,95,110,120,116,91
	.byte 93,91,37,100,93,32,61,10
	.byte 32,32,32,32,123,10,0
L526:
	.byte 115,99,97,110,110,101,114,32
	.byte 114,101,113,117,105,114,101,115
	.byte 32,45,56,32,102,108,97,103
	.byte 0
L282:
	.byte 115,116,97,116,101,32,35,32
	.byte 37,100,58,10,0

.globl _assoc_rule
.globl _numsnpairs
.globl _symfollowset
.globl _hshsave
.globl _num_backtracking
.globl _current_max_dfas
.globl _trans2
.globl _num_rules
.globl _dataline
.globl _ccltbl
.globl _numdup
.globl _current_max_dfa_size
.globl _mk1tbl
.globl _onestate
.globl _mk2data
.globl _onedef
.globl _csize
.globl _dss
.globl _def
.globl _useecs
.globl _numas
.globl _variable_trailing_context_rules
.globl _increase_max_dfas
.globl _malloc
.globl _rule_linenum
.globl _datapos
.globl _mkdeftbl
.globl _hshcol
.globl _num_reallocs
.globl _dataend
.globl _cclmap
.globl _mkbranch
.globl _dfasiz
.globl _state_type
.globl _abs
.globl _onesp
.globl _reject
.globl _flexfatal
.globl _printf
.globl _check_for_backtracking
.globl _inittbl
.globl _NUL_ec
.globl _program_name
.globl _dumpnfa
.globl _nultrans
.globl _ecgroup
.globl _check_trailing_context
.globl _ntod
.globl _dfaacc
.globl _onenext
.globl ___flushbuf
.globl _accsiz
.globl _snstods
.globl _transchar
.globl _bubble
.globl _list_character_set
.globl _epsclosure
.globl _lastdfa
.globl ___stderr
.globl _reallocate_array
.globl _lastsc
.globl _stack1
.globl _trace
.globl _place_state
.globl _bldtbl
.globl _accptnum
.globl _sympartition
.globl _mkechar
.globl _trans1
.globl _allocate_array
.globl _fullspd
.globl _backtrack_report
.globl _onesym
.globl _fputs
.globl _mkeccl
.globl _dfaeql
.globl _scset
.globl _dump_associated_rules
.globl _dhash
.globl _end_of_buffer_state
.globl _scbol
.globl _caseins
.globl _numuniq
.globl _totnst
.globl _ccllen
.globl _lastccl
.globl _dump_transitions
.globl _flexerror
.globl _base
.globl _rule_type
.globl _cclng
.globl _firstfree
.globl _fulltbl
.globl _fprintf
.globl _cmptmps
.globl _numecs
.globl _backtrack_file
