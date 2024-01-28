#!/bin/bash

# Param: 1B for the default dataset, or 1B_10K for the 10K dataset. You may use any other _suffix, it will be symlinked and used by all built code.

# Check if the first parameter is given
if [ -n "$1" ]; then
    suffix="_${1}"
fi

destination="/dev/shm/measurements$suffix.txt"
local_file="inputs/measurements$suffix.txt"
compressed_file="inputs/measurements$suffix.txt.zst"
java_symlink="./src/java/measurements.txt"
inputs_symlink="./inputs/measurements.txt"

if [ -f "$destination" ]; then
    :
    # echo "File already exists in destination: $destination"
else
    # Check if the local file exists
    if [ -e "$local_file" ]; then
        cp "$local_file" "$destination"
        echo "Copied $local_file to $destination"
    elif [ -e "$compressed_file" ]; then
        # Decompress the compressed file directly to the destination
        zstd -T0 -d -o "$destination" "$compressed_file"
        echo "Decompressed $compressed_file to $destination"
    else
        echo "No suitable file found for copying ($local_file) or decompressing ($compressed_file). Generate a default dataset from ./src/java/create_measurements.sh 1000000000 and move this file to ./inputs dir. You may compress it with zstd to save local space. Or you may download buybackoff's compressed files."
        exit 1
    fi
fi

rm -f $java_symlink
rm -f $inputs_symlink

ln -s $destination $java_symlink
ln -s $destination $inputs_symlink