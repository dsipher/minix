.text

_describe:
L1:
L2:
	movl $___stderr,%esi
	movl $L4,%edi
	call _fputs
L3:
	ret 

.align 2
L72:
	.short L20-_options
	.short L24-_options
	.short L13-_options
	.short L13-_options
	.short L28-_options
	.short L13-_options
	.short L30-_options
	.short L32-_options
	.short L13-_options
	.short L34-_options
	.short L36-_options
	.short L38-_options
	.short L13-_options
	.short L40-_options
	.short L42-_options
	.short L13-_options
	.short L13-_options
	.short L46-_options
	.short L48-_options
	.short L13-_options
	.short L52-_options
	.short L13-_options
	.short L54-_options
	.short L13-_options
	.short L57-_options

_options:
L5:
	pushq %rbx
	pushq %r12
	pushq %r13
L6:
	movl %edi,%r12d
	movq %rsi,%rbx
	movl $20,_blocking(%rip)
	movl $L8,%edi
	call _getenv
	movq %rax,_ar_file(%rip)
	testq %rax,%rax
	jnz L13
L9:
	movq $L12,_ar_file(%rip)
L13:
	movl $L16,%edx
	movq %rbx,%rsi
	movl %r12d,%edi
	call _getoldopt
	cmpl $-1,%eax
	jz L15
L14:
	cmpl $98,%eax
	jl L61
L63:
	cmpl $122,%eax
	jg L61
L60:
	addl $-98,%eax
	movzwl L72(,%rax,2),%eax
	addl $_options,%eax
	jmp *%rax
L54:
	incb _f_extract(%rip)
	jmp L13
L52:
	jmp L73
L48:
	incb _f_list(%rip)
L73:
	incb _f_verbose(%rip)
	jmp L13
L46:
	incb _f_sorted_names(%rip)
	jmp L13
L42:
	incb _f_use_protection(%rip)
	jmp L13
L40:
	incb _f_oldarch(%rip)
	jmp L13
L38:
	incb _f_modified(%rip)
	jmp L13
L36:
	incb _f_local_filesys(%rip)
	jmp L13
L34:
	incb _f_keep(%rip)
	jmp L13
L32:
	incb _f_ignorez(%rip)
	jmp L13
L30:
	incb _f_follow_links(%rip)
	jmp L13
L28:
	movq _optarg(%rip),%rax
	movq %rax,_ar_file(%rip)
	jmp L13
L24:
	incb _f_create(%rip)
	jmp L13
L20:
	movq _optarg(%rip),%rdi
	call _atoi
	movl %eax,_blocking(%rip)
	jmp L13
L61:
	cmpl $63,%eax
	jz L59
	jl L13
L65:
	cmpl $90,%eax
	jz L57
	jg L13
L66:
	cmpb $66,%al
	jz L22
L67:
	cmpb $68,%al
	jz L26
L68:
	cmpb $82,%al
	jz L44
L69:
	cmpb $84,%al
	jnz L13
L50:
	movq _optarg(%rip),%rax
	movq %rax,_name_file(%rip)
	incb _f_namefile(%rip)
	jmp L13
L44:
	incb _f_sayblock(%rip)
	jmp L13
L26:
	incb _f_dironly(%rip)
	jmp L13
L22:
	incb _f_reblock(%rip)
	jmp L13
L57:
	incb _f_compress(%rip)
	jmp L13
L59:
	call _describe
	movl $1,%edi
	call _exit
	jmp L13
L15:
	movl _blocking(%rip),%eax
	shll $9,%eax
	movl %eax,_blocksize(%rip)
L7:
	movl %r13d,%eax
	popq %r13
	popq %r12
	popq %rbx
	ret 


_name_init:
L74:
L75:
	cmpb $0,_f_namefile(%rip)
	jz L78
L77:
	cmpl _optind(%rip),%edi
	jle L82
L80:
	pushq $L83
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $1,%edi
	call _exit
L82:
	movl $L12,%esi
	movq _name_file(%rip),%rdi
	call _strcmp
	testl %eax,%eax
	jnz L85
L84:
	movq $___stdin,_namef(%rip)
	ret
L85:
	movl $L87,%esi
	movq _name_file(%rip),%rdi
	call _fopen
	movq %rax,_namef(%rip)
	testq %rax,%rax
	jnz L76
L88:
	pushq $L91
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movq _name_file(%rip),%rdi
	call _perror
	movl $2,%edi
	call _exit
	ret
L78:
	movl %edi,_n_argc(%rip)
	movq %rsi,_n_argv(%rip)
L76:
	ret 

.local L95
.comm L95, 102, 1

_name_next:
L92:
	pushq %rbx
L93:
	cmpq $0,_namef(%rip)
	jz L96
L104:
	movq _namef(%rip),%rdx
	movl $101,%esi
	movl $L95,%edi
	call _fgets
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L124
L110:
	movq %rbx,%rdi
	call _strlen
	leaq (%rax,%rbx),%rcx
	decq %rcx
	cmpq %rcx,%rbx
	jae L104
L114:
	movb $0,-1(%rax,%rbx)
	leaq -2(%rax,%rbx),%rax
	jmp L116
L119:
	cmpb $47,(%rax)
	jnz L124
L117:
	movb $0,(%rax)
	decq %rax
L116:
	cmpq %rax,%rbx
	jb L119
L124:
	movq %rbx,%rax
	jmp L94
L96:
	movl _optind(%rip),%ecx
	cmpl _n_argc(%rip),%ecx
	jl L99
L101:
	xorl %eax,%eax
	jmp L94
L99:
	leal 1(%rcx),%eax
	movl %eax,_optind(%rip)
	movslq %ecx,%rcx
	movq _n_argv(%rip),%rax
	movq (%rax,%rcx,8),%rax
L94:
	popq %rbx
	ret 


_name_close:
L125:
L126:
	movq _namef(%rip),%rdi
	testq %rdi,%rdi
	jz L127
L131:
	cmpq $___stdin,%rdi
	jz L127
L128:
	call _fclose
L127:
	ret 


_addname:
L135:
	pushq %rbx
	pushq %r12
	pushq %r13
L136:
	movq %rdi,%r13
	movq %r13,%rdi
	call _strlen
	movl %eax,%r12d
	movslq %r12d,%r12
	leaq 20(%r12),%rdi
	call _malloc
	movq %rax,%rbx
	testq %rbx,%rbx
	jnz L140
L138:
	pushq $L141
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	movl $4,%edi
	call _exit
L140:
	movq $0,(%rbx)
	movw %r12w,8(%rbx)
	movq %r12,%rdx
	movq %r13,%rsi
	leaq 13(%rbx),%rdi
	call _strncpy
	movb $0,13(%r12,%rbx)
	movb $0,10(%rbx)
	movb $0,12(%rbx)
	movb $1,11(%rbx)
	movl $42,%esi
	movq %r13,%rdi
	call _strchr
	testq %rax,%rax
	jnz L142
L149:
	movl $91,%esi
	movq %r13,%rdi
	call _strchr
	testq %rax,%rax
	jnz L142
L145:
	movl $63,%esi
	movq %r13,%rdi
	call _strchr
	testq %rax,%rax
	jz L144
L142:
	movb $1,12(%rbx)
	movb (%r13),%al
	cmpb $42,%al
	jz L153
L160:
	cmpb $91,%al
	jz L153
L156:
	cmpb $63,%al
	jnz L144
L153:
	movb $0,11(%rbx)
L144:
	movq _namelast(%rip),%rax
	testq %rax,%rax
	jz L166
L164:
	movq %rbx,(%rax)
L166:
	movq %rbx,_namelast(%rip)
	cmpq $0,_namelist(%rip)
	jnz L137
L167:
	movq %rbx,_namelist(%rip)
L137:
	popq %r13
	popq %r12
	popq %rbx
	ret 

.local L173
.comm L173, 120, 8

_name_gather:
L170:
	pushq %rbx
L171:
	cmpb $0,_f_sorted_names(%rip)
	jnz L174
L185:
	call _name_next
	testq %rax,%rax
	jz L172
L186:
	movq %rax,%rdi
	call _addname
	jmp L185
