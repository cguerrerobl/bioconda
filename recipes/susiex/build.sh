#!/bin/bash

mkdir -p $PREFIX/bin

cd src
make
cp ../bin/SuSiEx $PREFIX/bin/SuSiEx
