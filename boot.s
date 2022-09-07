//////////////////////////////////////////////////////////////////////////////
/
/  boot.s                                              tahoe/64 boot block
/
//////////////////////////////////////////////////////////////////////////////
/
/  Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).
/
/  Redistribution and use in source and binary forms, with or without
/  modification, are permitted provided that the following conditions
/  are met:
/
/  * Redistributions of source code must retain the above copyright
/    notice, this list of conditions and the following disclaimer.
/
/  * Redistributions in binary form must reproduce the above copyright
/    notice, this list of conditions and the following disclaimer in the
/    documentation and/or other materials provided with the distribution.
/
/  THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
/  "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
/  LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
/  FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
/  COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
/  INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
/  BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
/  OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
/  ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
/  TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
/  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
/
//////////////////////////////////////////////////////////////////////////////

/ the boot block occupies block 0, which is shared with the superblock data.
/ many of the addresses, both explicit an implicit, in this file are shared
/ with the kernel. any changes must be cross-checked/synced with sys/boot.h.

/ after some wrestling with the BIOS, we are loaded at 0x1000 absolute.
/ like all other executables we have an a.out header glued to the front.

BOOT_ADDR           =   0x1000      / base of boot page
BIOS_ADDR           =   0x7C00      / where the BIOS loads us
BOOT_SEG            =   0x0100      / segment portion of BOOT_ADDR
ORIGIN              =   0x1020      / address of `boot' (skipping header)

/ the kernel is loaded starting at 0x8000 (32k). to leave sufficient
/ room for the kernel bss, we limit the kernel size to 512-32 = 480k.

KERNEL_SEG          =   0x0800
KERNEL_ADDR         =   0x8000
MAX_KERNEL          =   491520

/ the zero page is ultimately unmapped by the kernel, but not until all the
/ CPUs are spun up. we use the part not used by the BIOS for temporary data.

BOOT_STACK          =   0x1000      / extends downwards into the zero page

DINODE              =   0x0700      / the `open' dinode (0x700-0x77F)
DINODE_MODE         =   0x0700      / dinode.di_mode
DINODE_SIZE         =   0x0710      / dinode.di_size
DINODE_ADDR         =   0x0734      / dinode.di_addr[]
DINODE_INDIRECT     =   0x0774      / dinode.di_addr[INDIRECT_BLOCK]

SIZEOF_DINODE       =   128         / size of struct dinode
LOG2_SIZEOF_DINODE  =   7           / .. which is 2^7

DIRECT              =   0x0780      / directory entry for `lookup'
DIRECT_INO          =   0x0780      / direct.d_ino
DIRECT_NAME         =   0x0784      / direct.d_name

SIZEOF_DIRECT       =   32          / size of struct direct

DAP                 =   0x07F0      / disk address packet
DAP_SIZE            =   0           / (byte) size of packet
DAP_ZERO            =   1           / (byte) must-be-zero
DAP_COUNT           =   2           / (word) sector count
DAP_OFS             =   4           / (word) buffer offset address
DAP_SEG             =   6           / (word) buffer segment address
DAP_LSN             =   8           / (qword) logical sector number

SIZEOF_DAP          =   16          / DAP packet is 16 bytes

/ boot sets up the initial system page tables,
/ identity-mapping the first 2MB in 4K pages.

PML3                =   0x2000      / the Intel/AMD manuals give all these
PML2                =   0x3000      / levels ridiculous legacy names that
PML1                =   0x4000      / make little sense. we just call them
PML0                =   0x5000      / what they are, `nth-level page table'

/ we record the BIOS-reported memory map here. we deliberately use this
/ instead of ACPI, so we don't have to play games to map in ACPI tables
/ before we've initialized memory management. chicken-and-egg stuff.

E820_N              =   0x6000      / count of BIOS E820 map entries
E820_MAP            =   0x6008      / the map itself (0x6008 - 0x6BFF)
SIZEOF_MAPENT       =   24          / each map entry occupies 24 bytes
MAX_E820            =   127         / 127 entries * 24/per = 3048 bytes

