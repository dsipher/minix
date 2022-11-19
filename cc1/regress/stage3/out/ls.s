.data
_l_ifmt:
	.byte 48,112,99,67,100,63,98,66
	.byte 45,63,108,63,115,63,63,63
	.byte 0
.align 4
_ncols:
	.int 79
.text

_heaperr:
L1:
L2:
	pushq _arg0(%rip)
	pushq $L4
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $-1,%edi
	call _exit
L3:
	ret 


_allocate:
L5:
	pushq %rbx
L6:
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L10
L8:
	call _heaperr
L10:
	movq %rbx,%rax
L7:
	popq %rbx
	ret 


_reallocate:
L12:
	pushq %rbx
L13:
	call _realloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L17
L15:
	call _heaperr
L17:
	movq %rbx,%rax
L14:
	popq %rbx
	ret 

.data
_allowed:
	.byte 97,99,100,102,103,104,105,108
	.byte 110,112,113,114,115,116,117,49
	.byte 65,67,70,76,77,82,84,88
	.byte 0
.text

_setflags:
L19:
	pushq %rbx
	pushq %r12
L20:
	movq %rdi,%r12
L22:
	movsbl (%r12),%ebx
	incq %r12
	testl %ebx,%ebx
	jz L21
L23:
	movl %ebx,%esi
	movl $_allowed,%edi
	call _strchr
	testq %rax,%rax
	jnz L26
L25:
	pushq $_allowed
	pushq _arg0(%rip)
	pushq $L28
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl $1,%edi
	call _exit
	jmp L22
L26:
	movl %ebx,%esi
	movl $_flags,%edi
	call _strchr
	testq %rax,%rax
	jnz L22
L29:
	movl $_flags,%edi
	call _strlen
	movb %bl,_flags(%rax)
	jmp L22
L21:
	popq %r12
	popq %rbx
	ret 


_present:
L32:
L33:
	movl %edi,%esi
	testl %esi,%esi
	jz L36
L35:
	movl $_flags,%edi
	call _strchr
	testq %rax,%rax
	jz L37
L36:
	movl $1,%eax
	ret
L37:
	xorl %eax,%eax
L34:
	ret 


_report:
L40:
	pushq %rbx
L41:
	movq %rdi,%rbx
	movl _errno(%rip),%edi
	call _strerror
	pushq %rax
	pushq %rbx
	pushq _arg0(%rip)
	pushq $L43
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movl $1,_ex(%rip)
L42:
	popq %rbx
	ret 


_idname:
L44:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L45:
	movl %edi,%r14d
	movl %esi,%r13d
	testl %r13d,%r13d
	movl $_gids,%eax
	movl $_uids,%ecx
	cmovnzq %rax,%rcx
	movl %r14d,%eax
	andl $31,%eax
	leaq (%rcx,%rax,8),%r12
	jmp L50
L53:
	cmpl 16(%rbx),%r14d
	jae L52
L51:
	movq %rbx,%r12
L50:
	movq (%r12),%rbx
	testq %rbx,%rbx
	jnz L53
L52:
	testq %rbx,%rbx
	jz L57
L60:
	cmpl 16(%rbx),%r14d
	jz L59
L57:
	xorl %r15d,%r15d
	movl $110,%edi
	call _present
	testl %eax,%eax
	jnz L66
L64:
	testl %r13d,%r13d
	jnz L68
L67:
	movl %r14d,%edi
	call _getpwuid
	testq %rax,%rax
	jz L66
	jnz L81
L68:
	movl %r14d,%edi
	call _getgrgid
	testq %rax,%rax
	jz L66
L81:
	movq (%rax),%r15
L66:
	testq %r15,%r15
	jnz L78
L76:
	leaq -12(%rbp),%r15
	pushq %r14
	pushq $L79
	pushq %r15
	call _sprintf
	addq $24,%rsp
L78:
	movl $24,%edi
	call _allocate
	movq %rax,%rbx
	movl %r14d,16(%rbx)
	movq %r15,%rdi
	call _strlen
	leaq 1(%rax),%rdi
	call _allocate
	movq %rax,8(%rbx)
	movq %r15,%rsi
	movq %rax,%rdi
	call _strcpy
	movq (%r12),%rax
	movq %rax,(%rbx)
	movq %rbx,(%r12)
L59:
	movq 8(%rbx),%rax
L46:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 4
_plen:
	.int 0
.align 4
_pidx:
	.int 0
.text

_addpath:
L82:
	pushq %rbx
	pushq %r12
L83:
	movq %rdi,%r12
	movq %rsi,%rbx
	cmpl $0,_plen(%rip)
	jnz L87
L85:
	movl $32,_plen(%rip)
	movl $32,%edi
	call _allocate
	movq %rax,_path(%rip)
L87:
	cmpl $1,_pidx(%rip)
	jnz L90
L91:
	movq _path(%rip),%rax
	cmpb $46,(%rax)
	jnz L90
L92:
	movl $0,_pidx(%rip)
L90:
	movl _pidx(%rip),%eax
	movl %eax,(%r12)
	movl _pidx(%rip),%eax
	cmpl $0,%eax
	jle L102
L98:
	movl %eax,%ecx
	decl %ecx
	movslq %ecx,%rcx
	movq _path(%rip),%rdx
	cmpb $47,(%rcx,%rdx)
	jz L102
L99:
	leal 1(%rax),%ecx
	movl %ecx,_pidx(%rip)
	movslq %eax,%rax
	movb $47,(%rdx,%rax)
L102:
	cmpb $47,(%rbx)
	jnz L109
L112:
	movl _pidx(%rip),%eax
	testl %eax,%eax
	jz L109
L114:
	decl %eax
	movslq %eax,%rax
	movq _path(%rip),%rcx
	cmpb $47,(%rax,%rcx)
	jz L107
L109:
	movl _plen(%rip),%esi
	cmpl _pidx(%rip),%esi
	jnz L118
L116:
	shll $1,%esi
	movl %esi,_plen(%rip)
	movslq %esi,%rsi
	movq _path(%rip),%rdi
	call _reallocate
	movq %rax,_path(%rip)
L118:
	movb (%rbx),%dl
	movl _pidx(%rip),%eax
	leal 1(%rax),%ecx
	movl %ecx,_pidx(%rip)
	movslq %eax,%rax
	movq _path(%rip),%rcx
	movb %dl,(%rax,%rcx)
L107:
	movb (%rbx),%al
	incq %rbx
	testb %al,%al
	jnz L102
L103:
	decl _pidx(%rip)
L84:
	popq %r12
	popq %rbx
	ret 

.data
.align 4
_field:
	.int 0
.text

