# Reproduce LightDSA Experiments

This folder contains the code and scripts for all experiments presented in our paper ***LightDSA: Enabling Efficient DSA Through Hardware-Aware Transparent Optimization***, submitted for the AE of the EuroSys '26 spring cycle.

For detailed information about LightDSA, refer to the [README.md](https://github.com/izumihanako/LightDSA/blob/master/README.md) in LightDSA repository.

## Must Read

We recommend running experiments one at a time to avoid resource contention and ensure accurate, reproducible results. Running multiple experiments in parallel can cause unpredictable results due to contention for DSA throughput and other shared resources. For best reproducibility, please run each experiment separately.

We provide a script named `check_if_running.sh` to check if there is any one else running the experiments:
If not running, it will output:
```bash
./check_if_running.sh
# ✓ No experiments from other users detected.
```
else it will output all the running process like:
```bash
./check_if_running.sh
# ⚠ Detected experiments running:
# USER       PID   ELAPSED CMD
# usertes+   90368       3 /bin/bash ./reproduce.sh
# usertes+   90370       3 /bin/bash ./reproduce.sh
```


## Common Concerns Before Getting Started

### Which experiments can I reproduce?

All the experiments in the paper can be reproduced:

- Reproduction scripts for Figures 1, 3–9, 11, and 12 are located in the `LightDSA/AE/figure*` directory.
- Reproduction script for Figure 13 is located in the `dsa_redis/AE/figure13` directory.
- Reproduction scripts for ATC structure exploration are located in the `LightDSA/AE/ATCexplore` directory.

Note: Some numbered figures are not based on experiments and do not have corresponding scripts.

### How much time will it take to reproduce all experiments?

We have optimized the experiment times to balance accuracy and duration. In favorable conditions, all experiments can be reproduced in 3 hours.

DSA performance is inherently unstable. when the bottleneck of a DSA operation is not bandwidth (i.e., far from 30GB/s), performance is affected by multiple factors and typically fluctuates within a range.
Some experiments therefore require multiple repetitions and result averaging to obtain representative data. To reduce artifact evaluation time, we have decreased the number of repetitions in the AE version code. While this may slightly reduce accuracy, the results are still sufficient to support the paper's conclusions. You can find the source code for all experiments in `LightDSA/expr/paper`. The variable named `REPEAT` in the code controls the number of repetitions.

## Dependencies

All hardware and software dependencies are pre-configured on the provided server. To reproduce the experiments on a custom machine, ensure the following requirements are met:

### Hardware Dependencies

- Intel Xeon CPU, 4th gen or higher (only these CPUs integrate the DSA accelerator).

### Software Dependencies

- Linux Kernel version ≥ 5.19 (Ubuntu 20.04.6 LTS with Linux 6.6.58 on the provided server)
- Python 3.10.12
  - Required Python libraries: brokenaxes, datasets, huggingface_hub, matplotlib, numpy, pandas, redis, tqdm
- `idxd-config` from [Intel repository](https://github.com/intel/idxd-config)

- libnuma, libpmem (available from package manager)

- CMake version ≥ 3.16 (CMake 3.16.3 on the provided server)
- Any C++ compiler supporting CXX14 (g++ 11.4.0 on the provided server)

To reproduce the experiments on a custom machine, if you are unsure whether all software dependencies (except the Linux kernel version) are satisfied, run the provided script to install them automatically:
```bash
./prerequisite.sh
```



## Running Experiments

There are two sub-directories: `LightDSA` and `dsa_redis`. The `LightDSA` directory contains all experiments except the final one (Figure 13). The `dsa_redis` directory contains experiment for Figure13.

We provide a one-click script to reproduce experiments and copy the generated figures to the root directory of this project. Just run:
```bash
./reproduce.sh
```

If you wish to run a specific experiment individually, or if you want to run the experiments of ATC structure exploration, please follow the instructions below.

### For Experiments in the `LightDSA` Directory:

First, build the LightDSA project (assuming you are in the LightDSA directory):

```bash
./build.sh
```

Then, for each experiment, enter the corresponding directory and run the script. All scripts are named `runner.sh`. For example, to reproduce the experiment for Figure 1 (assuming you're in the LightDSA directory):

```bash
cd AE/figure1 && ./runner.sh
```

After the script runs, you will see the message `Done!`, and you can find the generated `figure1.pdf` and `figure1.png` files in the directory.


### For Experiments in the `dsa_redis` Directory:

This experiment requires the Arxiv-Summarization dataset from Hugging Face and involves importing the data into Redis to create `.rdb` files before testing. Thus, the experiment consists of two scripts: one for downloading, converting, and importing the data into Redis, and another for running the experiment.

To run the experiment (assuming you're in the `dsa_redis` directory):

```bash
cd AE && ./env_init.sh      # prepare the dataset
cd figure13 && ./runner.sh  # run the experiment
```

Once the first script completes, it will output `Experiment environment initialized!`.

Once the second script completes, it will output `Done!`, and you'll find the generated `figure13.pdf` and `figure13.png` files in the directory.

### For ATC Structure Exploration Experiments
These experiments involve numerous trials and pattern analysis on the `perf` output. 
The full procedure is described in Appendix A of the paper. 
Since the experiments are not easy to visualize, we do not provide a script that goes through all steps. However, we do provide manually runnable scripts for Steps 1-5 to reproduce the experiments.


First, set up the environment (assuming you are in the project root directory):
```bash
cd LightDSA/AE/ATCexplore && ./env_init.sh 
```
In `LightDSA/AE/ATCexplore`, you will find scripts named `stepX.sh` (X = 1, 2, 3, 4, 5) corresponding to Steps 1–5 in Appendix A. Running a script with no arguments prints its usage. For example:
```bash
./step3.sh
# The output will be like:
# Usage: usage -k <times> -p <pages>
#   -k   Number of memmove submissions (k)
#   -p   Size of each memmove, in pages of 4KB (p)
# Use 2 descriptors with completion record located on different pages.
# Perform the same memmove "k" times; each memmove is "p" 4K pages long.
```

#### An Example of Reproducing Step 3
For example, to reproduce Step 3 with k=20 and p=5, run (assuming you are in the `ATCexplore` directory):
```bash
./step3.sh -k 20 -p 5
```

Inspect the last 6 lines of the output. The script extracts the `perf` metrics and prints the expected results. The experiment succeeds if they match. For the above execution command, the last 6 lines should be: 
```
Perf metrics:
Translation requests  : 220 , (100.00%)
Translation hits      : 0   , (100.00%)
---------- Expected Output ----------
Translation requests  : 220   (k+2kp)
Translation hits      : 0
```