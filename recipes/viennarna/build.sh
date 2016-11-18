#!/bin/sh
# ViennaRNA does not support Python 3 for MacOSX.

## choose extra configure options depending on the operating system
## (mac or linux)
##
if [ `uname` == Darwin ] ; then
    extra_config_options="--disable-openmp 
                          --enable-universal-binary
                          --without-python3
                          LDFLAGS=-Wl,-headerpad_max_install_names"
else ## linux
    if [ $PY3K -eq 1 ] ; then
        extra_config_options="--with-python3 --without-python"
    else
        extra_config_options="--with-python --without-python3"
    fi
fi

./configure --prefix=$PREFIX \
            --without-perl \
            --with-kinwalker \
            --disable-lto \
            --without-doc \
            ${extra_config_options} && \
make -j${CPU_COUNT} && \
make install
