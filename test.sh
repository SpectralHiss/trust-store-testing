#!/bin/bash

for distribution in ubuntu fedora "ubi_8" ; do
  mkdir -p results/$distribution
  ./test/bats/bin/bats -F tap "$distribution.bats" > "./results/${distribution}/result.tap"
  source "${distribution}.bats" > /dev/null 2>&1 
  declare -f update_trust_store > "./results/${distribution}/update_trust_store_function" 
  ./bin/container-diff diff --type=file --json \
   "daemon://${distribution}:pre-trust" "daemon://${distribution}:post-trust" \
    > "./results/${distribution}/container-diff.json"
done