.data
_man:
	.byte 109,114,120,116,100,112,113,0
_opt:
	.byte 117,118,110,98,97,105,108,0
.align 4
_signum:
	.int 1
	.int 2
	.int 3
	.int 0
_tmpnam:
	.byte 47,116,109,112,47,97,114,88
	.byte 88,88,88,88,88,0
_tmp1nam:
	.byte 47,116,109,112,47,97,114,88
	.byte 88,88,88,88,88,0
_tmp2nam:
	.byte 47,116,109,112,47,97,114,88
	.byte 88,88,88,88,88,0
.local L4
.comm L4, 29, 1
.text

_getdir:
L1:
L2:
	movl $56,%edx
	movl $_arbuf,%esi
	movl _af(%rip),%edi
	call _read
	cmpl $56,%eax
	jnz L5
L7:
	xorl %ecx,%ecx
L13:
	movb _arbuf(%rcx),%al
	movb %al,L4(%rcx)
	incl %ecx
	cmpl $28,%ecx
	jl L13
L15:
	movq $L4,_file(%rip)
	xorl %eax,%eax
	ret
L5:
	cmpq $0,_tf1nam(%rip)
	jz L10
L8:
	movl _tf(%rip),%ecx
	movl _tf1(%rip),%eax
	movl %eax,_tf(%rip)
	movl %ecx,_tf1(%rip)
L10:
	movl $1,%eax
L3:
	ret 


_morefil:
L17:
L18:
	xorl %eax,%eax
	xorl %edx,%edx
	jmp L20
L21:
	movq _namv(%rip),%rcx
	cmpq $0,(%rcx,%rdx,8)
	jz L26
L24:
	incl %eax
L26:
	incl %edx
L20:
	cmpl _namc(%rip),%edx
	jl L21
L19:
	ret 


_stats:
L28:
	pushq %rbx
L29:
	pushq $0
	pushq _file(%rip)
	call _open
	addq $16,%rsp
	movl %eax,%ebx
	cmpl $0,%eax
	jl L30
L33:
	movl $_stbuf,%esi
	movl %ebx,%edi
	call _fstat
	cmpl $0,%eax
	jl L35
L37:
	movl %ebx,%eax
	jmp L30
L35:
	movl %ebx,%edi
	call _close
	movl $-1,%eax
L30:
	popq %rbx
	ret 


_trim:
L40:
L41:
	movq %rdi,%rax
	movq %rax,%rsi
L43:
	cmpb $0,(%rsi)
	jnz L44
	jz L47
L48:
	leaq -1(%rsi),%rdx
	movb -1(%rsi),%cl
	movq %rdx,%rsi
	cmpb $47,%cl
	jnz L49
L52:
	movb $0,(%rdx)
L47:
	cmpq %rsi,%rax
	jb L48
L49:
	movq %rax,%rdx
	jmp L54
L55:
	cmpb $47,%cl
	jnz L60
L58:
	leaq 1(%rdx),%rax
L60:
	incq %rdx
L54:
	movb (%rdx),%cl
	testb %cl,%cl
	jnz L55
L42:
	ret 
L44:
	incq %rsi
	jmp L43


_mesg:
L62:
L63:
	movb _flg+21(%rip),%al
	testb %al,%al
	jz L64
L65:
	cmpl $99,%edi
	jnz L68
L71:
	cmpb $1,%al
	jle L64
L68:
	pushq _file(%rip)
	pushq %rdi
	pushq $L75
	call _printf
	addq $24,%rsp
L64:
	ret 


_done:
L76:
	pushq %rbx
L77:
	movq _tfnam(%rip),%rax
	movl %edi,%ebx
	testq %rax,%rax
	jz L81
L79:
	movq %rax,%rdi
	call _unlink
L81:
	movq _tf1nam(%rip),%rdi
	testq %rdi,%rdi
	jz L84
L82:
	call _unlink
L84:
	movq _tf2nam(%rip),%rdi
	testq %rdi,%rdi
	jz L87
L85:
	call _unlink
L87:
	movl %ebx,%edi
	call _exit
L78:
	popq %rbx
	ret 


_wrerr:
L88:
L89:
	movl $L91,%edi
	call _perror
	movl $1,%edi
	call _done
L90:
	ret 


_usage:
L92:
L93:
	pushq $_man
	pushq $_opt
	pushq $L95
	call _printf
	addq $24,%rsp
	movl $1,%edi
	call _done
L94:
	ret 


_sigdone:
L96:
L97:
	movl $100,%edi
	call _done
