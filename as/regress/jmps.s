.code16

		call routine16
		call routine32
		call *routine16
		call %ax
		call *%ax
		call *%ebx
		jo routine16
		jno routine16
		jb routine16
		jc routine16
		jnae routine16
		jnb routine16
		jnc routine16
		jae routine16
		jz routine16
		je routine16
		jnz routine16
		jne routine16
		jbe routine16
		jna routine16
		jnbe routine16
		ja routine16
		js routine16
		jns routine16
		jp routine16
		jpe routine16
		jnp routine16
		jpo routine16
		jl routine16
		jnge routine16
		jnl routine16
		jge routine16
		jle routine16
		jng routine16
		jnle routine16
		jg routine16

		.org 0xB0

routine16:

.code32
		jo routine16
		jno routine16
		jb routine16
		jc routine16
		jnae routine16
		jnb routine16
		jnc routine16
		jae routine16
		jz routine16
		je routine16
		jnz routine16
		jne routine16
		jbe routine16
		jna routine16
		jnbe routine16
		ja routine16
		js routine16
		jns routine16
		jp routine16
		jpe routine16
		jnp routine16
		jpo routine16
		jl routine16
		jnge routine16
		jnl routine16
		jge routine16
		jle routine16
		jng routine16
		jnle routine16
		jg routine16

		call routine16
		call routine32
		call *routine32
		call %ax
		call *%ax
		call *%ebx
routine32:

.code64
		call routine16
		call routine32
		call *routine64
		call %ax
		call *%ax
		call *%rbx
		jo routine16
		jno routine16
		jb routine16
		jc routine16
		jnae routine16
		jnb routine16
		jnc routine16
		jae routine16
		jz routine16
		je routine16
		jnz routine16
		jne routine16
		jbe routine16
		jna routine16
		jnbe routine16
		ja routine16
		js routine16
		jns routine16
		jp routine16
		jpe routine16
		jnp routine16
		jpo routine16
		jl routine16
		jnge routine16
		jnl routine16
		jge routine16
		jle routine16
		jng routine16
		jnle routine16
		jg routine16
routine64:
