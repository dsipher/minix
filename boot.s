//////////////////////////////////////////////////////////////////////////////
/
/  boot.s                                              jewel/os boot block
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
/ with the kernel (mostly in sys/boot.h) - it's important that they agree.

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

DINODE              =   0x0600      / the `open' dinode (0x700-0x77F)
DINODE_MODE         =   0x0600      / dinode.di_mode
DINODE_SIZE         =   0x0610      / dinode.di_size
DINODE_ADDR         =   0x0634      / dinode.di_addr[]
DINODE_INDIRECT     =   0x0674      / dinode.di_addr[INDIRECT_BLOCK]

SIZEOF_DINODE       =   128         / size of struct dinode
LOG2_SIZEOF_DINODE  =   7           / .. which is 2^7

DIRECT              =   0x0680      / directory entry for `lookup'
DIRECT_INO          =   0x0680      / direct.d_ino
DIRECT_NAME         =   0x0684      / direct.d_name

SIZEOF_DIRECT       =   32          / size of struct direct

A20_ALIAS           =   0x06D0      / see test_a20

DAP                 =   0x06F0      / disk address packet
DAP_SIZE            =   0           / (byte) size of packet
DAP_ZERO            =   1           / (byte) must-be-zero
DAP_COUNT           =   2           / (word) sector count
DAP_OFS             =   4           / (word) buffer offset address
DAP_SEG             =   6           / (word) buffer segment address
DAP_LSN             =   8           / (qword) logical sector number

SIZEOF_DAP          =   16          / DAP packet is 16 bytes

/ boot sets up the initial system page tables,
/ identity-mapping the first 2MB in 4K pages.

PTL3                =   0x2000      / the Intel/AMD manuals give all these
PTL2                =   0x3000      / levels names that evolved organically
PTL1                =   0x4000      / and are confusing. we just call them
PTL0                =   0x5000      / what they are: `page table level N'

/ we also set aside room for the mid-level table for
/ the physical ram image (starting at PHYSICAL_BASE).
/ there's no particular reason why we do this in boot,
/ except that we happen to have an unused page for it.

PTL2P               =   0x6000

/ transient buffer page used by open_file, read_file, lookup, etc. the
/ kernel may recover this page by unmapping it (along with the zero page)

BUFFER              =   0x7000

/ after loading we overwrite BUFFER with the E820 map. we deliberately
/ use this instead of ACPI so we don't have to play games to map in the
/ ACPI tables before we've initialized memory management. chicken/egg.

/ the kernel references this map in locore.s (_e820_count/_e820_map).

E820_N              =   0x7000      / count of BIOS E820 map entries
E820_MAP            =   0x7008      / the map itself (0x6008 - 0x6BFF)
SIZEOF_MAPENT       =   24          / each map entry occupies 24 bytes
MAX_E820            =   170         / 170 entries * 24/per = 4080 bytes

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
IA32_STAR           =   0xC0000081  / SYSCALL/SYSRET selectors MSR

KERNEL_STACK        =   0x00102000  / top of stack - must agree with page.h

/ segment selectors. obviously these must agree with the GDT, and are
/ dictated somewhat by SYSCALL/RET. should never need to change them.

KERNEL_CS_32        =   0x08
KERNEL_DS_32        =   0x10
KERNEL_CS           =   0x18
KERNEL_DS           =   0x20
USER_CS_32          =   0x2B
USER_DS             =   0x33
USER_CS             =   0x3B
KERNEL_TSS          =   0x40

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
                    .ascii "jewel/os boot block"
                    .byte 13, 10, 10
                    .ascii "auto-boot will begin in 10 seconds."
                    .byte 13, 10
                    .ascii "press any key for the boot prompt."
                    .byte 13, 10
                    .byte 0

//////////////////////////////////////////////////////////////////////////////

/ the boot configuration vector. entry_* are preset for
/ the BSP, but the kernel will reset them to appropriate
/ values for each AP before spinning it up. entry_ptl3,
/ despite being a .quad, must point inot the first 4GB of
/ addressible RAM, because %cr3 is loaded in 32-bit mode.
/ (this should never pose a problem; change prot_64 if so)

/ these correspond to struct boot_config in sys/boot.h

                    .org 0x1180 - ORIGIN

entry_addr:         .quad   KERNEL_ADDR         / kernel entry point
entry_ptl3:         .quad   PTL3                / page tables

/ these values are intended to be configurable by the user.
/ (eventually we'll modify mkboot.c to view/change/reset them.)

nproc:              .short  128         / number of processes
nbuf:               .short  8192        / number of 4k block buffers
nmbuf:              .short  1024        / number of 4k packet buffers

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
/ can run jewel (otherwise we'll just crash gracelessly).

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
                    jnz open_a20

cpu_error:          movw $cpu_error_msg, %si
                    jmp error

/ open the A20 gate if needed. try a couple
/ of techniques, least-intrusive first.

open_a20:           call test_a20               / might be open already
                    jnz check_fs

                    movw $0x2401, %ax           / try BIOS function
                    int $0x15
                    call test_a20
                    jnz check_fs

                    inb $0x92, %al              / try `fast A20' gate
                    orb $2, %al
                    andb $0xfe, %al
                    outb %al, $0x92
                    call test_a20
                    jnz check_fs

                    movw $stuck_a20_msg, %si
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
                    movw $PTL3, %di
                    movw $KERNEL_ADDR - PTL3, %cx
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

