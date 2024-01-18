#!/bin/bash

for distribution in ubuntu fedora "rhel_7" ; do
  ./test/bats/bin/bats $distribution.bats
done