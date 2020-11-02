#!/bin/bash
$PYTHON -m pip install --no-deps --ignore-installed .

# hmmscan in TEsorter need hmmpress first
# see here https://github.com/oushujun/EDTA/issues/121
pwd
ls -l
echo "Run hmmpress to get the DB ready to use"
cd TEsorter/database
echo "database folder before"
ls -l
for i in `ls *hmm | sed 's/.hmm//g'`; do hmmpress ${i}.hmm > ../${i}.hmm;done
echo "database folder after"
ls -l
