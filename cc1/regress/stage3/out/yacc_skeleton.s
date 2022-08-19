.data
.align 8
_banner:
	.quad L1
	.quad L2
	.quad L3
	.quad L4
	.quad L5
	.quad L6
	.quad L7
	.quad L8
	.quad L9
	.quad 0
.align 8
_tables:
	.quad L10
	.quad L11
	.quad L12
	.quad L13
	.quad L14
	.quad L15
	.quad L16
	.quad L17
	.quad L18
	.quad L19
	.quad L20
	.quad L21
	.quad L3
	.quad 0
.align 8
_header:
	.quad L22
	.quad L23
	.quad L24
	.quad L25
	.quad L26
	.quad L27
	.quad L25
	.quad L28
	.quad L29
	.quad L3
	.quad L3
	.quad L30
	.quad L31
	.quad L32
	.quad L33
	.quad L34
	.quad L35
	.quad L36
	.quad L37
	.quad L38
	.quad L39
	.quad L40
	.quad 0
.align 8
_body:
	.quad L41
	.quad L42
	.quad L43
	.quad L44
	.quad L45
	.quad L46
	.quad L47
	.quad L48
	.quad L19
	.quad L49
	.quad L50
	.quad L51
	.quad L52
	.quad L53
	.quad L54
	.quad L55
	.quad L56
	.quad L57
	.quad L3
	.quad L51
	.quad L58
	.quad L59
	.quad L60
	.quad L51
	.quad L61
	.quad L62
	.quad L63
	.quad L51
	.quad L64
	.quad L65
	.quad L66
	.quad L53
	.quad L67
	.quad L19
	.quad L68
	.quad L69
	.quad L70
	.quad L71
	.quad L72
	.quad L73
	.quad L74
	.quad L75
	.quad L3
	.quad L57
	.quad L76
	.quad L77
	.quad L53
	.quad L19
	.quad L68
	.quad L78
	.quad L79
	.quad L3
	.quad L80
	.quad L69
	.quad L81
	.quad L75
	.quad L82
	.quad L83
	.quad L84
	.quad L85
	.quad L86
	.quad L57
	.quad L87
	.quad L77
	.quad L53
	.quad L88
	.quad L89
	.quad L57
	.quad L90
	.quad L91
	.quad L92
	.quad L3
	.quad L93
	.quad L94
	.quad L91
	.quad L95
	.quad L3
	.quad L96
	.quad L97
	.quad L98
	.quad L99
	.quad L53
	.quad L100
	.quad L101
	.quad L69
	.quad L102
	.quad L103
	.quad L104
	.quad L19
	.quad L105
	.quad L106
	.quad L107
	.quad L3
	.quad L108
	.quad L109
	.quad L110
	.quad L111
	.quad L112
	.quad L113
	.quad L114
	.quad L115
	.quad L116
	.quad L104
	.quad L19
	.quad L105
	.quad L117
	.quad L118
	.quad L3
	.quad L119
	.quad L120
	.quad L121
	.quad L115
	.quad L75
	.quad L57
	.quad L122
	.quad L53
	.quad L123
	.quad L19
	.quad L68
	.quad L69
	.quad L70
	.quad L71
	.quad L72
	.quad L124
	.quad L74
	.quad L75
	.quad L3
	.quad L84
	.quad L86
	.quad L57
	.quad L125
	.quad L19
	.quad L126
	.quad L127
	.quad L128
	.quad L3
	.quad L129
	.quad L130
	.quad L131
	.quad L53
	.quad 0
.align 8
_trailer:
	.quad L57
	.quad L132
	.quad L133
	.quad L134
	.quad L135
	.quad L136
	.quad L53
	.quad L19
	.quad L68
	.quad L137
	.quad L138
	.quad L3
	.quad L139
	.quad L140
	.quad L141
	.quad L142
	.quad L69
	.quad L143
	.quad L19
	.quad L144
	.quad L104
	.quad L145
	.quad L146
	.quad L147
	.quad L148
	.quad L149
	.quad L115
	.quad L3
	.quad L75
	.quad L150
	.quad L86
	.quad L57
	.quad L151
	.quad L152
	.quad L153
	.quad L122
	.quad L154
	.quad L19
	.quad L126
	.quad L155
	.quad L156
	.quad L3
	.quad L157
	.quad L53
	.quad L158
	.quad L57
	.quad L159
	.quad L160
	.quad L161
	.quad L162
	.quad L163
	.quad L164
	.quad L165
	.quad L166
	.quad L167
	.quad L168
	.quad 0
