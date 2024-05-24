#!/bin/bash
# stop on error
set -exu -o pipefail

if [ ! -n "${PREFIX-}" -a "${PREFIX+defined}" != defined  ]; then
   echo "Prefix undefined, setting it to be path to script"
   PREFIX=$(dirname "$0")
   PREFIX=$(dirname "$PREFIX")

   export PATH=$PREFIX/bin:$PATH
fi

# download and run a small assembly, skip alignment of ONT on OSX to save time
rm -f ./hifi.fastq.gz ./ont.fastq.gz
curl -L https://obj.umiacs.umd.edu/sergek/shared/ecoli_hifi_lowcov.fastq.gz -o hifi.fastq.gz
curl -L https://obj.umiacs.umd.edu/sergek/shared/ecoli_ont_lowcov.fastq.gz -o ont.fastq.gz

touch empty.fasta

# now start tests
ONT="--nano ./ont.fastq.gz"
#if [ "$(uname)" == "Darwin" ]; then
#   ONT=""
#fi

verkko -d asm --hifi ./hifi.fastq.gz $ONT > run.out 2>&1

if [ -s asm/assembly.fasta ]; then
   head -n 2 asm/assembly.fasta > asm/tmp.fasta
   python $PREFIX/lib/verkko/scripts/circularize_ctgs.py -p 5 -f 0.01 -o asm/assembly_circular.fasta --min-ovl 1 asm/tmp.fasta
fi

if [ ! -s asm/assembly_circular.fasta ]; then
   echo "Error: verkko assembly test failed!"
   tail -n +1 `find asm -name *.err`
   exit 1
fi

# test HiC and trio but not on darwin cause it is much slower
if [ "$(uname)" == "Darwin" ]; then
   echo "Finished darwin verkko assembly test"
   exit 0
fi

verkko -d asm --hifi hifi.fastq.gz $ONT --hic1 empty.fasta --hic2 empty.fasta > run.out 2>&1

if [[ ! -s asm/assembly.unassigned.fasta || -s asm/assembly.haplotype1.fasta || -s asm/assembly.haplotype2.fasta ]]; then
   echo "Error: verkko hic assembly test failed!"
   tail -n +1 `find asm -name *.err`
   exit 1
fi

#now test trio
rm -rf asm/8-* asm/6-layoutContigs/ asm/7-consensus/ asm/assembly.* asm/6-rukki/
$PREFIX/lib/verkko/bin/meryl count compress k=21 memory=4 threads=8 output empty1.meryl hifi.fastq.gz
$PREFIX/lib/verkko/bin/meryl greater-than 100 empty1.meryl/ output empty2.meryl
verkko -d asm --hifi hifi.fastq.gz  $ONT --hap-kmers empty1.meryl empty2.meryl trio > run.out 2>&1

if [ ! -s asm/assembly.haplotype1.fasta ]; then
   echo "Error: verkko trio assembly test failed!"
   tail -n +1 `find asm -name *.err`
   exit 1
fi

echo "Finished verkko assembly test!"
exit 0
