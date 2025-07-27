#!/usr/bin/env bash

set -euxo pipefail

git submodule update --init
export PREFIX="$(pwd)/artifacts/linux-aarch64"
docker run --rm \
       -e PREFIX="$PREFIX" \
       -v "$(pwd)":"$(pwd)" \
       -w "$(pwd)" \
       debian:11.0 \
       bash -c 'apt update && apt install -y build-essential && pushd argon2 && make clean && make && make install && strip "$PREFIX"/lib/libargon2.so.1'