.text

_write_section:
L169:
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
L170:
	movq _code_file(%rip),%r13
	movq %rdi,%r14
	xorl %r12d,%r12d
L172:
	movslq %r12d,%r12
	movq (%r14,%r12,8),%rbx
	testq %rbx,%rbx
	jz L171
L173:
	incl _outline(%rip)
L176:
	movsbl (%rbx),%edi
	movl (%r13),%eax
	decl %eax
	testl %edi,%edi
	jz L178
L177:
	movl %eax,(%r13)
	cmpl $0,%eax
	jl L180
L179:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movb %dil,(%rcx)
	jmp L181
L180:
	movq %r13,%rsi
	call ___flushbuf
L181:
	incq %rbx
	jmp L176
L178:
	movl %eax,(%r13)
	cmpl $0,%eax
	jl L183
L182:
	movq 24(%r13),%rcx
	leaq 1(%rcx),%rax
	movq %rax,24(%r13)
	movb $10,(%rcx)
	jmp L184
L183:
	movq %r13,%rsi
	movl $10,%edi
	call ___flushbuf
L184:
	incl %r12d
	jmp L172
L171:
	popq %r14
	popq %r13
	popq %r12
	popq %rbx
	ret 

L158:
	.byte 32,32,32,32,32,32,32,32
	.byte 103,111,116,111,32,121,121,111
	.byte 118,101,114,102,108,111,119,59
	.byte 0
L51:
	.byte 0
L38:
	.byte 115,104,111,114,116,32,121,121
	.byte 115,115,91,89,89,83,84,65
	.byte 67,75,83,73,90,69,93,59
	.byte 0
L70:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,121,121,115,32
	.byte 61,32,48,59,0
L98:
	.byte 121,121,105,110,114,101,99,111
	.byte 118,101,114,121,58,0
L90:
	.byte 32,32,32,32,105,102,32,40
	.byte 121,121,101,114,114,102,108,97
	.byte 103,41,32,103,111,116,111,32
	.byte 121,121,105,110,114,101,99,111
	.byte 118,101,114,121,59,0
L91:
	.byte 35,105,102,100,101,102,32,108
	.byte 105,110,116,0
L160:
	.byte 32,32,32,32,42,43,43,121
	.byte 121,118,115,112,32,61,32,121
	.byte 121,118,97,108,59,0
L100:
	.byte 32,32,32,32,32,32,32,32
	.byte 121,121,101,114,114,102,108,97
	.byte 103,32,61,32,51,59,0
L81:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,103,111,116,111
	.byte 32,121,121,111,118,101,114,102
	.byte 108,111,119,59,0
L83:
	.byte 32,32,32,32,32,32,32,32
	.byte 42,43,43,121,121,118,115,112
	.byte 32,61,32,121,121,108,118,97
	.byte 108,59,0
L48:
	.byte 32,32,32,32,114,101,103,105
	.byte 115,116,101,114,32,105,110,116
	.byte 32,121,121,109,44,32,121,121
	.byte 110,44,32,121,121,115,116,97
	.byte 116,101,59,0
L118:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,89,89,80,82
	.byte 69,70,73,88,44,32,42,121
	.byte 121,115,115,112,41,59,0
L131:
	.byte 32,32,32,32,115,119,105,116
	.byte 99,104,32,40,121,121,110,41
	.byte 0
L86:
	.byte 32,32,32,32,32,32,32,32
	.byte 103,111,116,111,32,121,121,108
	.byte 111,111,112,59,0
L132:
	.byte 32,32,32,32,121,121,115,115
	.byte 112,32,45,61,32,121,121,109
	.byte 59,0
L12:
	.byte 101,120,116,101,114,110,32,115
	.byte 104,111,114,116,32,121,121,100
	.byte 101,102,114,101,100,91,93,59
	.byte 0
L19:
	.byte 35,105,102,32,89,89,68,69
	.byte 66,85,71,0
L120:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 45,45,121,121,115,115,112,59
	.byte 0
L28:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,83,84,65,67,75,83
	.byte 73,90,69,32,53,48,48,0
L57:
	.byte 32,32,32,32,125,0
L122:
	.byte 32,32,32,32,101,108,115,101
	.byte 0
