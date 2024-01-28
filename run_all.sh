#!/bin/bash

# Params: $0 <max_cores=4> <runs=5> <machine_id=CPUModel>

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

if [ -n "$3" ]; then
    machine_id="$3"
else
    # Get CPU model name
    cpu_model=$(lscpu | awk -F: '/Model name/ {print $2}' | awk '{$1=$1};1' | head -n 1)
    # Format CPU model for use in a path
    machine_id=$(echo "$cpu_model" | tr -d '[:space:]' | tr -d '()')
fi

export MACHINE_ID="$machine_id"


source run_ds.sh "1B" $max_cores $runs

source run_ds.sh "1B_10K" $max_cores $runs


# # Get current date and time formatted as YYMMDDHHmmss
# timestamp=$(date "+%y%m%d%H%M%S")

# # Create a new branch named results with the timestamp
# git checkout -b results_$timestamp

# git add .
# git commit -m "Results at $timestamp"

# # Switch back to the main branch
# git checkout main