L174:
	call _name_next
	movq %rax,%rbx
	testq %rbx,%rbx
	jz L172
L177:
	movq %rbx,%rdi
	call _strlen
	movw %ax,L173+8(%rip)
	cmpw $101,%ax
	jl L182
L180:
	pushq %rbx
	pushq $L183
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movw $100,L173+8(%rip)
L182:
	movswq L173+8(%rip),%rdx
	movq %rbx,%rsi
	movl $L173+13,%edi
	call _strncpy
	movswq L173+8(%rip),%rax
	movb $0,L173+13(%rax)
	movq $0,L173(%rip)
	movb $0,L173+10(%rip)
	movq $L173,_namelist(%rip)
	movq $L173,_namelast(%rip)
L172:
	popq %rbx
	ret 


_name_match:
L188:
	pushq %rbx
	pushq %r12
	pushq %r13
L189:
	movq %rdi,%r13
L191:
	movq _namelist(%rip),%r12
	testq %r12,%r12
	jz L244
L194:
	movq %r13,%rdi
	call _strlen
	movl %eax,%ebx
L196:
	testq %r12,%r12
	jz L199
L197:
	cmpb $0,11(%r12)
	jz L202
L203:
	movb 13(%r12),%al
	cmpb (%r13),%al
	jnz L198
L202:
	cmpb $0,12(%r12)
	jnz L208
L210:
	movw 8(%r12),%dx
	movswl %dx,%eax
	cmpl %eax,%ebx
	jl L198
L223:
	movswq %dx,%rdx
	movb (%rdx,%r13),%al
	testb %al,%al
	jz L219
L227:
	cmpb $47,%al
	jnz L198
L219:
	leaq 13(%r12),%rsi
	movq %r13,%rdi
	call _strncmp
	testl %eax,%eax
	jnz L198
	jz L245
L208:
	leaq 13(%r12),%rsi
	movq %r13,%rdi
	call _wildmat
	testl %eax,%eax
	jnz L245
L198:
	movq (%r12),%r12
	jmp L196
L245:
	movb $1,10(%r12)
	jmp L244
L199:
	cmpb $0,_f_sorted_names(%rip)
	jz L234
L235:
	movq _namelist(%rip),%rax
	cmpb $0,10(%rax)
	jz L234
L232:
	call _name_gather
	movq _namelist(%rip),%rax
	cmpb $0,10(%rax)
	jz L191
L234:
	xorl %eax,%eax
	jmp L190
L244:
	movl $1,%eax
L190:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_names_notfound:
L246:
	pushq %rbx
L247:
	movq _namelist(%rip),%rbx
	jmp L249
L250:
	cmpb $0,10(%rbx)
	jnz L255
L253:
	leaq 13(%rbx),%rax
	pushq %rax
	pushq $L256
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L255:
	movq (%rbx),%rbx
L249:
	testq %rbx,%rbx
	jnz L250
L252:
	movq $0,_namelist(%rip)
	movq $0,_namelast(%rip)
	cmpb $0,_f_sorted_names(%rip)
	jnz L260
	jz L248
L261:
	pushq %rax
	pushq $L256
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
L260:
	call _name_next
	testq %rax,%rax
	jnz L261
L248:
	popq %rbx
	ret 


_main:
L263:
	pushq %rbx
	pushq %r12
	pushq %r13
L264:
	movl %edi,%r13d
	movq %rsi,%r12
	movq $L266,_tar(%rip)
	movq %r12,%rsi
	movl %r13d,%edi
	call _options
	movq %r12,%rsi
	movl %r13d,%edi
	call _name_init
	movb _f_create(%rip),%cl
	movb _f_extract(%rip),%al
	testb %cl,%cl
	jz L268
L267:
	testb %al,%al
	jnz L277
L273:
	cmpb $0,_f_list(%rip)
	jnz L277
L275:
	call _create_archive
	jmp L269
L268:
	movb _f_list(%rip),%cl
	testb %al,%al
	jz L280
L279:
	testb %cl,%cl
	jnz L277
L284:
	call _extr_init
	movl $_extract_archive,%edi
	jmp L290
L280:
	testb %cl,%cl
	jnz L286
L277:
	pushq $L289
	pushq $___stderr
	call _fprintf
	addq $16,%rsp
	call _describe
	movl $1,%edi
	call _exit
	jmp L269
L286:
	movl $_list_archive,%edi
L290:
	call _read_and
L269:
	xorl %edi,%edi
	call _exit
L265:
	movl %ebx,%eax
	popq %r13
	popq %r12
	popq %rbx
	ret 

L141:
	.byte 116,97,114,58,32,99,97,110
	.byte 110,111,116,32,97,108,108,111
	.byte 99,97,116,101,32,109,101,109
	.byte 32,102,111,114,32,110,97,109
	.byte 101,108,105,115,116,32,101,110
	.byte 116,114,121,10,0
L4:
	.byte 116,97,114,58,32,118,97,108
	.byte 105,100,32,111,112,116,105,111
	.byte 110,115,58,10,45,98,32,78
	.byte 32,32,32,32,98,108,111,99
	.byte 107,105,110,103,32,102,97,99
	.byte 116,111,114,32,78,32,40,98
	.byte 108,111,99,107,32,115,105,122
	.byte 101,32,61,32,78,120,53,49
	.byte 50,32,98,121,116,101,115,41
	.byte 10,45,66,32,32,114,101,98
	.byte 108,111,99,107,32,97,115,32
	.byte 119,101,32,114,101,97,100,32
	.byte 40,102,111,114,32,114,101,97
	.byte 100,105,110,103,32,52,46,50
	.byte 66,83,68,32,112,105,112,101
	.byte 115,41,10,45,99,32,32,99
	.byte 114,101,97,116,101,32,97,110
	.byte 32,97,114,99,104,105,118,101
	.byte 10,45,68,32,32,100,111,110
	.byte 39,116,32,100,117,109,112,32
	.byte 116,104,101,32,99,111,110,116
	.byte 101,110,116,115,32,111,102,32
	.byte 100,105,114,101,99,116,111,114
	.byte 105,101,115,44,32,106,117,115
	.byte 116,32,116,104,101,32,100,105
	.byte 114,101,99,116,111,114,121,10
	.byte 45,102,32,70,32,114,101,97
	.byte 100,47,119,114,105,116,101,32
	.byte 97,114,99,104,105,118,101,32
	.byte 102,114,111,109,32,102,105,108
	.byte 101,32,111,114,32,100,101,118
	.byte 105,99,101,32,70,32,40,111
	.byte 114,32,104,111,115,116,110,97
	.byte 109,101,58,47,70,111,114,68
	.byte 41,10,45,104,32,32,100,111
	.byte 110,39,116,32,100,117,109,112
	.byte 32,115,121,109,98,111,108,105
	.byte 99,32,108,105,110,107,115,59
	.byte 32,100,117,109,112,32,116,104
	.byte 101,32,102,105,108,101,115,32
	.byte 116,104,101,121,32,112,111,105
	.byte 110,116,32,116,111,10,45,105
	.byte 32,32,105,103,110,111,114,101
	.byte 32,98,108,111,99,107,115,32
	.byte 111,102,32,122,101,114,111,115
	.byte 32,105,110,32,116,104,101,32
	.byte 97,114,99,104,105,118,101,44
	.byte 32,119,104,105,99,104,32,110
	.byte 111,114,109,97,108,108,121,32
	.byte 109,101,97,110,32,69,79,70
	.byte 10,45,107,32,32,107,101,101
	.byte 112,32,101,120,105,115,116,105
	.byte 110,103,32,102,105,108,101,115
	.byte 44,32,100,111,110,39,116,32
	.byte 111,118,101,114,119,114,105,116
	.byte 101,32,116,104,101,109,32,102
	.byte 114,111,109,32,116,104,101,32
	.byte 97,114,99,104,105,118,101,10
	.byte 45,108,32,32,115,116,97,121
	.byte 32,105,110,32,116,104,101,32
	.byte 108,111,99,97,108,32,102,105
	.byte 108,101,32,115,121,115,116,101
	.byte 109,32,119,104,101,110,32,99
	.byte 114,101,97,116,105,110,103,32
	.byte 97,110,32,97,114,99,104,105
	.byte 118,101,10,45,109,32,32,100
	.byte 111,110,39,116,32,101,120,116
	.byte 114,97,99,116,32,102,105,108
	.byte 101,32,109,111,100,105,102,105
	.byte 101,100,32,116,105,109,101,10
	.byte 45,111,32,32,119,114,105,116
	.byte 101,32,97,110,32,111,108,100
	.byte 32,86,55,32,102,111,114,109
	.byte 97,116,32,97,114,99,104,105
	.byte 118,101,44,32,114,97,116,104
	.byte 101,114,32,116,104,97,110,32
	.byte 80,79,83,73,88,32,102,111
	.byte 114,109,97,116,10,45,112,32
	.byte 32,100,111,32,101,120,116,114
	.byte 97,99,116,32,97,108,108,32
	.byte 112,114,111,116,101,99,116,105
	.byte 111,110,32,105,110,102,111,114
	.byte 109,97,116,105,111,110,10,45
	.byte 82,32,32,100,117,109,112,32
	.byte 114,101,99,111,114,100,32,110
	.byte 117,109,98,101,114,32,119,105
	.byte 116,104,105,110,32,97,114,99
	.byte 104,105,118,101,32,119,105,116
	.byte 104,32,101,97,99,104,32,109
	.byte 101,115,115,97,103,101,10,45
	.byte 115,32,32,108,105,115,116,32
	.byte 111,102,32,110,97,109,101,115
	.byte 32,116,111,32,101,120,116,114
	.byte 97,99,116,32,105,115,32,115
	.byte 111,114,116,101,100,32,116,111
	.byte 32,109,97,116,99,104,32,116
	.byte 104,101,32,97,114,99,104,105
	.byte 118,101,10,45,116,32,32,108
	.byte 105,115,116,32,97,32,116,97
	.byte 98,108,101,32,111,102,32,99
	.byte 111,110,116,101,110,116,115,32
	.byte 111,102,32,97,110,32,97,114
	.byte 99,104,105,118,101,10,45,84
	.byte 32,70,32,32,32,32,103,101
	.byte 116,32,110,97,109,101,115,32
	.byte 116,111,32,101,120,116,114,97
	.byte 99,116,32,111,114,32,99,114
	.byte 101,97,116,101,32,102,114,111
	.byte 109,32,102,105,108,101,32,70
	.byte 10,45,118,32,32,118,101,114
	.byte 98,111,115,101,108,121,32,108
	.byte 105,115,116,32,119,104,97,116
	.byte 32,102,105,108,101,115,32,119
	.byte 101,32,112,114,111,99,101,115
	.byte 115,10,45,120,32,32,101,120
	.byte 116,114,97,99,116,32,102,105
	.byte 108,101,115,32,102,114,111,109
	.byte 32,97,110,32,97,114,99,104
	.byte 105,118,101,10,45,122,32,111
	.byte 114,32,90,32,114,117,110,32
	.byte 116,104,101,32,97,114,99,104
	.byte 105,118,101,32,116,104,114,111
	.byte 117,103,104,32,99,111,109,112
	.byte 114,101,115,115,10,0
