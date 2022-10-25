.data
.align 4
_childpid:
	.int 0
.text

_findrec:
L1:
L2:
	movq _ar_record(%rip),%rax
	cmpq _ar_last(%rip),%rax
	jnz L6
L4:
	cmpl $0,_eof(%rip)
	jnz L16
L9:
	call _flush_archive
	movq _ar_record(%rip),%rax
	cmpq _ar_last(%rip),%rax
	jz L11
L6:
	movq _ar_record(%rip),%rax
	ret
L11:
	incl _eof(%rip)
L16:
	xorl %eax,%eax
L3:
	ret 


_userec:
L17:
	jmp L20
L21:
	addq $512,%rax
	movq %rax,_ar_record(%rip)
L20:
	movq _ar_record(%rip),%rax
	cmpq %rax,%rdi
	jae L21
L22:
	cmpq _ar_last(%rip),%rax
	jbe L19
L23:
	call _abort
L19:
	ret 


_endofrecs:
L26:
L27:
	movq _ar_last(%rip),%rax
L28:
	ret 


_dupto:
L30:
	pushq %rbx
	pushq %r12
	pushq %r13
L31:
	movl %edi,%r13d
	movl %esi,%r12d
	movq %rdx,%rbx
	cmpl %r12d,%r13d
	jz L32
L33:
	movl %r12d,%edi
	call _close
	movl %r13d,%edi
	call _dup
	cmpl %eax,%r12d
	jz L38
L36:
	pushq $L39
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq %rbx,%rdi
	call _perror
	movl $4,%edi
	call _exit
L38:
	movl %r13d,%edi
	call _close
L32:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_child_open:
L40:
	pushq %rbp
	movq %rsp,%rbp
	subq $1152,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L41:
	movq %rdi,%r13
	movq %rsi,%r12
	leaq -8(%rbp),%rdi
	call _pipe
	cmpl $0,%eax
	jge L45
L43:
	movl $L46,%edi
	call _perror
	movl $4,%edi
	call _exit
L45:
	call _fork
	movl %eax,_childpid(%rip)
	cmpl $0,%eax
	jge L49
L47:
	movl $L50,%edi
	call _perror
	movl $4,%edi
	call _exit
L49:
	cmpl $0,_childpid(%rip)
	jg L51
L53:
	cmpb $0,_ar_reading(%rip)
	jz L59
L58:
	movl -8(%rbp),%edi
	call _close
	movl $L61,%edx
	movl $1,%esi
	movl -4(%rbp),%edi
	call _dupto
	testq %r13,%r13
	jz L63
L62:
	xorl %edi,%edi
	call _close
	pushq $0
	pushq $L68
	call _open
	addq $16,%rsp
	testl %eax,%eax
	jz L67
L65:
	movl $L69,%edi
	call _perror
L67:
	movl _blocking(%rip),%eax
	leaq -1008(%rbp),%rbx
	pushq %rax
	pushq %r12
	pushq %r13
	pushq $L70
	pushq %rbx
	call _sprintf
	addq $40,%rsp
	cmpb $0,_f_compress(%rip)
	jz L117
L71:
	movl $L74,%esi
	leaq -1008(%rbp),%rdi
	call _strcat
	jmp L117
L63:
	movl $L78,%edx
	xorl %esi,%esi
	movl _archive(%rip),%edi
	call _dupto
	leaq -1152(%rbp),%rsi
	xorl %edi,%edi
	call _fstat
	testl %eax,%eax
	jz L81
L79:
	movl $L82,%edi
	call _perror
	movl $4,%edi
	call _exit
L81:
	movl -1128(%rbp),%eax
	andl $61440,%eax
	cmpl $32768,%eax
	jnz L84
L83:
	pushq $0
	pushq $L87
	pushq $L86
	pushq $L86
	call _execlp
	addq $32,%rsp
	movl $L88,%edi
	jmp L113
L84:
	movl _blocking(%rip),%eax
	leaq -1008(%rbp),%rbx
	pushq %rax
	pushq $L89
	pushq %rbx
	call _sprintf
	addq $24,%rsp
