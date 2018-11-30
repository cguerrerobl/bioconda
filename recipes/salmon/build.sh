#!/bin/bash
set -eu -o pipefail

#if [[ "$(uname)" == Darwin ]]; then
#export CC=clang
#export CXX=clang++
#export CXXFLAGS="${CXXFLAGS} -I${PREFIX}/include/c++/v1"
#export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -Wl,-rpath,${PREFIX}/lib"
#fi

#lint failing 1
#lint failing 2
#linter failing 3
#linter failing 4
#linter failing 5
#linter failing 6
#linter failing 7
#linter failing 8
#linter failing 9
#linter failing 10
#linter failing 11
#linter failing 12
#linter failing 13
#linter failing 14
#linter failing 15

mkdir -p $PREFIX/bin
mkdir -p $PREFIX/lib

mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=RELEASE -DCONDA_BUILD=TRUE -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9 -DCMAKE_INSTALL_PREFIX:PATH=$PREFIX -DBOOST_ROOT=$PREFIX -DBoost_NO_SYSTEM_PATHS=ON ..
echo "unit test executable"
./src/unitTests
echo "cmake-powered unit test"
make test
echo "installing"
make install CFLAGS="-L${PREFIX}/lib -I${PREFIX}/include"


