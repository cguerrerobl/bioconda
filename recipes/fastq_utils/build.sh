#!/bin/bash

mkdir -p $PREFIX/bin

export C_INCLUDE_PATH="${PREFIX}/include:${PREFIX}/include/bam"
export CXX_INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib"

# Compile and install. Replace gcc with $CC

sed -i.bak "s/gcc/\$CC/g" Makefile
make
make install

# Copy executables into prefix

cp bin/* $PREFIX/bin
