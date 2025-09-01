#!/bin/bash
set -e

ROOT_DIR=$(pwd)

# Reproduce the results in LightDSA
cd LightDSA/AE
./env_init.sh 
for i in 1 3 4 5 6 7 8 9 11 12
do
  (cd ./figure$i && ./runner.sh)
  cp ./figure$i/figure$i*.pdf "$ROOT_DIR"
done

# Reproduce the results in dsa_redis
cd ../../dsa_redis/AE
./env_init.sh
(cd ./figure13 && ./runner.sh)
cp ./figure13/figure13.pdf "$ROOT_DIR"