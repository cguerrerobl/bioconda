export HAS_GTEST=0

# fix build number in config
sed -i.bak 's/VERSION_STRING.*/VERSION_STRING="${PKG_VERSION}"/' config.mk

CXXFLAGS+="-std=c++17 -Wno-unused-result"

make CXX=$CXX CC=$CC
mkdir -p "${PREFIX}/bin"
mv build/release/dragen-os ${PREFIX}/bin/
