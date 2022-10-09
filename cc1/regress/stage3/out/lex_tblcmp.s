.text

_bldtbl:
L1:
	pushq %rbp
	movq %rsp,%rbp
	subq $2096,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L2:
	movl _numecs(%rip),%eax
	movq %rdi,-2088(%rbp) # spill
	movl %esi,-2076(%rbp) # spill
	movl %edx,-2096(%rbp) # spill
	movl %ecx,-2092(%rbp) # spill
	movl %r8d,-2060(%rbp) # spill
	xorl %r12d,%r12d
	imull $100,-2096(%rbp),%edx # spill
	imull $15,%eax,%ecx
	cmpl %ecx,%edx
	jl L40
L5:
	movl _firstprot(%rip),%esi
	imull $100,-2060(%rbp),%ecx # spill
	imull $50,-2096(%rbp),%eax # spill
	cmpl %eax,%ecx
	movl %esi,%ebx
	movl -2096(%rbp),%r14d # spill
	jle L8
L10:
	testl %esi,%esi
	jz L9
L11:
	movslq %esi,%rsi
	movl -2092(%rbp),%eax # spill
	cmpl _protcomst(,%rsi,4),%eax
	jz L14
L16:
	movl _protnext(,%rsi,4),%esi
	jmp L10
L14:
	movl %esi,%ebx
	jmp L41
L8:
	movl $0,-2092(%rbp) # spill
	testl %esi,%esi
	jz L9
L41:
	leaq -2056(%rbp),%rdx
	movq -2088(%rbp),%rdi # spill
	call _tbldiff
	movl %eax,%r14d
L9:
	imull $100,%r14d,%ecx
	imull $10,-2096(%rbp),%eax # spill
	cmpl %eax,%ecx
	jle L23
L21:
	movl %ebx,%r15d
	jmp L24
L25:
	movl $1,%r13d
	subl %r12d,%r13d
	movslq %r13d,%r13
	imulq $1028,%r13,%rax
	leaq -2056(%rbp,%rax),%rdx
	movl %r15d,%esi
	movq -2088(%rbp),%rdi # spill
	call _tbldiff
	cmpl %eax,%r14d
	jle L30
L28:
	movl %r13d,%r12d
	movl %eax,%r14d
	movl %r15d,%ebx
L30:
	movslq %r15d,%r15
	movl _protnext(,%r15,4),%r15d
L24:
	testl %r15d,%r15d
	jnz L25
L23:
	imull $100,%r14d,%eax
	movl %eax,-2064(%rbp) # spill
	imull $50,-2096(%rbp),%eax # spill
	cmpl %eax,-2064(%rbp) # spill
	jle L32
L31:
	imull $100,-2060(%rbp),%ecx # spill
	imull $60,-2096(%rbp),%eax # spill
	cmpl %eax,%ecx
	jl L35
L34:
	movl -2092(%rbp),%edx # spill
	movl -2076(%rbp),%esi # spill
	movq -2088(%rbp),%rdi # spill
	call _mktemplate
	jmp L3
L35:
	movl -2092(%rbp),%edx # spill
	movl -2076(%rbp),%esi # spill
	movq -2088(%rbp),%rdi # spill
	call _mkprot
	movl _numecs(%rip),%eax
L40:
	movl -2096(%rbp),%r8d # spill
	movl $-32766,%ecx
	movl -2076(%rbp),%edx # spill
	movl %eax,%esi
	movq -2088(%rbp),%rdi # spill
	call _mkentry
	jmp L3
L32:
	movslq %r12d,%r12
	imulq $1028,%r12,%rax
	movq %rax,-2072(%rbp) # spill
	movslq %ebx,%rbx
	movl %r14d,%r8d
	movl _prottbl(,%rbx,4),%ecx
	movl -2076(%rbp),%edx # spill
	movl _numecs(%rip),%esi
	movq -2072(%rbp),%rax # spill
	leaq -2056(%rbp,%rax),%rdi
	call _mkentry
	imull $20,-2096(%rbp),%eax # spill
	cmpl %eax,-2064(%rbp) # spill
	jl L39
