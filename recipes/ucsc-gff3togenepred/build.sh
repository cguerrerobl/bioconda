#!/bin/bash
mkdir -p "$PREFIX/bin"
export MACHTYPE=$(uname -m)
export BINDIR=$(pwd)/bin
export L="${LDFLAGS}"
mkdir -p "$BINDIR"
(cd kent/src/lib && make -j ${CPU_COUNT})
(cd kent/src/htslib && make -j ${CPU_COUNT})
(cd kent/src/jkOwnLib && make -j ${CPU_COUNT})
(cd kent/src/hg/lib && make -j ${CPU_COUNT})
(cd kent/src/hg/utils/gff3ToGenePred && make -j ${CPU_COUNT})
cp bin/gff3ToGenePred "$PREFIX/bin"
chmod +x "$PREFIX/bin/gff3ToGenePred"
