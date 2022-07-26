.text
.align 1
L61:
	.byte 68
	.byte 71
	.byte 76
	.byte 82
	.byte 83
	.byte 88
	.byte 100
	.byte 102
	.byte 103
	.byte 114
	.byte 115
	.byte 120
.align 2
L62:
	.short L32-_out
	.short L35-_out
	.short L44-_out
	.short L47-_out
	.short L49-_out
	.short L52-_out
	.short L16-_out
	.short L19-_out
	.short L30-_out
	.short L22-_out
	.short L24-_out
	.short L27-_out

_out:
L1:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
L2:
	movq 16(%rbp),%rax
	movq %rax,16(%rbp)
	leaq 24(%rbp),%rbx
L4:
	movq 16(%rbp),%rcx
	movzbl (%rcx),%eax
	testb %al,%al
	jz L3
L5:
	cmpb $37,%al
	jz L8
L7:
	movq _out_f(%rip),%rax
	decl (%rax)
	movq _out_f(%rip),%rsi
	movq 16(%rbp),%rax
	js L11
L10:
	movzbl (%rax),%edx
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %dl,(%rcx)
	jmp L9
L11:
	movsbl (%rax),%edi
	call ___flushbuf
	jmp L9
L8:
	leaq 1(%rcx),%rax
	movq %rax,16(%rbp)
	movzbl 1(%rcx),%ecx
	movq _out_f(%rip),%rdi
	xorl %eax,%eax
L58:
	cmpb L61(,%rax),%cl
	jz L59
L60:
	incl %eax
	cmpl $12,%eax
	jb L58
	jae L13
L59:
	movzwl L62(,%rax,2),%eax
	addl $_out,%eax
	jmp *%rax
L27:
	addq $8,%rbx
	movl -8(%rbx),%eax
	pushq %rax
	pushq $L28
	pushq %rdi
	call _fprintf
	addq $24,%rsp
	jmp L9
L24:
	addq $8,%rbx
	pushq -8(%rbx)
	pushq $L25
	pushq %rdi
	call _fprintf
	addq $24,%rsp
	jmp L9
L22:
	addq $8,%rbx
	xorl %edx,%edx
	movl -8(%rbx),%esi
	call _print_reg
	jmp L9
L30:
	addq $8,%rbx
	movq -8(%rbx),%rsi
	call _print_global
	jmp L9
L19:
	addq $8,%rbx
	movsd -8(%rbx),%xmm0
	subq $24,%rsp
	movsd %xmm0,16(%rsp)
	movq $L20,8(%rsp)
	movq %rdi,(%rsp)
	call _fprintf
	addq $24,%rsp
	jmp L9
L16:
	addq $8,%rbx
	movl -8(%rbx),%eax
	pushq %rax
	pushq $L17
	pushq %rdi
	call _fprintf
	addq $24,%rsp
	jmp L9
L52:
	addq $8,%rbx
	pushq -8(%rbx)
	pushq $L53
	pushq %rdi
	call _fprintf
	addq $24,%rsp
	jmp L9
L49:
	addq $8,%rbx
	movq -8(%rbx),%rcx
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L50
	pushq %rdi
	call _fprintf
	addq $32,%rsp
	jmp L9
L47:
	movl (%rbx),%esi
	addq $16,%rbx
	movq -8(%rbx),%rdx
	movslq %edx,%rdx
	call _print_reg
	jmp L9
L44:
	addq $8,%rbx
	movl -8(%rbx),%eax
	pushq %rax
	pushq $L45
	pushq %rdi
	call _fprintf
	addq $24,%rsp
	jmp L9
L35:
	movq (%rbx),%rsi
	addq $16,%rbx
	movq -8(%rbx),%r12
	testq %rsi,%rsi
	jz L37
L36:
	call _print_global
	testq %r12,%r12
	jz L9
L39:
	pushq %r12
	pushq $L42
	pushq _out_f(%rip)
	call _fprintf
	addq $24,%rsp
	jmp L9
L37:
	pushq %r12
	pushq $L33
	pushq %rdi
	call _fprintf
	addq $24,%rsp
	jmp L9
