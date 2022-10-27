.text
L25:
	.quad 0x0

_syminit:
L1:
L2:
	movq _symtab(%rip),%rcx
	movl $15,%edx
	movsd L25(%rip),%xmm0
	movl $L4,%esi
	movl $L4,%edi
	call _setsymtab
	movq %rax,_literal0(%rip)
	movq _symtab(%rip),%rcx
	movl $15,%edx
	movsd L25(%rip),%xmm0
	movl $L6,%esi
	movl $L5,%edi
	call _setsymtab
	movq %rax,_nullloc(%rip)
	movl $5,%esi
	movq %rax,%rdi
	call _celltonode
	movq %rax,_nullnode(%rip)
	movq _symtab(%rip),%rcx
	movl $6,%edx
	movsd L25(%rip),%xmm0
	movl $L8,%esi
	movl $L7,%edi
	call _setsymtab
	movq %rax,_fsloc(%rip)
	addq $16,%rax
	movq %rax,_FS(%rip)
	movq _symtab(%rip),%rcx
	movl $6,%edx
	movsd L25(%rip),%xmm0
	movl $L10,%esi
	movl $L9,%edi
	call _setsymtab
	addq $16,%rax
	movq %rax,_RS(%rip)
	movq _symtab(%rip),%rcx
	movl $6,%edx
	movsd L25(%rip),%xmm0
	movl $L8,%esi
	movl $L11,%edi
	call _setsymtab
	addq $16,%rax
	movq %rax,_OFS(%rip)
	movq _symtab(%rip),%rcx
	movl $6,%edx
	movsd L25(%rip),%xmm0
	movl $L10,%esi
	movl $L12,%edi
	call _setsymtab
	addq $16,%rax
	movq %rax,_ORS(%rip)
	movq _symtab(%rip),%rcx
	movl $6,%edx
	movsd L25(%rip),%xmm0
	movl $L14,%esi
	movl $L13,%edi
	call _setsymtab
	addq $16,%rax
	movq %rax,_OFMT(%rip)
	movq _symtab(%rip),%rcx
	movl $6,%edx
	movsd L25(%rip),%xmm0
	movl $L14,%esi
	movl $L15,%edi
	call _setsymtab
	addq $16,%rax
	movq %rax,_CONVFMT(%rip)
	movq _symtab(%rip),%rcx
	movl $6,%edx
	movsd L25(%rip),%xmm0
	movl $L6,%esi
	movl $L16,%edi
	call _setsymtab
	addq $16,%rax
	movq %rax,_FILENAME(%rip)
	movq _symtab(%rip),%rcx
	movl $1,%edx
	movsd L25(%rip),%xmm0
	movl $L6,%esi
	movl $L17,%edi
	call _setsymtab
	movq %rax,_nfloc(%rip)
	addq $24,%rax
	movq %rax,_NF(%rip)
	movq _symtab(%rip),%rcx
	movl $1,%edx
	movsd L25(%rip),%xmm0
	movl $L6,%esi
	movl $L18,%edi
	call _setsymtab
	movq %rax,_nrloc(%rip)
	addq $24,%rax
	movq %rax,_NR(%rip)
	movq _symtab(%rip),%rcx
	movl $1,%edx
	movsd L25(%rip),%xmm0
	movl $L6,%esi
	movl $L19,%edi
	call _setsymtab
	movq %rax,_fnrloc(%rip)
	addq $24,%rax
	movq %rax,_FNR(%rip)
	movq _symtab(%rip),%rcx
	movl $6,%edx
	movsd L25(%rip),%xmm0
	movl $L21,%esi
	movl $L20,%edi
	call _setsymtab
	addq $16,%rax
	movq %rax,_SUBSEP(%rip)
	movq _symtab(%rip),%rcx
	movl $1,%edx
	movsd L25(%rip),%xmm0
	movl $L6,%esi
	movl $L22,%edi
	call _setsymtab
	movq %rax,_rstartloc(%rip)
	addq $24,%rax
	movq %rax,_RSTART(%rip)
	movq _symtab(%rip),%rcx
	movl $1,%edx
	movsd L25(%rip),%xmm0
	movl $L6,%esi
	movl $L23,%edi
	call _setsymtab
	movq %rax,_rlengthloc(%rip)
	addq $24,%rax
	movq %rax,_RLENGTH(%rip)
	movq _symtab(%rip),%rcx
	movl $16,%edx
	movsd L25(%rip),%xmm0
	movl $L6,%esi
	movl $L24,%edi
	call _setsymtab
	movq %rax,_symtabloc(%rip)
	movq _symtab(%rip),%rcx
	movq %rcx,16(%rax)
L3:
	ret 


_arginit:
L26:
	pushq %rbp
	movq %rsp,%rbp
	subq $56,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L27:
	movl %edi,%r12d
	movq %rsi,%rbx
	cvtsi2sdl %r12d,%xmm0
	movq _symtab(%rip),%rcx
	movl $1,%edx
	movl $L6,%esi
	movl $L29,%edi
	call _setsymtab
	addq $24,%rax
	movq %rax,_ARGC(%rip)
	movq _symtab(%rip),%rcx
	movl $16,%edx
	movsd L25(%rip),%xmm0
	movl $L6,%esi
	movl $L30,%edi
	call _setsymtab
	movq %rax,%r13
	movl $50,%edi
	call _makesymtab
	movq %rax,_ARGVtab(%rip)
	movq %rax,16(%r13)
	xorl %r14d,%r14d
	jmp L31
L32:
	leaq -50(%rbp),%rax
	pushq %r14
	pushq $L35
	pushq %rax
	call _sprintf
	addq $24,%rsp
	movq (%rbx),%rdi
	call _is_number
	movq (%rbx),%r13
	testl %eax,%eax
	jz L37
L36:
	movq %r13,%rdi
	call _atof
	movq _ARGVtab(%rip),%rcx
	movl $3,%edx
	jmp L39
L37:
	movq _ARGVtab(%rip),%rcx
	movl $2,%edx
	movsd L25(%rip),%xmm0
L39:
	movq %r13,%rsi
	leaq -50(%rbp),%rdi
	call _setsymtab
	addq $8,%rbx
	incl %r14d
L31:
	cmpl %r14d,%r12d
	jg L32
L28:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_envinit:
L40:
	pushq %rbx
	pushq %r12
	pushq %r13
L41:
	movq %rdi,%r13
	movq _symtab(%rip),%rcx
	movl $16,%edx
	movsd L25(%rip),%xmm0
	movl $L6,%esi
	movl $L43,%edi
	call _setsymtab
	movq %rax,%rbx
	movl $50,%edi
	call _makesymtab
	movq %rax,_ENVtab(%rip)
	movq %rax,16(%rbx)
	jmp L44
L45:
	movl $61,%esi
	call _strchr
	movq %rax,%r12
	testq %r12,%r12
	jz L46
L50:
	cmpq (%r13),%r12
	jz L46
L54:
	movb $0,(%r12)
	leaq 1(%r12),%rdi
	call _is_number
	movq (%r13),%rbx
	testl %eax,%eax
	jz L57
L56:
	leaq 1(%r12),%rdi
	call _atof
	movq _ENVtab(%rip),%rcx
	movl $3,%edx
	jmp L59
L57:
	movq _ENVtab(%rip),%rcx
	movl $2,%edx
	movsd L25(%rip),%xmm0
L59:
	leaq 1(%r12),%rsi
	movq %rbx,%rdi
	call _setsymtab
	movb $61,(%r12)
L46:
	addq $8,%r13
L44:
	movq (%r13),%rdi
	testq %rdi,%rdi
	jnz L45
L42:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_makesymtab:
L60:
	pushq %rbx
	pushq %r12
	pushq %r13
L61:
	movl %edi,%r13d
	movl $16,%edi
	call _malloc
	movq %rax,%r12
	movslq %r13d,%rdi
	movl $8,%esi
	call _calloc
	movq %rax,%rbx
	testq %r12,%r12
	jz L63
L66:
	testq %rbx,%rbx
	jnz L65
L63:
	pushq $L70
	call _FATAL
	addq $8,%rsp
L65:
	movl $0,(%r12)
	movl %r13d,4(%r12)
	movq %rbx,8(%r12)
	movq %r12,%rax
L62:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_freesymtab:
L72:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L73:
	movq %rdi,%r14
	testl $16,32(%r14)
	jz L74
L77:
	movq 16(%r14),%r13
	testq %r13,%r13
	jz L74
L81:
	xorl %r15d,%r15d
	jmp L83
L84:
	movq 8(%r13),%rcx
	movl %r15d,%eax
	movq (%rcx,%rax,8),%r12
L87:
	testq %r12,%r12
	jz L90
L88:
	movq 8(%r12),%rdi
	testq %rdi,%rdi
	jz L93
L91:
	call _free
	movq $0,8(%r12)
L93:
	movl 32(%r12),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L96
L94:
	movq 16(%r12),%rdi
	testq %rdi,%rdi
	jz L96
L97:
	call _free
	movq $0,16(%r12)
L96:
	movq 40(%r12),%rbx
	movq %r12,%rdi
	call _free
	decl (%r13)
	movq %rbx,%r12
	jmp L87
L90:
	movq 8(%r13),%rax
	movl %r15d,%r15d
	movq $0,(%rax,%r15,8)
	incl %r15d
L83:
	cmpl 4(%r13),%r15d
	jl L84
L86:
	cmpl $0,(%r13)
	jz L102
L100:
	pushq 8(%r14)
	pushq $L103
	call _WARNING
	addq $16,%rsp
