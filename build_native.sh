#!/bin/bash

# Optional params: cores [threads=cores]

# Check if an input parameter is provided
if [ -n "$1" ]; then
    # Use the provided input parameter as the number of physical cores
    num_cores="$1"
else
    num_cores=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
fi

if [ -n "$2" ]; then
    # Use the provided input parameter as the number of threads
    num_threads="$2"
else
    # Use nproc to get the number of CPU threads
    num_threads=$(nproc --all)
fi


# lehuyduc
rm -rf bin/lehuyduc
mkdir -p bin/lehuyduc/aot
g++ -o ./bin/lehuyduc/aot/1brc ./src/lehuyduc/main.cpp -O3 -std=c++17 -march=native -m64 -lpthread -DN_THREADS_PARAM=$num_threads -DN_CORES_PARAM=$num_cores -g
echo "Built lehuyduc's repo with $num_cores cores and $num_threads threads"

# austindonisan
# Note that it uses clang-17, and the default gcc is indeed significantly slower (740ms vs 850 ms), but it does not change the big picture. For 10K the difference is invisible.
rm -rf bin/austindonisan
mkdir -p bin/austindonisan/aot
gcc -o ./bin/austindonisan/aot/1brc ./src/austindonisan/1brc.c -Wall -Werror -Wno-unused-parameter -std=c17 -march=native -mtune=native -Ofast
echo "Built austindonisan's repo"