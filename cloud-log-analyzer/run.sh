#!/usr/bin/env bash

set -e

if [[ ! -f ./analyzer ]]; then
  make
fi

cat data/logs_A.txt | ./analyzer
