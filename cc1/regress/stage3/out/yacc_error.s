.text

_fatal:
L1:
L2:
	pushq %rdi
	pushq _myname(%rip)
	pushq $L4
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl $2,%edi
	call _done
L3:
	ret 


_no_space:
L5:
L6:
	pushq _myname(%rip)
	pushq $L8
	pushq $___stderr
	call _fprintf
	addq $24,%rsp
	movl $2,%edi
	call _done
L7:
	ret 


_open_error:
L9:
L10:
	pushq %rdi
	pushq _myname(%rip)
	pushq $L12
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl $2,%edi
	call _done
L11:
	ret 


_unexpected_EOF:
L13:
L14:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L16
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movl $1,%edi
	call _done
L15:
	ret 


_print_pos:
L17:
	pushq %rbx
	pushq %r12
	pushq %r13
L18:
	movq %rdi,%rbx
	movq %rsi,%r13
	testq %rbx,%rbx
	jz L19
L22:
	movq %rbx,%r12
L24:
	movb (%r12),%cl
	cmpb $10,%cl
	jz L27
L25:
	movsbl %cl,%eax
	subl $32,%eax
	cmpl $95,%eax
	jb L28
L31:
	cmpb $9,%cl
	jnz L29
L28:
	decl ___stderr(%rip)
	js L36
L35:
	movb (%r12),%dl
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb %dl,(%rcx)
	jmp L30
L36:
	movsbl (%r12),%edi
	movl $___stderr,%esi
	jmp L64
L29:
	decl ___stderr(%rip)
	js L39
L38:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $63,(%rcx)
	jmp L30
L39:
	movl $___stderr,%esi
	movl $63,%edi
L64:
	call ___flushbuf
L30:
	incq %r12
	jmp L24
L27:
	decl ___stderr(%rip)
	js L42
L41:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $10,(%rcx)
	jmp L44
L42:
	movl $___stderr,%esi
	movl $10,%edi
	call ___flushbuf
L44:
	movl ___stderr(%rip),%eax
	decl %eax
	cmpq %rbx,%r13
	jbe L47
L45:
	cmpb $9,(%rbx)
	jnz L49
L48:
	movl %eax,___stderr(%rip)
	cmpl $0,%eax
	jl L52
L51:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $9,(%rcx)
	jmp L50
L52:
	movl $___stderr,%esi
	movl $9,%edi
	jmp L63
L49:
	movl %eax,___stderr(%rip)
	cmpl $0,%eax
	jl L55
L54:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $32,(%rcx)
	jmp L50
L55:
	movl $___stderr,%esi
	movl $32,%edi
L63:
	call ___flushbuf
L50:
	incq %rbx
	jmp L44
L47:
	movl %eax,___stderr(%rip)
	cmpl $0,%eax
	jl L58
L57:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $94,(%rcx)
	jmp L59
L58:
	movl $___stderr,%esi
	movl $94,%edi
	call ___flushbuf
L59:
	decl ___stderr(%rip)
	js L61
L60:
	movq ___stderr+24(%rip),%rcx
	leaq 1(%rcx),%rax
	movq %rax,___stderr+24(%rip)
	movb $10,(%rcx)
	jmp L19
L61:
	movl $___stderr,%esi
	movl $10,%edi
	call ___flushbuf
L19:
	popq %r13
	popq %r12
	popq %rbx
	ret 


_syntax_error:
L65:
	pushq %rbx
	pushq %r12
L66:
	movq %rsi,%r12
	movq %rdx,%rbx
	pushq _input_file_name(%rip)
	pushq %rdi
	pushq _myname(%rip)
	pushq $L68
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movq %rbx,%rsi
	movq %r12,%rdi
	call _print_pos
	movl $1,%edi
	call _done
L67:
	popq %r12
	popq %rbx
	ret 


_unterminated_comment:
L69:
	pushq %rbx
	pushq %r12
L70:
	movq %rsi,%r12
	movq %rdx,%rbx
	pushq _input_file_name(%rip)
	pushq %rdi
	pushq _myname(%rip)
	pushq $L72
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movq %rbx,%rsi
	movq %r12,%rdi
	call _print_pos
	movl $1,%edi
	call _done
L71:
	popq %r12
	popq %rbx
	ret 


_unterminated_string:
L73:
	pushq %rbx
	pushq %r12
L74:
	movq %rsi,%r12
	movq %rdx,%rbx
	pushq _input_file_name(%rip)
	pushq %rdi
	pushq _myname(%rip)
	pushq $L76
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movq %rbx,%rsi
	movq %r12,%rdi
	call _print_pos
	movl $1,%edi
	call _done
L75:
	popq %r12
	popq %rbx
	ret 


_unterminated_text:
L77:
	pushq %rbx
	pushq %r12
L78:
	movq %rsi,%r12
	movq %rdx,%rbx
	pushq _input_file_name(%rip)
	pushq %rdi
	pushq _myname(%rip)
	pushq $L80
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movq %rbx,%rsi
	movq %r12,%rdi
	call _print_pos
	movl $1,%edi
	call _done
L79:
	popq %r12
	popq %rbx
	ret 


_unterminated_union:
L81:
	pushq %rbx
	pushq %r12
L82:
	movq %rsi,%r12
	movq %rdx,%rbx
	pushq _input_file_name(%rip)
	pushq %rdi
	pushq _myname(%rip)
	pushq $L84
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movq %rbx,%rsi
	movq %r12,%rdi
	call _print_pos
	movl $1,%edi
	call _done
L83:
	popq %r12
	popq %rbx
	ret 


_over_unionized:
L85:
	pushq %rbx
L86:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	movq %rdi,%rbx
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L88
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movq %rbx,%rsi
	movq _line(%rip),%rdi
	call _print_pos
	movl $1,%edi
	call _done
L87:
	popq %rbx
	ret 


_illegal_tag:
L89:
	pushq %rbx
	pushq %r12
L90:
	movq %rsi,%r12
	movq %rdx,%rbx
	pushq _input_file_name(%rip)
	pushq %rdi
	pushq _myname(%rip)
	pushq $L92
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movq %rbx,%rsi
	movq %r12,%rdi
	call _print_pos
	movl $1,%edi
	call _done
L91:
	popq %r12
	popq %rbx
	ret 


_illegal_character:
L93:
	pushq %rbx
L94:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	movq %rdi,%rbx
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L96
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movq %rbx,%rsi
	movq _line(%rip),%rdi
	call _print_pos
	movl $1,%edi
	call _done
L95:
	popq %rbx
	ret 


_used_reserved:
L97:
L98:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq %rdi
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L100
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
	movl $1,%edi
	call _done
L99:
	ret 


_tokenized_start:
L101:
L102:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq %rdi
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L104
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
	movl $1,%edi
	call _done
L103:
	ret 


_retyped_warning:
L105:
L106:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq %rdi
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L108
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
L107:
	ret 


_reprec_warning:
L109:
L110:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq %rdi
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L112
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
L111:
	ret 


_revalued_warning:
L113:
L114:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq %rdi
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L116
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
L115:
	ret 


_terminal_start:
L117:
L118:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq %rdi
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L120
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
	movl $1,%edi
	call _done
L119:
	ret 


_restarted_warning:
L121:
L122:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L124
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
L123:
	ret 


_no_grammar:
L125:
L126:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L128
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movl $1,%edi
	call _done
L127:
	ret 


_terminal_lhs:
L129:
L130:
	pushq _input_file_name(%rip)
	pushq %rdi
	pushq _myname(%rip)
	pushq $L132
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movl $1,%edi
	call _done
L131:
	ret 


_prec_redeclared:
L133:
L134:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L136
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
L135:
	ret 


_unterminated_action:
L137:
	pushq %rbx
	pushq %r12
L138:
	movq %rsi,%r12
	movq %rdx,%rbx
	pushq _input_file_name(%rip)
	pushq %rdi
	pushq _myname(%rip)
	pushq $L140
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movq %rbx,%rsi
	movq %r12,%rdi
	call _print_pos
	movl $1,%edi
	call _done
L139:
	popq %r12
	popq %rbx
	ret 


_dollar_warning:
L141:
L142:
	pushq %rsi
	pushq _input_file_name(%rip)
	pushq %rdi
	pushq _myname(%rip)
	pushq $L144
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
L143:
	ret 


_dollar_error:
L145:
	pushq %rbx
	pushq %r12
L146:
	movq %rsi,%r12
	movq %rdx,%rbx
	pushq _input_file_name(%rip)
	pushq %rdi
	pushq _myname(%rip)
	pushq $L148
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movq %rbx,%rsi
	movq %r12,%rdi
	call _print_pos
	movl $1,%edi
	call _done
L147:
	popq %r12
	popq %rbx
	ret 


_untyped_lhs:
L149:
L150:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L152
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
	movl $1,%edi
	call _done