L289:
	.byte 116,97,114,58,32,121,111,117
	.byte 32,109,117,115,116,32,115,112
	.byte 101,99,105,102,121,32,101,120
	.byte 97,99,116,108,121,32,32,111
	.byte 110,101,32,111,102,32,116,104
	.byte 101,32,99,44,32,116,44,32
	.byte 111,114,32,120,32,111,112,116
	.byte 105,111,110,115,10,0
L91:
	.byte 116,97,114,58,32,0
L12:
	.byte 45,0
L8:
	.byte 84,65,80,69,0
L16:
	.byte 98,58,66,99,68,102,58,104
	.byte 105,107,108,109,111,112,82,115
	.byte 116,84,58,118,120,122,90,0
L87:
	.byte 114,0
L266:
	.byte 116,97,114,0
L256:
	.byte 116,97,114,58,32,37,115,32
	.byte 110,111,116,32,102,111,117,110
	.byte 100,32,105,110,32,97,114,99
	.byte 104,105,118,101,10,0
L83:
	.byte 116,97,114,58,32,116,111,111
	.byte 32,109,97,110,121,32,97,114
	.byte 103,115,32,119,105,116,104,32
	.byte 45,84,32,111,112,116,105,111
	.byte 110,10,0
L183:
	.byte 65,114,103,117,109,101,110,116
	.byte 32,110,97,109,101,32,116,111
	.byte 111,32,108,111,110,103,58,32
	.byte 37,115,10,0