/ with interrupts masked, we should never see any spurious interrupts
/ because these only occur due to aborted interrupt acknowledge cycles.
/ but just in case, we map both master and slave to vectors 0x38-0x3F.
/ this sends spurious interrupts from either PIC to vector 0x3F, which
/ the same vector we'll for spurious APIC interrupts (VECTOR_SPURIOUS).

                    cli

                    movb $0x11, %al             / ICW1 = initialize
                    outb %al, $0x20
                    outb %al, $0xA0

                    movb $0x38, %al             / ICW2 = vectors (0x38-0x3F)
                    outb %al, $0x21
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

                    movl $PTL2 + 0x07, PTL3     / 0x07 = U, R/W, P
                    movl $PTL1 + 0x07, PTL2
                    movl $PTL0 + 0x07, PTL1

/ identity map the first 2MB in PTL0 using 4k system-only pages.

                    movl $PTL0, %ebx

                    movl $0x303, %eax           / 0x303 = SHARED, G, R/W, P
                    movl $512, %ecx             / 512 PTEs/page = 2MB
ptl0_loop:          movl %eax, (%ebx)
                    addl $8, %ebx               / next entry
                    addl $0x1000, %eax          / next page address
                    loop ptl0_loop

/ we also link to the PTL2 for the physical memory map (PTL2P)
/ from the last PTE in PTL3. change this if PHYSICAL_BASE moves.

                    movl $PTL2P + 0x203, 4088 + PTL3  / 0x203 = SHARED, R/W, P

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

go_64:              movl %cr4, %eax             / enable PAE and PGE
                    orl $0x20, %eax
                    movl %eax, %cr4

                    movl $IA32_EFER, %ecx       / enable long mode
                    rdmsr
                    orw $0x101, %ax             / LME=1 SCE=1
                    wrmsr

                    movl entry_ptl3, %eax       / set page base
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
                    movq $KERNEL_STACK, %rsp

                    movb $0x89, tss_type(%rip)  / reset in case marked BUSY
                    movw $KERNEL_TSS, %ax
                    ltr %ax

                    movl $IA32_STAR, %ecx       / set SYSCALL/RET selectors
                    movq star(%rip), %rax
                    wrmsr

                    lidt idt_48(%rip)

                    jmp *entry_addr

.code16

//////////////////////////////////////////////////////////////////////////////
/
/ test to ensure A20 line is not gated
/
/  out: %ax destroyed
/       Z=0 if A20 enabled

