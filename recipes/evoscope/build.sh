#!/bin/bash
make CC="$CC"
mkdir -p ${PREFIX}/bin
cp epics epocs epocs_mcmc ${PREFIX}/bin
