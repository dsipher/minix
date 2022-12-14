/*****************************************************************************

   list.c                                              minix tape archiver

******************************************************************************

   Copyright (c) 2021-2023 by Charles E. Youse (charles@gnuless.org).
   derived from John Gilmore's public domain tar (USENET, Nov 1987)

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

#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <time.h>
#include <sys/stat.h>
#include "tar.h"
#include "port.h"

#define	isodigit(c)	( ((c) >= '0') && ((c) <= '7') )

long from_oct();			/* Decode octal number */
void demode();				/* Print file mode */

union record *head;			/* Points to current archive header */
struct stat hstat;			/* Stat struct corresponding */
int head_standard;			/* Tape header is in ANSI format */

void skip_file();


/*
 * Main loop for reading an archive.
 */
void
read_and(void (*do_something)(void))
{
	int status = 3;			/* Initial status at start of archive */
	int prev_status;

	name_gather();			/* Gather all the names */
	open_archive(1);		/* Open for reading */

	for(;;) {
		prev_status = status;
		status = read_header();
		switch (status) {

		case 1:			/* Valid header */
			/* We should decode next field (mode) first... */
			/* Ensure incoming names are null terminated. */
			head->header.name[NAMSIZ-1] = '\0';

			if (!name_match(head->header.name)) {
				/* Skip past it in the archive */
				userec(head);
				/* Skip to the next header on the archive */
				skip_file((long)hstat.st_size);
				continue;
			}

			(*do_something)();
			continue;

			/*
			 * If the previous header was good, tell them
			 * that we are skipping bad ones.
			 */
		case 0:			/* Invalid header */
			userec(head);
			switch (prev_status) {
			case 3:		/* Error on first record */
				annorec(stderr, tar);
				fprintf(stderr,
				"Hmm, this doesn't look like a tar archive.\n");
				/* FALL THRU */
			case 2:		/* Error after record of zeroes */
			case 1:		/* Error after header rec */
				annorec(stderr, tar);
				fprintf(stderr,
					"Skipping to next file header...\n");
			case 0:		/* Error after error */
				break;
			}
			continue;

		case 2:			/* Record of zeroes */
			userec(head);
			status = prev_status;	/* If error after 0's */
			if (f_ignorez)
				continue;
			/* FALL THRU */
		case EOF:		/* End of archive */
			break;
		}
		break;
	};

	close_archive();
	names_notfound();		/* Print names not found */
}


/*
 * Print a header record, based on tar options.
 */

void
list_archive(void)
{

	/* Save the record */
	saverec(&head);

	/* Print the header record */
	if (f_verbose) {
		if (f_verbose > 1)
			decode_header(head, &hstat, &head_standard, 0);
		print_header(stdout);
	}

	/* Skip past it in the archive */
	saverec((union record **) 0);	/* Unsave it */
	userec(head);

	/* Skip to the next header on the archive */
	skip_file((long)hstat.st_size);
}


/*
 * Read a record that's supposed to be a header record.
 * Return its address in "head", and if it is good, the file's
 * size in hstat.st_size.
 *
 * Return 1 for success, 0 if the checksum is bad, EOF on eof,
 * 2 for a record full of zeros (EOF marker).
 *
 * You must always userec(head) to skip past the header which this
 * routine reads.
 */

int
read_header(void)
{
	register int	i;
	register long	sum, recsum;
	register char	*p;
	register union record *header;

	header = findrec();
	head = header;		/* This is our current header */
	if (NULL == header) return EOF;

	recsum = from_oct(8,  header->header.chksum);

	sum = 0;
	p = header->charptr;
	for (i = sizeof(*header); --i >= 0;) {
		/*
		 * We can't use unsigned char here because of old compilers,
		 * e.g. V7.
		 */
		sum += 0xFF & *p++;
	}

	/* Adjust checksum to count the "chksum" field as blanks. */
	for (i = sizeof(header->header.chksum); --i >= 0;)
		sum -= 0xFF & header->header.chksum[i];
	sum += ' '* sizeof header->header.chksum;

	if (sum == recsum) {
		/*
		 * Good record.  Decode file size and return.
		 */
		if (header->header.linkflag == LF_LINK)
			hstat.st_size = 0;	/* Links 0 size on tape */
		else
			hstat.st_size = from_oct(1+12, header->header.size);
		return 1;
	}

	if (sum == 8*' ') {
		/*
		 * This is a zeroed record...whole record is 0's except
		 * for the 8 blanks we faked for the checksum field.
		 */
		return 2;
	}

	return 0;
}


