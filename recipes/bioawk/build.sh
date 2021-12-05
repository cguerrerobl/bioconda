#!/bin/bash
export LIBRARY_PATH="$PREFIX/lib"

make CC="${CC}" HOSTCC="${CC}" CFLAGS="-g -Wall -O2 -DBIO_VERSION='\"$PKG_VERSION\"' -I$PREFIX/include -L$PREFIX/lib"

mkdir -p "$PREFIX/bin"
cp bioawk "$PREFIX/bin"