_setstat:
L119:
L120:
	movl 8(%rsi),%eax
	movl %eax,16(%rdi)
	movl 24(%rsi),%eax
	movl %eax,20(%rdi)
	movl 16(%rsi),%eax
	movl %eax,32(%rdi)
	movl 28(%rsi),%eax
	movl %eax,24(%rdi)
	movl 32(%rsi),%eax
	movl %eax,28(%rdi)
	movl 40(%rsi),%eax
	movl %eax,36(%rdi)
	movq 48(%rsi),%rax
	movq %rax,40(%rdi)
	movq 88(%rsi),%rax
	movq %rax,48(%rdi)
	movq 72(%rsi),%rax
	movq %rax,56(%rdi)
	movq 104(%rsi),%rax
	movq %rax,64(%rdi)
L121:
	ret 

.local L125
.comm L125, 8, 8
.data
.align 4
L126:
	.int 0
L127:
	.byte 74,97,110,32,49,57,32,48
	.byte 51,58,49,52,58,48,55,32
	.byte 50,48,51,56,0
L128:
	.byte 74,97,110,70,101,98,77,97
	.byte 114,65,112,114,77,97,121,74
	.byte 117,110,74,117,108,65,117,103
	.byte 83,101,112,79,99,116,78,111
	.byte 118,68,101,99,0
.text

_timestamp:
L122:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L123:
	movq 48(%rdi),%rax
	movq %rax,-8(%rbp)
	movl _field(%rip),%ecx
	testl $128,%ecx
	jz L131
L129:
	movq 56(%rdi),%rax
	movq %rax,-8(%rbp)
L131:
	testl $256,%ecx
	jz L134
L132:
	movq 64(%rdi),%rax
	movq %rax,-8(%rbp)
L134:
	leaq -8(%rbp),%rdi
	call _localtime
	movq %rax,%rbx
	decl L126(%rip)
	jns L137
L135:
	movl $L125,%edi
	call _time
	movl $50,L126(%rip)
L137:
	testl $4096,_field(%rip)
	jz L139
L138:
	imull $3,16(%rbx),%r8d
	movslq %r8d,%r8
	addq $L128,%r8
	movl 12(%rbx),%edi
	movl 8(%rbx),%esi
	movl 4(%rbx),%edx
	movl (%rbx),%ecx
	movl 20(%rbx),%eax
	addl $1900,%eax
	pushq %rax
	pushq %rcx
	pushq %rdx
	pushq %rsi
	pushq %rdi
	pushq %r8
	pushq $L141
	pushq $L127
	call _sprintf
	addq $64,%rsp
	jmp L140
L139:
	movq L125(%rip),%rax
	movq %rax,%rcx
	subq $15724800,%rcx
	movq -8(%rbp),%rdx
	cmpq %rcx,%rdx
	jl L146
L145:
	addq $604800,%rax
	cmpq %rax,%rdx
	jle L147
L146:
	imull $3,16(%rbx),%edx
	movslq %edx,%rdx
	addq $L128,%rdx
	movl 12(%rbx),%ecx
	movl 20(%rbx),%eax
	addl $1900,%eax
	pushq %rax
	pushq %rcx
	pushq %rdx
	pushq $L149
	pushq $L127
	call _sprintf
	addq $40,%rsp
	jmp L140
L147:
	imull $3,16(%rbx),%esi
	movslq %esi,%rsi
	addq $L128,%rsi
	movl 12(%rbx),%edx
	movl 8(%rbx),%ecx
	movl 4(%rbx),%eax
	pushq %rax
	pushq %rcx
	pushq %rdx
	pushq %rsi
	pushq $L150
	pushq $L127
	call _sprintf
	addq $48,%rsp
L140:
	movl $L127,%eax
L124:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
L155:
	.byte 100,114,119,120,114,45,120,45
	.byte 45,120,0
L180:
	.byte 120
	.byte 103
	.byte 117
	.byte 115
.text

_permissions:
L152:
L153:
	movl 20(%rdi),%eax
	shrl $12,%eax
	andl $15,%eax
	movb _l_ifmt(%rax),%al
	movb %al,L155(%rip)
	testl $4,_field(%rip)
	movl 20(%rdi),%eax
	jz L157
L156:
	xorl %esi,%esi
	movl 24(%rdi),%ecx
	cmpl _uid(%rip),%ecx
	jnz L160
L159:
	movl %eax,%ecx
	shll $3,%ecx
	movl %eax,%esi
	shll $6,%esi
	orl %ecx,%esi
	jmp L161
L160:
	movl 28(%rdi),%ecx
	cmpl _gid(%rip),%ecx
	jnz L163
L162:
	shll $3,%eax
	jmp L161
L163:
	shll $6,%eax
L161:
	testl $256,%eax
	jz L166
L165:
	testl $256,%esi
	movl $114,%ecx
	movl $82,%edx
	cmovzl %ecx,%edx
	jmp L167
L166:
	movl $45,%edx
L167:
	movb %dl,L155+1(%rip)
	testl $128,%eax
	jz L172
L171:
	testl $128,%esi
	movl $119,%ecx
	movl $87,%edx
	cmovzl %ecx,%edx
	jmp L173
L172:
	movl $45,%edx
L173:
	movb %dl,L155+2(%rip)
	andl $64,%eax
	movl 20(%rdi),%ecx
	andl $3072,%ecx
	testl %eax,%eax
	jz L178
L177:
	shrl $10,%ecx
	movb L180(%rcx),%al
	movb %al,L155+3(%rip)
	testl $64,%esi
	jz L179
L181:
	addb $-32,%al
	movb %al,L155+3(%rip)
	jmp L179
L178:
	testl %ecx,%ecx
	movl $45,%eax
	movl $61,%ecx
	cmovzl %eax,%ecx
	movb %cl,L155+3(%rip)
L179:
	movb $0,L155+4(%rip)
	jmp L158
L157:
	movl $L155+1,%esi
L187:
	testl $256,%eax
	movl $45,%ecx
	movl $114,%edx
	cmovzl %ecx,%edx
	movb %dl,(%rsi)
	testl $128,%eax
	movl $45,%ecx
	movl $119,%edx
	cmovzl %ecx,%edx
	movb %dl,1(%rsi)
	testl $64,%eax
	movl $45,%ecx
	movl $120,%edx
	cmovzl %ecx,%edx
	movb %dl,2(%rsi)
	shll $3,%eax
	addq $3,%rsi
	cmpq $L155+7,%rsi
	jbe L187
L188:
	movl 20(%rdi),%eax
	testl $2048,%eax
	jz L201
L199:
	testl $64,%eax
	movl $61,%eax
	movl $115,%ecx
	cmovzl %eax,%ecx
	movb %cl,L155+3(%rip)
L201:
	movl 20(%rdi),%eax
	testl $1024,%eax
	jz L207
L205:
	testl $8,%eax
	movl $61,%eax
	movl $115,%ecx
	cmovzl %eax,%ecx
	movb %cl,L155+6(%rip)
L207:
	movl 20(%rdi),%eax
	testl $512,%eax
	jz L158
