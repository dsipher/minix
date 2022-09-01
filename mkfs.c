/*****************************************************************************

   mkfs.c                                      tahoe/64 filesystem creator

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

#include <stdio.h>
#include <unistd.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <ctype.h>
#include <errno.h>
#include <sys/stat.h>
#include <sys/fs.h>

struct filsys   fs;                     /* superblock for new fs */
struct dinode   root;                   /* and the root inode */
int             device;                 /* block device file descriptor */
FILE            *proto;                 /* handle to prototype file (or 0) */
daddr_t         nr_blocks;              /* number of blocks in filesystem */
ino_t           nr_inodes;              /* ......... inodes ............. */
char            block[FS_BLOCK_SIZE];   /* buffer for bio() */
char            buf[FS_BLOCK_SIZE];     /* buffer for do_proto() */
int             line;                   /* current line number in proto */
int             ch;                     /* ....... character .......... */

/* round `a' up to a multiple of `b'.
   all occurences in this source involve
   an unsigned `a' and a power of 2 `b',
   so this should actually be efficient,
   (not that it matters much). */

#define ROUND_UP(a,b)   (((a) % (b)) ? ((a) + ((b) - ((a) % (b)))) : (a))

/* how many blocks are needed to hold a bitmap of `n' elements? */

#define BITMAP_BLOCKS(n)  (ROUND_UP((unsigned long) (n), FS_BITS_PER_BLOCK) \
                                                        / FS_BITS_PER_BLOCK)

/* fetch the next character from the
   prototype file into `ch' */

#define NEXT()      do { ch = getc(proto); } while(0)

/* report an error and abort. include the proto line number
   if we have one. if `system' is non-zero, consult errno. */

void
error(int system, char *fmt, ...)
{
    va_list args;

    fprintf(stderr, "mkfs: ");
    if (line) fprintf(stderr, "line %d: ", line);

    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);

    if (system) fprintf(stderr, " (%s)", strerror(errno));
    fputc('\n', stderr);
    exit(1);
}

/* read/write blkno from/to the device. */

#define READ    0
#define WRITE   1

void
bio(daddr_t blkno, int op)
{
    int ret;

    if (lseek(device, blkno * (off_t) FS_BLOCK_SIZE, SEEK_SET) == -1)
        error(1, "can't seek device");

    if (op == READ)
        ret = read(device, block, FS_BLOCK_SIZE);
    else
        ret = write(device, block, FS_BLOCK_SIZE);

    if (ret == -1) error(1, "can't %s device", op == READ ? "read"
                                                          : "write");
}

/* write out an inode */

void
iput(struct dinode *di, ino_t ino)
{
    daddr_t blkno = FS_ITOD(fs, ino);
    int ofs = FS_ITOO(fs, ino);

    di->di_atime = fs.s_ctime;
    di->di_mtime = fs.s_ctime;
    di->di_ctime = fs.s_ctime;

    bio(blkno, READ);
    memcpy(block + ofs, di, sizeof(struct dinode));
    bio(blkno, WRITE);
}

/* write a bitmap, starting at `blkno', consisting of `n'
   blocks, of which the first `m' elements are used. */

void
bitmap(daddr_t blkno, long n, long m)
{
    int i, j;

    while (n--) {
        memset(block, 0xFF, FS_BLOCK_SIZE);
        i = 0; j = 0;

        while (m && j < FS_BLOCK_SIZE) {
            block[j] <<= 1;
            --m;
            ++i;
            if ((i & 7) == 0) ++j;
        }

        bio(blkno, WRITE);
        ++blkno;
    }
}

/* allocate an inode and return its number. also (somewhat
   unrelated) initialize the dinode supplied by the caller. */

ino_t
ialloc(struct dinode *di)
{
    if (nr_inodes == fs.s_inodes)
        error(0, "out of inodes");

    --fs.s_free_inodes;
    memset(di, 0, sizeof(struct dinode));
    return nr_inodes++;
}

/* allocate a disk block and return its number. as with
   the above, this is easy, since we do it sequentually. */

daddr_t
balloc(void)
{
    if (nr_blocks == fs.s_blocks)
        error(0, "out of blocks");

    --fs.s_free_blocks;
    return nr_blocks++;
}

/* return the block number that holds byte offset `offset'
   into `di', allocating blocks and updating the inode as
   required. we won't go larger than single indirection. */

