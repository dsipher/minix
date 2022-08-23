	cvtss2sd %xmm0,%xmm8
	cvtss2sd %xmm0,%xmm0
	cvtss2sd -144(%rbp),%xmm0
	cvtss2sd 16(%rbp),%xmm0
	cvtss2sd 16(%rbp),%xmm15

	cvtsd2ss %xmm8,%xmm0
	cvtsd2ss -144(%rbp),%xmm0
	cvtsd2ss 16(%rbp),%xmm0
	cvtsd2ss 16(%rbp),%xmm15

