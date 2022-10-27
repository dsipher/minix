.data
.align 8
_proc:
	.int 258
	.fill 4, 1, 0
	.quad L1
	.quad 0
	.int 280
	.fill 4, 1, 0
	.quad L2
	.quad L3
	.int 279
	.fill 4, 1, 0
	.quad L2
	.quad L4
	.int 343
	.fill 4, 1, 0
	.quad L2
	.quad L5
	.int 287
	.fill 4, 1, 0
	.quad L6
	.quad L7
	.int 282
	.fill 4, 1, 0
	.quad L6
	.quad L8
	.int 285
	.fill 4, 1, 0
	.quad L6
	.quad L9
	.int 286
	.fill 4, 1, 0
	.quad L6
	.quad L10
	.int 283
	.fill 4, 1, 0
	.quad L6
	.quad L11
	.int 284
	.fill 4, 1, 0
	.quad L6
	.quad L12
	.int 264
	.fill 4, 1, 0
	.quad L13
	.quad 0
	.int 348
	.fill 4, 1, 0
	.quad L14
	.quad L15
	.int 340
	.fill 4, 1, 0
	.quad L16
	.quad L16
	.int 299
	.fill 4, 1, 0
	.quad L17
	.quad L17
	.int 300
	.fill 4, 1, 0
	.quad L18
	.quad L18
	.int 302
	.fill 4, 1, 0
	.quad L19
	.quad L19
	.int 322
	.fill 4, 1, 0
	.quad L20
	.quad L21
	.int 307
	.fill 4, 1, 0
	.quad L22
	.quad L23
	.int 308
	.fill 4, 1, 0
	.quad L22
	.quad L24
	.int 309
	.fill 4, 1, 0
	.quad L22
	.quad L25
	.int 310
	.fill 4, 1, 0
	.quad L22
	.quad L26
	.int 311
	.fill 4, 1, 0
	.quad L22
	.quad L27
	.int 344
	.fill 4, 1, 0
	.quad L22
	.quad L28
	.int 345
	.fill 4, 1, 0
	.quad L22
	.quad L29
	.int 327
	.fill 4, 1, 0
	.quad L30
	.quad L31
	.int 326
	.fill 4, 1, 0
	.quad L30
	.quad L31
	.int 329
	.fill 4, 1, 0
	.quad L30
	.quad L32
	.int 328
	.fill 4, 1, 0
	.quad L30
	.quad L32
	.int 342
	.fill 4, 1, 0
	.quad L33
	.quad L34
	.int 259
	.fill 4, 1, 0
	.quad L35
	.quad 0
	.int 260
	.fill 4, 1, 0
	.quad L36
	.quad 0
	.int 265
	.fill 4, 1, 0
	.quad L37
	.quad L38
	.int 266
	.fill 4, 1, 0
	.quad L37
	.quad L39
	.int 304
	.fill 4, 1, 0
	.quad L37
	.quad L37
	.int 324
	.fill 4, 1, 0
	.quad L40
	.quad L40
	.int 321
	.fill 4, 1, 0
	.quad L41
	.quad L42
	.int 320
	.fill 4, 1, 0
	.quad L43
	.quad L44
	.int 292
	.fill 4, 1, 0
	.quad L45
	.quad L45
	.int 294
	.fill 4, 1, 0
	.quad L46
	.quad L46
	.int 339
	.fill 4, 1, 0
	.quad L47
	.quad L47
	.int 312
	.fill 4, 1, 0
	.quad L48
	.quad L49
	.int 314
	.fill 4, 1, 0
	.quad L48
	.quad L50
	.int 315
	.fill 4, 1, 0
	.quad L48
	.quad L51
	.int 316
	.fill 4, 1, 0
	.quad L48
	.quad L52
	.int 317
	.fill 4, 1, 0
	.quad L48
	.quad L53
	.int 318
	.fill 4, 1, 0
	.quad L48
	.quad L54
	.int 319
	.fill 4, 1, 0
	.quad L48
	.quad L55
	.int 325
	.fill 4, 1, 0
	.quad L56
	.quad L57
	.int 301
	.fill 4, 1, 0
	.quad L58
	.quad L59
	.int 341
	.fill 4, 1, 0
	.quad L60
	.quad L61
	.int 297
	.fill 4, 1, 0
	.quad L62
	.quad L63
	.int 295
	.fill 4, 1, 0
	.quad L64
	.quad L65
	.int 288
	.fill 4, 1, 0
	.quad L66
	.quad L66
	.int 305
	.fill 4, 1, 0
	.quad L67
	.quad L68
	.int 306
	.fill 4, 1, 0
	.quad L67
	.quad L69
	.int 296
	.fill 4, 1, 0
	.quad L67
	.quad L70
	.int 291
	.fill 4, 1, 0
	.quad L67
	.quad L71
	.int 293
	.fill 4, 1, 0
	.quad L67
	.quad L72
	.int 338
	.fill 4, 1, 0
	.quad L67
	.quad L73
	.int 290
	.fill 4, 1, 0
	.quad L74
	.quad L74
	.int 333
	.fill 4, 1, 0
	.quad L75
	.quad L75
	.int 289
	.fill 4, 1, 0
	.quad L76
	.quad L76
	.int 332
	.fill 4, 1, 0
	.quad L77
	.quad L78
	.int 337
	.fill 4, 1, 0
	.quad L79
	.quad L80
	.int 0
	.fill 4, 1, 0
	.quad L81
	.quad L81