daddr_t
bmap(struct dinode *di, off_t offset)
{
    daddr_t *addr;
    daddr_t ind;

    if (offset < FS_DIRECT_BYTES) {
        offset /= FS_BLOCK_SIZE;

        if (di->di_addr[offset] == 0)
            di->di_addr[offset] = balloc();

        return di->di_addr[offset];
    }

    offset -= FS_DIRECT_BYTES;

    if (offset >= FS_INDIRECT_BYTES)
        error(0, "file too big");

    ind = di->di_addr[FS_INDIRECT_BLOCK];

    if (ind == 0) {
        ind = balloc();
        memset(block, 0, FS_BLOCK_SIZE);
        di->di_addr[FS_INDIRECT_BLOCK] = ind;
    } else
        bio(ind, READ);

    offset /= FS_BLOCK_SIZE;
    addr = (daddr_t *) block;

    if (addr[offset] == 0) {            /* this will always be true */
        addr[offset] = balloc();        /* if we just allocated the */
        bio(ind, WRITE);                /* indirect block above. */
    }

    return addr[offset];
}

/* append `len' bytes from `buf' to
   the file described by `di'. */

#define BLKOFS(di)  ((di)->di_size & (FS_BLOCK_SIZE - 1))

void
iwrite(struct dinode *di, void *buf, size_t len)
{
    daddr_t blkno = 0;
    char *p = buf;

    while (len--) {
        if (blkno == 0) {
            blkno = bmap(di, di->di_size);
            bio(blkno, READ);
        }

        block[BLKOFS(di)] = *p++;
        ++di->di_size;

        if (BLKOFS(di) == 0 || len == 0) {
            bio(blkno, WRITE);
            blkno = 0;
        }
    }
}

/* write a directory entry into `di' with
   the given `name' which refers to `ino'. */

void
entry(struct dinode *di, char *name, ino_t ino)
{
    struct direct direct;

    memset(direct.d_name, 0, NAME_MAX);
    strncpy(direct.d_name, name, NAME_MAX);
    direct.d_ino = ino;

    iwrite(di, &direct, sizeof(direct));
}

/* convert text to a number. make
   an attempt to validate it. */

unsigned
convert(char *text)
{
    char *endptr;
    unsigned long ul;

    errno = 0;
    ul = strtoul(text, &endptr, 0);

    if (*endptr || errno)
        error(1, "bogus number `%s'", text);

    if (ul > UINT_MAX)
        error(0, "`%s' is too large", text);

    return ul;
}

/* skip whitespace in the prototype file.
   set `eof' when we're just cleaning up
   trailing whitespace at end of file */

void
skip(int eof)
{
    while (isspace(ch)) {
        if (ch == '\n') ++line;
        NEXT();
    }

    if (eof && ch != EOF) error(0, "unexpected EOF");
    if (!eof && ch == EOF) error(0, "premature EOF");
}

/* get a number from the prototype file. it's
   interpreted as decimal, unless prefixed with
   0, in which case it's interpreted as octal.

   this is used for major/minor device numbers,
   modes, uids, and gids, so we don't need to
   check for negative numbers. we don't bother
   guarding against overflow. */

int
get_num(void)
{
    int octal = 0;
    int i = 0;

    skip(0);

    if (!isdigit(ch))
        error(0, "number expected");

    if (ch == '0') ++octal;

    while (isdigit(ch)) {
        if (octal)
            i <<= 3;
        else
            i *= 10;

        i += ch - '0';
        NEXT();
    }

    return i;
}

/* read a sequence of non-space characters from
   the prototype file, at most `len'-1 characters */

void
get_name(char *name, int len)
{
    skip(0);

    while (!isspace(ch)) {
        if (len == 1)
            error(0, "name too long");

        *name++ = ch;
        --len;
        NEXT();
    }

    *name = 0;
}

/* XXX */

void
do_proto(struct dinode *dir_di, ino_t dir_ino)
{
    struct dinode   entry_di;
    ino_t           entry_ino;
    char            entry_name[NAME_MAX + 1];
    char            path[PATH_MAX + 1];
    int             major, minor;
    FILE            *fp;
    int             i;

    for (;;)
    {
        get_name(entry_name, NAME_MAX);
        if (!strcmp(entry_name, "$")) return;

        entry_ino = ialloc(&entry_di);
        entry(dir_di, entry_name, entry_ino);

        entry_di.di_nlink = 1;
        entry_di.di_mode = get_num();
        entry_di.di_uid = get_num();
        entry_di.di_gid = get_num();

        if (S_ISDIR(entry_di.di_mode)) {
            entry(&entry_di, ".", entry_ino); ++entry_di.di_nlink;
            entry(&entry_di, "..", dir_ino);  ++dir_di->di_nlink;
            do_proto(&entry_di, entry_ino);
        } else if (S_ISBLK(entry_di.di_mode) || S_ISCHR(entry_di.di_mode)) {
            major = get_num();
            minor = get_num();
            entry_di.di_rdev = MAKEDEV(major, minor);
        } else if (S_ISREG(entry_di.di_mode)) {
            get_name(path, PATH_MAX);
            fp = fopen(path, "r");
            if (fp == 0) error(1, "can't open `%s'", path);

            while (i = fread(buf, 1, FS_BLOCK_SIZE, fp))
                iwrite(&entry_di, buf, i);

            fclose(fp);
        } else
            error(0, "invalid mode");

        iput(&entry_di, entry_ino);
    }
}

int
main(int argc, char **argv)
{
    int opt;

    while ((opt = getopt(argc, argv, "p:n:")) != EOF)
    {
        switch (opt)
        {
        case 'n':   nr_inodes = convert(optarg); break;

        case 'p':   proto = fopen(optarg, "r");
                    if (proto == 0) error(1, "can't open `%s'", optarg);
                    break;

        default:    goto usage;
        }
    }

    argc -= optind;
    if (argc < 2) goto usage;

    nr_blocks = convert(argv[optind + 1]);
    device = open(argv[optind], O_RDWR);
    if (device == -1) error(1, "can't open `%s'", argv[optind]);

    if (nr_blocks < FS_MIN_BLOCKS || nr_blocks > FS_MAX_BLOCKS)
        error(0, "can't make a filesystem that size");

    if (nr_inodes == 0) nr_inodes = nr_blocks / 8;
    if (nr_inodes < FS_MIN_INODES) nr_inodes = FS_MIN_INODES;
    nr_inodes = ROUND_UP(nr_inodes, FS_INODES_PER_BLOCK);

    if (nr_inodes > FS_MAX_INODES || nr_inodes > nr_blocks)
        error(0, "sorry, too many inodes");

    /* ok, fill in the superblock. */

    fs.s_magic = FS_SUPER_MAGIC;
    fs.s_magic2 = FS_SUPER_MAGIC2;
    fs.s_mtime = fs.s_ctime = time(0);
    fs.s_blocks = nr_blocks;
    fs.s_inodes = nr_inodes;
    fs.s_bmap_blocks = BITMAP_BLOCKS(nr_blocks);
    fs.s_imap_blocks = BITMAP_BLOCKS(nr_inodes);
    fs.s_inode_blocks = nr_inodes / FS_INODES_PER_BLOCK;
    fs.s_free_inodes = nr_inodes - 1;
    fs.s_free_blocks = nr_blocks - FS_DATA_START(fs);

    /* from here on out, nr_inodes and nr_blocks
       count the number of allocated items */

    nr_inodes = 1;
    nr_blocks = FS_DATA_START(fs);

    /* build the root directory */

    ialloc(&root);
    root.di_mode = S_IFDIR | 0555;
    root.di_nlink = 2;
    entry(&root, ".", FS_ROOT_INO);
    entry(&root, "..", FS_ROOT_INO);

    /* if there's a prototype, populate the filesystem */

    if (proto) {
        ++line;
        NEXT();
        do_proto(&root, FS_ROOT_INO);
        skip(1);
        fclose(proto);
        line = 0;
    }

    /* write out root inode, bitmaps, and superblock */

    iput(&root, FS_ROOT_INO);

    bitmap(FS_BMAP_START(fs), fs.s_bmap_blocks, nr_blocks);
    bitmap(FS_IMAP_START(fs), fs.s_imap_blocks, nr_inodes);

    memset(block, 0, FS_BLOCK_SIZE);
    memcpy(block + FS_SUPER_OFFSET, &fs, sizeof(struct filsys));
    bio(FS_SUPER_BLOCK, WRITE);

    close(device);
    return 0;

usage:
    error(0, "syntax: mkfs <device> <# blocks> [-p <proto>] [-n <inodes>]");
}

/* vi: set ts=4 expandtab: */
