#!/bin/bash
export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
export C_INCLUDE_PATH=${PREFIX}/include

cd ./dysgu
git clone --recurse-submodules https://github.com/samtools/htslib.git
cd ./htslib
git clone https://github.com/ebiggers/libdeflate.git
ln -s libdeflate/libdeflate.h .
pwd
ls
autoreconf -i
./configure --with-libdeflate
${BUILD_PREFIX}/include
make
cd ../../

$PYTHON setup.py install --single-version-externally-managed --record=record.txt
