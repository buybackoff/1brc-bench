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
sudo apt install -y build-essential

# Java
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version
yes | sdk install java 21.0.2-open
yes | sdk install java 21.0.2-graal

# .NET
sudo apt install -y dotnet-sdk-8.0