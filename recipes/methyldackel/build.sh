#!/bin/bash
cd htslib && make CC=$CC OPTS="-I$PREFIX/include -L$PREFIX/lib -Wall -g -O3 -pthread" && cd ..
make CC=$CC OPTS="-I$PREFIX/include -L$PREFIX/lib -Wall -g -O3 -pthread"
make install prefix=$PREFIX/bin
