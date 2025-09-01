# Reproduce LightDSA Experiments

This folder contains the code and scripts for all experiments presented in our paper ***LightDSA: Enabling Efficient DSA Through Hardware-Aware Transparent Optimization***, submitted for the AE of the EuroSys '26 spring cycle.

Each experiment has a corresponding script (e.g., `LightDSA/AE/figure1/runner.sh`). These scripts cover the entire process, from compiling the project with specific configurations to running the experiment and generating the figures. After successfully running a script, the resulting figures will be saved in the corresponding directory (e.g., `LightDSA/AE/figure1/figure1.pdf`).

For detailed explanations of each experiment, refer to `LightDSA/README.md` and `dsa_redis/README.md`.



## Common Concerns Before Getting Started

### Which experiments can I reproduce?

All the experiments shown in the figures of the paper can be reproduced:

- Reproduction scripts for Figures 1, 3–9, 11, and 12 are located in the `LightDSA/AE/figure*` directory.
- Reproduction script for Figure 13 is located in the `dsa_redis/AE/figure13` directory.

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



## Running Experiments

There are two sub-directories: `LightDSA` and `dsa_redis`. The `LightDSA` directory contains all experiments except the final one (Figure 13). The `dsa_redis` directory contains experiment for Figure13.

### For Experiments in the `LightDSA` Directory:

First, run the scripts that build the LightDSA project (assuming you're in the LightDSA/AE directory):

```bash
./env_init.sh
```

Then, for each experiment, enter the corresponding directory and run the script. All scripts are named `runner.sh`. For example, to reproduce the experiment for Figure 1 (assuming you're in the LightDSA/AE directory):

```bash
cd figure1
./runner.sh
```

After the script runs, you will see the message `Done!`, and you can find the generated `figure1.pdf` and `figure1.png` files in the directory.


### For Experiments in the `dsa_redis` Directory:

This experiment requires the Arxiv-Summarization dataset from Hugging Face and involves importing the data into Redis to create `.rdb` files before testing. Thus, the experiment consists of two scripts: one for downloading, converting, and importing the data into Redis, and another for running the experiment.

To run the experiment (assuming you're in the `dsa_redis/AE` directory):

```bash
cd figure13
./env_init.sh # prepare the dataset
./runner.sh   # run the experiment
```

Once the first script completes, it will output `Experiment environment initialized!`.

Once the second script completes, it will output `Done!`, and you'll find the generated `figure13.pdf` and `figure13.png` files in the directory.

