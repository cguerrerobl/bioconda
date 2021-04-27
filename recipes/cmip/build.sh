#!/usr/bin/env bash

mkdir -p $PREFIX/bin

# Change to src directory
cd dist/src

# Compile using make
make \
    F77="${FC}" \
    CPP="${CXX}"

# Copy executable to environment bin dir included in the path
chmod u+x cmip watden titration
cp cmip watden titration $PREFIX/bin/

cd ../src90

# Compile using make
make \
    F77="${FC}" \
    CPP="${CXX}"

# Copy executable to environment bin dir included in the path
chmod u+x canal avgEpsGrid surfnet2binaryGrid grd2cube getPatch
cp canal avgEpsGrid surfnet2binaryGrid grd2cube getPatch $PREFIX/bin/

cd ..
mkdir -p $PREFIX/share/cmip
cp -r dat tests wrappers scripts $PREFIX/share/cmip/
