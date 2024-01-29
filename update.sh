#!/bin/bash

git fetch origin
git reset --hard origin/main
git submodule update --init --recursive
git submodule foreach --recursive 'git fetch origin; git reset --hard origin/$(git rev-parse --abbrev-ref HEAD); git clean -dfx'
git submodule update --recursive --remote

sudo chmod +x *.sh

source build.sh