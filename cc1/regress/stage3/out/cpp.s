.text

_error:
L1:
	pushq %rbp
	movq %rsp,%rbp
L2:
	movq 16(%rbp),%rax
	movq %rax,16(%rbp)
	movq _input_stack(%rip),%rax
	testq %rax,%rax
	jz L5
L4:
	testl $1,8(%rax)
	jz L9
L8:
	addq $9,%rax
	jmp L10
L9:
	movq 24(%rax),%rax
L10:
	pushq %rax
	pushq $L7
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movq _input_stack(%rip),%rax
	movl 32(%rax),%eax
	testl %eax,%eax
	jz L6
L11:
	pushq %rax
	pushq $L14
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	jmp L6
L5:
	pushq $L15
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L6:
	pushq $L16
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	leaq 24(%rbp),%rdx
	movq 16(%rbp),%rsi
	movl $___stderr,%edi
	call _vfprintf
	movl $___stderr,%esi
	movl $10,%edi
	call _fputc
	movq _out_fp(%rip),%rdi
	testq %rdi,%rdi
	jz L19
L17:
	call _fclose
	movq _out_path(%rip),%rdi
	call _remove
L19:
	movl $1,%edi
	call _exit
L3:
	popq %rbp
	ret 


_safe_malloc:
L20:
	pushq %rbx
L21:
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L25
L23:
	pushq $L26
	call _error
	addq $8,%rsp
L25:
	movq %rbx,%rax
L22:
	popq %rbx
	ret 


_parentheses:
L28:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L29:
	movq _input_stack(%rip),%rax
	movq %rdi,%r14
	movq %rsi,%r13
	xorl %r12d,%r12d
	movl 32(%rax),%ebx
L32:
	movq 32(%r13),%rsi
	xorl %edx,%edx
	xorl %eax,%eax
L36:
	testq %rsi,%rsi
	jz L38
L39:
	cmpl $51,(%rsi)
	jnz L38
L37:
	movq 32(%rsi),%rsi
	incl %eax
	jmp L36
L38:
	testq %rsi,%rsi
	jz L43
L45:
	cmpl $536870927,(%rsi)
	jnz L73
L55:
	testq %rsi,%rsi
	jz L58
L60:
	movl (%rsi),%ecx
	cmpl $536870927,%ecx
	jnz L68
L66:
	incl %edx
L68:
	cmpl $536870928,%ecx
	jnz L71
L69:
	decl %edx
L71:
	movq 32(%rsi),%rsi
	incl %eax
	testl %edx,%edx
	jnz L55
	jz L30
L58:
	movq %r14,%rsi
	xorl %edi,%edi
	call _input_tokens
	cmpl $-1,%eax
	jnz L32
L61:
	movq _input_stack(%rip),%rax
	movl %ebx,32(%rax)
	pushq $L64
	call _error
	addq $8,%rsp
	jmp L32
L43:
	movq %r14,%rsi
	xorl %edi,%edi
	call _input_tokens
	cmpl $-1,%eax
	jz L73
L48:
	movl $-1,%r12d
	jmp L32
L73:
	movl %r12d,%eax
L30:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_replace:
L74:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L75:
	movq %rdi,%r14
	leaq -16(%rbp),%r13
	xorl %eax,%eax
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movq $0,-16(%rbp)
	movq %r13,-8(%rbp)
	xorl %r12d,%r12d
	movq (%r14),%rbx
	cmpl $52,(%rbx)
	jnz L115
L79:
	leaq 8(%rbx),%rdi
	call _macro_lookup
	testq %rax,%rax
	jz L115
L84:
	movl 24(%rax),%eax
	testl $1,%eax
	jz L86
L115:
	xorl %eax,%eax
	jmp L76
L86:
	testl $2147483648,%eax
	jz L96
L89:
	movq %rbx,%rsi
	movq %r14,%rdi
	call _parentheses
	movl %eax,%r12d
	cmpl $0,%eax
	jle L76
L96:
	movq (%r14),%rcx
	testq %rcx,%rcx
	jz L101
L99:
	movq -8(%rbp),%rax
	movq %rcx,(%rax)
	movq -8(%rbp),%rcx
	movq (%r14),%rax
	movq %rcx,40(%rax)
	movq 8(%r14),%rax
	movq %rax,-8(%rbp)
	movq $0,(%r14)
	movq %r14,8(%r14)
L101:
	leal 1(%r12),%edx
	leaq -16(%rbp),%rsi
	movq %r14,%rdi
	call _list_move
	movq %r14,%rdi
	call _macro_replace
	movq -16(%rbp),%rcx
	testq %rcx,%rcx
	jz L110
L108:
	movq 8(%r14),%rax
	movq %rcx,(%rax)
	movq 8(%r14),%rcx
	movq -16(%rbp),%rax
	movq %rcx,40(%rax)
	movq -8(%rbp),%rax
	movq %rax,8(%r14)
	movq $0,-16(%rbp)
	movq %r13,-8(%rbp)
L110:
	movl $1,%eax
L76:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_output:
L116:
	pushq %rbx
