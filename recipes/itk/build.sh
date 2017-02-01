mkdir build
cd build

export INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib"
export LD_LIBRARY_PATH="${PREFIX}/lib"
export LDFLAGS="-L${PREFIX}/lib"
export CPPFLAGS="-I${PREFIX}/include"


cmake \
    -D CMAKE_INSTALL_PREFIX=${PREFIX} \
    -D CMAKE_INSTALL_RPATH:STRING=${PREFIX}/lib \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D BUILD_SHARED_LIBS=ON \
    -D BUILD_EXAMPLES:BOOL=OFF \
    -D BUILD_TESTING:BOOL=OFF \
    -D ITK_LEGACY_REMOVE:BOOL=OFF \
    -D ITK_LEGACY_SILENT:BOOL=OFF \
    -D ITKV3_COMPATIBILITY:BOOL=ON \
    -D ITK_USE_SYSTEM_JPEG:BOOL=ON \
    -D ITK_USE_SYSTEM_PNG:BOOL=ON \
    -D ITK_USE_SYSTEM_TIFF:BOOL=ON \
    -D ITK_USE_SYSTEM_ZLIB:BOOL=ON \
    ..

make -j$CPU_COUNT > /dev/null
make install