L127:
	.byte 32,32,32,32,32,32,32,32
	.byte 112,114,105,110,116,102,40,34
	.byte 37,115,100,101,98,117,103,58
	.byte 32,115,116,97,116,101,32,37
	.byte 100,44,32,114,101,100,117,99
	.byte 105,110,103,32,98,121,32,114
	.byte 117,108,101,32,37,100,32,40
	.byte 37,115,41,92,110,34,44,0
L110:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,103,111,116,111
	.byte 32,121,121,111,118,101,114,102
	.byte 108,111,119,59,0
L114:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 103,111,116,111,32,121,121,108
	.byte 111,111,112,59,0
L93:
	.byte 121,121,110,101,119,101,114,114
	.byte 111,114,58,0
L11:
	.byte 101,120,116,101,114,110,32,115
	.byte 104,111,114,116,32,121,121,108
	.byte 101,110,91,93,59,0
L71:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,105,102,32,40
	.byte 121,121,99,104,97,114,32,60
	.byte 61,32,89,89,77,65,88,84
	.byte 79,75,69,78,41,32,121,121
	.byte 115,32,61,32,121,121,110,97
	.byte 109,101,91,121,121,99,104,97
	.byte 114,93,59,0
L56:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,121,121,100,101
	.byte 98,117,103,32,61,32,121,121
	.byte 110,32,45,32,39,48,39,59
	.byte 0
L4:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,66,89,65,67,67,32
	.byte 49,0
L33:
	.byte 105,110,116,32,121,121,99,104
	.byte 97,114,59,0
L49:
	.byte 32,32,32,32,114,101,103,105
	.byte 115,116,101,114,32,99,104,97
	.byte 114,32,42,121,121,115,59,0
L145:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 121,121,115,32,61,32,48,59
	.byte 0
L62:
	.byte 32,32,32,32,121,121,118,115
	.byte 112,32,61,32,121,121,118,115
	.byte 59,0
L36:
	.byte 89,89,83,84,89,80,69,32
	.byte 121,121,118,97,108,59,0
L141:
	.byte 32,32,32,32,32,32,32,32
	.byte 42,43,43,121,121,118,115,112
	.byte 32,61,32,121,121,118,97,108
	.byte 59,0
L6:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,77,73,78,79,82,32
	.byte 57,0
L88:
	.byte 32,32,32,32,32,32,32,32
	.byte 121,121,110,32,61,32,121,121
	.byte 116,97,98,108,101,91,121,121
	.byte 110,93,59,0
L21:
	.byte 101,120,116,101,114,110,32,99
	.byte 104,97,114,32,42,121,121,114
	.byte 117,108,101,91,93,59,0
L50:
	.byte 32,32,32,32,101,120,116,101
	.byte 114,110,32,99,104,97,114,32
	.byte 42,103,101,116,101,110,118,40
	.byte 41,59,0
L147:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,33,121,121,115
	.byte 41,32,121,121,115,32,61,32
	.byte 34,105,108,108,101,103,97,108
	.byte 45,115,121,109,98,111,108,34
	.byte 59,0
L1:
	.byte 35,105,102,110,100,101,102,32
	.byte 108,105,110,116,0
L130:
	.byte 32,32,32,32,121,121,118,97
	.byte 108,32,61,32,121,121,118,115
	.byte 112,91,49,45,121,121,109,93
	.byte 59,0
L30:
	.byte 105,110,116,32,121,121,100,101
	.byte 98,117,103,59,0
L134:
	.byte 32,32,32,32,121,121,118,115
	.byte 112,32,45,61,32,121,121,109
	.byte 59,0
L64:
	.byte 121,121,108,111,111,112,58,0
L10:
	.byte 101,120,116,101,114,110,32,115
	.byte 104,111,114,116,32,121,121,108
	.byte 104,115,91,93,59,0
L125:
	.byte 121,121,114,101,100,117,99,101
	.byte 58,0
L112:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 42,43,43,121,121,115,115,112
	.byte 32,61,32,121,121,115,116,97
	.byte 116,101,32,61,32,121,121,116
	.byte 97,98,108,101,91,121,121,110
	.byte 93,59,0
L69:
	.byte 32,32,32,32,32,32,32,32
	.byte 123,0
L22:
	.byte 35,105,102,100,101,102,32,89
	.byte 89,83,84,65,67,75,83,73
	.byte 90,69,0
L32:
	.byte 105,110,116,32,121,121,101,114
	.byte 114,102,108,97,103,59,0
