#!/bin/bash
set -x

cd src/
make CC=$GCC CPP=$GXX
cp SeSiMCMC $PREFIX/bin
