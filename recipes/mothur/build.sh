### Configuring settings within mothur Makefile
# Enabling dependencies for full functionality
sed 's;\(USEBOOST ?\=\) no;\1 yes;' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
sed 's;\(USEHDF5 ?\=\) no;\1 yes;' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
sed 's;\(USEGSL ?\=\) no;\1 yes;' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
# Specifying dependency locations
sed 's;\(BOOST_LIBRARY_DIR ?\=\) \"\\\"Enter_your_boost_library_path_here\\\"\";\1 \"\\\"'"${PREFIX}"'\/lib\\\"\";' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
sed 's;\(BOOST_INCLUDE_DIR ?\=\) \"\\\"Enter_your_boost_include_path_here\\\"\";\1 \"\\\"'"${PREFIX}"'\/include/boost\\\"\";' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
sed 's;\(HDF5_LIBRARY_DIR ?\=\) \"\\\"Enter_your_HDF5_library_path_here\\\"\";\1 \"\\\"'"${PREFIX}"'\/lib\\\"\";' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
sed 's;\(HDF5_INCLUDE_DIR ?\=\) \"\\\"Enter_your_HDF5_include_path_here\\\"\";\1 \"\\\"'"${PREFIX}"'\/include\\\"\";' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
sed 's;\(GSL_LIBRARY_DIR ?\=\) \"\\\"Enter_your_GSL_library_path_here\\\"\";\1 \"\\\"'"${PREFIX}"'\/lib\\\"\";' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
sed 's;\(GSL_INCLUDE_DIR ?\=\) \"\\\"Enter_your_GSL_include_path_here\\\"\";\1 \"\\\"'"${PREFIX}"'\/include/gsl\\\"\";' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
# Fixing link errors for HDF5 libraries by replacing dynamic libraries with static libraries
sed 's;\(LDFLAGS += -L ${HDF5_LIBRARY_DIR}\) -lhdf5 -lhdf5_cpp;\1;' Makefile > Makefile.tmp && mv Makefile.tmp Makefile
sed '/^LDFLAGS += -L ${HDF5_LIBRARY_DIR}$/r'<(
	echo ""
    echo "LIBS += \${HDF5_LIBRARY_DIR}/libhdf5_hl_cpp.a"
    echo "LIBS += \${HDF5_LIBRARY_DIR}/libhdf5_cpp.a"
    echo "LIBS += \${HDF5_LIBRARY_DIR}/libhdf5_hl.a"
    echo "LIBS += \${HDF5_LIBRARY_DIR}/libhdf5.a"
    echo ""
) Makefile > Makefile.tmp && mv Makefile.tmp Makefile


### Reconfiguring compiler for uchime Makefile
sed 's/g++/$CXX/g' source/uchime_src/mk > source/uchime_src/mk.tmp && mv source/uchime_src/mk.tmp source/uchime_src/mk
# Making overwritten file executable
chmod +x source/uchime_src/mk


### Cleaning before compiling (just in case)
make clean


### Compiling programs
make


### Organizing bin
# Copy mothur and uchime executables to bin
cp {mothur,uchime} "${PREFIX}"/bin/
# Linking BLAST binaries to default location for mothur
mkdir -pv "${PREFIX}"/bin/blast/bin/
ln -s "${PREFIX}"/bin/{blastall,formatdb,megablast} "${PREFIX}"/bin/blast/bin/