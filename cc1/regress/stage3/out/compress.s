.data
_magic_header:
	.byte 31,157,0
.align 4
_maxbits:
	.int 16
.align 4
_maxmaxcode:
	.int 65536
.align 4
_hsize:
	.int 69001
.align 4
_free_ent:
	.int 0
.align 4
_exit_stat:
	.int 0
.text

_Usage:
L1:
L2:
	pushq $L4
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L3:
	ret 

.data
.align 4
_nomagic:
	.int 0
.align 4
_zcat_flg:
	.int 0
.align 4
_quiet:
	.int 0
.align 4
_block_compress:
	.int 128
.align 4
_clear_flg:
	.int 0
.align 8
_ratio:
	.quad 0
.align 8
_checkpoint:
	.quad 10000
.align 4
_force:
	.int 0
.align 4
_do_decomp:
	.int 0
.text

_main:
L5:
	pushq %rbp
	movq %rsp,%rbp
	subq $264,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L6:
	movl %edi,%r14d
	movq %rsi,%r13
	movl $0,-260(%rbp) # spill
	movl $1,%esi
	movl $2,%edi
	call _signal
	movq %rax,_bgnd_flag(%rip)
	cmpq $1,%rax
	jz L10
L8:
	movl $_onintr,%esi
	movl $2,%edi
	call _signal
	movl $_oops,%esi
	movl $11,%edi
	call _signal
L10:
	movslq %r14d,%rdi
	shlq $3,%rdi
	call _malloc
	movq %rax,%r12
	movq %r12,%rbx
	movq $0,(%r12)
	movl $47,%esi
	movq (%r13),%rdi
	call _strrchr
	testq %rax,%rax
	jz L12
L11:
	incq %rax
	movq %rax,%r15
	jmp L13
L12:
	movq (%r13),%r15
L13:
	movl $L17,%esi
	movq %r15,%rdi
	call _strcmp
	testl %eax,%eax
	jnz L15
L14:
	movl $1,_do_decomp(%rip)
	jmp L16
L15:
	movl $L21,%esi
	movq %r15,%rdi
	call _strcmp
	testl %eax,%eax
	jnz L16
L18:
	movl $1,_do_decomp(%rip)
	movl $1,_zcat_flg(%rip)
L16:
	xorl %ecx,%ecx
	movl $64,%edx
	xorl %esi,%esi
	movl $___stderr,%edi
	call _setvbuf
L258:
	decl %r14d
	addq $8,%r13
	cmpl $0,%r14d
	jle L25
L23:
	movq (%r13),%rax
	cmpb $45,(%rax)
	jnz L27
