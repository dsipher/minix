.code16

		call routine16
		call routine32
		call *routine16
		call %ax
		call *%ax
		call *%ebx
routine16:

.code32

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
routine64:
