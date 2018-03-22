#!/bin/bash

mkdir build
cd build

cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX -DLPSOLVE_INCLUDE_DIR="${PREFIX}/include" -DLPSOLVE_LIBRARY_DIR="${PREFIX}/include" -DBoost_INCLUDE_DIR="${PREFIX}/include" -DBOOST_LIBRARYDIR="${PREFIX}/include"

make
make install

cp cmfid ${PREFIX}/bin/cmfid

