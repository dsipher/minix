.data
.align 8
_outp:
	.quad _outbuf
.align 8
_nltoken:
	.byte 6
	.byte 0
	.short 0
	.int 0
	.int 1
	.fill 4, 1, 0
	.quad L1
_rcsid:
 .byte 36,82,101,118,105,115,105,111
 .byte 110,36,32,36,68,97,116,101
 .byte 36,0
.text

_main:
L2:
	pushq %rbp
	movq %rsp,%rbp
	subq $1064,%rsp
	pushq %rbx
	pushq %r12
L3:
	movl %edi,%r12d
	movq %rsi,%rbx
	leaq -1024(%rbp),%rsi
	movl $___stderr,%edi
	call _setbuf
	xorl %edi,%edi
	call _time
	movq %rax,-1032(%rbp)
	leaq -1032(%rbp),%rdi
	call _ctime
	movq %rax,_curtime(%rip)
	leaq -1064(%rbp),%rsi
	movl $3,%edi
	call _maketokenrow
	call _expandlex
	movq %rbx,%rsi
	movl %r12d,%edi
	call _setup
	call _fixlex
	call _iniths
	call _genline
	leaq -1064(%rbp),%rdi
	call _process
	call _flushout
	movl $___stderr,%edi
	call _fflush
	cmpl $0,_nerrs(%rip)
	setg %dil
	movzbl %dil,%edi
	call _exit
	xorl %eax,%eax
L4:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_process:
L6:
	pushq %rbx
	pushq %r12
L7:
	movq %rdi,%r12
	xorl %ebx,%ebx
L9:
	movq (%r12),%rax
	cmpq 16(%r12),%rax
	jb L15
L13:
	movq 8(%r12),%rax
	movq %rax,16(%r12)
	movq %rax,(%r12)
	movq $_outbuf,_outp(%rip)
	movl $1,%esi
	movq %r12,%rdi
	call _gettokens
	orl %eax,%ebx
	movq 8(%r12),%rax
	movq %rax,(%r12)
L15:
	movq (%r12),%rcx
	movzbl (%rcx),%eax
	testb %al,%al
	jz L16
L18:
	cmpb $41,%al
	jnz L33
L32:
	addq $24,%rcx
	movq %rcx,(%r12)
	movq %r12,%rdi
	call _control
	jmp L34
L33:
	cmpl $0,_skipping(%rip)
	jnz L34
L38:
	testl %ebx,%ebx
	jz L34
L39:
	xorl %esi,%esi
	movq %r12,%rdi
	call _expandrow
L34:
	cmpl $0,_skipping(%rip)
	jz L44
L42:
	movq %r12,%rdi
	call _setempty
L44:
	movq %r12,%rdi
	call _puttokens
	movq _cursource(%rip),%rdx
	xorl %ebx,%ebx
	movl 12(%rdx),%ecx
	addl 8(%rdx),%ecx
	movl %ecx,8(%rdx)
	movq _cursource(%rip),%rax
	cmpl $1,12(%rax)
	jle L9
	jg L48
L16:
	decl _incdepth(%rip)
	js L21
L19:
	movq _cursource(%rip),%rax
	cmpl $0,48(%rax)
	jz L24
L22:
	pushq $L25
	pushq $1
	call _error
	addq $16,%rsp
L24:
	call _unsetsource
	movq _cursource(%rip),%rdx
	movl 12(%rdx),%ecx
	addl 8(%rdx),%ecx
	movl %ecx,8(%rdx)
	movq 16(%r12),%rax
	movq %rax,(%r12)
L48:
	call _genline
	jmp L9
L21:
	cmpl $0,_ifdepth(%rip)
	jz L8
L27:
	pushq $L30
	pushq $1
	call _error
	addq $16,%rsp
L8:
	popq %r12
	popq %rbx
	ret 

.align 2
L254:
	.short L132-_control
	.short L132-_control
	.short L132-_control
	.short L140-_control
	.short L157-_control
	.short L179-_control
	.short L239-_control
	.short L112-_control
	.short L114-_control
	.short L197-_control
	.short L194-_control
	.short L51-_control
	.short L236-_control
	.short L109-_control
	.short L109-_control
	.short L109-_control
	.short L109-_control
	.short L109-_control
	.short L241-_control
