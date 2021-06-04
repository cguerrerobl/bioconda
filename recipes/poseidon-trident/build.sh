#!/usr/bin/env bash

curl -sSL https://get.haskellstack.org/ | sh

unzip v*.zip
cd poseidon-hs*
stack install poseidon-hs:trident
mkdir -p bin
cp ~/.local/bin/trident bin/
