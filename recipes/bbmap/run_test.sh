#!/bin/bash

set -e -o pipefail

# adapted from recipes/blast/run_test.sh

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" 0 INT QUIT ABRT PIPE TERM

cp test*.fa $TMPDIR
cd $TMPDIR

bbmap.sh in=test.fa ref=testdatabase.fa out=result.sam jni=t nodisk
diff <(tail -2 result.sam) testexpected.sam

