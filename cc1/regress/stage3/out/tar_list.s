.text

_read_and:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movq %rdi,%r13
	movl $3,%r12d
	call _name_gather
	movl $1,%edi
	call _open_archive
L4:
	movl %r12d,%ebx
	call _read_header
	movl %eax,%r12d
	cmpl $1,%eax
	jz L11
L38:
	testl %eax,%eax
	jz L17
L39:
	cmpl $2,%eax
	jnz L9
L29:
	movq _head(%rip),%rdi
	call _userec
	movl %ebx,%r12d
	cmpb $0,_f_ignorez(%rip)
	jnz L4
L9:
	call _close_archive
	call _names_notfound
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 
L17:
	movq _head(%rip),%rdi
	call _userec
	cmpl $3,%ebx
	jz L21
L44:
	cmpl $2,%ebx
	jz L24
L45:
	cmpl $1,%ebx
	jz L24
	jnz L4
L21:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L22
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L24:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L25
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	jmp L4
L11:
	movq _head(%rip),%rax
	movb $0,99(%rax)
	movq _head(%rip),%rdi
	call _name_match
	testl %eax,%eax
	jz L12
L14:
	call *%r13
	jmp L4
L12:
	movq _head(%rip),%rdi
	call _userec
	movq _hstat+48(%rip),%rdi
	call _skip_file
	jmp L4


_list_archive:
L49:
L50:
	movl $_head,%edi
	call _saverec
	movb _f_verbose(%rip),%al
	testb %al,%al
	jz L54
L52:
	cmpb $1,%al
	jle L57
L55:
	xorl %ecx,%ecx
	movl $_head_standard,%edx
	movl $_hstat,%esi
	movq _head(%rip),%rdi
	call _decode_header
L57:
	movl $___stdout,%edi
	call _print_header
L54:
	xorl %edi,%edi
	call _saverec
	movq _head(%rip),%rdi
	call _userec
	movq _hstat+48(%rip),%rdi
	call _skip_file
L51:
	ret 


_read_header:
L58:
	pushq %rbx
	pushq %r12
L59:
	call _findrec
	movq %rax,%rbx
	movq %rbx,%r12
	movq %rbx,_head(%rip)
	testq %rbx,%rbx
	jz L61
L63:
	leaq 148(%rbx),%rsi
	movl $8,%edi
	call _from_oct
	xorl %ecx,%ecx
	movl $512,%esi
	jmp L65
L66:
	movzbq (%r12),%rdx
	incq %r12
	addq %rdx,%rcx
L65:
	decl %esi
	jns L66
L68:
	movl $8,%esi
	jmp L69
L70:
	movslq %esi,%rdx
	movzbq 148(%rbx,%rdx),%rdx
	subq %rdx,%rcx
L69:
	decl %esi
	jns L70
L72:
	addq $256,%rcx
	cmpq %rcx,%rax
	jz L73
L75:
	cmpq $256,%rcx
	movl $2,%ecx
	movl $0,%eax
	cmovzl %ecx,%eax
	jmp L60
L73:
	cmpb $49,156(%rbx)
	jnz L77
L76:
	movq $0,_hstat+48(%rip)
	jmp L78
L77:
	leaq 124(%rbx),%rsi
	movl $13,%edi
	call _from_oct
	movq %rax,_hstat+48(%rip)
L78:
	movl $1,%eax
	jmp L60
L61:
	movl $-1,%eax
L60:
	popq %r12
	popq %rbx
	ret 


_decode_header:
L85:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L86:
	movq %rdi,%r12
	movq %rsi,%rbx
	movq %rdx,%r14
	movl %ecx,%r13d
	leaq 100(%r12),%rsi
	movl $8,%edi
	call _from_oct
	movl %eax,24(%rbx)
	leaq 136(%r12),%rsi
	movl $13,%edi
	call _from_oct
	movq %rax,88(%rbx)
	movl $L91,%esi
	leaq 257(%r12),%rdi
	call _strcmp
	testl %eax,%eax
	jnz L89
L88:
	movl $1,(%r14)
	testl %r13d,%r13d
	jz L94
L92:
	leaq 265(%r12),%rdi
	call _finduid
	movl %eax,28(%rbx)
	leaq 297(%r12),%rdi
	call _findgid
	movl %eax,32(%rbx)
L94:
	movb 156(%r12),%al
	cmpb $52,%al
	jz L99
