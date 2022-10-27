.data
.align 8
_infile:
	.quad 0
.align 8
_file:
	.quad L1
.align 4
_recsize:
	.int 8192
.align 4
_fieldssize:
	.int 8192
_inputFS:
	.byte 32,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0,0,0,0,0
	.byte 0,0,0,0
.align 4
_nfields:
	.int 2
.align 4
_lastfld:
	.int 0
.align 4
_argno:
	.int 1
.align 8
_dollar0:
	.byte 1
	.byte 1
	.fill 6, 1, 0
	.quad 0
	.quad L1
	.quad 0x0
	.int 134
	.fill 12, 1, 0
.align 8
_dollar1:
	.byte 1
	.byte 1
	.fill 6, 1, 0
	.quad 0
	.quad L1
	.quad 0x0
	.int 70
	.fill 12, 1, 0
.text

_recinit:
L2:
	pushq %rbx
L3:
	movl %edi,%ebx
	movl %ebx,%edi
	call _malloc
	movq %rax,_record(%rip)
	testq %rax,%rax
	jz L5
L16:
	incl %ebx
	movl %ebx,%edi
	call _malloc
	movq %rax,_fields(%rip)
	testq %rax,%rax
	jz L5
L12:
	movl _nfields(%rip),%edi
	incl %edi
	movslq %edi,%rdi
	shlq $3,%rdi
	call _malloc
	movq %rax,_fldtab(%rip)
	testq %rax,%rax
	jz L5
L8:
	movl $48,%edi
	call _malloc
	movq _fldtab(%rip),%rcx
	movq %rax,(%rcx)
	testq %rax,%rax
	jnz L7
L5:
	pushq $L20
	call _FATAL
	addq $8,%rsp
L7:
	movq _fldtab(%rip),%rax
	movl $48,%ecx
	movl $_dollar0,%esi
	movq (%rax),%rdi
	rep 
	movsb 
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movq _record(%rip),%rcx
	movq %rcx,16(%rax)
	movl $L21,%edi
	call _tostring
	movq _fldtab(%rip),%rcx
	movq (%rcx),%rcx
	movq %rax,8(%rcx)
	movl _nfields(%rip),%esi
	movl $1,%edi
	call _makefields
L4:
	popq %rbx
	ret 


_makefields:
L22:
	pushq %rbp
	movq %rsp,%rbp
	subq $56,%rsp
	pushq %rbx
	pushq %r12
L23:
	movl %esi,%r12d
	movl %edi,%ebx
	jmp L25
L26:
	movl $48,%edi
	call _malloc
	movslq %ebx,%rbx
	movq _fldtab(%rip),%rcx
	movq %rax,(%rcx,%rbx,8)
	movq _fldtab(%rip),%rax
	cmpq $0,(%rax,%rbx,8)
	jnz L31
L29:
	pushq %rbx
	pushq $L32
	call _FATAL
	addq $16,%rsp
L31:
	movq _fldtab(%rip),%rax
	movl $48,%ecx
	movl $_dollar1,%esi
	movq (%rax,%rbx,8),%rdi
	rep 
	movsb 
	leaq -50(%rbp),%rax
	pushq %rbx
	pushq $L33
	pushq %rax
	call _sprintf
	addq $24,%rsp
	leaq -50(%rbp),%rdi
	call _tostring
	movq _fldtab(%rip),%rcx
	movq (%rcx,%rbx,8),%rcx
	movq %rax,8(%rcx)
	incl %ebx
L25:
	cmpl %ebx,%r12d
	jge L26
L24:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_initgetrec:
L34:
	pushq %rbx
	pushq %r12
L35:
	movl $1,%r12d
L37:
	cvtsi2sdl %r12d,%xmm0
	movq _ARGC(%rip),%rax
	ucomisd (%rax),%xmm0
	jae L40
L38:
	movl %r12d,%edi
	call _getargv
	movq %rax,%rbx
	testq %rax,%rax
	jz L54
L44:
	cmpb $0,(%rax)
	jz L54
L46:
	movq %rbx,%rdi
	call _isclvar
	testl %eax,%eax
	jz L49
L51:
	movq %rbx,%rdi
	call _setclvar
L54:
	incl _argno(%rip)
	incl %r12d
	jmp L37
L49:
	movq _symtab(%rip),%rsi
	movl $L52,%edi
	call _lookup
	movq %rbx,%rsi
	movq %rax,%rdi
	call _setsval
	jmp L36
L40:
	movq $___stdin,_infile(%rip)
L36:
	popq %r12
	popq %rbx
	ret 

.data
.align 4
_firsttime:
	.int 1
.text
L134:
	.quad 0x0
L135:
	.quad 0x3ff0000000000000

_getrec:
L55:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L56:
	movq %rdi,%r15
	movq (%r15),%rax
	movq %rsi,%r14
	movl %edx,%r13d
	movq %rax,-8(%rbp)
	movl (%r14),%r12d
	movl %r12d,-12(%rbp)
	cmpl $0,_firsttime(%rip)
	jz L60
L58:
	movl $0,_firsttime(%rip)
	call _initgetrec
L60:
	cmpl $0,_dbg(%rip)
	jz L63
L61:
	movq _RS(%rip),%rax
	movq (%rax),%rdx
	movq _FS(%rip),%rax
	movq (%rax),%rcx
	movq _ARGC(%rip),%rax
	movsd (%rax),%xmm0
	movq _FILENAME(%rip),%rax
	movq (%rax),%rax
	subq $40,%rsp
	movq %rax,32(%rsp)
	movsd %xmm0,24(%rsp)
	movq %rcx,16(%rsp)
	movq %rdx,8(%rsp)
	movq $L64,(%rsp)
	call _printf
	addq $40,%rsp
L63:
	testl %r13d,%r13d
	jz L67
L65:
	movl $0,_donefld(%rip)
	movl $1,_donerec(%rip)
L67:
	movq -8(%rbp),%rax
	movb (%rax),%bl
	movb $0,(%rax)
L68:
	movl _argno(%rip),%eax
	cvtsi2sdl %eax,%xmm0
	movq _ARGC(%rip),%rcx
	ucomisd (%rcx),%xmm0
	jb L72
L71:
	cmpq $___stdin,_infile(%rip)
	jnz L73
L72:
	cmpl $0,_dbg(%rip)
	jz L77
L75:
	pushq _file(%rip)
	pushq %rax
	pushq $L78
	call _printf
	addq $24,%rsp
L77:
	cmpq $0,_infile(%rip)
	jnz L81
L79:
	movl _argno(%rip),%edi
	call _getargv
	movq %rax,%rdi
	movq %rdi,_file(%rip)
	testq %rdi,%rdi
	jz L136
L85:
	cmpb $0,(%rdi)
	jz L136
L87:
	call _isclvar
	movq _file(%rip),%rdi
	testl %eax,%eax
	jnz L90
L92:
	movq _FILENAME(%rip),%rax
	movq %rdi,(%rax)
	cmpl $0,_dbg(%rip)
	jz L96
L94:
	pushq _file(%rip)
	pushq $L97
	call _printf
	addq $16,%rsp