.text

_main:
L82:
	pushq %rbp
	movq %rsp,%rbp
	subq $608,%rsp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L83:
	pushq $L85
	call _printf
	pushq $L86
	call _printf
	pushq $L87
	call _printf
	addq $24,%rsp
	movl $93,%ecx
	jmp L88
L89:
	movslq %ecx,%rax
	movq $L81,_names(,%rax,8)
L88:
	decl %ecx
	jns L89
L91:
	movl $L96,%esi
	movl $L95,%edi
	call _fopen
	movq %rax,%r13
	testq %r13,%r13
	jnz L94
L92:
	pushq $L97
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $1,%edi
	call _exit
L94:
	pushq $93
	pushq $L98
	call _printf
	addq $16,%rsp
	xorl %r14d,%r14d
L99:
	leaq -200(%rbp),%r12
	movq %r13,%rdx
	movl $200,%esi
	leaq -200(%rbp),%rdi
	call _fgets
	testq %rax,%rax
	jz L101
L100:
	leaq -201(%rbp),%rdx
	leaq -401(%rbp),%rcx
	leaq -601(%rbp),%rbx
	leaq -608(%rbp),%rax
	pushq %rax
	pushq %rbx
	pushq %rcx
	pushq %rdx
	pushq $L102
	pushq %r12
	call _sscanf
	addq $48,%rsp
	cmpb $35,-201(%rbp)
	jnz L99
L107:
	cmpl $4,%eax
	jz L105
L111:
	movl $L106,%esi
	leaq -401(%rbp),%rdi
	call _strcmp
	testl %eax,%eax
	jnz L99
L105:
	movl -608(%rbp),%eax
	cmpl $257,%eax
	jl L99
L119:
	cmpl $349,%eax
	jg L99
L118:
	leaq -601(%rbp),%rdi
	call _strlen
	leaq 1(%rax),%rdi
	call _malloc
	movl -608(%rbp),%ecx
	subl $257,%ecx
	movslq %ecx,%rcx
	movq %rax,_names(,%rcx,8)
	movl -608(%rbp),%eax
	subl $257,%eax
	movslq %eax,%rax
	leaq -601(%rbp),%rsi
	movq _names(,%rax,8),%rdi
	call _strcpy
	movl -608(%rbp),%eax
	pushq %rax
	pushq %rbx
	pushq $L124
	call _printf
	addq $24,%rsp
	incl %r14d
	jmp L99
L101:
	pushq $L125
	call _printf
	addq $8,%rsp
	movl $_proc,%edx
	jmp L126
L127:
	movq 8(%rdx),%rcx
	subl $257,%eax
	movslq %eax,%rax
	movq %rcx,_table(,%rax,8)
	addq $24,%rdx
L126:
	movl (%rdx),%eax
	testl %eax,%eax
	jnz L127
L129:
	pushq $93
	pushq $L130
	call _printf
	addq $16,%rsp
	xorl %ebx,%ebx
L132:
	movq _table(,%rbx,8),%rax
	testq %rax,%rax
	jnz L136
L135:
	pushq _names(,%rbx,8)
	pushq $L138
	call _printf
	addq $16,%rsp
	jmp L137