L29:
	movq (%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,(%r13)
	movb 1(%rcx),%al
	testb %al,%al
	jz L258
L30:
	cmpb $67,%al
	jz L46
L244:
	cmpb $70,%al
	jz L42
L245:
	cmpb $86,%al
	jz L35
L246:
	cmpb $98,%al
	jz L48
L247:
	cmpb $99,%al
	jz L63
L248:
	cmpb $100,%al
	jz L39
L249:
	cmpb $102,%al
	jz L42
L250:
	cmpb $110,%al
	jz L44
L251:
	cmpb $113,%al
	jz L65
L252:
	cmpb $118,%al
	jz L37
L253:
	movsbl %al,%eax
	pushq %rax
	pushq $L67
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	call _Usage
	movl $1,%edi
	call _exit
	jmp L29
L37:
	movl $0,_quiet(%rip)
	jmp L29
L65:
	movl $1,_quiet(%rip)
	jmp L29
L44:
	movl $1,_nomagic(%rip)
	jmp L29
L39:
	movl $1,_do_decomp(%rip)
	jmp L29
L63:
	movl $1,_zcat_flg(%rip)
	jmp L29
L48:
	leaq 2(%rcx),%rax
	movq %rax,(%r13)
	cmpb $0,2(%rcx)
	jnz L51
L52:
	decl %r14d
	jz L58
L56:
	leaq 8(%r13),%rcx
	movq 8(%r13),%rax
	movq %rcx,%r13
	testq %rax,%rax
	jnz L51
L58:
	pushq $L60
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	call _Usage
	movl $1,%edi
	call _exit
L51:
	movq (%r13),%rdi
	call _atoi
	movl %eax,_maxbits(%rip)
	jmp L258
L35:
	call _version
	jmp L29
L42:
	movl $1,-260(%rbp) # spill
	movl $1,_force(%rip)
	jmp L29
L46:
	movl $0,_block_compress(%rip)
	jmp L29
L27:
	movq %rax,(%rbx)
	addq $8,%rbx
	movq $0,(%rbx)
	jmp L258
L25:
	cmpl $9,_maxbits(%rip)
	jge L71
L69:
	movl $9,_maxbits(%rip)
L71:
	cmpl $16,_maxbits(%rip)
	jle L74
L72:
	movl $16,_maxbits(%rip)
L74:
	movb _maxbits(%rip),%cl
	movl $1,%eax
	shll %cl,%eax
	movl %eax,_maxmaxcode(%rip)
	cmpq $0,(%r12)
	jz L76
L78:
	cmpq $0,(%r12)
	jz L77
L79:
	movl $0,_exit_stat(%rip)
	movl _do_decomp(%rip),%eax
	movq (%r12),%rbx
	testl %eax,%eax
	jz L83
L82:
	movq %rbx,%rdi
	call _strlen
	movl $L88,%esi
	leaq -2(%rbx,%rax),%rdi
	call _strcmp
	testl %eax,%eax
	jz L87
L85:
	leaq -100(%rbp),%rbx
	movq (%r12),%rsi
	leaq -100(%rbp),%rdi
	call _strcpy
	movl $L88,%esi
	leaq -100(%rbp),%rdi
	call _strcat
	movq %rbx,(%r12)
L87:
	movl $___stdin,%edx
	movl $L92,%esi
	movq (%r12),%rdi
	call _freopen
	testq %rax,%rax
	jz L89
L91:
	cmpl $0,_nomagic(%rip)
	jnz L96
L94:
	decl ___stdin(%rip)
	js L105
L104:
	movq ___stdin+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdin+24(%rip)
	movzbl (%rcx),%ebx
	jmp L106
L105:
	movl $___stdin,%edi
	call ___fillbuf
	movl %eax,%ebx
L106:
	movzbl _magic_header(%rip),%eax
	cmpl %eax,%ebx
	jnz L101
L100:
	decl ___stdin(%rip)
	js L108
L107:
	movq ___stdin+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdin+24(%rip)
	movzbl (%rcx),%eax
	jmp L109
L108:
	movl $___stdin,%edi
	call ___fillbuf
L109:
	movl %eax,-256(%rbp) # spill
	movzbl _magic_header+1(%rip),%ecx
	cmpl %ecx,%eax
	jz L102
L101:
	movl -256(%rbp),%eax # spill
	pushq %rax
	pushq %rbx
	pushq (%r12)
	pushq $L110
	jmp L256
L102:
	decl ___stdin(%rip)
	js L113
L112:
	movq ___stdin+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdin+24(%rip)
	movzbl (%rcx),%eax
	jmp L114
L113:
	movl $___stdin,%edi
	call ___fillbuf
L114:
	movl %eax,%ecx
	andl $128,%ecx
	movl %ecx,_block_compress(%rip)
	andl $31,%eax
	movl %eax,_maxbits(%rip)
	movb %al,%cl
	movl $1,%edx
	shll %cl,%edx
	movl %edx,_maxmaxcode(%rip)
	cmpl $16,%eax
	jg L115
L96:
	movq (%r12),%rsi
	movl $_ofname,%edi
	call _strcpy
	movq (%r12),%rdi
	call _strlen
	movb $0,_ofname-2(%rax)
	jmp L84
L115:
	pushq $16
	pushq %rax
	pushq (%r12)
	pushq $L118
L256:
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	jmp L80
L89:
	movq (%r12),%rdi
	jmp L255
L83:
	movq %rbx,%rdi
	call _strlen
	movl $L88,%esi
	leaq -2(%rbx,%rax),%rdi
	call _strcmp
	movq (%r12),%rdi
	testl %eax,%eax
	jz L120
L122:
	movl $___stdin,%edx
	movl $L92,%esi
	call _freopen
	movq (%r12),%rdi
	testq %rax,%rax
	jz L255
L127:
	leaq -248(%rbp),%rsi
	call _stat
	movq -200(%rbp),%rax
	movq %rax,_fsize(%rip)
	movl $69001,_hsize(%rip)
	cmpq $4096,%rax
	jge L130
L129:
	movl $5003,_hsize(%rip)
	jmp L131
L130:
	cmpq $8192,%rax
	jge L133
L132:
	movl $9001,_hsize(%rip)
	jmp L131
L133:
	cmpq $16384,%rax
	jge L136
L135:
	movl $18013,_hsize(%rip)
	jmp L131
L136:
	cmpq $32768,%rax
	jge L139
L138:
	movl $35023,_hsize(%rip)
	jmp L131
L139:
	cmpq $47000,%rax
	jge L131
L141:
	movl $50021,_hsize(%rip)
L131:
	movq (%r12),%rsi
	movl $_ofname,%edi
	call _strcpy
	movl $47,%esi
	movl $_ofname,%edi
	call _strrchr
	testq %rax,%rax
	jz L145
L144:
	leaq 1(%rax),%rbx
	jmp L146
L145:
	movl $_ofname,%ebx
L146:
	movq %rbx,%rdi
	call _strlen
	cmpq $26,%rax
	ja L147
L149:
	movl $L88,%esi
	movl $_ofname,%edi
	call _strcat
L84:
	cmpl $0,-260(%rbp) # spill
	jnz L154
L155:
	cmpl $0,_zcat_flg(%rip)
	jnz L154
L156:
	leaq -248(%rbp),%rsi
	movl $_ofname,%edi
	call _stat
	testl %eax,%eax
	jnz L154
L159:
	movb $110,-250(%rbp)
	pushq $_ofname
	pushq $L162
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	call _foreground
	testl %eax,%eax
	jz L165
L163:
	pushq $0
	pushq $L166
	call _open
	movl %eax,%ebx
	pushq $_ofname
	pushq $L167
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movl $___stderr,%edi
	call _fflush
	movl $2,%edx
	leaq -250(%rbp),%rsi
	movl %ebx,%edi
	call _read
L168:
	cmpb $10,-249(%rbp)
	jz L170
L169:
	movl $1,%edx
	leaq -249(%rbp),%rsi
	movl %ebx,%edi
	call _read
	cmpq $0,%rax
	jge L168
L171:
	movl $L174,%edi
	call _perror
L170:
	movl %ebx,%edi
	call _close
L165:
	cmpb $121,-250(%rbp)
	jnz L176
L154:
	cmpl $0,_zcat_flg(%rip)
	jnz L183
L181:
	movl $___stdout,%edx
	movl $L187,%esi
	movl $_ofname,%edi
	call _freopen
	testq %rax,%rax
	jz L184
L186:
	cmpl $0,_quiet(%rip)
	jnz L183
L189:
	pushq (%r12)
	pushq $L192
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L183:
	cmpl $0,_do_decomp(%rip)
	jnz L194
L193:
	call _compress
	jmp L195
L194:
	call _decompress
L195:
	cmpl $0,_zcat_flg(%rip)
	jnz L80
L196:
	movl $_ofname,%esi
	movq (%r12),%rdi
	call _copystat
	cmpl $1,_exit_stat(%rip)
	jz L203
L202:
	cmpl $0,_quiet(%rip)
	jnz L80
L203:
	decl ___stderr(%rip)
	js L207
L206:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $10,(%rcx)
	jmp L80
L207:
	movl $___stderr,%esi
	movl $10,%edi
	call ___flushbuf
	jmp L80
L184:
	movl $_ofname,%edi
L255:
	call _perror
	jmp L80
L176:
	pushq $L179
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L80
L147:
	pushq %rbx
	pushq $L150
	jmp L257
L120:
	pushq %rdi
	pushq $L123
L257:
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L80:
	addq $8,%r12
	jmp L78
L76:
	cmpl $0,_do_decomp(%rip)
	jnz L210
L209:
	call _compress
	cmpl $0,_quiet(%rip)
	jnz L77
L212:
	decl ___stderr(%rip)
	js L216
L215:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $10,(%rcx)
	jmp L77
L216:
	movl $___stderr,%esi
	movl $10,%edi
	call ___flushbuf
	jmp L77
L210:
	cmpl $0,_nomagic(%rip)
	jnz L220
L218:
	decl ___stdin(%rip)
	js L229
L228:
	movq ___stdin+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdin+24(%rip)
	movzbl (%rcx),%eax
	jmp L230
L229:
	movl $___stdin,%edi
	call ___fillbuf
L230:
	movzbl _magic_header(%rip),%ecx
	cmpl %ecx,%eax
	jnz L225
L224:
	decl ___stdin(%rip)
	js L232
L231:
	movq ___stdin+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdin+24(%rip)
	movzbl (%rcx),%eax
	jmp L233
L232:
	movl $___stdin,%edi
	call ___fillbuf
L233:
	movzbl _magic_header+1(%rip),%ecx
	cmpl %ecx,%eax
	jz L223
L225:
	pushq $L234
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $1,%edi
	call _exit
L223:
	decl ___stdin(%rip)
	js L236
L235:
	movq ___stdin+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdin+24(%rip)
	movzbl (%rcx),%eax
	jmp L237
L236:
	movl $___stdin,%edi
	call ___fillbuf
L237:
	movl %eax,%ecx
	andl $128,%ecx
	movl %ecx,_block_compress(%rip)
	andl $31,%eax
	movl %eax,_maxbits(%rip)
	movb %al,%cl
	movl $1,%edx
	shll %cl,%edx
	movl %edx,_maxmaxcode(%rip)
	movq $100000,_fsize(%rip)
	cmpl $16,%eax
	jle L220
L238:
	pushq $16
	pushq %rax
	pushq $L241
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl $1,%edi
	call _exit
L220:
	call _decompress
L77:
	movl _exit_stat(%rip),%eax
L7:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
.align 8
_in_count:
	.quad 1
.align 8
_out_count:
	.quad 0
.text

_compress:
L259:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L260:
	cmpl $0,_nomagic(%rip)
	jnz L264
L262:
	decl ___stdout(%rip)
	movb _magic_header(%rip),%dil
	js L266
L265:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb %dil,(%rcx)
	jmp L267
L266:
	movzbl %dil,%edi
	movl $___stdout,%esi
	call ___flushbuf
L267:
	decl ___stdout(%rip)
	movb _magic_header+1(%rip),%dil
	js L269
L268:
	movq ___stdout+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb %dil,(%rcx)
	jmp L270
L269:
	movzbl %dil,%edi
	movl $___stdout,%esi
	call ___flushbuf
L270:
	decl ___stdout(%rip)
	movb _maxbits(%rip),%al
	movb _block_compress(%rip),%dil
	js L272
L271:
	movq ___stdout+24(%rip),%rcx
	orb %al,%dil
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb %dil,(%rcx)
	jmp L273
L272:
	orb %al,%dil
	movsbl %dil,%edi
	movl $___stdout,%esi
	call ___flushbuf
L273:
	testl $32,___stdout+8(%rip)
	jz L264
L274:
	call _writeerr
L264:
	movl $0,_offset(%rip)
	movq $3,_bytes_out(%rip)
	movq $0,_out_count(%rip)
	movl $0,_clear_flg(%rip)
	movq $0,_ratio(%rip)
	movq $1,_in_count(%rip)
	movq $10000,_checkpoint(%rip)
	movl $9,_n_bits(%rip)
	movl $511,_maxcode(%rip)
	cmpl $0,_block_compress(%rip)
	movl $256,%eax
	movl $257,%ecx
	cmovzl %eax,%ecx
	movl %ecx,_free_ent(%rip)
	decl ___stdin(%rip)
	js L281
L280:
	movq ___stdin+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdin+24(%rip)
	movzbl (%rcx),%r12d
	jmp L282
L281:
	movl $___stdin,%edi
	call ___fillbuf
	movl %eax,%r12d
L282:
	movslq _hsize(%rip),%rax
	xorl %ecx,%ecx
	jmp L283
L284:
	incl %ecx
	shlq $1,%rax
L283:
	cmpq $65536,%rax
	jl L284
L286:
	movl _hsize(%rip),%r15d
	movl $8,%eax
	subl %ecx,%eax
	movl %eax,-4(%rbp) # spill
	movslq %r15d,%rdi
	call _cl_hash
L287:
	decl ___stdin(%rip)
	js L291
L290:
	movq ___stdin+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stdin+24(%rip)
	movzbl (%rcx),%r14d
	jmp L292
L291:
	movl $___stdin,%edi
	call ___fillbuf
	movl %eax,%r14d
L292:
	cmpl $-1,%r14d
	jz L289
L288:
	incq _in_count(%rip)
	movslq %r14d,%r13
	movb _maxbits(%rip),%cl
	shlq %cl,%r13
	movslq %r12d,%r12
	addq %r12,%r13
	movb -4(%rbp),%cl # spill
	movl %r14d,%ebx
	shll %cl,%ebx
	xorl %r12d,%ebx
	movslq %ebx,%rcx
	movq _htab(,%rcx,8),%rax
	cmpq %rax,%r13
	jnz L294
L293:
	movzwl _codetab(,%rcx,2),%r12d
	jmp L287
L294:
	cmpq $0,%rax
	jl L300
L295:
	movl %r15d,%ecx
	subl %ebx,%ecx
	testl %ebx,%ebx
	movl $1,%eax
	cmovzl %eax,%ecx
L305:
	subl %ecx,%ebx
	jns L308
L306:
	addl %r15d,%ebx
L308:
	movslq %ebx,%rbx
	movq _htab(,%rbx,8),%rax
	cmpq %rax,%r13
	jz L309
L311:
	cmpq $0,%rax
	jg L305
L300:
	movl %r12d,%edi
	call _output
	incq _out_count(%rip)
	movl _free_ent(%rip),%ecx
	movl %r14d,%r12d
	cmpl _maxmaxcode(%rip),%ecx
	jge L318
L317:
	leal 1(%rcx),%eax
	movl %eax,_free_ent(%rip)
	movslq %ebx,%rax
	movw %cx,_codetab(,%rax,2)
	movq %r13,_htab(,%rax,8)
	jmp L287
L318:
	movq _in_count(%rip),%rax
	cmpq _checkpoint(%rip),%rax
	jl L287
L323:
	cmpl $0,_block_compress(%rip)
	jz L287
L324:
	call _cl_block
	jmp L287
L309:
	movzwl _codetab(,%rbx,2),%r12d
	jmp L287
L289:
	movl %r12d,%edi
	call _output
	incq _out_count(%rip)
	movl $-1,%edi
	call _output
	cmpl $0,_zcat_flg(%rip)
	jnz L329
L330:
	cmpl $0,_quiet(%rip)
	jnz L329
L331:
	pushq $L334
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq _bytes_out(%rip),%rax
	movq _in_count(%rip),%rdx
	movq %rdx,%rsi
	subq %rax,%rsi
	movl $___stderr,%edi
	call _prratio
L329:
	movq _bytes_out(%rip),%rax
	cmpq _in_count(%rip),%rax
	jle L261
L335:
	movl $2,_exit_stat(%rip)
L261:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

.data
_lmask:
	.byte 255
	.byte 254
	.byte 252
	.byte 248
	.byte 240
	.byte 224
	.byte 192
	.byte 128
	.byte 0
_rmask:
	.byte 0
	.byte 1
	.byte 3
	.byte 7
	.byte 15
	.byte 31
	.byte 63
	.byte 127
	.byte 255
.text

_output:
L339:
	pushq %rbx
	pushq %r12
L340:
	movl _offset(%rip),%edx
	movl _n_bits(%rip),%r10d
	cmpl $0,%edi
	jl L343
L342:
	movl %edx,%r9d
	sarl $3,%r9d
	movslq %r9d,%r9
	movb _buf(%r9),%cl
	andl $7,%edx
	movl %edx,%eax
	movb _rmask(%rax),%r8b
	andb %cl,%r8b
	movb %dl,%cl
	movb %dil,%sil
	shlb %cl,%sil
	movb _lmask(%rax),%al
	andb %sil,%al
	orb %r8b,%al
	movb %al,_buf(%r9)
	leaq _buf+1(%r9),%rsi
	movl $8,%eax
	subl %edx,%eax
	subl %eax,%r10d
	movb $8,%cl
	subb %dl,%cl
	sarl %cl,%edi
	cmpl $8,%r10d
	jl L347
L345:
	movb %dil,_buf+1(%r9)
	leaq _buf+2(%r9),%rsi
	sarl $8,%edi
	subl $8,%r10d
L347:
	testl %r10d,%r10d
	jz L350
L348:
	movb %dil,(%rsi)
L350:
	movl _offset(%rip),%ecx
	movl _n_bits(%rip),%r12d
	addl %r12d,%ecx
	movl %ecx,_offset(%rip)
	movl %r12d,%eax
	shll $3,%eax
	cmpl %eax,%ecx
	jnz L353
L351:
	movl $_buf,%ebx
	movslq %r12d,%rcx
	addq _bytes_out(%rip),%rcx
	movq %rcx,_bytes_out(%rip)
L354:
	decl ___stdout(%rip)
	leaq 1(%rbx),%rax
	js L358
L357:
	movb (%rbx),%dl
	movq ___stdout+24(%rip),%rcx
	movq %rax,%rbx
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb %dl,(%rcx)
	jmp L359
L358:
	movsbl (%rbx),%edi
	movq %rax,%rbx
	movl $___stdout,%esi
	call ___flushbuf
L359:
	decl %r12d
	jnz L354
L355:
	movl $0,_offset(%rip)
L353:
	movl _free_ent(%rip),%eax
	cmpl _maxcode(%rip),%eax
	jg L364
L363:
	cmpl $0,_clear_flg(%rip)
	jle L341
L364:
	cmpl $0,_offset(%rip)
	jle L369
L367:
	movslq _n_bits(%rip),%rdx
	movl $___stdout,%ecx
	movl $1,%esi
	movl $_buf,%edi
	call _fwrite
	movslq _n_bits(%rip),%rcx
	cmpq %rcx,%rax
	jz L372
L370:
	call _writeerr
L372:
	movslq _n_bits(%rip),%rax
	addq _bytes_out(%rip),%rax
	movq %rax,_bytes_out(%rip)
L369:
	movl $0,_offset(%rip)
	cmpl $0,_clear_flg(%rip)
	jz L374
L373:
	movl $9,_n_bits(%rip)
	movl $511,_maxcode(%rip)
	movl $0,_clear_flg(%rip)
	jmp L341
L374:
	movl _n_bits(%rip),%ecx
	incl %ecx
	movl %ecx,_n_bits(%rip)
	cmpl _maxbits(%rip),%ecx
	jnz L377
L376:
	movl _maxmaxcode(%rip),%eax
	jmp L385
L377:
	movl $1,%eax
	shll %cl,%eax
	decl %eax
L385:
	movl %eax,_maxcode(%rip)
	jmp L341
L343:
	cmpl $0,%edx
	jle L381
L379:
	addl $7,%edx
	movslq %edx,%rdx
	shrq $3,%rdx
	movl $___stdout,%ecx
	movl $1,%esi
	movl $_buf,%edi
	call _fwrite
L381:
	movl _offset(%rip),%eax
	movl $8,%ecx
	addl $7,%eax
	cltd 
	idivl %ecx
	movslq %eax,%rax
	addq _bytes_out(%rip),%rax
	movq %rax,_bytes_out(%rip)
	movl $0,_offset(%rip)
	movl $___stdout,%edi
	call _fflush
	testl $32,___stdout+8(%rip)
	jz L341
L382:
	call _writeerr
L341:
	popq %r12
	popq %rbx
	ret 


_decompress:
L386:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L387:
	movl $9,_n_bits(%rip)
	movl $511,_maxcode(%rip)
	movl $255,%eax
L390:
	movslq %eax,%rax
	movw $0,_codetab(,%rax,2)
	movb %al,_htab(%rax)
	decl %eax
	jns L390
L392:
	cmpl $0,_block_compress(%rip)
	movl $256,%eax
	movl $257,%ecx
	cmovzl %eax,%ecx
	movl %ecx,_free_ent(%rip)
	call _getcode
	movl %eax,%r14d
	movl %eax,%r13d
	cmpl $-1,%eax
	jz L388
L398:
	decl ___stdout(%rip)
	js L401
L400:
	movq ___stdout+24(%rip),%rdx
	leaq 1(%rdx),%rcx
	movq %rcx,___stdout+24(%rip)
	movb %al,(%rdx)
	jmp L402
L401:
	movsbl %al,%edi
	movl $___stdout,%esi
	call ___flushbuf
L402:
	testl $32,___stdout+8(%rip)
	jz L405
L403:
	call _writeerr
L405:
	movl $_htab+65536,%r12d
	jmp L406
L407:
	cmpl $256,%eax
	jnz L411
L412:
	cmpl $0,_block_compress(%rip)
	jz L411
L413:
	movl $255,%eax
L417:
	movslq %eax,%rax
	movw $0,_codetab(,%rax,2)
	decl %eax
	jns L417
L419:
	movl $1,_clear_flg(%rip)
	movl $256,_free_ent(%rip)
	call _getcode
	cmpl $-1,%eax
	jz L408
L411:
	movl %eax,%ebx
	cmpl _free_ent(%rip),%eax
	jl L427
L424:
	movb %r13b,(%r12)
	incq %r12
	movl %r14d,%eax
L427:
	movslq %eax,%rax
	leaq 1(%r12),%rcx
	movb _htab(%rax),%r13b
	cmpl $256,%eax
	jl L429
L428:
	movb %r13b,(%r12)
	movq %rcx,%r12
	movzwl _codetab(,%rax,2),%eax
	jmp L427
L429:
	movzbl %r13b,%r13d
	movb %r13b,(%r12)
	movq %rcx,%r12
L430:
	decl ___stdout(%rip)
	leaq -1(%r12),%rax
	movb -1(%r12),%dil
	js L434
L433:
	movq ___stdout+24(%rip),%rcx
	movq %rax,%r12
	leaq 1(%rcx),%rax
	movq %rax,___stdout+24(%rip)
	movb %dil,(%rcx)
	jmp L435
L434:
	movzbl %dil,%edi
	movq %rax,%r12
	movl $___stdout,%esi
	call ___flushbuf
L435:
	cmpq $_htab+65536,%r12
	ja L430
L431:
	movl _free_ent(%rip),%ecx
	cmpl _maxmaxcode(%rip),%ecx
	jge L438
L436:
	movslq %ecx,%rax
	movw %r14w,_codetab(,%rax,2)
	movb %r13b,_htab(%rax)
	incl %ecx
	movl %ecx,_free_ent(%rip)
L438:
	movl %ebx,%r14d
L406:
	call _getcode
	cmpl $-1,%eax
	jg L407
L408:
	movl $___stdout,%edi
	call _fflush
	testl $32,___stdout+8(%rip)
	jz L388
L439:
	call _writeerr
L388:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

.data
.align 4
L445:
	.int 0
.align 4
L446:
	.int 0
.local L447
.comm L447, 16, 1
.text

_getcode:
L442:
L443:
	movl _clear_flg(%rip),%edx
	cmpl $0,%edx
	jg L452
L455:
	movl L445(%rip),%eax
	cmpl L446(%rip),%eax
	jge L452
L457:
	movl _free_ent(%rip),%eax
	cmpl _maxcode(%rip),%eax
	jle L450
L452:
	movl _free_ent(%rip),%eax
	cmpl _maxcode(%rip),%eax
	jle L461
L459:
	movl _n_bits(%rip),%ecx
	incl %ecx
	movl %ecx,_n_bits(%rip)
	cmpl _maxbits(%rip),%ecx
	jnz L463
L462:
	movl _maxmaxcode(%rip),%eax
	jmp L476
L463:
	movl $1,%eax
	shll %cl,%eax
	decl %eax
L476:
	movl %eax,_maxcode(%rip)
L461:
	cmpl $0,%edx
	jle L467
L465:
	movl $9,_n_bits(%rip)
	movl $511,_maxcode(%rip)
	movl $0,_clear_flg(%rip)
L467:
	movslq _n_bits(%rip),%rdx
	movl $___stdin,%ecx
	movl $1,%esi
	movl $L447,%edi
	call _fread
	movl %eax,L446(%rip)
	cmpl $0,%eax
	jle L468
L470:
	movl $0,L445(%rip)
	shll $3,%eax
	movl _n_bits(%rip),%ecx
	decl %ecx
	subl %ecx,%eax
	movl %eax,L446(%rip)
L450:
	movl L445(%rip),%r10d
	movl _n_bits(%rip),%r9d
	movl %r10d,%r8d
	sarl $3,%r8d
	movslq %r8d,%r8
	movl %r10d,%edx
	andl $7,%edx
	movzbl L447(%r8),%edi
	leaq L447+1(%r8),%r11
	movb %dl,%cl
	sarl %cl,%edi
	movl %edi,%eax
	movl $8,%esi
	subl %edx,%esi
	movl %r9d,%edx
	subl %esi,%edx
	movl %esi,%ecx
	cmpl $8,%edx
	jl L474
L472:
	movzbl L447+1(%r8),%eax
	leaq L447+2(%r8),%r11
	movb %sil,%cl
	shll %cl,%eax
	orl %edi,%eax
	leal 8(%rsi),%ecx
	subl $8,%edx
L474:
	movb (%r11),%sil
	movslq %edx,%rdx
	movb _rmask(%rdx),%dl
	andb %sil,%dl
	movzbl %dl,%edx
	shll %cl,%edx
	orl %edx,%eax
	addl %r9d,%r10d
	movl %r10d,L445(%rip)
	ret
L468:
	movl $-1,%eax
L444:
	ret 


_writeerr:
L477:
L478:
	movl $_ofname,%edi
	call _perror
	movl $_ofname,%edi
	call _unlink
	movl $1,%edi
	call _exit
L479:
	ret 


_copystat:
L480:
	pushq %rbp
	movq %rsp,%rbp
	subq $160,%rsp
	pushq %rbx
	pushq %r12
L481:
	movq %rdi,%r12
	movq %rsi,%rbx
	movl $___stdout,%edi
	call _fflush
	movl ___stdout+4(%rip),%edi
	call _close
	leaq -144(%rbp),%rsi
	movq %r12,%rdi
	call _stat
	testl %eax,%eax
	jnz L483
L485:
	movl -120(%rbp),%esi
	movl %esi,%eax
	andl $61440,%eax
	cmpl $32768,%eax
	jz L488
L487:
	cmpl $0,_quiet(%rip)
	jz L492
L490:
	pushq %r12
	pushq $L192
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L492:
	pushq $L493
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L527
L488:
	cmpl $1,-128(%rbp)
	jbe L495
L494:
	cmpl $0,_quiet(%rip)
	jz L499
L497:
	pushq %r12
	pushq $L192
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L499:
	movl -128(%rbp),%eax
	decl %eax
	pushq %rax
	pushq $L500
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L527:
	movl $1,_exit_stat(%rip)
	jmp L489
L495:
	cmpl $2,_exit_stat(%rip)
	jnz L506
L504:
	cmpl $0,_force(%rip)
	jnz L506
L505:
	cmpl $0,_quiet(%rip)
	jnz L489
L508:
	pushq $L511
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L489:
	movq %rbx,%rdi
	call _unlink
	testl %eax,%eax
	jz L482
L524:
	movq %rbx,%rdi
	jmp L528
L506:
	movl $0,_exit_stat(%rip)
	andl $4095,%esi
	movq %rbx,%rdi
	call _chmod
	testl %eax,%eax
	jz L514
L512:
	movq %rbx,%rdi
	call _perror
L514:
	movl -116(%rbp),%esi
	movl -112(%rbp),%edx
	movq %rbx,%rdi
	call _chown
	movq -72(%rbp),%rax
	movq %rax,-160(%rbp)
	movq -56(%rbp),%rax
	movq %rax,-152(%rbp)
	leaq -160(%rbp),%rsi
	movq %rbx,%rdi
	call _utime
	cmpl $0,_quiet(%rip)
	jnz L482
L515:
	cmpl $0,_do_decomp(%rip)
	jnz L519
L518:
	pushq %rbx
	pushq $L521
	jmp L529
L519:
	pushq %rbx
	pushq $L522
L529:
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L482
L483:
	movq %r12,%rdi
L528:
	call _perror
L482:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_foreground:
L530:
L531:
	cmpq $0,_bgnd_flag(%rip)
	jnz L542
L534:
	movl $2,%edi
	call _isatty
	testl %eax,%eax
	jnz L537
L542:
	xorl %eax,%eax
	ret
L537:
	movl $1,%eax
L532:
	ret 


_onintr:
L543:
L544:
	movl $1,%esi
	movl $2,%edi
	call _signal
	movl $_ofname,%edi
	call _unlink
	movl $1,%edi
	call _exit
L545:
	ret 


_oops:
L546:
L547:
	movl $1,%esi
	movl $11,%edi
	call _signal
	cmpl $1,_do_decomp(%rip)
	jnz L551
L549:
	pushq $L552
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L551:
	movl $_ofname,%edi
	call _unlink
	movl $1,%edi
	call _exit
L548:
	ret 


_cl_block:
L553:
L554:
	movq _in_count(%rip),%rax
	leaq 10000(%rax),%rcx
	movq %rcx,_checkpoint(%rip)
	movq _bytes_out(%rip),%rcx
	cmpq $8388607,%rax
	jle L557
L556:
	sarq $8,%rcx
	jnz L565
L559:
	movl $2147483647,%eax
	jmp L558
L557:
	shlq $8,%rax
L565:
	cqto 
	idivq %rcx
L558:
	cmpq _ratio(%rip),%rax
	jle L563
L562:
	movq %rax,_ratio(%rip)
	ret
L563:
	movq $0,_ratio(%rip)
	movslq _hsize(%rip),%rdi
	call _cl_hash
	movl $257,_free_ent(%rip)
	movl $1,_clear_flg(%rip)
	movl $256,%edi
	call _output
L555:
	ret 


_cl_hash:
L566:
L567:
	leaq (,%rdi,8),%rdx
	movl $-1,%esi
	movl $_htab,%edi
	call _memset
L568:
	ret 


_prratio:
L569:
	pushq %rbx
	pushq %r12
L570:
	movq %rdi,%rbx
	movq %rdx,%rdi
	cmpq $214748,%rsi
	jle L573
L572:
	movl $10000,%ecx
	movq %rdi,%rax
	cqto 
	idivq %rcx
	movq %rax,%rcx
	movq %rsi,%rax
	cqto 
	idivq %rcx
	jmp L582
L573:
	imulq $10000,%rsi,%rax
	cqto 
	idivq %rdi
L582:
	movl %eax,%r12d
	cmpl $0,%r12d
	jge L577
L575:
	decl (%rbx)
	js L579
L578:
	movq 24(%rbx),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rbx)
	movb $45,(%rcx)
	jmp L580
