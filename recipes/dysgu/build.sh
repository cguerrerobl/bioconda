#!/bin/bash
export CFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
export C_INCLUDE_PATH=${PREFIX}/include

# build bundled htslib
cd ./dysgu
wget -O htslib.tar.bz2 https://github.com/samtools/htslib/releases/download/1.17/htslib-1.17.tar.bz2
tar -xvf htslib.tar.bz2
rm htslib.tar.bz2 && cd htslib
autoreconf -i
./configure --enable-libcurl --with-libdeflate --enable-bz2 --enable-lzma
make
cd ../../

$PYTHON setup.py install --single-version-externally-managed --record=record.txt
