#!/usr/bin/env bash

python3 setup.py install --single-version-externally-managed --record=record.txt

conda install -c ambermd ambertools 

mkdir -p $PREFIX/bin

chmod u+x $SP_DIR/biobb_analysis/gromacs/rms.py
cp $SP_DIR/biobb_analysis/gromacs/rms.py $PREFIX/bin/rms

chmod u+x $SP_DIR/biobb_analysis/gromacs/rms.py
cp $SP_DIR/biobb_analysis/gromacs/rms.py $PREFIX/bin/rms

chmod u+x $SP_DIR/biobb_analysis/ambertools/cpptraj.py
cp $SP_DIR/biobb_analysis/ambertools/cpptraj.py $PREFIX/bin/cpptraj