L37:
	movl -2092(%rbp),%edx # spill
	movl -2076(%rbp),%esi # spill
	movq -2088(%rbp),%rdi # spill
	call _mkprot
L39:
	movl %ebx,%edi
	call _mv2front
L3:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cmptmps:
L42:
	pushq %rbp
	movq %rsp,%rbp
	subq $1032,%rsp
	pushq %rbx
L43:
	movl _numtemps(%rip),%ecx
	movl _numecs(%rip),%edx
	movl _tblend(%rip),%eax
	imull %edx,%ecx
	addl %ecx,%eax
	movl %eax,_peakpairs(%rip)
	cmpl $0,_usemecs(%rip)
	jz L46
L45:
	movl $_tecbck,%esi
	movl $_tecfwd,%edi
	call _cre8ecs
	movl %eax,_nummecs(%rip)
	jmp L47
L46:
	movl %edx,_nummecs(%rip)
L47:
	movl _numtemps(%rip),%ecx
	movl _lastdfa(%rip),%eax
	leal 1(%rcx,%rax),%eax
	cmpl _current_max_dfas(%rip),%eax
	jl L50
L48:
	call _increase_max_dfas
L50:
	movl $1,%ebx
	jmp L51
L52:
	xorl %r8d,%r8d
	movl $1,%eax
L55:
	movl _numecs(%rip),%edx
	cmpl %eax,%edx
	jl L58
L56:
	imull %ebx,%edx
	addl %eax,%edx
	movslq %edx,%rdx
	movq _tnxt(%rip),%rcx
	movl (%rcx,%rdx,4),%edx
	cmpl $0,_usemecs(%rip)
	jz L60
L59:
	movl _tecbck(,%rax,4),%ecx
	cmpl $0,%ecx
	jle L61
L62:
	movslq %ecx,%rcx
	movl %edx,-1028(%rbp,%rcx,4)
	cmpl $0,%edx
	jle L61
	jg L71
L60:
	movl %edx,-1028(%rbp,%rax,4)
	cmpl $0,%edx
	jle L61
L71:
	incl %r8d
L61:
	incl %eax
	jmp L55
L58:
	movl _lastdfa(%rip),%eax
	movl $-32766,%ecx
	leal 1(%rax,%rbx),%edx
	movl _nummecs(%rip),%esi
	leaq -1028(%rbp),%rdi
	call _mkentry
	incl %ebx
L51:
	cmpl %ebx,_numtemps(%rip)
	jge L52
L44:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_expand_nxt_chk:
L72:
	pushq %rbx
L73:
	movl _current_max_xpairs(%rip),%ebx
	leal 2000(%rbx),%eax
	movl %eax,_current_max_xpairs(%rip)
	incl _num_reallocs(%rip)
	movl $4,%edx
	leal 2000(%rbx),%esi
	movq _nxt(%rip),%rdi
	call _reallocate_array
	movq %rax,_nxt(%rip)
	movl $4,%edx
	movl _current_max_xpairs(%rip),%esi
	movq _chk(%rip),%rdi
	call _reallocate_array
	movq %rax,_chk(%rip)
	movslq %ebx,%rbx
	movl $8000,%edx
	xorl %esi,%esi
	leaq (%rax,%rbx,4),%rdi
	call _memset
L74:
	popq %rbx
	ret 


_find_table_space:
L75:
	pushq %rbx
	pushq %r12
	pushq %r13
L76:
	movq %rdi,%r13
	movl %esi,%r12d
	cmpl $4,%r12d
	jle L79
L78:
	movl _tblend(%rip),%ebx
	cmpl $2,%ebx
	jl L81
L83:
	subl _numecs(%rip),%ebx
	jmp L85
L81:
	movl $1,%eax
	jmp L77
L79:
	movl _firstfree(%rip),%ebx
L85:
	movl _numecs(%rip),%eax
	addl %ebx,%eax
	cmpl _current_max_xpairs(%rip),%eax
	jle L91
L123:
	call _expand_nxt_chk
L91:
	movl %ebx,%eax
	decl %eax
	movslq %eax,%rax
	movq _chk(%rip),%rcx
	cmpl $0,(%rcx,%rax,4)
	jnz L95
L94:
	movslq %ebx,%rbx
	cmpl $0,(%rcx,%rbx,4)
	jz L93