L102:
	movq 8(%r13),%rdi
	call _free
	movq %r13,%rdi
	call _free
L74:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_freeelem:
L104:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L105:
	movq %rsi,%r15
	xorl %r14d,%r14d
	movq 16(%rdi),%r13
	movl 4(%r13),%esi
	movq %r15,%rdi
	call _hash
	movl %eax,%ebx
	movq 8(%r13),%rcx
	movslq %ebx,%rax
	movq (%rcx,%rax,8),%r12
L107:
	testq %r12,%r12
	jz L106
L108:
	movq 8(%r12),%rsi
	movq %r15,%rdi
	call _strcmp
	movq 40(%r12),%rcx
	testl %eax,%eax
	jz L111
L113:
	movq %r12,%r14
	movq %rcx,%r12
	jmp L107
L111:
	testq %r14,%r14
	jnz L115
L114:
	movq 8(%r13),%rax
	movslq %ebx,%rbx
	movq %rcx,(%rax,%rbx,8)
	jmp L116
L115:
	movq %rcx,40(%r14)
L116:
	movl 32(%r12),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L119
L117:
	movq 16(%r12),%rdi
	testq %rdi,%rdi
	jz L119
L120:
	call _free
	movq $0,16(%r12)
L119:
	movq 8(%r12),%rdi
	call _free
	movq %r12,%rdi
	call _free
	decl (%r13)
L106:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_setsymtab:
L124:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	movsd %xmm8,-8(%rbp)
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L125:
	movq %rdi,%r14
	movq %rsi,%r13
	movsd %xmm0,%xmm8
	movl %edx,%r12d
	movq %rcx,%rbx
	testq %r14,%r14
	jz L129
L130:
	movq %rbx,%rsi
	movq %r14,%rdi
	call _lookup
	movq %rax,%r15
	testq %r15,%r15
	jz L129
L127:
	cmpl $0,_dbg(%rip)
	jz L161
L134:
	movq 8(%r15),%rax
	testq %rax,%rax
	movl $L138,%edx
	cmovnzq %rax,%rdx
	movq 16(%r15),%rax
	testq %rax,%rax
	movl $L138,%ecx
	cmovnzq %rax,%rcx
	movsd 24(%r15),%xmm0
	movl 32(%r15),%eax
	subq $48,%rsp
	movl %eax,40(%rsp)
	movsd %xmm0,32(%rsp)
	movq %rcx,24(%rsp)
	movq %rdx,16(%rsp)
	movq %r15,8(%rsp)
	movq $L137,(%rsp)
	call _printf
	addq $48,%rsp
	jmp L161
L129:
	movl $48,%edi
	call _malloc
	movq %rax,%r15
	testq %r15,%r15
	jnz L148
L146:
	pushq %r14
	pushq $L149
	call _FATAL
	addq $16,%rsp
L148:
	movq %r14,%rdi
	call _tostring
	movq %rax,8(%r15)
	testq %r13,%r13
	jz L151
L150:
	movq %r13,%rdi
	jmp L162
L151:
	movl $L6,%edi
L162:
	call _tostring
	movq %rax,16(%r15)
	movsd %xmm8,24(%r15)
	movl %r12d,32(%r15)
	movb $0,1(%r15)
	movb $1,(%r15)
	movl (%rbx),%ecx
	incl %ecx
	movl %ecx,(%rbx)
	movl 4(%rbx),%eax
	shll $1,%eax
	cmpl %eax,%ecx
	jle L155
L153:
	movq %rbx,%rdi
	call _rehash
L155:
	movl 4(%rbx),%esi
	movq %r14,%rdi
	call _hash
	movq 8(%rbx),%rdx
	movslq %eax,%rcx
	movq (%rdx,%rcx,8),%rax
	movq %rax,40(%r15)
	movq 8(%rbx),%rax
	movq %r15,(%rax,%rcx,8)
	cmpl $0,_dbg(%rip)
	jz L161
L156:
	movq 8(%r15),%rdx
	movq 16(%r15),%rcx
	movsd 24(%r15),%xmm0
	movl 32(%r15),%eax
	subq $48,%rsp
	movl %eax,40(%rsp)
	movsd %xmm0,32(%rsp)
	movq %rcx,24(%rsp)
	movq %rdx,16(%rsp)
	movq %r15,8(%rsp)
	movq $L159,(%rsp)
	call _printf
	addq $48,%rsp
L161:
	movq %r15,%rax
