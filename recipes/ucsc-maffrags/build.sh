#!/bin/bash
mkdir -p "$PREFIX/bin"
export MACHTYPE=x86_64
export BINDIR=$(pwd)/bin
mkdir -p "$BINDIR"
(cd kent/src/lib && make)
(cd kent/src/htslib && make)
(cd kent/src/jkOwnLib && make)
(cd kent/src/hg/lib && make)
(cd kent/src/hg/ratStuff/mafFrags && make)
cp bin/mafFrags "$PREFIX/bin"
chmod +x "$PREFIX/bin/mafFrags"
