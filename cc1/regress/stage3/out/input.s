.data
.align 8
_input_stack:
	.quad 0
.text

_input_push:
L1:
	pushq %rbx
	pushq %r12
	pushq %r13
L2:
	movq %rdi,%r13
	movq %rsi,%r12
	movl $48,%edi
	call _safe_malloc
	movq %rax,%rbx
	leaq 8(%rbx),%rdi
	call _vstring_init
	movq %r12,%rsi
	leaq 8(%rbx),%rdi
	call _vstring_puts
	movq %r13,(%rbx)
	movl $0,32(%rbx)
	movq _input_stack(%rip),%rax
	movq %rax,40(%rbx)
	movq %rbx,_input_stack(%rip)
	movb $1,_need_resync(%rip)
L3:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_input_pop:
L7:
	pushq %rbx
L8:
	movq _input_stack(%rip),%rbx
	cmpq $0,40(%rbx)
	jnz L13
L10:
	call _directive_check
L13:
	movq _input_stack(%rip),%rax
	movq 40(%rax),%rax
	movq %rax,_input_stack(%rip)
	movq (%rbx),%rdi
	call _fclose
	leaq 8(%rbx),%rdi
	call _vstring_free
	movq %rbx,%rdi
	call _free
	movb $1,_need_resync(%rip)
L9:
	popq %rbx
	ret 


_erase_comments:
L16:
L17:
	xorl %esi,%esi
	xorl %edx,%edx
L19:
	movzbl (%rdi),%ecx
	testb %cl,%cl
	jz L21
L20:
	testl %esi,%esi
	jz L23
L22:
	movsbl %cl,%eax
	cmpl %eax,%esi
	movl $0,%eax
	cmovzl %eax,%esi
	cmpb $92,%cl
	jnz L24
L31:
	leaq 1(%rdi),%rcx
	movsbl 1(%rdi),%eax
	cmpl %eax,%esi
	cmovzq %rcx,%rdi
	jmp L24
L23:
	cmpb $0,_in_comment(%rip)
	jz L36
L35:
	cmpb $42,%cl
	jnz L40
L41:
	cmpb $47,1(%rdi)
	jnz L40
L42:
	movb $32,1(%rdi)
	movb $0,_in_comment(%rip)
L40:
	movb $32,(%rdi)
	jmp L24
L36:
	cmpb $47,%cl
	jnz L50
L48:
	cmpb $42,1(%rdi)
	jnz L50
L49:
	movb $32,(%rdi)
	movb $32,1(%rdi)
	movb $1,_in_comment(%rip)
	jmp L24
L50:
	cmpb $0,_cxx_mode(%rip)
	jz L57
L59:
	cmpb $47,%cl
	jnz L57
L60:
	cmpb $47,1(%rdi)
	jz L56
L57:
	cmpb $34,%cl
	jz L68
L67:
	cmpb $39,%cl
	jnz L24
L68:
	movsbl %cl,%esi
L24:
	cmpb $32,(%rdi)
	jnz L72
L71:
	testq %rdx,%rdx
	cmovzq %rdi,%rdx
	jmp L73
L72:
	xorl %edx,%edx
L73:
	incq %rdi
	jmp L19
L56:
	movb $0,(%rdi)
L21:
	testq %rdx,%rdx
	jz L18
L77:
	movb $0,(%rdx)
L18:
	ret 


_unwind:
L80:
	pushq %rbx
	pushq %r12
L81:
	movl %edi,%ebx
	movl $-1,%r12d
L83:
	movq _input_stack(%rip),%rax
	testq %rax,%rax
	jz L85
L84:
	movq (%rax),%rax
	decl (%rax)
	movq _input_stack(%rip),%rax
	movq (%rax),%rdi
	js L87
L86:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%r12d
	jmp L88
L87:
	call ___fillbuf
	movl %eax,%r12d
L88:
	cmpl $-1,%r12d
	jnz L90
L89:
	cmpb $0,_in_comment(%rip)
	jz L94
L92:
	pushq $L95
	call _error
	addq $8,%rsp
L94:
	testl %ebx,%ebx
	jz L85
L98:
	call _input_pop
	jmp L83
L90:
	movq _input_stack(%rip),%rax
	movq (%rax),%rsi
	movl %r12d,%edi
	call _ungetc
L85:
	movl %r12d,%eax
L82:
	popq %r12
	popq %rbx
	ret 

.data
.align 8
L105:
	.byte 1
	.fill 23, 1, 0
.text

_concat_line:
L102:
	pushq %rbx
	pushq %r12
L103:
	xorl %r12d,%r12d
	call _unwind
	cmpl $-1,%eax
	jz L106
L108:
	movq _input_stack(%rip),%rcx
	incl 32(%rcx)
	movl $L105,%edi
	call _vstring_clear
L110:
	movq _input_stack(%rip),%rax
	cmpl $92,%r12d
	setz %bl
	movzbl %bl,%ebx
	movq (%rax),%rax
	decl (%rax)
	movq _input_stack(%rip),%rax
	movq (%rax),%rdi
	js L115
L114:
	movq 24(%rdi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rdi)
	movzbl (%rcx),%r12d
	jmp L116
L115:
	call ___fillbuf
	movl %eax,%r12d
L116:
	cmpl $10,%r12d
	jz L120
L131:
	cmpl $-1,%r12d
	jz L125
L132:
	movl %r12d,%esi
	movl $L105,%edi
	call _vstring_putc
	jmp L110
L120:
	testl %ebx,%ebx
	jz L125
L121:
	movl $L105,%edi
	call _vstring_rubout
	movq _input_stack(%rip),%rcx
	incl 32(%rcx)
	jmp L110
L125:
	testl $1,L105(%rip)
	jz L127
L126:
	movl $L105+1,%eax
	jmp L104
L127:
	movq L105+16(%rip),%rax
	jmp L104
L106:
	xorl %eax,%eax
L104:
	popq %r12
	popq %rbx
	ret 


_input_tokenize:
L134:
	pushq %rbp
	movq %rsp,%rbp
	subq $8,%rsp
	pushq %rbx
	pushq %r12
L135:
	movq %rdi,%r12
	movq %rsi,-8(%rbp)
	xorl %ebx,%ebx
L137:
	movq -8(%rbp),%rdi
	cmpb $0,(%rdi)
	jz L139
L138:
	leaq -8(%rbp),%rsi
	call _token_scan
	leaq 32(%rax),%rdx
	movq $0,32(%rax)
	movq 8(%r12),%rcx
	movq %rcx,40(%rax)
	movq 8(%r12),%rcx
	movq %rax,(%rcx)
	movq %rdx,8(%r12)
	incl %ebx
	jmp L137
L139:
	movl %ebx,%eax
L136:
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_input_tokens:
L144:
	pushq %rbx
	pushq %r12
L145:
	movq %rsi,%r12
	call _concat_line
	movq %rax,%rbx
	testq %rax,%rax
	jz L147
L149:
	movq %rbx,%rdi
	call _erase_comments
	movq %rbx,%rsi
	movq %r12,%rdi
	call _input_tokenize
	jmp L146
L147:
	movl $-1,%eax
L146:
	popq %r12
	popq %rbx
	ret 

.data
.align 8
_system_dirs:
	.quad 0
.text

_input_dir:
L152:
	pushq %rbx
	pushq %r12
L153:
	movq %rdi,%r12
	movl $32,%edi
	call _safe_malloc
	movq %rax,%rbx
	movq %rbx,%rdi
	call _vstring_init
	movq %r12,%rsi
	movq %rbx,%rdi
	call _vstring_puts
	movq _system_dirs(%rip),%rax
	movq %rax,24(%rbx)
	movq %rbx,_system_dirs(%rip)
L154:
	popq %r12
	popq %rbx
	ret 


_input_open:
L158:
	pushq %rbp
	movq %rsp,%rbp
	subq $24,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
L159:
	movq %rdi,%rbx
	movl %esi,%r13d
	leaq -24(%rbp),%rdi
	call _vstring_init
	movq _system_dirs(%rip),%r12
L161:
	leaq -24(%rbp),%rdi
	call _vstring_clear
	testl %r13d,%r13d
	jz L168
L208:
	cmpl $2,%r13d
	jz L171
L209:
	cmpl $1,%r13d
	jnz L166
L183:
	testq %r12,%r12
	jnz L186
L184:
	pushq %rbx
	pushq $L187
	call _error
	addq $16,%rsp
L186:
	movq %r12,%rsi
	leaq -24(%rbp),%rdi
	call _vstring_concat
	movl $47,%esi
	leaq -24(%rbp),%rdi
	call _vstring_putc
	movq %rbx,%rsi
	leaq -24(%rbp),%rdi
	call _vstring_puts
	movq 24(%r12),%r12
	jmp L166
L171:
	movq _input_stack(%rip),%rsi
	addq $8,%rsi
	leaq -24(%rbp),%rdi
	call _vstring_concat
L172:
	movl -24(%rbp),%eax
	testl $1,%eax
	jz L180
L179:
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	jmp L181
L180:
	movq -16(%rbp),%rax
L181:
	testq %rax,%rax
	jz L174
L175:
	leaq -24(%rbp),%rdi
	call _vstring_last
	cmpb $47,%al
	jz L174
L173:
	leaq -24(%rbp),%rdi
	call _vstring_rubout
	jmp L172
L174:
	movq %rbx,%rsi
	leaq -24(%rbp),%rdi
	call _vstring_puts
	movl $1,%r13d
L166:
	testl $1,-24(%rbp)
	jz L193
L192:
	leaq -23(%rbp),%rdi
	jmp L194
L193:
	movq -8(%rbp),%rdi
L194:
	xorl %esi,%esi
	call _access
	testl %eax,%eax
	jnz L161
	jz L169
L168:
	movq %rbx,%rsi
	leaq -24(%rbp),%rdi
	call _vstring_puts
L169:
	testl $1,-24(%rbp)
	jz L198
L197:
	leaq -23(%rbp),%rdi
	jmp L199
L198:
	movq -8(%rbp),%rdi
L199:
	movl $L196,%esi
	call _fopen
	movq %rax,%r12
	testq %r12,%r12
	jnz L202
L200:
	pushq %rbx
	pushq $L203
	call _error
	addq $16,%rsp
L202:
	testl $1,-24(%rbp)
	jz L205
L204:
	leaq -23(%rbp),%rsi
	jmp L206
L205:
	movq -8(%rbp),%rsi
L206:
	movq %r12,%rdi
	call _input_push
	leaq -24(%rbp),%rdi
	call _vstring_free
L160:
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L95:
 .byte 101,110,100,45,111,102,45,102
 .byte 105,108,101,32,105,110,32,99
 .byte 111,109,109,101,110,116,0
L196:
 .byte 114,0
L187:
 .byte 99,97,110,39,116,32,102,105
 .byte 110,100,32,39,37,115,39,0
L203:
 .byte 99,97,110,39,116,32,111,112
 .byte 101,110,32,39,37,115,39,32
 .byte 102,111,114,32,114,101,97,100
 .byte 105,110,103,0
.local _in_comment
.comm _in_comment, 1, 1

.globl _input_tokenize
.globl _free
.globl _input_dir
.globl _vstring_init
.globl ___fillbuf
.globl _vstring_putc
.globl _error
.globl _fopen
.globl _cxx_mode
.globl _token_scan
.globl _directive_check
.globl _vstring_concat
.globl _safe_malloc
.globl _input_tokens
.globl _input_open
.globl _access
.globl _vstring_puts
.globl _system_dirs
.globl _need_resync
.globl _fclose
.globl _vstring_clear
.globl _vstring_free
.globl _vstring_last
.globl _input_stack
.globl _vstring_rubout
.globl _ungetc
