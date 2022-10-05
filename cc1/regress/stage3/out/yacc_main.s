.data
.align 8
_file_prefix:
	.quad L1
.align 8
_myname:
	.quad L2
.align 8
_temp_form:
	.quad L3
.align 8
_input_file_name:
	.quad L4
.text

_done:
L5:
	pushq %rbx
L6:
	movq _action_file(%rip),%rax
	movl %edi,%ebx
	testq %rax,%rax
	jz L10
L8:
	movq %rax,%rdi
	call _fclose
	movq _action_file_name(%rip),%rdi
	call _unlink
L10:
	movq _text_file(%rip),%rdi
	testq %rdi,%rdi
	jz L13
L11:
	call _fclose
	movq _text_file_name(%rip),%rdi
	call _unlink
L13:
	movq _union_file(%rip),%rdi
	testq %rdi,%rdi
	jz L16
L14:
	call _fclose
	movq _union_file_name(%rip),%rdi
	call _unlink
L16:
	movl %ebx,%edi
	call _exit
L7:
	popq %rbx
	ret 


_onintr:
L17:
L18:
	movl $1,%edi
	call _done
L19:
	ret 


_set_signals:
L20:
L21:
	movl $1,%esi
	movl $2,%edi
	call _signal
	cmpq $1,%rax
	jz L25
L23:
	movl $_onintr,%esi
	movl $2,%edi
	call _signal
L25:
	movl $1,%esi
	movl $15,%edi
	call _signal
	cmpq $1,%rax
	jz L22
L26:
	movl $_onintr,%esi
	movl $15,%edi
	call _signal
L22:
	ret 


_usage:
L29:
L30:
	pushq _myname(%rip)
	pushq $L32
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $1,%edi
	call _exit
L31:
	ret 


_getargs:
L33:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L34:
	movl %edi,%r14d
	movq %rsi,%r13
	cmpl $0,%r14d
	jle L38
L36:
	movq (%r13),%rax
	movq %rax,_myname(%rip)
L38:
	movl $1,%r12d
L39:
	cmpl %r12d,%r14d
	jle L56
L40:
	movq (%r13,%r12,8),%rcx
	cmpb $45,(%rcx)
	jnz L56
L45:
	leaq 1(%rcx),%rbx
	movb 1(%rcx),%al
	testb %al,%al
	jz L50
L115:
	cmpb $45,%al
	jz L55
L116:
	cmpb $98,%al
	jz L58
L117:
	cmpb $100,%al
	jz L112
L118:
	cmpb $108,%al
	jz L111
L119:
	cmpb $112,%al
	jz L70
L120:
	cmpb $114,%al
	jz L110
L121:
	cmpb $116,%al
	jz L109
L122:
	cmpb $118,%al
	jz L108
	jnz L107
L70:
	leaq 2(%rcx),%rax
	cmpb $0,2(%rcx)
	jnz L133
L72:
	incl %r12d
	cmpl %r12d,%r14d
	jle L113
L74:
	movl %r12d,%eax
	movq (%r13,%rax,8),%rax
L133:
	movq %rax,_symbol_prefix(%rip)
	jmp L41
L112:
	movb $1,_dflag(%rip)
L84:
	leaq 1(%rbx),%rcx
	movb 1(%rbx),%al
	movq %rcx,%rbx
	testb %al,%al
	jz L41
L126:
	cmpb $100,%al
	jz L112
L127:
	cmpb $108,%al
	jz L111
L128:
	cmpb $114,%al
	jz L110
L129:
	cmpb $116,%al
	jz L109
L130:
	cmpb $118,%al
	jz L108
L107:
	call _usage
	jmp L84
L108:
	movb $1,_vflag(%rip)
	jmp L84
L109:
	movb $1,_tflag(%rip)
	jmp L84
L110:
	movb $1,_rflag(%rip)
	jmp L84
L111:
	movb $1,_lflag(%rip)
	jmp L84
L58:
	leaq 2(%rcx),%rax
	cmpb $0,2(%rcx)
	jnz L134
L60:
	incl %r12d
	cmpl %r12d,%r14d
	jg L62
L113:
	call _usage
	jmp L41
L62:
	movl %r12d,%eax
	movq (%r13,%rax,8),%rax
L134:
	movq %rax,_file_prefix(%rip)
L41:
	incl %r12d
	jmp L39
L55:
	incl %r12d
	jmp L56
L50:
	movq $___stdin,_input_file(%rip)
	incl %r12d
	cmpl %r12d,%r14d
	jle L35
L51:
	call _usage
	jmp L35
L56:
	leal 1(%r12),%eax
	cmpl %eax,%r14d
	jz L106
