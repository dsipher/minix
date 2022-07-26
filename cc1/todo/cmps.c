struct reload
{
    int base;
    long offset;
    struct symbol *sym;
};

int reload_precedes(struct reload *r1, struct reload *r2)
{
    if (r1->base < r2->base) return 1;
    if (r1->base > r2->base) return -1;

    if (r1->offset < r2->offset) return 1;
    if (r1->offset > r2->offset) return -1;

    if (r1->sym < r2->sym) return 1;
    if (r1->sym > r2->sym) return -1;

    return 0;
}
