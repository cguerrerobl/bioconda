#!/bin/bash
install -d "${PREFIX}/bin"
install probeit.py "${PREFIX}/bin/"
# setcover
cd setcover
make CXXFLAGS="${CXXFLAGS} -I. -O3 -std=c++14" -j $CPU_COUNT
install setcover "${PREFIX}/bin/"