L98:
	addl $2,%ebx
	jmp L96
L93:
	cmpl $4,%r12d
	jg L106
L104:
	leal 1(%rbx),%eax
	movl %eax,_firstfree(%rip)
L106:
	movl _numecs(%rip),%eax
	leaq 4(%r13),%rsi
	leal 1(%rbx,%rax),%eax
	movslq %eax,%rax
	leaq (%rcx,%rax,4),%rdx
	leal 1(%rbx),%eax
	movslq %eax,%rax
	leaq (%rcx,%rax,4),%rcx
	jmp L107
L108:
	movl (%rsi),%eax
	addq $4,%rsi
	testl %eax,%eax
	jz L116
L114:
	cmpl $0,(%rcx)
	jnz L110
L116:
	addq $4,%rcx
L107:
	cmpq %rcx,%rdx
	jnz L108
L110:
	cmpq %rcx,%rdx
	jz L119
L120:
	incl %ebx
	jmp L85
L119:
	movl %ebx,%eax
L77:
	popq %r13
	popq %r12
	popq %rbx
	ret 
L95:
	incl %ebx
L96:
	movl _numecs(%rip),%eax
	addl %ebx,%eax
	cmpl %eax,_current_max_xpairs(%rip)
	jge L91
	jl L123


_inittbl:
L124:
L125:
	movslq _current_max_xpairs(%rip),%rdx
	shlq $2,%rdx
	xorl %esi,%esi
	movq _chk(%rip),%rdi
	call _memset
	movl $0,_tblend(%rip)
	movl $1,_firstfree(%rip)
	movl $0,_numtemps(%rip)
	cmpl $0,_usemecs(%rip)
	jz L126
L127:
	movl $0,_tecbck+4(%rip)
	movl $2,%ecx
	jmp L130
L131:
	movl %ecx,%eax
	decl %eax
	movl %eax,_tecbck(,%rcx,4)
	movslq %eax,%rax
	movl %ecx,_tecfwd(,%rax,4)
	incl %ecx
L130:
	movl _numecs(%rip),%eax
	cmpl %eax,%ecx
	jle L131
L133:
	movslq %eax,%rax
	movl $0,_tecfwd(,%rax,4)
L126:
	ret 