L98:
	ret 


_getaf:
L99:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
L100:
	movl %edi,%ebx
	pushq $0
	pushq _arnam(%rip)
	call _open
	addq $16,%rsp
	movl %eax,_af(%rip)
	cmpl $0,%eax
	jge L104
L102:
	testl %ebx,%ebx
	jz L106
L105:
	pushq _arnam(%rip)
	pushq $L108
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _done
L104:
	movl $8,%edx
	leaq -8(%rbp),%rsi
	movl _af(%rip),%edi
	call _read
	cmpq $8,%rax
	jnz L110
L113:
	movq $4356213840513474878,%rax
	cmpq %rax,-8(%rbp)
	jz L112
L110:
	pushq _arnam(%rip)
	pushq $L117
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _done
L112:
	xorl %eax,%eax
	jmp L101
L106:
	movl $1,%eax
L101:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
L122:
	.quad 4356213840513474878
.text

_init:
L119:
L120:
	movl $_tmpnam,%edi
	call _mktemp
	movq %rax,_tfnam(%rip)
	movl $384,%esi
	movq %rax,%rdi
	call _creat
	movl %eax,%edi
	call _close
	pushq $2
	pushq _tfnam(%rip)
	call _open
	addq $16,%rsp
	movl %eax,_tf(%rip)
	cmpl $0,%eax
	jge L125
L123:
	pushq $L126
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $1,%edi
	call _done
L125:
	movl $8,%edx
	movl $L122,%esi
	movl _tf(%rip),%edi
	call _write
	cmpq $8,%rax
	jz L121
L127:
	call _wrerr
L121:
	ret 


_bamatch:
L130:
L131:
	movl _bastate(%rip),%eax
	cmpl $1,%eax
	jz L136
L152:
	cmpl $2,%eax
	jz L145
	ret
L136:
	movq _file(%rip),%rdi
	movq _ponam(%rip),%rsi
	call _strcmp
	testl %eax,%eax
	jnz L132
L139:
	movl $2,_bastate(%rip)
	cmpb $0,_flg(%rip)
	jnz L132
L145:
	movl $0,_bastate(%rip)
	movl $_tmp1nam,%edi
	call _mktemp
	movq %rax,_tf1nam(%rip)
	movl $384,%esi
	movq %rax,%rdi
	call _creat
	movl %eax,%edi
	call _close
	pushq $2
	pushq _tf1nam(%rip)
	call _open
	addq $16,%rsp
	cmpl $0,%eax
	jl L146
L148:
	movl _tf(%rip),%ecx
	movl %ecx,_tf1(%rip)
	movl %eax,_tf(%rip)
	ret
L146:
	pushq $L149
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L132:
	ret 


_copyfil:
L155:
	pushq %rbp
	movq %rsp,%rbp
	subq $4104,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L156:
	movl %edi,-4100(%rbp) # spill
	movl %esi,%r13d
	movl %edx,%r12d
	testl $8,%r12d
	jz L160
L158:
	movl $56,%edx
	movl $_arbuf,%esi
	movl %r13d,%edi
	call _write
	cmpq $56,%rax
	jz L160
L161:
	call _wrerr
L160:
	xorl %ebx,%ebx
	jmp L164
L165:
	movl $4096,%r14d
	movl $4096,%r15d
	cmpq $4096,%rdx
	jge L169
L167:
	movl %edx,%r14d
	movl %edx,%r15d
	movl %edx,%ecx
	andl $7,%ecx
	jz L169
L170:
	movl $8,%eax
	subl %ecx,%eax
	testl $2,%r12d
	jz L175
L173:
	leal (%rdx,%rax),%r15d
L175:
	testl $4,%r12d
	jz L169
L176:
	leal (%rdx,%rax),%r14d
L169:
	movslq %r15d,%r15
	movq %r15,%rdx
	leaq -4096(%rbp),%rsi
	movl -4100(%rbp),%edi # spill
	call _read
	cmpq %rax,%r15
	jz L181
L179:
	incl %ebx
L181:
	testl $1,%r12d
	jnz L184
L182:
	movslq %r14d,%r14
	movq %r14,%rdx
	leaq -4096(%rbp),%rsi
	movl %r13d,%edi
	call _write
	cmpq %rax,%r14
	jz L184
L185:
	call _wrerr
L184:
	subq $4096,_arbuf+48(%rip)
L164:
	movq _arbuf+48(%rip),%rdx
	cmpq $0,%rdx
	jg L165
L166:
	testl %ebx,%ebx
	jz L157
