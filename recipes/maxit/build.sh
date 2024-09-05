#!/bin/bash

export INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"
export CFLAGS="${CFLAGS} -O3 ${LDFLAGS}"
export RCSBROOT=${PREFIX}

ln -s ${CC} ${BUILD_PREFIX}/bin/gcc
ln -s ${CXX} ${BUILD_PREFIX}/bin/c++
ln -s ${CXX} ${BUILD_PREFIX}/bin/cxx
ln -s ${GXX} ${BUILD_PREFIX}/bin/g++

cd ${RCSBROOT}/cifparse-obj-v7.0
sed -i 's/mv /cp /g' Makefile

cd ${RCSBROOT}
sed -i 's|./data/binary|\${RCSBROOT}/data/binary|g' binary.sh

cd ${RCSBROOT}
make binary

unlink ${BUILD_PREFIX}/bin/gcc
unlink ${BUILD_PREFIX}/bin/c++
unlink ${BUILD_PREFIX}/bin/cxx
unlink ${BUILD_PREFIX}/bin/g++

install -d ${PREFIX}/bin
install ${RCSBROOT}/bin/* ${PREFIX}/bin
install -d ${PREFIX}/data
install -m 644 ${RCSBROOT}/data/* ${PREFIX}/data
