(cd as; make clean)
rm -rf as/regress/a.out
rm -rf as/regress/*.bin
rm -rf as/regress/*.gas

(cd cc1; make clean)
rm -rf cc1/regress/stage1
rm -rf cc1/regress/stage2
rm -rf cc1/regress/stage3/bin
rm -rf cc1/regress/stage3/lib
rm -rf cc1/regress/stage3/include

(cd cpp; make clean)
(cd libc; make clean)