.align 2
L255:
	.short L95-_control
	.short L95-_control
	.short L95-_control
	.short L102-_control
	.short L102-_control
	.short L88-_control

_control:
L49:
	pushq %rbx
	pushq %r12
	pushq %r13
L50:
	movq %rdi,%r13
	movq (%r13),%rbx
	movzbl (%rbx),%eax
	cmpb $2,%al
	jnz L52
L54:
	xorl %esi,%esi
	movq %rbx,%rdi
	call _lookup
	movq %rax,%r12
	testq %r12,%r12
	jz L69
L68:
	movzbl 41(%r12),%eax
	andb $2,%al
	jnz L74
L72:
	cmpl $0,_skipping(%rip)
	jnz L74
L69:
	pushq %rbx
	pushq $L76
	pushq $0
	call _error
	addq $24,%rsp
	jmp L51
L74:
	movl _skipping(%rip),%ecx
	testl %ecx,%ecx
	jz L80
L78:
	testb %al,%al
	jz L51
L83:
	movzbl 40(%r12),%eax
	cmpb $0,%al
	jl L51
L253:
	cmpb $5,%al
	jg L51
L251:
	movzbl %al,%eax
	movzwl L255(,%rax,2),%eax
	addl $_control,%eax
	jmp *%rax
L88:
	movl _ifdepth(%rip),%eax
	decl %eax
	movl %eax,_ifdepth(%rip)
	cmpl %eax,%ecx
	jle L91
L89:
	movl $0,_skipping(%rip)
L91:
	movq _cursource(%rip),%rcx
	decl 48(%rcx)
	jmp L246
L102:
	cmpl _ifdepth(%rip),%ecx
	jl L51
L80:
	movzbl 40(%r12),%esi
	cmpb $0,%sil
	jl L109
L250:
	cmpb $18,%sil
	jg L109
L248:
	movzbl %sil,%eax
	movzwl L254(,%rax,2),%eax
	addl $_control,%eax
	jmp *%rax
L241:
	movsbl %sil,%esi
	movq %r13,%rdi
	call _eval
	jmp L246
L236:
	pushq $L237
	pushq $1
	call _error
	addq $16,%rsp
	jmp L246
L194:
	addq $24,%rbx
	movq %rbx,(%r13)
	pushq %r13
	pushq $L195
	pushq $0
	call _error
	addq $24,%rsp
	jmp L246
L197:
	addq $24,%rbx
	movq %rbx,(%r13)
	movl $L198,%esi
	movq %r13,%rdi
	call _expandrow
	movq 8(%r13),%rbx
	addq $48,%rbx
	jmp L58
L114:
	cmpb $2,24(%rbx)
	jnz L119
L118:
	movq 16(%r13),%rax
	subq 8(%r13),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cmpq $4,%rax
	jz L120
L119:
	pushq $L122
	pushq $1
	call _error
	addq $16,%rsp
	jmp L246
L120:
	xorl %esi,%esi
	leaq 24(%rbx),%rdi
	call _lookup
	testq %rax,%rax
	jz L246
L124:
	andb $-2,41(%rax)
	jmp L246
L112:
	movq %r13,%rdi
	call _dodefine
	jmp L246
L239:
	movq %r13,%rdi
	call _doinclude
	movq 8(%r13),%rax
	movq %rax,16(%r13)
	jmp L51
L179:
	movl _ifdepth(%rip),%eax
	testl %eax,%eax
	jz L184
L183:
	movq _cursource(%rip),%rcx
	cmpl $0,48(%rcx)
	jnz L185
L184:
	pushq $L187
	pushq $1
	call _error
	addq $16,%rsp
	jmp L51
L185:
	decl %eax
	movl %eax,_ifdepth(%rip)
	decl 48(%rcx)
	movq 16(%r13),%rax
	subq 8(%r13),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cmpq $3,%rax
	jz L246
L189:
	pushq $L192
	pushq $0
	call _error
	addq $16,%rsp
	jmp L246
L157:
	movl _ifdepth(%rip),%eax
	testl %eax,%eax
	jz L162
L161:
	movq _cursource(%rip),%rcx
	cmpl $0,48(%rcx)
	jnz L163
L162:
	pushq $L165
	pushq $1
	call _error
	addq $16,%rsp
	jmp L51
