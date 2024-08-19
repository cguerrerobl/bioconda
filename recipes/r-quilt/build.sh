#!/bin/bash

set -xe

export LC_ALL=C.UTF-8
export LANG=C.UTF-8

cp -rf $SRC_DIR/QUILT.R $PREFIX/bin/
cd $SRC_DIR/QUILT

${R} CMD INSTALL --build --install-tests .

