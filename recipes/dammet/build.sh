#!/bin/bash

export C_INCLUDE_PATH=${PREFIX}/include
export CPP_INCLUDE_PATH=${PREFIX}/include
export CPLUS_INCLUDE_PATH=${PREFIX}/include
export CXX_INCLUDE_PATH=${PREFIX}/include
export LIBRARY_PATH=${PREFIX}/lib
export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"

make -f  makefile.bioconda
make -f makefile.bioconda install PREFIX=${PREFIX}
