export CPATH=${PREFIX}/include
export INCLUDES="-I$PREFIX/include -I$PREFIX/include/ncurses"
export LDFLAGS="-L$PREFIX/lib -ltinfo"
export LIBRARY_PATH=${PREFIX}/lib
export CPPFLAGS="-I$PREFIX/include"
#apt-get install gcc
#echo $CC $CXX
CC=gcc
make CC=$CC
cp msisensor-pro $PREFIX/bin
