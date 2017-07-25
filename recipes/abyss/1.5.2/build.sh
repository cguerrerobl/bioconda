#!/bin/bash

mkdir -p $PREFIX/bin

if [[ $(uname) == "Darwin" ]]; then
	echo "Configuring for OSX..."
  	export CPPFLAGS="-I$PREFIX/include --stdlib=libstdc++"
else
	echo "Configuring for Linux..."
  	export CPPFLAGS="-I$PREFIX/include" 
fi

./configure --prefix=$PREFIX --with-boost=$PREFIX/include --enable-maxk=96
make AM_CXXFLAGS=-Wall
make install