L117:
	pushq $0
	pushq %rbx
	jmp L116
L59:
	movl -4(%rbp),%edi
	call _close
	movl $L78,%edx
	xorl %esi,%esi
	movl -8(%rbp),%edi
	call _dupto
	testq %r13,%r13
	jnz L92
L90:
	movl $L61,%edx
	movl $1,%esi
	movl _archive(%rip),%edi
	call _dupto
L92:
	leaq -1008(%rbp),%rbx
	movb $0,-1008(%rbp)
	cmpb $0,_f_compress(%rip)
	jz L95
L93:
	testq %r13,%r13
	jnz L98
L96:
	leaq -1152(%rbp),%rsi
	movl $1,%edi
	call _fstat
	testl %eax,%eax
	jz L101
L99:
	movl $L82,%edi
	call _perror
	movl $4,%edi
	call _exit
L101:
	movl -1128(%rbp),%eax
	andl $61440,%eax
	cmpl $32768,%eax
	jnz L98
L102:
	pushq $0
	pushq $L86
	pushq $L86
	call _execlp
	addq $24,%rsp
	movl $L88,%edi
	call _perror
L98:
	movl $L105,%esi
	leaq -1008(%rbp),%rdi
	call _strcat
L95:
	testq %r13,%r13
	jz L107
L106:
	leaq -1008(%rbp),%rdi
	call _strlen
	movl _blocking(%rip),%ecx
	leaq -1008(%rbp,%rax),%rax
	pushq %r12
	pushq %rcx
	pushq %r13
	pushq $L109
	pushq %rax
	call _sprintf
	addq $40,%rsp
	jmp L108
L107:
	leaq -1008(%rbp),%rdi
	call _strlen
	movl _blocking(%rip),%ecx
	leaq -1008(%rbp,%rax),%rax
	pushq %rcx
	pushq $L110
	pushq %rax
	call _sprintf
	addq $24,%rsp
L108:
	pushq $0
	pushq %rbx
L116:
	pushq $L76
	pushq $L75
	pushq $L75
	call _execlp
	addq $40,%rsp
	movl $L77,%edi
L113:
	call _perror
	movl $105,%edi
	call _exit
	jmp L42
L51:
	movl _archive(%rip),%edi
	call _close
	cmpb $0,_ar_reading(%rip)
	jz L55
L54:
	movl -4(%rbp),%edi
	call _close
	movl -8(%rbp),%eax
	movl %eax,_archive(%rip)
	incb _f_reblock(%rip)
	jmp L42
L55:
	movl -8(%rbp),%edi
	call _close
	movl -4(%rbp),%eax
	movl %eax,_archive(%rip)
L42:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_open_archive:
L118:
	pushq %rbx
	pushq %r12
	pushq %r13
L119:
	movl %edi,%r13d
	xorl %r12d,%r12d
	movl $58,%esi
	movq _ar_file(%rip),%rdi
	call _strchr
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L123
L121:
	movl $47,%esi
	movq _ar_file(%rip),%rdi
	call _strchr
	testq %rax,%rax
	jz L123
L127:
	cmpq %rax,%rbx
	jb L128
L123:
	movq _ar_file(%rip),%rdi
	cmpb $45,(%rdi)
	jnz L138
L136:
	cmpb $0,1(%rdi)
	jnz L138
L137:
	incb _f_reblock(%rip)
	testl %r13d,%r13d
	jz L141
L140:
	movl $0,_archive(%rip)
	jmp L135
L141:
	movl $1,_archive(%rip)
	jmp L135
L138:
	testl %r13d,%r13d
	jz L144
L143:
	pushq $0
	pushq %rdi
	call _open
	addq $16,%rsp
	jmp L167
L144:
	movl $438,%esi
	call _creat
L167:
	movl %eax,_archive(%rip)
L135:
	cmpl $0,_archive(%rip)
	jge L131