L96:
	movq _file(%rip),%rdi
	cmpb $45,(%rdi)
	jnz L103
L101:
	cmpb $0,1(%rdi)
	jnz L103
L102:
	movq $___stdin,_infile(%rip)
	jmp L100
L103:
	movl $L108,%esi
	call _fopen
	movq %rax,_infile(%rip)
	testq %rax,%rax
	jnz L100
L105:
	pushq _file(%rip)
	pushq $L109
	call _FATAL
	addq $16,%rsp
L100:
	movq _fnrloc(%rip),%rdi
	movsd L134(%rip),%xmm0
	call _setfval
L81:
	movq _infile(%rip),%rdx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _readrec
	testl %eax,%eax
	jnz L114
L113:
	movq -8(%rbp),%rax
	cmpb $0,(%rax)
	jnz L114
L115:
	movq _infile(%rip),%rdi
	cmpq $___stdin,%rdi
	jz L132
L130:
	call _fclose
L132:
	movq $0,_infile(%rip)
	jmp L136
L114:
	testl %r13d,%r13d
	jz L119
L117:
	movq _fldtab(%rip),%rax
	movq (%rax),%rcx
	movl 32(%rcx),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L122
L120:
	movq 16(%rcx),%rdi
	testq %rdi,%rdi
	jz L122
L123:
	call _free
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movq $0,16(%rax)
L122:
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movq -8(%rbp),%rcx
	movq %rcx,16(%rax)
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movl $134,32(%rax)
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movq 16(%rax),%rdi
	call _is_number
	testl %eax,%eax
	jz L119
L126:
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movq 16(%rax),%rdi
	call _atof
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movsd %xmm0,24(%rax)
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	orl $1,32(%rax)
L119:
	movq _nrloc(%rip),%rdi
	movsd 24(%rdi),%xmm1
	movsd L135(%rip),%xmm0
	addsd %xmm1,%xmm0
	call _setfval
	movq _fnrloc(%rip),%rdi
	movsd 24(%rdi),%xmm1
	movsd L135(%rip),%xmm0
	addsd %xmm1,%xmm0
	call _setfval
	movq -8(%rbp),%rax
	movq %rax,(%r15)
	movl -12(%rbp),%eax
	movl %eax,(%r14)
	movl $1,%eax
	jmp L57
L90:
	call _setclvar
L136:
	incl _argno(%rip)
	jmp L68
L73:
	movq -8(%rbp),%rax
	movb %bl,(%rax)
	movq -8(%rbp),%rax
	movq %rax,(%r15)
	movl %r12d,(%r14)
	xorl %eax,%eax
L57:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_nextfile:
L137:
L138:
	movq _infile(%rip),%rdi
	testq %rdi,%rdi
	jz L142
L143:
	cmpq $___stdin,%rdi
	jz L142
L144:
	call _fclose
L142:
	movq $0,_infile(%rip)
	incl _argno(%rip)
L139:
	ret 


_readrec:
L147:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L148:
	movq %rdi,%r15
	movq (%r15),%rax
	movq %rsi,%r14
	movq %rdx,%r13
	movq %rax,-8(%rbp)
	movl (%r14),%eax
	movl %eax,-12(%rbp)
	movq _FS(%rip),%rax
	movq (%rax),%rdi
	call _strlen
	cmpq $100,%rax
	jb L152
L150:
	movq _FS(%rip),%rax
	pushq (%rax)
	pushq $L153
	call _FATAL
	addq $16,%rsp
L152:
	movq _FS(%rip),%rax
	movq (%rax),%rsi
	movl $_inputFS,%edi
	call _strcpy
	movq _RS(%rip),%rax
	movq (%rax),%rax
	movsbl (%rax),%r12d
	testl %r12d,%r12d
	jnz L156
L154:
	movl $10,%r12d
L157:
	decl (%r13)
	js L165
L164:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movzbl (%rcx),%eax
	jmp L166
L165:
	movq %r13,%rdi
	call ___fillbuf
L166:
	cmpl $10,%eax
	jnz L159
L160:
	cmpl $-1,%eax
	jnz L157
L159:
	cmpl $-1,%eax
	jz L156
L167:
	movq %r13,%rsi
	movl %eax,%edi
	call _ungetc
L156:
	movq -8(%rbp),%rax
	movq %rax,-24(%rbp)
L174:
	decl (%r13)
	js L183
L182:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movzbl (%rcx),%ebx
	jmp L184
L183:
	movq %r13,%rdi
	call ___fillbuf
	movl %eax,%ebx
L184:
	cmpl %ebx,%r12d
	jz L177
L178:
	cmpl $-1,%ebx
	jz L177
L175:
	movq -8(%rbp),%rsi
	movq -24(%rbp),%rdx
	movq %rdx,%rcx
	subq %rsi,%rcx
	incq %rcx
	movslq -12(%rbp),%rax
	cmpq %rax,%rcx
	jle L239
L185:
	incq %rdx
	subq %rsi,%rdx
	movl $L191,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	testl %eax,%eax
	jnz L239
L188:
	pushq -8(%rbp)
	pushq $L192
	call _FATAL
	addq $16,%rsp
	jmp L239
L177:
	movq _RS(%rip),%rax
	movq (%rax),%rax
	movsbl (%rax),%eax
	cmpl %eax,%r12d
	jz L173
L196:
	cmpl $-1,%ebx
	jz L173
L195:
	decl (%r13)
	js L209
L208:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movzbl (%rcx),%ebx
	jmp L210
L209:
	movq %r13,%rdi
	call ___fillbuf
	movl %eax,%ebx
L210:
	cmpl $10,%ebx
	jz L173
L204:
	cmpl $-1,%ebx
	jz L173
L203:
	movq -24(%rbp),%rdx
	addq $2,%rdx
	subq -8(%rbp),%rdx
	movl $L215,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	testl %eax,%eax
	jnz L214
L212:
	pushq -8(%rbp)
	pushq $L192
	call _FATAL
	addq $16,%rsp
