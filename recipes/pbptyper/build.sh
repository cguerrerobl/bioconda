#! /bin/bash

# Set up defaults
PBPTYPER_SHARE="share/${PKG_NAME}-${PKG_VERSION}"
mkdir -p ${PREFIX}/${PBPTYPER_SHARE}
mkdir -p ${PREFIX}/bin

# Make Bioconda compatible
cp db/*.faa ${PREFIX}/${PBPTYPER_SHARE}/
cp db/GCF_000006885.fna.gz ${PREFIX}/${PBPTYPER_SHARE}/
sed "s=\"bin\", \"db\"=\"bin\", \"$PBPTYPER_SHARE\"=" bin/pbptyper > ${PREFIX}/bin/pbptyper
chmod 755 ${PREFIX}/bin/pbptyper
