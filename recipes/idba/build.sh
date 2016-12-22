aclocal
autoconf
automake --add-missing

export DYLD_FALLBACK_LIBRARY_PATH="${PREFIX}/lib"
export LD_LIBRARY_PATH="${PREFIX}/lib"
./configure --prefix=$PREFIX
make

gawk -i inplace '/usr\/bin\//{ gsub(/python/, "env python");}1' script/*.py

mkdir -p ${PREFIX}/bin

cp bin/* ${PREFIX}/bin
cp script/*py ${PREFIX}/bin
cp script/validate* ${PREFIX}/bin
