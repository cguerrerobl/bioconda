#!/bin/bash


# zlib hack
sed -i 's/CFLAGS =/CFLAGS +=/' Makefile
make CC=$CC INCLUDES="-I$PREFIX/include" CFLAGS+="-g -Wall -O2 -L$PREFIX/lib"
chmod +x srnaMapper
mkdir -p ${PREFIX}/bin
cp -f srnaMapper ${PREFIX}/bin
