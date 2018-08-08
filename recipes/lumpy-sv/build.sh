#!/bin/bash
set -eu -o pipefail

outdir=$PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM
mkdir -p $outdir
mkdir -p $outdir/scripts
mkdir -p $outdir/scripts/bamkit
mkdir -p $PREFIX/bin

make \
    CC="${CC}" \
    CXX="${CXX}" \
    CPPFLAGS="${CPPFLAGS}" \
    CFLAGS="${CFLAGS}" \
    CXXFLAGS="${CXXFLAGS}" \
    LDFLAGS="${LDFLAGS}" \
    ZLIB_PATH="${PREFIX/lib}"

cp bin/lumpy $PREFIX/bin
cp bin/lumpy_filter $PREFIX/bin
cp scripts/lumpyexpress $PREFIX/bin

cp scripts/cnvanator_to_bedpes.py $PREFIX/bin


cp scripts/*.py $outdir/scripts
cp scripts/*.sh $outdir/scripts
cp scripts/*.pl $outdir/scripts
cp scripts/extractSplitReads* $outdir/scripts
cp scripts/vcf* $outdir/scripts
cp scripts/bamkit/* $outdir/scripts/bamkit

cp $RECIPE_DIR/lumpyexpress.config $outdir
ln -s $outdir/lumpyexpress.config $PREFIX/bin
ln -s $outdir/extractSplitReads_BwaMem /$PREFIX/bin

chmod +x $PREFIX/bin/extractSplitReads_BwaMem