L148:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 112,114,105,110,116,102,40,34
	.byte 37,115,100,101,98,117,103,58
	.byte 32,115,116,97,116,101,32,37
	.byte 100,44,32,114,101,97,100,105
	.byte 110,103,32,37,100,32,40,37
	.byte 115,41,92,110,34,44,0
L142:
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,99,104
	.byte 97,114,32,60,32,48,41,0
L17:
	.byte 101,120,116,101,114,110,32,115
	.byte 104,111,114,116,32,121,121,116
	.byte 97,98,108,101,91,93,59,0
L5:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,77,65,74,79,82,32
	.byte 49,0
L3:
	.byte 35,101,110,100,105,102,0
L87:
	.byte 32,32,32,32,105,102,32,40
	.byte 40,121,121,110,32,61,32,121
	.byte 121,114,105,110,100,101,120,91
	.byte 121,121,115,116,97,116,101,93
	.byte 41,32,38,38,32,40,121,121
	.byte 110,32,43,61,32,121,121,99
	.byte 104,97,114,41,32,62,61,32
	.byte 48,32,38,38,0
L67:
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,40,121,121,99
	.byte 104,97,114,32,61,32,121,121
	.byte 108,101,120,40,41,41,32,60
	.byte 32,48,41,32,121,121,99,104
	.byte 97,114,32,61,32,48,59,0
L2:
	.byte 115,116,97,116,105,99,32,99
	.byte 104,97,114,32,121,121,115,99
	.byte 99,115,105,100,91,93,32,61
	.byte 32,34,64,40,35,41,121,97
	.byte 99,99,112,97,114,9,49,46
	.byte 57,32,40,66,101,114,107,101
	.byte 108,101,121,41,32,48,50,47
	.byte 50,49,47,57,51,34,59,0
L121:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 45,45,121,121,118,115,112,59
	.byte 0
L73:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,112,114,105,110
	.byte 116,102,40,34,37,115,100,101
	.byte 98,117,103,58,32,115,116,97
	.byte 116,101,32,37,100,44,32,114
	.byte 101,97,100,105,110,103,32,37
	.byte 100,32,40,37,115,41,92,110
	.byte 34,44,0
L136:
	.byte 32,32,32,32,105,102,32,40
	.byte 121,121,115,116,97,116,101,32
	.byte 61,61,32,48,32,38,38,32
	.byte 121,121,109,32,61,61,32,48
	.byte 41,0
L146:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,99,104
	.byte 97,114,32,60,61,32,89,89
	.byte 77,65,88,84,79,75,69,78
	.byte 41,32,121,121,115,32,61,32
	.byte 121,121,110,97,109,101,91,121
	.byte 121,99,104,97,114,93,59,0
L34:
	.byte 115,104,111,114,116,32,42,121
	.byte 121,115,115,112,59,0
L29:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,77,65,88,68,69,80
	.byte 84,72,32,53,48,48,0
L115:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,125,0
L58:
	.byte 32,32,32,32,121,121,110,101
	.byte 114,114,115,32,61,32,48,59
	.byte 0
L92:
	.byte 32,32,32,32,103,111,116,111
	.byte 32,121,121,110,101,119,101,114
	.byte 114,111,114,59,0
L150:
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,99,104
	.byte 97,114,32,61,61,32,48,41
	.byte 32,103,111,116,111,32,121,121
	.byte 97,99,99,101,112,116,59,0
L138:
	.byte 32,115,116,97,116,101,32,37
	.byte 100,92,110,34,44,32,89,89
	.byte 80,82,69,70,73,88,44,32
	.byte 89,89,70,73,78,65,76,41
	.byte 59,0
L133:
	.byte 32,32,32,32,121,121,115,116
	.byte 97,116,101,32,61,32,42,121
	.byte 121,115,115,112,59,0
L80:
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,115,115
	.byte 112,32,62,61,32,121,121,115
	.byte 115,32,43,32,121,121,115,116
	.byte 97,99,107,115,105,122,101,32
	.byte 45,32,49,41,0
L60:
	.byte 32,32,32,32,121,121,99,104
	.byte 97,114,32,61,32,40,45,49
	.byte 41,59,0
L47:
	.byte 123,0
L108:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,115,115
	.byte 112,32,62,61,32,121,121,115
	.byte 115,32,43,32,121,121,115,116
	.byte 97,99,107,115,105,122,101,32
	.byte 45,32,49,41,0
