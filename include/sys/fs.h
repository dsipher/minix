/*****************************************************************************

   sys/fs.h                                      tahoe/64 standard library

******************************************************************************

   Copyright (c) 2021, 2022, Charles E. Youse (charles@gnuless.org).

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS  PROVIDED BY  THE COPYRIGHT  HOLDERS AND  CONTRIBUTORS
   "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT
   LIMITED TO, THE  IMPLIED  WARRANTIES  OF  MERCHANTABILITY  AND  FITNESS
   FOR  A  PARTICULAR  PURPOSE  ARE  DISCLAIMED.  IN  NO  EVENT  SHALL THE
   COPYRIGHT  HOLDER OR  CONTRIBUTORS BE  LIABLE FOR ANY DIRECT, INDIRECT,
   INCIDENTAL,  SPECIAL, EXEMPLARY,  OR CONSEQUENTIAL  DAMAGES (INCLUDING,
   BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR SERVICES; LOSS
   OF USE, DATA, OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY  OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY, OR
   TORT (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING IN ANY WAY OUT OF THE
   USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*****************************************************************************/

#ifndef _SYS_FS_H
#define _SYS_FS_H

#include <limits.h>
#include <sys/types.h>

#define FS_BLOCK_SIZE       4096
#define FS_BLOCK_SHIFT      12

/* the tahoe/64 filesystem is fairly conventional, with 4k blocks. we
   choose this value to match our page size, which simplifies the vm
   system. as a bonus, it is the native sector size of modern disks.

   block 0 is the superblock, which doubles as the boot block. this
   is followed by s_bmap_blocks of block bitmaps (0=used, 1=free),
   then `s_imap_blocks' of inode bitmaps, then `s_inode_blocks' of
   inodes. the balance of the disk comprises allocatable blocks.

   inode 0 is reserved for anonymous backing storage (aka swap).

   since inode 0 and block 0 have special fixed purposes, they can
   never be allocated, so the value 0 is often used as a sentinel
   meaning "no inode" or "no block" in on-disk structures, or as a
   return value from a function. the root inode is always inode 1. */

#define FS_BLOCK_SIZE       4096
#define FS_BLOCK_SHIFT      12

#define FS_ROOT_INO         1

/* the superblock data starts at offset FS_SUPER_OFFSET in block 0.
   (the rest of the block is reserved for use by the boot code.) */

#define FS_SUPER_BLOCK      0           /* superblock is always block 0 */
#define FS_SUPER_OFFSET     448         /* occupies 64 bytes (448-511) */

struct filsys
{
    int             s_magic;            /* FS_SUPER_MAGIC */
    int             s_flags;            /* (none yet) */

    time_t          s_ctime;            /* creation time */
    time_t          s_mtime;            /* last mount time */
    daddr_t         s_bmap_blocks;      /* number of blocks in block map */
    daddr_t         s_imap_blocks;      /* ................... inode map */
    daddr_t         s_inode_blocks;     /* number of blocks used for inodes */
    daddr_t         s_blocks;           /* total blocks on device */
    daddr_t         s_free_blocks;      /* ... and how many are free */
    ino_t           s_inodes;           /* total number of inodes */
    ino_t           s_free_inodes;      /* ... and how many are free */

    int             s_reserved[2];      /* padding; must be zero */

    short           s_magic2;           /* FS_SUPER_MAGIC2 */
    short           s_boot_magic;       /* FS_BOOT_MAGIC */
};

#define FS_SUPER_MAGIC      0xABE01E50
#define FS_SUPER_MAGIC2     (short) 0x87CD  /* homage to OS-9/6809 */
#define FS_BOOT_MAGIC       (short) 0xAA55  /* BIOS boot signature */

/* compute the starting blocks for various regions of disk */

#define FS_BMAP_START(fs)   (1)
#define FS_IMAP_START(fs)   (FS_BMAP_START(fs) + ((fs).s_bmap_blocks))
#define FS_INODE_START(fs)  (FS_IMAP_START(fs) + ((fs).s_imap_blocks))
#define FS_DATA_START(fs)   (FS_INODE_START(fs) + ((fs).s_inode_blocks))