L188:
	pushq _file(%rip)
	pushq $L191
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L157:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_install0:
L192:
	pushq %rbp
	movq %rsp,%rbp
	subq $4096,%rsp
	pushq %rbx
	pushq %r12
L193:
	movl %esi,%r12d
	testq %rdi,%rdi
	jz L194
L195:
	xorl %edx,%edx
	xorl %esi,%esi
	movl %r12d,%edi
	call _lseek
L198:
	movl $4096,%edx
	leaq -4096(%rbp),%rsi
	movl %r12d,%edi
	call _read
	cmpl $0,%eax
	jle L194
L199:
	movslq %eax,%rbx
	movq %rbx,%rdx
	leaq -4096(%rbp),%rsi
	movl _af(%rip),%edi
	call _write
	cmpq %rax,%rbx
	jz L198
L201:
	call _wrerr
	jmp L198
L194:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_install:
L204:
	pushq %rbx
L205:
	xorl %ebx,%ebx
	jmp L207
L208:
	movl $1,%esi
	call _signal
	incl %ebx
L207:
	movl _signum(,%rbx,4),%edi
	testl %edi,%edi
	jnz L208
L210:
	cmpl $0,_af(%rip)
	jge L213
L211:
	cmpb $0,_flg+2(%rip)
	jnz L213
L214:
	pushq _arnam(%rip)
	pushq $L217
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L213:
	movl _af(%rip),%edi
	call _close
	movl $438,%esi
	movq _arnam(%rip),%rdi
	call _creat
	movl %eax,_af(%rip)
	cmpl $0,%eax
	jge L220
L218:
	pushq _arnam(%rip)
	pushq $L221
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _done
L220:
	movq _tfnam(%rip),%rdi
	movl _tf(%rip),%esi
	call _install0
	movq _tf2nam(%rip),%rdi
	movl _tf2(%rip),%esi
	call _install0
	movq _tf1nam(%rip),%rdi
	movl _tf1(%rip),%esi
	call _install0
L206:
	popq %rbx
	ret 


_movefil:
L222:
	pushq %rbx
L223:
	movl %edi,%ebx
	movq _file(%rip),%rdi
	call _trim
	xorl %ecx,%ecx
L226:
	movb (%rax),%dl
	movb %dl,_arbuf(%rcx)
	testb %dl,%dl
	jz L231
L229:
	incq %rax
L231:
	incl %ecx
	cmpl $28,%ecx
	jl L226
L228:
	movq _stbuf+48(%rip),%rax
	movq %rax,_arbuf+48(%rip)
	movq _stbuf+88(%rip),%rax
	movq %rax,_arbuf+40(%rip)
	movl _stbuf+28(%rip),%eax
	movl %eax,_arbuf+28(%rip)
	movl _stbuf+32(%rip),%eax
	movl %eax,_arbuf+32(%rip)
	movl _stbuf+24(%rip),%eax
	movl %eax,_arbuf+36(%rip)
	movl $12,%edx
	movl _tf(%rip),%esi
	movl %ebx,%edi
	call _copyfil
	movl %ebx,%edi
	call _close
L224:
	popq %rbx
	ret 


_match:
L232:
	pushq %rbx
L233:
	xorl %ebx,%ebx
L235:
	cmpl _namc(%rip),%ebx
	jge L238
L236:
	movq _namv(%rip),%rax
	movq (%rax,%rbx,8),%rdi
	testq %rdi,%rdi
	jz L237
L241:
	call _trim
	movq _file(%rip),%rsi
	movq %rax,%rdi
	call _strcmp
	testl %eax,%eax
	jz L243
L237:
	incl %ebx
	jmp L235
L243:
	movq _namv(%rip),%rcx
	movq (%rcx,%rbx,8),%rax
	movq %rax,_file(%rip)
	movq $0,(%rcx,%rbx,8)
	movl $1,%eax
	jmp L234
L238:
	xorl %eax,%eax
L234:
	popq %rbx
	ret 


_rcmd:
L248:
	pushq %rbx
L249:
	call _init
	xorl %edi,%edi
	call _getaf
L251:
	call _getdir
	testl %eax,%eax
	jnz L253
L252:
	call _bamatch
	cmpl $0,_namc(%rip)
	jz L254
L257:
	call _match
	testl %eax,%eax
	jz L268
L254:
	call _stats
	movl %eax,%ebx
	cmpl $0,%ebx
	jl L261
L263:
	cmpb $0,_flg+20(%rip)
	jz L272
L270:
	movq _stbuf+88(%rip),%rax
	cmpq _arbuf+40(%rip),%rax
	jle L273
L272:
	movl $114,%edi
	call _mesg
	movl $3,%edx
	movl $-1,%esi
	movl _af(%rip),%edi
	call _copyfil
	movl %ebx,%edi
	call _movefil
	jmp L251
L273:
	movl %ebx,%edi
	call _close
	jmp L268
L261:
	cmpl $0,_namc(%rip)
	jz L268
L264:
	pushq _file(%rip)
	pushq $L267
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L268:
	movl $99,%edi
	call _mesg
	movl _af(%rip),%edi
	movl $14,%edx
	movl _tf(%rip),%esi
	call _copyfil
	jmp L251
L253:
	xorl %ebx,%ebx
	jmp L278
L279:
	movq _namv(%rip),%rcx
	movq (%rcx,%rbx,8),%rax
	movq %rax,_file(%rip)
	testq %rax,%rax
	jz L280
L284:
	movq $0,(%rcx,%rbx,8)
	movl $97,%edi
	call _mesg
	call _stats
	movl %eax,%edi
	cmpl $0,%edi
	jl L286
L288:
	call _movefil
	jmp L280
L286:
	pushq _file(%rip)
	pushq $L289
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L280:
	incl %ebx
L278:
	cmpl %ebx,_namc(%rip)
	jg L279
L281:
	call _install
L250:
	popq %rbx
	ret 


_dcmd:
L291:
L292:
	call _init
	movl $1,%edi
	call _getaf
	jmp L294
L295:
	call _match
	testl %eax,%eax
	jz L298
L297:
	movl $100,%edi
	call _mesg
	movl _af(%rip),%edi
	movl $3,%edx
	movl $-1,%esi
	jmp L300
L298:
	movl $99,%edi
	call _mesg
	movl _af(%rip),%edi
	movl $14,%edx
	movl _tf(%rip),%esi
L300:
	call _copyfil
L294:
	call _getdir
	testl %eax,%eax
	jz L295
L296:
	call _install
L293:
	ret 


_xcmd:
L301:
	pushq %rbx
L302:
	movl $1,%edi
	call _getaf
L304:
	call _getdir
	testl %eax,%eax
	jnz L303
L305:
	cmpl $0,_namc(%rip)
	jz L307
L310:
	call _match
	testl %eax,%eax
	jz L318
L307:
	movl _arbuf+36(%rip),%esi
	andl $511,%esi
	movq _file(%rip),%rdi
	call _creat
	movl %eax,%ebx
	cmpl $0,%eax
	jl L314
L316:
	movl $120,%edi
	call _mesg
	movl $2,%edx
	movl %ebx,%esi
	movl _af(%rip),%edi
	call _copyfil
	movl %ebx,%edi
	call _close
	jmp L304
L314:
	pushq _file(%rip)
	pushq $L317
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L318:
	movl $99,%edi
	call _mesg
	movl $3,%edx
	movl $-1,%esi
	movl _af(%rip),%edi
	call _copyfil
	cmpl $0,_namc(%rip)
	jle L304
L324:
	call _morefil
	testl %eax,%eax
	jnz L304
L321:
	xorl %edi,%edi
	call _done
	jmp L304
L303:
	popq %rbx
	ret 


_pcmd:
L328:
L329:
	movl $1,%edi
	call _getaf
	jmp L331
L332:
	cmpl $0,_namc(%rip)
	jz L334
L337:
	call _match
	testl %eax,%eax
	jz L335
L334:
	cmpb $0,_flg+21(%rip)
	jz L343
L341:
	pushq _file(%rip)
	pushq $L344
	call _printf
	addq $16,%rsp
	movl $___stdout,%edi
	call _fflush
L343:
	movl _af(%rip),%edi
	movl $2,%edx
	movl $1,%esi
	jmp L345
L335:
	movl _af(%rip),%edi
	movl $3,%edx
	movl $-1,%esi
L345:
	call _copyfil
L331:
	call _getdir
	testl %eax,%eax
	jz L332
L330:
	ret 


_mcmd:
L346:
L347:
	call _init
	movl $1,%edi
	call _getaf
	movl $_tmp2nam,%edi
	call _mktemp
	movq %rax,_tf2nam(%rip)
	movl $384,%esi
	movq %rax,%rdi
	call _creat
	movl %eax,%edi
	call _close
	pushq $2
	pushq _tf2nam(%rip)
	call _open
	addq $16,%rsp
	movl %eax,_tf2(%rip)
	cmpl $0,%eax
	jge L353
L349:
	pushq $L352
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $1,%edi
	call _done
	jmp L353
L354:
	call _bamatch
	call _match
	testl %eax,%eax
	jnz L356
L358:
	movl $99,%edi
	call _mesg
	movl _af(%rip),%edi
	movl $14,%edx
	movl _tf(%rip),%esi
	jmp L360
L356:
	movl $109,%edi
	call _mesg
	movl _tf2(%rip),%esi
	movl _af(%rip),%edi
	movl $14,%edx
L360:
	call _copyfil
L353:
	call _getdir
	testl %eax,%eax
	jz L354
L355:
	call _install
L348:
	ret 

.data
.align 4
_m1:
	.int 1
	.int 256
	.int 114
	.int 45
.align 4
_m2:
	.int 1
	.int 128
	.int 119
	.int 45
.align 4
_m3:
	.int 2
	.int 2048
	.int 115
	.int 64
	.int 120
	.int 45
.align 4
_m4:
	.int 1
	.int 32
	.int 114
	.int 45
.align 4
_m5:
	.int 1
	.int 16
	.int 119
	.int 45
.align 4
_m6:
	.int 2
	.int 1024
	.int 115
	.int 8
	.int 120
	.int 45
.align 4
_m7:
	.int 1
	.int 4
	.int 114
	.int 45
.align 4
_m8:
	.int 1
	.int 2
	.int 119
	.int 45
.align 4
_m9:
	.int 2
	.int 512
	.int 116
	.int 1
	.int 120
	.int 45
.align 8
_m:
	.quad _m1
	.quad _m2
	.quad _m3
	.quad _m4
	.quad _m5
	.quad _m6
	.quad _m7
	.quad _m8
	.quad _m9
.text

_longt:
L361:
	pushq %rbx
L362:
	movl $_m,%ebx
L364:
	cmpq $_m+72,%rbx
	jae L367
L365:
	movq (%rbx),%rax
	addq $8,%rbx
	leaq 4(%rax),%rsi
	movl (%rax),%edx
	jmp L368
L371:
	movl _arbuf+36(%rip),%ecx
	movl (%rsi),%eax
	addq $4,%rsi
	testl %ecx,%eax
	jnz L370
L369:
	addq $4,%rsi
L368:
	decl %edx
	jns L371
L370:
	decl ___stdout(%rip)
	movl (%rsi),%edi
	js L376
L375:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb %dil,(%rcx)
	jmp L364
L376:
	movl $___stdout,%esi
	call ___flushbuf
	jmp L364
L367:
	movl $_arbuf+40,%edi
	call _ctime
	leaq 4(%rax),%rcx
	addq $20,%rax
	pushq %rax
	pushq %rcx
	pushq $L378
	call _printf
	movl _arbuf+28(%rip),%ecx
	movl _arbuf+32(%rip),%eax
	pushq %rax
	pushq %rcx
	pushq $L379
	call _printf
	pushq _arbuf+48(%rip)
	pushq $L380
	call _printf
	addq $64,%rsp
L363:
	popq %rbx
	ret 


_tcmd:
L381:
L382:
	movl $1,%edi
	call _getaf
	jmp L384
L385:
	cmpl $0,_namc(%rip)
	jz L387
L390:
	call _match
	testl %eax,%eax
	jz L389
L387:
	movq _file(%rip),%rdi
	call _trim
	pushq %rax
	pushq $28
	pushq $L394
	call _printf
	addq $24,%rsp
	cmpb $0,_flg+21(%rip)
	jz L397
L395:
	call _longt
L397:
	decl ___stdout(%rip)
	js L399
L398:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb $10,(%rcx)
	jmp L389
L399:
	movl $___stdout,%esi
	movl $10,%edi
	call ___flushbuf
L389:
	movl $3,%edx
	movl $-1,%esi
	movl _af(%rip),%edi
	call _copyfil
L384:
	call _getdir
	testl %eax,%eax
	jz L385
L383:
	ret 


_getqf:
L401:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L402:
	pushq $2
	pushq _arnam(%rip)
	call _open
	movl %eax,%edi
	addq $16,%rsp
	movl %edi,_qf(%rip)
	cmpl $0,%edi
	jge L405
L404:
	cmpb $0,_flg+2(%rip)
	jnz L409
L407:
	pushq _arnam(%rip)
	pushq $L217
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L409:
	movl $438,%esi
	movq _arnam(%rip),%rdi
	call _creat
	movl %eax,%edi
	call _close
	pushq $2
	pushq _arnam(%rip)
	call _open
	addq $16,%rsp
	movl %eax,_qf(%rip)
	cmpl $0,%eax
	jge L412