L126:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movsd -8(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 


_hash:
L163:
L164:
	xorl %eax,%eax
	jmp L166
L167:
	movsbl %cl,%ecx
	imull $31,%eax,%eax
	addl %ecx,%eax
	incq %rdi
L166:
	movb (%rdi),%cl
	testb %cl,%cl
	jnz L167
L169:
	xorl %edx,%edx
	divl %esi
	movl %edx,%eax
L165:
	ret 


_rehash:
L171:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L172:
	movq %rdi,%r15
	movl 4(%r15),%edi
	movl %edi,-8(%rbp) # spill
	shll $2,%edi
	movslq %edi,%rdi
	movl %edi,-4(%rbp) # spill
	movl $8,%esi
	call _calloc
	movq %rax,%r14
	testq %r14,%r14
	jz L173
L176:
	xorl %r13d,%r13d
	jmp L178
L179:
	movq (%rdi,%r13,8),%r12
L182:
	testq %r12,%r12
	jz L185
L183:
	movq 40(%r12),%rbx
	movl -8(%rbp),%esi # spill
	shll $2,%esi
	movq 8(%r12),%rdi
	call _hash
	movslq %eax,%rcx
	movq (%r14,%rcx,8),%rax
	movq %rax,40(%r12)
	movq %r12,(%r14,%rcx,8)
	movq %rbx,%r12
	jmp L182
L185:
	incl %r13d
L178:
	movl 4(%r15),%eax
	movq 8(%r15),%rdi
	cmpl %eax,%r13d
	jl L179
L181:
	call _free
	movq %r14,8(%r15)
	movl -4(%rbp),%eax # spill
	movl %eax,4(%r15)
L173:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_lookup:
L186:
	pushq %rbx
	pushq %r12
L187:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl 4(%rbx),%esi
	movq %r12,%rdi
	call _hash
	movq 8(%rbx),%rcx
	movslq %eax,%rax
	movq (%rcx,%rax,8),%rbx
L189:
	testq %rbx,%rbx
	jz L192
L190:
	movq 8(%rbx),%rsi
	movq %r12,%rdi
	call _strcmp
	testl %eax,%eax
	jz L193
L195:
	movq 40(%rbx),%rbx
	jmp L189
L193:
	movq %rbx,%rax
	jmp L188
L192:
	xorl %eax,%eax
L188:
	popq %r12
	popq %rbx
	ret 


_setfval:
L198:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	movsd %xmm8,-8(%rbp)
	pushq %rbx
	pushq %r12
L199:
	movq %rdi,%rbx
	movsd %xmm0,%xmm8
	testl $3,32(%rbx)
	jnz L203
L201:
	movl $L204,%esi
	movq %rbx,%rdi
	call _funnyvar
L203:
	movl 32(%rbx),%eax
	testl $64,%eax
	jz L206
L205:
	movl $0,_donerec(%rip)
	movq 8(%rbx),%rdi
	call _atoi
	movl %eax,%r12d
	cvtsi2sdl %r12d,%xmm0
	movq _NF(%rip),%rax
	ucomisd (%rax),%xmm0
	jbe L210
L208:
	movl %r12d,%edi
	call _newfld
L210:
	cmpl $0,_dbg(%rip)
	jz L207
L211:
	subq $24,%rsp
	movsd %xmm8,16(%rsp)
	movl %r12d,8(%rsp)
	movq $L214,(%rsp)
	call _printf
	addq $24,%rsp
	jmp L207
L206:
	testl $128,%eax
	jz L207
L215:
	movl $0,_donefld(%rip)
	movl $1,_donerec(%rip)
L207:
	movl 32(%rbx),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L220
L218:
	movq 16(%rbx),%rdi
	testq %rdi,%rdi
	jz L220
L221:
	call _free
	movq $0,16(%rbx)
L220:
	movl 32(%rbx),%edx
	andl $-3,%edx
	orl $1,%edx
	movl %edx,32(%rbx)
	movsd L25(%rip),%xmm0
	ucomisd %xmm0,%xmm8
	jnz L226
L224:
	movsd %xmm0,%xmm8
L226:
	cmpl $0,_dbg(%rip)
	jz L229
L227:
	movq 8(%rbx),%rcx
	testq %rcx,%rcx
	movl $L138,%eax
	cmovnzq %rcx,%rax
	subq $40,%rsp
	movl %edx,32(%rsp)
	movsd %xmm8,24(%rsp)
	movq %rax,16(%rsp)
	movq %rbx,8(%rsp)
	movq $L230,(%rsp)
	call _printf
	addq $40,%rsp
L229:
	movsd %xmm8,24(%rbx)
	movsd %xmm8,%xmm0
L200:
	popq %r12
	popq %rbx
	movsd -8(%rbp),%xmm8
	movq %rbp,%rsp
	popq %rbp
	ret 


_funnyvar:
L235:
	pushq %rbx
	pushq %r12
L236:
	movq %rdi,%r12
	movq %rsi,%rbx
	testl $16,32(%r12)
	jz L240
L238:
	pushq 8(%r12)
	pushq %rbx
	pushq $L241
	call _FATAL
	addq $24,%rsp
L240:
	testl $32,32(%r12)
	jz L244
L242:
	pushq 8(%r12)
	pushq %rbx
	pushq $L245
	call _FATAL
	addq $24,%rsp
L244:
	movq 8(%r12),%rdx
	movq 16(%r12),%rcx
	movsd 24(%r12),%xmm0
	movl 32(%r12),%eax
	subq $48,%rsp
	movl %eax,40(%rsp)
	movsd %xmm0,32(%rsp)
	movq %rcx,24(%rsp)
	movq %rdx,16(%rsp)
	movq %r12,8(%rsp)
	movq $L246,(%rsp)
	call _WARNING
	addq $48,%rsp
L237:
	popq %r12
	popq %rbx
	ret 


_setsval:
L247:
	pushq %rbx
	pushq %r12
	pushq %r13
L248:
	movq %rdi,%r12
	movq %rsi,%rbx
	cmpl $0,_dbg(%rip)
	jz L252
L250:
	movq 8(%r12),%rax
	testq %rax,%rax
	movl $L138,%esi
	cmovnzq %rax,%rsi
	movl 32(%r12),%edx
	movl _donerec(%rip),%ecx
	movl _donefld(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq %rdx
	pushq %rbx
	pushq %rsi
	pushq %r12
	pushq $L253
	call _printf
	addq $56,%rsp
L252:
	testl $3,32(%r12)
	jnz L259
L257:
	movl $L204,%esi
	movq %r12,%rdi
	call _funnyvar
L259:
	movl 32(%r12),%eax
	testl $64,%eax
	jz L261
L260:
	movl $0,_donerec(%rip)
	movq 8(%r12),%rdi
	call _atoi
	movl %eax,%r13d
	cvtsi2sdl %r13d,%xmm0
	movq _NF(%rip),%rax
	ucomisd (%rax),%xmm0
	jbe L265
L263:
	movl %r13d,%edi
	call _newfld
L265:
	cmpl $0,_dbg(%rip)
	jz L262
L266:
	pushq %rbx
	pushq %rbx
	pushq %r13
	pushq $L269
	call _printf
	addq $32,%rsp
	jmp L262
L261:
	testl $128,%eax
	jz L262
L270:
	movl $0,_donefld(%rip)
	movl $1,_donerec(%rip)
L262:
	movq %rbx,%rdi
	call _tostring
	movq %rax,%rbx
	movl 32(%r12),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L275
L273:
	movq 16(%r12),%rdi
	testq %rdi,%rdi
	jz L275
L276:
	call _free
	movq $0,16(%r12)
L275:
	movl 32(%r12),%edx
	andl $-2,%edx
	orl $2,%edx
	andl $-5,%edx
	movl %edx,32(%r12)
	cmpl $0,_dbg(%rip)
	jz L281
L279:
	movq 8(%r12),%rcx
	testq %rcx,%rcx
	movl $L138,%eax
	cmovnzq %rcx,%rax
	movl _donerec(%rip),%esi
	movl _donefld(%rip),%ecx
	pushq %rcx
	pushq %rsi
	pushq %rdx
	pushq %rbx
	pushq %rbx
	pushq %rax
	pushq %r12
	pushq $L282
	call _printf
	addq $64,%rsp
L281:
	movq %rbx,16(%r12)
	movq %rbx,%rax
L249:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_getfval:
L287:
	pushq %rbx
L288:
	movq %rdi,%rbx
	testl $3,32(%rbx)
	jnz L292
L290:
	movl $L293,%esi
	movq %rbx,%rdi
	call _funnyvar
L292:
	movl 32(%rbx),%eax
	testl $64,%eax
	jz L295
L297:
	cmpl $0,_donefld(%rip)
	jnz L295
L294:
	call _fldbld
	jmp L296
L295:
	testl $128,%eax
	jz L296
L304:
	cmpl $0,_donerec(%rip)
	jnz L296
L301:
	call _recbld
L296:
	testl $1,32(%rbx)
	jnz L310
L308:
	movq 16(%rbx),%rdi
	call _atof
	movsd %xmm0,24(%rbx)
	movq 16(%rbx),%rdi
	call _is_number
	testl %eax,%eax
	jz L310
L314:
	movl 32(%rbx),%eax
	testl $8,%eax
	jnz L310
L311:
	orl $1,%eax
	movl %eax,32(%rbx)
L310:
	cmpl $0,_dbg(%rip)
	jz L320
L318:
	movq 8(%rbx),%rax
	testq %rax,%rax
	movl $L138,%ecx
	cmovnzq %rax,%rcx
	movsd 24(%rbx),%xmm0
	movl 32(%rbx),%eax
	subq $40,%rsp
	movl %eax,32(%rsp)
	movsd %xmm0,24(%rsp)
	movq %rcx,16(%rsp)
	movq %rbx,8(%rsp)
	movq $L321,(%rsp)
	call _printf
	addq $40,%rsp
L320:
	movsd 24(%rbx),%xmm0
L289:
	popq %rbx
	ret 


_get_str_val:
L326:
	pushq %rbp
	movq %rsp,%rbp
	subq $112,%rsp
	pushq %rbx
	pushq %r12
L327:
	movq %rdi,%rbx
	movq %rsi,%r12
	testl $3,32(%rbx)
	jnz L331
L329:
	movl $L293,%esi
	movq %rbx,%rdi
	call _funnyvar
L331:
	movl 32(%rbx),%eax
	testl $64,%eax
	jz L333
L335:
	cmpl $0,_donefld(%rip)
	jnz L333
L332:
	call _fldbld
	jmp L334
L333:
	testl $128,%eax
	jz L334
L342:
	cmpl $0,_donerec(%rip)
	jnz L334
L339:
	call _recbld
L334:
	movl 32(%rbx),%eax
	testl $2,%eax
	jnz L348
L346:
	andl $6,%eax
	cmpl $2,%eax
	jnz L351
L349:
	movq 16(%rbx),%rdi
	testq %rdi,%rdi
	jz L351
L352:
	call _free
	movq $0,16(%rbx)
L351:
	leaq -8(%rbp),%rdi
	movsd 24(%rbx),%xmm0
	call _modf
	leaq -108(%rbp),%rax
	movsd 24(%rbx),%xmm1
	ucomisd L25(%rip),%xmm0
	jnz L356
L355:
	subq $24,%rsp
	movsd %xmm1,16(%rsp)
	movq $L358,8(%rsp)
	jmp L367
L356:
	movq (%r12),%rcx
	subq $24,%rsp
	movsd %xmm1,16(%rsp)
	movq %rcx,8(%rsp)
L367:
	movq %rax,(%rsp)
	call _sprintf
	addq $24,%rsp
	leaq -108(%rbp),%rdi
	call _tostring
	movq %rax,16(%rbx)
	movl 32(%rbx),%eax
	andl $-5,%eax
	orl $2,%eax
	movl %eax,32(%rbx)
L348:
	cmpl $0,_dbg(%rip)
	jz L361
L359:
	movq 8(%rbx),%rax
	testq %rax,%rax
	movl $L138,%edx
	cmovnzq %rax,%rdx
	movq 16(%rbx),%rcx
	movl 32(%rbx),%eax
	pushq %rax
	pushq %rcx
	pushq %rcx
	pushq %rdx
	pushq %rbx
	pushq $L362
	call _printf
	addq $48,%rsp
L361:
	movq 16(%rbx),%rax
L328:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_getsval:
L368:
L369:
	movq _CONVFMT(%rip),%rsi
	call _get_str_val
L370:
	ret 


_getpssval:
L372:
L373:
	movq _OFMT(%rip),%rsi
	call _get_str_val
L374:
	ret 


_tostring:
L376:
	pushq %rbx
	pushq %r12
L377:
	movq %rdi,%r12
	movq %r12,%rdi
	call _strlen
	leaq 1(%rax),%rdi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L381
L379:
	pushq %r12
	pushq $L382
	call _FATAL
	addq $16,%rsp
L381:
	movq %r12,%rsi
	movq %rbx,%rdi
	call _strcpy
	movq %rbx,%rax
L378:
	popq %r12
	popq %rbx
	ret 


_qstring:
L384:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L385:
	movq %rdi,%r15
	movl %esi,%r14d
	movq %r15,%r13
	movq %r15,%rdi
	call _strlen
	leaq 3(%rax),%rdi
	call _malloc
	movq %rax,%r12
	testq %r12,%r12
	jnz L389
L387:
	pushq %r15
	pushq $L390
	call _FATAL
	addq $16,%rsp
L389:
	movq %r12,%rbx
L391:
	movzbl (%r13),%eax
	cmpl %eax,%r14d
	jz L394
L392:
	cmpl $10,%eax
	jnz L396
L395:
	pushq %r15
	pushq $L398
	call _SYNTAX
	addq $16,%rsp
	jmp L397
L396:
	cmpl $92,%eax
	jz L400
L399:
	movb %al,(%rbx)
	jmp L441
L400:
	leaq 1(%r13),%rsi
	movzbl 1(%r13),%edx
	movq %rsi,%r13
	testl %edx,%edx
	jz L402
L404:
	cmpl $92,%edx
	jz L409
	jl L406
L434:
	cmpl $116,%edx
	jz L413
	jg L406
L435:
	cmpb $98,%dl
	jz L415
L436:
	cmpb $102,%dl
	jz L417
L437:
	cmpb $110,%dl
	jz L411
L438:
	cmpb $114,%dl
	jnz L406
L419:
	movb $13,(%rbx)
	jmp L441
L411:
	movb $10,(%rbx)
	jmp L441
L417:
	movb $12,(%rbx)
	jmp L441
L415:
	movb $8,(%rbx)
	jmp L441
L413:
	movb $9,(%rbx)
	jmp L441
L406:
	testb $4,___ctype+1(%rdx)
	jz L442
L423:
	subl $48,%edx
	leaq 1(%rsi),%rcx
	movzbq 1(%rsi),%rax
	testb $4,___ctype+1(%rax)
	jz L442
L425:
	movzbl %al,%eax
	movq %rcx,%r13
	leal (%rax,%rdx,8),%edx
	subl $48,%edx
	leaq 2(%rsi),%rcx
	movzbq 2(%rsi),%rax
	testb $4,___ctype+1(%rax)
	jz L442
L428:
	movzbl %al,%eax
	movq %rcx,%r13
	leal (%rax,%rdx,8),%edx
	subl $48,%edx
L442:
	movb %dl,(%rbx)
	jmp L441
L409:
	movb $92,(%rbx)
L441:
	incq %rbx
L397:
	incq %r13
	jmp L391
L402:
	movb $92,(%rbx)
	incq %rbx
L394:
	movb $0,(%rbx)
	movq %r12,%rax
L386:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L6:
	.byte 0
L35:
	.byte 37,100,0
L17:
	.byte 78,70,0
L362:
	.byte 103,101,116,115,118,97,108,32
	.byte 37,112,58,32,37,115,32,61
	.byte 32,34,37,115,32,40,37,112
	.byte 41,34,44,32,116,61,37,111
	.byte 10,0
L293:
	.byte 114,101,97,100,32,118,97,108
	.byte 117,101,32,111,102,0
L13:
	.byte 79,70,77,84,0
L19:
	.byte 70,78,82,0
L11:
	.byte 79,70,83,0
L398:
	.byte 110,101,119,108,105,110,101,32
	.byte 105,110,32,115,116,114,105,110
	.byte 103,32,37,46,50,48,115,46
	.byte 46,46,0
L149:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,115,121,109,98,111,108,32
	.byte 116,97,98,108,101,32,97,116
	.byte 32,37,115,0
L246:
	.byte 102,117,110,110,121,32,118,97
	.byte 114,105,97,98,108,101,32,37
	.byte 112,58,32,110,61,37,115,32
	.byte 115,61,34,37,115,34,32,102
	.byte 61,37,103,32,116,61,37,111
	.byte 0
L137:
	.byte 115,101,116,115,121,109,116,97
	.byte 98,32,102,111,117,110,100,32
	.byte 37,112,58,32,110,61,37,115
	.byte 32,115,61,34,37,115,34,32
	.byte 102,61,37,103,32,116,61,37
	.byte 111,10,0
L16:
	.byte 70,73,76,69,78,65,77,69
	.byte 0
L390:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 113,115,116,114,105,110,103,40
	.byte 37,115,41,0
L282:
	.byte 115,101,116,115,118,97,108,32
	.byte 37,112,58,32,37,115,32,61
	.byte 32,34,37,115,32,40,37,112
	.byte 41,32,34,44,32,116,61,37
	.byte 111,32,114,44,102,61,37,100
	.byte 44,37,100,10,0
L22:
	.byte 82,83,84,65,82,84,0
L70:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 109,97,107,101,115,121,109,116
	.byte 97,98,0
L12:
	.byte 79,82,83,0
L5:
	.byte 36,122,101,114,111,38,110,117
	.byte 108,108,0
L43:
	.byte 69,78,86,73,82,79,78,0
L10:
	.byte 10,0
L382:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 116,111,115,116,114,105,110,103
	.byte 32,111,110,32,37,115,0
L18:
	.byte 78,82,0
L15:
	.byte 67,79,78,86,70,77,84,0
L358:
	.byte 37,46,51,48,103,0
L214:
	.byte 115,101,116,116,105,110,103,32
	.byte 102,105,101,108,100,32,37,100
	.byte 32,116,111,32,37,103,10,0
L8:
	.byte 32,0
L9:
	.byte 82,83,0
L204:
	.byte 97,115,115,105,103,110,32,116
	.byte 111,0
L30:
	.byte 65,82,71,86,0
L7:
	.byte 70,83,0
L29:
	.byte 65,82,71,67,0
L230:
	.byte 115,101,116,102,118,97,108,32
	.byte 37,112,58,32,37,115,32,61
	.byte 32,37,103,44,32,116,61,37
	.byte 111,10,0
L241:
	.byte 99,97,110,39,116,32,37,115
	.byte 32,37,115,59,32,105,116,39
	.byte 115,32,97,110,32,97,114,114
	.byte 97,121,32,110,97,109,101,46
	.byte 0
L159:
	.byte 115,101,116,115,121,109,116,97
	.byte 98,32,115,101,116,32,37,112
	.byte 58,32,110,61,37,115,32,115
	.byte 61,34,37,115,34,32,102,61
	.byte 37,103,32,116,61,37,111,10
	.byte 0
L253:
	.byte 115,116,97,114,116,105,110,103
	.byte 32,115,101,116,115,118,97,108
	.byte 32,37,112,58,32,37,115,32
	.byte 61,32,34,37,115,34,44,32
	.byte 116,61,37,111,44,32,114,44
	.byte 102,61,37,100,44,37,100,10
	.byte 0
L20:
	.byte 83,85,66,83,69,80,0
L138:
	.byte 40,110,117,108,108,41,0
L103:
	.byte 99,97,110,39,116,32,104,97
	.byte 112,112,101,110,58,32,105,110
	.byte 99,111,110,115,105,115,116,101
	.byte 110,116,32,101,108,101,109,101
	.byte 110,116,32,99,111,117,110,116
	.byte 32,102,114,101,101,105,110,103
	.byte 32,37,115,0
L4:
	.byte 48,0
L21:
	.byte 28,0
L245:
	.byte 99,97,110,39,116,32,37,115
	.byte 32,37,115,59,32,105,116,39
	.byte 115,32,97,32,102,117,110,99
	.byte 116,105,111,110,46,0
L321:
	.byte 103,101,116,102,118,97,108,32
	.byte 37,112,58,32,37,115,32,61
	.byte 32,37,103,44,32,116,61,37
	.byte 111,10,0
L23:
	.byte 82,76,69,78,71,84,72,0
L14:
	.byte 37,46,54,103,0
L269:
	.byte 115,101,116,116,105,110,103,32
	.byte 102,105,101,108,100,32,37,100
	.byte 32,116,111,32,37,115,32,40
	.byte 37,112,41,10,0
L24:
	.byte 83,89,77,84,65,66,0
.globl _FS
.comm _FS, 8, 8
.globl _RS
.comm _RS, 8, 8
.globl _ORS
.comm _ORS, 8, 8
.globl _OFS
.comm _OFS, 8, 8
.globl _OFMT
.comm _OFMT, 8, 8
.globl _NR
.comm _NR, 8, 8
.globl _FNR
.comm _FNR, 8, 8
.globl _NF
.comm _NF, 8, 8
.globl _FILENAME
.comm _FILENAME, 8, 8
.globl _SUBSEP
.comm _SUBSEP, 8, 8
.globl _RSTART
.comm _RSTART, 8, 8
.globl _RLENGTH
.comm _RLENGTH, 8, 8
.globl _symtab
.comm _symtab, 8, 8
.globl _nrloc
.comm _nrloc, 8, 8
.globl _fnrloc
.comm _fnrloc, 8, 8
.globl _nfloc
.comm _nfloc, 8, 8
.globl _rstartloc
.comm _rstartloc, 8, 8
.globl _rlengthloc
.comm _rlengthloc, 8, 8
.globl _nullnode
.comm _nullnode, 8, 8
.globl _CONVFMT
.comm _CONVFMT, 8, 8
.globl _ARGC
.comm _ARGC, 8, 8
.globl _fsloc
.comm _fsloc, 8, 8
.globl _ARGVtab
.comm _ARGVtab, 8, 8
.globl _ENVtab
.comm _ENVtab, 8, 8
.globl _symtabloc
.comm _symtabloc, 8, 8
.globl _nullloc
.comm _nullloc, 8, 8
.globl _literal0
.comm _literal0, 8, 8

.globl _fldbld
.globl _free
.globl _celltonode
.globl _sprintf
.globl _ORS
.globl _FS
.globl _syminit
.globl _NF
.globl _ENVtab
.globl _getsval
.globl _envinit
.globl _setfval
.globl _nullnode
.globl _makesymtab
.globl _dbg
.globl _hash
.globl _donefld
.globl _malloc
.globl _ARGC
.globl _nullloc
.globl _SYNTAX
.globl _rlengthloc
.globl _is_number
.globl _freesymtab
.globl _nfloc
.globl _OFMT
.globl _setsymtab
.globl _nrloc
.globl _atoi
.globl _printf
.globl _tostring
.globl _SUBSEP
.globl _FNR
.globl _OFS
.globl _RS
.globl _symtabloc
.globl _funnyvar
.globl _strcmp
.globl _calloc
.globl _getpssval
.globl ___ctype
.globl _WARNING
.globl _symtab
.globl _FILENAME
.globl _literal0
.globl _ARGVtab
.globl _lookup
.globl _arginit
.globl _fsloc
.globl _freeelem
.globl _fnrloc
.globl _modf
.globl _rstartloc
.globl _NR
.globl _strlen
.globl _strchr
.globl _donerec
.globl _RLENGTH
.globl _FATAL
.globl _strcpy
.globl _CONVFMT
.globl _newfld
.globl _getfval
.globl _RSTART
.globl _setsval
.globl _recbld
.globl _rehash
.globl _qstring
.globl _atof