L211:
	testl $1,%eax
	movl $61,%eax
	movl $116,%ecx
	cmovzl %eax,%ecx
	movb %cl,L155+9(%rip)
L158:
	movl $L155,%eax
L154:
	ret 


_numeral:
L218:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
L219:
	leaq -12(%rbp),%r8
L221:
	movl $10,%ecx
	movl %edi,%eax
	cltd 
	idivl %ecx
	addb $48,%dl
	movb %dl,(%r8)
	incq %r8
	movl $10,%ecx
	movl %edi,%eax
	cltd 
	idivl %ecx
	movl %eax,%edi
	cmpl $0,%edi
	jg L221
L224:
	leaq -1(%r8),%rdi
	movb -1(%r8),%dl
	movq (%rsi),%rcx
	movq %rdi,%r8
	leaq 1(%rcx),%rax
	movq %rax,(%rsi)
	movb %dl,(%rcx)
	leaq -12(%rbp),%rax
	cmpq %rax,%rdi
	ja L224
L220:
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
L230:
	.byte 49,46,50,109,0
.text

_cxsize:
L227:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L228:
	movq $L230,-8(%rbp)
	movb $0,L230+3(%rip)
	movb $0,L230+2(%rip)
	movb $0,L230+1(%rip)
	movq 40(%rdi),%rdi
	cmpq $5120,%rdi
	jle L231
L233:
	movl $1024,%ecx
	leaq 1023(%rdi),%rax
	cqto 
	idivq %rcx
	movq %rax,%rdi
	cmpq $999,%rdi
	jg L236
L235:
	leaq -8(%rbp),%rsi
	call _numeral
	movq -8(%rbp),%rax
	movb $107,(%rax)
	jmp L246
L236:
	leaq (%rdi,%rdi,4),%rax
	addq %rax,%rax
	cmpq $99000,%rax
	jg L239
L238:
	movl $1000,%ecx
	addq $999,%rax
	cqto 
	idivq %rcx
	movl %eax,%ebx
	movl $10,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	leaq -8(%rbp),%rsi
	movl %eax,%edi
	call _numeral
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $46,(%rcx)
	movl $10,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	leaq -8(%rbp),%rsi
	movl %edx,%edi
	jmp L247
L239:
	cmpq $999000,%rdi
	jg L242
L241:
	movl $1000,%ecx
	leaq 999(%rdi),%rax
	cqto 
	idivq %rcx
	leaq -8(%rbp),%rsi
	movl %eax,%edi
L247:
	call _numeral
	movq -8(%rbp),%rax
	movb $109,(%rax)
	jmp L246
