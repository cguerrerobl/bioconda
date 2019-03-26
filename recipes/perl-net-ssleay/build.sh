#!/bin/bash

export OPENSSL_PREFIX=${PREFIX}

export PERL_MM_USE_DEFAULT=1

if [ `uname -s` == "Darwin" ]; then
    # Force use of conda's OpenSSL instead of the system one
    export DYLD_FALLBACK_LIBRARY_PATH="${PREFIX}/lib"
else
    # Force use of conda's OpenSSL instead of the system one
    export LD_LIBRARY_PATH="${PREFIX}/lib"
fi

# A few things need to be changed.
# Config.pm holds the compiler in cc
# ./lib/5.26.2/x86_64-linux-thread-multi/Config.pm
#     cc => '${CC}'
# Config_heavy.pl holds the cflags in ccflags
# ./lib/5.26.2/x86_64-linux-thread-multi/Config_heavy.pl
#     ccflags ='${CFLAGS}'
dname=`find $PREFIX/lib -name Config_heavy.pl -print | xargs dirname`
sed -i.bak "s|^    cc => .*$|    cc => '${CC}',|" ${dname}/Config.pm
sed -i.bak "s|^    ccflags =.*$|    ccflags ='${CFLAGS}'|" ${dname}/Config_heavy.pl

perl -V

# If it has Build.PL use that, otherwise use Makefile.PL
if [ -f Build.PL ]; then
    perl Build.PL
    ./Build
    ./Build test
    # Make sure this goes in site
    ./Build install --installdirs site
elif [ -f Makefile.PL ]; then
    # Make sure this goes in site
    perl Makefile.PL INSTALLDIRS=site
    make
    make test
    make install
else
    echo 'Unable to find Build.PL or Makefile.PL. You need to modify build.sh.'
    exit 1
fi

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
