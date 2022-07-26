# 1 "signal.c"

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
# 16 "signal.c"
__sighandler_t signal(int sig, __sighandler_t handler)
{
    struct sigaction new = { 0 };
    struct sigaction old = { 0 };

    new.sa_handler = handler;
    new.sa_flags = 0x80000000 | 0x40000000;

    if (sigaction(sig, &new, &old) == -1)
        return ((__sighandler_t) -1);
    else
        return old.sa_handler;
}
