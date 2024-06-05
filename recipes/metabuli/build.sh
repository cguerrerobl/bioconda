#!/bin/bash

ARCH_BUILD=""
case $(uname -m) in
    x86_64) ARCH_BUILD="-DHAVE_SSE4_1=1" ;;
    arm64|aarch64) ARCH_BUILD="-DHAVE_ARM8=1" ;;
esac

if [ -z "${ARCH_BUILD}" ]; then
    echo "Invalid architecture"
    exit 1
fi

mkdir build
cd build

if [[ "$(uname)" == Darwin ]]; then
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DHAVE_TESTS=0 -DHAVE_MPI=0 ${ARCH_BUILD} -DVERSION_OVERRIDE="${PKG_VERSION}" -DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}" ..
else
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DHAVE_TESTS=0 -DHAVE_MPI=0 ${ARCH_BUILD} -DVERSION_OVERRIDE="${PKG_VERSION}" ..
fi

make -j${CPU_COUNT} ${VERBOSE_CM}
make install
