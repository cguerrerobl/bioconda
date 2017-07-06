#!/bin/sh

export C_INCLUDE_PATH=${PREFIX}/include
export LIBRARY_PATH=${PREFIX}/lib
export LD_LIBRARY_PATH=${PREFIX}/lib

mkdir contrib-build
cd contrib-build
cmake -DBUILD_TYPE=WILDMAGIC ../contrib

cd ..
mkdir build
cd build

ORIGIN='$ORIGIN'
export ORIGIN
LDFLAGS='-Wl,-rpath,$${ORIGIN}/../lib'

cmake .. -DOPENMS_CONTRIB_LIBS='../../contrib-build' -DCMAKE_INSTALL_PREFIX=$PREFIX -DHAS_XSERVER=OFF -DENABLE_TUTORIALS=OFF -DENABLE_STYLE_TESTING=OFF -DENABLE_UNITYBUILD=OFF -DWITH_GUI=OFF -DBoost_LIB_VERSION=1.64.0 -DBoost_INCLUDE_DIR=$PREFIX/include -DBoost_LIBRARY_DIRS=$PREFIX/lib -DBoost_LIBRARIES=$PREFIX/lib -DBoost_DEBUG=ON -DBOOST_LIBRARYDIR=$PREFIX/lib/ -DBOOST_USE_STATIC=OFF

make -j2
make install
