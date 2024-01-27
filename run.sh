#!/bin/bash

set -eo pipefail

# Params: [sudo] ./run.sh <username> <cores=4> <threads=2*cores> <dataset=1B> <runs=5>

if [ -z "$1" ]; then
    echo "Usage: $0 <username> <cores=4> <threads=2*cores> <dataset=1B> <runs=5>"
    exit 1
fi

username="$1"
input_file="./inputs/measurements.txt"
warmup=1
runs=5

if [ -n "$2" ]; then
    num_cores="$2"
else
    num_cores=4
fi

if [ -n "$3" ]; then
    num_threads="$3"
else
    num_threads=$((num_cores * 2))
fi

if [ "$num_threads" -ne "$num_cores" ] && [ "$num_threads" -ne $((num_cores * 2)) ]; then
    echo "Error: num_threads must be equal to num_cores or 2 times its size."
    exit 1
fi

if [ -z "$4" ]; then
    dataset="1B"
else
    dataset="$4"
fi

source use_input.sh $dataset

if [ -n "$5" ]; then
    runs="$5"
fi

dir="results/${dataset}"
mkdir -p $dir

filetimestamp=$(date  +"%Y%m%d%H%M%S") 
jsonfilename="./${dir}/${username}_${num_cores}_${num_threads}_${filetimestamp}.json"
jsonfilename=$(realpath "$jsonfilename")

if [ "$num_cores" -eq "$num_threads" ]; then
    cpus=""
    for (( i=0; i<num_cores*2; i+=2 )); do
        cpus+=",$i"
    done
    cpus="${cpus#,}"
else
    cpus="0-$((num_threads - 1))"
fi

echo "Using CPUs: $cpus"

if [ "$username" == "lehuyduc" ]; then
    rm -f ./bin/lehuyduc/aot/1brc
    # g++ -o ./bin/lehuyduc/aot/1brc ./src/lehuyduc/main.cpp -O3 -std=c++17 -march=native -m64 -lpthread -DN_THREADS_PARAM=$num_threads -DN_CORES_PARAM=$num_cores -g
    # echo "Built lehuyduc's repo with $num_cores cores and $num_threads threads"
    # TODO On HT cores set to threads count is significantly better.
    g++ -o ./bin/lehuyduc/aot/1brc ./src/lehuyduc/main.cpp -O3 -std=c++17 -march=native -m64 -lpthread -DN_THREADS_PARAM=$num_threads -DN_CORES_PARAM=$num_threads -g
    echo "Built lehuyduc's repo with $num_threads threads"
    numactl --physcpubind=$cpus hyperfine -w=$warmup -r=$runs --export-json $jsonfilename "./bin/lehuyduc/aot/1brc $input_file"
    rm -f result.txt
elif [ "$username" == "austindonisan" ]; then
    numactl --physcpubind=$cpus hyperfine -w=$warmup -r=$runs --export-json $jsonfilename "./bin/austindonisan/aot/1brc $input_file $num_threads 1"
else
    aot="./bin/$username/aot/1brc"
    # jit="./bin/$username/jit/1brc"
    java="./src/java/calculate_average_${username}.sh"
    echo $java
    if [ -f "$aot" ]; then
        numactl --physcpubind=$cpus hyperfine -w=$warmup -r=$runs --export-json $jsonfilename "$aot $input_file"
    elif [ -f "$java" ]; then
        (cd src/java && numactl --physcpubind=$cpus hyperfine -w=$warmup -r=$runs --export-json $jsonfilename "./calculate_average_${username}.sh")
    else
        echo "No suitable file found for $username. Exiting."
        exit 1
    fi
fi