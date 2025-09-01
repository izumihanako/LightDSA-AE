#!/bin/bash
# This script installs all the prerequisites for running the experiments in this repository.
set -e 

# Install idxd-config
sudo apt install build-essential -y
sudo apt install autoconf automake autotools-dev libtool pkgconf asciidoc xmlto -y
sudo apt install uuid-dev libjson-c-dev libkeyutils-dev libz-dev libssl-dev -y
sudo apt install debhelper devscripts debmake quilt fakeroot lintian asciidoctor -y
sudo apt install file gnupg patch patchutils -y

git clone git@github.com:intel/idxd-config.git
cd idxd-config
./autogen.sh
./configure CFLAGS='-g -O2' --prefix=/usr --sysconfdir=/etc \
    --libdir=/usr/lib64 --enable-test=yes --enable-asciidoctor
sudo make
# sudo make check # This sometimes fails, some bugs exist in the check scripts.
sudo make install

# Install python libraries
sudo apt install python3-pip -y
pip3 install matplotlib numpy pandas scipy
pip3 install brokenaxes datasets huggingface_hub matplotlib numpy pandas redis tqdm

# Install libnuma and libpmem
sudo apt install libnuma-dev libpmem-dev -y

# Install CMake
sudo apt install cmake -y