_mkdeftbl:
L134:
L135:
	movl _lastdfa(%rip),%eax
	incl %eax
	movl %eax,_jamstate(%rip)
	movl _tblend(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,_tblend(%rip)
	movl _numecs(%rip),%eax
	leal 1(%rcx,%rax),%eax
	cmpl _current_max_xpairs(%rip),%eax
	jle L139
L137:
	call _expand_nxt_chk
L139:
	movslq _tblend(%rip),%rdx
	movq _nxt(%rip),%rcx
	movl _end_of_buffer_state(%rip),%eax
	movl %eax,(%rcx,%rdx,4)
	movslq _tblend(%rip),%rcx
	movq _chk(%rip),%rax
	movl _jamstate(%rip),%edx
	movl %edx,(%rax,%rcx,4)
	movl $1,%ecx
	jmp L140
L141:
	addl %ecx,%edx
	movslq %edx,%rdx
	movq _nxt(%rip),%rax
	movl $0,(%rax,%rdx,4)
	movl _tblend(%rip),%eax
	addl %ecx,%eax
	movslq %eax,%rax
	movq _chk(%rip),%rdx
	movl _jamstate(%rip),%esi
	movl %esi,(%rdx,%rax,4)
	incl %ecx
L140:
	movl _numecs(%rip),%eax
	movl _tblend(%rip),%edx
	cmpl %ecx,%eax
	jge L141
L143:
	movl %edx,_jambase(%rip)
	movslq _jamstate(%rip),%rcx
	movq _base(%rip),%rax
	movl %edx,(%rax,%rcx,4)
	movslq _jamstate(%rip),%rcx
	movq _def(%rip),%rax
	movl $0,(%rax,%rcx,4)
	movl _tblend(%rip),%ecx
	addl _numecs(%rip),%ecx
	movl %ecx,_tblend(%rip)
	incl _numtemps(%rip)
L136:
	ret 


_mkentry:
L144:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L145:
	movq %rdi,-16(%rbp) # spill
	movq %rdx,-24(%rbp) # spill
	movl %ecx,%r15d
	testl %r8d,%r8d
	jz L147
L149:
	movl $1,%ebx
	jmp L154
L155:
	movl %ebx,%ecx
	movq -16(%rbp),%rax # spill
	movl (%rax,%rcx,4),%eax
	cmpl $-1,%eax
	jz L160
L158:
	testl %eax,%eax
	jnz L157
L164:
	cmpl $-32766,%r15d
	jnz L157
L160:
	incl %ebx
L154:
	cmpl %ebx,%esi
	jge L155
L157:
	cmpl $1,%r8d
	jz L169
L171:
	movl %esi,%r14d
	jmp L173
L174:
	movslq %r14d,%r14
	movq -16(%rbp),%rax # spill
	movl (%rax,%r14,4),%eax
	cmpl $-1,%eax
	jz L179
L177:
	testl %eax,%eax
	jnz L176
L183:
	cmpl $-32766,%r15d
	jnz L176
L179:
	decl %r14d
L173:
	cmpl $0,%r14d
	jg L174
L176:
	imull $100,%r8d,%ecx
	imull $15,%esi,%eax
	cmpl %eax,%ecx
	jg L189
L188:
	movl _firstfree(%rip),%r13d
L191:
	cmpl %r13d,%ebx
	jle L193
L260:
	incl %r13d
	movslq %r13d,%rcx
	movq _chk(%rip),%rax
	cmpl $0,(%rax,%rcx,4)
	jnz L260
	jz L191
L193:
	leal (%r13,%r14),%eax
	subl %ebx,%eax
	cmpl _current_max_xpairs(%rip),%eax
	jl L200
L198:
	call _expand_nxt_chk
L200:
	movl %ebx,%ecx
L201:
	cmpl %ecx,%r14d
	jl L190
L202:
	movslq %ecx,%rcx
	movq -16(%rbp),%rax # spill
	movl (%rax,%rcx,4),%eax
	cmpl $-1,%eax
	jz L207
L205:
	testl %eax,%eax
	jnz L208
L211:
	cmpl $-32766,%r15d
	jz L207
L208:
	leal (%rcx,%r13),%eax
	subl %ebx,%eax
	movslq %eax,%rax
	movq _chk(%rip),%rdx
	cmpl $0,(%rdx,%rax,4)
	jz L207
L259:
	incl %r13d
	movl _current_max_xpairs(%rip),%ecx
	cmpl %ecx,%r13d
	jge L221
L222:
	movslq %r13d,%r13
	movq _chk(%rip),%rax
	cmpl $0,(%rax,%r13,4)
	jnz L259
L221:
	leal (%r13,%r14),%eax
	subl %ebx,%eax
	cmpl %eax,%ecx
	jg L228
L226:
	call _expand_nxt_chk
L228:
	movl %ebx,%ecx
	decl %ecx
L207:
	incl %ecx
	jmp L201
L189:
	movl _tblend(%rip),%r13d
	incl %r13d
	cmpl %r13d,%ebx
	cmovgel %ebx,%r13d
L190:
	movl %r13d,%r12d
	subl %ebx,%r12d
	leal (%r12,%r14),%eax
	cmpl %eax,_current_max_xpairs(%rip)
	movl %eax,-4(%rbp) # spill
	jg L234
L232:
	call _expand_nxt_chk
L234:
	movslq -24(%rbp),%rax # spill
	movq %rax,-24(%rbp) # spill
	movq _base(%rip),%rcx
	movq -24(%rbp),%rax # spill
	movl %r12d,(%rcx,%rax,4)
	movq _def(%rip),%rcx
	movq -24(%rbp),%rax # spill
	movl %r15d,(%rcx,%rax,4)
	jmp L235
L236:
	movl %ebx,%ebx
	movq -16(%rbp),%rax # spill
	movl (%rax,%rbx,4),%edx
	cmpl $-1,%edx
	jz L241
L239:
	testl %edx,%edx
	jnz L242
L245:
	cmpl $-32766,%r15d
	jz L241
L242:
	leal (%rbx,%r12),%ecx
	movslq %ecx,%rcx
	movq _nxt(%rip),%rax
	movl %edx,(%rax,%rcx,4)
	movq _chk(%rip),%rdx
	movq -24(%rbp),%rax # spill
	movl %eax,(%rdx,%rcx,4)
L241:
	incl %ebx
L235:
	cmpl %ebx,%r14d
	jge L236
L238:
	movl _firstfree(%rip),%eax
	cmpl %eax,%r13d
	jnz L251
L261:
	incl %eax
	movl %eax,_firstfree(%rip)
	movslq _firstfree(%rip),%rax
	movq _chk(%rip),%rcx
	cmpl $0,(%rcx,%rax,4)
	jnz L261
L251:
	movl _tblend(%rip),%ecx
	cmpl -4(%rbp),%ecx # spill
	movl -4(%rbp),%eax # spill
	cmovlel %eax,%ecx
	movl %ecx,_tblend(%rip)
	jmp L146
L169:
	movl %ebx,%edx
	movl %r15d,%ecx
	movq -16(%rbp),%rax # spill
	movl (%rax,%rdx,4),%edx
	movl %ebx,%esi
	movl -24(%rbp),%edi # spill
	call _stack1
	jmp L146
L147:
	movslq -24(%rbp),%rcx # spill
	movq _base(%rip),%rax
	cmpl $-32766,%r15d
	jnz L151
L150:
	movl $-32766,(%rax,%rcx,4)
	jmp L152
L151:
	movl $0,(%rax,%rcx,4)
L152:
	movq _def(%rip),%rax
	movl %r15d,(%rax,%rcx,4)
L146:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_mk1tbl:
L262:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L263:
	movl %edi,%ebx
	movl %esi,%r14d
	movl %edx,%r13d
	movl %ecx,%r12d
	cmpl _firstfree(%rip),%r14d
	jle L268
L265:
	movl %r14d,_firstfree(%rip)
L268:
	movslq _firstfree(%rip),%rcx
	movq _chk(%rip),%rax
	cmpl $0,(%rax,%rcx,4)
	jz L270
L269:
	incl %ecx
	movl %ecx,_firstfree(%rip)
	cmpl _current_max_xpairs(%rip),%ecx
	jl L268
L271:
	call _expand_nxt_chk
	jmp L268
L270:
	subl %r14d,%ecx
	movslq %ebx,%rbx
	movq _base(%rip),%rax
	movl %ecx,(%rax,%rbx,4)
	movq _def(%rip),%rax
	movl %r12d,(%rax,%rbx,4)
	movslq _firstfree(%rip),%rax
	movq _chk(%rip),%rcx
	movl %ebx,(%rcx,%rax,4)
	movslq _firstfree(%rip),%rcx
	movq _nxt(%rip),%rax
	movl %r13d,(%rax,%rcx,4)
	movl _firstfree(%rip),%ecx
	cmpl _tblend(%rip),%ecx
	jle L264
L274:
	leal 1(%rcx),%eax
	movl %eax,_firstfree(%rip)
	movl %ecx,_tblend(%rip)
	cmpl %eax,_current_max_xpairs(%rip)
	jg L264
L277:
	call _expand_nxt_chk
L264:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_mkprot:
L280:
L281:
	movl _numprots(%rip),%r8d
	incl %r8d
	movl %r8d,_numprots(%rip)
	cmpl $50,%r8d
	jge L283
L286:
	movl _numecs(%rip),%eax
	imull %r8d,%eax
	cmpl $2000,%eax
	jl L285
L283:
	movl _lastprot(%rip),%r8d
	movslq %r8d,%rax
	movl _protprev(,%rax,4),%eax
	movl %eax,_lastprot(%rip)
	movslq %eax,%rax
	movl $0,_protnext(,%rax,4)
L285:
	movslq %r8d,%r8
	movl _firstprot(%rip),%eax
	movl %eax,_protnext(,%r8,4)
	movl _firstprot(%rip),%eax
	testl %eax,%eax
	jz L292
L290:
	movslq %eax,%rax
	movl %r8d,_protprev(,%rax,4)
L292:
	movl %r8d,_firstprot(%rip)
	movl %esi,_prottbl(,%r8,4)
	movl %edx,_protcomst(,%r8,4)
	decl %r8d
	imull _numecs(%rip),%r8d
	movl $1,%edx
	jmp L293
L294:
	movl (%rdi,%rdx,4),%ecx
	leal (%rdx,%r8),%eax
	movslq %eax,%rax
	movl %ecx,_protsave(,%rax,4)
	incl %edx
L293:
	cmpl %edx,_numecs(%rip)
	jge L294
L282:
	ret 


_mktemplate:
L297:
	pushq %rbp
	movq %rsp,%rbp
	subq $1288,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L298:
	movl _numtemps(%rip),%ebx
	movq %rdi,%r15
	movl %esi,%r14d
	movl %edx,%r13d
	incl %ebx
	movl %ebx,_numtemps(%rip)
	movl _numecs(%rip),%eax
	xorl %r12d,%r12d
	imull %eax,%ebx
	movl _current_max_template_xpairs(%rip),%esi
	addl %ebx,%eax
	cmpl %esi,%eax
	jl L302
L300:
	leal 2500(%rsi),%eax
	movl %eax,_current_max_template_xpairs(%rip)
	incl _num_reallocs(%rip)
	movl $4,%edx
	addl $2500,%esi
	movq _tnxt(%rip),%rdi
	call _reallocate_array
	movq %rax,_tnxt(%rip)
L302:
	movl $1,%edx
	jmp L303
L304:
	leal (%rdx,%rbx),%eax
	movslq %eax,%rax
	cmpl $0,(%r15,%rdx,4)
	jnz L308
L307:
	movq _tnxt(%rip),%rcx
	movl $0,(%rcx,%rax,4)
	jmp L309
L308:
	movl %r12d,%ecx
	incl %r12d
	movb %dl,-257(%rbp,%rcx)
	movq _tnxt(%rip),%rcx
	movl %r13d,(%rcx,%rax,4)
L309:
	incl %edx
L303:
	movl _numecs(%rip),%r8d
	cmpl %edx,%r8d
	jge L304
L306:
	cmpl $0,_usemecs(%rip)
	jz L312
L310:
	xorl %r9d,%r9d
	movl $_tecbck,%ecx
	movl $_tecfwd,%edx
	movl %r12d,%esi
	leaq -257(%rbp),%rdi
	call _mkeccl
L312:
	movslq %ebx,%rbx
	movq _tnxt(%rip),%rax
	movl _numtemps(%rip),%esi
	negl %esi
	movl %r13d,%edx
	leaq (%rax,%rbx,4),%rdi
	call _mkprot
	leaq -1288(%rbp),%rdx
	movl _firstprot(%rip),%esi
	movq %r15,%rdi
	call _tbldiff
	movl _numtemps(%rip),%ecx
	negl %ecx
	movl %eax,%r8d
	movl %r14d,%edx
	movl _numecs(%rip),%esi
	leaq -1288(%rbp),%rdi
	call _mkentry
L299:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_mv2front:
L313:
L314:
	cmpl _firstprot(%rip),%edi
	jz L315
L316:
	movl _lastprot(%rip),%eax
	cmpl %eax,%edi
	jnz L321
L319:
	movslq %eax,%rax
	movl _protprev(,%rax,4),%eax
	movl %eax,_lastprot(%rip)
L321:
	movslq %edi,%rdx
	movl _protnext(,%rdx,4),%ecx
	movslq _protprev(,%rdx,4),%rax
	movl %ecx,_protnext(,%rax,4)
	movl _protnext(,%rdx,4),%eax
	testl %eax,%eax
	jz L324
L322:
	movl _protprev(,%rdx,4),%ecx
	movslq %eax,%rax
	movl %ecx,_protprev(,%rax,4)
L324:
	movl $0,_protprev(,%rdx,4)
	movl _firstprot(%rip),%eax
	movl %eax,_protnext(,%rdx,4)
	movslq _firstprot(%rip),%rax
	movl %edi,_protprev(,%rax,4)
	movl %edi,_firstprot(%rip)
L315:
	ret 


_place_state:
L325:
	pushq %rbx
	pushq %r12
L326:
	movq %rdi,%rbx
	movl %esi,%r12d
	movl %edx,%esi
	movq %rbx,%rdi
	call _find_table_space
	movslq %r12d,%r12
	movq _base(%rip),%rcx
	movl %eax,(%rcx,%r12,4)
	movl %eax,%edx
	decl %edx
	movslq %edx,%rdx
	movq _chk(%rip),%rcx
	movl $1,(%rcx,%rdx,4)
	movslq %eax,%rax
	movq _chk(%rip),%rcx
	movl $1,(%rcx,%rax,4)
	addq $4,%rbx
	movl $1,%edi
	jmp L328
L329:
	cmpl $0,(%rbx)
	jz L334
L332:
	leal (%rax,%rdi),%esi
	movslq %esi,%rsi
	movq _chk(%rip),%rcx
	movl %edi,(%rcx,%rsi,4)
	movl (%rbx),%edx
	movq _nxt(%rip),%rcx
	movl %edx,(%rcx,%rsi,4)
L334:
	incl %edi
	addq $4,%rbx
L328:
	movl _numecs(%rip),%ecx
	cmpl %ecx,%edi
	jle L329
L331:
	addl %eax,%ecx
	cmpl _tblend(%rip),%ecx
	jle L327
L335:
	movl %ecx,_tblend(%rip)
L327:
	popq %r12
	popq %rbx
	ret 


_stack1:
L338:
L339:
	movl _onesp(%rip),%eax
	cmpl $499,%eax
	jl L342
L341:
	call _mk1tbl
	ret
L342:
	incl %eax
	movl %eax,_onesp(%rip)
	movslq %eax,%rax
	movl %edi,_onestate(,%rax,4)
	movslq _onesp(%rip),%rax
	movl %esi,_onesym(,%rax,4)
	movslq _onesp(%rip),%rax
	movl %edx,_onenext(,%rax,4)
	movslq _onesp(%rip),%rax
	movl %ecx,_onedef(,%rax,4)
L340:
	ret 


_tbldiff:
L344:
L345:
	movl _numecs(%rip),%r9d
	xorl %eax,%eax
	decl %esi
	imull %r9d,%esi
	movslq %esi,%rcx
	leaq _protsave(,%rcx,4),%r10
	jmp L347
L348:
	leaq 4(%r10),%rcx
	movl 4(%r10),%r8d
	movq %rcx,%r10
	leaq 4(%rdi),%rcx
	movl 4(%rdi),%esi
	movq %rcx,%rdi
	leaq 4(%rdx),%rcx
	cmpl %esi,%r8d
	jnz L352
L351:
	movl $-1,4(%rdx)
	movq %rcx,%rdx
	jmp L353
L352:
	movl %esi,4(%rdx)
	movq %rcx,%rdx
	incl %eax
L353:
	decl %r9d
L347:
	cmpl $0,%r9d
	jg L348
L346:
	ret 


.globl _protcomst
.globl _current_max_dfas
.globl _jamstate
.globl _mk1tbl
.globl _nxt
.globl _onestate
.globl _onedef
.globl _def
.globl _increase_max_dfas
.globl _numprots
.globl _firstprot
.globl _mkdeftbl
.globl _num_reallocs
.globl _current_max_xpairs
.globl _cre8ecs
.globl _tecbck
.globl _find_table_space
.globl _protnext
.globl _tnxt
.globl _numtemps
.globl _peakpairs
.globl _onesp
.globl _jambase
.globl _inittbl
.globl _prottbl
.globl _mv2front
.globl _chk
.globl _onenext
.globl _tblend
.globl _expand_nxt_chk
.globl _lastdfa
.globl _mkentry
.globl _reallocate_array
.globl _stack1
.globl _place_state
.globl _mktemplate
.globl _bldtbl
.globl _current_max_template_xpairs
.globl _tecfwd
.globl _memset
.globl _mkprot
.globl _lastprot
.globl _nummecs
.globl _onesym
.globl _mkeccl
.globl _tbldiff
.globl _end_of_buffer_state
.globl _base
.globl _protprev
.globl _firstfree
.globl _protsave
.globl _usemecs
.globl _cmptmps
.globl _numecs
