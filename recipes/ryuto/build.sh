#!/bin/bash

export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"
export LDFLAGS="$LDFLAGS -L$PREFIX/lib"

#cd $RECIPE_DIR

#cd omp_test

#./reset_autogen.sh
#./configure
#make

#./configure CFLAGS="-fopenmp" CXXFLAGS='-fopenmp'
#make

#./configure --enable-mac
#make

#exit 0

# RESET AUTOMAKE just in case for RYUTO

./reset_autogen.sh

# Build static libraries. Sadly Lemon from Forge cannot be linked to CLP correctly. So this is a workaround for now.

echo "Recipe Dir"
echo $RECIPE_DIR
echo "Source Dir"
echo $SRC_DIR

cd $RECIPE_DIR

unzip clp_mod.zip
tar -xvf lemon_mod.tar.gz

cd clp_mod

echo "========================== CLP =========================="

./configure --enable-static --disable-shared --prefix=`pwd` --disable-bzlib --disable-zlib
make
make install



cd ../lemon_mod


echo "========================== LEMON =========================="

mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake" -DLEMON_DEFAULT_LP=CLP -DCOIN_ROOT_DIR=$RECIPE_DIR/clp_mod -DCMAKE_INSTALL_PREFIX=$RECIPE_DIR/lemon_mod  ..
echo "========================== cmake done"
make
echo "========================== make done"
make install 
echo "========================== make install done"

#echo "========================== CMAKE LOG =========================="
#cat CMakeFiles/CMakeOutput.log
#echo "========================== CMAKE ERR =========================="
#cat CMakeFiles/CMakeError.log
#echo "========================== CMAKE VAL =========================="
#cat CMakeCache.txt

# RUN RYUTO

cd $SRC_DIR
echo "========================== RYUTO =========================="
#if [ `uname` == Darwin ]; then
#    ./configure --prefix=$PREFIX --with-htslib="$PREFIX" --with-zlib="$PREFIX" --with-boost="$PREFIX" --with-clp=$RECIPE_DIR/clp_mod --with-staticcoin=$RECIPE_DIR/clp_mod --with-lemon=$RECIPE_DIR/lemon_mod CFLAGS="-fopenmp" CXXFLAGS='-fopenmp'
#else
./configure --prefix=$PREFIX --with-htslib="$PREFIX" --with-zlib="$PREFIX" --with-boost="$PREFIX" --with-clp=$RECIPE_DIR/clp_mod --with-staticcoin=$RECIPE_DIR/clp_mod --with-lemon=$RECIPE_DIR/lemon_mod
#fi

echo "========================== configure dowe"
make LIBS+=-lhts
echo "========================== make dowe"
make install
