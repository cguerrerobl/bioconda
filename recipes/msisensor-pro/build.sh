export CPATH=${PREFIX}/include
export INCLUDES="-I$PREFIX/include -I$PREFIX/include/ncurses"
export LDFLAGS="-L$PREFIX/lib -ltinfo -lz"
export LIBRARY_PATH=${PREFIX}/lib
export CPPFLAGS="-I$PREFIX/include"
#apt-get install gcc
#echo $CC $CXX

make CC=$GCC
cp msisensor-pro $PREFIX/bin
