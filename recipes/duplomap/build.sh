#!/bin/bash -e

# taken from yacrd recipe, see: https://github.com/bioconda/bioconda-recipes/blob/2b02c3db6400499d910bc5f297d23cb20c9db4f8/recipes/yacrd/build.sh                            
if [ "$(uname)" == "Darwin" ]; then
    # apparently the HOME variable isn't set correctly, and circle ci output indicates the following as the home directory                                                   
    export HOME="/Users/distiller"
    export HOME=`pwd`
    echo "HOME is $HOME"
    # according to https://github.com/rust-lang/cargo/issues/2422#issuecomment-198458960 removing circle ci default configuration solves cargo trouble downloading crates    
    #git config --global --unset url.ssh://git@github.com.insteadOf
fi

export C_INCLUDE_PATH="$BUILD_PREFIX/include"
export LIBRARY_PATH="$BUILD_PREFIX/lib"
export CFLAGS="-L$BUILD_PREFIX/lib"
export RUSTFLAGS="-L$BUILD_PREFIX/lib -lz"
./build --install "$PREFIX"

