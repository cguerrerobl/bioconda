#!/bin/bash

# Make sure this goes in site
cpanm --installdeps .

perl Makefile.PL INSTALLDIRS=site
make
make test
make install
