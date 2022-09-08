# 1 "strncmp.c"

# 15 "/home/charles/xcc/include/sys/jewel.h"
typedef long            __blkcnt_t;
typedef long            __blksize_t;
typedef unsigned long   __dev_t;
typedef unsigned        __gid_t;
typedef unsigned long   __ino_t;
typedef unsigned        __mode_t;
typedef unsigned long   __nlink_t;
typedef long            __off_t;
typedef int             __pid_t;
typedef unsigned long   __size_t;
typedef long            __ssize_t;
typedef unsigned        __uid_t;
typedef char            *__va_list;
# 17 "/home/charles/xcc/include/string.h"
typedef __size_t size_t;


extern void *memchr(const void *, int, size_t);
extern int memcmp(const void *, const void *, size_t);
extern void *memcpy(void *, const void *, size_t);
extern void *memmove(void *, const void *, size_t);
extern void *memset(void *, int, size_t);
extern char *strcat(char *, const char *);
extern char *strchr(const char *, int);
extern int strcmp(const char *, const char *);
extern char *strcpy(char *, const char *);
extern char *strerror(int);
extern size_t strlen(const char *);
extern char *strncat(char *, const char *, size_t);
extern int strncmp(const char *, const char *, size_t);
extern char *strncpy(char *, const char *, size_t);
extern char *strrchr(const char *, int);
# 12 "strncmp.c"
int strncmp(const char *s1, const char *s2, size_t n)
{
    if (n) {
        do {
            if (*s1 != *s2++)
                break;

            if (*s1++ == '\0')
                return 0;
        } while (--n > 0);

        if (n > 0) {
            if (*s1 == '\0')
                return -1;

            if (*--s2 == '\0')
                return 1;

            return (unsigned char) *s1 - (unsigned char) *s2;
        }
    }

    return 0;
}