/*
 * Decode things from a file header record into a "struct stat".
 * Also set "*stdp" to !=0 or ==0 depending whether header record is "Unix
 * Standard" tar format or regular old tar format.
 *
 * read_header() has already decoded the checksum and length, so we don't.
 *
 * If wantug != 0, we want the uid/group info decoded from Unix Standard
 * tapes (for extraction).  If == 0, we are just printing anyway, so save time.
 *
 * decode_header should NOT be called twice for the same record, since the
 * two calls might use different "wantug" values and thus might end up with
 * different uid/gid for the two calls.  If anybody wants the uid/gid they
 * should decode it first, and other callers should decode it without uid/gid
 * before calling a routine, e.g. print_header, that assumes decoded data.
 */

void
decode_header(union record *header, struct stat *st, int *stdp, int wantug)
{

	st->st_mode = from_oct(8,  header->header.mode);
	st->st_mtime = from_oct(1+12, header->header.mtime);

	if (0==strcmp(header->header.magic, TMAGIC)) {
		/* Unix Standard tar archive */
		*stdp = 1;
		if (wantug) {
#ifdef NONAMES
			st->st_uid = from_oct(8,  header->header.uid);
			st->st_gid = from_oct(8,  header->header.gid);
#else
			st->st_uid = finduid(header->header.uname);
			st->st_gid = findgid(header->header.gname);
#endif
		}
		switch  (header->header.linkflag)
		case LF_BLK: case LF_CHR:
		    st->st_rdev = MAKEDEV(from_oct(8, header->header.devmajor),
			 		  from_oct(8, header->header.devminor));
	} else {
		/* Old fashioned tar archive */
		*stdp = 0;
		st->st_uid = from_oct(8,  header->header.uid);
		st->st_gid = from_oct(8,  header->header.gid);
		st->st_rdev = 0;
	}
}


/*
 * Quick and dirty octal conversion.
 *
 * Result is -1 if the field is invalid (all blank, or nonoctal).
 */
long
from_oct(digs, where)
	register int	digs;
	register char	*where;
{
	register long	value;

	while (isspace(*where)) {		/* Skip spaces */
		where++;
		if (--digs <= 0)
			return -1;		/* All blank field */
	}
	value = 0;
	while (digs > 0 && isodigit(*where)) {	/* Scan til nonoctal */
		value = (value << 3) | (*where++ - '0');
		--digs;
	}

	if (digs > 0 && *where && !isspace(*where))
		return -1;			/* Ended on non-space/nul */

	return value;
}


/*
 * Actually print it.
 *
 * Plain and fancy file header block logging.
 * Non-verbose just prints the name, e.g. for "tar t" or "tar x".
 * This should just contain file names, so it can be fed back into tar
 * with xargs or the "-T" option.  The verbose option can give a bunch
 * of info, one line per file.  I doubt anybody tries to parse its
 * format, or if they do, they shouldn't.  Unix tar is pretty random here
 * anyway.
 *
 * Note that print_header uses the globals <head>, <hstat>, and
 * <head_standard>, which must be set up in advance.  This is not very clean
 * and should be cleaned up.  FIXME.
 */
#define	UGSWIDTH	11		/* min width of User, group, size */
#define	DATEWIDTH	19		/* Last mod date */
static int	ugswidth = UGSWIDTH;	/* Max width encountered so far */

