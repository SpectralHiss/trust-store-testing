#!/bin/bash

for distribution in "ubuntu" ; do
  ./test/bats/bin/bats $distribution.bats
done