L214:
	movq -24(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-24(%rbp)
	movb $10,(%rcx)
L239:
	movq -24(%rbp),%rcx
	leaq 1(%rcx),%rax
	movq %rax,-24(%rbp)
	movb %bl,(%rcx)
	jmp L174
L173:
	movq -24(%rbp),%rdx
	incq %rdx
	subq -8(%rbp),%rdx
	movl $L219,%r9d
	leaq -24(%rbp),%r8
	movl _recsize(%rip),%ecx
	leaq -12(%rbp),%rsi
	leaq -8(%rbp),%rdi
	call _adjbuf
	testl %eax,%eax
	jnz L218
L216:
	pushq -8(%rbp)
	pushq $L192
	call _FATAL
	addq $16,%rsp
L218:
	movq -24(%rbp),%rax
	movb $0,(%rax)
	cmpl $0,_dbg(%rip)
	jz L222
L220:
	cmpl $-1,%ebx
	jnz L225
L227:
	movq -8(%rbp),%rax
	cmpq -24(%rbp),%rax
	jnz L225
L224:
	xorl %eax,%eax
	jmp L226
L225:
	movl $1,%eax
L226:
	pushq %rax
	pushq -8(%rbp)
	pushq $L223
	call _printf
	addq $24,%rsp
L222:
	movq -8(%rbp),%rax
	movq %rax,(%r15)
	movl -12(%rbp),%eax
	movl %eax,(%r14)
	cmpl $-1,%ebx
	jnz L232
L234:
	movq -8(%rbp),%rax
	cmpq -24(%rbp),%rax
	jnz L232
L231:
	xorl %eax,%eax
	jmp L149
L232:
	movl $1,%eax
L149:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_getargv:
L240:
	pushq %rbp
	movq %rsp,%rbp
	subq $56,%rsp
	pushq %rbx
	pushq %r12
L241:
	movl %edi,%r12d
	leaq -50(%rbp),%rax
	pushq %r12
	pushq $L33
	pushq %rax
	call _sprintf
	addq $24,%rsp
	movq _ARGVtab(%rip),%rsi
	leaq -50(%rbp),%rdi
	call _lookup
	testq %rax,%rax
	jz L243
L245:
	movq _ARGVtab(%rip),%rcx
	movl $2,%edx
	movsd L134(%rip),%xmm0
	movl $L1,%esi
	leaq -50(%rbp),%rdi
	call _setsymtab
	movq %rax,%rdi
	call _getsval
	movq %rax,%rbx
	cmpl $0,_dbg(%rip)
	jz L249
L247:
	pushq %rbx
	pushq %r12
	pushq $L250
	call _printf
	addq $24,%rsp
L249:
	movq %rbx,%rax
	jmp L242
L243:
	xorl %eax,%eax
L242:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_setclvar:
L252:
	pushq %rbx
	pushq %r12
	pushq %r13
L253:
	movq %rdi,%r13
	movq %r13,%rdi
	jmp L255
L256:
	movq %rax,%rdi
L255:
	leaq 1(%rdi),%rax
	cmpb $61,(%rdi)
	jnz L256
L258:
	movb $0,(%rdi)
	xorl %esi,%esi
	incq %rdi
	call _qstring
	movq %rax,%r12
	movq _symtab(%rip),%rcx
	movl $2,%edx
	movsd L134(%rip),%xmm0
	movq %r12,%rsi
	movq %r13,%rdi
	call _setsymtab
	movq %rax,%rbx
	movq %r12,%rsi
	movq %rbx,%rdi
	call _setsval
	movq 16(%rbx),%rdi
	call _is_number
	testl %eax,%eax
	jz L261
L259:
	movq 16(%rbx),%rdi
	call _atof
	movsd %xmm0,24(%rbx)
	orl $1,32(%rbx)
L261:
	cmpl $0,_dbg(%rip)
	jz L254
L262:
	pushq %r12
	pushq %r13
	pushq $L265
	call _printf
	addq $24,%rsp
L254:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_fldbld:
L266:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L267:
	cmpl $0,_donefld(%rip)
	jnz L268
L271:
	movq _fldtab(%rip),%rax
	movq (%rax),%rdi
	testl $2,32(%rdi)
	jnz L275
L273:
	call _getsval
L275:
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movq 16(%rax),%rbx
	movq %rbx,%rdi
	call _strlen
	movl %eax,%r12d
	cmpl _fieldssize(%rip),%r12d
	jle L278
L276:
	movq _fields(%rip),%rdi
	testq %rdi,%rdi
	jz L281
L279:
	call _free
	movq $0,_fields(%rip)
L281:
	leal 2(%r12),%edi
	movslq %edi,%rdi
	call _malloc
	movq %rax,_fields(%rip)
	testq %rax,%rax
	jnz L284
L282:
	pushq %r12
	pushq $L285
	call _FATAL
	addq $16,%rsp
L284:
	movl %r12d,_fieldssize(%rip)
L278:
	movq _fields(%rip),%rax
	movq %rax,-16(%rbp) # spill
	movq _FS(%rip),%rax
	movq -16(%rbp),%r14 # spill
	xorl %r12d,%r12d
	movq (%rax),%rsi
	movl $_inputFS,%edi
	call _strcpy
	movl $_inputFS,%edi
	call _strlen
	cmpq $1,%rax
	jbe L287
L286:
	movl $_inputFS,%esi
	movq %rbx,%rdi
	call _refldbld
	movl %eax,%r12d
	jmp L288
L287:
	movb _inputFS(%rip),%al
	cmpb $32,%al
	movb %al,-17(%rbp) # spill
	jnz L290
L289:
	xorl %r12d,%r12d
L296:
	movb (%rbx),%al
	cmpb $32,%al
	jz L300
L303:
	cmpb $9,%al
	jz L300
L305:
	cmpb $10,%al
	jnz L301
L300:
	incq %rbx
	jmp L296
L301:
	testb %al,%al
	jz L404
L309:
	leal 1(%r12),%r13d
	movl %r13d,%r12d
	cmpl _nfields(%rip),%r13d
	jle L313
L311:
	movl %r13d,%edi
	call _growfldtab
L313:
	movq _fldtab(%rip),%rax
	movq (%rax,%r13,8),%rcx
	movl 32(%rcx),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L316
L314:
	movq 16(%rcx),%rdi
	testq %rdi,%rdi
	jz L316
L317:
	call _free
	movq _fldtab(%rip),%rax
	movq (%rax,%r13,8),%rax
	movq $0,16(%rax)
L316:
	movq _fldtab(%rip),%rax
	movq (%rax,%r13,8),%rax
	movq %r14,16(%rax)
	movq _fldtab(%rip),%rax
	movq (%rax,%r13,8),%rax
	movl $70,32(%rax)
L320:
	movb (%rbx),%al
	incq %rbx
	movb %al,(%r14)
	incq %r14
	movb (%rbx),%al
	cmpb $32,%al
	jz L325
L331:
	cmpb $9,%al
	jz L325
L332:
	cmpb $10,%al
	jz L325
L328:
	testb %al,%al
	jnz L320
L325:
	movb $0,(%r14)
	incq %r14
	jmp L296
L290:
	cmpb $0,-17(%rbp) # spill
	jnz L336
L335:
	xorl %r12d,%r12d
	jmp L338
L339:
	leal 1(%r12),%r13d
	movl %r13d,%r12d
	cmpl %r13d,_nfields(%rip)
	jge L344
L342:
	movl %r13d,%edi
	call _growfldtab
L344:
	movq _fldtab(%rip),%rax
	movq (%rax,%r13,8),%rcx
	movl 32(%rcx),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L347
L345:
	movq 16(%rcx),%rdi
	testq %rdi,%rdi
	jz L347
L348:
	call _free
	movq _fldtab(%rip),%rax
	movq (%rax,%r13,8),%rax
	movq $0,16(%rax)
L347:
	movb (%rbx),%al
	movb %al,-2(%rbp)
	movb $0,-1(%rbp)
	leaq -2(%rbp),%rdi
	call _tostring
	movq _fldtab(%rip),%rcx
	movq (%rcx,%r13,8),%rcx
	movq %rax,16(%rcx)
	movq _fldtab(%rip),%rax
	movq (%rax,%r13,8),%rax
	movl $66,32(%rax)
	incq %rbx
L338:
	cmpb $0,(%rbx)
	jnz L339
L341:
	movq -16(%rbp),%rax # spill
	movb $0,(%rax)
	jmp L288
L336:
	cmpb $0,(%rbx)
	jz L288
L351:
	movq _RS(%rip),%rax
	movl $10,%r13d
	movq (%rax),%rdi
	call _strlen
	testq %rax,%rax
	movl $0,%eax
	cmovnzl %eax,%r13d
L357:
	incl %r12d
	cmpl %r12d,_nfields(%rip)
	jge L363
L361:
	movl %r12d,%edi
	call _growfldtab
L363:
	movq _fldtab(%rip),%rax
	movq (%rax,%r12,8),%rcx
	movl 32(%rcx),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L366
L364:
	movq 16(%rcx),%rdi
	testq %rdi,%rdi
	jz L366
L367:
	call _free
	movq _fldtab(%rip),%rax
	movq (%rax,%r12,8),%rax
	movq $0,16(%rax)
L366:
	movq _fldtab(%rip),%rax
	movq (%rax,%r12,8),%rax
	movq %r14,16(%rax)
	movq _fldtab(%rip),%rax
	movq (%rax,%r12,8),%rax
	movl $70,32(%rax)
	jmp L370
L377:
	movsbl %al,%eax
	cmpl %eax,%r13d
	jz L375
L378:
	testb %al,%al
	jz L375
L374:
	incq %rbx
	movb %al,(%r14)
	incq %r14
L370:
	movb (%rbx),%al
	cmpb %al,-17(%rbp) # spill
	jnz L377
L375:
	movb $0,(%r14)
	incq %r14
	movb (%rbx),%al
	incq %rbx
	testb %al,%al
	jnz L357
L404:
	movb $0,(%r14)
L288:
	cmpl _nfields(%rip),%r12d
	jle L387
L385:
	pushq %rbx
	pushq $L388
	call _FATAL
	addq $16,%rsp
L387:
	movl _lastfld(%rip),%esi
	leal 1(%r12),%edi
	call _cleanfld
	movl %r12d,_lastfld(%rip)
	movl $1,_donefld(%rip)
	movl $1,%r12d
	jmp L389
L390:
	movq _fldtab(%rip),%rax
	movq (%rax,%r12,8),%rbx
	movq 16(%rbx),%rdi
	call _is_number
	testl %eax,%eax
	jz L395
L393:
	movq 16(%rbx),%rdi
	call _atof
	movsd %xmm0,24(%rbx)
	orl $1,32(%rbx)
L395:
	incl %r12d
L389:
	movl _lastfld(%rip),%eax
	cmpl %r12d,%eax
	jge L390
L392:
	cvtsi2sdl %eax,%xmm0
	movq _nfloc(%rip),%rdi
	call _setfval
	cmpl $0,_dbg(%rip)
	jz L268
L396:
	xorl %ebx,%ebx
	jmp L399
L400:
	movq _fldtab(%rip),%rax
	movq (%rax,%rbx,8),%rax
	pushq 16(%rax)
	pushq 8(%rax)
	pushq %rbx
	pushq $L403
	call _printf
	addq $32,%rsp
	incl %ebx
L399:
	cmpl %ebx,_lastfld(%rip)
	jge L400
L268:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_cleanfld:
L405:
	pushq %rbx
	pushq %r12
	pushq %r13
L406:
	movl %esi,%r13d
	movl %edi,%r12d
	jmp L408
L409:
	movslq %r12d,%r12
	movq _fldtab(%rip),%rax
	movq (%rax,%r12,8),%rbx
	movl 32(%rbx),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L414
L412:
	movq 16(%rbx),%rdi
	testq %rdi,%rdi
	jz L414
L415:
	call _free
	movq $0,16(%rbx)
L414:
	movq $L1,16(%rbx)
	movl $70,32(%rbx)
	incl %r12d
L408:
	cmpl %r12d,%r13d
	jge L409
L407:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_newfld:
L418:
	pushq %rbx
L419:
	movl %edi,%ebx
	cmpl _nfields(%rip),%ebx
	jle L423
L421:
	movl %ebx,%edi
	call _growfldtab
L423:
	movl _lastfld(%rip),%edi
	movl %ebx,%esi
	incl %edi
	call _cleanfld
	movl %ebx,_lastfld(%rip)
	cvtsi2sdl %ebx,%xmm0
	movq _nfloc(%rip),%rdi
	call _setfval
L420:
	popq %rbx
	ret 


_fieldadr:
L424:
	pushq %rbx
L425:
	movl %edi,%ebx
	cmpl $0,%ebx
	jge L429
L427:
	pushq %rbx
	pushq $L430
	call _FATAL
	addq $16,%rsp
L429:
	cmpl _nfields(%rip),%ebx
	jle L433
L431:
	movl %ebx,%edi
	call _growfldtab
L433:
	movslq %ebx,%rbx
	movq _fldtab(%rip),%rax
	movq (%rax,%rbx,8),%rax
L426:
	popq %rbx
	ret 


_growfldtab:
L435:
	pushq %rbx
L436:
	movl _nfields(%rip),%ebx
	shll $1,%ebx
	cmpl %ebx,%edi
	cmovgl %edi,%ebx
	leal 1(%rbx),%esi
	movslq %esi,%rsi
	movq %rsi,%rax
	shlq $3,%rax
	shrq $3,%rax
	decq %rax
	movslq %ebx,%rbx
	movq _fldtab(%rip),%rdi
	cmpq %rbx,%rax
	jnz L442
L441:
	shlq $3,%rsi
	call _realloc
	movq %rax,_fldtab(%rip)
	jmp L443
L442:
	testq %rdi,%rdi
	jz L443
L444:
	call _free
	movq $0,_fldtab(%rip)
L443:
	cmpq $0,_fldtab(%rip)
	jnz L449
L447:
	pushq %rbx
	pushq $L450
	call _FATAL
	addq $16,%rsp
L449:
	movl _nfields(%rip),%edi
	movl %ebx,%esi
	incl %edi
	call _makefields
	movl %ebx,_nfields(%rip)
L437:
	popq %rbx
	ret 


_refldbld:
L451:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L452:
	movq %rdi,%r15
	movq %rsi,%r12
	movq %r15,%rdi
	call _strlen
	movl %eax,%ebx
	cmpl _fieldssize(%rip),%ebx
	jle L456
L454:
	movq _fields(%rip),%rdi
	testq %rdi,%rdi
	jz L459
L457:
	call _free
	movq $0,_fields(%rip)
L459:
	leal 1(%rbx),%edi
	movslq %edi,%rdi
	call _malloc
	movq %rax,_fields(%rip)
	testq %rax,%rax
	jnz L462
L460:
	pushq %rbx
	pushq $L463
	call _FATAL
	addq $16,%rsp
L462:
	movl %ebx,_fieldssize(%rip)
L456:
	movq _fields(%rip),%r14
	movb $0,(%r14)
	cmpb $0,(%r15)
	jz L464
L466:
	movl $1,%esi
	movq %r12,%rdi
	call _makedfa
	movq %rax,%r13
	cmpl $0,_dbg(%rip)
	jz L470
L468:
	pushq %r12
	pushq %r15
	pushq $L471
	call _printf
	addq $24,%rsp
L470:
	movl 8592(%r13),%r12d
	movl $1,%ebx
L472:
	cmpl _nfields(%rip),%ebx
	jle L478
L476:
	movl %ebx,%edi
	call _growfldtab
L478:
	movq _fldtab(%rip),%rax
	movq (%rax,%rbx,8),%rcx
	movl 32(%rcx),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L481
L479:
	movq 16(%rcx),%rdi
	testq %rdi,%rdi
	jz L481
L482:
	call _free
	movq _fldtab(%rip),%rax
	movq (%rax,%rbx,8),%rax
	movq $0,16(%rax)
L481:
	movq _fldtab(%rip),%rax
	movq (%rax,%rbx,8),%rax
	movl $70,32(%rax)
	movq _fldtab(%rip),%rax
	movq (%rax,%rbx,8),%rax
	movq %r14,16(%rax)
	cmpl $0,_dbg(%rip)
	jz L487
L485:
	pushq %rbx
	pushq $L488
	call _printf
	addq $16,%rsp
L487:
	movq %r15,%rsi
	movq %r13,%rdi
	call _nematch
	testl %eax,%eax
	jz L490
L489:
	movl $2,8592(%r13)
	cmpl $0,_dbg(%rip)
	jz L494
L492:
	movq _patbeg(%rip),%rcx
	movl _patlen(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq $L495
	call _printf
	addq $24,%rsp
L494:
	movq _patbeg(%rip),%rdx
	subq %r15,%rdx
	movq %r15,%rsi
	movq %r14,%rdi
	call _strncpy
	movq _patbeg(%rip),%rax
	subq %r15,%rax
	leaq 1(%r14,%rax),%r14
	movb $0,-1(%r14)
	movslq _patlen(%rip),%r15
	addq _patbeg(%rip),%r15
	incl %ebx
	jmp L472
L490:
	cmpl $0,_dbg(%rip)
	jz L498
L496:
	pushq %r15
	pushq $L499
	call _printf
	addq $16,%rsp
L498:
	movq %r15,%rsi
	movq %r14,%rdi
	call _strcpy
	movl %r12d,8592(%r13)
	movl %ebx,%eax
	jmp L453
L464:
	xorl %eax,%eax
L453:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_recbld:
L502:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L503:
	cmpl $1,_donerec(%rip)
	jz L504
L507:
	movq _record(%rip),%rax
	movq %rax,-8(%rbp)
	movl $1,%ebx
	jmp L509
L510:
	movq _fldtab(%rip),%rax
	movq (%rax,%rbx,8),%rdi
	call _getsval
	movq %rax,%r12
	movq %rax,%rdi
	call _strlen
	movq -8(%rbp),%rcx
	leaq 1(%rax,%rcx),%rdx
	subq _record(%rip),%rdx
	movl $L516,%r9d
	leaq -8(%rbp),%r8
	movl _recsize(%rip),%ecx
	movl $_recsize,%esi
	movl $_record,%edi
	call _adjbuf
	testl %eax,%eax
	jnz L518
L513:
	pushq _record(%rip)
	pushq $L517
	call _FATAL
	addq $16,%rsp
L518:
	movb (%r12),%al
	incq %r12
	movq -8(%rbp),%rcx
	movb %al,(%rcx)
	testb %al,%al
	jz L520
L519:
	incq -8(%rbp)
	jmp L518
L520:
	cvtsi2sdl %ebx,%xmm0
	movq _NF(%rip),%rax
	ucomisd (%rax),%xmm0
	jae L523
L521:
	movq _OFS(%rip),%rax
	movq (%rax),%rdi
	call _strlen
	movq -8(%rbp),%rcx
	leaq 2(%rax,%rcx),%rdx
	subq _record(%rip),%rdx
	movl $L527,%r9d
	leaq -8(%rbp),%r8
	movl _recsize(%rip),%ecx
	movl $_recsize,%esi
	movl $_record,%edi
	call _adjbuf
	testl %eax,%eax
	jnz L526
L524:
	pushq _record(%rip)
	pushq $L517
	call _FATAL
	addq $16,%rsp
L526:
	movq _OFS(%rip),%rax
	movq (%rax),%rcx
L528:
	movb (%rcx),%al
	incq %rcx
	movq -8(%rbp),%rdx
	movb %al,(%rdx)
	testb %al,%al
	jz L523
L529:
	incq -8(%rbp)
	jmp L528
L523:
	incl %ebx
L509:
	cvtsi2sdl %ebx,%xmm0
	movq _NF(%rip),%rax
	ucomisd (%rax),%xmm0
	jbe L510
L512:
	movq -8(%rbp),%rdx
	addq $2,%rdx
	subq _record(%rip),%rdx
	movl $L535,%r9d
	leaq -8(%rbp),%r8
	movl _recsize(%rip),%ecx
	movl $_recsize,%esi
	movl $_record,%edi
	call _adjbuf
	testl %eax,%eax
	jnz L534
L532:
	pushq _record(%rip)
	pushq $L536
	call _FATAL
	addq $16,%rsp
L534:
	movq -8(%rbp),%rax
	movb $0,(%rax)
	cmpl $0,_dbg(%rip)
	jz L539
L537:
	movq _fldtab(%rip),%rax
	pushq (%rax)
	pushq $_inputFS
	pushq $L540
	call _printf
	addq $24,%rsp
L539:
	movq _fldtab(%rip),%rax
	movq (%rax),%rcx
	movl 32(%rcx),%eax
	andl $6,%eax
	cmpl $2,%eax
	jnz L543
L541:
	movq 16(%rcx),%rdi
	testq %rdi,%rdi
	jz L543
L544:
	call _free
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movq $0,16(%rax)
L543:
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movl $134,32(%rax)
	movq _fldtab(%rip),%rax
	movq (%rax),%rax
	movq _record(%rip),%rcx
	movq %rcx,16(%rax)
	cmpl $0,_dbg(%rip)
	jz L549
L547:
	movq _fldtab(%rip),%rax
	pushq (%rax)
	pushq $_inputFS
	pushq $L540
	call _printf
	addq $24,%rsp
L549:
	cmpl $0,_dbg(%rip)
	jz L552
L550:
	pushq _record(%rip)
	pushq $L553
	call _printf
	addq $16,%rsp
L552:
	movl $1,_donerec(%rip)
L504:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 4
_errorflag:
	.int 0
.text

_yyerror:
L554:
L555:
	pushq %rdi
	pushq $L557
	call _SYNTAX
	addq $16,%rsp
L556:
	ret 

.data
.align 4
L561:
	.int 0
.text

_SYNTAX:
L558:
	pushq %rbp
	movq %rsp,%rbp
L559:
	movq 16(%rbp),%rax
	movq %rax,16(%rbp)
	movl L561(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,L561(%rip)
	cmpl $2,%ecx
	jg L560
L564:
	pushq _cmdname(%rip)
	pushq $L566
	pushq $___stderr
	call _fprintf
	leaq 24(%rbp),%rdx
	movq 16(%rbp),%rsi
	movl $___stderr,%edi
	call _vfprintf
	movl _lineno(%rip),%eax
	pushq %rax
	pushq $L567
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
	movq _curfname(%rip),%rax
	testq %rax,%rax
	jz L570
L568:
	pushq %rax
	pushq $L571
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L570:
	cmpl $1,_compile_time(%rip)
	jnz L574
L575:
	call _cursource
	testq %rax,%rax
	jz L574
L576:
	call _cursource
	pushq %rax
	pushq $L579
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L574:
	pushq $L580
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $2,_errorflag(%rip)
	call _eprint
L560:
	popq %rbp
	ret 


_fpecatch:
L581:
L582:
	pushq %rdi
	pushq $L584
	call _FATAL
	addq $16,%rsp
L583:
	ret 

.data
.align 4
L588:
	.int 0
.text

_bracecheck:
L585:
L586:
	movl L588(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,L588(%rip)
	testl %ecx,%ecx
	jz L593
	ret
L596:
	testl %eax,%eax
	jz L595
L594:
	movl %eax,%edi
	call _bclass
L593:
	call _input
	cmpl $-1,%eax
	jnz L596
L595:
	movl $125,%edx
	movl $123,%esi
	movl _bracecnt(%rip),%edi
	call _bcheck2
	movl $93,%edx
	movl $91,%esi
	movl _brackcnt(%rip),%edi
	call _bcheck2
	movl $41,%edx
	movl $40,%esi
	movl _parencnt(%rip),%edi
	call _bcheck2
L587:
	ret 


_bcheck2:
L600:
L601:
	cmpl $1,%edi
	jz L603
	jl L608
L607:
	pushq %rdx
	pushq %rdi
	pushq $L610
	jmp L620
L608:
	cmpl $-1,%edi
	jz L611
	jg L602
L615:
	negl %edi
	pushq %rdx
	pushq %rdi
	pushq $L618
L620:
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	ret
L611:
	pushq %rdx
	pushq $L614
	jmp L619
L603:
	pushq %rdx
	pushq $L606
L619:
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L602:
	ret 


_FATAL:
L621:
	pushq %rbp
	movq %rsp,%rbp
L622:
	movq 16(%rbp),%rax
	movq %rax,16(%rbp)
	movl $___stdout,%edi
	call _fflush
	pushq _cmdname(%rip)
	pushq $L566
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	leaq 24(%rbp),%rdx
	movq 16(%rbp),%rsi
	movl $___stderr,%edi
	call _vfprintf
	call _error
	cmpl $1,_dbg(%rip)
	jle L626
L624:
	call _abort
L626:
	movl $2,%edi
	call _exit
L623:
	popq %rbp
	ret 


_WARNING:
L627:
	pushq %rbp
	movq %rsp,%rbp
L628:
	movq 16(%rbp),%rax
	movq %rax,16(%rbp)
	movl $___stdout,%edi
	call _fflush
	pushq _cmdname(%rip)
	pushq $L566
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	leaq 24(%rbp),%rdx
	movq 16(%rbp),%rsi
	movl $___stderr,%edi
	call _vfprintf
	call _error
L629:
	popq %rbp
	ret 


_error:
L630:
L631:
	pushq $L580
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	cmpl $2,_compile_time(%rip)
	jz L635
L640:
	movq _NR(%rip),%rax
	testq %rax,%rax
	jz L635
L636:
	movsd (%rax),%xmm0
	ucomisd L134(%rip),%xmm0
	jbe L635
L633:
	movq _FNR(%rip),%rax
	cvttsd2sil (%rax),%eax
	pushq %rax
	pushq $L644
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movq _FILENAME(%rip),%rax
	movl $L648,%esi
	movq (%rax),%rdi
	call _strcmp
	testl %eax,%eax
	jz L647
L645:
	movq _FILENAME(%rip),%rax
	pushq (%rax)
	pushq $L649
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L647:
	pushq $L580
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L635:
	movl _compile_time(%rip),%ecx
	cmpl $2,%ecx
	jz L651
L653:
	movq _curnode(%rip),%rax
	testq %rax,%rax
	jz L651
L650:
	movl 16(%rax),%eax
	jmp L673
L651:
	cmpl $2,%ecx
	jz L652
L661:
	movl _lineno(%rip),%eax
	testl %eax,%eax
	jz L652
L673:
	pushq %rax
	pushq $L657
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L652:
	cmpl $1,_compile_time(%rip)
	jnz L667
L668:
	call _cursource
	testq %rax,%rax
	jz L667
L665:
	call _cursource
	pushq %rax
	pushq $L579
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L667:
	pushq $L580
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	call _eprint
L632:
	ret 

.data
.align 4
L677:
	.int 0
.text

_eprint:
L674:
	pushq %rbx
	pushq %r12
L675:
	movl _compile_time(%rip),%eax
	cmpl $2,%eax
	jz L676
L685:
	testl %eax,%eax
	jz L676
L687:
	movl L677(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,L677(%rip)
	cmpl $0,%ecx
	jg L676
L683:
	movq _ep(%rip),%rax
	movq %rax,%r12
	decq %r12
	cmpq $_ebuf,%r12
	jbe L697
L693:
	cmpb $10,-1(%rax)
	jnz L697
L694:
	leaq -2(%rax),%r12
L697:
	cmpq $_ebuf,%r12
	jbe L709
L705:
	movb (%r12),%al
	cmpb $10,%al
	jz L709
L706:
	testb %al,%al
	jnz L702
	jz L709
L710:
	incq %r12
L709:
	cmpb $10,(%r12)
	jz L710
L711:
	pushq $L712
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq _ep(%rip),%rbx
	decq %rbx
L713:
	cmpq %rbx,%r12
	ja L729
L725:
	movb (%rbx),%al
	cmpb $32,%al
	jz L729
L726:
	cmpb $9,%al
	jz L729
L722:
	cmpb $10,%al
	jnz L718
	jz L729
L730:
	cmpb $0,(%r12)
	jz L735
L733:
	decl ___stderr(%rip)
	js L737
L736:
	movb (%r12),%dl
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb %dl,(%rcx)
	jmp L735
L737:
	movsbl (%r12),%edi
	movl $___stderr,%esi
	call ___flushbuf
L735:
	incq %r12
L729:
	cmpq %rbx,%r12
	jb L730
L732:
	pushq $L739
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L740
L741:
	cmpb $0,(%r12)
	jz L746
L744:
	decl ___stderr(%rip)
	js L748
L747:
	movb (%r12),%dl
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb %dl,(%rcx)
	jmp L746
L748:
	movsbl (%r12),%edi
	movl $___stderr,%esi
	call ___flushbuf
L746:
	incq %r12
L740:
	cmpq %r12,_ep(%rip)
	ja L741
L743:
	pushq $L750
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq _ep(%rip),%rax
	cmpb $0,(%rax)
	jnz L754
	jz L753
L761:
	testl %ebx,%ebx
	jz L753
L762:
	cmpl $-1,%ebx
	jz L753
L758:
	decl ___stderr(%rip)
	js L766
L765:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb %bl,(%rcx)
	jmp L767
L766:
	movl $___stderr,%esi
	movl %ebx,%edi
	call ___flushbuf
L767:
	movl %ebx,%edi
	call _bclass
L754:
	call _input
	movl %eax,%ebx
	cmpl $10,%ebx
	jnz L761
L753:
	decl ___stderr(%rip)
	js L769
L768:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $10,(%rcx)
	jmp L770
L769:
	movl $___stderr,%esi
	movl $10,%edi
	call ___flushbuf
L770:
	movq $_ebuf,_ep(%rip)
L676:
	popq %r12
	popq %rbx
	ret 
L718:
	decq %rbx
	jmp L713
L702:
	decq %r12
	jmp L697


_bclass:
L771:
L772:
	cmpl $40,%edi
	jz L785
	jl L773
L790:
	cmpl $125,%edi
	jz L779
	jg L773
L791:
	cmpb $41,%dil
	jz L787
L792:
	cmpb $91,%dil
	jz L781
L793:
	cmpb $93,%dil
	jz L783
L794:
	cmpb $123,%dil
	jnz L773
L777:
	movl _bracecnt(%rip),%eax
	incl %eax
	jmp L799
L783:
	movl _brackcnt(%rip),%eax
	decl %eax
	jmp L798
L781:
	movl _brackcnt(%rip),%eax
	incl %eax
L798:
	movl %eax,_brackcnt(%rip)
	ret
L787:
	movl _parencnt(%rip),%eax
	decl %eax
	jmp L797
L779:
	movl _bracecnt(%rip),%eax
	decl %eax
L799:
	movl %eax,_bracecnt(%rip)
	ret
L785:
	movl _parencnt(%rip),%eax
	incl %eax
L797:
	movl %eax,_parencnt(%rip)
L773:
	ret 


_errcheck:
L800:
L801:
	movl _errno(%rip),%eax
	cmpl $33,%eax
	jnz L804
L803:
	movl $0,_errno(%rip)
	pushq %rdi
	pushq $L806
	jmp L813
L804:
	cmpl $34,%eax
	jnz L802
L807:
	movl $0,_errno(%rip)
	pushq %rdi
	pushq $L810
L813:
	call _WARNING
	addq $16,%rsp
	movsd L135(%rip),%xmm0
L802:
	ret 


_isclvar:
L814:
L815:
	movzbq (%rdi),%rax
	movq %rdi,%rcx
	testb $3,___ctype+1(%rax)
	jnz L825
L820:
	cmpb $95,%al
	jz L825
	jnz L846
L826:
	movzbq %al,%rax
	testb $7,___ctype+1(%rax)
	jnz L831
L832:
	cmpb $95,%al
	jnz L828
L831:
	incq %rdi
L825:
	movb (%rdi),%al
	testb %al,%al
	jnz L826
L828:
	cmpb $61,%al
	jnz L846
L841:
	cmpq %rcx,%rdi
	jbe L846
L837:
	cmpb $61,1(%rdi)
	jz L846
L838:
	movl $1,%eax
	ret
L846:
	xorl %eax,%eax
L816:
	ret 


_is_number:
L847:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L848:
	movq %rdi,%rbx
	movl $0,_errno(%rip)
	leaq -8(%rbp),%rsi
	movq %rbx,%rdi
	call _strtod
	cmpq -8(%rbp),%rbx
	jz L878
L857:
	ucomisd ___huge_val(%rip),%xmm0
	jz L878
L859:
	cmpl $34,_errno(%rip)
	jz L878
L862:
	movq -8(%rbp),%rcx
	movb (%rcx),%al
	cmpb $32,%al
	jz L866
L869:
	cmpb $9,%al
	jz L866
L871:
	cmpb $10,%al
	jnz L867
L866:
	incq %rcx
	movq %rcx,-8(%rbp)
	jmp L862
L867:
	testb %al,%al
	jnz L878
L873:
	movl $1,%eax
	jmp L849
L878:
	xorl %eax,%eax
L849:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L644:
	.byte 32,105,110,112,117,116,32,114
	.byte 101,99,111,114,100,32,110,117
	.byte 109,98,101,114,32,37,100,0
L1:
	.byte 0
L516:
	.byte 114,101,99,98,108,100,32,49
	.byte 0
L488:
	.byte 114,101,102,108,100,98,108,100
	.byte 58,32,105,61,37,100,10,0
L33:
	.byte 37,100,0
L192:
	.byte 105,110,112,117,116,32,114,101
	.byte 99,111,114,100,32,96,37,46
	.byte 51,48,115,46,46,46,39,32
	.byte 116,111,111,32,108,111,110,103
	.byte 0
L567:
	.byte 32,97,116,32,115,111,117,114
	.byte 99,101,32,108,105,110,101,32
	.byte 37,100,0
L495:
	.byte 109,97,116,99,104,32,37,115
	.byte 32,40,37,100,32,99,104,97
	.byte 114,115,41,10,0
L553:
	.byte 114,101,99,98,108,100,32,61
	.byte 32,124,37,115,124,10,0
L52:
	.byte 70,73,76,69,78,65,77,69
	.byte 0
L540:
	.byte 105,110,32,114,101,99,98,108
	.byte 100,32,105,110,112,117,116,70
	.byte 83,61,37,115,44,32,102,108
	.byte 100,116,97,98,91,48,93,61
	.byte 37,112,10,0
L223:
	.byte 114,101,97,100,114,101,99,32
	.byte 115,97,119,32,60,37,115,62
	.byte 44,32,114,101,116,117,114,110
	.byte 115,32,37,100,10,0
L566:
	.byte 37,115,58,32,0
L20:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,36,48,32,97,110,100,32
	.byte 102,105,101,108,100,115,0
L463:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,102,105,101,108,100,115,32
	.byte 105,110,32,114,101,102,108,100
	.byte 98,108,100,32,37,100,0
L64:
	.byte 82,83,61,60,37,115,62,44
	.byte 32,70,83,61,60,37,115,62
	.byte 44,32,65,82,71,67,61,37
	.byte 103,44,32,70,73,76,69,78
	.byte 65,77,69,61,37,115,10,0
L606:
	.byte 9,109,105,115,115,105,110,103
	.byte 32,37,99,10,0
L806:
	.byte 37,115,32,97,114,103,117,109
	.byte 101,110,116,32,111,117,116,32
	.byte 111,102,32,100,111,109,97,105
	.byte 110,0
L32:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,105,110,32
	.byte 109,97,107,101,102,105,101,108
	.byte 100,115,32,37,100,0
L388:
	.byte 114,101,99,111,114,100,32,96
	.byte 37,46,51,48,115,46,46,46
	.byte 39,32,104,97,115,32,116,111
	.byte 111,32,109,97,110,121,32,102
	.byte 105,101,108,100,115,59,32,99
	.byte 97,110,39,116,32,104,97,112
	.byte 112,101,110,0
L536:
	.byte 98,117,105,108,116,32,103,105
	.byte 97,110,116,32,114,101,99,111
	.byte 114,100,32,96,37,46,51,48
	.byte 115,46,46,46,39,0
L579:
	.byte 32,115,111,117,114,99,101,32
	.byte 102,105,108,101,32,37,115,0
L648:
	.byte 45,0
L471:
	.byte 105,110,116,111,32,114,101,102
	.byte 108,100,98,108,100,44,32,114
	.byte 101,99,32,61,32,60,37,115
	.byte 62,44,32,112,97,116,32,61
	.byte 32,60,37,115,62,10,0
L265:
	.byte 99,111,109,109,97,110,100,32
	.byte 108,105,110,101,32,115,101,116
	.byte 32,37,115,32,116,111,32,124
	.byte 37,115,124,10,0
L580:
	.byte 10,0
L610:
	.byte 9,37,100,32,109,105,115,115
	.byte 105,110,103,32,37,99,39,115
	.byte 10,0
L614:
	.byte 9,101,120,116,114,97,32,37
	.byte 99,10,0
L584:
	.byte 102,108,111,97,116,105,110,103
	.byte 32,112,111,105,110,116,32,101
	.byte 120,99,101,112,116,105,111,110
	.byte 32,37,100,0
L78:
	.byte 97,114,103,110,111,61,37,100
	.byte 44,32,102,105,108,101,61,124
	.byte 37,115,124,10,0
L403:
	.byte 102,105,101,108,100,32,37,100
	.byte 32,40,37,115,41,58,32,124
	.byte 37,115,124,10,0
L649:
	.byte 44,32,102,105,108,101,32,37
	.byte 115,0
L219:
	.byte 114,101,97,100,114,101,99,32
	.byte 51,0
L215:
	.byte 114,101,97,100,114,101,99,32
	.byte 50,0
L250:
	.byte 103,101,116,97,114,103,118,40
	.byte 37,100,41,32,114,101,116,117
	.byte 114,110,115,32,124,37,115,124
	.byte 10,0
L557:
	.byte 37,115,0
L191:
	.byte 114,101,97,100,114,101,99,32
	.byte 49,0
L618:
	.byte 9,37,100,32,101,120,116,114
	.byte 97,32,37,99,39,115,10,0
L810:
	.byte 37,115,32,114,101,115,117,108
	.byte 116,32,111,117,116,32,111,102
	.byte 32,114,97,110,103,101,0
L108:
	.byte 114,0
L153:
	.byte 102,105,101,108,100,32,115,101
	.byte 112,97,114,97,116,111,114,32
	.byte 37,46,49,48,115,46,46,46
	.byte 32,105,115,32,116,111,111,32
	.byte 108,111,110,103,0
L750:
	.byte 32,60,60,60,32,0
L517:
	.byte 99,114,101,97,116,101,100,32
	.byte 36,48,32,96,37,46,51,48
	.byte 115,46,46,46,39,32,116,111
	.byte 111,32,108,111,110,103,0
L712:
	.byte 32,99,111,110,116,101,120,116
	.byte 32,105,115,10,9,0
L571:
	.byte 32,105,110,32,102,117,110,99
	.byte 116,105,111,110,32,37,115,0
L499:
	.byte 110,111,32,109,97,116,99,104
	.byte 32,37,115,10,0
L739:
	.byte 32,62,62,62,32,0
L21:
	.byte 48,0
L430:
	.byte 116,114,121,105,110,103,32,116
	.byte 111,32,97,99,99,101,115,115
	.byte 32,111,117,116,32,111,102,32
	.byte 114,97,110,103,101,32,102,105
	.byte 101,108,100,32,37,100,0
L97:
	.byte 111,112,101,110,105,110,103,32
	.byte 102,105,108,101,32,37,115,10
	.byte 0
L285:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,102,111,114
	.byte 32,102,105,101,108,100,115,32
	.byte 105,110,32,102,108,100,98,108
	.byte 100,32,37,100,0
L535:
	.byte 114,101,99,98,108,100,32,51
	.byte 0
L527:
	.byte 114,101,99,98,108,100,32,50
	.byte 0
L109:
	.byte 99,97,110,39,116,32,111,112
	.byte 101,110,32,102,105,108,101,32
	.byte 37,115,0
L657:
	.byte 32,115,111,117,114,99,101,32
	.byte 108,105,110,101,32,110,117,109
	.byte 98,101,114,32,37,100,0
L450:
	.byte 111,117,116,32,111,102,32,115
	.byte 112,97,99,101,32,99,114,101
	.byte 97,116,105,110,103,32,37,100
	.byte 32,102,105,101,108,100,115,0
.globl _record
.comm _record, 8, 8
.globl _donefld
.comm _donefld, 4, 4
.globl _donerec
.comm _donerec, 4, 4
.globl _fields
.comm _fields, 8, 8
.globl _fldtab
.comm _fldtab, 8, 8

.globl _fldbld
.globl _inputFS
.globl _free
.globl _errno
.globl _patbeg
.globl _fieldadr
.globl _cursource
.globl _sprintf
.globl _FS
.globl ___fillbuf
.globl _ebuf
.globl _realloc
.globl _NF
.globl _getargv
.globl _strncpy
.globl _fields
.globl _getsval
.globl _error
.globl _setfval
.globl _fopen
.globl _curnode
.globl _dbg
.globl ___stdout
.globl _cmdname
.globl _donefld
.globl _malloc
.globl _ARGC
.globl _bclass
.globl _refldbld
.globl _eprint
.globl _SYNTAX
.globl _adjbuf
.globl _is_number
.globl _nfloc
.globl _record
.globl _growfldtab
.globl _bcheck2
.globl _abort
.globl _errorflag
.globl _strtod
.globl _setsymtab
.globl _nrloc
.globl _curfname
.globl _lineno
.globl _isclvar
.globl _printf
.globl _fpecatch
.globl _argno
.globl _infile
.globl _tostring
.globl _FNR
.globl _OFS
.globl _RS
.globl _patlen
.globl _fflush
.globl _makefields
.globl _setclvar
.globl _strcmp
.globl ___flushbuf
.globl _fldtab
.globl _makedfa
.globl ___ctype
.globl _vfprintf
.globl _WARNING
.globl _symtab
.globl _FILENAME
.globl _recsize
.globl _errcheck
.globl ___stderr
.globl _bracecnt
.globl ___stdin
.globl _cleanfld
.globl _fclose
.globl _lastfld
.globl ___huge_val
.globl _readrec
.globl _nextfile
.globl _recinit
.globl _compile_time
.globl _input
.globl _lookup
.globl _ep
.globl _ARGVtab
.globl _file
.globl _bracecheck
.globl _initgetrec
.globl _yyerror
.globl _getrec
.globl _fnrloc
.globl _nfields
.globl _NR
.globl _strlen
.globl _donerec
.globl _exit
.globl _fieldssize
.globl _FATAL
.globl _strcpy
.globl _parencnt
.globl _newfld
.globl _setsval
.globl _fprintf
.globl _recbld
.globl _ungetc
.globl _brackcnt
.globl _qstring
.globl _nematch
.globl _atof