L124:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,112,114,105,110
	.byte 116,102,40,34,37,115,100,101
	.byte 98,117,103,58,32,115,116,97
	.byte 116,101,32,37,100,44,32,101
	.byte 114,114,111,114,32,114,101,99
	.byte 111,118,101,114,121,32,100,105
	.byte 115,99,97,114,100,115,32,116
	.byte 111,107,101,110,32,37,100,32
	.byte 40,37,115,41,92,110,34,44
	.byte 0
L106:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,112,114,105,110
	.byte 116,102,40,34,37,115,100,101
	.byte 98,117,103,58,32,115,116,97
	.byte 116,101,32,37,100,44,32,101
	.byte 114,114,111,114,32,114,101,99
	.byte 111,118,101,114,121,32,115,104
	.byte 105,102,116,105,110,103,92,0
L9:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,82,69,67,79,86,69
	.byte 82,73,78,71,32,40,121,121
	.byte 101,114,114,102,108,97,103,33
	.byte 61,48,41,0
L113:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 42,43,43,121,121,118,115,112
	.byte 32,61,32,121,121,108,118,97
	.byte 108,59,0
L8:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,101,114,114,111,107,32
	.byte 40,121,121,101,114,114,102,108
	.byte 97,103,61,48,41,0
L162:
	.byte 121,121,111,118,101,114,102,108
	.byte 111,119,58,0
L61:
	.byte 32,32,32,32,121,121,115,115
	.byte 112,32,61,32,121,121,115,115
	.byte 59,0
L139:
	.byte 32,32,32,32,32,32,32,32
	.byte 121,121,115,116,97,116,101,32
	.byte 61,32,89,89,70,73,78,65
	.byte 76,59,0
L59:
	.byte 32,32,32,32,121,121,101,114
	.byte 114,102,108,97,103,32,61,32
	.byte 48,59,0
L103:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,121,121,110,32
	.byte 60,61,32,89,89,84,65,66
	.byte 76,69,83,73,90,69,32,38
	.byte 38,32,121,121,99,104,101,99
	.byte 107,91,121,121,110,93,32,61
	.byte 61,32,89,89,69,82,82,67
	.byte 79,68,69,41,0
L77:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,121,121,110,32
	.byte 60,61,32,89,89,84,65,66
	.byte 76,69,83,73,90,69,32,38
	.byte 38,32,121,121,99,104,101,99
	.byte 107,91,121,121,110,93,32,61
	.byte 61,32,121,121,99,104,97,114
	.byte 41,0
L16:
	.byte 101,120,116,101,114,110,32,115
	.byte 104,111,114,116,32,121,121,103
	.byte 105,110,100,101,120,91,93,59
	.byte 0
L46:
	.byte 121,121,112,97,114,115,101,40
	.byte 41,0
L109:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 123,0
L152:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,121,121,110,32
	.byte 60,61,32,89,89,84,65,66
	.byte 76,69,83,73,90,69,32,38
	.byte 38,32,121,121,99,104,101,99
	.byte 107,91,121,121,110,93,32,61
	.byte 61,32,121,121,115,116,97,116
	.byte 101,41,0
L166:
	.byte 121,121,97,99,99,101,112,116
	.byte 58,0
L126:
	.byte 32,32,32,32,105,102,32,40
	.byte 121,121,100,101,98,117,103,41
	.byte 0
L42:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,82,69,74,69,67,84
	.byte 32,103,111,116,111,32,121,121
	.byte 97,98,111,114,116,0
L156:
	.byte 116,111,32,115,116,97,116,101
	.byte 32,37,100,92,110,34,44,32
	.byte 89,89,80,82,69,70,73,88
	.byte 44,32,42,121,121,115,115,112
	.byte 44,32,121,121,115,116,97,116
	.byte 101,41,59,0
L82:
	.byte 32,32,32,32,32,32,32,32
	.byte 42,43,43,121,121,115,115,112
	.byte 32,61,32,121,121,115,116,97
	.byte 116,101,32,61,32,121,121,116
	.byte 97,98,108,101,91,121,121,110
	.byte 93,59,0
L151:
	.byte 32,32,32,32,105,102,32,40
	.byte 40,121,121,110,32,61,32,121
	.byte 121,103,105,110,100,101,120,91
	.byte 121,121,109,93,41,32,38,38
	.byte 32,40,121,121,110,32,43,61
	.byte 32,121,121,115,116,97,116,101
	.byte 41,32,62,61,32,48,32,38
	.byte 38,0
L129:
	.byte 32,32,32,32,121,121,109,32
	.byte 61,32,121,121,108,101,110,91
	.byte 121,121,110,93,59,0
L40:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,115,116,97,99,107,115
	.byte 105,122,101,32,89,89,83,84
	.byte 65,67,75,83,73,90,69,0
L94:
	.byte 32,32,32,32,121,121,101,114
	.byte 114,111,114,40,34,115,121,110
	.byte 116,97,120,32,101,114,114,111
	.byte 114,34,41,59,0
L161:
	.byte 32,32,32,32,103,111,116,111
	.byte 32,121,121,108,111,111,112,59
	.byte 0
L63:
	.byte 32,32,32,32,42,121,121,115
	.byte 115,112,32,61,32,121,121,115
	.byte 116,97,116,101,32,61,32,48
	.byte 59,0
L66:
	.byte 32,32,32,32,105,102,32,40
	.byte 121,121,99,104,97,114,32,60
	.byte 32,48,41,0
L84:
	.byte 32,32,32,32,32,32,32,32
	.byte 121,121,99,104,97,114,32,61
	.byte 32,40,45,49,41,59,0
L7:
	.byte 35,100,101,102,105,110,101,32
	.byte 121,121,99,108,101,97,114,105
	.byte 110,32,40,121,121,99,104,97
	.byte 114,61,40,45,49,41,41,0
L123:
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,99,104
	.byte 97,114,32,61,61,32,48,41
	.byte 32,103,111,116,111,32,121,121
	.byte 97,98,111,114,116,59,0
L168:
	.byte 125,0
L45:
	.byte 105,110,116,0
L111:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 125,0
L164:
	.byte 121,121,97,98,111,114,116,58
	.byte 0
L102:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,105,102,32,40
	.byte 40,121,121,110,32,61,32,121
	.byte 121,115,105,110,100,101,120,91
	.byte 42,121,121,115,115,112,93,41
	.byte 32,38,38,32,40,121,121,110
	.byte 32,43,61,32,89,89,69,82
	.byte 82,67,79,68,69,41,32,62
	.byte 61,32,48,32,38,38,0
L153:
	.byte 32,32,32,32,32,32,32,32
	.byte 121,121,115,116,97,116,101,32
	.byte 61,32,121,121,116,97,98,108
	.byte 101,91,121,121,110,93,59,0
L18:
	.byte 101,120,116,101,114,110,32,115
	.byte 104,111,114,116,32,121,121,99
	.byte 104,101,99,107,91,93,59,0
L149:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 89,89,80,82,69,70,73,88
	.byte 44,32,89,89,70,73,78,65
	.byte 76,44,32,121,121,99,104,97
	.byte 114,44,32,121,121,115,41,59
	.byte 0
L14:
	.byte 101,120,116,101,114,110,32,115
	.byte 104,111,114,116,32,121,121,115
	.byte 105,110,100,101,120,91,93,59
	.byte 0
L79:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,89,89,80,82
	.byte 69,70,73,88,44,32,121,121
	.byte 115,116,97,116,101,44,32,121
	.byte 121,116,97,98,108,101,91,121
	.byte 121,110,93,41,59,0
L159:
	.byte 32,32,32,32,42,43,43,121
	.byte 121,115,115,112,32,61,32,121
	.byte 121,115,116,97,116,101,59,0
L75:
	.byte 32,32,32,32,32,32,32,32
	.byte 125,0
L44:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,69,82,82,79,82,32
	.byte 103,111,116,111,32,121,121,101
	.byte 114,114,108,97,98,0
L39:
	.byte 89,89,83,84,89,80,69,32
	.byte 121,121,118,115,91,89,89,83
	.byte 84,65,67,75,83,73,90,69
	.byte 93,59,0
L26:
	.byte 35,105,102,100,101,102,32,89
	.byte 89,77,65,88,68,69,80,84
	.byte 72,0
L99:
	.byte 32,32,32,32,105,102,32,40
	.byte 121,121,101,114,114,102,108,97
	.byte 103,32,60,32,51,41,0
L117:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,112,114,105,110
	.byte 116,102,40,34,37,115,100,101
	.byte 98,117,103,58,32,101,114,114
	.byte 111,114,32,114,101,99,111,118
	.byte 101,114,121,32,100,105,115,99
	.byte 97,114,100,105,110,103,32,115
	.byte 116,97,116,101,32,37,100,92
	.byte 110,34,44,0