L163:
	movslq %eax,%rax
	cmpl $2,_ifsatisfied(,%rax,4)
	jnz L169
L167:
	pushq $L170
	pushq $1
	call _error
	addq $16,%rsp
L169:
	movq 16(%r13),%rax
	subq 8(%r13),%rax
	movl $24,%ecx
	cqto 
	idivq %rcx
	cmpq $3,%rax
	jz L173
L171:
	pushq $L174
	pushq $1
	call _error
	addq $16,%rsp
L173:
	movl _ifdepth(%rip),%edx
	movslq %edx,%rcx
	cmpl $0,_ifsatisfied(,%rcx,4)
	movl $0,%eax
	cmovnzl %edx,%eax
	movl %eax,_skipping(%rip)
	movl $2,_ifsatisfied(,%rcx,4)
	jmp L246
L140:
	movl _ifdepth(%rip),%eax
	testl %eax,%eax
	jz L141
L143:
	movslq %eax,%rax
	cmpl $2,_ifsatisfied(,%rax,4)
	jnz L148
L146:
	pushq $L149
	pushq $1
	call _error
	addq $16,%rsp
L148:
	movsbl 40(%r12),%esi
	movq %r13,%rdi
	call _eval
	movl _ifdepth(%rip),%ecx
	testq %rax,%rax
	jz L247
L150:
	movslq %ecx,%rax
	cmpl $0,_ifsatisfied(,%rax,4)
	jz L154
L247:
	movl %ecx,_skipping(%rip)
	jmp L246
L154:
	movl $0,_skipping(%rip)
	movl $1,_ifsatisfied(,%rax,4)
	jmp L246
L141:
	pushq $L144
	pushq $1
	call _error
	addq $16,%rsp
	jmp L51
L132:
	movl _ifdepth(%rip),%eax
	incl %eax
	movl %eax,_ifdepth(%rip)
	cmpl $32,%eax
	jl L135
L133:
	pushq $L99
	pushq $2
	call _error
	addq $16,%rsp
L135:
	movq _cursource(%rip),%rcx
	incl 48(%rcx)
	movslq _ifdepth(%rip),%rax
	movl $0,_ifsatisfied(,%rax,4)
	movsbl 40(%r12),%esi
	movq %r13,%rdi
	call _eval
	movl _ifdepth(%rip),%ecx
	testq %rax,%rax
	jz L137
L136:
	movslq %ecx,%rcx
	movl $1,_ifsatisfied(,%rcx,4)
	jmp L246
L137:
	movl %ecx,_skipping(%rip)
	jmp L246
L109:
	pushq %rbx
	pushq $L243
	pushq $1
	call _error
	addq $24,%rsp
L246:
	movq %r13,%rdi
	call _setempty
	jmp L51
L95:
	movl _ifdepth(%rip),%eax
	incl %eax
	movl %eax,_ifdepth(%rip)
	cmpl $32,%eax
	jl L98
L96:
	pushq $L99
	pushq $2
	call _error
	addq $16,%rsp
L98:
	movq _cursource(%rip),%rcx
	incl 48(%rcx)
	jmp L51
L52:
	cmpb $3,%al
	jnz L57
L58:
	leaq 24(%rbx),%rax
	movq 16(%r13),%rcx
	cmpq %rcx,%rax
	jae L203
L210:
	cmpb $3,(%rbx)
	jnz L203
L212:
	leaq 72(%rbx),%rax
	cmpq %rax,%rcx
	ja L203
	jb L220
L218:
	cmpb $4,24(%rbx)
	jnz L203
L220:
	movq 40(%rbx),%rax
	cmpb $76,(%rax)
	jz L203
L216:
	movq 16(%rbx),%rdi
	call _atol
	movq _cursource(%rip),%rcx
	decl %eax
	movl %eax,8(%rcx)
	movq _cursource(%rip),%rax
	movl 8(%rax),%eax
	cmpl $0,%eax
	jl L228
L227:
	cmpl $32768,%eax
	jl L226
L228:
	pushq $L231
	pushq $0
	call _error
	addq $16,%rsp
L226:
	leaq 48(%rbx),%rax
	cmpq 16(%r13),%rax
	jae L51
L232:
	movq 40(%rbx),%rdi
	movl 32(%rbx),%esi
	xorl %edx,%edx
	addl $4294967294,%esi
	incq %rdi
	call _newstring
	movq _cursource(%rip),%rcx
	movq %rax,(%rcx)
	jmp L51