L104:
	call _usage
L106:
	movl %r12d,%eax
	movq (%r13,%rax,8),%rax
	movq %rax,_input_file_name(%rip)
L35:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 


_allocate:
L135:
	pushq %rbx
L136:
	xorl %ebx,%ebx
	testq %rdi,%rdi
	jz L140
L138:
	movl %edi,%esi
	movl $1,%edi
	call _calloc
	movq %rax,%rbx
	testq %rax,%rax
	jnz L140
L141:
	call _no_space
L140:
	movq %rbx,%rax
L137:
	popq %rbx
	ret 


_create_file_names:
L145:
	pushq %rbx
	pushq %r12
	pushq %r13
L146:
	movl $L148,%edi
	call _getenv
	movq %rax,%rbx
	testq %rax,%rax
	movl $L152,%eax
	cmovzq %rax,%rbx
	movq %rbx,%rdi
	call _strlen
	movl %eax,%r12d
	leal 13(%r12),%r13d
	testl %r12d,%r12d
	jz L155
L156:
	movl %r12d,%eax
	decl %eax
	movslq %eax,%rax
	cmpb $47,(%rax,%rbx)
	jz L155
L153:
	leal 14(%r12),%r13d
L155:
	movq %r13,%rdi
	call _malloc
	movq %rax,_action_file_name(%rip)
	testq %rax,%rax
	jnz L162
L160:
	call _no_space
L162:
	movq %r13,%rdi
	call _malloc
	movq %rax,_text_file_name(%rip)
	testq %rax,%rax
	jnz L165
L163:
	call _no_space
L165:
	movq %r13,%rdi
	call _malloc
	movq %rax,_union_file_name(%rip)
	testq %rax,%rax
	jnz L168
L166:
	call _no_space
L168:
	movq %rbx,%rsi
	movq _action_file_name(%rip),%rdi
	call _strcpy
	movq %rbx,%rsi
	movq _text_file_name(%rip),%rdi
	call _strcpy
	movq %rbx,%rsi
	movq _union_file_name(%rip),%rdi
	call _strcpy
	testl %r12d,%r12d
	jz L171
L172:
	movl %r12d,%eax
	decl %eax
	movslq %eax,%rax
	cmpb $47,(%rax,%rbx)
	jz L171
L169:
	movslq %r12d,%rax
	movq _action_file_name(%rip),%rcx
	movb $47,(%rax,%rcx)
	movq _text_file_name(%rip),%rcx
	movb $47,(%rax,%rcx)
	movq _union_file_name(%rip),%rcx
	movb $47,(%rax,%rcx)
	incl %r12d
L171:
	movslq %r12d,%r12
	movq _action_file_name(%rip),%rdi
	movq _temp_form(%rip),%rsi
	addq %r12,%rdi
	call _strcpy
	movq _text_file_name(%rip),%rdi
	movq _temp_form(%rip),%rsi
	addq %r12,%rdi
	call _strcpy
	movq _union_file_name(%rip),%rdi
	movq _temp_form(%rip),%rsi
	addq %r12,%rdi
	call _strcpy
	addl $5,%r12d
	movslq %r12d,%rax
	movq _action_file_name(%rip),%rcx
	movb $97,(%rax,%rcx)
	movq _text_file_name(%rip),%rcx
	movb $116,(%rax,%rcx)
	movq _union_file_name(%rip),%rcx
	movb $117,(%rax,%rcx)
	movq _action_file_name(%rip),%rdi
	call _mktemp
	movq _text_file_name(%rip),%rdi
	call _mktemp
	movq _union_file_name(%rip),%rdi
	call _mktemp
	movq _file_prefix(%rip),%rdi
	call _strlen
	movl %eax,%r13d
	leal 7(%r13),%r12d
	movq %r12,%rdi
	call _malloc
	movq %rax,_output_file_name(%rip)
	testq %rax,%rax
	jnz L178
L176:
	call _no_space
L178:
	movq _file_prefix(%rip),%rsi
	movq _output_file_name(%rip),%rdi
	call _strcpy
	movslq %r13d,%rbx
	movq _output_file_name(%rip),%rdi
	movl $L179,%esi
	addq %rbx,%rdi
	call _strcpy
	cmpb $0,_rflag(%rip)
	jz L181
L180:
	leal 8(%r13),%edi
	call _malloc
	movq %rax,_code_file_name(%rip)
	testq %rax,%rax
	jnz L185
L183:
	call _no_space
L185:
	movq _file_prefix(%rip),%rsi
	movq _code_file_name(%rip),%rdi
	call _strcpy
	movq _code_file_name(%rip),%rdi
	movl $L186,%esi
	addq %rbx,%rdi
	call _strcpy
	jmp L182
L181:
	movq _output_file_name(%rip),%rax
	movq %rax,_code_file_name(%rip)
L182:
	cmpb $0,_dflag(%rip)
	jz L189
L187:
	movq %r12,%rdi
	call _malloc
	movq %rax,_defines_file_name(%rip)
	testq %rax,%rax
	jnz L192
L190:
	call _no_space
L192:
	movq _file_prefix(%rip),%rsi
	movq _defines_file_name(%rip),%rdi
	call _strcpy
	movq _defines_file_name(%rip),%rdi
	movl $L193,%esi
	addq %rbx,%rdi
	call _strcpy
L189:
	cmpb $0,_vflag(%rip)
	jz L147
L194:
	addl $8,%r13d
	movl %r13d,%edi
	call _malloc
	movq %rax,_verbose_file_name(%rip)
	testq %rax,%rax
	jnz L199
L197:
	call _no_space
L199:
	movq _file_prefix(%rip),%rsi
	movq _verbose_file_name(%rip),%rdi
	call _strcpy
	movq _verbose_file_name(%rip),%rdi
	movl $L200,%esi
	addq %rbx,%rdi
	call _strcpy
L147:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_open_files:
L201:
L202:
	call _create_file_names
	cmpq $0,_input_file(%rip)
	jnz L206
L204:
	movl $L207,%esi
	movq _input_file_name(%rip),%rdi
	call _fopen
	movq %rax,_input_file(%rip)
	testq %rax,%rax
	jnz L206
L208:
	movq _input_file_name(%rip),%rdi
	call _open_error
L206:
	movl $L211,%esi
	movq _action_file_name(%rip),%rdi
	call _fopen
	movq %rax,_action_file(%rip)
	testq %rax,%rax
	jnz L214
L212:
	movq _action_file_name(%rip),%rdi
	call _open_error
L214:
	movl $L211,%esi
	movq _text_file_name(%rip),%rdi
	call _fopen
	movq %rax,_text_file(%rip)
	testq %rax,%rax
	jnz L217
L215:
	movq _text_file_name(%rip),%rdi
	call _open_error
L217:
	cmpb $0,_vflag(%rip)
	jz L220
L218:
	movl $L211,%esi
	movq _verbose_file_name(%rip),%rdi
	call _fopen
	movq %rax,_verbose_file(%rip)
	testq %rax,%rax
	jnz L220
L221:
	movq _verbose_file_name(%rip),%rdi
	call _open_error
L220:
	cmpb $0,_dflag(%rip)
	jz L226
L224:
	movl $L211,%esi
	movq _defines_file_name(%rip),%rdi
	call _fopen
	movq %rax,_defines_file(%rip)
	testq %rax,%rax
	jnz L229
L227:
	movq _defines_file_name(%rip),%rdi
	call _open_error
L229:
	movl $L211,%esi
	movq _union_file_name(%rip),%rdi
	call _fopen
	movq %rax,_union_file(%rip)
	testq %rax,%rax
	jnz L226
L230:
	movq _union_file_name(%rip),%rdi
	call _open_error
L226:
	movl $L211,%esi
	movq _output_file_name(%rip),%rdi
	call _fopen
	movq %rax,_output_file(%rip)
	testq %rax,%rax
	jnz L235
L233:
	movq _output_file_name(%rip),%rdi
	call _open_error
L235:
	cmpb $0,_rflag(%rip)
	jz L237
L236:
	movl $L211,%esi
	movq _code_file_name(%rip),%rdi
	call _fopen
	movq %rax,_code_file(%rip)
	testq %rax,%rax
	jnz L203
L239:
	movq _code_file_name(%rip),%rdi
	call _open_error
	ret
L237:
	movq _output_file(%rip),%rax
	movq %rax,_code_file(%rip)
L203:
	ret 


_main:
L242:
	pushq %rbx
	pushq %r12
	pushq %r13
L243:
	movl %edi,%r13d
	movq %rsi,%r12
	call _set_signals
	movq %r12,%rsi
	movl %r13d,%edi
	call _getargs
	call _open_files
	call _reader
	call _lr0
	call _lalr
	call _make_parser
	call _verbose
	call _output
	xorl %edi,%edi
	call _done
L244:
	movl %ebx,%eax
	popq %r13
	popq %r12
	popq %rbx
	ret 

L4:
	.byte 0
L193:
	.byte 46,116,97,98,46,104,0
L152:
	.byte 47,116,109,112,0
L179:
	.byte 46,116,97,98,46,99,0
L3:
	.byte 121,97,99,99,46,88,88,88
	.byte 88,88,88,88,0
L2:
	.byte 121,97,99,99,0