L579:
	movq %rbx,%rsi
	movl $45,%edi
	call ___flushbuf
L580:
	negl %r12d
L577:
	movl $100,%ecx
	movl %r12d,%eax
	cltd 
	idivl %ecx
	movl %eax,%esi
	movl $100,%ecx
	movl %r12d,%eax
	cltd 
	idivl %ecx
	pushq $37
	pushq %rdx
	pushq %rsi
	pushq $L581
	pushq %rbx
	call _fprintf
	addq $40,%rsp
L571:
	popq %r12
	popq %rbx
	ret 


_version:
L583:
L584:
	pushq $L586
	pushq $___stderr
	call _fprintf
	pushq $L587
	pushq $___stderr
	call _fprintf
	pushq $16
	pushq $L588
	pushq $___stderr
	call _fprintf
	addq $56,%rsp
L585:
	ret 

L21:
	.byte 122,99,97,116,0
L162:
	.byte 37,115,32,97,108,114,101,97
	.byte 100,121,32,101,120,105,115,116
	.byte 115,59,0
L511:
	.byte 32,45,45,32,102,105,108,101
	.byte 32,117,110,99,104,97,110,103
	.byte 101,100,0
L174:
	.byte 115,116,100,101,114,114,0
L192:
	.byte 37,115,58,32,0
L234:
	.byte 115,116,100,105,110,58,32,110
	.byte 111,116,32,105,110,32,99,111
	.byte 109,112,114,101,115,115,101,100
	.byte 32,102,111,114,109,97,116,10
	.byte 0
L522:
	.byte 32,45,45,32,100,101,99,111
	.byte 109,112,114,101,115,115,101,100
	.byte 32,116,111,32,37,115,0
L167:
	.byte 32,100,111,32,121,111,117,32
	.byte 119,105,115,104,32,116,111,32
	.byte 111,118,101,114,119,114,105,116
	.byte 101,32,37,115,32,40,121,32
	.byte 111,114,32,110,41,63,32,0
L4:
	.byte 85,115,97,103,101,58,32,99
	.byte 111,109,112,114,101,115,115,32
	.byte 91,45,100,102,118,99,86,93
	.byte 32,91,45,98,32,109,97,120
	.byte 98,105,116,115,93,32,91,102
	.byte 105,108,101,32,46,46,46,93
	.byte 10,0
L123:
	.byte 37,115,58,32,97,108,114,101
	.byte 97,100,121,32,104,97,115,32
	.byte 46,90,32,115,117,102,102,105
	.byte 120,32,45,45,32,110,111,32
	.byte 99,104,97,110,103,101,10,0
