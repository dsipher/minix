##############################################################################
#
# memcpy.s                                          tahoe/64 standard library
#
#                                  derived from NetBSD's bcopy.S for AMD64 by
#                     Wolfgang Solfrank (ws@tools.de), dsl@netbsd.org, et al.
#
#             FIXME: replace with version derived from MINIX or COHERENT libc
#
##############################################################################

.text

# void *memcpy(void *s1, const void *s2, size_t n)

.global _memcpy

_memcpy:        movq %rdx, %rcx             # n
                movq %rdi, %rax             # must return s1
                movq %rdi, %r11             # for misalignment check

                shrq $3, %rcx               # bytes to 64-bit words
                jz small                    # fewer than 8 bytes

                leaq -8(%rdi,%rdx), %r9     # target address of last 8
                movq -8(%rsi,%rdx), %r10    # get last word

                andq $7, %r11               # destination misaligned?
                jnz misaligned
                rep
                movsq
                movq %r10, (%r9)            # write last word
                ret

                # misaligned; adjust to align the destination.

misaligned:     leaq -9(%r11,%rdx),%rcx     # post realignment count
                negq %r11                   # now -1 .. -7
                movq (%rsi),%rdx            # get first word
                movq %rdi, %r8              # target for first word
                leaq 8(%rsi,%r11),%rsi
                leaq 8(%rdi,%r11),%rdi
                shrq $3, %rcx
                rep
                movsq
                movq %rdx,(%r8)             # write first word
                movq %r10,(%r9)             # write last word
                ret

                # less than 8 bytes to copy

small:          movq %rdx, %rcx
                rep
                movsb
                ret

# vi: set ts=4 expandtab:
