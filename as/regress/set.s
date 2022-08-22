
	seto %al

	setno (%eax)

	setb (%ebp)
	setc 250(%ebp)
	setnae (%rbp)

	setnb (%rax)
	setnc 250(%rax)
	setae (%rax)

	setz %bl
	sete %r8b

	setnz %dil
	setne %r9b

	setbe (%r12d)
	setna (%r12)

	setnbe -100(%r15, %rbp, 2)
	seta %r15b

	sets %ah
	setns %bh

	setp %ch
	setpe %dh

	setnp %bpl
	setpo %dil

	setl %spl
	setnge %bpl

	setnl %r8b
	setge (%r8)

	setle -20000(%r13d)
	setng 20000(%r13)

	setnle (%r14,%rcx,2)
	setg (%r15d,%ecx,2)

