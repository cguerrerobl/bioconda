#!/bin/bash

set -x

export INCLUDES="-I${PREFIX}/include"
export LIBPATH="-L${PREFIX}/lib"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"
export CFLAGS="${CFLAGS} -O3"
export CPPFLAGS="${CPPFLAGS} -I${PREFIX}/include"
export CXXFLAGS=$(echo "$CXXFLAGS" | sed 's/-std=c++17//g')
export CMAKE_C_COMPILER="${CC}"
export CMAKE_CXX_COMPILER="${CXX}"

if [ "$(uname)" == Darwin ]; then
	export CMAKE_C_COMPILER="clang"
	export CMAKE_CXX_COMPILER="clang++"
fi

mkdir build
cd build

cmake -D CMAKE_INSTALL_PREFIX:PATH="${PREFIX}" -DUSE_LSD2=ON -DIQTREE_FLAGS=omp ..

make --jobs "${CPU_COUNT}"
make install
cp "${PREFIX}"/bin/iqtree2 "${PREFIX}"/bin/iqtree
