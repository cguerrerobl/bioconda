#!/bin/bash
set -eu -o pipefail

echo $PREFIX
mkdir -p $PREFIX/bin
make
co divvier $PREFIX/bin