/ the per-CPU structures for each CPU/HT. each entry is
/ referenced permanently by the CPU's task register and
/ its kernel GS register. there are MAX_CPU (4) of these.
/ they are indexed by APIC ID: all IDs must be in [0, 3].
/ the BSP is assumed to have APIC ID 0: see config vector.

PER_CPU             =   0x6C00      / 256 bytes/CPU = 1k (0x6C00 - 0x6FFF)

/ transient block buffer used by open_file, read_file, lookup, etc. the
/ kernel may recover this page by unmapping it (along with the zero page)

BUFFER              =   0x7000

/ the BUFFER page is reused as the BSP's idle task descriptor.
/ task descriptors are exactly one page. a task's kernel stack
/ occupies the top of that page, so we know BSP_IDLE_STACK too.

BSP_IDLE_TASK       =   0x7000
BSP_IDLE_STACK      =   0x8000

/ constants related to the filesystem.

SUPER_MAGIC         =   0xABE01E50
SUPER_MAGIC2        =   0x87CD
BIOS_MAGIC          =   0xAA55
ROOT_INO            =   1
BLOCK_SIZE          =   4096
LOG2_BLOCK_SIZE     =   12
DIRECT_BYTES        =   65536
NAME_MAX            =   28

LOG2_BLOCK_DINODES  =   LOG2_BLOCK_SIZE - LOG2_SIZEOF_DINODE

S_IFMT              =   0170000     / DINODE_MODE type mask
S_IFREG             =   0100000     / type of regular file

/ other useful constants

TIMEOUT_TICKS       =   182         / auto-boot timeout (in BIOS ticks)

SPC                 =   0x20        / ASCII space
CR                  =   0x0D        / ..... carriage return
BS                  =   0x08        / ..... backspace
DEL                 =   0x7F        / ..... delete

ZMAGIC              =   0x17B81EEB  / expected kernel a.out magic
E820_SMAP           =   0x534D4150  / cookie for BIOS E820 functions
IA32_EFER           =   0xC0000080  / extended feature enable MSR
IA32_GS_BASE        =   0xC0000101  / current GS segment base MSR

/ segment selectors. obviously these must agree with the GDT.

KERNEL_CS_32        =   0x08
KERNEL_DS_32        =   0x10
KERNEL_CS           =   0x18
KERNEL_DS           =   0x20
KERNEL_TSS          =   0x38

.code16

/ all CPUs enter at `boot' in real mode. we distinguish
/ the BSP from the APs by inspecting %cs, which will be
/ BOOT_SEG on the APs and [something else] on the BSP.

boot:               cli

                    xorw %ax, %ax
                    movw %ax, %ds
                    movw %ax, %es
                    movw %ax, %ss
                    movw $BOOT_STACK, %sp

                    movw %cs, %ax
                    cmpw $BOOT_SEG, %ax
                    jz ap_boot

/ first-stage boot: complete loading boot itself. the BIOS has loaded
/ only our first sector, and that to BIOS_ADDR; let's copy ourselves
/ to where we should be, and restart. this might seem like a waste,
/ since we will shortly overwrite ourselves with a fresh copy from
/ disk, but this is the easiest way to avoid tripping over ourselves.

bsp:                sti
                    cld
                    movw $BIOS_ADDR, %si
                    movw $BOOT_ADDR, %di
                    movw $256, %cx          / = 512 bytes/sector
                    rep
                    movsw
                    ljmp 0, bsp_reloc

/ ok, now we're running in the right place, but only the first
/ sector has been loaded. ensure that BIOS DAP extensions are
/ present, since we use those to do the loading.

bsp_reloc:          movb $0x41, %ah
                    movw $0x55aa, %bx
                    int $0x13
                    jc no_dap
                    cmpw $0xaa55, %bx
                    jne no_dap
                    testb $1, %cl
                    jnz read_boot

no_dap:             movw $unsupported_msg, %si
                    jmp error

/ now read the `rest' of the boot block to its rightful
/ place. we actually overwrite ourselves in the process,
/ but no runtime storage is affected, so no ill effects.

