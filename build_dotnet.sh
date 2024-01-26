#!/bin/bash

# buybackoff
rm -rf bin/buybackoff 
dotnet build -c Release ./src/buybackoff/1brc/1brc.csproj -o bin/buybackoff/jit
dotnet publish -r linux-x64 -f net8.0 -p:PublishAot=true  ./src/buybackoff/1brc/1brc.csproj -o bin/buybackoff/aot

# nietras
rm -rf bin/nietras 
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