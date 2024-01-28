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


if [ -n "$MACHINE_ID" ]; then
    machine_id="${MACHINE_ID}/"
else
    machine_id="manual/"
fi

dir="results/${machine_id}${dataset}"
mkdir -p $dir
filetimestamp=$(date  +"%Y%m%d%H%M%S") 
jsonfilename="./${dir}/${username}_${num_cores}_${num_threads}_${runs}_${filetimestamp}.json"
jsonfilename=$(realpath "$jsonfilename")

# Using lstopo, these are sequences of the HT cores. For non-HT we need to take only even indices
cores=($(lstopo | grep -oP '\(P#\d+\)' | awk -F'#' '{print $2}' | tr -d ')' | xargs))

if [ "$num_cores" -eq "$num_threads" ]; then
    result=()
    for ((i = 0; i < ${#cores[@]}; i += 2)); do
        result+=("${cores[i]}")
    done
    cpus=$(IFS=,; echo "${result[*]:0:num_cores}")
else
    cpus=$(IFS=,; echo "${cores[*]:0:num_threads}")
fi

# machine_num_cores=$(nproc --all)
# amd_cores=(0 64 1 65 2 66 3 67 4 68 5 69 6 70 7 71 8 72 9 73 10 74 11 75 12 76 13 77 14 78 15 79 16 80 17 81 18 82 19 83 20 84 21 85 22 86 23 87 24 88 25 89 26 90 27 91 28 92 29 93 30 94 31 95 32 96 33 97 34 98 35 99 36 100 37 101 38 102 39 103 40 104 41 105 42 106 43 107 44 108 45 109 46 110 47 111 48 112 49 113 50 114 51 115 52 116 53 117 54 118 55 119 56 120 57 121 58 122 59 123 60 124 61 125 62 126 63 127)
# intel_cores=(0 52 2 34 4 36 6 38 8 40 10 42 12 44 14 46 16 48 18 50 20 32 22 54 24 56 26 58 28 60 30 62 1 33 3 35 5 37 7 39 9 41 11 43 13 45 15 47 17 49 19 51 21 53 23 55 25 57 27 59 29 61 31 63)
# aws_cores=(0 48 1 49 2 50 3 51 4 52 5 53 6 54 7 55 8 56 9 57 10 58 11 59 12 60 13 61 14 62 15 63 16 64 17 65 18 66 19 67 20 68 21 69 22 70 23 71 24 72 25 73 26 74 27 75 28 76 29 77 30 78 31 79 32 80 33 81 34 82 35 83 36 84 37 85 38 86 39 87 40 88 41 89 42 90 43 91 44 92 45 93 46 94 47 95)
# # Poor man's way to detect a machine
# if [ "$machine_num_cores" -eq 128 ]; then
#     cores=("${amd_cores[@]}")
#     if [ "$num_cores" -eq "$num_threads" ]; then
#         result=()
#         for ((i = 0; i < ${#cores[@]}; i += 2)); do
#             result+=("${cores[i]}")
#         done
#         cpus=$(IFS=,; echo "${result[*]:0:num_cores}")
#     else
#         cpus=$(IFS=,; echo "${cores[*]:0:num_threads}")
#     fi
# elif [ "$machine_num_cores" -eq 64 ]; then
#     cores=("${intel_cores[@]}")
#     if [ "$num_cores" -eq "$num_threads" ]; then
#         result=()
#         for ((i = 0; i < ${#cores[@]}; i += 2)); do
#             result+=("${cores[i]}")
#         done
#         cpus=$(IFS=,; echo "${result[*]:0:num_cores}")
#     else
#         cpus=$(IFS=,; echo "${cores[*]:0:num_threads}")
#     fi
# elif [ "$machine_num_cores" -eq 96 ]; then
#     cores=("${aws_cores[@]}")
#     if [ "$num_cores" -eq "$num_threads" ]; then
#         result=()
#         for ((i = 0; i < ${#cores[@]}; i += 2)); do
#             result+=("${cores[i]}")
#         done
#         cpus=$(IFS=,; echo "${result[*]:0:num_cores}")
#     else
#         cpus=$(IFS=,; echo "${cores[*]:0:num_threads}")
#     fi
# else
#     if [ "$num_cores" -eq "$num_threads" ]; then
#         cpus=""
#         for (( i=0; i<num_cores*2; i+=2 )); do
#             cpus+=",$i"
#         done
#         cpus="${cpus#,}"
#     else
#         cpus="0-$((num_threads - 1))"
#     fi
# fi

echo "Using CPUs (${num_cores}C ${num_threads}T): $cpus"

if [ "$username" == "lehuyduc" ]; then
    rm -f ./bin/lehuyduc/aot/1brc
    # g++ -o ./bin/lehuyduc/aot/1brc ./src/lehuyduc/main.cpp -O3 -std=c++17 -march=native -m64 -lpthread -DN_THREADS_PARAM=$num_threads -DN_CORES_PARAM=$num_cores -g
    # echo "Built lehuyduc's repo with $num_cores cores and $num_threads threads"
    # TODO On HT cores set to threads count is significantly better.
    g++ -o ./bin/lehuyduc/aot/1brc ./src/lehuyduc/main.cpp -O3 -std=c++17 -march=native -m64 -lpthread -DN_THREADS_PARAM=$num_threads -DN_CORES_PARAM=$num_threads -g
    echo "Built lehuyduc's repo with $num_threads threads"
    numactl --all --physcpubind=$cpus hyperfine -w=$warmup -r=$runs --export-json $jsonfilename "./bin/lehuyduc/aot/1brc $input_file"
    rm -f result.txt
elif [ "$username" == "austindonisan" ]; then
    numactl --all --physcpubind=$cpus hyperfine -w=$warmup -r=$runs --export-json $jsonfilename "./bin/austindonisan/aot/1brc $input_file $num_threads 1"
elif [ "$username" == "dzaima" ]; then
    THREADS_1BRC=$num_threads \
    numactl --all --physcpubind=$cpus hyperfine -w=$warmup -r=$runs --export-json $jsonfilename "./bin/dzaima/aot/1brc $input_file"
else
    aot="./bin/$username/aot/1brc"
    # jit="./bin/$username/jit/1brc"
    java="./src/java/calculate_average_${username}.sh"
    
    if [ -f "$aot" ]; then
        numactl --all --physcpubind=$cpus hyperfine -w=$warmup -r=$runs --export-json $jsonfilename "$aot $input_file"
    elif [ -f "$java" ]; then
        (cd src/java && numactl --all --physcpubind=$cpus hyperfine -w=$warmup -r=$runs --export-json $jsonfilename "./calculate_average_${username}.sh")
    else
        echo "No suitable file found for $username. Exiting."
        exit 1
    fi
fi