L32:
	addq $8,%rbx
	pushq -8(%rbx)
	pushq $L33
	pushq %rdi
	call _fprintf
	addq $24,%rsp
	jmp L9
L13:
	decl (%rdi)
	movq _out_f(%rip),%rsi
	movq 16(%rbp),%rax
	js L56
L55:
	movzbl (%rax),%edx
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %dl,(%rcx)
	jmp L9
L56:
	movsbl (%rax),%edi
	call ___flushbuf
L9:
	incq 16(%rbp)
	jmp L4
L3:
	popq %r12
	popq %rbx
	popq %rbp
	ret 

.local L66
.comm L66, 4, 4

_seg:
L63:
	pushq %rbx
L64:
	movl %edi,%ebx
	cmpl L66(%rip),%ebx
	jz L65
L67:
	cmpl $1,%ebx
	movl $L71,%eax
	movl $L70,%edi
	cmovnzq %rax,%rdi
	movq _out_f(%rip),%rsi
	call _fputs
	movl %ebx,L66(%rip)
L65:
	popq %rbx
	ret 

.data
.align 8
L78:
	.quad L79
	.quad L80
	.quad L81
	.quad L82
	.quad L83
.text

_error:
L75:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L76:
	movl 16(%rbp),%r12d
	movq 24(%rbp),%rbx
	movq 32(%rbp),%rax
	movq %rax,32(%rbp)
	testl %r12d,%r12d
	jnz L86
L87:
	cmpb $0,_w_flag(%rip)
	jz L77
L86:
	movq _path(%rip),%rcx
	testq %rcx,%rcx
	jz L94
L92:
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L50
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl _line_no(%rip),%eax
	testl %eax,%eax
	jz L97
L95:
	pushq %rax
	pushq $L98
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L97:
	pushq $L99
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L94:
	movslq %r12d,%rax
	pushq L78(,%rax,8)
	pushq $L100
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	testq %rbx,%rbx
	jz L103
L101:
	movl 4(%rbx),%eax
	pushq 8(%rbx)
	pushq %rax
	pushq $L104
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L103:
	leaq 40(%rbp),%rbx
L105:
	movq 32(%rbp),%rcx
	movzbl (%rcx),%eax
	testb %al,%al
	jz L107
L106:
	cmpb $37,%al
	jz L109
L108:
	decl ___stderr(%rip)
	js L112
L111:
	movzbl (%rcx),%edx
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb %dl,(%rcx)
	jmp L110
L112:
	movsbl (%rcx),%edi
	movl $___stderr,%esi
	call ___flushbuf
	jmp L110
L109:
	leaq 1(%rcx),%rax
	movq %rax,32(%rbp)
	movzbl 1(%rcx),%eax
	cmpb $37,%al
	jz L183
L201:
	cmpb $75,%al
	jz L143
L202:
	cmpb $76,%al
	jz L145
L203:
	cmpb $83,%al
	jz L163
L204:
	cmpb $84,%al
	jz L165
L205:
	cmpb $100,%al
	jz L117
L206:
	cmpb $107,%al
	jz L119
L207:
	cmpb $113,%al
	jz L121
L208:
	cmpb $115,%al
	jnz L110
L141:
	addq $8,%rbx
	pushq -8(%rbx)
	pushq $L25
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L110
L121:
	addq $8,%rbx
	movq -8(%rbx),%rcx
	testq $131072,%rcx
	movl $L124,%eax
	movl $L123,%edi
	cmovzq %rax,%rdi
	cmpq $393216,%rcx
	movl $L124,%eax
	movl $L125,%esi
	cmovnzq %rax,%rsi
	testq $262144,%rcx
	movl $L124,%eax
	movl $L126,%edx
	cmovzq %rax,%rdx
	cmpq $393216,%rcx
	movl $L124,%eax
	movl $L127,%ecx
	cmovnzq %rax,%rcx
	pushq %rcx
	pushq %rdx
	pushq %rsi
	pushq %rdi
	pushq $L122
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
	jmp L110
L119:
	addq $8,%rbx
	movl -8(%rbx),%esi
	movl $___stderr,%edi
	call _print_k
	jmp L110