test_a20:           pushw %es

                    movw $0xFFFF, %ax
                    movw %ax, %es

                    / the basic idea is to see if A20_ALIAS can be
                    / accessed by wrapping around the 1MB boundary.

                    movw $0x1234, A20_ALIAS
                    seg %es
                    cmpw $0x1234, A20_ALIAS+0x10
                    jne test_a20_done

                    movw $0x4321, A20_ALIAS
                    seg %es
                    cmpw $0x4321, A20_ALIAS+0x10

test_a20_done:      popw %es
                    ret

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

stuck_a20_msg:      .ascii "A20 gate stuck"
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

                    / KERNEL_CS, KERNEL_DS must be in
                    / this order for SYSCALL to work.

                    .short  0               / 0x18 = 64-bit kernel code
                    .short  0
                    .short  0x9800
                    .short  0x0020

                    .short  0               / 0x20 = 64-bit kernel data
                    .short  0
                    .short  0x9200
                    .short  0

                    / USER_CS_32, USER_DS, USER_CS must be in this
                    / order for SYSRET. (we don't really need the
                    / dummy USER_CS_32, but it keeps things tidy.)

                    .short  0               / 0x28 = 32-bit user code (0x2B)
                    .short  0
                    .short  0
                    .short  0

                    .short  0               / 0x30 = 64-bit user data (0x33)
                    .short  0
                    .short  0xF200
                    .short  0

                    .short  0               / 0x38 = 64-bit user code (0x3B)
                    .short  0
                    .short  0xF800
                    .short  0x0020

/ the TSS is only used to specify the kernel stack
/ for a process. since this is always at the same
/ [virtual] address in every process, we use one
/ TSS for all CPUs and all processes: so we load the
/ task register once (in go_64) then forget about it.

                    .short  0x0067          / 0x40 - 64-bit TSS
                    .short  tss
                    .byte   0
tss_type:           .byte   0               / (set to available TSS, 0x89)
                    .byte   0
                    .byte   0
                    .short  0, 0, 0, 0      / (double-length descriptor)

gdt_48:             .short  gdt_48 - gdt - 1
                    .int    gdt

/ the task state segment. read-only.
/ shared by all CPUs and all tasks.

.align 8

tss:                .int    0
                    .quad   KERNEL_STACK    / RSP0
                    .fill   92, 1, 0

/ contents loaded into IA32_STAR.
/
/   on SYSCALL:     KERNEL_CS -> CS
/                   KERNEL_DS -> SS
/
/   on SYSRET:      USER_CS -> CS
/                   USER_DS -> SS

star:               .int    0               / (32-bit entry: unused)
                    .short  KERNEL_CS       / selectors for SYSCALL
                    .short  USER_CS_32      / ............. SYSRET

/ the interrupt descriptor table.

.align 8

idt:                .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x00
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x01
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x02
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x03
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x04
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x05
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x06
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x07
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x08
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x09
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x0A
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x0B
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x0C
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x0D
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x0E
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x0F

                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x10
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x11
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x12
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x13
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x14
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x15
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x16
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x17
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x18
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x19
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x1A
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x1B
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x1C
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x1D
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x1E
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x1F

                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x20
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x21
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x22
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x23
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x24
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x25
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x26
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x27
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x28
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x29
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x2A
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x2B
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x2C
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x2D
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x2E
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x2F

                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x30
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x31
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x32
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x33
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x34
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x35
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x36
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x37
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x38
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x39
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x3A
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x3B
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x3C
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x3D
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x3E
                    .short  0, 0, 0, 0, 0, 0, 0, 0          /   0x3F

idt_48:             .short  idt_48 - idt - 1
                    .quad   idt

//////////////////////////////////////////////////////////////////////////////

ap_boot:            ljmp 0, ap_reloc        / XXX
ap_reloc:           jmp halt

//////////////////////////////////////////////////////////////////////////////

/ pad the boot block to exactly 4k.
/ (generate an error if we overflow).

                    .org 0x1FFF - ORIGIN
                    .byte 0

/ vi: set ts=4 expandtab:
