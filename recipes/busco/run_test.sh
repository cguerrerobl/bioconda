#!/bin/bash

set -euo pipefail

cat > ex.fasta <<EOF
>1
AATTCC
EOF


busco -i ex.fasta -o out -l proteobacteria_odb10 -m geno
