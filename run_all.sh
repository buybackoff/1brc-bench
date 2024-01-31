#!/bin/bash

# Params: $0 <max_cores=4> <runs=5> <min_cores=4>

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
    min_cores="$3"
else
    min_cores=4
fi


# Get CPU model name
cpu_model=$(lscpu | awk -F: '/Model name/ {print $2}' | awk '{$1=$1};1' | head -n 1)
# Format CPU model for use in a path
machine_id=$(echo "$cpu_model" | tr -d '[:space:]' | tr -d '()')
machine_id+="_$(date +'%y%m%d_%H%M')"
export MACHINE_ID="$machine_id"

file="results/${machine_id}/cpu.txt"

mkdir -p "$(dirname "$file")"

{
    echo "=== lscpu ==="
    lscpu
    echo -e "\n\n"

    echo "=== lscpu -e ==="
    lscpu -e
    echo -e "\n\n"

    echo -e "=== lstopo  ==="
    lstopo
    echo -e "\n\n"

    echo -e "=== numactl --hardware ==="
    numactl --hardware
} > "$file"

# Deafult dataset
source run_ds.sh "1B" $max_cores $runs $min_cores

# 10K dataset
capped_double_min_cores=$(( (min_cores * 2) < max_cores ? (min_cores * 2) : max_cores ))
at_least_three_runs=$(( (runs / 4) < 3 ? 3 : (runs / 4) ))
source run_ds.sh "1B_10K" $max_cores $at_least_three_runs $capped_double_min_cores

echo "Finished running all benchmarks."