L146:
	movq _ar_file(%rip),%rdi
	call _perror
	movl $3,%edi
	call _exit
	jmp L131
L128:
	movq _ar_file(%rip),%r12
	movb $0,(%rbx)
L131:
	cmpl $0,_blocksize(%rip)
	jnz L151
L149:
	pushq $L152
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $1,%edi
	call _exit
L151:
	movl _blocksize(%rip),%edi
	call _malloc
	movq %rax,_ar_block(%rip)
	testq %rax,%rax
	jnz L155
L153:
	movl _blocking(%rip),%eax
	pushq %rax
	pushq $L156
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _exit
L155:
	movq _ar_block(%rip),%rcx
	movq %rcx,_ar_record(%rip)
	movslq _blocking(%rip),%rax
	shlq $9,%rax
	addq %rax,%rcx
	movq %rcx,_ar_last(%rip)
	movb %r13b,_ar_reading(%rip)
	cmpb $0,_f_compress(%rip)
	jnz L161
L160:
	testq %r12,%r12
	jz L159
L161:
	leaq 1(%rbx),%rsi
	movq %r12,%rdi
	call _child_open
L159:
	testl %r13d,%r13d
	jz L120
L164:
	movq _ar_block(%rip),%rax
	movq %rax,_ar_last(%rip)
	call _findrec
L120:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_saverec:
L168:
L169:
	movq %rdi,_save_rec(%rip)
	movq _ar_record(%rip),%rax
	movq _ar_block(%rip),%rcx
	movq _baserec(%rip),%rsi
	subq %rcx,%rax
	movl $512,%ecx
	cqto 
	idivq %rcx
	addq %rax,%rsi
	movq %rsi,_saved_recno(%rip)
L170:
	ret 


_fl_write:
L171:
L172:
	movslq _blocksize(%rip),%rdx
	movq _ar_block(%rip),%rsi
	movl _archive(%rip),%edi
	call _write
	movl _blocksize(%rip),%ecx
	cmpl %eax,%ecx
	jz L173
L176:
	movq _ar_file(%rip),%rdi
	cmpl $0,%eax
	jge L179
L178:
	call _perror
	jmp L180
L179:
	subl %eax,%ecx
	pushq %rcx
	pushq %rdi
	pushq $L181
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L180:
	movl $3,%edi
	call _exit
L173:
	ret 


_readerror:
L182:
L183:
	incb _read_error_flag(%rip)
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L185
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq _ar_file(%rip),%rdi
	call _perror
	cmpq $0,_baserec(%rip)
	jnz L188
L186:
	movl $3,%edi
	call _exit
L188:
	movl _r_error_count(%rip),%ecx
	leal 1(%rcx),%eax
	movl %eax,_r_error_count(%rip)
	cmpl $10,%ecx
	jle L184
L189:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L192
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $3,%edi
	call _exit
L184:
	ret 


_fl_read:
L194:
	pushq %rbx
	pushq %r12
	pushq %r13
L195:
	movl $0,_r_error_count(%rip)
	movq _save_rec(%rip),%rax
	testq %rax,%rax
	jz L208
L204:
	movq (%rax),%rsi
	cmpq _ar_record(%rip),%rsi
	jb L208
L205:
	cmpq _ar_last(%rip),%rsi
	jae L208
L201:
	movl $512,%ecx
	movl $_record_save_area,%edi
	rep 
	movsb 
	movq _save_rec(%rip),%rax
	movq $_record_save_area,(%rax)
L208:
	movslq _blocksize(%rip),%rdx
	movq _ar_block(%rip),%rsi
	movl _archive(%rip),%edi
	call _read
	movl _blocksize(%rip),%ebx
	movl %eax,%r12d
	cmpl %eax,%ebx
	jz L196
L211:
	cmpl $0,%eax
	jge L215
L213:
	call _readerror
	jmp L208
L215:
	movq _ar_block(%rip),%r13
	movslq %eax,%rax
	addq %rax,%r13
	subl %eax,%ebx
L217:
	testl $511,%ebx
	movb _f_reblock(%rip),%al
	jz L218
L220:
	testb %al,%al
	jz L244
L243:
	cmpl $0,%ebx
	jg L249
	jle L196
L250:
	call _readerror
L249:
	movslq %ebx,%rdx
	movq %r13,%rsi
	movl _archive(%rip),%edi
	call _read
	movl %eax,%r12d
	cmpl $0,%r12d
	jl L250
	jg L256
L254:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq _ar_file(%rip)
	pushq $L257
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $3,%edi
	call _exit
L256:
	subl %r12d,%ebx
	movslq %r12d,%rax
	addq %rax,%r13
	jmp L217
L244:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq %r12
	pushq _ar_file(%rip)
	pushq $L259
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl $3,%edi
	call _exit
	jmp L196
L218:
	testb %al,%al
	jnz L223
L232:
	cmpq $0,_baserec(%rip)
	jnz L223
L233:
	cmpb $0,_f_verbose(%rip)
	jz L223
L229:
	cmpl $0,%r12d
	jle L223
L225:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	movl $512,%ecx
	movl %r12d,%eax
	cltd 
	idivl %ecx
	cmpl $512,%r12d
	movl $L238,%ecx
	movl $L237,%edx
	cmovleq %rcx,%rdx
	pushq %rdx
	pushq %rax
	pushq $L236
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L223:
	movl _blocksize(%rip),%eax
	subl %ebx,%eax
	shrl $9,%eax
	movq _ar_block(%rip),%rcx
	shlq $9,%rax
	addq %rax,%rcx
	movq %rcx,_ar_last(%rip)
L196:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_flush_archive:
L260:
L261:
	movq _ar_last(%rip),%rax
	movq _ar_block(%rip),%rdi
	subq %rdi,%rax
	movl $512,%ecx
	cqto 
	idivq %rcx
	addq %rax,_baserec(%rip)
	movq %rdi,_ar_record(%rip)
	movslq _blocking(%rip),%rax
	shlq $9,%rax
	addq %rax,%rdi
	movq %rdi,_ar_last(%rip)
	cmpb $0,_ar_reading(%rip)
	jnz L264
L263:
	call _fl_write
	ret
L264:
	call _fl_read
L262:
	ret 


_close_archive:
L266:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
L267:
	cmpb $0,_ar_reading(%rip)
	jnz L271
L269:
	call _flush_archive
L271:
	movl _archive(%rip),%edi
	call _close
	cmpl $0,_childpid(%rip)
	jz L268
L275:
	leaq -4(%rbp),%rdi
	call _wait
	cmpl %eax,_childpid(%rip)
	jz L277
L278:
	cmpl $-1,%eax
	jnz L275
L277:
	cmpl $-1,%eax
	jz L268
L282:
	movl -4(%rbp),%eax
	movl %eax,%edx
	andl $127,%edx
	jz L288
L308:
	cmpl $13,%edx
	jz L268
L309:
	testl $128,%eax
	movl $L238,%eax
	movl $L303,%ecx
	cmovzq %rax,%rcx
	pushq %rcx
	pushq %rdx
	pushq $L302
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	jmp L268
L288:
	sarl $8,%eax
	cmpl $105,%eax
	jnz L291
L289:
	movl $4,%edi
	call _exit
L291:
	movl -4(%rbp),%eax
	sarl $8,%eax
	cmpl $141,%eax
	jz L268
L293:
	testl %eax,%eax
	jz L268
L296:
	pushq %rax
	pushq $L299
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L268:
	movq %rbp,%rsp
	popq %rbp
	ret 


_anno:
L311:
	pushq %rbp
	movq %rsp,%rbp
	subq $56,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L312:
	movq %rdi,%r12
	movq %rsi,%r13
	movl %edx,%ebx
	cmpq $___stderr,%r12
	jnz L316
L314:
	movl $___stdout,%edi
	call _fflush
L316:
	cmpb $0,_f_sayblock(%rip)
	jz L318
L317:
	testq %r13,%r13
	jz L322
L320:
	movq %r12,%rsi
	movq %r13,%rdi
	call _fputs
	decl (%r12)
	js L324
L323:
	movq 24(%r12),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r12)
	movb $32,(%rcx)
	jmp L322
L324:
	movq %r12,%rsi
	movl $32,%edi
	call ___flushbuf
L322:
	movq _ar_record(%rip),%rax
	subq _ar_block(%rip),%rax
	movl $512,%ecx
	cqto 
	idivq %rcx
	leaq -50(%rbp),%rdx
	testl %ebx,%ebx
	jz L328
L327:
	movq _saved_recno(%rip),%rax
	jmp L329
L328:
	addq _baserec(%rip),%rax
L329:
	pushq %rax
	pushq $L326
	pushq %rdx
	call _sprintf
	addq $24,%rsp
	movq %r12,%rsi
	leaq -50(%rbp),%rdi
	call _fputs
	leaq -50(%rbp),%rdi
	call _strlen
	movl $13,%ecx
	subl %eax,%ecx
	cmpl $0,%ecx
	jle L313
L330:
	pushq $L238
	pushq %rcx
	pushq $L333
	pushq %r12
	call _fprintf
	addq $32,%rsp
	jmp L313
L318:
	testq %r13,%r13
	jz L313
L334:
	movq %r12,%rsi
	movq %r13,%rdi
	call _fputs
	movq %r12,%rsi
	movl $L337,%edi
	call _fputs
L313:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L238:
	.byte 0
L77:
	.byte 116,97,114,58,32,99,97,110
	.byte 110,111,116,32,101,120,101,99
	.byte 32,115,104,0
L152:
	.byte 116,97,114,58,32,105,110,118
	.byte 97,108,105,100,32,118,97,108
	.byte 117,101,32,102,111,114,32,98
	.byte 108,111,99,107,115,105,122,101
	.byte 10,0
L50:
	.byte 116,97,114,58,32,99,97,110
	.byte 110,111,116,32,102,111,114,107
	.byte 0
L82:
	.byte 116,97,114,58,32,99,97,110
	.byte 39,116,32,102,115,116,97,116
	.byte 32,97,114,99,104,105,118,101
	.byte 0
L69:
	.byte 67,97,110,39,116,32,111,112
	.byte 101,110,32,47,100,101,118,47
	.byte 110,117,108,108,0
L299:
	.byte 116,97,114,58,32,99,104,105
	.byte 108,100,32,114,101,116,117,114
	.byte 110,101,100,32,115,116,97,116
	.byte 117,115,32,37,100,10,0
L74:
	.byte 124,32,99,111,109,112,114,101
	.byte 115,115,32,45,100,0
L259:
	.byte 37,115,58,32,114,101,97,100
	.byte 32,37,100,32,98,121,116,101
	.byte 115,44,32,115,116,114,97,110
	.byte 103,101,46,46,46,10,0
L78:
	.byte 116,111,32,115,116,100,105,110
	.byte 0
L236:
	.byte 66,108,111,99,107,115,105,122
	.byte 101,32,61,32,37,100,32,114
	.byte 101,99,111,114,100,37,115,10
	.byte 0
L76:
	.byte 45,99,0
L75:
	.byte 115,104,0
L109:
	.byte 114,115,104,32,39,37,115,39
	.byte 32,100,100,32,111,98,115,61
	.byte 37,100,98,32,39,62,37,115
	.byte 39,0
L303:
	.byte 32,40,99,111,114,101,32,100
	.byte 117,109,112,101,100,41,0
L110:
	.byte 100,100,32,111,98,115,61,37
	.byte 100,98,0
L61:
	.byte 116,111,32,115,116,100,111,117
	.byte 116,0
L181:
	.byte 116,97,114,58,32,37,115,58
	.byte 32,119,114,105,116,101,32,102
	.byte 97,105,108,101,100,44,32,115
	.byte 104,111,114,116,32,37,100,32
	.byte 98,121,116,101,115,10,0