/* on-disk inodes are also conventional: 128 bytes.
   up to triple indirection (for ~ 4Tb per file) */

#define FS_INODE_BLOCKS     19      /* 19 block addresses in the inode: */
#define FS_DIRECT_BLOCKS    16      /* 0..15 are the direct blocks (64k) */
#define FS_INDIRECT_BLOCK   16      /* index of indirect block (4Mb) */
#define FS_DOUBLE_BLOCK     17      /* ........ double-indirect (4Gb) */
#define FS_TRIPLE_BLOCK     18      /* ........ triple-indirect (4Tb) */

struct dinode
{
    mode_t          di_mode;
    nlink_t         di_nlink;
    uid_t           di_uid;
    gid_t           di_gid;

    union
    {
        off_t           di_size;        /* for regular file */
        dev_t           di_rdev;        /* for blk/chr devs */
    };

    time_t          di_atime;
    time_t          di_mtime;
    time_t          di_ctime;

    int             di_reserved;

    daddr_t         di_addr[FS_INODE_BLOCKS];
};

#define FS_INODES_PER_BLOCK     (FS_BLOCK_SIZE / sizeof(struct dinode))
#define FS_BLOCKS_PER_BLOCK     (FS_BLOCK_SIZE / sizeof(daddr_t))
#define FS_BITS_PER_BLOCK       (FS_BLOCK_SIZE * 8)

/* how many bytes can be stored in the direct blocks, or
   per indirect block, double-indirect, triple-indirect ... */

#define FS_DIRECT_BYTES         (FS_DIRECT_BLOCKS * (off_t) FS_BLOCK_SIZE)
#define FS_INDIRECT_BYTES       (FS_BLOCKS_PER_BLOCK * (off_t) FS_BLOCK_SIZE)
#define FS_DOUBLE_BYTES         (FS_BLOCKS_PER_BLOCK * FS_INDIRECT_BYTES)
#define FS_TRIPLE_BYTES         (FS_BLOCKS_PER_BLOCK * FS_DOUBLE_BYTES)

#define FS_MAX_FILE_SIZE        (   FS_TRIPLE_BYTES + FS_DOUBLE_BYTES       \
                                +   FS_INDIRECT_BYTES + FS_DIRECT_BYTES     )

/* we need at least two inodes, but we always round up to
   a multiple of FS_INODES_PER_BLOCK (otherwise the extra
   space is wasted). the minimum filesystem size is:

        1 super block + 1 bmap block + 1 imap block
        + 1 inode block + 1 data block = 5 blocks

   such a filesystem could consist only of a root directory
   with device files in it, but it is technically allowed.

   the maxima are constrained by the types of ino_t/daddr_t */

#define FS_MIN_INODES           FS_INODES_PER_BLOCK
#define FS_MIN_BLOCKS           5
#define FS_MAX_INODES           UINT_MAX
#define FS_MAX_BLOCKS           UINT_MAX

/* the block number/offset in that block where inode `i' is located.
   the names of these macros are historical (like filsys and dinode) */

#define FS_ITOD(fs, i)  (((i) / FS_INODES_PER_BLOCK) + FS_INODE_START(fs))
#define FS_ITOO(fs, i)  (((i) % FS_INODES_PER_BLOCK) * sizeof(struct dinode))

/* format of directory files. NAME_MAX == 28 (see limits.h), which makes each
   entry a nice round 32 bytes. this is also more than should ever reasonably
   be needed. it's true that the unix 14-character limit was cramped, but the
   arbitrary-length filenames introduced in 4BSD just invite silliness. */

struct direct
{
    ino_t       d_ino;                  /* 0 == unused entry */
    char        d_name[NAME_MAX];
};

#endif /* _SYS_FS_H */

/* vi: set ts=4 expandtab: */