L242:
	movl $1000000,%ecx
	addq $999999,%rax
	cqto 
	idivq %rcx
	movl %eax,%ebx
	movl $10,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	leaq -8(%rbp),%rsi
	movl %eax,%edi
	call _numeral
	movq -8(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-8(%rbp)
	movb $46,(%rcx)
	movl $10,%ecx
	movl %ebx,%eax
	cltd 
	idivl %ecx
	leaq -8(%rbp),%rsi
	movl %edx,%edi
	call _numeral
	movq -8(%rbp),%rax
	movb $103,(%rax)
	jmp L246
L231:
	leaq -8(%rbp),%rsi
	call _numeral
L246:
	movl $L230,%eax
L229:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_mergesort:
L248:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L249:
	movq %rdi,%r12
	movq (%r12),%rcx
	movq (%rcx),%rax
L251:
	movq (%rax),%rax
	testq %rax,%rax
	jz L252
L256:
	movq (%rcx),%rcx
	movq (%rax),%rax
	testq %rax,%rax
	jnz L251
L252:
	movq (%rcx),%rax
	movq %rax,-8(%rbp)
	movq $0,(%rcx)
	movq (%r12),%rax
	cmpq $0,(%rax)
	jz L260
L258:
	movq %r12,%rdi
	call _mergesort
L260:
	movq -8(%rbp),%rax
	cmpq $0,(%rax)
	jz L263
L261:
	leaq -8(%rbp),%rdi
	call _mergesort
L263:
	movq (%r12),%rbx
L264:
	movq -8(%rbp),%rsi
	movq _CMP(%rip),%rax
	movq %rbx,%rdi
	call *%rax
	cmpl $0,%eax
	jg L269
L268:
	movq (%rbx),%rax
	movq %rbx,%r12
	movq %rax,%rbx
	testq %rax,%rax
	jnz L264
L271:
	movq -8(%rbp),%rax
	movq %rax,(%r12)
	jmp L250
L269:
	movq -8(%rbp),%rax
	movq %rax,(%r12)
	movq -8(%rbp),%r12
	movq (%r12),%rax
	movq %rax,-8(%rbp)
	movq %rbx,(%r12)
	cmpq $0,-8(%rbp)
	jnz L264
L250:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_namecmp:
L279:
L280:
	movq 8(%rdi),%rdi
	movq 8(%rsi),%rsi
	call _strcmp
L281:
	ret 


_mtimecmp:
L283:
L284:
	movq 48(%rdi),%rax
	cmpq 48(%rsi),%rax
	jz L286
	jl L290
L289:
	movl $-1,%eax
	ret
L290:
	movl $1,%eax
	ret
L286:
	xorl %eax,%eax
L285:
	ret 


_atimecmp:
L293:
L294:
	movq 56(%rdi),%rax
	cmpq 56(%rsi),%rax
	jz L296
	jl L300
L299:
	movl $-1,%eax
	ret
L300:
	movl $1,%eax
	ret
L296:
	xorl %eax,%eax
L295:
	ret 


_ctimecmp:
L303:
L304:
	movq 64(%rdi),%rax
	cmpq 64(%rsi),%rax
	jz L306
	jl L310
L309:
	movl $-1,%eax
	ret
L310:
	movl $1,%eax
	ret
L306:
	xorl %eax,%eax
L305:
	ret 


_revcmp:
L313:
L314:
	movq _rCMP(%rip),%rax
	movq %rsi,%rcx
	movq %rdi,%rsi
	movq %rcx,%rdi
	call *%rax
L315:
	ret 


_sort:
L317:
	pushq %rbx
L318:
	movq %rdi,%rbx
	movl $102,%edi
	call _present
	testl %eax,%eax
	jnz L319
L327:
	movq (%rbx),%rax
	testq %rax,%rax
	jz L319
L328:
	cmpq $0,(%rax)
	jz L319
L324:
	movq $_namecmp,_CMP(%rip)
	testl $64,_field(%rip)
	jnz L332
L331:
	movl $114,%edi
	call _present
	testl %eax,%eax
	jz L346
	jnz L347
L332:
	movq %rbx,%rdi
	call _mergesort
	movl _field(%rip),%eax
	testl $256,%eax
	jz L338
L337:
	movq $_ctimecmp,_CMP(%rip)
	jmp L339
L338:
	testl $128,%eax
	jz L341
L340:
	movq $_atimecmp,_CMP(%rip)
	jmp L339
L341:
	movq $_mtimecmp,_CMP(%rip)
L339:
	movl $114,%edi
	call _present
	testl %eax,%eax
	jz L346
L347:
	movq _CMP(%rip),%rax
	movq %rax,_rCMP(%rip)
	movq $_revcmp,_CMP(%rip)
L346:
	movq %rbx,%rdi
	call _mergesort
L319:
	popq %rbx
	ret 


_newfile:
L348:
	pushq %rbx
	pushq %r12
L349:
	movq %rdi,%r12
	movl $72,%edi
	call _allocate
	movq %rax,%rbx
	movq %r12,%rdi
	call _strlen
	leaq 1(%rax),%rdi
	call _allocate
	movq %r12,%rsi
	movq %rax,%rdi
	call _strcpy
	movq %rax,8(%rbx)
	movq %rbx,%rax
L350:
	popq %r12
	popq %rbx
	ret 


_pushfile:
L352:
L353:
	movq (%rdi),%rax
	movq %rax,(%rsi)
	movq %rsi,(%rdi)
L354:
	ret 


_delfile:
L355:
	pushq %rbx
L356:
	movq %rdi,%rbx
	movq 8(%rbx),%rdi
	call _free
	movq %rbx,%rdi
	call _free
L357:
	popq %rbx
	ret 


_popfile:
L358:
L359:
	movq (%rdi),%rax
	movq (%rax),%rcx
	movq %rcx,(%rdi)
L360:
	ret 


_dotflag:
L362:
L363:
	movb (%rdi),%al
	incq %rdi
	cmpb $46,%al
	jnz L365
L367:
	movb (%rdi),%al
	incq %rdi
	testb %al,%al
	jz L380
L382:
	cmpb $46,%al
	jnz L369
L374:
	cmpb $0,(%rdi)
	jz L380
L369:
	movl $65,%eax
	ret
L380:
	movl $97,%eax
	ret
L365:
	xorl %eax,%eax
L364:
	ret 


_adddir:
L385:
	pushq %rbx
	pushq %r12
	pushq %r13
L386:
	movq %rdi,%r13
	movq %rsi,%rbx
	xorl %esi,%esi
	movq %rbx,%rdi
	call _access
	cmpl $0,%eax
	jl L407
L390:
	movq %rbx,%rdi
	call _opendir
	movq %rax,%r12
	testq %r12,%r12
	jz L407
L396:
	movq %r12,%rdi
	call _readdir
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L398
L397:
	cmpl $0,(%rbx)
	jz L396
L402:
	leaq 18(%rbx),%rdi
	call _dotflag
	movl %eax,%edi
	call _present
	testl %eax,%eax
	jz L396
L399:
	leaq 18(%rbx),%rdi
	call _newfile
	movq %rax,%rsi
	movq %r13,%rdi
	call _pushfile
	movq (%r13),%r13
	jmp L396
L398:
	movq %r12,%rdi
	call _closedir
	movl $1,%eax
	jmp L387
L407:
	movq %rbx,%rdi
	call _report
	xorl %eax,%eax
L387:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_countblocks:
L408:
L409:
	xorl %esi,%esi
	jmp L411
L412:
	movl 20(%rdi),%eax
	andl $61440,%eax
	cmpl $16384,%eax
	jz L418
L421:
	cmpl $32768,%eax
	jnz L415
L418:
	movq 40(%rdi),%rax
	movl $512,%ecx
	addq $511,%rax
	cqto 
	idivq %rcx
	addq %rax,%rsi
L415:
	movq (%rdi),%rdi
L411:
	testq %rdi,%rdi
	jnz L412
L413:
	movq %rsi,%rax
L410:
	ret 


_printname:
L424:
	pushq %rbx
	pushq %r12
L425:
	movq %rdi,%r12
	movl $113,%edi
	call _present
	movl %eax,%ebx
L427:
	movzbl (%r12),%edi
	incq %r12
	testl %edi,%edi
	jz L426
L428:
	testl %ebx,%ebx
	jz L432
L433:
	cmpl $32,%edi
	jl L430
L437:
	cmpl $127,%edi
	jnz L432
L430:
	movl $63,%edi
L432:
	decl ___stdout(%rip)
	js L442
L441:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb %dil,(%rcx)
	jmp L427
L442:
	movl $___stdout,%esi
	call ___flushbuf
	jmp L427
L426:
	popq %r12
	popq %rbx
	ret 


_mark:
L444:
	pushq %rbx
L445:
	movl _field(%rip),%eax
	xorl %ebx,%ebx
	testl $512,%eax
	jz L448
L447:
	movl 20(%rdi),%eax
	movl %eax,%ecx
	andl $61440,%ecx
	cmpl $16384,%ecx
	jz L477
L479:
	cmpl $32768,%ecx
	jnz L449
L455:
	testl $73,%eax
	movl $42,%eax
	cmovnzl %eax,%ebx
	jmp L449
L448:
	testl $1024,%eax
	jz L449
L460:
	movl 20(%rdi),%eax
	andl $61440,%eax
	cmpl $16384,%eax
	jnz L449
L477:
	movl $47,%ebx
L449:
	testl %esi,%esi
	jz L468
L469:
	testl %ebx,%ebx
	jz L468
L466:
	decl ___stdout(%rip)
	js L474
L473:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb %bl,(%rcx)
	jmp L468
L474:
	movl $___stdout,%esi
	movl %ebx,%edi
	call ___flushbuf
L468:
	movl %ebx,%eax
L446:
	popq %rbx
	ret 


_maxise:
L482:
L483:
	movzbl (%rdi),%eax
	cmpl %eax,%esi
	jle L484
L485:
	cmpl $255,%esi
	movl $255,%eax
	cmovgl %eax,%esi
	movb %sil,(%rdi)
L484:
	ret 


_numwidth:
L491:
L492:
	movq %rdi,%rax
	xorl %esi,%esi
L494:
	incl %esi
	movl $10,%ecx
	xorl %edx,%edx
	divq %rcx
	testq %rax,%rax
	jnz L494
L495:
	movl %esi,%eax
L493:
	ret 


_numxwidth:
L498:
L499:
	xorl %eax,%eax
L501:
	incl %eax
	shrq $4,%rdi
	jnz L501
L500:
	ret 

.data
.align 4
_nsp:
	.int 0
.text

_print1:
L505:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L506:
	movq %rdi,%r14
	movl %edx,%r13d
	xorl %r12d,%r12d
	movslq %esi,%rbx
	jmp L508
L509:
	decl ___stdout(%rip)
	js L512
L511:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $32,(%rcx)
	jmp L513
L512:
	movl $___stdout,%esi
	movl $32,%edi
	call ___flushbuf
L513:
	decl _nsp(%rip)
L508:
	cmpl $0,_nsp(%rip)
	jg L509
L510:
	testl $1,_field(%rip)
	jz L516
L514:
	movl 16(%r14),%edi
	testl %r13d,%r13d
	jz L518
L517:
	movzbl _fieldwidth+1(,%rbx,8),%eax
	pushq %rdi
	pushq %rax
	pushq $L520
	call _printf
	addq $24,%rsp
	jmp L516
L518:
	call _numwidth
	movl %eax,%esi
	leaq _fieldwidth+1(,%rbx,8),%rdi
	call _maxise
	movl $1,%r12d
L516:
	testl $2,_field(%rip)
	jz L523
L521:
	movq 40(%r14),%rax
	movl $512,%ecx
	addq $511,%rax
	cqto 
	idivq %rcx
	movl $2,%ecx
	incq %rax
	cqto 
	idivq %rcx
	movq %rax,%rdi
	testl %r13d,%r13d
	jz L525
L524:
	movzbl _fieldwidth+2(,%rbx,8),%eax
	pushq %rdi
	pushq %rax
	pushq $L527
	call _printf
	addq $24,%rsp
	jmp L523
L525:
	call _numwidth
	movl %eax,%esi
	leaq _fieldwidth+2(,%rbx,8),%rdi
	call _maxise
	incl %r12d
L523:
	movl _field(%rip),%eax
	testl $8,%eax
	jz L530
L528:
	testl %r13d,%r13d
	jz L532
L531:
	movq %r14,%rdi
	call _permissions
	pushq %rax
	pushq $L534
	call _printf
	addq $16,%rsp
	jmp L530
L532:
	testl $4,%eax
	movl $11,%eax
	movl $5,%ecx
	cmovzl %eax,%ecx
	addl %ecx,%r12d
L530:
	testl $4,_field(%rip)
	jz L540
L538:
	movq %r14,%rdi
	call _cxsize
	movq %rax,%rdi
	movq %rax,-16(%rbp) # spill
	call _strlen
	leal 1(%rax),%ecx
	testl %r13d,%r13d
	jz L542
L541:
	movzbl _fieldwidth+6(,%rbx,8),%r15d
	subl %ecx,%r15d
	jmp L544
L545:
	decl ___stdout(%rip)
	js L548
L547:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $32,(%rcx)
	jmp L549
L548:
	movl $___stdout,%esi
	movl $32,%edi
	call ___flushbuf
L549:
	decl %r15d
L544:
	cmpl $0,%r15d
	jg L545
L546:
	pushq -16(%rbp) # spill
	pushq $L534
	call _printf
	addq $16,%rsp
	jmp L540
L542:
	leal 1(%rax),%esi
	leaq _fieldwidth+6(,%rbx,8),%rdi
	call _maxise
L540:
	testl $16,_field(%rip)
	jz L552
L550:
	movl 32(%r14),%edi
	testl %r13d,%r13d
	jz L554
L553:
	movzbl _fieldwidth+3(,%rbx,8),%eax
	pushq %rdi
	pushq %rax
	pushq $L556
	call _printf
	addq $24,%rsp
	jmp L555
L554:
	call _numwidth
	movl %eax,%esi
	leaq _fieldwidth+3(,%rbx,8),%rdi
	call _maxise
	incl %r12d
L555:
	testl $32,_field(%rip)
	jnz L559
L557:
	movl 24(%r14),%edi
	testl %r13d,%r13d
	jz L561
L560:
	movzbl _fieldwidth+4(,%rbx,8),%eax
	movl %eax,-4(%rbp) # spill
	xorl %esi,%esi
	call _idname
	pushq %rax
	movl -4(%rbp),%eax # spill
	pushq %rax
	pushq $L563
	call _printf
	addq $24,%rsp
	jmp L559
L561:
	xorl %esi,%esi
	call _idname
	movq %rax,%rdi
	call _strlen
	movl %eax,%esi
	leaq _fieldwidth+4(,%rbx,8),%rdi
	call _maxise
	addl $2,%r12d
L559:
	movl 28(%r14),%edi
	testl %r13d,%r13d
	jz L565
L564:
	movzbl _fieldwidth+5(,%rbx,8),%eax
	movl %eax,-8(%rbp) # spill
	movl $1,%esi
	call _idname
	pushq %rax
	movl -8(%rbp),%eax # spill
	pushq %rax
	pushq $L563
	call _printf
	addq $24,%rsp
	jmp L566
L565:
	movl $1,%esi
	call _idname
	movq %rax,%rdi
	call _strlen
	movl %eax,%esi
	leaq _fieldwidth+5(,%rbx,8),%rdi
	call _maxise
	addl $2,%r12d
L566:
	movl 20(%r14),%eax
	andl $61440,%eax
	cmpl $24576,%eax
	jz L571
L612:
	cmpl $8192,%eax
	jz L571
L613:
	testl $16384,_field(%rip)
	jz L578
L577:
	movq %r14,%rdi
	call _cxsize
	movq %rax,%rdi
	movq %rax,-24(%rbp) # spill
	call _strlen
	leal 1(%rax),%ecx
	testl %r13d,%r13d
	jz L581
L580:
	movzbl _fieldwidth+6(,%rbx,8),%r15d
	subl %ecx,%r15d
	jmp L583
L584:
	decl ___stdout(%rip)
	js L587
L586:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $32,(%rcx)
	jmp L588
L587:
	movl $___stdout,%esi
	movl $32,%edi
	call ___flushbuf
L588:
	decl %r15d
L583:
	cmpl $0,%r15d
	jg L584
L585:
	pushq -24(%rbp) # spill
	pushq $L534
	call _printf
	addq $16,%rsp
	jmp L568
L581:
	leal 1(%rax),%esi
	leaq _fieldwidth+6(,%rbx,8),%rdi
	call _maxise
	jmp L568
L578:
	movq 40(%r14),%rdi
	testl %r13d,%r13d
	jz L590
L589:
	movzbl _fieldwidth+6(,%rbx,8),%eax
	pushq %rdi
	pushq %rax
	pushq $L527
	call _printf
	addq $24,%rsp
	jmp L568
L590:
	call _numwidth
	movl %eax,%esi
	jmp L615
L571:
	movl 36(%r14),%ecx
	movl %ecx,%eax
	shrl $8,%eax
	testl %r13d,%r13d
	jz L573
L572:
	movzbl _fieldwidth+6(,%rbx,8),%esi
	subl $5,%esi
	movzbl %al,%edx
	movzbl %cl,%eax
	pushq %rax
	pushq %rdx
	pushq %rsi
	pushq $L575
	call _printf
	addq $32,%rsp
	jmp L568
L573:
	movzbq %al,%rdi
	call _numwidth
	leal 5(%rax),%esi
L615:
	leaq _fieldwidth+6(,%rbx,8),%rdi
	call _maxise
	incl %r12d
L568:
	testl %r13d,%r13d
	jz L593
L592:
	movq %r14,%rdi
	call _timestamp
	pushq %rax
	pushq $L534
	call _printf
	addq $16,%rsp
	jmp L552
L593:
	testl $4096,_field(%rip)
	movl $13,%eax
	movl $21,%ecx
	cmovzl %eax,%ecx
	addl %ecx,%r12d
L552:
	movq 8(%r14),%rdi
	call _strlen
	movl %eax,%r15d
	testl %r13d,%r13d
	jz L599
L598:
	movq 8(%r14),%rdi
	call _printname
	movl $1,%esi
	movq %r14,%rdi
	call _mark
	testl %eax,%eax
	jz L603
L601:
	incl %r15d
L603:
	movzbl _fieldwidth+7(,%rbx,8),%eax
	subl %r15d,%eax
	movl %eax,_nsp(%rip)
	jmp L507
L599:
	xorl %esi,%esi
	movq %r14,%rdi
	call _mark
	testl %eax,%eax
	jz L606
L604:
	incl %r15d
L606:
	leal 3(%r15),%esi
	leaq _fieldwidth+7(,%rbx,8),%rdi
	call _maxise
	movl $1,%ecx
L608:
	movzbl _fieldwidth(%rcx,%rbx,8),%eax
	addl %eax,%r12d
	incl %ecx
	cmpl $8,%ecx
	jl L608
L610:
	movl %r12d,%esi
	leaq _fieldwidth(,%rbx,8),%rdi
	call _maxise
L507:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_countfiles:
L616:
L617:
	xorl %eax,%eax
	jmp L619
L620:
	incl %eax
	movq (%rdi),%rdi
L619:
	testq %rdi,%rdi
	jnz L620
L618:
	ret 


_columnise:
L623:
L624:
	movl _nfiles(%rip),%eax
	leal -1(%rax,%rsi),%eax
	cltd 
	idivl %esi
	movl %eax,_nlines(%rip)
	movq %rdi,_filecol(%rip)
	movl $1,%eax
	jmp L626
L627:
	xorl %ecx,%ecx
L630:
	cmpl %ecx,_nlines(%rip)
	jle L633
L634:
	testq %rdi,%rdi
	jz L633
L631:
	movq (%rdi),%rdi
	incl %ecx
	jmp L630
L633:
	movl %eax,%eax
	movq %rdi,_filecol(,%rax,8)
	incl %eax
L626:
	cmpl %eax,%esi
	jg L627
L625:
	ret 


_print:
L638:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L639:
	movl %esi,%r14d
	movl %edx,%r13d
	movl %r14d,%esi
	call _columnise
	testl %r13d,%r13d
	jnz L652
L641:
	xorl %ecx,%ecx
L644:
	cmpl %ecx,%r14d
	jg L645
L652:
	decl _nlines(%rip)
	js L654
L653:
	xorl %r12d,%r12d
	xorl %ebx,%ebx
L655:
	cmpl %ebx,%r14d
	jle L658
L656:
	movq _filecol(,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L661
L659:
	movq (%rdi),%rax
	movq %rax,_filecol(,%rbx,8)
	movl %r13d,%edx
	movl %ebx,%esi
	call _print1
L661:
	testl %r13d,%r13d
	jnz L664
L665:
	cmpl $1,%r14d
	jle L664
L666:
	movb _fieldwidth(,%rbx,8),%cl
	cmpb $255,%cl
	jz L684
L671:
	movzbl %cl,%ecx
	movl _ncols(%rip),%eax
	addl %ecx,%r12d
	addl $3,%eax
	cmpl %eax,%r12d
	jg L684
L664:
	incl %ebx
	jmp L655
L684:
	xorl %eax,%eax
	jmp L640
L658:
	testl %r13d,%r13d
	jz L652
L677:
	movl $0,_nsp(%rip)
	decl ___stdout(%rip)
	js L681
L680:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $10,(%rcx)
	jmp L652
L681:
	movl $___stdout,%esi
	movl $10,%edi
	call ___flushbuf
	jmp L652
L654:
	movl $1,%eax
L640:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 
L645:
	xorl %eax,%eax
L649:
	movl %ecx,%ecx
	movb $0,_fieldwidth(%rax,%rcx,8)
	incl %eax
	cmpl $8,%eax
	jl L649
L651:
	incl %ecx
	jmp L644

.data
.align 4
L688:
	.int 1
.local L699
.comm L699, 144, 8
.text

_listfiles:
L685:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L686:
	leaq -8(%rbp),%r12
	movq %rdi,-8(%rbp)
	movl %esi,%r14d
	movl %edx,%r13d
	leaq -16(%rbp),%rbx
	movq $0,-16(%rbp)
	movl $___stdout,%edi
	call _fflush
	cmpl $0,_field(%rip)
	jnz L696
L692:
	testl %r13d,%r13d
	jnz L696
	jz L691
L697:
	movq 8(%rax),%rsi
	leaq -20(%rbp),%rdi
	call _addpath
	movl $L699,%esi
	movq _path(%rip),%rdi
	call _stat
	cmpl $0,%eax
	jge L701
L700:
	cmpl $2,%r14d
	jnz L707
L706:
	cmpl $2,_errno(%rip)
	jz L705
L707:
	movq (%r12),%rax
	movq 8(%rax),%rdi
	call _report
L705:
	movq %r12,%rdi
	call _popfile
	movq %rax,%rdi
	call _delfile
	jmp L702
L701:
	movl $L699,%esi
	movq (%r12),%rdi
	call _setstat
	movq (%r12),%r12
L702:
	movl -20(%rbp),%eax
	movl %eax,_pidx(%rip)
	movslq %eax,%rax
	movq _path(%rip),%rcx
	movb $0,(%rax,%rcx)
L696:
	movq (%r12),%rax
	testq %rax,%rax
	jnz L697
L691:
	leaq -8(%rbp),%r12
	leaq -8(%rbp),%rdi
	call _sort
	cmpl $2,%r14d
	jnz L712
L713:
	testl $18,_field(%rip)
	jz L712
L714:
	movq -8(%rbp),%rdi
	call _countblocks
	movl $2,%ecx
	incq %rax
	cqto 
	idivq %rcx
	pushq %rax
	pushq $L717
	call _printf
	addq $16,%rsp
L712:
	cmpl $1,%r13d
	jz L725
L721:
	cmpl $1,%r14d
	jnz L720
L725:
	movq (%r12),%rcx
	testq %rcx,%rcx
	jz L720
L726:
	movl 20(%rcx),%eax
	andl $61440,%eax
	cmpl $16384,%eax
	jnz L729
L728:
	movq %r12,%rdi
	call _popfile
	movq %rax,%rsi
	movq %rbx,%rdi
	call _pushfile
	movq (%rbx),%rbx
	jmp L725
L729:
	movq %rcx,%r12
	jmp L725
L720:
	movq -8(%rbp),%rdi
	call _countfiles
	movl %eax,_nfiles(%rip)
	cmpl $0,%eax
	jle L743
L731:
	movl $67,%edi
	call _present
	testl %eax,%eax
	jnz L735
L734:
	movl $1,%r12d
	jmp L740
L735:
	movl _nfiles(%rip),%eax
	cmpl $128,%eax
	movl $128,%r12d
	cmovll %eax,%r12d
	jmp L740
L741:
	decl %r12d
L740:
	xorl %edx,%edx
	movl %r12d,%esi
	movq -8(%rbp),%rdi
	call _print
	testl %eax,%eax
	jz L741
L742:
	movl $1,%edx
	movl %r12d,%esi
	movq -8(%rbp),%rdi
	call _print
	movl $0,L688(%rip)
L743:
	movq -8(%rbp),%rax
	testq %rax,%rax
	jnz L744
	jz L753
L754:
	movq 8(%rax),%rdi
	call _dotflag
	cmpl $97,%eax
	jnz L760
L759:
	cmpl $2,%r14d
	jz L758
L760:
	movq -16(%rbp),%rax
	movq 8(%rax),%rsi
	leaq -24(%rbp),%rdi
	call _addpath
	movq $0,-8(%rbp)
	movq _path(%rip),%rsi
	leaq -8(%rbp),%rdi
	call _adddir
	testl %eax,%eax
	jz L765
L763:
	cmpl $1,%r14d
	jz L768
L766:
	cmpl $0,L688(%rip)
	jnz L771
L769:
	decl ___stdout(%rip)
	js L773
L772:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $10,(%rcx)
	jmp L771
L773:
	movl $___stdout,%esi
	movl $10,%edi
	call ___flushbuf
L771:
	pushq _path(%rip)
	pushq $L775
	call _printf
	addq $16,%rsp
	movl $0,L688(%rip)
L768:
	cmpl $2,%r13d
	movl $0,%eax
	movl $2,%edx
	cmovnzl %eax,%edx
	movl $2,%esi
	movq -8(%rbp),%rdi
	call _listfiles
L765:
	movl -24(%rbp),%eax
	movl %eax,_pidx(%rip)
	movslq %eax,%rax
	movq _path(%rip),%rcx
	movb $0,(%rax,%rcx)
L758:
	leaq -16(%rbp),%rdi
	call _popfile
	movq %rax,%rdi
	call _delfile
L753:
	movq -16(%rbp),%rax
	testq %rax,%rax
	jnz L754
L687:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 
L744:
	cmpl $2,%r13d
	jnz L751
L749:
	movl 20(%rax),%eax
	andl $61440,%eax
	cmpl $16384,%eax
	jnz L751
L750:
	leaq -8(%rbp),%rdi
	call _popfile
	movq %rax,%rsi
	movq %rbx,%rdi
	call _pushfile
	movq (%rbx),%rbx
	jmp L743
L751:
	leaq -8(%rbp),%rdi
	call _popfile
	movq %rax,%rdi
	call _delfile
	jmp L743


_main:
L779:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L780:
	movq %rsi,%r13
	leaq -8(%rbp),%r12
	movq $0,-8(%rbp)
	call _geteuid
	movl %eax,_uid(%rip)
	call _getegid
	movl %eax,_gid(%rip)
	movl $47,%esi
	movq (%r13),%rdi
	call _strrchr
	movq %rax,_arg0(%rip)
	testq %rax,%rax
	jnz L783
L782:
	movq (%r13),%rax
	jmp L945
L783:
	incq %rax
L945:
	movq %rax,_arg0(%rip)
	addq $8,%r13
	jmp L785
L788:
	cmpb $45,(%rdi)
	jnz L787
L789:
	cmpb $45,1(%rdi)
	jnz L797
L795:
	cmpb $0,2(%rdi)
	jnz L797
L796:
	addq $8,%r13
	jmp L787
L797:
	addq $8,%r13
	incq %rdi
	call _setflags
L785:
	movq (%r13),%rdi
	testq %rdi,%rdi
	jnz L788
L787:
	movl $1,%edi
	call _isatty
	movl %eax,_istty(%rip)
	testl %eax,%eax
	jz L802
L804:
	movl $L803,%edi
	call _getenv
	movq %rax,%rdi
	testq %rax,%rax
	jz L802
L805:
	cmpb $45,(%rax)
	jnz L810
L808:
	leaq 1(%rax),%rdi
L810:
	call _setflags
L802:
	movl $49,%edi
	call _present
	testl %eax,%eax
	jnz L813
L822:
	movl $67,%edi
	call _present
	testl %eax,%eax
	jnz L813
L823:
	movl $108,%edi
	call _present
	testl %eax,%eax
	jnz L813
L819:
	cmpl $0,_istty(%rip)
	jnz L827
L834:
	movl $77,%edi
	call _present
	testl %eax,%eax
	jnz L827
L836:
	movl $88,%edi
	call _present
	testl %eax,%eax
	jnz L827
L832:
	movl $70,%edi
	call _present
	testl %eax,%eax
	jz L813
L827:
	movl $L838,%edi
	call _setflags
L813:
	cmpl $0,_istty(%rip)
	jz L841
L839:
	movl $L842,%edi
	call _setflags
L841:
	cmpl $0,_uid(%rip)
	jz L847
L846:
	movl $97,%edi
	call _present
	testl %eax,%eax
	jz L845
L847:
	movl $L850,%edi
	call _setflags
L845:
	movl $105,%edi
	call _present
	testl %eax,%eax
	jz L853
L851:
	orl $1,_field(%rip)
L853:
	movl $115,%edi
	call _present
	testl %eax,%eax
	jz L856
L854:
	orl $2,_field(%rip)
L856:
	movl $77,%edi
	call _present
	testl %eax,%eax
	jz L859
L857:
	orl $8,_field(%rip)
L859:
	movl $88,%edi
	call _present
	testl %eax,%eax
	jz L862
L860:
	orl $12,_field(%rip)
L862:
	movl $116,%edi
	call _present
	testl %eax,%eax
	jz L865
L863:
	orl $64,_field(%rip)
L865:
	movl $117,%edi
	call _present
	testl %eax,%eax
	jz L868
L866:
	orl $128,_field(%rip)
L868:
	movl $99,%edi
	call _present
	testl %eax,%eax
	jz L871
L869:
	orl $256,_field(%rip)
L871:
	movl $108,%edi
	call _present
	testl %eax,%eax
	jz L874
L872:
	orl $24,_field(%rip)
L874:
	movl $103,%edi
	call _present
	testl %eax,%eax
	jz L877
L875:
	orl $56,_field(%rip)
L877:
	movl $70,%edi
	call _present
	testl %eax,%eax
	jz L880
L878:
	orl $512,_field(%rip)
L880:
	movl $112,%edi
	call _present
	testl %eax,%eax
	jz L883
L881:
	orl $1024,_field(%rip)
L883:
	movl $84,%edi
	call _present
	testl %eax,%eax
	jz L886
L884:
	orl $4120,_field(%rip)
L886:
	movl $100,%edi
	call _present
	testl %eax,%eax
	jz L889
L887:
	orl $8192,_field(%rip)
L889:
	movl $104,%edi
	call _present
	testl %eax,%eax
	jz L892
L890:
	orl $16384,_field(%rip)
L892:
	movl _field(%rip),%eax
	testl $16,%eax
	jz L895
L893:
	andl $-5,%eax
	movl %eax,_field(%rip)
L895:
	movl $67,%edi
	call _present
	testl %eax,%eax
	jz L898
L896:
	cmpl $0,_istty(%rip)
	jz L901
L900:
	movl $1,%ebx
	jmp L910
L901:
	pushq $1
	pushq $L899
	call _open
	addq $16,%rsp
	movl %eax,%ebx
	cmpl $0,%eax
	jl L905
L910:
	leaq -16(%rbp),%rdx
	movl $21523,%esi
	movl %ebx,%edi
	call _ioctl
	testl %eax,%eax
	jnz L905
L911:
	movw -14(%rbp),%ax
	cmpw $0,%ax
	jbe L905
L907:
	movzwl %ax,%eax
	decl %eax
	movl %eax,_ncols(%rip)
L905:
	cmpl $1,%ebx
	jz L898
L917:
	cmpl $-1,%ebx
	jz L898
L918:
	movl %ebx,%edi
	call _close
L898:
	xorl %ebx,%ebx
	cmpq $0,(%r13)
	jnz L922
L921:
	testl $8192,_field(%rip)
	movl $1,%eax
	cmovzl %eax,%ebx
	movl $L927,%edi
	call _newfile
	movq %rax,%rsi
	leaq -8(%rbp),%rdi
	call _pushfile
	jmp L923
L922:
	cmpq $0,8(%r13)
	jnz L935
L931:
	testl $8192,_field(%rip)
	movl $1,%eax
	cmovzl %eax,%ebx
L935:
	movq (%r13),%rdi
	addq $8,%r13
	call _newfile
	movq %rax,%rsi
	movq %r12,%rdi
	call _pushfile
	movq (%r12),%r12
	cmpq $0,(%r13)
	jnz L935
L923:
	testl $8192,_field(%rip)
	jz L939
L938:
	xorl %edx,%edx
	jmp L940
L939:
	movl $82,%edi
	call _present
	testl %eax,%eax
	movl $1,%eax
	movl $2,%edx
	cmovzl %eax,%edx
L940:
	movl %ebx,%esi
	movq -8(%rbp),%rdi
	call _listfiles
	movl _ex(%rip),%eax
L781:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L717:
	.byte 116,111,116,97,108,32,37,108
	.byte 100,10,0
L838:
	.byte 67,0
L556:
	.byte 37,42,117,32,0
L141:
	.byte 37,46,51,115,32,37,50,100
	.byte 32,37,48,50,100,58,37,48
	.byte 50,100,58,37,48,50,100,32
	.byte 37,100,0
L149:
	.byte 37,46,51,115,32,37,50,100
	.byte 32,32,37,100,0
L4:
	.byte 37,115,58,32,79,117,116,32
	.byte 111,102,32,109,101,109,111,114
	.byte 121,10,0
L842:
	.byte 113,0
L28:
	.byte 85,115,97,103,101,58,32,37
	.byte 115,32,91,45,37,115,93,32
	.byte 91,102,105,108,101,32,46,46
	.byte 46,93,10,0
L803:
	.byte 76,83,79,80,84,83,0
L79:
	.byte 37,117,0
L899:
	.byte 47,100,101,118,47,116,116,121
	.byte 0
L527:
	.byte 37,42,108,117,32,0
L150:
	.byte 37,46,51,115,32,37,50,100
	.byte 32,37,48,50,100,58,37,48
	.byte 50,100,0
L927:
	.byte 46,0
L563:
	.byte 37,45,42,115,32,32,0
L534:
	.byte 37,115,32,0
L775:
	.byte 37,115,58,10,0
L520:
	.byte 37,42,100,32,0
L575:
	.byte 37,42,100,44,32,37,51,100
	.byte 32,0
L43:
	.byte 37,115,58,32,37,115,58,32
	.byte 37,115,10,0
L850:
	.byte 65,0
.globl _arg0
.comm _arg0, 8, 8
.globl _uid
.comm _uid, 4, 4
.globl _gid
.comm _gid, 4, 4
.globl _ex
.comm _ex, 4, 4
.globl _istty
.comm _istty, 4, 4
.globl _flags
.comm _flags, 25, 1
.globl _uids
.comm _uids, 256, 8
.globl _gids
.comm _gids, 256, 8
.globl _path
.comm _path, 8, 8
.local _CMP
.comm _CMP, 8, 8
.local _rCMP
.comm _rCMP, 8, 8
.globl _fieldwidth
.comm _fieldwidth, 1024, 1
.globl _filecol
.comm _filecol, 1024, 8
.globl _nfiles
.comm _nfiles, 4, 4
.globl _nlines
.comm _nlines, 4, 4

.globl _errno
.globl _close
.globl _free
.globl _dotflag
.globl _geteuid
.globl _sprintf
.globl _filecol
.globl _idname
.globl _l_ifmt
.globl _closedir
.globl _mark
.globl _popfile
.globl _localtime
.globl _getegid
.globl _getenv
.globl _adddir
.globl _realloc
.globl _uids
.globl _numwidth
.globl _allowed
.globl ___stdout
.globl _malloc
.globl _heaperr
.globl _setstat
.globl _listfiles
.globl _opendir
.globl _stat
.globl _path
.globl _mtimecmp
.globl _numeral
.globl _flags
.globl _countfiles
.globl _ncols
.globl _printf
.globl _istty
.globl _delfile
.globl _field
.globl _fflush
.globl _nfiles
.globl _allocate
.globl _atimecmp
.globl _access
.globl _strrchr
.globl _print1
.globl _strcmp
.globl ___flushbuf
.globl _columnise
.globl _nlines
.globl _ioctl
.globl _print
.globl _isatty
.globl _fieldwidth
.globl _open
.globl _maxise
.globl _countblocks
.globl _getgrgid
.globl _strerror
.globl ___stderr
.globl _newfile
.globl _gid
.globl _arg0
.globl _plen
.globl _setflags
.globl _ctimecmp
.globl _present
.globl _uid
.globl _addpath
.globl _revcmp
.globl _namecmp
.globl _getpwuid
.globl _pushfile
.globl _gids
.globl _printname
.globl _numxwidth
.globl _reallocate
.globl _pidx
.globl _time
.globl _strlen
.globl _strchr
.globl _main
.globl _exit
.globl _readdir
.globl _strcpy
.globl _cxsize
.globl _ex
.globl _fprintf
.globl _permissions
.globl _report