L186:
	.byte 46,99,111,100,101,46,99,0
L32:
	.byte 117,115,97,103,101,58,32,37
	.byte 115,32,91,45,100,108,114,116
	.byte 118,93,32,91,45,98,32,102
	.byte 105,108,101,95,112,114,101,102
	.byte 105,120,93,32,91,45,112,32
	.byte 115,121,109,98,111,108,95,112
	.byte 114,101,102,105,120,93,32,102
	.byte 105,108,101,110,97,109,101,10
	.byte 0
L1:
	.byte 121,0
L207:
	.byte 114,0
L211:
	.byte 119,0
L200:
	.byte 46,111,117,116,112,117,116,0
L148:
	.byte 84,77,80,68,73,82,0
.globl _dflag
.comm _dflag, 1, 1
.globl _lflag
.comm _lflag, 1, 1
.globl _rflag
.comm _rflag, 1, 1
.globl _tflag
.comm _tflag, 1, 1
.globl _vflag
.comm _vflag, 1, 1
.globl _symbol_prefix
.comm _symbol_prefix, 8, 8
.globl _lineno
.comm _lineno, 4, 4
.globl _outline
.comm _outline, 4, 4
.globl _action_file_name
.comm _action_file_name, 8, 8
.globl _code_file_name
.comm _code_file_name, 8, 8
.globl _defines_file_name
.comm _defines_file_name, 8, 8
.globl _output_file_name
.comm _output_file_name, 8, 8
.globl _text_file_name
.comm _text_file_name, 8, 8
.globl _union_file_name
.comm _union_file_name, 8, 8
.globl _verbose_file_name
.comm _verbose_file_name, 8, 8
.globl _action_file
.comm _action_file, 8, 8
.globl _code_file
.comm _code_file, 8, 8
.globl _defines_file
.comm _defines_file, 8, 8
.globl _input_file
.comm _input_file, 8, 8
.globl _output_file
.comm _output_file, 8, 8
.globl _text_file
.comm _text_file, 8, 8
.globl _union_file
.comm _union_file, 8, 8
.globl _verbose_file
.comm _verbose_file, 8, 8
.globl _nitems
.comm _nitems, 4, 4
.globl _nrules
.comm _nrules, 4, 4
.globl _nsyms
.comm _nsyms, 4, 4
.globl _ntokens
.comm _ntokens, 4, 4
.globl _nvars
.comm _nvars, 4, 4
.globl _start_symbol
.comm _start_symbol, 4, 4
.globl _symbol_name
.comm _symbol_name, 8, 8
.globl _symbol_value
.comm _symbol_value, 8, 8
.globl _symbol_prec
.comm _symbol_prec, 8, 8
.globl _symbol_assoc
.comm _symbol_assoc, 8, 8
.globl _ritem
.comm _ritem, 8, 8
.globl _rlhs
.comm _rlhs, 8, 8
.globl _rrhs
.comm _rrhs, 8, 8
.globl _rprec
.comm _rprec, 8, 8
.globl _rassoc
.comm _rassoc, 8, 8
.globl _derives
.comm _derives, 8, 8
.globl _nullable
.comm _nullable, 8, 8

.globl _output_file_name
.globl _symbol_assoc
.globl _rlhs
.globl _vflag
.globl _defines_file_name
.globl _getenv
.globl _temp_form
.globl _dflag
.globl _output_file
.globl _done
.globl _fopen
.globl _verbose_file_name
.globl _nsyms
.globl _defines_file
.globl _code_file
.globl _symbol_prefix
.globl _malloc
.globl _verbose_file
.globl _text_file_name
.globl _mktemp
.globl _ntokens
.globl _input_file_name
.globl _lalr
.globl _lflag
.globl _rrhs
.globl _verbose
.globl _lineno
.globl _tflag
.globl _text_file
.globl _reader
.globl _outline
.globl _allocate
.globl _union_file
.globl _nitems
.globl _calloc
.globl _open_error
.globl _start_symbol
.globl _unlink
.globl _rprec
.globl _union_file_name
.globl _symbol_prec
.globl _symbol_name
.globl _nrules
.globl ___stderr
.globl _myname
.globl _action_file_name
.globl ___stdin
.globl _fclose
.globl _lr0
.globl _output
.globl _symbol_value
.globl _rflag
.globl _ritem
.globl _rassoc
.globl _nvars
.globl _file_prefix
.globl _signal
.globl _derives
.globl _strlen
.globl _main
.globl _input_file
.globl _exit
.globl _strcpy
.globl _code_file_name
.globl _fprintf
.globl _make_parser
.globl _nullable
.globl _action_file
.globl _no_space