L151:
	ret 


_untyped_rhs:
L153:
L154:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq %rsi
	pushq %rdi
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L156
	pushq $___stderr
	call _fprintf
	addq $56,%rsp
	movl $1,%edi
	call _done
L155:
	ret 


_unknown_rhs:
L157:
L158:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq %rdi
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L160
	pushq $___stderr
	call _fprintf
	addq $48,%rsp
	movl $1,%edi
	call _done
L159:
	ret 


_default_action_warning:
L161:
L162:
	movq _myname(%rip),%rcx
	movl _lineno(%rip),%eax
	pushq _input_file_name(%rip)
	pushq %rax
	pushq %rcx
	pushq $L164
	pushq $___stderr
	call _fprintf
	addq $40,%rsp
L163:
	ret 


_undefined_goal:
L165:
L166:
	pushq %rdi
	pushq _myname(%rip)
	pushq $L168
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
	movl $1,%edi
	call _done
L167:
	ret 


_undefined_symbol_warning:
L169:
L170:
	pushq %rdi
	pushq _myname(%rip)
	pushq $L172
	pushq $___stderr
	call _fprintf
	addq $32,%rsp
L171:
	ret 

L148:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,105,108,108,101,103,97,108
 .byte 32,36,45,110,97,109,101,10
 .byte 0
L140:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,117,110,116,101,114,109,105
 .byte 110,97,116,101,100,32,97,99
 .byte 116,105,111,110,10,0
L88:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,116,111,111,32,109,97,110
 .byte 121,32,37,37,117,110,105,111
 .byte 110,32,100,101,99,108,97,114
 .byte 97,116,105,111,110,115,10,0
L12:
 .byte 37,115,58,32,102,32,45,32
 .byte 99,97,110,110,111,116,32,111
 .byte 112,101,110,32,34,37,115,34
 .byte 10,0
L104:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,116,104,101,32,115,116,97
 .byte 114,116,32,115,121,109,98,111
 .byte 108,32,37,115,32,99,97,110
 .byte 110,111,116,32,98,101,32,100
 .byte 101,99,108,97,114,101,100,32
 .byte 116,111,32,98,101,32,97,32
 .byte 116,111,107,101,110,10,0
L136:
 .byte 37,115,58,32,119,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,32,34,37,115,34
 .byte 44,32,99,111,110,102,108,105
 .byte 99,116,105,110,103,32,37,37
 .byte 112,114,101,99,32,115,112,101
 .byte 99,105,102,105,101,114,115,10
 .byte 0
L160:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,36,37,100,32,105,115,32
 .byte 117,110,116,121,112,101,100,10
 .byte 0
L164:
 .byte 37,115,58,32,119,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,116,104,101,32,100,101,102
 .byte 97,117,108,116,32,97,99,116
 .byte 105,111,110,32,97,115,115,105
 .byte 103,110,115,32,97,110,32,117
 .byte 110,100,101,102,105,110,101,100
 .byte 32,118,97,108,117,101,32,116
 .byte 111,32,36,36,10,0
L84:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,117,110,116,101,114,109,105
 .byte 110,97,116,101,100,32,37,37
 .byte 117,110,105,111,110,32,100,101
 .byte 99,108,97,114,97,116,105,111
 .byte 110,10,0
L152:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,36,36,32,105,115,32,117
 .byte 110,116,121,112,101,100,10,0
L100:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,105,108,108,101,103,97,108
 .byte 32,117,115,101,32,111,102,32
 .byte 114,101,115,101,114,118,101,100
 .byte 32,115,121,109,98,111,108,32
 .byte 37,115,10,0
L4:
 .byte 37,115,58,32,102,32,45,32
 .byte 37,115,10,0
L112:
 .byte 37,115,58,32,119,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,116,104,101,32,112,114,101
 .byte 99,101,100,101,110,99,101,32
 .byte 111,102,32,37,115,32,104,97
 .byte 115,32,98,101,101,110,32,114
 .byte 101,100,101,99,108,97,114,101
 .byte 100,10,0
L144:
 .byte 37,115,58,32,119,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,36,37,100,32,114,101,102
 .byte 101,114,101,110,99,101,115,32
 .byte 98,101,121,111,110,100,32,116
 .byte 104,101,32,101,110,100,32,111
 .byte 102,32,116,104,101,32,99,117
 .byte 114,114,101,110,116,32,114,117
 .byte 108,101,10,0
