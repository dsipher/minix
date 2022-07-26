char *comment = "the compiler should eliminate the store"
		"to _a->top at the bottom of the do-while"
		"since it's overwritten by the store at"
		"the bottom of the return expression,"
		"and eliminate the load at the head of"
		"the return expression since that value"
		"is loaded by all predecessors (gcse).";

char *comment2 = 	"also, the compiler should be able to"
			"reassociate the _p + 8 - (...) into"
			"8 + _p - (...) to avoid the awkward"
			"subtraction FROM a constant (reassoc.c)";

struct arena { void *bottom; void *top; };

void *alloc(struct arena *a, unsigned long n)
{
    do {
        struct arena *_a = (a);
        unsigned long _n = (8);
        unsigned long _p = (unsigned long) _a->top;
        if (_p % _n) { _p += _n - (_p % _n); _a->top = (void *) _p; }
    } while (0);

    return
    ({
        struct arena *_a = (a);
        void *_p = _a->top;
        _a->top = (char *) _p + (n);
        (_p);
    });
}
