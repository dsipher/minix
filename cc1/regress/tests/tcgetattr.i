# 1 "tcgetattr.c"

# 13 "/home/charles/xcc/include/termios.h"
typedef unsigned char cc_t;
typedef unsigned int speed_t;
typedef unsigned int tcflag_t;



struct termios
{
    tcflag_t c_iflag;
    tcflag_t c_oflag;
    tcflag_t c_cflag;
    tcflag_t c_lflag;
    cc_t c_line;
    cc_t c_cc[19];
};

extern int tcgetattr(int, struct termios *);
# 13 "/home/charles/xcc/include/sys/ioctl.h"
extern int ioctl(int, int, void *);
# 13 "tcgetattr.c"
int tcgetattr(int fd, struct termios *termios_p)
{
    return ioctl(fd, 0x5401, termios_p);
}
