#!/bin/bash

set -x

mkdir -p $PREFIX/bin/
# build and install binary tools
cd src/simulator
make
cp simulator $PREFIX/bin/

cd ../poa-graph
make poa
cp poa $PREFIX/bin/

cd ../utils
make
cp fq2fa $PREFIX/bin/

cd ../split
make
cp masterSplitter $PREFIX/bin/
cp Donatello $PREFIX/bin/
cd ../..

# setup and install python script
mkdir -p $PREFIX/share/elector/
cp src/poa-graph/blosum80.mat $PREFIX/share/elector/

sed -i "s#os.path.dirname(os.path.realpath(__file__))+\"/../bin/\"#${PREFIX}/bin/#" elector/utils.py
sed -i "s#os.path.dirname(os.path.realpath(__file__))+\"/../src/poa-graph/\"#${PREFIX}/share/elector/#" elector/utils.py

$PYTHON setup.py install