L410:
	pushq _arnam(%rip)
	pushq $L221
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _done
L412:
	movq $4356213840513474878,%rax
	movq %rax,-8(%rbp)
	movl $8,%edx
	leaq -8(%rbp),%rsi
	movl _qf(%rip),%edi
	call _write
	cmpq $8,%rax
	jz L403
L413:
	call _wrerr
	jmp L403
L405:
	movl $8,%edx
	leaq -8(%rbp),%rsi
	call _read
	cmpq $8,%rax
	jnz L420
L419:
	movq $4356213840513474878,%rax
	cmpq %rax,-8(%rbp)
	jz L403
L420:
	pushq _arnam(%rip)
	pushq $L117
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _done
L403:
	movq %rbp,%rsp
	popq %rbp
	ret 


_qcmd:
L423:
	pushq %rbx
L424:
	cmpb $0,_flg(%rip)
	jnz L426
L429:
	cmpb $0,_flg+1(%rip)
	jz L428
L426:
	pushq $L433
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $1,%edi
	call _done
L428:
	call _getqf
	xorl %ebx,%ebx
	jmp L434
L435:
	movl $1,%esi
	call _signal
	incl %ebx
L434:
	movl _signum(,%rbx,4),%edi
	testl %edi,%edi
	jnz L435
L437:
	movl $2,%edx
	xorl %esi,%esi
	movl _qf(%rip),%edi
	call _lseek
	xorl %ebx,%ebx
	jmp L438
L439:
	movq _namv(%rip),%rcx
	movq (%rcx,%rbx,8),%rax
	movq %rax,_file(%rip)
	testq %rax,%rax
	jz L440
L444:
	movq $0,(%rcx,%rbx,8)
	movl $113,%edi
	call _mesg
	call _stats
	movl %eax,%edi
	cmpl $0,%edi
	jge L447
L446:
	pushq _file(%rip)
	pushq $L289
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L440
L447:
	movl _qf(%rip),%eax
	movl %eax,_tf(%rip)
	call _movefil
	movl _tf(%rip),%eax
	movl %eax,_qf(%rip)
L440:
	incl %ebx
L438:
	cmpl _namc(%rip),%ebx
	jl L439
L425:
	popq %rbx
	ret 


_notfound:
L449:
	pushq %rbx
	pushq %r12
L450:
	xorl %r12d,%r12d
	xorl %ebx,%ebx
	jmp L452
L453:
	movq _namv(%rip),%rax
	movq (%rax,%rbx,8),%rax
	testq %rax,%rax
	jz L458
L456:
	pushq %rax
	pushq $L459
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	incl %r12d
L458:
	incl %ebx
L452:
	cmpl _namc(%rip),%ebx
	jl L453
L455:
	movl %r12d,%eax
L451:
	popq %r12
	popq %rbx
	ret 


_setcom:
L461:
	pushq %rbx
L462:
	movq %rdi,%rbx
	cmpq $0,_comfun(%rip)
	jz L466
L464:
	pushq $_man
	pushq $L467
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _done
L466:
	movq %rbx,_comfun(%rip)
L463:
	popq %rbx
	ret 

.align 2
L539:
	.short L495-_main
	.short L495-_main
	.short L495-_main
	.short L499-_main
	.short L485-_main
	.short L485-_main
	.short L485-_main
	.short L485-_main
	.short L495-_main
	.short L485-_main
	.short L485-_main
	.short L495-_main
	.short L507-_main
	.short L495-_main
	.short L485-_main
	.short L505-_main
	.short L509-_main
	.short L497-_main
	.short L485-_main
	.short L503-_main
	.short L495-_main
	.short L495-_main
	.short L485-_main
	.short L501-_main

_main:
L468:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L469:
	movl %edi,%r12d
	movq %rsi,%r14
	xorl %r13d,%r13d
	jmp L471
L472:
	movl $1,%esi
	call _signal
	cmpq $1,%rax
	jz L477
L475:
	movl $_sigdone,%esi
	movl _signum(,%r13,4),%edi
	call _signal
L477:
	incl %r13d
L471:
	movl _signum(,%r13,4),%edi
	testl %edi,%edi
	jnz L472
L474:
	cmpl $3,%r12d
	jge L480
L478:
	call _usage
L480:
	movq 8(%r14),%r13
	jmp L481
L482:
	cmpb $97,%cl
	jl L485