L8:
 .byte 37,115,58,32,102,32,45,32
 .byte 111,117,116,32,111,102,32,115
 .byte 112,97,99,101,10,0
L92:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,105,108,108,101,103,97,108
 .byte 32,116,97,103,10,0
L116:
 .byte 37,115,58,32,119,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,116,104,101,32,118,97,108
 .byte 117,101,32,111,102,32,37,115
 .byte 32,104,97,115,32,98,101,101
 .byte 110,32,114,101,100,101,99,108
 .byte 97,114,101,100,10,0
L156:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,36,37,100,32,40,37,115
 .byte 41,32,105,115,32,117,110,116
 .byte 121,112,101,100,10,0
L124:
 .byte 37,115,58,32,119,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,116,104,101,32,115,116,97
 .byte 114,116,32,115,121,109,98,111
 .byte 108,32,104,97,115,32,98,101
 .byte 101,110,32,114,101,100,101,99
 .byte 108,97,114,101,100,10,0
L72:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,117,110,109,97,116,99,104
 .byte 101,100,32,47,42,10,0
L168:
 .byte 37,115,58,32,101,32,45,32
 .byte 116,104,101,32,115,116,97,114
 .byte 116,32,115,121,109,98,111,108
 .byte 32,37,115,32,105,115,32,117
 .byte 110,100,101,102,105,110,101,100
 .byte 10,0
L132:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,97,32,116,111,107,101,110
 .byte 32,97,112,112,101,97,114,115
 .byte 32,111,110,32,116,104,101,32
 .byte 108,104,115,32,111,102,32,97
 .byte 32,112,114,111,100,117,99,116
 .byte 105,111,110,10,0
L80:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,117,110,109,97,116,99,104
 .byte 101,100,32,37,37,123,10,0
L108:
 .byte 37,115,58,32,119,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,116,104,101,32,116,121,112
 .byte 101,32,111,102,32,37,115,32
 .byte 104,97,115,32,98,101,101,110
 .byte 32,114,101,100,101,99,108,97
 .byte 114,101,100,10,0
L120:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,116,104,101,32,115,116,97
 .byte 114,116,32,115,121,109,98,111
 .byte 108,32,37,115,32,105,115,32
 .byte 97,32,116,111,107,101,110,10
 .byte 0
L68:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,115,121,110,116,97,120,32
 .byte 101,114,114,111,114,10,0
L16:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,117,110,101,120,112,101,99
 .byte 116,101,100,32,101,110,100,45
 .byte 111,102,45,102,105,108,101,10
 .byte 0
L172:
 .byte 37,115,58,32,119,32,45,32
 .byte 116,104,101,32,115,121,109,98
 .byte 111,108,32,37,115,32,105,115
 .byte 32,117,110,100,101,102,105,110
 .byte 101,100,10,0
L128:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,110,111,32,103,114,97,109
 .byte 109,97,114,32,104,97,115,32
 .byte 98,101,101,110,32,115,112,101
 .byte 99,105,102,105,101,100,10,0
L96:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,105,108,108,101,103,97,108
 .byte 32,99,104,97,114,97,99,116
 .byte 101,114,10,0
L76:
 .byte 37,115,58,32,101,32,45,32
 .byte 108,105,110,101,32,37,100,32
 .byte 111,102,32,34,37,115,34,44
 .byte 32,117,110,116,101,114,109,105
 .byte 110,97,116,101,100,32,115,116
 .byte 114,105,110,103,10,0

.globl _no_grammar
.globl _retyped_warning
.globl _syntax_error
.globl _dollar_error
.globl _done
.globl _restarted_warning
.globl _dollar_warning
.globl _terminal_start
.globl _default_action_warning
.globl _unknown_rhs
.globl _input_file_name
.globl _unterminated_union
.globl _prec_redeclared
.globl _lineno
.globl _unterminated_action
.globl _tokenized_start
.globl _terminal_lhs
.globl _unterminated_text
.globl ___flushbuf
.globl _untyped_lhs
.globl _revalued_warning
.globl _over_unionized
.globl _print_pos
.globl _open_error
.globl ___stderr
.globl _myname
.globl _undefined_symbol_warning
.globl _unexpected_EOF
.globl _illegal_tag
.globl _unterminated_comment
.globl _reprec_warning
.globl _used_reserved
.globl _fatal
.globl _undefined_goal
.globl _line
.globl _fprintf
.globl _untyped_rhs
.globl _unterminated_string
.globl _illegal_character
.globl _no_space
