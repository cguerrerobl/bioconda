cd src

# Link flags are on the wrong line, leads to problems with NLOPT enabled.
sed -i.bak 's/argv_parser.o \$(TREEATORLINKFLAGS)$/argv_parser.o/' Makefile 
sed -i.bak 's/\$(PP) -o treeator \$(OTREEATOR)/\$(PP) -o treeator \$(OTREEATOR) \$(TREEATORLINKFLAGS)/' Makefile

# CFLAGS, CPPFLAGS, and LDFLAGS are missing
sed -i.bak '/\$(PP).*-c/ s/-c/$(CFLAGS) -c/' Makefile
sed -i.bak '/\$(CC).*-c/ s/-c/$(CFLAGS) -c/' Makefile
sed -i.bak '/\$(PP).*-o/ s/-o/$(LDFLAGS) -o/' Makefile

make PP="$CXX" CC="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS" NLOPT=YES PTHREADS=YES

# Makefile has no install target 
mkdir -p $PREFIX/bin

mv pairalign $PREFIX/bin/
mv contree $PREFIX/bin/
mv treeator $PREFIX/bin/
mv treebender $PREFIX/bin/
