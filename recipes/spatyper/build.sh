#! /bin/bash

$PYTHON -m pip install . --ignore-installed --no-deps -vv

# Add default databases
printf '>1\nAAAA\n' > test.fasta
$PREFIX/bin/spaTyper -f test.fasta
rm test.fasta
