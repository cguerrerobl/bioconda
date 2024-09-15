#!/usr/bin/bash
set -e

# USE_GL=1 make prep > /dev/null 2>&1 


# Detect architecture and OS
ARCH=$(uname -m)
OS=$(uname -s)

# Use pre-built binary
if [ "$OS" = "Darwin" ]; then
    SYSROOT_FLAGS=""
    CPPFLAGS="${CPPFLAGS}"
    LDFLAGS="${LDFLAGS} -L${PREFIX}"
    echo "Downloading pre-built skia"
    USE_GL=1 make prep > /dev/null 2>&1 

    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY" \
    CPPFLAGS="${CPPFLAGS}" \
    LDFLAGS="${LDFLAGS}" \
    prefix="${PREFIX}" \
        make -j ${CPU_COUNT}
    
    mkdir -p $PREFIX/bin
    cp gw $PREFIX/bin/gw
    cp -n .gw.ini $PREFIX/bin/.gw.ini
    chmod +x $PREFIX/bin/gw
    exit 0
fi

# Linux build. Build skia from scratch
ls

NAME=${PWD}/lib/skia
echo "Skia out folder is: $NAME"

cd ./lib
mkdir -p skia
mkdir -p build_skia && cd build_skia


# Set default flags
EXTRA_CFLAGS=""
EXTRA_LDFLAGS=""
INCLUDE="\"-I$PREFIX/include\", \"-I$PREFIX/include/freetype2\", \"-I$PREFIX/include/libpng16\""
LIB="\"-L${PREFIX}/lib\""

# Architecture-specific flags
if [ "$ARCH" = "x86_64" ]; then
    # Old glibc so cant use depot_tools
    EXTRA_CFLAGS="extra_cflags=[\"-mavx2\", \"-mfma\", \"-mavx512f\", \"-mavx512dq\", \"-msse4.2\", \"-mpopcnt\", \"-frtti\", $INCLUDE]"
    EXTRA_LDFLAGS="extra_ldflags=[\"-mavx2\", \"-mfma\", \"-mavx512f\", \"-mavx512dq\", $LIB]"

    #echo "Cloning skia"
    #git clone https://skia.googlesource.com/skia.git
    
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then

    #FREETYPE_DIR=$(find $CONDA_PREFIX -name "freetype2" -type d | grep "include")
    #FONTCONFIG_DIR=$(find $CONDA_PREFIX -name "fontconfig" -type d | grep "include")
    #echo "Freetype include: $FREETYPE_DIR"
    #echo "Fontconfig include: $FONTCONFIG_DIR"

    #f_include=$(pkg-config --cflags fontconfig freetype2)
    #f_ldflags=$(pkg-config --libs fontconfig freetype2)
    
    #echo "Extra include: $f_include"
    #echo "Extra ldflags: $f_ldflags"

    EXTRA_CFLAGS="extra_cflags=[\"-march=armv8-a+crc+crypto\", \"-frtti\", $INCLUDE]"
    EXTRA_LDFLAGS="extra_ldflags=[\"-march=armv8-a+crc+crypto\", $LIB]"
    #EXTRA_CFLAGS='extra_cflags=["-march=armv8-a+crc+crypto", "-frtti"]'
    #EXTRA_LDFLAGS='extra_ldflags=["-march=armv8-a+crc+crypto"]'
    #echo "Fetching skia using depot_tools"
    #git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
    #export PATH="${PWD}/depot_tools:${PATH}"
    #depot_tools/fetch skia

fi

EXTRA_ARGS="skia_use_egl=true skia_use_gl=true skia_use_x11=true"

echo "Architecture: $ARCH"
echo "Operating System: $OS"
echo "Extra C flags: $EXTRA_CFLAGS"
echo "Extra LD flags: $EXTRA_LDFLAGS"
echo "Extra arguments: $EXTRA_ARGS"
export PATH="${CONDA_PREFIX}/bin:$PATH"

# Check system build tools available
echo "Using gn from: $(which gn)"
echo "Using ninja from: $(which ninja)"

echo "Cloning skia"
git clone https://skia.googlesource.com/skia.git

cd skia
VERSION=m93
git checkout origin/chrome/${VERSION}
echo "Checked out Skia version: ${VERSION}"
echo "Using python3: " $(which python3)

# Patch gn to map aarch64 to arm64
sed -i.bak 's/cpu = {/cpu = {"aarch64": "arm64", /g' bin/fetch-gn

python3 tools/git-sync-deps

REL=Release

echo "STARTING SKIA BUILD"
which gn
which ninja

# Generate build files
gn gen out/${REL} --args="is_official_build=true \
    skia_use_system_icu=true \
    skia_use_system_zlib=true \
    skia_use_system_expat=true \
    skia_use_system_libjpeg_turbo=true \
    skia_use_system_libpng=true \
    skia_use_system_libwebp=false \
    skia_use_system_harfbuzz=false \
    skia_pdf_subset_harfbuzz=true \
    skia_enable_skottie=false \
    skia_use_dng_sdk=false \
    target_cpu=\"${ARCH}\" \
    ${EXTRA_CFLAGS} \
    ${EXTRA_LDFLAGS} \
    cc=\"clang\" \
    cxx=\"clang++\" \
    ${EXTRA_ARGS}"
gn args out/${REL} --list
ninja -C out/${REL}

echo "------------SKIA BUILD FINISHED---------------"
pwd
ls

mkdir -p ${NAME}/out/${REL}
mkdir -p ${NAME}/third_party/externals

cp -rf out/${REL}/* ${NAME}/out/${REL}
cp -rf include ${NAME}
cp -rf modules ${NAME}
cp -rf src ${NAME}

#libs=( "freetype" "harfbuzz" "icu" "libpng" "zlib" )

#for l in "${libs[@]}"
#do
#  echo $l
#  mkdir -p ${NAME}/third_party/externals/${l}
#  cp -rf third_party/externals/${l}/src ${NAME}/third_party/externals/${l}
#  cp -rf third_party/externals/${l}/include ${NAME}/third_party/externals/${l}
#  cp -rf third_party/externals/${l}/source ${NAME}/third_party/externals/${l}
#  cp third_party/externals/${l}/*.h ${NAME}/third_party/externals/${l}
#done

#cp -rf third_party/icu ${NAME}/third_party

# clean up
cd ${NAME}
#rm -rf modules/skottie/tests
#rm -rf out/${REL}/obj
#rm -rf out/${REL}/gen
#rm -rf out/${REL}/gcc_like_host
#find . -name "*.clang-format" -type f -delete
#find . -name "*.gitignore" -type f -delete
#find . -name "*.md" -type f -delete
#find . -name "*.gn" -type f -delete
#find . -name "*.ninja" -type f -delete
#find . -name "*.cpp" -type f -delete
#find . -name "*.ninja.d" -type f -delete
#find . -name "*BUILD*" -type f -delete
#find . -name "*.txt" -type f -delete
#find . -name "test*" -type d -exec rm -rv {} +
cd ../

pwd
rm -rf build_skia
cd ../
echo "----------DONE PREPARING SKIA-------------"
pwd

#if [[ "$OSTYPE" != "darwin"* ]]; then
#  sed -i 's/-lEGL -lGLESv2/-lEGL -lGLESv2 -lGL -lGLX/' Makefile
  #sed -i 's/GLFW_EGL_CONTEXT_API/GLFW_NATIVE_CONTEXT_API/' src/plot_manager.cpp
#fi


SYSROOT_FLAGS="--sysroot=${BUILD_PREFIX}/${HOST}/sysroot"
CPPFLAGS="${CPPFLAGS} -I${BUILD_PREFIX}/${HOST}/sysroot/usr/include ${SYSROOT_FLAGS}"
LDFLAGS="${LDFLAGS} -L${PREFIX}/lib -L${BUILD_PREFIX}/${HOST}/sysroot/usr/lib -L${BUILD_PREFIX}/${HOST}/sysroot/usr/lib64 ${SYSROOT_FLAGS}"

CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY" \
CPPFLAGS="${CPPFLAGS}" \
LDFLAGS="${LDFLAGS}" \
prefix="${PREFIX}" \
    make -j ${CPU_COUNT}

mkdir -p $PREFIX/bin
cp gw $PREFIX/bin/gw
cp -n .gw.ini $PREFIX/bin/.gw.ini
chmod +x $PREFIX/bin/gw
chmod +rw $PREFIX/bin/.gw.ini
