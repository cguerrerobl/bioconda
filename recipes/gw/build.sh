#!/usr/bin/bash
set -e
ldconfig -v | grep -v ^$'\t'
echo
ldconfig -p | grep libEGL
ldconfig -p | grep libGLESv2

#ln -s /lib64/*GL* ./lib
#ls ./lib

echo "SYSROOT"
ls $CONDA_BUILD_SYSROOT

echo "SYSROOT/usr"
ls $CONDA_BUILD_SYSROOT/usr

echo "SYSROOT/usr/lib"
ls $CONDA_BUILD_SYSROOT/usr/lib

echo "BUILD_PREFIX"
ls $BUILD_PREFIX

echo "BUILD_PREFIX/lib64"
ls $BUILD_PREFIX/lib64

#export USE_GL=1
if [[ "$OSTYPE" != "darwin"* ]]; then
#  sed -i 's/-lEGL -lGLESv2/-lGL/' Makefile
  LDLIBS="${LDLIBS} -lGLX"
fi
make prep > /dev/null 2>&1 

CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY" LDFLAGS="${LDFLAGS} -L${PREFIX} -L${CONDA_BUILD_SYSROOT}/lib64" prefix="${PREFIX}"  make -j ${CPU_COUNT}

mkdir -p $PREFIX/bin
cp gw $PREFIX/bin/gw
cp -n .gw.ini $PREFIX/bin/.gw.ini
chmod +x $PREFIX/bin/gw
chmod +rw $PREFIX/bin/.gw.ini

