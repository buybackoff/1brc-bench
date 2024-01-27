#!/bin/bash

git fetch origin
git reset --hard origin/main
git submodule update --init --recursive
git submodule foreach --recursive 'git reset --hard; git clean -dfx'
git submodule update --recursive --remote

chmod +x *.sh

source build.sh