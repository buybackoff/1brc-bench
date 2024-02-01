#!/bin/bash

# buybackoff
rm -rf bin/buybackoff 
dotnet build -c Release ./src/buybackoff/1brc/1brc.csproj -o bin/buybackoff/jit
dotnet publish -r linux-x64 -f net8.0 -p:PublishAot=true  ./src/buybackoff/1brc/1brc.csproj -o bin/buybackoff/aot

# nietras
rm -rf bin/nietras 
prio_file_path="./src/nietras/src/Brc/Program.cs"
substring="ProcessPriorityClass"
sed -i "/$substring/ s/^/\/\/ /" "$prio_file_path"
mv ./src/nietras/src/Brc/Brc.csproj ./src/nietras/src/Brc/1brc.csproj
dotnet build -c Release ./src/nietras/src/Brc/1brc.csproj -o bin/nietras/jit
dotnet publish -r linux-x64 -f net8.0 -p:PublishAot=true ./src/nietras/src/Brc/1brc.csproj -o bin/nietras/aot

# noahfalk
rm -rf bin/noahfalk 
dotnet build -c Release ./src/noahfalk/1brc/1brc.csproj -o bin/noahfalk/jit
dotnet publish -r linux-x64 -f net8.0 -p:PublishAot=true  ./src/noahfalk/1brc/1brc.csproj -o bin/noahfalk/aot

# xoofx
rm -rf bin/xoofx
mv ./src/xoofx/Fast1BRC.csproj ./src/xoofx/1brc.csproj
dotnet build -c Release ./src/xoofx/1brc.csproj -o bin/xoofx/jit
dotnet publish -r linux-x64 -f net8.0 -p:PublishAot=true ./src/xoofx/1brc.csproj -o bin/xoofx/aot

# kpocza
rm -rf bin/kpocza 
dotnet build -c Release ./src/kpocza/1brc/1brc.csproj -o bin/kpocza/jit
dotnet publish -r linux-x64 -f net8.0 -p:PublishAot=true  ./src/kpocza/1brc/1brc.csproj -o bin/kpocza/aot

# pedrosakuma
rm -rf bin/pedrosakuma 
dotnet build -c Release ./src/pedrosakuma/1brc/1brc.csproj -o bin/pedrosakuma/jit
dotnet publish -r linux-x64 -f net8.0 -p:PublishAot=true  ./src/pedrosakuma/1brc/1brc.csproj -o bin/pedrosakuma/aot
