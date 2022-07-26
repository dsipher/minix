# 1 "sigemptyset.c"

# 20 "/home/charles/xcc/include/signal.h"
typedef void(*__sighandler_t)(int);





typedef unsigned long sigset_t;

struct sigaction
{
    __sighandler_t sa_handler;
    unsigned long sa_flags;
    void (*sa_restorer)(void);
    sigset_t sa_mask;
};





extern __sighandler_t signal(int, __sighandler_t);
extern void __sigreturn(void);
extern int __sigaction(int, const struct sigaction *, struct sigaction *);
extern int sigaction(int, const struct sigaction *, struct sigaction *);
extern int sigemptyset(sigset_t *);
# 12 "sigemptyset.c"
int sigemptyset(sigset_t *set)
{
    *set = 0;
    return 0;
}