L117:
	addq $8,%rbx
	movl -8(%rbx),%eax
	pushq %rax
	pushq $L17
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L110
L165:
	addq $8,%rbx
	movq -8(%rbx),%r13
	movl 12(%r13),%eax
	andl $8191,%eax
	cmpl $1,%eax
	jz L169
L212:
	cmpl $2,%eax
	jz L172
L213:
	cmpl $4,%eax
	jnz L167
L175:
	movl $___stderr,%esi
	movl $L176,%edi
	call _fputs
	jmp L167
L172:
	movl $___stderr,%esi
	movl $L173,%edi
	call _fputs
	jmp L167
L169:
	movl $___stderr,%esi
	movl $L170,%edi
	call _fputs
L167:
	movq (%r13),%rcx
	testq %rcx,%rcx
	jz L110
L178:
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L181
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	jmp L110
L163:
	addq $8,%rbx
	movq -8(%rbx),%rcx
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L50
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	jmp L110
L145:
	addq $8,%rbx
	movq -8(%rbx),%r13
	movl 12(%r13),%eax
	testl $2147483648,%eax
	jnz L146
L148:
	testl $1073741824,%eax
	movl $L153,%eax
	movl $L152,%ecx
	cmovzq %rax,%rcx
	pushq %rcx
	pushq $L151
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movq 24(%r13),%rcx
	cmpq %rcx,_path(%rip)
	jz L159
L157:
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L160
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L159:
	movl 20(%r13),%eax
	pushq %rax
	pushq $L161
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L110
L146:
	movl $___stderr,%esi
	movl $L149,%edi
	call _fputs
	jmp L110
L143:
	addq $8,%rbx
	movq -8(%rbx),%rsi
	movl $___stderr,%edi
	call _print_token
	jmp L110
L183:
	decl ___stderr(%rip)
	js L185
L184:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $37,(%rcx)
	jmp L110
L185:
	movl $___stderr,%esi
	movl $37,%edi
	call ___flushbuf
L110:
	incq 32(%rbp)
	jmp L105
L107:
	cmpl $2,%r12d
	jnz L189
L187:
	movl _errno(%rip),%edi
	call _strerror
	pushq %rax
	pushq $L190
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L189:
	decl ___stderr(%rip)
	js L192
L191:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $10,(%rcx)
	jmp L193
L192:
	movl $___stderr,%esi
	movl $10,%edi
	call ___flushbuf
L193:
	cmpl $0,%r12d
	jle L77
L194:
	movq _out_f(%rip),%rdi
	testq %rdi,%rdi
	jz L199
L197:
	call _fclose
	movq _out_path(%rip),%rdi
	call _unlink
L199:
	movl $1,%edi
	call _exit
L77:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret 


_main:
L216:
	pushq %rbx
	pushq %r12
	pushq %r13
L217:
	movl %edi,%r12d
	movq %rsi,%r13
L219:
	movl $L222,%edx
	movq %r13,%rsi
	movl %r12d,%edi
	call _getopt
	cmpl $-1,%eax
	jz L221
L220:
	cmpl $103,%eax
	jz L226
L246:
	cmpl $119,%eax
	jz L228
L247:
	cmpl $63,%eax
	jnz L219
	jz L231
L228:
	movb $1,_w_flag(%rip)
	jmp L219
L226:
	movb $1,_g_flag(%rip)
	jmp L219
L221:
	movl _optind(%rip),%ebx
	subl %ebx,%r12d
	movslq %ebx,%rbx
	cmpl $2,%r12d
	jz L235
L231:
	pushq $L243
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $-1,%eax
	jmp L218
L235:
	movq 8(%r13,%rbx,8),%rdi
	movq %rdi,_out_path(%rip)
	movl $L240,%esi
	call _fopen
	movq %rax,_out_f(%rip)
	testq %rax,%rax
	jnz L239
L237:
	pushq _out_path(%rip)
	pushq $L241
	pushq $0
	pushq $2
	call _error
	addq $32,%rsp
L239:
	call _init_arenas
	call _seed_types
	xorl %edi,%edi
	call _enter_scope
	call _seed_keywords
	movq (%r13,%rbx,8),%rdi
	call _init_lex
	call _externals
	call _out_literals
	movl $_tentative,%edx
	movl $268435456,%esi
	movl $1,%edi
	call _walk_scope
	call _out_globls
	movq _out_f(%rip),%rdi
	call _fclose
	xorl %eax,%eax
L218:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L124:
 .byte 0
L17:
 .byte 37,100,0
L181:
 .byte 32,96,37,46,42,115,39,0
L33:
 .byte 37,108,100,0
L151:
 .byte 40,37,115,32,0
L222:
 .byte 103,107,119,0
L104:
 .byte 96,37,46,42,115,39,58,32
 .byte 0
L71:
 .byte 46,100,97,116,97,10,0
L79:
 .byte 87,65,82,78,73,78,71,0
L243:
 .byte 117,115,97,103,101,58,32,99
 .byte 99,49,32,91,32,45,103,119
 .byte 32,93,32,105,110,112,117,116
 .byte 32,111,117,116,112,117,116,10
 .byte 0
L173:
 .byte 117,110,105,111,110,0
L126:
 .byte 118,111,108,97,116,105,108,101
 .byte 0
L100:
 .byte 37,115,58,32,0
L81:
 .byte 83,89,83,84,69,77,32,69
 .byte 82,82,79,82,0
L241:
 .byte 99,97,110,39,116,32,111,112
 .byte 101,110,32,111,117,116,112,117
 .byte 116,32,96,37,115,39,0
L80:
 .byte 83,79,82,82,89,0
L83:
 .byte 69,82,82,79,82,0
L176:
 .byte 101,110,117,109,0
L123:
 .byte 99,111,110,115,116,0
L50:
 .byte 37,46,42,115,0
L190:
 .byte 32,40,37,115,41,0
L25:
 .byte 37,115,0
L125:
 .byte 32,0
L28:
 .byte 48,120,37,120,0
L161:
 .byte 97,116,32,108,105,110,101,32
 .byte 37,100,41,0
L152:
 .byte 100,101,102,105,110,101,100,0
L127:
 .byte 115,0
L45:
 .byte 76,37,100,0
L149:
 .byte 40,98,117,105,108,116,45,105
 .byte 110,41,0
L240:
 .byte 119,0
L98:
 .byte 32,40,37,100,41,0
L42:
 .byte 37,43,108,100,0
L160:
 .byte 105,110,32,96,37,46,42,115
 .byte 39,32,0
L82:
 .byte 73,78,84,69,82,78,65,76
 .byte 32,69,82,82,79,82,0
L53:
 .byte 48,120,37,108,120,0
L153:
 .byte 102,105,114,115,116,32,115,101
 .byte 101,110,0
L99:
 .byte 58,32,0
L170:
 .byte 115,116,114,117,99,116,0
L122:
 .byte 96,37,115,37,115,37,115,96
 .byte 32,113,117,97,108,105,102,105
 .byte 101,114,37,115,0
L70:
 .byte 46,116,101,120,116,10,0
L20:
 .byte 37,102,0
.comm _g_flag, 1, 1
.comm _w_flag, 1, 1
.comm _last_asmlab, 4, 4
.comm _out_f, 8, 8
.local _out_path
.comm _out_path, 8, 8

.globl _errno
.globl _print_token
.globl _enter_scope
.globl _error
.globl _fopen
.globl _out_globls
.globl _last_asmlab
.globl _print_reg
.globl _optind
.globl _path
.globl _print_k
.globl _line_no
.globl _print_global
.globl _g_flag
.globl _w_flag
.globl _seed_keywords
.globl ___flushbuf
.globl _out
.globl _unlink
.globl _strerror
.globl ___stderr
.globl _walk_scope
.globl _seg
.globl _seed_types
.globl _out_f
.globl _tentative
.globl _fclose
.globl _out_literals
.globl _getopt
.globl _externals
.globl _fputs
.globl _init_lex
.globl _main
.globl _exit
.globl _fprintf
.globl _init_arenas