L156:
	.byte 116,97,114,58,32,99,111,117
	.byte 108,100,32,110,111,116,32,97
	.byte 108,108,111,99,97,116,101,32
	.byte 109,101,109,111,114,121,32,102
	.byte 111,114,32,98,108,111,99,107
	.byte 105,110,103,32,102,97,99,116
	.byte 111,114,32,37,100,10,0
L88:
	.byte 116,97,114,58,32,99,97,110
	.byte 110,111,116,32,101,120,101,99
	.byte 32,99,111,109,112,114,101,115
	.byte 115,0
L89:
	.byte 100,100,32,98,115,61,37,100
	.byte 98,32,124,32,99,111,109,112
	.byte 114,101,115,115,32,45,100,0
L302:
	.byte 116,97,114,58,32,99,104,105
	.byte 108,100,32,100,105,101,100,32
	.byte 119,105,116,104,32,115,105,103
	.byte 110,97,108,32,37,100,37,115
	.byte 10,0
L46:
	.byte 116,97,114,58,32,99,97,110
	.byte 110,111,116,32,99,114,101,97
	.byte 116,101,32,112,105,112,101,32
	.byte 116,111,32,99,104,105,108,100
	.byte 0
L333:
	.byte 37,42,115,0
L105:
	.byte 99,111,109,112,114,101,115,115
	.byte 32,124,32,0
L237:
	.byte 115,0
L39:
	.byte 116,97,114,58,32,99,97,110
	.byte 110,111,116,32,100,117,112,32
	.byte 0
L87:
	.byte 45,100,0
L192:
	.byte 84,111,111,32,109,97,110,121
	.byte 32,101,114,114,111,114,115,44
	.byte 32,113,117,105,116,116,105,110
	.byte 103,46,10,0
L337:
	.byte 58,32,0
L70:
	.byte 114,115,104,32,39,37,115,39
	.byte 32,100,100,32,39,60,37,115
	.byte 39,32,98,115,61,37,100,98
	.byte 0
L68:
	.byte 47,100,101,118,47,110,117,108
	.byte 108,0
L326:
	.byte 114,101,99,32,37,100,58,32
	.byte 0
L257:
	.byte 37,115,58,32,101,111,102,32
	.byte 110,111,116,32,111,110,32,98
	.byte 108,111,99,107,32,98,111,117
	.byte 110,100,97,114,121,44,32,115
	.byte 116,114,97,110,103,101,46,46
	.byte 46,10,0
L185:
	.byte 82,101,97,100,32,101,114,114
	.byte 111,114,32,111,110,32,0
L86:
	.byte 99,111,109,112,114,101,115,115
	.byte 0
.local _save_rec
.comm _save_rec, 8, 8
.local _record_save_area
.comm _record_save_area, 512, 1
.local _saved_recno
.comm _saved_recno, 8, 8
.local _baserec
.comm _baserec, 8, 8
.local _r_error_count
.comm _r_error_count, 4, 4
.local _eof
.comm _eof, 4, 4

.globl _ar_reading
.globl _close
.globl _open_archive
.globl _sprintf
.globl _archive
.globl _anno
.globl _fork
.globl _f_sayblock
.globl _dup
.globl ___stdout
.globl _malloc
.globl _child_open
.globl _execlp
.globl _ar_record
.globl _ar_last
.globl _abort
.globl _write
.globl _pipe
.globl _f_reblock
.globl _read_error_flag
.globl _strcat
.globl _fflush
.globl _blocksize
.globl _close_archive
.globl _creat
.globl ___flushbuf
.globl _findrec
.globl _ar_file
.globl _open
.globl ___stderr
.globl _f_verbose
.globl _tar
.globl _perror
.globl _f_compress
.globl _ar_block
.globl _fstat
.globl _read
.globl _blocking
.globl _userec
.globl _wait
.globl _fputs
.globl _endofrecs
.globl _strlen
.globl _strchr
.globl _exit
.globl _fprintf
.globl _saverec
