/*****************************************************************************

   mkboot.c                                       minix boot block manager

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
#include <string.h>
#include <errno.h>
#include <stdarg.h>
#include <fcntl.h>
#include <unistd.h>
#include <a.out.h>
#include <sys/fs.h>

#ifndef BOOT
#define BOOT "/lib/boot"
#endif /* BOOT */

struct filsys   fs;
char            *device_path;
char            *boot_path = BOOT;
int             device_fd, boot_fd;
char            buf[FS_BLOCK_SIZE];

#define EXEC    ((struct exec *) buf)

void
error(int system, char *fmt, ...)
{
    va_list args;

    fprintf(stderr, "mkboot: ");

    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);

    if (system) fprintf(stderr, " (%s)", strerror(errno));

    fputc('\n', stderr);
    exit(1);
}

/* read or write the first block at the
   beginning of `fd' to or from `buf'.

   handle the tedious error checking and
   reporting if something goes wrong. */

#define READ    0
#define WRITE   1

void
io(int fd, int op)
{
    char *path = (fd == device_fd) ? device_path : boot_path;
    char *desc = (op == READ) ? "read" : "write";

    ssize_t ret = (op == READ) ? read(fd, buf, FS_BLOCK_SIZE)
                               : write(fd, buf, FS_BLOCK_SIZE);

    if (lseek(fd, 0, SEEK_SET) == -1)
        error(1, "%s: seek failure");

    if (ret != FS_BLOCK_SIZE)
        if (ret < 0)
            error(1, "%s: %s failure", path, desc);
        else
            error(0, "%s: short %s", path, desc);
}

int
main(int argc, char **argv)
{
    int opt;

    while ((opt = getopt(argc, argv, "b:")) != EOF)
    {
        switch (opt)
        {
        case 'b':   boot_path = optarg; break;
        default:    goto usage;
        }
    }

    argc -= optind;
    if (argc != 1) goto usage;
    device_path = argv[optind];

    /* open the device and
       read the superblock */

    if ((device_fd = open(device_path, O_RDWR)) == -1)
        error(1, "%s: can't open device", device_path);

    io(device_fd, READ);
    memcpy(&fs, buf + FS_SUPER_OFFSET, sizeof(struct filsys));

    if (fs.s_magic != FS_SUPER_MAGIC || fs.s_magic2 != FS_SUPER_MAGIC2)
        error(0, "%s: invalid filesystem", device_path);

    /* open the prospective boot block
       and make sure it looks right */

    if ((boot_fd = open(boot_path, O_RDONLY)) == -1)
        error(1, "%s: can't open", boot_path);

    io(boot_fd, READ);

    if (N_BADMAG(*EXEC) || (EXEC->a_text != FS_BLOCK_SIZE))
        error(1, "%s: bogus boot block", boot_path);

    close(boot_fd);

    /* merge the superblock into the boot block
       and write the result out to the device */

    fs.s_boot_magic = FS_BOOT_MAGIC;    /* mark bootable */
    memcpy(buf + FS_SUPER_OFFSET, &fs, sizeof(struct filsys));
    io(device_fd, WRITE);
    close(device_fd);

    return 0;

usage:
    error(0, "syntax: mkboot [-b <boot block>] <device>");
}

/* vi: set ts=4 expandtab: */