.globl _ar_block
.comm _ar_block, 8, 8
.globl _ar_record
.comm _ar_record, 8, 8
.globl _ar_last
.comm _ar_last, 8, 8
.globl _ar_reading
.comm _ar_reading, 1, 1
.globl _blocking
.comm _blocking, 4, 4
.globl _blocksize
.comm _blocksize, 4, 4
.globl _ar_file
.comm _ar_file, 8, 8
.globl _name_file
.comm _name_file, 8, 8
.globl _tar
.comm _tar, 8, 8
.globl _f_reblock
.comm _f_reblock, 1, 1
.globl _f_create
.comm _f_create, 1, 1
.globl _f_diff
.comm _f_diff, 1, 1
.globl _f_dironly
.comm _f_dironly, 1, 1
.globl _f_follow_links
.comm _f_follow_links, 1, 1
.globl _f_ignorez
.comm _f_ignorez, 1, 1
.globl _f_keep
.comm _f_keep, 1, 1
.globl _f_local_filesys
.comm _f_local_filesys, 1, 1
.globl _f_modified
.comm _f_modified, 1, 1
.globl _f_oldarch
.comm _f_oldarch, 1, 1
.globl _f_use_protection
.comm _f_use_protection, 1, 1
.globl _f_sayblock
.comm _f_sayblock, 1, 1
.globl _f_sorted_names
.comm _f_sorted_names, 1, 1
.globl _f_list
.comm _f_list, 1, 1
.globl _f_namefile
.comm _f_namefile, 1, 1
.globl _f_verbose
.comm _f_verbose, 1, 1
.globl _f_extract
.comm _f_extract, 1, 1
.globl _f_compress
.comm _f_compress, 1, 1
.globl _namelist
.comm _namelist, 8, 8
.globl _namelast
.comm _namelast, 8, 8
.globl _archive
.comm _archive, 4, 4
.globl _errors
.comm _errors, 4, 4
.globl _linklist
.comm _linklist, 8, 8
.globl _read_error_flag
.comm _read_error_flag, 1, 1
.local _namef
.comm _namef, 8, 8
.local _n_argv
.comm _n_argv, 8, 8
.local _n_argc
.comm _n_argc, 4, 4

.globl _name_file
.globl _ar_reading
.globl _name_gather
.globl _archive
.globl _optarg
.globl _getenv
.globl _extract_archive
.globl _read_and
.globl _name_next
.globl _names_notfound
.globl _f_namefile
.globl _fgets
.globl _strncpy
.globl _f_keep
.globl _f_sayblock
.globl _fopen
.globl _name_close
.globl _malloc
.globl _errors
.globl _ar_record
.globl _optind
.globl _create_archive
.globl _ar_last
.globl _strncmp
.globl _linklist
.globl _f_modified
.globl _extr_init
.globl _atoi
.globl _f_reblock
.globl _read_error_flag
.globl _f_sorted_names
.globl _f_ignorez
.globl _blocksize
.globl _f_dironly
.globl _namelast
.globl _strcmp
.globl _ar_file
.globl _namelist
.globl _f_diff
.globl ___stderr
.globl ___stdin
.globl _f_verbose
.globl _f_oldarch
.globl _tar
.globl _perror
.globl _wildmat
.globl _fclose
.globl _f_compress
.globl _ar_block
.globl _f_use_protection
.globl _f_list
.globl _blocking
.globl _name_match
.globl _fputs
.globl _f_extract
.globl _f_local_filesys
.globl _f_follow_links
.globl _strlen
.globl _strchr
.globl _main
.globl _exit
.globl _f_create
.globl _list_archive
.globl _getoldopt
.globl _fprintf
