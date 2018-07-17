#!/usr/bin/env bash
# Build file is copied from VarScan
# https://github.com/bioconda/bioconda-recipes/blob/master/recipes/varscan/build.sh
# This file was automatically generated by the sbt-bioconda plugin.

outdir=$PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM
mkdir -p $outdir
mkdir -p $PREFIX/bin
cp vcffilter-assembly-0.2.jar $outdir/vcffilter-assembly-0.2.jar
cp $RECIPE_DIR/biopet-vcffilter.py $outdir/biopet-vcffilter
ln -s $outdir/biopet-vcffilter $PREFIX/bin

