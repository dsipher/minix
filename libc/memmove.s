##############################################################################
#
# memmove.s                                         tahoe/64 standard library
#
#                                  derived from NetBSD's bcopy.S for AMD64 by
#                     Wolfgang Solfrank (ws@tools.de), dsl@netbsd.org, et al.
#
#             FIXME: replace with version derived from MINIX or COHERENT libc
#
##############################################################################

.text

# void *memmove(void *s1, const void *s2, size_t n)

.global _memmove

_memmove:       movq %rdx, %rcx             # n
                movq %rdi, %rax             # must return s1
                movq %rdi, %r11             # for misalignment check

                movq %rdi, %r8
                subq %rsi, %r8

                shrq $3, %rcx               # bytes to 64-bit words
                jz small                    # fewer than 8 bytes

                leaq -8(%rdi,%rdx), %r9     # target address of last 8
                movq -8(%rsi,%rdx), %r10    # get last word
                cmpq %rdx, %r8              # overlapping?
                jb overlap

                # non-overlapping (forward) copy

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

                # overlapping (backward) copy

overlap:        leaq -8(%rsi,%rcx,8), %rsi
                leaq -8(%rdi,%rcx,8), %rdi
                std
                rep
                movsq
                cld
                movq %r10, (%r9)            # write last bytes
                ret

                # less than 8 bytes to copy

small:          movq %rdx, %rcx
                cmpq %rdx, %r8              # overlapping?
                jb osmall

                rep                         # no, (forward copy)
                movsb
                ret

osmall:         leaq -1(%rsi,%rcx),%rsi     # yes, (backward copy)
                leaq -1(%rdi,%rcx),%rdi
                std
                rep
                movsb
                cld
                ret

# vi: set ts=4 expandtab:
