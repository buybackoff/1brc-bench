# 1BRC reproducible benchmark

Works on Ubuntu 22.04, may work on Debian 12 with .NET install adjustments in prerequisites.sh (apt repo). 

1. Clone this repo.
2. Run `bash update.sh`. (not `./update.sh`). This checks out latest repositories and also makes all scripts executable.
3. Run `sudo ./prerequisites.sh`.
4. Run `sudo ./build.sh`.
5. Place `measurements_1B.txt` and `measurements_1B_10K.txt` input files in `./inputs`. You may use `zstd` and place compressed files here, e.g. `measurements_1B.txt.zst`. 
6. [Optional] Call `use_input.sh 1B` or `use_input.sh 1B_10K` to select a dataset. You may use your own suffix. This places the files in `tmpfs`, so you must have at least 30GB of RAM just for the files. For most implementations using `mmap` this is all that is needed, the apps itself use very little. Do not try to run this if you have less than 32GB. You will have to adjust the scripts to read files from a disk directly or run only the default dataset.
7. Run `sudo ./run.sh <username> <cores=4> <threads=2*cores> <dataset=1B> <runs=5>`, e.g. `bash run.sh buybackoff 6 12 1B_10K 5`.
8. Run `sudo ./run_ds.sh <dataset> <max_cores=4> <runs=5>` to run all users on a dataset.
9. Run `sudo ./run_all.sh <max_cores=4> <runs=5>` for a complete benchmark run.

Json output will be stored in `results` dir.

Sudo is required for `numactl`. But it could become messy if you use remote VSCode. Just do `sudo chown -R username ./*` if you want to edit a file but receive a permission error.

## Usage in Proxmox/LXC

There is no difference between bare metal and Proxmox container setup but only **if the container is privileged**. Otherwise `numactl` does not work.
