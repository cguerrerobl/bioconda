#!/bin/bash

# compile library
mkdir -p $PREFIX/lib/R/library/e1071FuzzVec
R CMD INSTALL --build e1071FuzzVec_Installation
cp -r e1071FuzzVec_Installation/* $PREFIX/lib/R/library/e1071FuzzVec/

# move all files to outdir and link into it by bin executor
mkdir -p $PREFIX/bin
mkdir -p $PREFIX/share/vsclust
# substituting paths for testing 
cp run_app.sh run_vsclust_app.sh
echo "before sed"
tail -n +2 run_vsclust_app.sh t.sh
echo '#!/usr/bin/env Rscript' > tt
echo 'setwd("$CONDA_PREFIX/share/vsclust")' > tt
cat tt t > run_vsclust_app.sh
#sed -i'.orig' '1a\ setwd("$CONDA_PREFIX/share/vsclust")' run_vsclust_app.sh
#sed --posix -i'.orig' "1 a setwd(\"\$CONDA_PREFIX/share/vsclust\")" run_vsclust_app.sh
sed -i'.orig' "s=FcmClustPEst.R=../share/vsclust/FcmClustPEst.R=" runVSClust.R
sed -i'.orig' "s=mfuzz.plotpdf.R=../share/vsclust/mfuzz.plotpdf.R=" runVSClust.R
sed -i'.orig' "s=HelperFuncs.R=../share/vsclust/HelperFuncs.R=" runVSClust.R
echo "after sed"
cp *.R $PREFIX/share/vsclust/
cp ProtExample.csv $PREFIX/share/vsclust/
cp vsclust.yml $PREFIX/share/vsclust/
cp runVSClust.R $PREFIX/bin
cp run_vsclust_app.sh $PREFIX/bin
echo "before chmod"
chmod a+x $PREFIX/bin/runVSClust.R
chmod a+x $PREFIX/bin/run_vsclust_app.sh
