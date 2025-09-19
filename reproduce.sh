#!/bin/bash
set -e

ROOT_DIR=$(pwd)

# Reproduce the results in LightDSA
cd LightDSA
./build.sh
cd AE
for i in 1 3 4 5 6 7 8 9 12 13 15
do
  (cd ./figure$i && ./runner.sh)
  cp ./figure$i/figure$i*.pdf "$ROOT_DIR"
done

# Reproduce the results in dsa_redis
cd ../../dsa_redis/AE
./env_init.sh
( cd figure14 && sudo ./runner.sh )
cp ./figure14/figure14.pdf "$ROOT_DIR"