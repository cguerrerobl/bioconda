#!/bin/bash
export LIBRARY_PATH="${PREFIX}/lib"
export LD_LIBRARY_PATH="${PREFIX}/lib"
export LDFLAGS="-L${PREFIX}/lib"
export CPPFLAGS="-I${PREFIX}/include"
#explicititly set dictory for GHC download
export STACK_ROOT="${SRC_DIR}/s"
stack setup --local-bin-path ${SRC_DIR}/s
stack update
stack install --extra-include-dirs ${PREFIX}/include --local-bin-path ${PREFIX}/bin
#cleanup
rm -r .stack-work
rm -r "${PREFIX}/stack"