L203:
	pushq $L222
	pushq $1
	call _error
	addq $16,%rsp
	jmp L51
L57:
	cmpb $6,%al
	jz L51
L60:
	pushq $L63
	pushq $1
	call _error
	addq $16,%rsp
L51:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_domalloc:
L256:
	pushq %rbx
L257:
	movslq %edi,%rdi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L261
L259:
	pushq $L262
	pushq $2
	call _error
	addq $16,%rsp
L261:
	movq %rbx,%rax
L258:
	popq %rbx
	ret 


_dofree:
L264:
L265:
	call _free
L266:
	ret 


_error:
L267:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L268:
	movl 16(%rbp),%r12d
	movq 24(%rbp),%rax
	movq %rax,24(%rbp)
	pushq $L270
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq _cursource(%rip),%rbx
L271:
	testq %rbx,%rbx
	jz L274
L272:
	movq (%rbx),%rcx
	cmpb $0,(%rcx)
	jz L277
L275:
	movl 8(%rbx),%eax
	pushq %rax
	pushq %rcx
	pushq $L278
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L277:
	movq 56(%rbx),%rbx
	jmp L271
L274:
	leaq 32(%rbp),%rbx
	movq 24(%rbp),%r15
L279:
	movzbl (%r15),%edi
	testb %dil,%dil
	jz L282
L280:
	cmpb $37,%dil
	jnz L284
L283:
	leaq 1(%r15),%rax
	movzbl 1(%r15),%edi
	movq %rax,%r15
	cmpb $115,%dil
	jz L289
L323:
	cmpb $100,%dil
	jz L292
L324:
	cmpb $116,%dil
	jz L295
L325:
	cmpb $114,%dil
	jz L298
L326:
	movsbl %dil,%edi
	movl $___stderr,%esi
	call _fputc
	jmp L285
L298:
	addq $8,%rbx
	movq -8(%rbx),%r13
	movq (%r13),%r14
L299:
	cmpq 16(%r13),%r14
	jae L285
L303:
	cmpb $6,(%r14)
	jz L285
L304:
	cmpq (%r13),%r14
	jbe L309
L310:
	cmpl $0,4(%r14)
	jz L309
L311:
	movl $___stderr,%esi
	movl $32,%edi
	call _fputc
L309:
	movl 8(%r14),%eax
	pushq 16(%r14)
	pushq %rax
	pushq $L296
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	addq $24,%r14
	jmp L299
L295:
	addq $8,%rbx
	movq -8(%rbx),%rcx
	movl 8(%rcx),%eax
	pushq 16(%rcx)
	pushq %rax
	pushq $L296
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	jmp L285
L292:
	addq $8,%rbx
	movl -8(%rbx),%eax
	pushq %rax
	pushq $L293
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L285
L289:
	addq $8,%rbx
	pushq -8(%rbx)
	pushq $L290
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L285
L284:
	movsbl %dil,%edi
	movl $___stderr,%esi
	call _fputc
L285:
	incq %r15
	jmp L279
L282:
	movl $___stderr,%esi
	movl $10,%edi
	call _fputc
	cmpl $2,%r12d
	jnz L318
L316:
	movl $1,%edi
	call _exit
L318:
	testl %r12d,%r12d
	jz L321
L319:
	movl $1,_nerrs(%rip)
L321:
	movl $___stderr,%edi
	call _fflush
L269:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret 

L293:
 .byte 37,100,0
L174:
 .byte 83,121,110,116,97,120,32,101
 .byte 114,114,111,114,32,105,110,32
 .byte 35,101,108,115,101,0
L278:
 .byte 37,115,58,37,100,32,0
L170:
 .byte 35,101,108,115,101,32,97,102
 .byte 116,101,114,32,35,101,108,115
 .byte 101,0
L231:
 .byte 35,108,105,110,101,32,115,112
 .byte 101,99,105,102,105,101,115,32
 .byte 110,117,109,98,101,114,32,111
 .byte 117,116,32,111,102,32,114,97
 .byte 110,103,101,0
L270:
 .byte 99,112,112,58,32,0
L195:
 .byte 35,101,114,114,111,114,32,100
 .byte 105,114,101,99,116,105,118,101
 .byte 58,32,37,114,0
