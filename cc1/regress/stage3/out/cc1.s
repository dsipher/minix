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
	movb (%rcx),%al
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
	js L69
	jns L68
L8:
	leaq 1(%rcx),%rax
	movq %rax,16(%rbp)
	movb 1(%rcx),%cl
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
	jmp L65
L24:
	addq $8,%rbx
	pushq -8(%rbx)
	pushq $L25
	jmp L65
L22:
	addq $8,%rbx
	xorl %edx,%edx
	movl -8(%rbx),%esi
	jmp L67
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
	jmp L64
L16:
	addq $8,%rbx
	movl -8(%rbx),%eax
	pushq %rax
	pushq $L17
	jmp L65
L52:
	addq $8,%rbx
	pushq -8(%rbx)
	pushq $L53
	jmp L65
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
L67:
	call _print_reg
	jmp L9
L44:
	addq $8,%rbx
	movl -8(%rbx),%eax
	pushq %rax
	pushq $L45
	jmp L65
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
	jmp L64
L37:
	pushq %r12
	jmp L66
L32:
	addq $8,%rbx
	pushq -8(%rbx)
L66:
	pushq $L33
L65:
	pushq %rdi
L64:
	call _fprintf
	addq $24,%rsp
	jmp L9
L13:
	decl (%rdi)
	movq _out_f(%rip),%rsi
	movq 16(%rbp),%rax
	js L69
L68:
	movb (%rax),%dl
	movq 24(%rsi),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%rsi)
	movb %dl,(%rcx)
	jmp L9
L69:
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

.local L73
.comm L73, 4, 4

_seg:
L70:
	pushq %rbx
L71:
	movl %edi,%ebx
	cmpl L73(%rip),%ebx
	jz L72
L74:
	cmpl $1,%ebx
	movl $L78,%eax
	movl $L77,%edi
	cmovnzq %rax,%rdi
	movq _out_f(%rip),%rsi
	call _fputs
	movl %ebx,L73(%rip)
L72:
	popq %rbx
	ret 

.data
.align 8
L85:
	.quad L86
	.quad L87
	.quad L88
	.quad L89
	.quad L90
.text

_error:
L82:
	pushq %rbp
	movq %rsp,%rbp
	pushq %rbx
	pushq %r12
	pushq %r13
L83:
	movl 16(%rbp),%r12d
	movq 24(%rbp),%rbx
	movq 32(%rbp),%rax
	movq %rax,32(%rbp)
	testl %r12d,%r12d
	jnz L93
L94:
	cmpb $0,_w_flag(%rip)
	jz L84
L93:
	movq _path(%rip),%rcx
	testq %rcx,%rcx
	jz L101
L99:
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L50
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl _line_no(%rip),%eax
	testl %eax,%eax
	jz L104
L102:
	pushq %rax
	pushq $L105
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L104:
	pushq $L106
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L101:
	movslq %r12d,%rax
	pushq L85(,%rax,8)
	pushq $L107
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	testq %rbx,%rbx
	jz L110
L108:
	movl 4(%rbx),%eax
	pushq 8(%rbx)
	pushq %rax
	pushq $L111
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L110:
	leaq 40(%rbp),%rbx
L112:
	movq 32(%rbp),%rcx
	movb (%rcx),%al
	testb %al,%al
	jz L114
L113:
	cmpb $37,%al
	jz L116
L115:
	decl ___stderr(%rip)
	js L119
L118:
	movb (%rcx),%dl
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb %dl,(%rcx)
	jmp L117
L119:
	movsbl (%rcx),%edi
	movl $___stderr,%esi
	jmp L223
L116:
	leaq 1(%rcx),%rax
	movq %rax,32(%rbp)
	movb 1(%rcx),%al
	cmpb $37,%al
	jz L190
L208:
	cmpb $75,%al
	jz L150
L209:
	cmpb $76,%al
	jz L152
L210:
	cmpb $83,%al
	jz L170
L211:
	cmpb $84,%al
	jz L172
L212:
	cmpb $100,%al
	jz L124
L213:
	cmpb $107,%al
	jz L126
L214:
	cmpb $113,%al
	jz L128
L215:
	cmpb $115,%al
	jnz L117
L148:
	addq $8,%rbx
	pushq -8(%rbx)
	pushq $L25
	jmp L225
L128:
	addq $8,%rbx
	movq -8(%rbx),%rcx
	testq $131072,%rcx
	movl $L131,%eax
	movl $L130,%edi
	cmovzq %rax,%rdi
	cmpq $393216,%rcx
	movl $L131,%eax
	movl $L132,%esi
	cmovnzq %rax,%rsi
	testq $262144,%rcx
	movl $L131,%eax
	movl $L133,%edx
	cmovzq %rax,%rdx
	cmpq $393216,%rcx
	movl $L131,%eax
	movl $L134,%ecx
	cmovnzq %rax,%rcx
	pushq %rcx
	pushq %rdx
	pushq %rsi
	pushq %rdi
	pushq $L129
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
	jmp L117
L126:
	addq $8,%rbx
	movl -8(%rbx),%esi
	movl $___stderr,%edi
	call _print_k
	jmp L117
L124:
	addq $8,%rbx
	movl -8(%rbx),%eax
	pushq %rax
	pushq $L17
	jmp L225
L172:
	addq $8,%rbx
	movq -8(%rbx),%r13
	movl 12(%r13),%eax
	andl $8191,%eax
	cmpl $1,%eax
	jz L176
L219:
	cmpl $2,%eax
	jz L179
L220:
	cmpl $4,%eax
	jnz L174
L182:
	movl $___stderr,%esi
	movl $L183,%edi
	jmp L226
L179:
	movl $___stderr,%esi
	movl $L180,%edi
	jmp L226
L176:
	movl $___stderr,%esi
	movl $L177,%edi
L226:
	call _fputs
L174:
	movq (%r13),%rcx
	testq %rcx,%rcx
	jz L117
L185:
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L188
	jmp L224
L170:
	addq $8,%rbx
	movq -8(%rbx),%rcx
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L50
L224:
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	jmp L117
L152:
	addq $8,%rbx
	movq -8(%rbx),%r13
	movl 12(%r13),%eax
	testl $2147483648,%eax
	jnz L153
L155:
	testl $1073741824,%eax
	movl $L160,%eax
	movl $L159,%ecx
	cmovzq %rax,%rcx
	pushq %rcx
	pushq $L158
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movq 24(%r13),%rcx
	cmpq %rcx,_path(%rip)
	jz L166
L164:
	movl 4(%rcx),%eax
	pushq 8(%rcx)
	pushq %rax
	pushq $L167
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L166:
	movl 20(%r13),%eax
	pushq %rax
	pushq $L168
L225:
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L117
L153:
	movl $___stderr,%esi
	movl $L156,%edi
	call _fputs
	jmp L117
L150:
	addq $8,%rbx
	movq -8(%rbx),%rsi
	movl $___stderr,%edi
	call _print_token
	jmp L117
L190:
	decl ___stderr(%rip)
	js L192
L191:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $37,(%rcx)
	jmp L117
L192:
	movl $___stderr,%esi
	movl $37,%edi
L223:
	call ___flushbuf
L117:
	incq 32(%rbp)
	jmp L112
L114:
	cmpl $2,%r12d
	jnz L196
L194:
	movl _errno(%rip),%edi
	call _strerror
	pushq %rax
	pushq $L197
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L196:
	decl ___stderr(%rip)
	js L199
L198:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $10,(%rcx)
	jmp L200
L199:
	movl $___stderr,%esi
	movl $10,%edi
	call ___flushbuf
L200:
	cmpl $0,%r12d
	jle L84
L201:
	movq _out_f(%rip),%rdi
	testq %rdi,%rdi
	jz L206
L204:
	call _fclose
	movq _out_path(%rip),%rdi
	call _unlink
L206:
	movl $1,%edi
	call _exit
L84:
	popq %r13
	popq %r12
	popq %rbx
	popq %rbp
	ret 


_main:
L227:
	pushq %rbx
	pushq %r12
	pushq %r13
L228:
	movl %edi,%r12d
	movq %rsi,%r13
L230:
	movl $L233,%edx
	movq %r13,%rsi
	movl %r12d,%edi
	call _getopt
	cmpl $-1,%eax
	jz L232
L231:
	cmpl $103,%eax
	jz L237
L257:
	cmpl $119,%eax
	jz L239
L258:
	cmpl $63,%eax
	jnz L230
	jz L242
L239:
	movb $1,_w_flag(%rip)
	jmp L230
L237:
	movb $1,_g_flag(%rip)
	jmp L230
L232:
	movl _optind(%rip),%ebx
	subl %ebx,%r12d
	movslq %ebx,%rbx
	cmpl $2,%r12d
	jz L246
L242:
	pushq $L254
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $-1,%eax
	jmp L229
L246:
	movq 8(%r13,%rbx,8),%rdi
	movq %rdi,_out_path(%rip)
	movl $L251,%esi
	call _fopen
	movq %rax,_out_f(%rip)
	testq %rax,%rax
	jnz L250
L248:
	pushq _out_path(%rip)
	pushq $L252
	pushq $0
	pushq $2
	call _error
	addq $32,%rsp
L250:
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
L229:
	popq %r13
	popq %r12
	popq %rbx
	ret 

L131:
 .byte 0
L17:
 .byte 37,100,0
L188:
 .byte 32,96,37,46,42,115,39,0
L33:
 .byte 37,108,100,0
L158:
 .byte 40,37,115,32,0
L233:
 .byte 103,107,119,0
L111:
 .byte 96,37,46,42,115,39,58,32
 .byte 0
L78:
 .byte 46,100,97,116,97,10,0
L86:
 .byte 87,65,82,78,73,78,71,0
L254:
 .byte 117,115,97,103,101,58,32,99
 .byte 99,49,32,91,32,45,103,119
 .byte 32,93,32,105,110,112,117,116
 .byte 32,111,117,116,112,117,116,10
 .byte 0
L180:
 .byte 117,110,105,111,110,0
L133:
 .byte 118,111,108,97,116,105,108,101
 .byte 0
L107:
 .byte 37,115,58,32,0
L88:
 .byte 83,89,83,84,69,77,32,69
 .byte 82,82,79,82,0
L252:
 .byte 99,97,110,39,116,32,111,112
 .byte 101,110,32,111,117,116,112,117
 .byte 116,32,96,37,115,39,0
L87:
 .byte 83,79,82,82,89,0
L90:
 .byte 69,82,82,79,82,0
L183:
 .byte 101,110,117,109,0
L130:
 .byte 99,111,110,115,116,0
L50:
 .byte 37,46,42,115,0
L197:
 .byte 32,40,37,115,41,0
L25:
 .byte 37,115,0
L132:
 .byte 32,0
L28:
 .byte 48,120,37,120,0
L168:
 .byte 97,116,32,108,105,110,101,32
 .byte 37,100,41,0
L159:
 .byte 100,101,102,105,110,101,100,0
L134:
 .byte 115,0
L45:
 .byte 76,37,100,0
L156:
 .byte 40,98,117,105,108,116,45,105
 .byte 110,41,0
L251:
 .byte 119,0
L105:
 .byte 32,40,37,100,41,0
L42:
 .byte 37,43,108,100,0
L167:
 .byte 105,110,32,96,37,46,42,115
 .byte 39,32,0
L89:
 .byte 73,78,84,69,82,78,65,76
 .byte 32,69,82,82,79,82,0
L53:
 .byte 48,120,37,108,120,0
L160:
 .byte 102,105,114,115,116,32,115,101
 .byte 101,110,0
L106:
 .byte 58,32,0
L177:
 .byte 115,116,114,117,99,116,0
L129:
 .byte 96,37,115,37,115,37,115,96
 .byte 32,113,117,97,108,105,102,105
 .byte 101,114,37,115,0
L77:
 .byte 46,116,101,120,116,10,0
L20:
 .byte 37,102,0
.globl _g_flag
.comm _g_flag, 1, 1
.globl _w_flag
.comm _w_flag, 1, 1
.globl _last_asmlab
.comm _last_asmlab, 4, 4
.globl _out_f
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
