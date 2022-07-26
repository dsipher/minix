static const char digits[] = {
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
};

static const char ldigits[] = {
    '0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
};

char *convert(char *cp, unsigned long n, unsigned b, int c)
{
    char *ep;
    const char *dp;
    char pbuf[23];

    dp = (c == 'x') ? ldigits : digits;
    ep = &pbuf[23-1];
    *ep = '\0';

    do {
        *--ep = dp[n%b];
    } while ((n /= b) != 0);

    while (*ep)
        *cp++ = *ep++;

    return cp;
}