L144:
 .byte 35,101,108,105,102,32,119,105
 .byte 116,104,32,110,111,32,35,105
 .byte 102,0
L122:
 .byte 83,121,110,116,97,120,32,101
 .byte 114,114,111,114,32,105,110,32
 .byte 35,117,110,100,101,102,0
L1:
 .byte 10,0
L296:
 .byte 37,46,42,115,0
L63:
 .byte 85,110,105,100,101,110,116,105
 .byte 102,105,97,98,108,101,32,99
 .byte 111,110,116,114,111,108,32,108
 .byte 105,110,101,0
L30:
 .byte 85,110,116,101,114,109,105,110
 .byte 97,116,101,100,32,35,105,102
 .byte 47,35,105,102,100,101,102,47
 .byte 35,105,102,110,100,101,102,0
L99:
 .byte 35,105,102,32,116,111,111,32
 .byte 100,101,101,112,108,121,32,110
 .byte 101,115,116,101,100,0
L290:
 .byte 37,115,0
L25:
 .byte 85,110,116,101,114,109,105,110
 .byte 97,116,101,100,32,99,111,110
 .byte 100,105,116,105,111,110,97,108
 .byte 32,105,110,32,35,105,110,99
 .byte 108,117,100,101,0
L165:
 .byte 35,101,108,115,101,32,119,105
 .byte 116,104,32,110,111,32,35,105
 .byte 102,0
L198:
 .byte 60,108,105,110,101,62,0
L222:
 .byte 83,121,110,116,97,120,32,101
 .byte 114,114,111,114,32,105,110,32
 .byte 35,108,105,110,101,0
L149:
 .byte 35,101,108,105,102,32,97,102
 .byte 116,101,114,32,35,101,108,115
 .byte 101,0
L192:
 .byte 83,121,110,116,97,120,32,101
 .byte 114,114,111,114,32,105,110,32
 .byte 35,101,110,100,105,102,0
L187:
 .byte 35,101,110,100,105,102,32,119
 .byte 105,116,104,32,110,111,32,35
 .byte 105,102,0
L262:
 .byte 79,117,116,32,111,102,32,109
 .byte 101,109,111,114,121,32,102,114
 .byte 111,109,32,109,97,108,108,111
 .byte 99,0
L243:
 .byte 80,114,101,112,114,111,99,101
 .byte 115,115,111,114,32,99,111,110
 .byte 116,114,111,108,32,96,37,116
 .byte 39,32,110,111,116,32,121,101
 .byte 116,32,105,109,112,108,101,109
 .byte 101,110,116,101,100,0
L76:
 .byte 85,110,107,110,111,119,110,32
 .byte 112,114,101,112,114,111,99,101
 .byte 115,115,111,114,32,99,111,110
 .byte 116,114,111,108,32,37,116,0
L237:
 .byte 66,97,100,32,115,121,110,116
 .byte 97,120,32,102,111,114,32,99
 .byte 111,110,116,114,111,108,32,108
 .byte 105,110,101,0
.comm _cursource, 8, 8
.comm _curtime, 8, 8
.comm _incdepth, 4, 4
.comm _ifdepth, 4, 4
.comm _ifsatisfied, 128, 4
.comm _skipping, 4, 4
.comm _outbuf, 16384, 1
.comm _nerrs, 4, 4

.globl _free
.globl _cursource
.globl _iniths
.globl _puttokens
.globl _control
.globl _ctime
.globl _atol
.globl _nerrs
.globl _curtime
.globl _error
.globl _malloc
.globl _rcsid
.globl _expandlex
.globl _unsetsource
.globl _domalloc
.globl _genline
.globl _fixlex
.globl _skipping
.globl _fputc
.globl _process
.globl _fflush
.globl _newstring
.globl _setbuf
.globl ___stderr
.globl _ifsatisfied
.globl _incdepth
.globl _outbuf
.globl _dofree
.globl _setup
.globl _outp
.globl _lookup
.globl _eval
.globl _setempty
.globl _doinclude
.globl _maketokenrow
.globl _gettokens
.globl _expandrow
.globl _time
.globl _main
.globl _exit
.globl _flushout
.globl _ifdepth
.globl _fprintf
.globl _nltoken
.globl _dodefine