L101:
	cmpb $51,%al
	jnz L87
L99:
	leaq 329(%r12),%rsi
	movl $8,%edi
	call _from_oct
	movl %eax,%r13d
	shll $8,%r13d
	leaq 337(%r12),%rsi
	movl $8,%edi
	call _from_oct
	orl %r13d,%eax
	movl %eax,40(%rbx)
	jmp L87
L89:
	movl $0,(%r14)
	leaq 108(%r12),%rsi
	movl $8,%edi
	call _from_oct
	movl %eax,28(%rbx)
	leaq 116(%r12),%rsi
	movl $8,%edi
	call _from_oct
	movl %eax,32(%rbx)
	movl $0,40(%rbx)
L87:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_from_oct:
L104:
L107:
	movsbq (%rsi),%rax
	testb $8,___ctype+1(%rax)
	jz L109
L108:
	incq %rsi
	decl %edi
	cmpl $0,%edi
	jg L107
	jle L138
L109:
	xorl %eax,%eax
	jmp L114
L117:
	movb (%rsi),%cl
	cmpb $48,%cl
	jl L116
L121:
	cmpb $55,%cl
	jg L116
L115:
	shlq $3,%rax
	movsbl %cl,%ecx
	incq %rsi
	subl $48,%ecx
	movslq %ecx,%rcx
	orq %rax,%rcx
	movq %rcx,%rax
	decl %edi
L114:
	cmpl $0,%edi
	jg L117
L116:
	cmpl $0,%edi
	jle L106
L132:
	movb (%rsi),%cl
	testb %cl,%cl
	jz L106
L128:
	movsbq %cl,%rcx
	testb $8,___ctype+1(%rcx)
	jnz L106
L138:
	movq $-1,%rax
L106:
	ret 

.data
.align 4
_ugswidth:
	.int 11
.text
.align 2
L238:
	.short L214-_print_header
	.short L203-_print_header
	.short L200-_print_header
	.short L214-_print_header
	.short L214-_print_header
	.short L214-_print_header
	.short L214-_print_header
	.short L214-_print_header
.align 2
L239:
	.short L152-_print_header
	.short L152-_print_header
	.short L159-_print_header
	.short L163-_print_header
	.short L161-_print_header
	.short L219-_print_header
	.short L165-_print_header
	.short L167-_print_header

_print_header:
L139:
	pushq %rbp
	movq %rsp,%rbp
	subq $88,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
L140:
	movq %rdi,%r15
	movl $1,%edx
	xorl %esi,%esi
	movq %r15,%rdi
	call _anno
	cmpb $1,_f_verbose(%rip)
	jg L143
L142:
	pushq _head(%rip)
	pushq $L145
	jmp L240
L143:
	leaq -11(%rbp),%rax
	movq %rax,-80(%rbp) # spill
	movb $63,-11(%rbp)
	movq _head(%rip),%rbx
	movb 156(%rbx),%al
	cmpb $48,%al
	jl L232
L234:
	cmpb $55,%al
	jg L232
L231:
	addb $-48,%al
	movzbl %al,%eax
	movzwl L239(,%rax,2),%eax
	addl $_print_header,%eax
	jmp *%rax
L167:
	movb $67,-11(%rbp)
	jmp L148
L165:
	movb $112,-11(%rbp)
	jmp L148
L161:
	movb $98,-11(%rbp)
	jmp L148
L163:
	movb $99,-11(%rbp)
	jmp L148
L159:
	movb $108,-11(%rbp)
	jmp L148
L232:
	testb %al,%al
	jnz L148
L152:
	movb $45,-11(%rbp)
	movq %rbx,%rdi
	call _strlen
	cmpb $47,-1(%rbx,%rax)
	jnz L148
L219:
	movb $100,-11(%rbp)
L148:
	leaq -10(%rbp),%rsi
	movl _hstat+24(%rip),%edi
	call _demode
	movq _hstat+88(%rip),%rax
	movq %rax,-24(%rbp)
	leaq -24(%rbp),%rdi
	call _ctime
	movq %rax,%r14
	movb $0,16(%r14)
	movb $0,24(%r14)
	movq _head(%rip),%rax
	leaq 265(%rax),%r13
	cmpb $0,265(%rax)
	jz L170
L172:
	cmpl $0,_head_standard(%rip)
	jnz L171
L170:
	movl _hstat+28(%rip),%eax
	leaq -35(%rbp),%r13
	pushq %rax
	pushq $L176
	pushq %r13
	call _sprintf
	addq $24,%rsp
L171:
	movq _head(%rip),%rax
	leaq 297(%rax),%r12
	cmpb $0,297(%rax)
	jz L178
L180:
	cmpl $0,_head_standard(%rip)
	jnz L179
L178:
	movl _hstat+32(%rip),%eax
	leaq -46(%rbp),%r12
	pushq %rax
	pushq $L176
	pushq %r12
	call _sprintf
	addq $24,%rsp
L179:
	movq _head(%rip),%rax
	movb 156(%rax),%al
	cmpb $51,%al
	jz L188
L228:
	cmpb $52,%al
	jz L188
L229:
	leaq -70(%rbp),%rax
	pushq _hstat+48(%rip)
	pushq $L191
	pushq %rax
	call _sprintf
	addq $24,%rsp
	jmp L185
L188:
	movl _hstat+40(%rip),%edx
	leaq -70(%rbp),%rsi
	movl %edx,%eax
	shrl $8,%eax
	movzbl %al,%ecx
	movzbl %dl,%eax
	pushq %rax
	pushq %rcx
	pushq $L189
	pushq %rsi
	call _sprintf
	addq $32,%rsp
L185:
	movq %r13,%rdi
	call _strlen
	movl %eax,%ebx
	movq %r12,%rdi
	call _strlen
	addl %eax,%ebx
	leaq -70(%rbp),%rax
	movq %rax,-88(%rbp) # spill
	leaq -70(%rbp),%rdi
	call _strlen
	leal 1(%rbx,%rax),%eax
	cmpl _ugswidth(%rip),%eax
	jle L194
L192:
	movl %eax,_ugswidth(%rip)
L194:
	movl _ugswidth(%rip),%ecx
	subl %eax,%ecx
	leaq 4(%r14),%rax
	addq $20,%r14
	pushq _head(%rip)
	pushq $100
	pushq %r14
	pushq %rax
	pushq -88(%rbp) # spill
	pushq $L196
	pushq %rcx
	pushq %r12
	pushq %r13
	pushq -80(%rbp) # spill
	pushq $L195
	pushq %r15
	call _fprintf
	addq $96,%rsp
	movq _head(%rip),%rdx
	movb 156(%rdx),%cl
	cmpb $48,%cl
	jl L221
L223:
	cmpb $55,%cl
	jg L221
L220:
	leal -48(%rcx),%eax
	movzbl %al,%eax
	movzwl L238(,%rax,2),%eax
	addl $_print_header,%eax
	jmp *%rax
L200:
	addq $157,%rdx
	pushq %rdx
	pushq $L201
	jmp L240
L203:
	addq $157,%rdx
	pushq %rdx
	pushq $L204
	jmp L240
L221:
	testb %cl,%cl
	jz L214
L197:
	movsbl %cl,%ecx
	pushq %rcx
	pushq $L206
L240:
	pushq %r15
	call _fprintf
	addq $24,%rsp
	jmp L141
L214:
	decl (%r15)
	js L216
L215:
	movq 24(%r15),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r15)
	movb $10,(%rcx)
	jmp L141
L216:
	movq %r15,%rsi
	movl $10,%edi
	call ___flushbuf
L141:
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_pr_mkdir:
L241:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L242:
	movq %rdi,%r14
	movl %esi,%r13d
	movl %edx,%edi
	movq %rcx,%r12
	cmpb $1,_f_verbose(%rip)
	jle L243
L244:
	leaq -11(%rbp),%rbx
	movb $100,-11(%rbp)
	leaq -10(%rbp),%rsi
	call _demode
	movl $1,%edx
	xorl %esi,%esi
	movq %r12,%rdi
	call _anno
	movl _ugswidth(%rip),%eax
	addl $19,%eax
	pushq %r14
	pushq %r13
	pushq $L248
	pushq %rax
	pushq %rbx
	pushq $L247
	pushq %r12
	call _fprintf
	addq $56,%rsp
L243:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_skip_file:
L249:
	pushq %rbx
	pushq %r12
L250:
	movq %rdi,%rbx
	jmp L252
L253:
	call _findrec
	movq %rax,%r12
	testq %r12,%r12
	jnz L257
L255:
	xorl %edx,%edx
	movq _tar(%rip),%rsi
	movl $___stderr,%edi
	call _anno
	pushq $L258
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $3,%edi
	call _exit
