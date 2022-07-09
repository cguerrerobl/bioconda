#!/bin/bash
set -eu -o pipefail

if [ `uname` == Darwin ]; then
    sed -i '' 's=/usr/bin/make=/usr/bin/env make=' ${RECIPE_DIR}/bin/goldrush
else
    sed -i 's=/usr/bin/make=/usr/bin/env make=' ${RECIPE_DIR}/bin/goldrush
fi


mkdir -p ${PREFIX}
meson --prefix ${PREFIX} build
cd build
ninja
ninja install
