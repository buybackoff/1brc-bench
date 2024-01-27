#!/bin/bash

# Params: $0 <dataset> <max_cores=4> <runs=5>

if [ -z "$1" ]; then
    dataset="1B"
else
    dataset="$1"
fi

if [ -n "$2" ]; then
    max_cores="$2"
else
    max_cores=4
fi

if [ -n "$3" ]; then
    runs="$3"
else
    runs=5
fi

user_list=("buybackoff" "nietras" "noahfalk" "xoofx" "abeobk" "artsiomkorzun" "austindonisan" "lehuyduc") # TODO dzaima #17

counter=2
while [ "$counter" -le "$max_cores" ]; do
   
    for username in "${user_list[@]}"; do
        # Non hyper-threaded
        source run.sh $username $counter $counter $dataset $runs
        # Hyper-threaded
        source run.sh $username $counter $((counter * 2)) $dataset $runs
    done

    # Double the counter
    counter=$((counter * 2))
done

if [ "$counter" -gt "$max_cores" ]; then
    counter=$max_cores
    # Non hyper-threaded
    source run.sh $username $counter $counter $dataset $runs
    # Hyper-threaded
    source run.sh $username $counter $((counter * 2)) $dataset $runs
fi