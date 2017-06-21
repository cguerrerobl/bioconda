#!/bin/bash
set -x

cd src
autoconf

# build version with MPI & Beagle
./configure \
    --prefix=$PREFIX \
    --disable-debug \
    --with-beagle=$PREFIX \
    --enable-mpi \
    --program-suffix mpi

make -j$CPU_COUNT
make install
mv $PREFIX/bin/mb{,-mpi}

# build version with Beagle only
./configure \
    --prefix=$PREFIX \
    --disable-debug \
    --with-beagle=$PREFIX

make -j$CPU_COUNT
make install
