#!/bin/bash

mkdir -p $PREFIX/bin

export CPATH=${PREFIX}/include

make INCLUDES="-I$PREFIX/include" CFLAGS="-g -Wall -O2 -Wc++-compat -L$PREFIX/lib" minimap2 sdust
cp minimap2 misc/paftools.js $PREFIX/bin
cp sdust $PREFIX/bin

if [ ! -d $PREFIX/share/man/man1 ] ; then
  mkdir -p $PREFIX/share/man/man1
fi

cp minimap2.1 $PREFIX/share/man/man1
