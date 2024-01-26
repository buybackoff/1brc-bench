#!/bin/bash

rm -rf bin 
# On Windows they are not chmod u+x, quite annoying but just calling via bash is fine
bash build_java.sh
bash build_dotnet.sh
bash build_native.sh