read_boot:          xorl %eax, %eax
                    movw $BOOT_ADDR, %di
                    call read_block

                    jmp second      / off to the second stage

//////////////////////////////////////////////////////////////////////////////
/
/ read logical block
/
/   in: %eax = logical block number
/       %di  = absolute offset to 4k buffer

read_block:         pushw %si
                    pushl %edx
                    pushl %eax

                    movw $DAP, %si
                    movb $SIZEOF_DAP, DAP_SIZE(%si)
                    movb $0, DAP_ZERO(%si)
                    movw $8, DAP_COUNT(%si)     / 8 sectors = 4k
                    movw %di, DAP_OFS(%si)
                    movw $0, DAP_SEG(%si)

                    movl %eax, %edx             / %edx:%eax = %eax << 3
                    shrl $29, %edx              / (block # -> sector #)
                    shll $3, %eax
                    movl %eax, DAP_LSN(%si)
                    movl %edx, DAP_LSN+4(%si)

                    movb $0x80, %dl             / first hard disk
                    movb $0x42, %ah
                    int $0x13
                    jc read_error

                    popl %eax
                    popl %edx
                    popw %si
                    ret

read_error:         movw $read_error_msg, %si
                    / FALLTHRU

//////////////////////////////////////////////////////////////////////////////
/
/ print a string on the console, then halt
/
/   in: %si = NUL-terminated error string
/  out: (does not return)

error:              pushw %si

                    movw $fatal_msg, %si
                    call puts
                    popw %si
                    call puts

                    movw $halt_msg, %si
                    call puts
                    / FALLTHRU

//////////////////////////////////////////////////////////////////////////////
/
/ disable interrupts and halt.

halt:               cli
                    hlt
                    jmp halt

//////////////////////////////////////////////////////////////////////////////
/
/ print a string on the console
/
/   in: %si = NUL-terminated string
/  out: %si = moved just past the NUL
/

puts:               pushw %ax
                    pushw %bx

                    xorw %bx, %bx
                    movb $0x0e, %ah

puts_loop:          lodsb
                    testb %al, %al
                    jz puts_done
                    int $0x10
                    jmp puts_loop

puts_done:          popw %bx
                    popw %ax
                    ret

//////////////////////////////////////////////////////////////////////////////

fatal_msg:          .ascii "FATAL: "
                    .byte 0

halt_msg:           .ascii ", HALT."
                    .byte 13, 10, 0

read_error_msg:     .ascii "read error"
                    .byte 0

unsupported_msg:    .ascii "unsupported BIOS"
                    .byte 0

bad_fs_msg:         .ascii "invalid filesystem"
                    .byte 0

banner_msg:         .byte 13, 10, 10
                    .ascii "tahoe/64 boot block"
                    .byte 13, 10, 10
                    .ascii "auto-boot will begin in 10 seconds."
                    .byte 13, 10
                    .ascii "press any key for the boot prompt."
                    .byte 13, 10
                    .byte 0

//////////////////////////////////////////////////////////////////////////////

/ the CPU configuration vector. go_64 uses these to configure
/ the basic 64-bit environment of a CPU (task register, kernel
/ GS base, idle task stack) and enter the kernel at the right
/ place. these are prepopulated with values for the BSP, but
/ the kernel must set them up for each AP before startup IPI.

/ per_cpu is a .quad for convenience, but the PER_CPU structs
/ are in the first 64k of memory. we rely on this when setting
/ up the task state segment descriptor; see go_64.

                    .org 0x1180 - ORIGIN

entry:              .quad   KERNEL_ADDR
idle_stack:         .quad   BSP_IDLE_STACK
per_cpu:            .quad   PER_CPU

//////////////////////////////////////////////////////////////////////////////

/ the default kernel to boot.

                    .org 0x11B0 - ORIGIN

kernel:             .ascii "kernel"
                    .byte 0

/ the superblock data. obviously these are dummy values, but
/ at runtime they won't be (assuming there is a filesystem).

                    .org 0x11C0 - ORIGIN

s_magic:            .int        0
s_flags:            .int        0
s_ctime:            .quad       0
s_mtime:            .quad       0
s_bmap_blocks:      .int        0
s_imap_blocks:      .int        0
s_inode_blocks:     .int        0
s_blocks:           .int        0
s_free_blocks:      .int        0
s_inodes:           .int        0
s_free_inodes:      .int        0
s_reserved:         .quad       0
s_magic2:           .short      0
s_bios_magic:       .short      0

//////////////////////////////////////////////////////////////////////////////
// END OF FIRST SECTOR - nothing below is present before read_boot completes
//////////////////////////////////////////////////////////////////////////////

/ begin second stage of boot, where we load the kernel.
/ first be a good citizen and make sure the CPU we're on
/ can run tahoe (otherwise we'll just crash gracelessly).

second:             pushfl                      / copy EFLAGS
                    popl %eax                   / into %eax.
                    movl %eax, %ebx             / save original in %ebx
                    xorl $0x200000, %eax        / toggle bit 21.

                    pushl %eax                  / filter the result
                    popfl                       / through EFLAGS.
                    pushfl
                    popl %eax

                    cmpl %eax, %ebx             / if they are the same,
                    jz cpu_error                / then we have a problem.

                    movl $0x80000000, %eax      / can get feature bits?
                    cpuid
                    cmpl $0x80000001, %eax
                    jb cpu_error
                    movl $0x80000001, %eax      / get feature bits
                    cpuid
                    testl $0x20000000, %edx     / supports 64-bit mode?
                    jnz check_fs

cpu_error:          movw $cpu_error_msg, %si
                    jmp error

/ make sure the disk looks like a filesystem.

check_fs:           cmpl $SUPER_MAGIC, s_magic
                    jne bad_fs
                    cmpw $SUPER_MAGIC2, s_magic2
                    je good_fs

bad_fs:             movw $bad_fs_msg, %si
                    jmp error

/ display the boot banner and give the user time
/ to press a key to abort the auto-boot sequence.

good_fs:            movw $banner_msg, %si
                    call puts

                    movb $1, %ah                / reset BIOS timer
                    xorw %cx, %cx
                    xorw %dx, %dx
                    int $0x1a

timeout_loop:       movb $0, %ah                / read timer
                    int $0x1a
                    cmpw $TIMEOUT_TICKS, %dx
                    jge load                    / expired, proceed.

                    movb $1, %ah                / key pressed?
                    int $0x16
                    jz timeout_loop
                    movb $0, %ah                / yes. consume key, and
                    int $0x16                   / fall into prompt loop.

/ auto-boot interrupted. display prompt,
/ input kernel name, try to boot, repeat.

prompt:             movw $prompt_msg, %si
                    call puts

                    movw $NAME_MAX+1, %cx       / zap kernel name
                    movw $kernel, %di
                    xorb %al, %al
                    rep
                    stosb

                    xorw %di, %di               / %di = name length
                    xorw %bx, %bx               / for int 0x10 %ah=0x0e

input:              movb $0, %ah                / get key into %al
                    int $0x16

                    cmpb $CR, %al
                    jne input_10

                    / carriage return: ignore on empty lines.
                    / otherwise try to load the named kernel.

                    testw %di, %di
                    jz prompt
                    jmp load

input_10:           cmpb $BS, %al
                    jne input_20

                    / backspace: ignore on empty line.
                    / otherwise, rub out the last character in
                    / name buffer, echo destructive backspace.

                    testw %di, %di
                    jz input

                    decw %di
                    movb $0, kernel(%di)

                    movb $0x0e, %ah
                    int $0x10
                    movb $SPC, %al
                    int $0x10
                    movb $BS, %al
                    int $0x10
                    jmp input

input_20:           / other character: ignore if not printable or if the
                    / name buffer is full, otherwise stash it in buffer.

                    cmpb $SPC, %al
                    jb input
                    cmpb $DEL, %al
                    jae input

                    cmpw $NAME_MAX, %di
                    jae input

                    movb %al, kernel(%di)
                    incw %di

                    movb $0x0e, %ah
                    int $0x10
                    jmp input

/ try to open the kernel file, do some sanity checks
/ on it, and print status messages to keep the apprised.

load:               movw $load_msg_1, %si
                    call puts
                    movw $kernel, %si
                    call puts
                    movw $load_msg_2, %si
                    call puts

                    call lookup                     / look up kernel file
                    testl %eax, %eax
                    jz not_found

                    call open_file                  / open it
                    andl $S_IFMT, DINODE_MODE       / and make sure it
                    cmpl $S_IFREG, DINODE_MODE      / is a regular file
                    jnz not_regular

                    testl $0, DINODE_SIZE+4         / multi-gigabyte
                    jnz absurd                      / kernel is absurd

                    movl DINODE_SIZE, %eax          / report size
                    call putn
                    movw $bytes_msg, %si
                    call puts
                    cmpl $MAX_KERNEL, %eax          / must be smaller
                    jg too_big                      / than MAX_KERNEL

/ looks like a legitimate file. now load it into memory. this is
/ absurdly inefficient; we bounce each block through BUFFER, twice!
/ but loading the kernel happens once at boot and it's fast enough.

                    movl %eax, %edx                 / %edx = bytes to go
                    xorl %eax, %eax                 / %eax = file offset
                    movw $KERNEL_SEG, %bx           / %bx = target segment

load_10:            cmpl $0, %edx                   / are we done?
                    jle load_20

                    movw $BUFFER, %di           / absurdity: read_file loads
                    movw $BLOCK_SIZE, %cx       / block to BUFFER, then copies
                    call read_file              / it over itself to BUFFER

                    pushw %es                   / and then we copy it AGAIN
                    movw %bx, %es               / to its final resting place
                    movw $BUFFER, %si
                    xorw %di, %di
                    rep
                    movsb
                    popw %es

                    addw $0x100, %bx            / 4k (in paragraphs)
                    addl $BLOCK_SIZE, %eax      / bump offset
                    subl $BLOCK_SIZE, %edx      / shrink remaining
                    jmp load_10

not_found:          movw $not_found_msg, %si
                    jmp load_error

not_regular:        movw $not_regular_msg, %si
                    jmp load_error

absurd:             movw $absurd_msg, %si
                    jmp load_error

too_big:            movw $too_big_msg, %si
                    jmp load_error

bad_magic:          movw $bad_magic_msg, %si
                    / FALLTHRU

load_error:         call puts
                    jmp prompt

load_20:            cmpl $ZMAGIC, KERNEL_ADDR
                    jnz bad_magic

                    movw $load_ok_msg, %si
                    call puts

//////////////////////////////////////////////////////////////////////////////

/ ok, we've loaded what appears to be a valid kernel. now begins the third
/ stage: perform the last tasks which require BIOS assistance, then build an
/ embryonic protected mode environment, enter long mode, and start the kernel.

                    xorw %ax, %ax               / zero all data areas
                    movw $PML3, %di
                    movw $KERNEL_ADDR - PML3, %cx
                    rep
                    stosb

/ read the memory map from the BIOS using E820. this is a tad bit trickier
/ than one might think at first, because the BIOS can indicate the end of
/ the map in two different ways: carry set on return, OR %ebx = 0; plus we
/ artificially terminate after we get to MAX_E820 entries.

                    xorl %ebx, %ebx             / continuation value
                    movw $E820_MAP, %di         / array entry address
                    movl $E820_SMAP, %edx       / function cookie

e820_loop:          movl $0xe820, %eax
                    movl $SIZEOF_MAPENT, %ecx
                    int $0x15
                    jc e820_done
                    cmpl $E820_SMAP, %eax
                    jne e820_done

                    addw $SIZEOF_MAPENT, %di    / next array entry
                    incl E820_N                 / bump count
                    cmpl $MAX_E820, E820_N      / if maxed out,
                    jz e820_done                / exit now.
                    testl %ebx, %ebx            / loop if continuation
                    jnz e820_loop               / value is not zero

e820_done:          cmpl $0, E820_N             / can't be an error if
                    jnz vesa                    / we got any entries at
                    movw $unsupported_msg, %di  / all, unless the BIOS
                    jmp error                   / totally broken.

/ XXX - select VESA graphics mode

vesa:

/ warn the BIOS that we're heading for long mode.

warn_bios:          movw $0xec00, %ax
                    movb $2, %bl
                    int $0x15

/ kill the legacy PICs: program them to generate
/ out-of-the-way vectors and mask all interrupts.

                    cli

                    movb $0x11, %al             / ICW1 = initialize
                    outb %al, $0x20
                    outb %al, $0xA0

                    movb $0x20, %al             / ICW2 = vectors (0x20-0x2F)
                    outb %al, $0x21
                    movb $0x28, %al
                    outb %al, $0xA1

                    movb $4, %al                / ICW3 = master/slave
                    outb %al, $0x21
                    movb $2, %al
                    outb %al, $0xA1

                    movb $1, %al                / ICW4 = 8086 mode
                    outb %al, $0x21
                    outb %al, $0xA1

/ kill NMIs. these usually just mean the computer
/ is exploding. if so, we'll find out soon enough.

                    inb $0x70, %al
                    orb $0x80, %al
                    outb %al, $0x70

/ ok, enter 32-bit protected mode.

                    lgdt gdt_48
                    movw $1, %ax
                    lmsw %ax
                    ljmp KERNEL_CS_32, bsp_prot_32
.code32

bsp_prot_32:        movw $KERNEL_DS_32, %ax
                    movw %ax, %ds

/ set up the embryonic page tables. these have been zeroed out
/ above. we only need to populate one entry, the first, in each
/ of the upper-level tables, linking it down to the next level.

                    movl $PML2 + 0x07, PML3     / 0x07 = user, R/W, P
                    movl $PML1 + 0x07, PML2
                    movl $PML0 + 0x07, PML1

/ identity map the first 2MB in PML0 using 4k system-only pages.

                    movl $PML0, %ebx
                    movl $0x03, %eax            / 0x03 = (system) R/W, P
                    movl $512, %ecx             / 512 entries in PML1
pml0_loop:          movl %eax, (%ebx)
                    addl $8, %ebx               / next entry
                    addl $0x1000, %eax          / next page address
                    loop pml0_loop

                    / BSP setup complete - FALLTHRU to go_64

//////////////////////////////////////////////////////////////////////////////
/
/ toggle control bits, enable paging, enter long mode, load
/ the TR and GS seg for this CPU, then jump into the kernel.
/
/ the behavior is controlled in large part by the values in
/ the config vector (see above): these are automatically set
/ up for the BSP, but the kernel must twiddle them for APs.
/

go_64:              movl %cr4, %eax             / enable PAE
                    orl $0x20, %eax
                    movl %eax, %cr4

                    movl $IA32_EFER, %ecx       / enable long mode
                    rdmsr
                    orw $0x100, %ax
                    wrmsr

                    movl $PML3, %eax            / set page base
                    movl %eax, %cr3

                    movl %cr0, %eax             / enable paging
                    orl $0x80000000, %eax
                    movl %eax, %cr0

                    movl %cr4, %eax             / enable SSE
                    orw $0x200, %ax
                    movl %eax, %cr4

                    ljmp KERNEL_CS, prot_64

.code64

prot_64:            xorl %eax, %eax             / reload segments. this is
                    movw %ax, %ds               / really just hygiene: the
                    movw %ax, %es               / data segment registers are
                    movw %ax, %ss               / [almost] entirely ignored.
                    movw %ax, %gs
                    movw %ax, %fs
                    movq idle_stack, %rsp

                    xorl %edx, %edx
                    movl per_cpu, %eax
                    movl $IA32_GS_BASE, %ecx
                    wrmsr

                    movw %ax, tss_base          / n.b.: assumes per_cpu
                    movb $0x89, tss_type        / is in first 64k (it is)
                    movw $KERNEL_TSS, %ax
                    ltr %ax

                    jmp *entry

.code16

//////////////////////////////////////////////////////////////////////////////
/
/ print unsigned number in decimal
/
/   in: %eax = number

putn:               pushl %eax
                    pushl %ebx
                    pushl %ecx
                    pushl %edx

                    pushw $0                    / terminator
                    movl $10, %ecx

putn_10:            xorl %edx, %edx             / zero-extend
                    divl %ecx
                    addw $0x30, %dx             / make remainder a digit
                    pushw %dx                   / remember it
                    testl %eax, %eax            / done?
                    jnz putn_10

putn_20:            popw %ax
                    testw %ax, %ax              / terminator?
                    jz putn_done
                    movb $0x0e, %ah
                    xorw %bx, %bx
                    int $0x10
                    jmp putn_20

putn_done:          popl %edx
                    popl %ecx
                    popl %ebx
                    popl %eax
                    ret

//////////////////////////////////////////////////////////////////////////////
/
/ look up the kernel file in the root directory
/
/  out: %eax = the inode number (0 = not found)

lookup:             pushl %ebx
                    pushw %cx
                    pushw %si
                    pushw %di

                    movl $ROOT_INO, %eax        / open root directory
                    call open_file
                    xorl %ebx, %ebx             / start at offset 0

lookup_10:          cmpl DINODE_SIZE, %ebx      / end of directory?
                    jb lookup_20
                    xorl %eax, %eax             / return `not found'
                    jmp lookup_done

lookup_20:          movl %ebx, %eax             / read directory entry
                    movw $SIZEOF_DIRECT, %cx
                    movw $DIRECT, %di
                    call read_file

                    cmpl $0, DIRECT_INO         / unused entry?
                    jz lookup_40

                    movw $DIRECT_NAME, %si      / check name against
                    movw $kernel, %di           / the desired kernel
                    movw $NAME_MAX, %cx
lookup_30:          lodsb
                    cmpb %al, (%di)
                    jnz lookup_40
                    incw %di
                    testb %al, %al
                    loopnz lookup_30
                    movl DIRECT_INO, %eax       / match, return inode
                    jmp lookup_done

lookup_40:          addl $SIZEOF_DIRECT, %ebx   / advance to next entry
                    jmp lookup_10

lookup_done:        popw %di
                    popw %si
                    popw %cx
                    popl %ebx
                    ret

//////////////////////////////////////////////////////////////////////////////
/
/ open file: retrieve DINODE for read_file
/
/   in: %eax = inode number of file to open

open_file:          pushl %eax
                    pushl %esi
                    pushw %di
                    pushw %cx

                    movl %eax, %esi                     / compute offset
                    shll $LOG2_SIZEOF_DINODE, %esi      / of inode -> %si
                    andw $BLOCK_SIZE-1, %si             / ... within block
                    addw $BUFFER, %si                   / ... now in BUFFER

                    shrl $LOG2_BLOCK_DINODES, %eax      / compute block #
                    incl %eax                           / (skip superblock)
                    addl s_bmap_blocks, %eax            / (skip bmap)
                    addl s_imap_blocks, %eax            / (skip imap)

                    movw $BUFFER, %di                   / read block
                    call read_block                     / containing dinode

                    movw $SIZEOF_DINODE, %cx            / and copy it
                    movw $DINODE, %di                   / to DINODE buffer
                    rep
                    movsb

                    popw %cx
                    popw %di
                    popl %esi
                    popl %eax
                    ret

//////////////////////////////////////////////////////////////////////////////
/
/ read data from the last opened file. this
/ is not smart enough to read across block
/ boundaries (because it doesn't have to be).
/
/   in: %eax = offset into file
/       %cx  = length to read
/       %di  = destination buffer

read_file:          pushl %eax
                    pushw %si
                    pushw %di
                    pushw %bx
                    pushw %cx

                    movw %di, %bx               / save caller's target buffer
                    movw $BUFFER, %di

                    movw %ax, %si               / %si = offset to data
                    andw $BLOCK_SIZE-1, %si     / requested (in BUFFER)
                    addw $BUFFER, %si

                    cmpl $DIRECT_BYTES, %eax    / need to read indirect block?
                    jae read_file_10
                    shrl $LOG2_BLOCK_SIZE, %eax         / no, compute index
                    movl DINODE_ADDR(,%eax,4), %eax     / get direct blkno
                    jmp read_file_20

read_file_10:       subl $DIRECT_BYTES, %eax        / compute index into
                    shrl $LOG2_BLOCK_SIZE, %eax     / indirect block
                    pushl %eax
                    movl DINODE_INDIRECT, %eax      / read indirect block
                    call read_block
                    popl %eax
                    movl BUFFER(,%eax,4), %eax      / extract blkno from it

read_file_20:       call read_block             / read data block
                    movw %bx, %di               / recall caller's target buf
                    rep                         / and copy data to
                    movsb                       / caller from BUFFER

                    popw %cx
                    popw %bx
                    popw %di
                    popw %si
                    popl %eax
                    ret

//////////////////////////////////////////////////////////////////////////////

prompt_msg:         .byte 13, 10, 10
                    .ascii "boot: "
                    .byte 0

load_msg_1:         .byte 13, 10
                    .ascii "loading `"
                    .byte 0

load_msg_2:         .ascii "' ... "
                    .byte 0

not_found_msg:      .ascii "not found."
                    .byte 0

not_regular_msg:    .ascii "not a regular file."
                    .byte 0

bytes_msg:          .ascii " bytes, "
                    .byte 0

bad_magic_msg:      .ascii "bad magic."
                    .byte 0

load_ok_msg:        .ascii "ok."
                    .byte 13, 10, 10, 0

absurd_msg:         .ascii "absurdly large."
                    .byte 0

too_big_msg:        .ascii "too big."
                    .byte 0

cpu_error_msg:      .ascii "unsupported CPU"
                    .byte 0

/ the global descriptor table: like the page tables, this is
/ inherited by the kernel which never really looks at it. do
/ not change the selectors willy-nilly: the kernel and boot
/ must agree on them, and the relative ordering is important
/ to some architectural mechanisms (e.g., SYSCALL/SYSRET).

.align 8

gdt:                .short  0, 0, 0, 0      / 0x00 = null descriptor

                    .short  0xFFFF          / 0x08 = 32-bit kernel code
                    .short  0
                    .short  0x9A00
                    .short  0x00CF

                    .short  0xFFFF          / 0x10 = 32-bit kernel data
                    .short  0
                    .short  0x9200
                    .short  0x00CF

                    .short  0               / 0x18 = 64-bit kernel code
                    .short  0
                    .short  0x9800
                    .short  0x0020

                    .short  0               / 0x20 = 64-bit kernel data
                    .short  0
                    .short  0x9200
                    .short  0

                    .short  0               / 0x28 = 64-bit user code (0x2B)
                    .short  0
                    .short  0xF800
                    .short  0x0020

                    .short  0               / 0x30 = 64-bit user data (0x33)
                    .short  0
                    .short  0xF200
                    .short  0

    / each CPU gets its own TSS, but we only load the TR once
    / (here, in go_64) so we can reset and reuse the descriptor.

                    .short  0x0067          / 0x38 - 64-bit TSS
tss_base:           .short  0               / (set to PER_CPU of this cpu)
                    .byte   0
tss_type:           .byte   0               / (set to available TSS, 0x89)
                    .byte   0
                    .byte   0
                    .short  0, 0, 0, 0      / (double-length descriptor)

gdt_48:             .short  gdt_48 - gdt - 1
                    .int    gdt

//////////////////////////////////////////////////////////////////////////////

ap_boot:            ljmp 0, ap_reloc        / XXX
ap_reloc:           jmp halt

//////////////////////////////////////////////////////////////////////////////

/ pad the boot block to exactly 4k.
/ (generate an error if we overflow).

                    .org 0x1FFF - ORIGIN
                    .byte 0

/ vi: set ts=4 expandtab:
