#! /bin/bash

set -ex

BASE_DIR=$(dirname "$0")
SCRIPTS_DIR="${BASE_DIR}/scripts"
TEST_DATA_DIR="${BASE_DIR}/TestData"

# Check for scripts directory
if [ ! -d "${SCRIPTS_DIR}" ]; then
    echo "The scripts directory is missing. It should be placed in the same directory as the PoolSNP.sh script."
    exit 1
fi

# Check for TestData directory
if [ ! -d "${TEST_DATA_DIR}" ]; then
    echo "The TestData directory is missing. It should be placed in the same directory as the PoolSNP.sh script."
    exit 1
fi

# Create directories
mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/bin/scripts
mkdir -p ${PREFIX}/share/PoolSNP

# Copy PoolSNP.sh and make it executable
cp PoolSNP.sh ${PREFIX}/bin
chmod +x ${PREFIX}/bin/PoolSNP.sh

# Copy python scripts and make them executable
for script in $SCRIPTS_DIR/*; do
    cp $script ${PREFIX}/bin/$(basename $script)
    cp $script ${PREFIX}/bin/scripts/
    chmod +x ${PREFIX}/bin/$(basename $script)
    chmod +x ${PREFIX}/bin/scripts/$(basename $script)
done

# Copy the test data to the share directory
cp -r ${TEST_DATA_DIR} ${PREFIX}/share/PoolSNP/TestData