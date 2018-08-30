#!/bin/bash

export PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig \
 OPENMP_HEADER_DIR=${PREFIX}/include \
 OPENMP_LIB_DIR=${PREFIX}/lib \
 FREETYPE_DIR=${PREFIX}

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DOPENSSL_ROOT_DIR=${PREFIX} \
 -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXE_LINKER_FLAGS_RELEASE="-L${PREFIX}/lib" \
 -DWORKBENCH_USE_QT5=TRUE -DZLIB_ROOT=${PREFIX} -DWORKBENCH_MESA_DIR=${PREFIX} \
 -DCMAKE_PREFIX_PATH=${PREFIX} -DPKG_CONFIG_USE_CMAKE_PREFIX_PATH=True ../src
make -j ${CPU_COUNT}
make install
