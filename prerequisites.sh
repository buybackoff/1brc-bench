#!/bin/bash

sudo apt update
sudo apt upgrade -y

# Basics
sudo apt install -y git
sudo apt install -y curl 
sudo apt install -y zip
sudo apt install -y unzip
sudo apt install -y zlib1g
sudo apt install -y zlib1g-dev
sudo apt install -y zstd
sudo apt install -y hyperfine
sudo apt install -y numactl
sudo apt install -y hwloc
sudo apt install -y build-essential

# Java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version
yes | sdk install java 21.0.2-open
yes | sdk install java 21.0.2-graal
sudo apt install -y maven

# .NET
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install -y dotnet-sdk-8.0