L257:
	movq %r12,%rdi
	call _userec
	subq $512,%rbx
L252:
	cmpq $0,%rbx
	jg L253
L251:
	popq %r12
	popq %rbx
	ret 


_demode:
L259:
L260:
	movl $L262,%r9d
	movl $256,%r8d
L264:
	testl %edi,%r8d
	leaq 1(%rsi),%rcx
	leaq 1(%r9),%rax
	jz L268
L267:
	movb (%r9),%dl
	movq %rax,%r9
	movb %dl,(%rsi)
	movq %rcx,%rsi
	jmp L269
L268:
	movb $45,(%rsi)
	movq %rcx,%rsi
	movq %rax,%r9
L269:
	shrl $1,%r8d
	jnz L264
L266:
	testl $2048,%edi
	jz L272
L270:
	cmpb $120,-7(%rsi)
	jnz L274
L273:
	movb $115,-7(%rsi)
	jmp L272
L274:
	movb $83,-7(%rsi)
L272:
	testl $1024,%edi
	jz L278
L276:
	cmpb $120,-4(%rsi)
	jnz L280
L279:
	movb $115,-4(%rsi)
	jmp L278
L280:
	movb $83,-4(%rsi)
L278:
	testl $512,%edi
	jz L284
L282:
	cmpb $120,-1(%rsi)
	jnz L286
L285:
	movb $116,-1(%rsi)
	jmp L284
L286:
	movb $84,-1(%rsi)
L284:
	movb $0,(%rsi)
L261:
	ret 

L196:
	.byte 0
L176:
	.byte 37,100,0
L201:
	.byte 32,45,62,32,37,115,10,0
L262:
	.byte 114,119,120,114,119,120,114,119
	.byte 120,0
L191:
	.byte 37,108,100,0
L258:
	.byte 85,110,101,120,112,101,99,116
	.byte 101,100,32,69,79,70,32,111
	.byte 110,32,97,114,99,104,105,118
	.byte 101,32,102,105,108,101,10,0
L145:
	.byte 37,115,10,0
L206:
	.byte 32,117,110,107,110,111,119,110
	.byte 32,102,105,108,101,32,116,121
	.byte 112,101,32,39,37,99,39,10
	.byte 0
L22:
	.byte 72,109,109,44,32,116,104,105
	.byte 115,32,100,111,101,115,110,39
	.byte 116,32,108,111,111,107,32,108
	.byte 105,107,101,32,97,32,116,97
	.byte 114,32,97,114,99,104,105,118
	.byte 101,46,10,0
L91:
	.byte 117,115,116,97,114,32,32,0
L195:
	.byte 37,115,32,37,115,47,37,115
	.byte 32,37,42,115,37,115,32,37
	.byte 115,32,37,115,32,37,46,42
	.byte 115,0
L204:
	.byte 32,108,105,110,107,32,116,111
	.byte 32,37,115,10,0
L25:
	.byte 83,107,105,112,112,105,110,103
	.byte 32,116,111,32,110,101,120,116
	.byte 32,102,105,108,101,32,104,101
	.byte 97,100,101,114,46,46,46,10
	.byte 0
L247:
	.byte 37,115,32,37,42,115,32,37
	.byte 46,42,115,10,0
L248:
	.byte 67,114,101,97,116,105,110,103
	.byte 32,100,105,114,101,99,116,111
	.byte 114,121,58,0
L189:
	.byte 37,100,44,37,100,0
.globl _head
.comm _head, 8, 8
.globl _hstat
.comm _hstat, 144, 8
.globl _head_standard
.comm _head_standard, 4, 4

.globl _open_archive
.globl _sprintf
.globl _print_header
.globl _finduid
.globl _name_gather
.globl _findgid
.globl _anno
.globl _read_and
.globl _ctime
.globl _names_notfound
.globl _from_oct
.globl _hstat
.globl ___stdout
.globl _f_ignorez
.globl _pr_mkdir
.globl _close_archive
.globl ___flushbuf
.globl _strcmp
.globl _findrec
.globl _skip_file
.globl ___ctype
.globl _head
.globl _head_standard
.globl ___stderr
.globl _f_verbose
.globl _tar
.globl _read_header
.globl _name_match
.globl _userec
.globl _decode_header
.globl _strlen
.globl _exit
.globl _demode
.globl _list_archive
.globl _fprintf
.globl _saverec
