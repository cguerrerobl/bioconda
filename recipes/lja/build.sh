set -e

echo "Building LJA..."

cmake .

make

cp -r $SRC_DIR/bin/* $PREFIX/bin/

cd $PREFIX/bin

chmod +x ./*