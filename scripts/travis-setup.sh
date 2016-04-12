#!/bin/bash
set -e

wget https://github.com/thriqon/involucro/releases/download/v1.0.1/involucro -O involucro
chmod a+x involucro

if [[ $TRAVIS_OS_NAME = "linux" ]]
then
    docker pull bioconda/bioconda-builder
else

    # install conda
    curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    sudo bash Miniconda3-latest-MacOSX-x86_64.sh -b -p /anaconda
    sudo chown -R $USER /anaconda
    mkdir -p /anaconda/conda-bld/osx-64 # workaround for bug in current conda
    mkdir -p /anaconda/conda-bld/linux-64 # workaround for bug in current conda
    export PATH=/anaconda/bin:$PATH
    conda install -y --file scripts/requirements.txt
    conda index /anaconda/conda-bld/linux-64 /anaconda/conda-bld/osx-64

    # setup bioconda channel
    conda config --add channels bioconda
    conda config --add channels r
    conda config --add channels file://anaconda/conda-bld

    conda install -y toposort
fi