L150:
	.byte 37,115,58,32,102,105,108,101
	.byte 110,97,109,101,32,116,111,111
	.byte 32,108,111,110,103,32,102,111
	.byte 114,32,46,90,10,0
L166:
	.byte 47,100,101,118,47,116,116,121
	.byte 0
L17:
	.byte 117,110,99,111,109,112,114,101
	.byte 115,115,0
L587:
	.byte 79,112,116,105,111,110,115,58
	.byte 32,0
L521:
	.byte 32,45,45,32,99,111,109,112
	.byte 114,101,115,115,101,100,32,116
	.byte 111,32,37,115,0
L60:
	.byte 77,105,115,115,105,110,103,32
	.byte 109,97,120,98,105,116,115,10
	.byte 0
L334:
	.byte 67,111,109,112,114,101,115,115
	.byte 105,111,110,58,32,0
L118:
	.byte 37,115,58,32,99,111,109,112
	.byte 114,101,115,115,101,100,32,119
	.byte 105,116,104,32,37,100,32,98
	.byte 105,116,115,44,32,99,97,110
	.byte 32,111,110,108,121,32,104,97
	.byte 110,100,108,101,32,37,100,32
	.byte 98,105,116,115,10,0
L92:
	.byte 114,0
L586:
	.byte 99,111,109,112,114,101,115,115
	.byte 32,52,46,49,10,0
L88:
	.byte 46,90,0
L581:
	.byte 37,100,46,37,48,50,100,37
	.byte 99,0
L187:
	.byte 119,0
L500:
	.byte 32,45,45,32,104,97,115,32
	.byte 37,100,32,111,116,104,101,114
	.byte 32,108,105,110,107,115,58,32
	.byte 117,110,99,104,97,110,103,101
	.byte 100,0
L67:
	.byte 85,110,107,110,111,119,110,32
	.byte 102,108,97,103,58,32,39,37
	.byte 99,39,59,32,0
L179:
	.byte 9,110,111,116,32,111,118,101
	.byte 114,119,114,105,116,116,101,110
	.byte 10,0
L493:
	.byte 32,45,45,32,110,111,116,32
	.byte 97,32,114,101,103,117,108,97
	.byte 114,32,102,105,108,101,58,32
	.byte 117,110,99,104,97,110,103,101
	.byte 100,0
L588:
	.byte 66,73,84,83,32,61,32,37
	.byte 100,10,0
L552:
	.byte 117,110,99,111,109,112,114,101
	.byte 115,115,58,32,99,111,114,114
	.byte 117,112,116,32,105,110,112,117
	.byte 116,10,0
L241:
	.byte 115,116,100,105,110,58,32,99
	.byte 111,109,112,114,101,115,115,101
	.byte 100,32,119,105,116,104,32,37
	.byte 100,32,98,105,116,115,44,32
	.byte 99,97,110,32,111,110,108,121
	.byte 32,104,97,110,100,108,101,32
	.byte 37,100,32,98,105,116,115,10
	.byte 0
L110:
	.byte 37,115,58,32,110,111,116,32
	.byte 105,110,32,99,111,109,112,114
	.byte 101,115,115,101,100,32,102,111
	.byte 114,109,97,116,32,37,120,32
	.byte 37,120,10,0
.globl _n_bits
.comm _n_bits, 4, 4
.globl _maxcode
.comm _maxcode, 4, 4
.globl _htab
.comm _htab, 552008, 8
.globl _codetab
.comm _codetab, 138002, 2
.globl _fsize
.comm _fsize, 8, 8
.globl _ofname
.comm _ofname, 100, 1
.globl _bgnd_flag
.comm _bgnd_flag, 8, 8
.local _offset
.comm _offset, 4, 4
.globl _bytes_out
.comm _bytes_out, 8, 8
.local _buf
.comm _buf, 16, 1

.globl _close
.globl _ratio
.globl _decompress
.globl _setvbuf
.globl ___fillbuf
.globl _bgnd_flag
.globl _writeerr
.globl _do_decomp
.globl _copystat
.globl ___stdout
.globl _malloc
.globl _force
.globl _stat
.globl _fread
.globl _onintr
.globl _magic_header
.globl _chown
.globl _checkpoint
.globl _cl_block
.globl _fsize
.globl _foreground
.globl _n_bits
.globl _version
.globl _lmask
.globl _oops
.globl _chmod
.globl _atoi
.globl _bytes_out
.globl _maxbits
.globl _in_count
.globl _cl_hash
.globl _free_ent
.globl _strcat
.globl _quiet
.globl _fflush
.globl _getcode
.globl _block_compress
.globl _prratio
.globl _exit_stat
.globl _strrchr
.globl _strcmp
.globl ___flushbuf
.globl _unlink
.globl _isatty
.globl _open
.globl ___stderr
.globl ___stdin
.globl _hsize
.globl _perror
.globl _out_count
.globl _ofname
.globl _clear_flg
.globl _codetab
.globl _rmask
.globl _Usage
.globl _read
.globl _memset
.globl _output
.globl _htab
.globl _maxcode
.globl _fwrite
.globl _compress
.globl _signal
.globl _nomagic
.globl _strlen
.globl _main
.globl _exit
.globl _strcpy
.globl _freopen
.globl _maxmaxcode
.globl _zcat_flg
.globl _utime
.globl _fprintf