L117:
	movq (%rdi),%rbx
	movq 32(%rbx),%rcx
	movq 40(%rbx),%rax
	testq %rcx,%rcx
	jz L123
L122:
	movq %rax,40(%rcx)
	jmp L124
L123:
	movq %rax,8(%rdi)
L124:
	movq 32(%rbx),%rcx
	movq 40(%rbx),%rax
	movq %rcx,(%rax)
	movl (%rbx),%eax
	testl $2147483648,%eax
	jz L127
L125:
	pushq %rax
	pushq $L128
	call _error
	addq $16,%rsp
L127:
	movl _last_class(%rip),%edi
	testl %edi,%edi
	jz L131
L132:
	movl (%rbx),%esi
	call _token_separate
	testl %eax,%eax
	jz L131
L133:
	movq _out_fp(%rip),%rsi
	movl $32,%edi
	call _fputc
L131:
	movl 8(%rbx),%eax
	movl %eax,%ecx
	andl $1,%ecx
	jz L140
L139:
	shll $24,%eax
	sarl $25,%eax
	movslq %eax,%rax
	jmp L141
L140:
	movq 16(%rbx),%rax
L141:
	testq %rax,%rax
	jz L138
L136:
	testl %ecx,%ecx
	jz L143
L142:
	leaq 9(%rbx),%rdi
	jmp L144
L143:
	movq 24(%rbx),%rdi
L144:
	movq _out_fp(%rip),%rsi
	call _fputs
	movl (%rbx),%eax
	movl %eax,_last_class(%rip)
L138:
	movq %rbx,%rdi
	call _token_free
L118:
	popq %rbx
	ret 

.data
.align 4
L148:
	.int 1
.text

_resync:
L145:
L146:
	cmpb $0,_need_resync(%rip)
	jnz L153
L156:
	movq _input_stack(%rip),%rax
	movl 32(%rax),%eax
	movl L148(%rip),%ecx
	cmpl %ecx,%eax
	jl L153
L158:
	subl $20,%eax
	cmpl %eax,%ecx
	jge L164
L153:
	movq _input_stack(%rip),%rcx
	movl 32(%rcx),%eax
	movl %eax,L148(%rip)
	testl $1,8(%rcx)
	jz L162
L161:
	addq $9,%rcx
	jmp L163
L162:
	movq 24(%rcx),%rcx
L163:
	pushq %rcx
	pushq %rax
	pushq $L160
	pushq _out_fp(%rip)
	call _fprintf
	addq $32,%rsp
	movb $0,_need_resync(%rip)
L167:
	movl $0,_last_class(%rip)
L164:
	movq _input_stack(%rip),%rax
	movl 32(%rax),%eax
	cmpl %eax,L148(%rip)
	jl L165
L147:
	ret 
L165:
	movq _out_fp(%rip),%rsi
	movl $10,%edi
	call _fputc
	incl L148(%rip)
	jmp L167


_loop:
L168:
	pushq %rbp
	movq %rsp,%rbp
	subq $16,%rsp
	pushq %rbx
L169:
	leaq -16(%rbp),%rcx
	xorl %eax,%eax
	movq %rax,-16(%rbp)
	movq %rax,-8(%rbp)
	movq $0,-16(%rbp)
	movq %rcx,-8(%rbp)
	movq _input_stack(%rip),%rax
	testl $1,8(%rax)
	jz L173
L172:
	addq $9,%rax
	jmp L174
L173:
	movq 24(%rax),%rax
L174:
	pushq %rax
	pushq $L171
	pushq _out_fp(%rip)
	call _fprintf
	addq $24,%rsp
	movb $0,_need_resync(%rip)
L175:
	cmpq $0,-16(%rbp)
	jnz L187
L182:
	leaq -16(%rbp),%rsi
	movl $1,%edi
	call _input_tokens
	cmpl $-1,%eax
	jz L183
L187:
	cmpq $0,-16(%rbp)
	jz L175
L188:
	leaq -16(%rbp),%rdi
	call _directive
L190:
	cmpq $0,-16(%rbp)
	jz L187
L191:
	call _resync
	leaq -16(%rbp),%rdi
	call _replace
	movl %eax,%ebx
	cmpl $1,%ebx
	jz L190
L195:
	leaq -16(%rbp),%rdi
	call _output
	cmpl $-1,%ebx
	jnz L190
	jz L187
L183:
	movq _out_fp(%rip),%rsi
	movl $10,%edi
	call _fputc
L170:
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 


_main:
L201:
	pushq %rbx
	pushq %r12
	pushq %r13
L202:
	movl %edi,%r13d
	movq %rsi,%rbx
	call _macro_predef
L204:
	movl $L207,%edx
	movq %rbx,%rsi
	movl %r13d,%edi
	call _getopt
	cmpl $-1,%eax
	jz L206
L205:
	cmpl $120,%eax
	jz L211
L232:
	cmpl $73,%eax
	jz L213
L233:
	cmpl $68,%eax
	jnz L217
L215:
	movq _optarg(%rip),%rdi
	call _macro_cmdline
	jmp L204
L213:
	movq _optarg(%rip),%rdi
	call _input_dir
	jmp L204
L211:
	movb $1,_cxx_mode(%rip)
	jmp L204
L206:
	movl _optind(%rip),%eax
	subl %eax,%r13d
	cmpl $2,%r13d
	jnz L219
L221:
	incl %eax
	movslq %eax,%rax
	movq (%rbx,%rax,8),%rdi
	movq %rdi,_out_path(%rip)
	movl $L224,%esi
	call _fopen
	movq %rax,_out_fp(%rip)
	testq %rax,%rax
	jnz L227
L225:
	pushq _out_path(%rip)
	pushq $L228
	call _error
	addq $16,%rsp
L227:
	movslq _optind(%rip),%rax
	xorl %esi,%esi
	movq (%rbx,%rax,8),%rdi
	call _input_open
	call _loop
	movq _out_fp(%rip),%rdi
	call _fclose
	xorl %r12d,%r12d
	jmp L203
L219:
	pushq $L222
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
L217:
	pushq $L230
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $1,%edi
	call _exit
L203:
	movl %r12d,%eax
	popq %r13
	popq %r12
	popq %rbx
	ret 

L207:
 .byte 120,73,58,68,58,0
L160:
 .byte 10,35,32,37,100,32,34,37
 .byte 115,34,10,0
L15:
 .byte 99,112,112,0
L228:
 .byte 99,97,110,39,116,32,111,112
 .byte 101,110,32,111,117,116,112,117
 .byte 116,32,39,37,115,39,0
L64:
 .byte 117,110,116,101,114,109,105,110
 .byte 97,116,101,100,32,109,97,99
 .byte 114,111,32,97,114,103,117,109
 .byte 101,110,116,32,108,105,115,116
 .byte 0
L26:
 .byte 111,117,116,32,111,102,32,109
 .byte 101,109,111,114,121,0
L128:
 .byte 67,80,80,32,73,78,84,69
 .byte 82,78,65,76,58,32,97,116
 .byte 116,101,109,112,116,32,116,111
 .byte 32,111,117,116,112,117,116,32
 .byte 110,111,110,45,116,101,120,116
 .byte 32,116,111,107,101,110,32,37
 .byte 120,0
L224:
 .byte 119,0
L14:
 .byte 32,40,37,100,41,0
L222:
 .byte 99,112,112,58,32,105,110,99
 .byte 111,114,114,101,99,116,32,110
 .byte 117,109,98,101,114,32,111,102
 .byte 32,97,114,103,117,109,101,110
 .byte 116,115,10,0
L171:
 .byte 35,32,49,32,34,37,115,34
 .byte 10,0
L16:
 .byte 32,69,82,82,79,82,58,32
 .byte 0
L7:
 .byte 39,37,115,39,0
L230:
 .byte 117,115,97,103,101,58,32,99
 .byte 112,112,32,123,60,111,112,116
 .byte 105,111,110,62,125,32,60,105
 .byte 110,112,117,116,62,32,60,111
 .byte 117,116,112,117,116,62,10,10
 .byte 111,112,116,105,111,110,115,58
 .byte 10,32,32,32,45,120,32,32
 .byte 32,32,32,32,32,32,32,32
 .byte 32,32,32,32,32,32,32,32
 .byte 32,32,32,32,114,101,99,111
 .byte 103,110,105,122,101,32,67,43
 .byte 43,32,99,111,109,109,101,110
 .byte 116,115,32,97,110,100,32,116
 .byte 111,107,101,110,115,10,32,32
 .byte 32,45,73,60,100,105,114,62
 .byte 32,32,32,32,32,32,32,32
 .byte 32,32,32,32,32,32,32,32
 .byte 32,97,100,100,32,60,100,105
 .byte 114,62,32,116,111,32,115,121
 .byte 115,116,101,109,32,105,110,99
 .byte 108,117,100,101,32,112,97,116
 .byte 104,115,10,32,32,32,45,68
 .byte 60,110,97,109,101,62,91,61
 .byte 60,118,97,108,117,101,62,93
 .byte 32,32,32,32,32,32,100,101
 .byte 102,105,110,101,32,109,97,99
 .byte 114,111,32,40,100,101,102,97
 .byte 117,108,116,32,118,97,108,117
 .byte 101,32,105,115,32,49,41,10
 .byte 0
.comm _need_resync, 1, 1
.comm _cxx_mode, 1, 1
.local _out_fp
.comm _out_fp, 8, 8
.local _out_path
.comm _out_path, 8, 8
.comm _last_class, 4, 4

.globl _input_dir
.globl _last_class
.globl _optarg
.globl _macro_replace
.globl _error
.globl _fopen
.globl _malloc
.globl _macro_cmdline
.globl _cxx_mode
.globl _optind
.globl _token_separate
.globl _safe_malloc
.globl _fputc
.globl _directive
.globl _remove
.globl _input_tokens
.globl _input_open
.globl _vfprintf
.globl _need_resync
.globl ___stderr
.globl _fclose
.globl _token_free
.globl _getopt
.globl _macro_lookup
.globl _fputs
.globl _macro_predef
.globl _list_move
.globl _main
.globl _exit
.globl _input_stack
.globl _fprintf
