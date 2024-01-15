#!/bin/bash

for distribution in `ls "distributions"` ; do
  ./distributions/${distribution}/setup.sh
done