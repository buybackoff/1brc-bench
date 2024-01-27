# 1BRC reproducible benchmark

Works on Ubuntu 22.04, may work on Debian 12 with .NET install adjustments in prerequisites.sh (apt repo). 

1. Clone this repo.
2. Run `bash update.sh`. 
3. Run `./prerequisites.sh`.
4. Run `./build.sh`.
5. Place `measurements_1B.txt` and `measurements_1B_10K.txt` input files in `./inputs`. You may use `zstd` and place compressed files here, e.g. `measurements_1B.txt.zst`. 
6. Call `use_input.sh 1B` or `use_input.sh 1B_10K` to select a dataset. You may use your own suffix. This places the files in `tmpfs`, so you must have at least 30GB of RAM just for the files. For most implementations using `mmap` this is all that is needed, the apps itself use very little. Do not try to run this if you have less than 32GB. You will have to adjust the scripts to read files from a disk directly or run only the default dataset.
7. Run `[sudo] ./run.sh <username> <cores=4> <threads=2*cores> <dataset=1B> <runs=5>`, e.g. `sudo bash run.sh buybackoff 6 12 1B_10K 5`.


## Usage in Proxmox/LXC

There is no difference between bare metal and Proxmox container setup but only **if the container is privileged**. Otherwise `numactl` does not work.
