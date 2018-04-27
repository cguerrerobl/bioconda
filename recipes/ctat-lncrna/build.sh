#!/bin/bash
# ctat_lncrna_DIR_NAME="$PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM"
# The above is an error. The following is correct.
ctat_lncrna_DIR_NAME="$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM"
ctat_lncrna_INSTALL_PATH="$PREFIX/share/$ctat_lncrna_DIR_NAME"
# Make the install directory and move the ctat_lncrna files to that location.
mkdir -p $PREFIX/bin
mkdir -p $ctat_lncrna_INSTALL_PATH
#cp -R $SRC_DIR/* $ctat_lncrna_INSTALL_PATH
# The copy of everything does not work, because the build process puts a conda_build script
# into the same directory. That file has hard coded paths in it which are not able to be
# corrected, so the build fails.
cp -R $SRC_DIR/LICENSE.txt $SRC_DIR/lncrna $SRC_DIR/SciEDPipeR $ctat_lncrna_INSTALL_PATH
chmod a+x $ctat_lncrna_INSTALL_PATH/lncrna
cd $PREFIX/bin
# The following shell script is built to invoke lncrna_discovery.py using its full
# install path rather than creating a symlink to it from $PREFIX/bin.
# That way the import for sciedpiper in lncrna.py will find it, 
# because the program is invoked from its actual location.
echo "#!/bin/bash" > $PREFIX/bin/lncrna
echo "$ctat_lncrna_INSTALL_PATH/lncrna \$@" >> $PREFIX/bin/lncrna
chmod a+x $PREFIX/bin/lncrna
