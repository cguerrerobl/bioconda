#!/bin/bash
find / -name omp.h -print
pushd src
sed -i.bak '4i\
CFLAGS += -I$(PREFIX)/include -L$(PREFIX)/lib' Makefile
make CC=${CXX}
mkdir -p ${PREFIX}/bin
mv psascan ${PREFIX}/bin/
