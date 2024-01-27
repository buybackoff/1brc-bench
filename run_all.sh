#!/bin/bash

# Params: $0 <max_cores=4> <runs=5>

if [ -n "$1" ]; then
    max_cores="$1"
else
    max_cores=4
fi

if [ -n "$2" ]; then
    runs="$2"
else
    runs=5
fi

source run_ds.sh "1B" $max_cores $runs

source run_ds.sh "1B_10K" $max_cores $runs

