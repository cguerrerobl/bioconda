#!/bin/bash

make -j${CPU_COUNT}
make install PREFIX=$PREFIX/bin/