void
print_header(FILE *outfile)
{
	char modes[11];
	char *timestamp;
	char uform[11], gform[11];	/* These hold formatted ints */
	char *user, *group;
	char size[24];		/* Holds a formatted long or maj, min */
	long longie;		/* To make ctime() call portable */
	int	pad;

	annofile(outfile, (char *)NULL);

	if (f_verbose <= 1) {
		/* Just the fax, mam. */
		fprintf(outfile, "%s\n", head->header.name);
		return;
	} else {
		/* File type and modes */
		modes[0] = '?';
		switch (head->header.linkflag) {
		case LF_NORMAL:
		case LF_OLDNORMAL:
		case LF_LINK:
				modes[0] = '-';
				if ('/' == head->header.name[strlen(head->header.name)-1])
					modes[0] = 'd';
				break;
		case LF_DIR:	modes[0] = 'd'; break;
		case LF_SYMLINK:modes[0] = 'l'; break;
		case LF_BLK:	modes[0] = 'b'; break;
		case LF_CHR:	modes[0] = 'c'; break;
		case LF_FIFO:	modes[0] = 'p'; break;
		case LF_CONTIG:	modes[0] = 'C'; break;
		}

		demode((unsigned)hstat.st_mode, modes+1);

		/* Timestamp */
		longie = hstat.st_mtime;
		timestamp = ctime(&longie);
		timestamp[16] = '\0';
		timestamp[24] = '\0';

		/* User and group names */
		if (*head->header.uname && head_standard) {
			user  = head->header.uname;
		} else {
			user = uform;
			(void)sprintf(uform, "%d", (int)hstat.st_uid);
		}
		if (*head->header.gname && head_standard) {
			group = head->header.gname;
		} else {
			group = gform;
			(void)sprintf(gform, "%d", (int)hstat.st_gid);
		}

		/* Format the file size or major/minor device numbers */
		switch (head->header.linkflag) {
		case LF_CHR:
		case LF_BLK:
			(void)sprintf(size, "%d,%d",
					MAJOR(hstat.st_rdev),
					MINOR(hstat.st_rdev));
			break;

		default:
			(void)sprintf(size, "%ld", (long)hstat.st_size);
		}

		/* Figure out padding and print the whole line. */
		pad = strlen(user) + strlen(group) + strlen(size) + 1;
		if (pad > ugswidth) ugswidth = pad;

		fprintf(outfile, "%s %s/%s %*s%s %s %s %.*s",
			modes,
			user,
			group,
			ugswidth - pad,
			"",
			size,
			timestamp+4, timestamp+20,
			sizeof(head->header.name),
			head->header.name);

		switch (head->header.linkflag) {
		case LF_SYMLINK:
			fprintf(outfile, " -> %s\n", head->header.linkname);
			break;

		case LF_LINK:
			fprintf(outfile, " link to %s\n", head->header.linkname);
			break;

		default:
			fprintf(outfile, " unknown file type '%c'\n",
				head->header.linkflag);
			break;

		case LF_OLDNORMAL:
		case LF_NORMAL:
		case LF_CHR:
		case LF_BLK:
		case LF_DIR:
		case LF_FIFO:
		case LF_CONTIG:
			putc('\n', outfile);
			break;
		}
	}
}

/*
 * Print a similar line when we make a directory automatically.
 */
void
pr_mkdir(pathname, length, mode, outfile)
	char *pathname;
	int length;
	int mode;
	FILE *outfile;
{
	char modes[11];

	if (f_verbose > 1) {
		/* File type and modes */
		modes[0] = 'd';
		demode((unsigned)mode, modes+1);

		annofile(outfile, (char *)NULL);
		fprintf(outfile, "%s %*s %.*s\n",
			modes,
			ugswidth+DATEWIDTH,
			"Creating directory:",
			length,
			pathname);
	}
}


/*
 * Skip over <size> bytes of data in records in the archive.
 */
void
skip_file(size)
	register long size;
{
	union record *x;

	while (size > 0) {
		x = findrec();
		if (x == NULL) {	/* Check it... */
			annorec(stderr, tar);
			fprintf(stderr, "Unexpected EOF on archive file\n");
			exit(EX_BADARCH);
		}
		userec(x);
		size -= RECORDSIZE;
	}
}


/*
 * Decode the mode string from a stat entry into a 9-char string and a null.
 */
void
demode(mode, string)
	register unsigned mode;
	register char *string;
{
	register unsigned mask;
	register char *rwx = "rwxrwxrwx";

	for (mask = 0400; mask != 0; mask >>= 1) {
		if (mode & mask)
			*string++ = *rwx++;
		else {
			*string++ = '-';
			rwx++;
		}
	}

	if (mode & S_ISUID)
		if (string[-7] == 'x')
			string[-7] = 's';
		else
			string[-7] = 'S';
	if (mode & S_ISGID)
		if (string[-4] == 'x')
			string[-4] = 's';
		else
			string[-4] = 'S';
	if (mode & S_ISVTX)
		if (string[-1] == 'x')
			string[-1] = 't';
		else
			string[-1] = 'T';
	*string = '\0';
}

/* vi: set ts=4 expandtab: */
