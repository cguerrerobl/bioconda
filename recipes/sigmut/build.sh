#!/bin/bash

set -e
# cp sigprofiler ${PREFIX}/bin/
# cp -r lib_repo ${PREFIX}/bin/
cp -r * ${PREFIX}/bin/
chmod u+rwx $PREFIX/bin/lib_repo/scripts/*
chmod u+rwx $PREFIX/bin/lib_repo/SigProfPlot/sigProfilerPlotting/*
chmod u+rwx $PREFIX/bin/*
