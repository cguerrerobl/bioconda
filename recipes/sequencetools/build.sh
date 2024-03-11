#!/bin/bash
# export LIBRARY_PATH="${PREFIX}/lib:/usr/lib:/usr/lib64"
# export LD_LIBRARY_PATH="${PREFIX}/lib:/usr/lib:/usr/lib64"
# export LDFLAGS="-L${PREFIX}/lib"
# export CPPFLAGS="-I${PREFIX}/include"

wget https://downloads.haskell.org/~ghc/9.4.7/ghc-9.4.7-x86_64-centos7-linux.tar.xz
tar xf ghc-9.4.7-x86_64-centos7-linux.tar.xz
export PATH="$PATH:$PWD/ghc-9.4.7-x86_64-unknown-linux/bin"

echo $PATH
which ghc

stack install --local-bin-path ${PREFIX}/bin --system-ghc --no-install-ghc
# cleanup
# rm -r .stack-work