L78:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,112,114,105,110
	.byte 116,102,40,34,37,115,100,101
	.byte 98,117,103,58,32,115,116,97
	.byte 116,101,32,37,100,44,32,115
	.byte 104,105,102,116,105,110,103,32
	.byte 116,111,32,115,116,97,116,101
	.byte 32,37,100,92,110,34,44,0
L43:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,65,67,67,69,80,84
	.byte 32,103,111,116,111,32,121,121
	.byte 97,99,99,101,112,116,0
L137:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,112,114,105,110
	.byte 116,102,40,34,37,115,100,101
	.byte 98,117,103,58,32,97,102,116
	.byte 101,114,32,114,101,100,117,99
	.byte 116,105,111,110,44,32,115,104
	.byte 105,102,116,105,110,103,32,102
	.byte 114,111,109,32,115,116,97,116
	.byte 101,32,48,32,116,111,92,0
L155:
	.byte 32,32,32,32,32,32,32,32
	.byte 112,114,105,110,116,102,40,34
	.byte 37,115,100,101,98,117,103,58
	.byte 32,97,102,116,101,114,32,114
	.byte 101,100,117,99,116,105,111,110
	.byte 44,32,115,104,105,102,116,105
	.byte 110,103,32,102,114,111,109,32
	.byte 115,116,97,116,101,32,37,100
	.byte 32,92,0
L140:
	.byte 32,32,32,32,32,32,32,32
	.byte 42,43,43,121,121,115,115,112
	.byte 32,61,32,89,89,70,73,78
	.byte 65,76,59,0
L104:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,123,0
L163:
	.byte 32,32,32,32,121,121,101,114
	.byte 114,111,114,40,34,121,97,99
	.byte 99,32,115,116,97,99,107,32
	.byte 111,118,101,114,102,108,111,119
	.byte 34,41,59,0
L165:
	.byte 32,32,32,32,114,101,116,117
	.byte 114,110,32,40,49,41,59,0
L95:
	.byte 32,32,32,32,103,111,116,111
	.byte 32,121,121,101,114,114,108,97
	.byte 98,59,0
L41:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,65,66,79,82,84,32
	.byte 103,111,116,111,32,121,121,97
	.byte 98,111,114,116,0
L65:
	.byte 32,32,32,32,105,102,32,40
	.byte 121,121,110,32,61,32,121,121
	.byte 100,101,102,114,101,100,91,121
	.byte 121,115,116,97,116,101,93,41
	.byte 32,103,111,116,111,32,121,121
	.byte 114,101,100,117,99,101,59,0
L72:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,105,102,32,40
	.byte 33,121,121,115,41,32,121,121
	.byte 115,32,61,32,34,105,108,108
	.byte 101,103,97,108,45,115,121,109
	.byte 98,111,108,34,59,0
L25:
	.byte 35,101,108,115,101,0
L76:
	.byte 32,32,32,32,105,102,32,40
	.byte 40,121,121,110,32,61,32,121
	.byte 121,115,105,110,100,101,120,91
	.byte 121,121,115,116,97,116,101,93
	.byte 41,32,38,38,32,40,121,121
	.byte 110,32,43,61,32,121,121,99
	.byte 104,97,114,41,32,62,61,32
	.byte 48,32,38,38,0
L167:
	.byte 32,32,32,32,114,101,116,117
	.byte 114,110,32,40,48,41,59,0
L53:
	.byte 32,32,32,32,123,0
L119:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,115,115
	.byte 112,32,60,61,32,121,121,115
	.byte 115,41,32,103,111,116,111,32
	.byte 121,121,97,98,111,114,116,59
	.byte 0
L54:
	.byte 32,32,32,32,32,32,32,32
	.byte 121,121,110,32,61,32,42,121
	.byte 121,115,59,0
L97:
	.byte 32,32,32,32,43,43,121,121
	.byte 110,101,114,114,115,59,0
L23:
	.byte 35,117,110,100,101,102,32,89
	.byte 89,77,65,88,68,69,80,84
	.byte 72,0
L24:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,77,65,88,68,69,80
	.byte 84,72,32,89,89,83,84,65
	.byte 67,75,83,73,90,69,0
L144:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,105,102,32,40
	.byte 121,121,100,101,98,117,103,41
	.byte 0
