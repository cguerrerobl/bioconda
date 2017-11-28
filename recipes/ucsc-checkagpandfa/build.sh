#!/bin/bash
mkdir -p "$PREFIX/bin"
if [ "$(uname)" == "Darwin" ]; then
    cp checkAgpAndFa "$PREFIX/bin"
else
    export MACHTYPE=x86_64
    export BINDIR=$(pwd)/bin
    mkdir -p "$BINDIR"
    (cd kent/src/lib && make)
    (cd kent/src/htslib && make)
    (cd kent/src/jkOwnLib && make)
    (cd kent/src/hg/lib && make)
    (cd kent/src/hg/gigAssembler/checkAgpAndFa && make)
    cp bin/checkAgpAndFa "$PREFIX/bin"
fi
chmod +x "$PREFIX/bin/checkAgpAndFa"
