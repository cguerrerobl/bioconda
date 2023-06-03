#!/bin/sh

export CFLAGS="$C -no-pie -lrt"
export CXXFLAGS="$CXXFLAGS -std=c++20 -no-pie -lrt"

CC=$CC
CXX=$CXX
LINK=$CC

alias g++=$CXX

rustvers="nightly-2023-04-20"

mkdir -p $PREFIX/bin

export RUSTFLAGS="-C linker=$CC"

export RUSTUP_HOME="$HOME/rustup"
export CARGO_HOME="$HOME/cargo"
wget https://sh.rustup.rs -O rustup.sh
sh rustup.sh -y --default-toolchain $rustvers
export PATH="$CARGO_HOME/bin:$PATH"

git submodule update --init --recursive

echo "$rustvers" > ggcat/rust-toolchain

cd build
cmake .. -DMAX_KMER_LENGTH=64 -DCMAKE_BUILD_ZLIB=1 -DCMAKE_BUILD_BZIP2=0 -DROARING_DISABLE_NATIVE=ON
make -j${CPU_COUNT} ${VERBOSE_AT}

cp bin/themisto $PREFIX/bin
