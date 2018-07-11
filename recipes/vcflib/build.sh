#!/bin/bash

export C_INCLUDE_PATH=$PREFIX/include
export CPLUS_INCLUDE_PATH=$PREFIX/include

#export CFLAGS="-I$PREFIX/include"
#export LDFLAGS="-L$PREFIX/lib"
export INCLUDES="-Ihtslib -I$PREFIX/include"
export LIBPATH="-L. -Lhtslib -L$PREFIX/lib"

# MacOSX Build fix: https://github.com/chapmanb/homebrew-cbl/issues/14
if [ "$(uname)" == "Darwin" ]; then
    sed -i.bak 's/LDFLAGS=-Wl,-s/LDFLAGS=/' smithwaterman/Makefile
fi
# tabix missing library https://github.com/ekg/tabixpp/issues/5
# Uses newline trick for OSX from: http://stackoverflow.com/a/24299845/252589
sed -i.bak 's/SUBDIRS=./SUBDIRS=.\'$'\n''LOBJS=tabix.o/' tabixpp/Makefile
sed -i.bak 's/-ltabix//' Makefile

#sed -i.bak 's/-Ihtslib/-Ihtslib "$CFLAGS"/' tabixpp/Makefile
#sed -i.bak 's/^LIBPATH.*/LIBPATH=-L. -Lhtslib "$LDFLAGS"/' tabixpp/Makefile

make -e

mkdir -p $PREFIX/bin
cp bin/* $PREFIX/bin
