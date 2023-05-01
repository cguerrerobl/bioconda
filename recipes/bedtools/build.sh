#!/bin/sh
export CPLUS_INCLUDE_PATH="${PREFIX}/include"
export C_INCLUDE_PATH="${PREFIX}/include"
cd 'bedtools2' || exit 1
make install prefix="$PREFIX" CXX="$CXX" CC="$CC" LDFLAGS="-L$PREFIX/lib"