L15:
	.byte 101,120,116,101,114,110,32,115
	.byte 104,111,114,116,32,121,121,114
	.byte 105,110,100,101,120,91,93,59
	.byte 0
L143:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,105,102,32,40
	.byte 40,121,121,99,104,97,114,32
	.byte 61,32,121,121,108,101,120,40
	.byte 41,41,32,60,32,48,41,32
	.byte 121,121,99,104,97,114,32,61
	.byte 32,48,59,0
L105:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,100,101
	.byte 98,117,103,41,0
L85:
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,101,114
	.byte 114,102,108,97,103,32,62,32
	.byte 48,41,32,32,45,45,121,121
	.byte 101,114,114,102,108,97,103,59
	.byte 0
L37:
	.byte 89,89,83,84,89,80,69,32
	.byte 121,121,108,118,97,108,59,0
L157:
	.byte 32,32,32,32,105,102,32,40
	.byte 121,121,115,115,112,32,62,61
	.byte 32,121,121,115,115,32,43,32
	.byte 121,121,115,116,97,99,107,115
	.byte 105,122,101,32,45,32,49,41
	.byte 0
L68:
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,100,101
	.byte 98,117,103,41,0
L31:
	.byte 105,110,116,32,121,121,110,101
	.byte 114,114,115,59,0
L107:
	.byte 32,116,111,32,115,116,97,116
	.byte 101,32,37,100,92,110,34,44
	.byte 32,89,89,80,82,69,70,73
	.byte 88,44,32,42,121,121,115,115
	.byte 112,44,32,121,121,116,97,98
	.byte 108,101,91,121,121,110,93,41
	.byte 59,0
L96:
	.byte 121,121,101,114,114,108,97,98
	.byte 58,0
L13:
	.byte 101,120,116,101,114,110,32,115
	.byte 104,111,114,116,32,121,121,100
	.byte 103,111,116,111,91,93,59,0
L154:
	.byte 32,32,32,32,32,32,32,32
	.byte 121,121,115,116,97,116,101,32
	.byte 61,32,121,121,100,103,111,116
	.byte 111,91,121,121,109,93,59,0
L52:
	.byte 32,32,32,32,105,102,32,40
	.byte 121,121,115,32,61,32,103,101
	.byte 116,101,110,118,40,34,89,89
	.byte 68,69,66,85,71,34,41,41
	.byte 0
L74:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,89,89,80,82
	.byte 69,70,73,88,44,32,121,121
	.byte 115,116,97,116,101,44,32,121
	.byte 121,99,104,97,114,44,32,121
	.byte 121,115,41,59,0
L35:
	.byte 89,89,83,84,89,80,69,32
	.byte 42,121,121,118,115,112,59,0
L27:
	.byte 35,100,101,102,105,110,101,32
	.byte 89,89,83,84,65,67,75,83
	.byte 73,90,69,32,89,89,77,65
	.byte 88,68,69,80,84,72,0
L128:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,32,32,32,32
	.byte 89,89,80,82,69,70,73,88
	.byte 44,32,121,121,115,116,97,116
	.byte 101,44,32,121,121,110,44,32
	.byte 121,121,114,117,108,101,91,121
	.byte 121,110,93,41,59,0
L55:
	.byte 32,32,32,32,32,32,32,32
	.byte 105,102,32,40,121,121,110,32
	.byte 62,61,32,39,48,39,32,38
	.byte 38,32,121,121,110,32,60,61
	.byte 32,39,57,39,41,0
L20:
	.byte 101,120,116,101,114,110,32,99
	.byte 104,97,114,32,42,121,121,110
	.byte 97,109,101,91,93,59,0
L135:
	.byte 32,32,32,32,121,121,109,32
	.byte 61,32,121,121,108,104,115,91
	.byte 121,121,110,93,59,0
L101:
	.byte 32,32,32,32,32,32,32,32
	.byte 102,111,114,32,40,59,59,41
	.byte 0
L116:
	.byte 32,32,32,32,32,32,32,32
	.byte 32,32,32,32,101,108,115,101
	.byte 0
L89:
	.byte 32,32,32,32,32,32,32,32
	.byte 103,111,116,111,32,121,121,114
	.byte 101,100,117,99,101,59,0

.globl _header
.globl _write_section
.globl _banner
.globl _code_file
.globl _body
.globl _tables
.globl _outline
.globl _trailer
.globl ___flushbuf