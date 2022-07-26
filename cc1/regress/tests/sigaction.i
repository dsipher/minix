# 1 "sigaction.c"

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
# 15 "sigaction.c"
int sigaction(int sig, const struct sigaction *act, struct sigaction *oact)
{
    struct sigaction new;

    new = *act;
    new.sa_flags |= 0x04000000;
    new.sa_restorer = __sigreturn;

    return __sigaction(sig, &new, oact);
}