L136:
	pushq _names(,%rbx,8)
	pushq %rax
	pushq $L139
	call _printf
	addq $24,%rsp
L137:
	incl %ebx
	cmpl $93,%ebx
	jl L132
L134:
	pushq $L125
	call _printf
	pushq $L140
	call _printf
	pushq $L141
	call _printf
	pushq $L142
	call _printf
	pushq $L143
	call _printf
	pushq $L144
	call _printf
	pushq $L145
	call _printf
	pushq $L146
	call _printf
	pushq $L147
	call _printf
	pushq $L148
	call _printf
	addq $80,%rsp
	xorl %eax,%eax
L84:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	movq %rbp,%rsp
	popq %rbp
	ret 

L81:
	.byte 0
L78:
	.byte 78,70,0
L56:
	.byte 99,111,110,100,101,120,112,114
	.byte 0
L5:
	.byte 32,33,0
L46:
	.byte 97,119,107,100,101,108,101,116
	.byte 101,0
L31:
	.byte 43,43,0
L27:
	.byte 32,37,32,0
L95:
	.byte 121,46,116,97,98,46,104,0
L144:
	.byte 9,9,115,112,114,105,110,116
	.byte 102,40,98,117,102,44,32,34
	.byte 116,111,107,101,110,32,37,37
	.byte 100,34,44,32,110,41,59,10
	.byte 0
L62:
	.byte 102,111,114,115,116,97,116,0
L15:
	.byte 36,40,0
L49:
	.byte 32,61,32,0
L44:
	.byte 112,114,105,110,116,0
L85:
	.byte 35,105,110,99,108,117,100,101
	.byte 32,60,115,116,100,105,111,46
	.byte 104,62,10,0
L14:
	.byte 105,110,100,105,114,101,99,116
	.byte 0
L76:
	.byte 97,114,103,0
L59:
	.byte 105,102,40,0
L22:
	.byte 97,114,105,116,104,0
L48:
	.byte 97,115,115,105,103,110,0
L74:
	.byte 98,108,116,105,110,0
L66:
	.byte 105,110,115,116,97,116,0
L8:
	.byte 32,61,61,32,0
L43:
	.byte 112,114,105,110,116,115,116,97
	.byte 116,0
L9:
	.byte 32,60,61,32,0
L139:
	.byte 9,37,115,44,9,47,42,32
	.byte 37,115,32,42,47,10,0
L16:
	.byte 115,117,98,115,116,114,0
L13:
	.byte 97,114,114,97,121,0
L141:
	.byte 123,10,0
L80:
	.byte 103,101,116,108,105,110,101,0
L36:
	.byte 100,111,112,97,50,0
L65:
	.byte 100,111,0
L11:
	.byte 32,62,61,32,0
L26:
	.byte 32,47,32,0
L10:
	.byte 32,60,32,0
L143:
	.byte 9,105,102,32,40,110,32,60
	.byte 32,70,73,82,83,84,84,79
	.byte 75,69,78,32,124,124,32,110
	.byte 32,62,32,76,65,83,84,84
	.byte 79,75,69,78,41,32,123,10
	.byte 0
L79:
	.byte 97,119,107,103,101,116,108,105
	.byte 110,101,0
L42:
	.byte 112,114,105,110,116,102,0
L7:
	.byte 32,33,61,32,0
L146:
	.byte 9,125,10,0
L40:
	.byte 105,110,116,101,115,116,0
L54:
	.byte 32,37,61,32,0
L47:
	.byte 115,112,108,105,116,0
L57:
	.byte 32,63,58,32,0
L130:
	.byte 10,67,101,108,108,32,42,40
	.byte 42,112,114,111,99,116,97,98
	.byte 91,37,100,93,41,40,78,111
	.byte 100,101,32,42,42,44,32,105
	.byte 110,116,41,32,61,32,123,10
	.byte 0
L125:
	.byte 125,59,10,10,0
L72:
	.byte 99,111,110,116,105,110,117,101
	.byte 0
L148:
	.byte 125,10,0
L55:
	.byte 32,94,61,32,0
L6:
	.byte 114,101,108,111,112,0
L142:
	.byte 9,115,116,97,116,105,99,32
	.byte 99,104,97,114,32,98,117,102
	.byte 91,49,48,48,93,59,10,10
	.byte 0
L61:
	.byte 119,104,105,108,101,40,0
L19:
	.byte 115,105,110,100,101,120,0
L21:
	.byte 115,112,114,105,110,116,102,32
	.byte 0
L102:
	.byte 37,49,99,32,37,115,32,37
	.byte 115,32,37,100,0
L73:
	.byte 114,101,116,0
L34:
	.byte 32,0
L23:
	.byte 32,43,32,0
L30:
	.byte 105,110,99,114,100,101,99,114
	.byte 0
L20:
	.byte 97,119,107,115,112,114,105,110
	.byte 116,102,0
L1:
	.byte 112,114,111,103,114,97,109,0
L97:
	.byte 109,97,107,101,116,97,98,32
	.byte 99,97,110,39,116,32,111,112
	.byte 101,110,32,121,46,116,97,98
	.byte 46,104,33,10,0
L50:
	.byte 32,43,61,32,0
L24:
	.byte 32,45,32,0
L4:
	.byte 32,38,38,32,0
L33:
	.byte 99,97,116,0
L2:
	.byte 98,111,111,108,111,112,0
L96:
	.byte 114,0
L45:
	.byte 99,108,111,115,101,102,105,108
	.byte 101,0
L140:
	.byte 99,104,97,114,32,42,116,111
	.byte 107,110,97,109,101,40,105,110
	.byte 116,32,110,41,10,0
L58:
	.byte 105,102,115,116,97,116,0
L147:
	.byte 9,114,101,116,117,114,110,32
	.byte 112,114,105,110,116,110,97,109
	.byte 101,91,110,45,70,73,82,83
	.byte 84,84,79,75,69,78,93,59
	.byte 10,0
L37:
	.byte 109,97,116,99,104,111,112,0
L69:
	.byte 110,101,120,116,102,105,108,101
	.byte 0
L51:
	.byte 32,45,61,32,0
L70:
	.byte 101,120,105,116,0
L12:
	.byte 32,62,32,0
L53:
	.byte 32,47,61,32,0
L68:
	.byte 110,101,120,116,0
L38:
	.byte 32,126,32,0
L63:
	.byte 102,111,114,40,0
L145:
	.byte 9,9,114,101,116,117,114,110
	.byte 32,98,117,102,59,10,0
L71:
	.byte 98,114,101,97,107,0
L60:
	.byte 119,104,105,108,101,115,116,97
	.byte 116,0
L87:
	.byte 35,105,110,99,108,117,100,101
	.byte 32,34,121,46,116,97,98,46
	.byte 104,34,10,10,0
L32:
	.byte 45,45,0
L35:
	.byte 112,97,115,116,97,116,0
L41:
	.byte 97,119,107,112,114,105,110,116
	.byte 102,0
L98:
	.byte 115,116,97,116,105,99,32,99
	.byte 104,97,114,32,42,112,114,105
	.byte 110,116,110,97,109,101,91,37
	.byte 100,93,32,61,32,123,10,0
L29:
	.byte 32,42,42,0
L28:
	.byte 32,45,0
L86:
	.byte 35,105,110,99,108,117,100,101
	.byte 32,34,97,119,107,46,104,34
	.byte 10,0
L52:
	.byte 32,42,61,32,0
L64:
	.byte 100,111,115,116,97,116,0
L106:
	.byte 100,101,102,105,110,101,0
L25:
	.byte 32,42,32,0
L138:
	.byte 9,110,117,108,108,112,114,111
	.byte 99,44,9,47,42,32,37,115
	.byte 32,42,47,10,0
L124:
	.byte 9,40,99,104,97,114,32,42
	.byte 41,32,34,37,115,34,44,9
	.byte 47,42,32,37,100,32,42,47
	.byte 10,0
L3:
	.byte 32,124,124,32,0
L18:
	.byte 103,115,117,98,0
L75:
	.byte 99,97,108,108,0
L77:
	.byte 103,101,116,110,102,0
L39:
	.byte 32,33,126,32,0
L67:
	.byte 106,117,109,112,0
L17:
	.byte 115,117,98,0
.globl _table
.comm _table, 744, 8
.globl _names
.comm _names, 744, 8

.globl _fgets
.globl _fopen
.globl _malloc
.globl _names
.globl _printf
.globl _strcmp
.globl _table
.globl ___stderr
.globl _proc
.globl _sscanf
.globl _strlen
.globl _main
.globl _exit
.globl _strcpy
.globl _fprintf