L538:
	cmpb $120,%cl
	jg L485
L536:
	leal -97(%rcx),%eax
	movzbl %al,%eax
	movzwl L539(,%rax,2),%eax
	addl $_main,%eax
	jmp *%rax
L501:
	movl $_xcmd,%edi
	jmp L540
L503:
	movl $_tcmd,%edi
	jmp L540
L497:
	movl $_rcmd,%edi
	jmp L540
L509:
	movl $_qcmd,%edi
	jmp L540
L505:
	movl $_pcmd,%edi
	jmp L540
L507:
	movl $_mcmd,%edi
	jmp L540
L499:
	movl $_dcmd,%edi
L540:
	call _setcom
	jmp L486
L495:
	movsbl %cl,%ecx
	subl $97,%ecx
	movslq %ecx,%rcx
	incb _flg(%rcx)
	jmp L486
L485:
	movsbl %cl,%ecx
	pushq %rcx
	pushq $L511
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _done
L486:
	incq %r13
L481:
	movb (%r13),%cl
	testb %cl,%cl
	jnz L482
L484:
	cmpb $0,_flg+11(%rip)
	jz L514
L512:
	movl $L515,%esi
	movl $_tmpnam,%edi
	call _strcpy
	movl $L515,%esi
	movl $_tmp1nam,%edi
	call _strcpy
	movl $L515,%esi
	movl $_tmp2nam,%edi
	call _strcpy
L514:
	cmpb $0,_flg+8(%rip)
	jz L518
L516:
	incb _flg+1(%rip)
L518:
	cmpb $0,_flg(%rip)
	jnz L523
L522:
	cmpb $0,_flg+1(%rip)
	jz L521
L523:
	movl $1,_bastate(%rip)
	movq 16(%r14),%rdi
	call _trim
	movq %rax,_ponam(%rip)
	addq $8,%r14
	decl %r12d
	cmpl $3,%r12d
	jge L521
L526:
	call _usage
L521:
	movq 16(%r14),%rax
	movq %rax,_arnam(%rip)
	addq $24,%r14
	movq %r14,_namv(%rip)
	subl $3,%r12d
	movl %r12d,_namc(%rip)
	cmpq $0,_comfun(%rip)
	jnz L531
L529:
	cmpb $0,_flg+20(%rip)
	jnz L534
L532:
	pushq $_man
	pushq $L535
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _done
L534:
	movl $_rcmd,%edi
	call _setcom
L531:
	movq _comfun(%rip),%rax
	call *%rax
	call _notfound
	movl %eax,%edi
	call _done
L470:
	movl %ebx,%eax
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L221:
	.byte 97,114,58,32,99,97,110,110
	.byte 111,116,32,99,114,101,97,116
	.byte 101,32,37,115,10,0
L394:
	.byte 37,45,42,115,0
L511:
	.byte 97,114,58,32,98,97,100,32
	.byte 111,112,116,105,111,110,32,96
	.byte 37,99,39,10,0
L126:
	.byte 97,114,58,32,99,97,110,110
	.byte 111,116,32,99,114,101,97,116
	.byte 101,32,116,101,109,112,32,102
	.byte 105,108,101,10,0
L75:
	.byte 37,99,32,45,32,37,115,10
	.byte 0
L289:
	.byte 97,114,58,32,37,115,32,99
	.byte 97,110,110,111,116,32,111,112
	.byte 101,110,10,0
L515:
	.byte 97,114,88,88,88,88,88,88
	.byte 0
L91:
	.byte 97,114,32,119,114,105,116,101
	.byte 32,101,114,114,111,114,0
L117:
	.byte 97,114,58,32,37,115,32,110
	.byte 111,116,32,105,110,32,97,114
	.byte 99,104,105,118,101,32,102,111
	.byte 114,109,97,116,10,0
L344:
	.byte 10,60,37,115,62,10,10,0
L108:
	.byte 97,114,58,32,37,115,32,100
	.byte 111,101,115,32,110,111,116,32
	.byte 101,120,105,115,116,10,0
L378:
	.byte 32,32,37,45,49,50,46,49
	.byte 50,115,32,37,45,52,46,52
	.byte 115,0
L149:
	.byte 97,114,58,32,99,97,110,110
	.byte 111,116,32,99,114,101,97,116
	.byte 101,32,115,101,99,111,110,100
	.byte 32,116,101,109,112,10,0
L433:
	.byte 97,114,58,32,97,98,105,32
	.byte 110,111,116,32,97,108,108,111
	.byte 119,101,100,32,119,105,116,104
	.byte 32,113,10,0
