export ROOT=$PREFIX
./configure --prefix=$PREFIX/ --build=$PREFIX/share/ncbi --with-ngs-sdk-prefix=$PREFIX --with-xml2-prefix=$PREFIX 
make
make install
