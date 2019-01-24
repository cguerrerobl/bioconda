#!/bin/bash

# Make m4 accessible to bison
# https://github.com/conda-forge/bison-feedstock/issues/7#issuecomment-431602144
export M4=m4

if [ "$(uname)" == Darwin ] ; then
    CXXFLAGS="$CXXFLAGS -fopenmp"
fi

make  

mkdir -p $PREFIX/bin

cp bin/epa-ng $PREFIX/bin