L380:
	.byte 32,32,37,108,100,0
L267:
	.byte 97,114,58,32,99,97,110,110
	.byte 111,116,32,111,112,101,110,32
	.byte 37,115,10,0
L467:
	.byte 97,114,58,32,111,110,108,121
	.byte 32,111,110,101,32,111,102,32
	.byte 91,37,115,93,32,97,108,108
	.byte 111,119,101,100,10,0
L459:
	.byte 97,114,58,32,37,115,32,110
	.byte 111,116,32,102,111,117,110,100
	.byte 10,0
L95:
	.byte 117,115,97,103,101,58,32,97
	.byte 114,32,91,37,115,93,91,37
	.byte 115,93,32,97,114,99,104,105
	.byte 118,101,32,102,105,108,101,115
	.byte 32,46,46,46,10,0
L352:
	.byte 97,114,58,32,99,97,110,110
	.byte 111,116,32,99,114,101,97,116
	.byte 101,32,116,104,105,114,100,32
	.byte 116,101,109,112,10,0
L535:
	.byte 97,114,58,32,111,110,101,32
	.byte 111,102,32,91,37,115,93,32
	.byte 109,117,115,116,32,98,101,32
	.byte 115,112,101,99,105,102,105,101
	.byte 100,10,0
L191:
	.byte 97,114,58,32,112,104,97,115
	.byte 101,32,101,114,114,111,114,32
	.byte 111,110,32,37,115,10,0
L317:
	.byte 97,114,58,32,37,115,32,99
	.byte 97,110,110,111,116,32,99,114
	.byte 101,97,116,101,10,0
L379:
	.byte 32,32,37,100,47,37,100,0
L217:
	.byte 97,114,58,32,99,114,101,97
	.byte 116,105,110,103,32,37,115,10
	.byte 0
.globl _flg
.comm _flg, 26, 1
.globl _namv
.comm _namv, 8, 8
.globl _namc
.comm _namc, 4, 4
.globl _tfnam
.comm _tfnam, 8, 8
.globl _tf
.comm _tf, 4, 4
.globl _tf1nam
.comm _tf1nam, 8, 8
.globl _tf1
.comm _tf1, 4, 4
.globl _tf2nam
.comm _tf2nam, 8, 8
.globl _tf2
.comm _tf2, 4, 4
.globl _arnam
.comm _arnam, 8, 8
.globl _af
.comm _af, 4, 4
.globl _ponam
.comm _ponam, 8, 8
.globl _file
.comm _file, 8, 8
.globl _qf
.comm _qf, 4, 4
.globl _arbuf
.comm _arbuf, 56, 8
.globl _stbuf
.comm _stbuf, 144, 8
.globl _bastate
.comm _bastate, 4, 4
.globl _comfun
.comm _comfun, 8, 8

.globl _pcmd
.globl _morefil
.globl _ponam
.globl _close
.globl _m2
.globl _rcmd
.globl _m3
.globl _tf
.globl _install0
.globl _sigdone
.globl _ctime
.globl _getqf
.globl _tmp2nam
.globl _getaf
.globl _bamatch
.globl _done
.globl _flg
.globl ___stdout
.globl _dcmd
.globl _opt
.globl _namc
.globl _mcmd
.globl _mktemp
.globl _tf2
.globl _arbuf
.globl _trim
.globl _stats
.globl _write
.globl _lseek
.globl _tf2nam
.globl _printf
.globl _m7
.globl _m6
.globl _tmpnam
.globl _m
.globl _fflush
.globl _tf1
.globl _copyfil
.globl _getdir
.globl _man
.globl _creat
.globl _longt
.globl _install
.globl _strcmp
.globl ___flushbuf
.globl _usage
.globl _tf1nam
.globl _xcmd
.globl _unlink
.globl _comfun
.globl _qf
.globl _signum
.globl _open
.globl _notfound
.globl _m4
.globl _af
.globl ___stderr
.globl _m5
.globl _perror
.globl _tfnam
.globl _bastate
.globl _stbuf
.globl _arnam
.globl _movefil
.globl _init
.globl _wrerr
.globl _tmp1nam
.globl _fstat
.globl _read
.globl _tcmd
.globl _file
.globl _m1
.globl _signal
.globl _qcmd
.globl _mesg
.globl _main
.globl _m8
.globl _exit
.globl _m9
.globl _match
.globl _strcpy
.globl _setcom
.globl _namv
.globl _fprintf
