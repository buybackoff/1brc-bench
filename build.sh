#!/bin/bash

rm -rf bin 
# On Windows they are not chmod u+x, quite annoying but just calling via bash is fine
source build_java.sh
source build_dotnet.sh
source build_native.sh $1 $2